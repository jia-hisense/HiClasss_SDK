//
//  HICDBManager.m
//  HiClass
//
//  Created by Eddie Ma on 2020/2/20.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICDBManager.h"

static NSString *logName = @"[HIC][DBM]";

#pragma mark - - - 数据库信息 - - - Start
// 数据库所有表
#define DOWNLOADMEDIATABLE                 @"downloadMediaTable"      // 下载媒资表
// downloadMediaTable表中字段
#define LOGIN_CID                                    @"login_cid"                       // 用户ID
#define FILE_ID                                         @"file_id"                           // 媒资-ID
#define FILE_IDS                                       @"file_ids"                         // 媒资-IDs, 用于记录图片或者文档所有图片的顺序
#define FILE_TYPE                                     @"file_type"                       // 媒资-是否原文件：0-否  1-是
#define SECTION_ID                                  @"section_id"                     // 媒资-章节ID
#define MEDIA_ID                                      @"media_id"                      // 媒资-知识ID
#define MEDIA_TS_ID                                @"media_ts_id"                  // 如果媒资是m3u8格式，该字段存的是在一个mediaId下的第几个ts文件, 如果不是m3u8格式，则为-2 (暂时不用)
#define MEDIA_NAME                                 @"media_name"                 // 媒资-知识名
#define MEDIA_CID                                    @"media_cid"                     // 媒资-课程ID
#define MEDIA_CNAME                               @"media_cname"                // 媒资-课程名
#define MEDIA_URL                                    @"media_url"                     // 媒资的源下载地址
#define MEDIA_TYPE                                  @"media_type"                   // 媒资类型：0-图片，1-视频，2-音频，3-文档，4-压缩包，5-scrom，6-html
#define MEDIA_PATH                                  @"media_path"                   // 媒资保存路径
#define MEDIA_DOWNLOAD_SIZE               @"media_download_size"     // 媒资已经下载的大小
#define MEDIA_SIZE                                  @"media_size"                    // 媒资大小
#define MEDIA_DOWNLOAD_STATSU           @"media_download_status" // 媒资下载的状态 HICDownloadStatus
#define MEDIA_STOP_POINT                       @"media_stop_point"          // 媒资下载暂停后，记录暂停时的点，为了下次继续传
#define MEDIA_COUNT                               @"media_count"                 // 该媒资（知识）所属的课程下所有可下载的媒资（知识）数
#define MEDIA_DOWNLOAD_COUNT            @"media_download_count"  // 课程中下载的数量
#define MEDIA_SINGLE                              @"media_single"                 // 该媒资（知识）是否是的单独下载,  0-不是，1-是
#define MEDIA_COVER_PIC                         @"media_cover_pic"           // 该媒资(知识)封面图
#define MEDIA_CCOVER_PIC                       @"media_cCover_pic"           // 该媒资(所属课程)封面图
// downloadMediaTable表中字段
#define DOWNLOADMEDIATABLEARRAY        [NSArray arrayWithObjects: LOGIN_CID, FILE_ID, FILE_IDS, FILE_TYPE, SECTION_ID, MEDIA_ID, MEDIA_TS_ID, MEDIA_NAME, MEDIA_CID, MEDIA_CNAME, MEDIA_URL, MEDIA_TYPE, MEDIA_PATH, MEDIA_DOWNLOAD_SIZE, MEDIA_SIZE, MEDIA_DOWNLOAD_STATSU, MEDIA_STOP_POINT, MEDIA_COUNT, MEDIA_DOWNLOAD_COUNT, MEDIA_SINGLE, MEDIA_COVER_PIC, MEDIA_CCOVER_PIC, nil]
// downloadMediaTable表中字段类型
#define DOWNLOADMEDIATABLETYPE           [NSArray arrayWithObjects: @"TEXT", @"TEXT", @"TEXT", @"TEXT", @"TEXT", @"TEXT", @"TEXT", @"TEXT" ,@"TEXT", @"TEXT", @"TEXT", @"TEXT", @"TEXT", @"TEXT", @"TEXT", @"TEXT", @"TEXT", @"TEXT", @"TEXT", @"TEXT", @"TEXT", @"TEXT", nil]
// 存放所有表数组
#define ALLTABLEARRAY                               [NSArray arrayWithObjects: DOWNLOADMEDIATABLE, nil]
// 存放所有表中的字段数组
#define ALLTABLECOLUMNSARRAY                [NSArray arrayWithObjects: DOWNLOADMEDIATABLEARRAY, nil]
// 存放所有表中字段类型数组
#define ALLTABLECOLUMNSTYPEARRAY         [NSArray arrayWithObjects: DOWNLOADMEDIATABLETYPE, nil]

#pragma mark - - - 数据库信息 - - - End

@interface HICDBManager() {
    sqlite3 *db;
}
@end

@implementation HICDBManager

+ (instancetype)shared {
    static HICDBManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (dispatch_queue_t)database_queue {
    static dispatch_queue_t as_database_queue = NULL;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        as_database_queue = dispatch_queue_create("com.hisense.edu.hiclass.db.queue", NULL);
    });
    return as_database_queue;
}

- (void)updataDB {
    for (int i = 0; i < ALLTABLECOLUMNSARRAY.count; i ++) {
        NSArray *tableColumnArray = ALLTABLECOLUMNSARRAY[i];
        NSArray *tableColumnTypeArray = ALLTABLECOLUMNSTYPEARRAY[i];
        NSArray * oldColumns = [self getOldTableColumnsWithTabelName:ALLTABLEARRAY[i]];
        NSMutableArray *newColums = [[NSMutableArray alloc] init];
        NSMutableArray *newColumsType = [[NSMutableArray alloc] init];
        for (int k = 0; k < tableColumnArray.count; k++) {
            BOOL isExist = NO;
            for (int j = 0; j < oldColumns.count; j ++) {
                if ([tableColumnArray[k] isEqualToString:oldColumns[j]]) {
                    isExist = YES;
                }
            }
            if (!isExist) {
                [newColums addObject:tableColumnArray[k]];
                [newColumsType addObject:tableColumnTypeArray[k]];
            }
        }
        [self updateNewColumnsWithTableName:ALLTABLEARRAY[i] newColums:newColums newColumsType:newColumsType];
    }
}

- (NSArray *)getOldTableColumnsWithTabelName:(NSString *)tableName {
    NSString *sqlQuery = [NSString stringWithFormat:@"PRAGMA table_info(%@)", tableName];
    sqlite3_stmt *statement = nil;
    NSMutableArray *array = [NSMutableArray array];
    if (sqlite3_prepare_v2(db, [sqlQuery UTF8String], -1, &statement, NULL) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            char *nameData = (char *)sqlite3_column_text(statement, 1);
            NSString *columnName = [[NSString alloc] initWithUTF8String:nameData];
            BOOL result = [columnName caseInsensitiveCompare:@"id"] == NSOrderedSame;
            if (!result)
                [array addObject:columnName];
        }
    }
    sqlite3_finalize(statement);
    return array;
}

- (void)updateNewColumnsWithTableName:(NSString *)tableName newColums:(NSArray *)colums newColumsType:(NSArray *)newColumsType{
    for (int i = 0; i < colums.count; i++) {
        id defaultValue;
        NSString *contactSql = @"";
        if ([newColumsType[i] isEqualToString:@"INTEGER"]) {
            defaultValue = 0;
            contactSql = [NSString stringWithFormat:@"ALTER TABLE %@ ADD COLUMN %@ %@ DEFAULT %ld", tableName, colums[i], newColumsType[i], (long)defaultValue];
        } else {
            defaultValue = @"";
            contactSql = [NSString stringWithFormat:@"ALTER TABLE %@ ADD COLUMN %@ %@ DEFAULT '%@'", tableName, colums[i], newColumsType[i], defaultValue];
        }
        [self execSql:contactSql];
    }
}

#pragma mark - - - init create DB
- (instancetype)init {
    if (self = [super init]) {
        sqlite3_shutdown();
        sqlite3_config(SQLITE_CONFIG_SERIALIZED);
        sqlite3_initialize();

        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *firlePath = [path stringByAppendingPathComponent:@"HICDB.sqlite"];

        DDLogDebug(@"%@ HIC DB file path: %@",logName, firlePath);

        if (sqlite3_open(firlePath.UTF8String, &db) == SQLITE_OK) {
            DDLogDebug(@"%@ DB open successfully!",logName);
            [self createTable];
        } else{
            DDLogDebug(@"%@ DB open unsuccessfully! error code: %d",logName, sqlite3_open(firlePath.UTF8String, &db));
            return nil;
        }
    }
    return self;
}

- (void)createTable {
    // 媒资下载表
    NSString *contactSql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (ID INTEGER PRIMARY KEY AUTOINCREMENT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT)", DOWNLOADMEDIATABLE, LOGIN_CID, FILE_ID, FILE_IDS, FILE_TYPE, SECTION_ID, MEDIA_ID, MEDIA_TS_ID, MEDIA_NAME, MEDIA_CID, MEDIA_CNAME, MEDIA_URL, MEDIA_TYPE, MEDIA_PATH, MEDIA_DOWNLOAD_SIZE, MEDIA_SIZE, MEDIA_DOWNLOAD_STATSU, MEDIA_STOP_POINT, MEDIA_COUNT, MEDIA_DOWNLOAD_COUNT, MEDIA_SINGLE, MEDIA_COVER_PIC, MEDIA_CCOVER_PIC];
    [self execSql:contactSql];
}

// 判断表是否创建成功
- (void)execSql:(NSString *)sql {
    char *err;
    if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) {
        sqlite3_free(err);
        DDLogDebug(@"%@ DB execute unsuccessfully! %@",logName, sql);
    }
}

- (void)insertToDownloadMediaTable:(HICKnowledgeDownloadModel *)kModel {
    NSString *fileIdStr = [NSString isValidStr:kModel.fileId] ? kModel.fileId : @"";
    NSString *fileIdsStr = [NSString isValidStr:kModel.fileIds] ? kModel.fileIds : @"";
    NSString *fileTypeStr = kModel.fileType ? [NSString stringWithFormat:@"%@",kModel.fileType] : @"";
    NSString *mediaSectionbIdStr = kModel.sectionId ? [NSString stringWithFormat:@"%@",kModel.sectionId] : @"";
    NSString *mediaIdStr = kModel.mediaId ? [NSString stringWithFormat:@"%@",kModel.mediaId] : @"";
    NSString *mediaTsIdStr = kModel.mediaTsId ? [NSString stringWithFormat:@"%@", kModel.mediaTsId] : @"-2";
    NSString *mediaName = [NSString isValidStr:kModel.mediaName] ? kModel.mediaName : @"";
    NSString *cMediaIdStr = kModel.cMediaId ? [NSString stringWithFormat:@"%@",kModel.cMediaId] : @"";
    NSString *cMediaName = [NSString isValidStr:kModel.cMediaName] ? kModel.cMediaName : @"";
    NSString *mediaURLStr = [NSString isValidStr:kModel.mediaURL] ? kModel.mediaURL : @"";
    NSString *mediaTypeStr = kModel.mediaType ? [NSString stringWithFormat:@"%@",kModel.mediaType] : @"0";
    NSString *mediaPath = [NSString isValidStr:kModel.mediaPath] ? kModel.mediaPath : @"";
    NSString *mediaDownloadSizeStr = kModel.mediaDownloadSize ? [NSString stringWithFormat:@"%@",kModel.mediaDownloadSize] : @"0";
    NSString *mediaSizeStr = kModel.mediaSize ? [NSString stringWithFormat:@"%@",kModel.mediaSize] : @"0";
    NSString *mediaDownloadStatus = [NSString isValidStr:[NSString stringWithFormat:@"%ld", (long)kModel.mediaStatus]] ? [NSString stringWithFormat:@"%ld", (long)kModel.mediaStatus] : @"0";
    NSString *mediaStopPoint = [NSString isValidStr:kModel.mediaStopPoint] ? kModel.mediaStopPoint : @"";
    NSString *mediaCountStr = [NSString isValidStr:[NSString stringWithFormat:@"%ld", (long)kModel.mediaCount]] ? [NSString stringWithFormat:@"%ld", (long)kModel.mediaCount] : @"0";
    NSString *mediaDownloadCountStr = [NSString isValidStr:[NSString stringWithFormat:@"%ld", (long)kModel.mediaDownloadCount]] ? [NSString stringWithFormat:@"%ld", (long)kModel.mediaDownloadCount] : @"0";
    NSString *mediaSingleStr = [NSString isValidStr:[NSString stringWithFormat:@"%ld", (long)kModel.mediaSingle]] ? [NSString stringWithFormat:@"%ld", (long)kModel.mediaSingle] : @"1";
    NSString *mediaCoverPicStr = [NSString isValidStr:kModel.coverPic] ? kModel.coverPic : @"";
    NSString *mediaCCoverPicStr = [NSString isValidStr:kModel.cCoverPic] ? kModel.cCoverPic : @"";

    if (![self isExistMediaWith:mediaIdStr mediaTsId:mediaTsIdStr]) {
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO '%@' ('%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@') VALUES ('%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@')", DOWNLOADMEDIATABLE, LOGIN_CID, FILE_ID, FILE_IDS, FILE_TYPE, SECTION_ID, MEDIA_ID, MEDIA_TS_ID, MEDIA_NAME, MEDIA_CID, MEDIA_CNAME, MEDIA_URL, MEDIA_TYPE, MEDIA_PATH, MEDIA_DOWNLOAD_SIZE, MEDIA_SIZE, MEDIA_DOWNLOAD_STATSU, MEDIA_STOP_POINT, MEDIA_COUNT, MEDIA_DOWNLOAD_COUNT, MEDIA_SINGLE, MEDIA_COVER_PIC, MEDIA_CCOVER_PIC, USER_CID, fileIdStr, fileIdsStr, fileTypeStr, mediaSectionbIdStr, mediaIdStr, mediaTsIdStr, mediaName, cMediaIdStr, cMediaName, mediaURLStr, mediaTypeStr, mediaPath, mediaDownloadSizeStr, mediaSizeStr, mediaDownloadStatus, mediaStopPoint, mediaCountStr, mediaDownloadCountStr, mediaSingleStr, mediaCoverPicStr, mediaCCoverPicStr];
        [self execSql:sql];
    }
}

- (BOOL)isExistMediaWith:(NSString *)mediaIdStr mediaTsId:(NSString *)mediaTsid {
    sqlite3_stmt *stmt = nil;
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = '%@' AND %@ = '%@' AND %@ = '%@'", DOWNLOADMEDIATABLE, LOGIN_CID, USER_CID, MEDIA_ID, mediaIdStr, MEDIA_TS_ID, mediaTsid];
    int result = sqlite3_prepare_v2(db, [sql UTF8String], -1, &stmt, nil);
    if (result == SQLITE_OK) {
        if (sqlite3_step(stmt) == SQLITE_ROW) {
            sqlite3_finalize(stmt);
            return YES;
        } else {
            sqlite3_finalize(stmt);
            return NO;
        }
    } else {
        sqlite3_finalize(stmt);
        return NO;
    }
}

- (void)updateDownloadMediaWithDownloading:(HICKnowledgeDownloadModel *)kModel {
    NSString *mediaDownloadSizeStr = kModel.mediaDownloadSize ? [NSString stringWithFormat:@"%@",kModel.mediaDownloadSize] : @"0";
    NSString *mediaSizeStr = kModel.mediaSize ? [NSString stringWithFormat:@"%@",kModel.mediaSize] : @"0";
    NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET %@ = '%@', %@ = '%@' WHERE %@ = '%@' AND %@ = '%@'", DOWNLOADMEDIATABLE, MEDIA_DOWNLOAD_SIZE, mediaDownloadSizeStr, MEDIA_SIZE, mediaSizeStr, LOGIN_CID, USER_CID, MEDIA_ID, kModel.mediaId];
    [self execSql:sql];
}

- (void)updateDownloadMediaWithStop:(HICKnowledgeDownloadModel *)kModel {
    NSString *mediaStopPoint = [NSString isValidStr:kModel.mediaStopPoint] ? kModel.mediaStopPoint : @"";
    NSString *mediaDownloadStatus = [NSString isValidStr:[NSString stringWithFormat:@"%ld", (long)kModel.mediaStatus]] ? [NSString stringWithFormat:@"%ld", (long)kModel.mediaStatus] : @"0";
    NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET %@ = '%@', %@ = '%@' WHERE %@ = '%@' AND %@ = '%@'", DOWNLOADMEDIATABLE, MEDIA_DOWNLOAD_STATSU, mediaDownloadStatus, MEDIA_STOP_POINT, mediaStopPoint, LOGIN_CID, USER_CID, MEDIA_ID, kModel.mediaId];
    [self execSql:sql];
}

- (void)updateDownloadMediaWithResume:(HICKnowledgeDownloadModel *)kModel {
    NSString *mediaDownloadStatus = [NSString isValidStr:[NSString stringWithFormat:@"%ld", (long)kModel.mediaStatus]] ? [NSString stringWithFormat:@"%ld", (long)kModel.mediaStatus] : @"0";
    NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET %@ = '%@' WHERE %@ = '%@' AND %@ = '%@'", DOWNLOADMEDIATABLE, MEDIA_DOWNLOAD_STATSU, mediaDownloadStatus, LOGIN_CID, USER_CID, MEDIA_ID, kModel.mediaId];
    [self execSql:sql];
}

- (void)updateDownloadMediaWithFinish:(HICKnowledgeDownloadModel *)kModel {
    NSString *mediaPath = [NSString isValidStr:kModel.mediaPath] ? kModel.mediaPath : @"";
    NSString *mediaDownloadStatus = [NSString isValidStr:[NSString stringWithFormat:@"%ld", (long)kModel.mediaStatus]] ? [NSString stringWithFormat:@"%ld", (long)kModel.mediaStatus] : @"0";
    NSString *mediaStopPoint = @"";
    NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET %@ = '%@', %@ = '%@', %@ = '%@' WHERE %@ = '%@' AND %@ = '%@'", DOWNLOADMEDIATABLE, MEDIA_PATH, mediaPath, MEDIA_DOWNLOAD_STATSU, mediaDownloadStatus, MEDIA_STOP_POINT, mediaStopPoint, LOGIN_CID, USER_CID, MEDIA_ID, kModel.mediaId];
    [self execSql:sql];
}

- (NSArray *)selectAllDownloadMedia {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = %@", DOWNLOADMEDIATABLE, LOGIN_CID, USER_CID];
    sqlite3_stmt *statement = nil;
    int result = sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, nil);
    if (result == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            [array addObject:[self getKModel:statement]];
        }
    }
    sqlite3_finalize(statement);
    return array;
}

- (NSArray *)selectMediasByMediaId:(NSNumber *)mediaId isCourseId:(BOOL)isCourseid {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSString *mediaIdStr = mediaId ? [NSString stringWithFormat:@"%@",mediaId] : @"";
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = %@ AND %@ = '%@'", DOWNLOADMEDIATABLE, LOGIN_CID, USER_CID, isCourseid ? MEDIA_CID : MEDIA_ID, mediaIdStr];
    sqlite3_stmt *statement = nil;
    int result = sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, nil);
    if (result == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            [array addObject:[self getKModel:statement]];
        }
    }
    sqlite3_finalize(statement);
    return array;
}

- (NSArray *)selectMediasByMediaSectionId:(NSNumber *)mediaSectionId {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSString *mediaSectionIdStr = mediaSectionId ? [NSString stringWithFormat:@"%@",mediaSectionId] : @"";
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = %@ AND %@ = '%@'", DOWNLOADMEDIATABLE, LOGIN_CID, USER_CID, SECTION_ID, mediaSectionIdStr];
    sqlite3_stmt *statement = nil;
    int result = sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, nil);
    if (result == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            [array addObject:[self getKModel:statement]];
        }
    }
    sqlite3_finalize(statement);
    return array;
}


- (void)deleteMediaWith:(NSArray *)arr {
    for (HICKnowledgeDownloadModel *kModel in arr) {
        NSString *mediaIdStr = kModel.mediaId ? [NSString stringWithFormat:@"%@",kModel.mediaId] : @"";
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = '%@' AND %@ = '%@'", DOWNLOADMEDIATABLE, LOGIN_CID, USER_CID, MEDIA_ID, mediaIdStr];
        [self execSql:sql];
        // 删除沙盒中保存的该媒资
        if (kModel.mediaStatus == HICDownloadFinish) {
            NSString *filePath;
            if ([kModel.mediaURL containsString:@".m3u8"]) { // 如果是m3u8，则删除整个文件夹
                filePath  = [NSString stringWithFormat:@"HIC_Media_%@",kModel.mediaId];
            } else {
                if ([kModel.mediaType integerValue] == HICFileType || [kModel.mediaType integerValue] == HICPictureType) { // 如果是图片，则删除整个文件夹
                    filePath  = [NSString stringWithFormat:@"HIC_pics_%@",kModel.mediaId];
                } else {
                    filePath = kModel.mediaPath;
                }
            }
            if ([self removeDocumentWithFilePath:filePath]) {
                DDLogDebug(@"%@ Delete media(mediaId: %@) successfully", logName, mediaIdStr);
            } else {
                DDLogDebug(@"%@ Delete media(mediaId: %@) failed, cannot find media path", logName, mediaIdStr);
            }
        }
    }
}

- (BOOL)removeDocumentWithFilePath:(NSString*)filePath {
    DDLogDebug(@"%@ Delete path: %@", logName, filePath);
    BOOL isRemove = NO;
    NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *file = [caches stringByAppendingPathComponent:filePath];
    NSFileManager* fileManager=[NSFileManager defaultManager];
    if ([[NSFileManager defaultManager] fileExistsAtPath:file]) {
        isRemove = [fileManager removeItemAtPath:file error:nil];
    }
    return isRemove;
}

- (HICKnowledgeDownloadModel *)getKModel:(sqlite3_stmt *)statement {
    HICKnowledgeDownloadModel *kModel = [[HICKnowledgeDownloadModel alloc] init];
    // 媒资-id
    char *kFileId = (char *)sqlite3_column_text(statement, 2);
    kModel.fileId = [[NSString alloc] initWithUTF8String:kFileId];
    // 媒资-ids
    char *kFileIds = (char *)sqlite3_column_text(statement, 3);
    kModel.fileIds = [[NSString alloc] initWithUTF8String:kFileIds];
    // 媒资类型
    char *kFileType = (char *)sqlite3_column_text(statement, 4);
    kModel.fileType = [[[NSString alloc] initWithUTF8String:kFileType] toNumber];
    // 媒资-章节id
    char *kMediaSectionId = (char *)sqlite3_column_text(statement, 5);
    kModel.sectionId = [[[NSString alloc] initWithUTF8String:kMediaSectionId] toNumber];
    // 媒资-知识id
    char *kMediaId = (char *)sqlite3_column_text(statement, 6);
    kModel.mediaId = [[[NSString alloc] initWithUTF8String:kMediaId] toNumber];
    // 媒资-ts文件id
    char *kMediaTsId = (char *)sqlite3_column_text(statement, 7);
    kModel.mediaTsId = [[[NSString alloc] initWithUTF8String:kMediaTsId] toNumber];
    // 媒资-知识名
    char *kMediaName = (char *)sqlite3_column_text(statement, 8);
    kModel.mediaName = [[NSString alloc] initWithUTF8String:kMediaName];
    // 媒资-课程id
    char *cMediaId = (char *)sqlite3_column_text(statement, 9);
    kModel.cMediaId = [[[NSString alloc] initWithUTF8String:cMediaId] toNumber];
    // 媒资-课程名
    char *cMediaName = (char *)sqlite3_column_text(statement, 10);
    kModel.cMediaName = [[NSString alloc] initWithUTF8String:cMediaName];
    // 媒资-URL
    char *cMediaURL = (char *)sqlite3_column_text(statement, 11);
    kModel.mediaURL = [[NSString alloc] initWithUTF8String:cMediaURL];
    // 媒资-类型
    char *kMediaType = (char *)sqlite3_column_text(statement, 12);
    kModel.mediaType = [[[NSString alloc] initWithUTF8String:kMediaType] toNumber];
    // 媒资-存储路径
    char *kMediaPath = (char *)sqlite3_column_text(statement, 13);
    kModel.mediaPath = [[NSString alloc] initWithUTF8String:kMediaPath];
    // 媒资-已下载大小
    char *kMediaDownloadSize = (char *)sqlite3_column_text(statement, 14);
    kModel.mediaDownloadSize = [[[NSString alloc] initWithUTF8String:kMediaDownloadSize] toNumber];
    // 媒资-总大小
    char *kMediaSize = (char *)sqlite3_column_text(statement, 15);
    kModel.mediaSize = [[[NSString alloc] initWithUTF8String:kMediaSize] toNumber];
    // 媒资-下载状态
    char *kMediaStatus = (char *)sqlite3_column_text(statement, 16);
    kModel.mediaStatus = [[[NSString alloc] initWithUTF8String:kMediaStatus] integerValue];
    // 媒资-课程名
    char *kMediaStopPoint = (char *)sqlite3_column_text(statement, 17);
    kModel.mediaStopPoint = [[NSString alloc] initWithUTF8String:kMediaStopPoint];
    // 媒资-所属某个课程下媒资（知识）的总数
    char *kMediaCount = (char *)sqlite3_column_text(statement, 18);
    kModel.mediaCount = [[[NSString alloc] initWithUTF8String:kMediaCount] integerValue];
    // 课程中知识下载数
    char *kMediaDownloadCount = (char *)sqlite3_column_text(statement, 19);
    kModel.mediaDownloadCount = [[[NSString alloc] initWithUTF8String:kMediaDownloadCount] integerValue];
    // 媒资-（知识）是否是单独下载
    char *kMediaSingle = (char *)sqlite3_column_text(statement, 20);
    kModel.mediaSingle = [[[NSString alloc] initWithUTF8String:kMediaSingle] integerValue];
    // 媒资(知识)封面
    char *kMediaCoverPic = (char *)sqlite3_column_text(statement, 21);
    kModel.coverPic = [[NSString alloc] initWithUTF8String:kMediaCoverPic];
    // 媒资(所属课程)封面
    char *kMediaCCoverPic = (char *)sqlite3_column_text(statement, 22);
    kModel.cCoverPic = [[NSString alloc] initWithUTF8String:kMediaCCoverPic];
    return kModel;
}


@end
