//
//  HICHomeTaskCenterModel.m
//  iTest
//
//  Created by Sir_Jing on 2020/3/14.
//  Copyright © 2020 Sir_Jing. All rights reserved.
//

#import "HICHomeTaskCenterModel.h"

@implementation HICHomeTaskCenterModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key {
    // 空实现
}

+(NSArray *)createModelWithSourceData:(NSDictionary *)data name:(nonnull NSString *)name{
    if (!name) {
        return @[]; // 空数组
    }
//    NSDictionary *dicData = [data objectForKey:@"data"];
//    if ([HICCommonUtils isValidObject:dicData]) {
//        NSArray *columnList = [dicData objectForKey:name];
//
//        NSMutableArray *modelArray = [NSMutableArray array];
//
//        for (NSDictionary *dic in columnList) {
//            HICHomeTaskCenterModel *model = [HICHomeTaskCenterModel new];
//            [model setValuesForKeysWithDictionary:dic];
//
//            // 添加到数组中
//            [modelArray addObject:model];
//        }
//        return [modelArray copy];
//    } else {
//        return @[];
//    }

    NSDictionary *dicData = [data objectForKey:@"data"];
    if ([HICCommonUtils isValidObject:dicData]) {
        NSArray *columnList = [dicData objectForKey:name];
        if ([columnList isKindOfClass:NSArray.class]) {
            NSMutableArray *array = [self mj_objectArrayWithKeyValuesArray:columnList];
            return [array copy];
        }
    }
    return @[];
}

@end
