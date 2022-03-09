//
//  JLogSDKDataBaseManager.h
//  AFNetworking
//
//  Created by keep on 2018/1/29.
//

#import <sqlite3.h>
#import "JLogSDKSingleton.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JLogSDKDataBaseManager : NSObject {
    sqlite3 *db;
}

singleton_interface(JLogSDKDataBaseManager)

typedef void(^NeedReport)(BOOL need, JLogSDKLogEventType logType);

@property (nonatomic, copy) NeedReport _Nonnull needReport;

/// 获取数据库queue
- (dispatch_queue_t _Nullable )database_queue;
/**
 * 存取上报失败的遗失log
 */
- (void)saveLostLogToDataBaseWithArr:(NSArray *_Nullable)arr;

- (void)saveAllLogToDataBaseWithDict:(NSDictionary *_Nullable)dict needReport:(NeedReport _Nullable )need;

- (NSArray * _Nullable )getExcLogDataWithExcFileSize:(NSInteger)size;

- (NSArray * _Nullable )getDotLogDataWithDotFileSize:(NSInteger)size;

- (NSArray * _Nullable )getSerLogDataWithSerFileSize:(NSInteger)size;

@end

NS_ASSUME_NONNULL_END
