//
//  JLogSDKDataBaseManager.h
//  AFNetworking
//
//  Created by keep on 2018/1/29.
//

#import <sqlite3.h>
#import "JLogSDKSingleton.h"
#import <Foundation/Foundation.h>

@interface JLogSDKDataBaseManager : NSObject {
    sqlite3 *db;
}

singleton_interface(JLogSDKDataBaseManager)

/**
 * 存取上报失败的遗失log
 */
- (void)saveLostLogToDataBaseWithArr:(NSArray *)arr;

- (void)saveAllLogToDataBaseWithDict:(NSDictionary *)dict;

- (NSArray *)getExcLogDataWithExcFileSize:(NSInteger)size;

- (NSArray *)getDotLogDataWithDotFileSize:(NSInteger)size;

- (NSArray *)getSerLogDataWithSerFileSize:(NSInteger)size;

@end
