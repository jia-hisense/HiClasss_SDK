//
//  HICM3U8Manager.m
//  HiClass
//
//  Created by Eddie_Ma on 16/2/20.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICM3U8Manager.h"
#import "HICM3U8SegmentModel.h"

static NSString *logName = @"[HIC][M3U8M]";

@implementation HICM3U8Manager

+ (instancetype)shared {
    static HICM3U8Manager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (NSMutableArray *)segmentArray {
    if (_segmentArray == nil) {
        _segmentArray = [[NSMutableArray alloc] init];
    }
    return _segmentArray;
}

- (HICM3U8PlayListModel *)playList {
    if (_playList == nil) {
        _playList = [[HICM3U8PlayListModel alloc] init];
    }
    return _playList;
}

- (void)praseUrl:(NSString *)urlStr {
    //判断是否是HTTP连接
    if (!([urlStr hasPrefix:@"http://"] || [urlStr hasPrefix:@"https://"])) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(praseM3U8Result:reason:)]) {
            [self.delegate praseM3U8Result:NO reason:@"URL is NOT a valid HTTP/HTTPS URL"];
        }
        return;
    }

    // https://dco4urblvsasc.cloudfront.net/811/81095_ywfZjAuP/game/1000kbps.m3u8
    NSArray *tsURLArr = [urlStr componentsSeparatedByString:@"/"];
    NSMutableArray *temTsURLArr = [[NSMutableArray alloc] initWithArray:tsURLArr];
    [temTsURLArr removeLastObject];
    NSString *tsUrl = [NSString stringWithFormat:@"%@/", [temTsURLArr componentsJoinedByString:@"/"]];

    //解析出M3U8
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSError *error = nil;
        NSStringEncoding encoding;
        NSString *m3u8Str = [[NSString alloc] initWithContentsOfURL:[NSURL URLWithString:urlStr] usedEncoding:&encoding error:&error]; //这一步是耗时操作，要在子线程中进行
        self.oriM3U8Str = m3u8Str;
        if (![NSString isValidStr:m3u8Str]) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(praseM3U8Result:reason:)]) {
                [self.delegate praseM3U8Result:NO reason:@"Parse m3u8 index to m3u8 string failed"];
            }
            return;
        }

        //解析TS文件
        NSRange segmentRange = [m3u8Str rangeOfString:@"#EXTINF:"];
        if (segmentRange.location == NSNotFound) {
            //M3U8里没有TS文件
            if (self.delegate && [self.delegate respondsToSelector:@selector(praseM3U8Result:reason:)]) {
                [self.delegate praseM3U8Result:NO reason:@"NO .ts file in M3U8"];
            }
            return;
        }

        if (self.segmentArray.count > 0) {
            [self.segmentArray removeAllObjects];
        }

        //逐个解析TS文件，并存储
        while (segmentRange.location != NSNotFound) {
            //声明一个model存储TS文件链接和时长的model
            HICM3U8SegmentModel *sModel = [[HICM3U8SegmentModel alloc] init];
            //读取TS片段时长
            NSRange commaRange = [m3u8Str rangeOfString:@","];
            NSString* value = [m3u8Str substringWithRange:NSMakeRange(segmentRange.location + [@"#EXTINF:" length], commaRange.location -(segmentRange.location + [@"#EXTINF:" length]))];
            sModel.duration = value;
            //截取M3U8
            m3u8Str = [m3u8Str substringFromIndex:commaRange.location];
            //获取TS下载链接,这需要根据具体的M3U8获取链接，可以根据自己公司的需求
            NSRange linkRangeBegin = [m3u8Str rangeOfString:@","];
            NSRange linkRangeEnd = [m3u8Str rangeOfString:@".ts"];
            NSString* linkUrl = [m3u8Str substringWithRange:NSMakeRange(linkRangeBegin.location + 2, (linkRangeEnd.location + 3) - (linkRangeBegin.location + 2))];
            if ([linkUrl containsString:@"http://"] || [linkUrl containsString:@"https://"]) {
                sModel.downloadURL = linkUrl;
            } else {
                if ([linkUrl containsString:@"\n"]) {
                    linkUrl = [linkUrl componentsSeparatedByString:@"\n"].lastObject;
                }
                sModel.downloadURL = [NSString stringWithFormat:@"%@%@", tsUrl, linkUrl];
            }
            [self.segmentArray addObject:sModel];
            m3u8Str = [m3u8Str substringFromIndex:(linkRangeEnd.location + 3)];
            segmentRange = [m3u8Str rangeOfString:@"#EXTINF:"];
        }

        //已经获取了所有TS片段，继续打包数据
        self.playList.segmentModelArr = self.segmentArray;
        self.playList.tsNum = self.segmentArray.count;
        self.playList.uuid = self.mediaId;
        self.playList.m3u8IndexUrl = urlStr;

        // 到此数据TS解析成功，通过代理发送成功消息
        if (self.delegate && [self.delegate respondsToSelector:@selector(praseM3U8Result:reason:)]) {
            for (HICM3U8SegmentModel *sModel in self.segmentArray) {
                DDLogDebug(@"%@ .ts duration: %@, .ts url: %@", logName, sModel.duration, sModel.downloadURL);
            }
            NSString *desc = [NSString stringWithFormat:@"Parse all .ts file (total: %ld .ts files) successfully",(long)self.segmentArray.count];
            [self.delegate praseM3U8Result:YES reason:desc];
        }
    });
}

@end
