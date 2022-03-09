//
//  HICLogManager.h
//  HiClass
//
//  Created by Eddie Ma on 2020/1/15.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HICLogManager : NSObject

+ (instancetype)shared;

- (void)reportExcLogWithDict:(NSDictionary *)dict;
- (void)reportDotLogWithDict:(NSDictionary *)dict;
- (void)reportSerLogWithDict:(NSDictionary *)dict;
- (void)reportSerLogWithType:(HICSerLogEventType)type params:(NSDictionary *__nullable)params;
- (void)reportAppStart;
- (NSDictionary *)getDotLogEventDictWithType:(HICDotLogEventType)type;

- (NSDictionary *)getSerLogEventDictWithType:(HICSerLogEventType)type;

- (NSDictionary *)getExcLogEventDictWithType:(HICExcLogEventType)type;

- (NSDictionary *)getAppEventDictWithType:(HICAppLogEventType)type;
@end

NS_ASSUME_NONNULL_END
