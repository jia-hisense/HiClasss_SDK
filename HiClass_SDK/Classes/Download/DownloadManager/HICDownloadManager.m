//
//  HICDownloadManager.m
//  HiClass
//
//  Created by Eddie_Ma on 15/2/20.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICDownloadManager.h"
#import "HICM3U8SegmentModel.h"
#import "HICM3U8PlayListModel.h"

static NSString *logName = @"[HIC][DM]";

@interface HICDownloadManager()<NSURLSessionDownloadDelegate, HICM3U8ManagerDelegate, NSURLSessionTaskDelegate>
// session
@property (nonatomic, strong) NSURLSession* session;
@property (nonatomic, strong) NSMutableDictionary* resumeDataDic;
@property (nonatomic, strong) NSMutableDictionary* m3u8ProcessDic;
@property (nonatomic, strong) NSMutableArray* taskArr;
@property (nonatomic, strong) NSString* m3u8IndexName;
@property (nonatomic, strong) NSArray *downloadMedias;
@property (nonatomic, assign) BOOL m3u8Stopped;
@end

@implementation HICDownloadManager

- (NSURLSession *)session {
    if (!_session) {
        NSURLSessionConfiguration *cfg = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"BackgroundDownloadIdentifier"];
        //默认单线程执行大文件下载
//        NSOperationQueue *queue = [NSOperationQueue mainQueue];
//        queue.maxConcurrentOperationCount = 3;//这里可以设置它的最大并发数
        self.session = [NSURLSession sessionWithConfiguration:cfg delegate:self delegateQueue:[NSOperationQueue mainQueue]]; //[NSOperationQueue mainQueue]
    }
    return _session;
}

- (NSMutableArray *)taskArr {
    if (!_taskArr) {
        _taskArr = [[NSMutableArray alloc] init];
    }
    return _taskArr;
}

- (NSMutableDictionary *)resumeDataDic {
    if (!_resumeDataDic) {
        _resumeDataDic = [[NSMutableDictionary alloc] init];
    }
    return _resumeDataDic;
}

- (NSMutableDictionary *)m3u8ProcessDic {
    if (!_m3u8ProcessDic) {
        _m3u8ProcessDic = [[NSMutableDictionary alloc] init];
    }
    return _m3u8ProcessDic;
}

+ (instancetype)shared {
    static HICDownloadManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

// 从0开始下载（除m3u8）
- (void)startDownloadWith:(NSArray *)arr {
    if (arr.count == 0) {
        if (self.downloadMediaArr.count == 0) {
            DDLogDebug(@"%@ NO media to download",logName);
            return;
        }
    } else {
        _downloadMediaArr = arr;
    }
    M3U8Manager.delegate = self;
    for (HICKnowledgeDownloadModel *kModel in _downloadMediaArr) {
        kModel.mediaStatus = HICDownloading;
        DDLogDebug(@"%@ Media ID: %@, Media URL: %@",logName, kModel.mediaId, kModel.mediaURL);
        if ([NSString isM3U8URL:kModel.mediaURL]) {
            // 如果是m3u8的index文件
            M3U8Manager.mediaId = kModel.mediaId;
            [M3U8Manager praseUrl:kModel.mediaURL];
        } else {
            NSString *taskDesc = [NSString stringWithFormat:@"%@",kModel.mediaId];
            [self downloadProcessWithDesc:taskDesc url:kModel.mediaURL];
            [self uploadDownloadRecordWithModel:kModel];
            dispatch_async([DBManager database_queue], ^{
                [DBManager insertToDownloadMediaTable:kModel];
            });
        }
    }
}

// 从0开始下载m3u8文件
- (void)startDownloadWithM3U8Segments:(NSArray *)m3u8Segments m3u8IndexUrl:(NSString *)m3u8IndexUrl {
    HICKnowledgeDownloadModel *kModel = [self getDownloadModel:M3U8Manager.mediaId];
    [self uploadDownloadRecordWithModel:kModel];
    // 1. 先下载索引文件
    [self downloadProcessWithDesc:[NSString stringWithFormat:@"m3u8_%@_-1_%ld", M3U8Manager.mediaId, (long)m3u8Segments.count + 1] url:m3u8IndexUrl];
    dispatch_async([DBManager database_queue], ^{
        if (kModel) {
            [DBManager insertToDownloadMediaTable:kModel];
        } else {
            DDLogDebug(@"%@ Can NOT get Model when Download start", logName);
        }
    });

    // 2. 下载索引下面的所有.ts文件
    for (int i = 0; i < m3u8Segments.count; i++) {
        if (self.m3u8Stopped) {
            [_taskArr removeAllObjects];
            break;
        }
        HICM3U8SegmentModel *sModel = m3u8Segments[i];
        // +1是为了加上m3u8的index文件
        [self downloadProcessWithDesc:[NSString stringWithFormat:@"m3u8_%@_%d_%ld", M3U8Manager.mediaId, i, (long)m3u8Segments.count + 1] url:sModel.downloadURL];
    }
}
- (void)uploadDownloadRecordWithModel:(HICKnowledgeDownloadModel *)model{
    [HICAPI uploadDownloadRecordWithModel:model];
    
}
// 恢复下载
- (void)resumeWith:(NSNumber *)mediaId {
    NSMutableArray *temTaskArr = [[NSMutableArray alloc] initWithArray:_taskArr];
    if (temTaskArr.count > 0) {
        for (__strong NSURLSessionDownloadTask* downloadTask in temTaskArr) {
               NSString *mediaIdStr = downloadTask.taskDescription;
               NSNumber *mId;
               if ([self isM3U8Media:mediaIdStr]) { // 如果是m3u8
                   NSArray *m3u8Arr = [mediaIdStr componentsSeparatedByString:@"_"];
                   mId = [m3u8Arr[1] toNumber];
               } else {
                   mId = [mediaIdStr toNumber];
               }
               if ([mId isEqual:mediaId]) {
                   [_taskArr removeObject:downloadTask];
                   downloadTask = nil;
                   [self updateEachMediaDownloadStatus:mediaId status:HICDownloadResume];
                   NSData *resumeData = (NSData *)[_resumeDataDic valueForKey:mediaIdStr];
                   if (resumeData) {
                       // 传入上次暂停下载返回的数据，就可以恢复下载
                       downloadTask = [self.session downloadTaskWithResumeData:resumeData];
                       [_taskArr addObject:downloadTask];
                       [downloadTask setTaskDescription:mediaIdStr];
                       // 开始任务
                       [downloadTask resume];
                       [_resumeDataDic removeObjectForKey:mediaIdStr];
                       dispatch_async([DBManager database_queue], ^{
                           HICKnowledgeDownloadModel *kModel = [self getDownloadModel:mediaId];
                           if (kModel) {
                               kModel.mediaStatus = HICDownloadResume;
                               [DBManager updateDownloadMediaWithResume:kModel];
                           } else {
                               DDLogDebug(@"%@ Can NOT get Model when Download paused", logName);
                           }
                       });
                   } else {
                       DDLogDebug(@"%@ Resume Data is NOT valid", logName);
                   }
               }
           }
    } else {
        // 查看数据库中该条媒资的Resume data
        dispatch_async([DBManager database_queue], ^{
            NSArray *kModelArr = [DBManager selectMediasByMediaId:mediaId isCourseId:NO];
            for (HICKnowledgeDownloadModel *kModel in kModelArr) {
                if (kModel) {
                    if ([self isM3U8Media:kModel.mediaURL]) {
                        dispatch_async([DBManager database_queue], ^{
                            kModel.mediaStatus = HICDownloadResume;
                            [DBManager updateDownloadMediaWithResume:kModel];
                        });
                        NSMutableArray *arr = [[NSMutableArray alloc] init];
                        [arr addObject:kModel];
                        self.m3u8Stopped = NO;
                        [self startDownloadWith:arr];
                    } else {
                        NSData *data = [self decodeStringToBinaryData:kModel.mediaStopPoint];
                        if (data) {
                            NSString *mediaIdStr = [NSString stringWithFormat:@"%@", mediaId];
                            // 传入上次暂停下载返回的数据，就可以恢复下载
                            NSURLSessionDownloadTask *downloadTask = [self.session downloadTaskWithResumeData:data];
                            [_taskArr addObject:downloadTask];
                            [downloadTask setTaskDescription:mediaIdStr];
                            // 开始任务
                            [downloadTask resume];
                            //                    NSMutableArray *temArr = [[NSMutableArray alloc] init];
                            //                    [temArr addObject:kModel];
                            //                    self.downloadMediaArr = temArr;
                            [self->_resumeDataDic removeObjectForKey:mediaIdStr];
                            dispatch_async([DBManager database_queue], ^{
                                kModel.mediaStatus = HICDownloadResume;
                                [DBManager updateDownloadMediaWithResume:kModel];
                            });
                        } else {
                            DDLogDebug(@"%@ Resume Data is NOT valid from DB", logName);
                        }
                    }
                } else {
                    DDLogDebug(@"%@ Can NOT get Model when Download paused", logName);
                }
            }
        });
    }
}

// 暂停
- (void)pauseWith:(NSNumber *)mediaId {
    self.m3u8Stopped = YES;
    __weak typeof(self) weakSelf = self;
    NSMutableArray *temTaskArr = [[NSMutableArray alloc] initWithArray:_taskArr];
    for (__strong NSURLSessionDownloadTask* downloadTask in temTaskArr) {
        NSString *mediaIdStr = downloadTask.taskDescription;
        NSNumber *mId;
        if ([self isM3U8Media:mediaIdStr]) {
            NSArray *m3u8Arr = [mediaIdStr componentsSeparatedByString:@"_"];
            mId = [m3u8Arr[1] toNumber];
            [downloadTask cancel];
            [self.taskArr removeObject:downloadTask];
            [self.m3u8ProcessDic removeObjectForKey:mediaIdStr];
            dispatch_async([DBManager database_queue], ^{
                HICKnowledgeDownloadModel *kModel = [weakSelf getDownloadModel:mediaId];
                if (kModel) {
                    kModel.mediaStopPoint = [NSString stringWithFormat:@"%@", kModel.mediaDownloadSize];
                    kModel.mediaStatus = HICDownloadStop;
                    [DBManager updateDownloadMediaWithStop:kModel];
                } else {
                    DDLogDebug(@"%@ Can NOT get Model when Download paused", logName);
                }
            });
        } else {
            mId = [mediaIdStr toNumber];
            if ([mId isEqual:mediaId]) {
                // resumeData:包含了继续下载的开始位置&下载的url
                [downloadTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
                    if (!resumeData) {
                        HICKnowledgeDownloadModel *kModel = [weakSelf getDownloadModel:mediaId];
                        DDLogDebug(@"%@ Download paused, but resumeData is nil, media download size: %@", logName, kModel.mediaDownloadSize);
                    }
                    [self updateEachMediaDownloadStatus:mediaId status:HICDownloadStop];
                    [weakSelf.resumeDataDic setValue:resumeData forKey:downloadTask.taskDescription];
                    dispatch_async([DBManager database_queue], ^{
                        HICKnowledgeDownloadModel *kModel = [weakSelf getDownloadModel:mediaId];
                        if (kModel) {
                            kModel.mediaStopPoint = [weakSelf encodeBinaryDataToString:resumeData];
                            kModel.mediaStatus = HICDownloadStop;
                            [DBManager updateDownloadMediaWithStop:kModel];
                        } else {
                            DDLogDebug(@"%@ Can NOT get Model when Download paused", logName);
                        }
                    });
                }];
            }
        }
    }
    DDLogDebug(@"asdasdasd count: %lu", (unsigned long)_taskArr.count);
}

// 取消下载
- (void)cancelWith:(NSNumber *)mediaId {
    // 1. 从taskArr中找到对应的task后删除
    NSMutableArray *temArr = [[NSMutableArray alloc] initWithArray:_taskArr];
    for (__strong NSURLSessionDownloadTask* downloadTask in _taskArr) {
        NSString *mediaIdStr = downloadTask.taskDescription;
        NSNumber *mId;
        if ([self isM3U8Media:mediaIdStr]) {
            NSArray *m3u8Arr = [mediaIdStr componentsSeparatedByString:@"_"];
            mId = [m3u8Arr[1] toNumber];
        } else {
            mId = [mediaIdStr toNumber];
        }
        if ([mId isEqual:mediaId]) {
            // 取消下载
            [downloadTask cancel];
            // 移除task
            [temArr removeObject:downloadTask];
        }
    }
    _taskArr = temArr;

    // 2. 删除downloadMediaArr中存储的相应媒资
    NSMutableArray *temDownloadMediaArr = [[NSMutableArray alloc] initWithArray:self.downloadMediaArr];
    for (HICKnowledgeDownloadModel *temKModel in self.downloadMediaArr) {
        if ([temKModel.mediaId isEqual:mediaId]) {
            [temDownloadMediaArr removeObject:temKModel];
        }
    }
    self.downloadMediaArr = temDownloadMediaArr;
    _session = nil;
}

/// 更新每个媒资下载时的状态
/// @param mediaId 媒资id
/// @param status 下载状态
- (void)updateEachMediaDownloadStatus:(NSNumber *)mediaId status:(HICDownloadStatus)status {
    for (HICKnowledgeDownloadModel *kModel in _downloadMediaArr) {
        if ([mediaId isEqual:kModel.mediaId]) {
            kModel.mediaStatus = status;
        }
    }
}

- (HICKnowledgeDownloadModel *)getDownloadModel:(NSNumber *)mediaId {
    HICKnowledgeDownloadModel *model = nil;
    if (_downloadMediaArr.count > 0) {
        for (HICKnowledgeDownloadModel *kModel in _downloadMediaArr) {
               if ([mediaId isEqual:kModel.mediaId]) {
                   model = kModel;
                   break;
               }
           }
    } else {
        NSArray *kModelArr = [DBManager selectMediasByMediaId:mediaId isCourseId:NO];
        for (HICKnowledgeDownloadModel *kModel in kModelArr) {
            if (kModel && [kModel.mediaId isEqual:mediaId]) {
                model = kModel;
            }
        }
    }
    return model;
}

- (BOOL)isM3U8Media:(NSString *)mediaIdStr {
    if ([mediaIdStr containsString:@"m3u8"]) {
        return YES;
    }
    return NO;
}

- (void)downloadProcessWithDesc:(NSString *)desc url:(NSString *)strUrl{
    NSArray *arrURL = [strUrl componentsSeparatedByString:@","];
    for (int i = 0; i < arrURL.count; i++) {
        NSURL* url = [NSURL URLWithString:arrURL[i]];
        // 创建任务
        NSURLSessionDownloadTask *downloadTask = [self.session downloadTaskWithURL:url];
        // 将每个task放入task数组
        [self.taskArr addObject:downloadTask];
        // Task Description存放媒资id，标识每个task属于哪个媒资
        // m3u8: 使用m3u8_mediaId_第几个_总数
        // 其他: 使用媒资id（mediaId）
        [downloadTask setTaskDescription:desc];
        // 开始任务
        [downloadTask resume];
    }
}

- (NSString *)encodeBinaryDataToString:(NSData *)data {
    NSString *resumeDataStr = @"";
    if (data) {
        resumeDataStr = [data base64EncodedStringWithOptions:0];
    }
    return resumeDataStr;
}

- (NSData *)decodeStringToBinaryData:(NSString *)str {
    NSData *data = nil;
    if ([NSString isValidStr:str]) {
        data = [[NSData alloc]initWithBase64EncodedString:str options:0];
    }
    return data;
}

#pragma mark - - - NSURLSessionDownloadDelegate - - - start
/// 下载完毕会调用
/// @param session session
/// @param downloadTask downloadTask
/// @param location 文件临时地址
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location {
    NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    // response.suggestedFilename ： 建议使用的文件名，一般跟服务器端的文件名一致 [NSString stringWithFormat:@"%@/%@", M3U8Manager.mediaId, downloadTask.response.suggestedFilename]
    NSString *fileName = downloadTask.response.suggestedFilename;

    // 将临时文件剪切或者复制Caches文件夹
    NSFileManager *mgr = [NSFileManager defaultManager];

    if ([self isM3U8Media:downloadTask.taskDescription]) {
        NSArray *mediaIdArr = [downloadTask.taskDescription componentsSeparatedByString:@"_"];
        caches = [NSString stringWithFormat:@"%@/HIC_Media_%@",caches,mediaIdArr[1]];
        // 创建文件夹
        if (![mgr fileExistsAtPath:caches]) {
            [mgr createDirectoryAtPath:caches withIntermediateDirectories:YES attributes:nil error:nil];
        }
        if ([mediaIdArr[2] isEqual: @"-1"]) { // 找到m3u8的index文件
             _m3u8IndexName = [NSString stringWithFormat:@"%@/%@", caches, fileName];
        }
    } else {
        NSString *mediaIdStr = downloadTask.taskDescription;
        NSNumber *mediaId = [mediaIdStr toNumber];
        HICKnowledgeDownloadModel *kModel = [self getDownloadModel:mediaId];
        if ([kModel.mediaType integerValue] == HICPictureType || [kModel.mediaType integerValue] == HICFileType) {
            caches = [NSString stringWithFormat:@"%@/HIC_pics_%@", caches, kModel.mediaId];
            // 创建文件夹
            if (![mgr fileExistsAtPath:caches]) {
                [mgr createDirectoryAtPath:caches withIntermediateDirectories:YES attributes:nil error:nil];
            }
        }
    }

    NSString *file = [caches stringByAppendingPathComponent:fileName];

    // AtPath : 剪切前的文件路径
    // ToPath : 剪切后的文件路径
    [mgr moveItemAtPath:location.path toPath:file error:nil];

    dispatch_async([DBManager database_queue], ^{
        if ([self isM3U8Media:downloadTask.taskDescription]) {
            NSArray *mediaIdArr = [downloadTask.taskDescription componentsSeparatedByString:@"_"];
            NSNumber *mId = [mediaIdArr[1] toNumber];
            HICKnowledgeDownloadModel *kModel = [self getDownloadModel:mId];
            if (kModel) {
                if ([kModel.mediaDownloadSize longLongValue] >= [kModel.mediaSize longLongValue]) {
                    NSArray *temArr = [self.m3u8IndexName componentsSeparatedByString:@"/"];
                    NSString *lastTwoStr = temArr[temArr.count - 2];
                    NSString *absolutePath = temArr.lastObject;
                    if ([lastTwoStr isEqualToString:[NSString stringWithFormat:@"HIC_Media_%@", mId]]) {
                        absolutePath = [NSString stringWithFormat:@"%@/%@", temArr[temArr.count - 2], temArr.lastObject];
                    }
                    kModel.mediaPath = absolutePath;
                    kModel.mediaStatus = HICDownloadFinish;
                    [DBManager updateDownloadMediaWithFinish:kModel];
                }
            } else {
                DDLogDebug(@"%@ Can NOT get Model when Download finished", logName);
            }
        } else {
            NSString *mediaIdStr = downloadTask.taskDescription;
            NSNumber *mediaId = [mediaIdStr toNumber];
            HICKnowledgeDownloadModel *kModel = [self getDownloadModel:mediaId];
            if (kModel) {
                NSArray *temArr = [file componentsSeparatedByString:@"/"];
                NSString *lastTwoStr = temArr[temArr.count - 2];
                NSString *absolutePath = temArr.lastObject;
                if ([lastTwoStr isEqualToString:[NSString stringWithFormat:@"HIC_pics_%@", mediaId]]) {
                    absolutePath = [NSString stringWithFormat:@"%@/%@", temArr[temArr.count - 2], temArr.lastObject];
                }
                kModel.mediaPath = [NSString isValidStr:kModel.mediaPath] ? [NSString stringWithFormat:@"%@,%@", kModel.mediaPath, absolutePath] : absolutePath;
                kModel.mediaStatus = HICDownloadFinish;
                [DBManager updateDownloadMediaWithFinish:kModel];
            } else {
                DDLogDebug(@"%@ Can NOT get Model when Download finished", logName);
            }
        }
    });

    DDLogDebug(@"%@ mediaId:%@ downloaded SUCCESSFULLY and file stored in: %@", logName, downloadTask.taskDescription, file);

}

/// 每次写入沙盒完毕调用,在这里面监听下载进度，totalBytesWritten/totalBytesExpectedToWrite
/// @param session session
/// @param downloadTask downloadTask
/// @param bytesWritten 这次写入的大小
/// @param totalBytesWritten 已经写入沙盒的大小
/// @param totalBytesExpectedToWrite 文件总大小
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
                                           didWriteData:(int64_t)bytesWritten
                                      totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    if (![_taskArr containsObject:downloadTask]) {
        DDLogDebug(@"%@ Download task has been cancelled", logName);
        return;
    }
    NSString *mediaIdStr = downloadTask.taskDescription;
    DDLogDebug(@"%@ Download process has written: %lld, total writtern: %lld percent: %f with mediaId: %@", logName, totalBytesWritten, totalBytesExpectedToWrite, (double)totalBytesWritten/totalBytesExpectedToWrite, mediaIdStr);
    if ([self.delegate respondsToSelector:@selector(downloadProcess:kModel:)]) {
        CGFloat percent = (double)totalBytesWritten / totalBytesExpectedToWrite;
        if ([self isM3U8Media:mediaIdStr]) {
            NSArray *m3u8Arr = [mediaIdStr componentsSeparatedByString:@"_"];
            NSString *mIdStr = m3u8Arr[1];

            for (HICKnowledgeDownloadModel *kModel in _downloadMediaArr) {
                if ([kModel.mediaId isEqual:[mIdStr toNumber]]) {
                    // 将一个m3u8中某一个.ts文件下载的进度记录下来: 已下载大小_一共大小
                    [self.m3u8ProcessDic setValue:[NSString stringWithFormat:@"%lld_%lld",totalBytesWritten, totalBytesExpectedToWrite] forKey:mediaIdStr];
                    // 在记录了所有.ts文件的数组中，找到属于某个m3u8的整体下载情况
                    int64_t curTotalBytesWritten = 0;
                    int64_t curTotalBytesExpectedToWrite = 0;
                    // 是否一个m3u8的所有.ts文件都已经开始下载
                    NSArray *keys = [_m3u8ProcessDic allKeys];
                    for (int i = 0; i < keys.count; i++) {
//                        NSArray *valueInKey = [keys[i] componentsSeparatedByString:@"_"];
//                        if ([mIdStr isEqualToString:valueInKey[1]]) {
                            NSString *process = [_m3u8ProcessDic valueForKey:keys[i]];
                            NSArray *processArr = [process componentsSeparatedByString:@"_"];
                            int64_t currentWritten = [processArr[0] longLongValue];
                            int64_t totalWritten = [processArr[1] longLongValue];
                            curTotalBytesWritten = curTotalBytesWritten + currentWritten;
                            curTotalBytesExpectedToWrite = curTotalBytesExpectedToWrite + totalWritten;
//                        }
                    }
                    DDLogDebug(@"downloaded: %lld, total: %@ expected total: %lld", curTotalBytesWritten, kModel.mediaSize, curTotalBytesExpectedToWrite);
                    percent = (double)curTotalBytesWritten / [kModel.mediaSize longLongValue];
                    if ([NSString isValidStr:kModel.mediaStopPoint] && [kModel.mediaStopPoint longLongValue] > curTotalBytesWritten) {
//                        DDLogDebug(@"czxcasdas: %lld, asdasd: %lld", [kModel.mediaDownloadSize longLongValue], [kModel.mediaSize longLongValue]);
                        percent = (double)[kModel.mediaStopPoint longLongValue]/[kModel.mediaSize longLongValue];
                    }
                    // 保留小数点后六位
                    NSString *percentStr = [NSString stringWithFormat:@"%.6f", percent];
                    if ([percentStr floatValue] >= 1.0) {
                        [_m3u8ProcessDic removeObjectForKey:mediaIdStr];
                        [self updateEachMediaDownloadStatus:[mIdStr toNumber] status:HICDownloadFinish];
                    }
                    for (HICKnowledgeDownloadModel *kModel in _downloadMediaArr) {
                        if ([kModel.mediaId isEqual:[mIdStr toNumber]]) {
                            [self.delegate downloadProcess:percent kModel:kModel];
                        }
                    }
                    dispatch_async([DBManager database_queue], ^{
                        kModel.mediaDownloadSize = [NSNumber numberWithLongLong:curTotalBytesWritten];
                        [DBManager updateDownloadMediaWithDownloading:kModel];
                    });
                }
            }
        } else {
            // 保留小数点后六位
            NSString *percentStr = [NSString stringWithFormat:@"%.6f", percent];
            if ([percentStr floatValue] >= 1.0) {
                [self updateEachMediaDownloadStatus:[mediaIdStr toNumber] status:HICDownloadFinish];
            }
            if (_downloadMediaArr.count > 0) { // 从下载后App一直没有被kill
                for (HICKnowledgeDownloadModel *kModel in _downloadMediaArr) {
                    if ([kModel.mediaId isEqual:[mediaIdStr toNumber]]) {
                        [self.delegate downloadProcess:percent kModel:kModel];
                        dispatch_async([DBManager database_queue], ^{
                            kModel.mediaDownloadSize = [NSNumber numberWithLongLong:totalBytesWritten];
                            kModel.mediaSize = [NSNumber numberWithLongLong:totalBytesExpectedToWrite];
                            [DBManager updateDownloadMediaWithDownloading:kModel];
                        });
                    }
                }
            } else { //App被kill后从数据库找下载媒资继续下载等操作
                NSArray *kModelArr = [DBManager selectMediasByMediaId:[mediaIdStr toNumber] isCourseId:NO];
                for (HICKnowledgeDownloadModel *kModel in kModelArr) {
                    if (kModel) {
                        if ([percentStr floatValue] == 1.0) {
                            kModel.mediaStatus = HICDownloadFinish;
                        }
                        [self.delegate downloadProcess:percent kModel:kModel];
                        dispatch_async([DBManager database_queue], ^{
                            kModel.mediaDownloadSize = [NSNumber numberWithLongLong:totalBytesWritten];
                            kModel.mediaSize = [NSNumber numberWithLongLong:totalBytesExpectedToWrite];
                            [DBManager updateDownloadMediaWithDownloading:kModel];
                        });
                    } else {
                        DDLogDebug(@"%@ NO model in DB", logName);
                    }
                }
            }
        }
    }
}

/// 恢复下载后调用
/// @param session session
/// @param downloadTask downloadTask
/// @param fileOffset fileOffset
/// @param expectedTotalBytes expectedTotalBytes
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes {

}

#pragma mark - - - NSURLSessionDownloadDelegate - - - end

#pragma mark - - - NSURLSessionTaskDelegate - - - start

/// 每次任务结束后调用，结束并不代表它下载完了，有以下几种情况
/// 1、没错误
/// 2、用户取消下载
/// 3、进程在后台被杀死了
/// 4、其他错误
/// @param session 当前的session会话
/// @param task 当前的下载任务NSURLSessionTask，NSURLSessionDownloadTask继承它
/// @param error 错误信息, error里面有断点续传需要的resumeData
-(void)URLSession:(nonnull NSURLSession *)session task:(nonnull NSURLSessionTask *)task didCompleteWithError:(nullable NSError *)error {
    if (error) {
        //用户取消下载会回调一个error,
        if ([error.localizedDescription isEqualToString:@"cancelled"] || [error.localizedDescription isEqualToString:NSLocalizableString(@"canceled", nil)] ) {
            DDLogDebug(@"%@ Downloading is meeting: %@", logName, error.localizedDescription);
            return;
        }
        NSString *mediaIdStr = task.taskDescription;
        DDLogDebug(@"%@ Downloading is meeting an Error: %@, mediaId: %@", logName, error, mediaIdStr);
        NSData *resumeData = [error.userInfo objectForKey:NSURLSessionDownloadTaskResumeData];
        //如果是在后台进程被杀死了,则保存一下resumeData
        if ([error.userInfo objectForKey:NSURLErrorBackgroundTaskCancelledReasonKey]) {}
        // 出任何问题，都将resumeData保存
        dispatch_async([DBManager database_queue], ^{
            HICKnowledgeDownloadModel *kModel = [self getDownloadModel:[mediaIdStr toNumber]];
            if (kModel) {
                kModel.mediaStopPoint = [self encodeBinaryDataToString:resumeData];
                kModel.mediaStatus = HICDownloadStop;
                [DBManager updateDownloadMediaWithStop:kModel];
            } else {
                DDLogDebug(@"%@ Can NOT get Model when Download paused", logName);
            }
        });
    }
}

#pragma mark - NSURLSessionDelegate
//应用处于后台,所有下载任务已经完成，且其他代理方法都调用完以后调用
- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session {
    DDLogDebug(@"应用在后台该做的事儿都做完了");
}
#pragma mark - - - NSURLSessionTaskDelegate - - - end

#pragma mark - - - HICM3U8ManagerDelegate - - - start
- (void)praseM3U8Result:(BOOL)success reason:(NSString *)reason {
    if (success) {
        HICM3U8PlayListModel *plModel = M3U8Manager.playList;
        NSArray *m3u8Segments = plModel.segmentModelArr;
        if (m3u8Segments.count > 0) {
            [self startDownloadWithM3U8Segments:m3u8Segments m3u8IndexUrl:plModel.m3u8IndexUrl];
        } else {
            DDLogDebug(@"%@ There is no m3u8 .ts file", logName);
        }
    } else {
        DDLogDebug(@"%@ M3U8 parse failed, reason: %@", logName, reason);
    }
}
#pragma mark - - - HICM3U8ManagerDelegate - - - end

@end
