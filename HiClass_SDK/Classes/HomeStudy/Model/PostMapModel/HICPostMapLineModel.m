//
//  HICPostMapLineModel.m
//  HiClass
//
//  Created by Sir_Jing on 2020/3/19.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICPostMapLineModel.h"

@implementation MapLineInfoModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key {
    // 空实现
}

@end

@implementation HICPostMapLineModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key {

    if ([key isEqualToString:@"wayDetail"]) {
        if ([value isKindOfClass:NSArray.class]) {
            NSMutableArray *array = [NSMutableArray array];
            for (NSDictionary *dic in value) {
                if ([dic isKindOfClass:NSDictionary.class]) {
                    MapLineInfoModel *model = [MapLineInfoModel new];
                    [model setValuesForKeysWithDictionary:dic];
                    [array addObject:model];
                }
            }
            self.wayDetail = [array copy];
        }
    }
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"wayDetail":@"MapLineInfoModel"};
}

+(NSArray *)getMapLineDataWith:(NSDictionary *)dic {

//    NSMutableArray *models = [NSMutableArray array];
//    NSDictionary *data = [dic objectForKey:@"data"];
    NSArray *list = [dic objectForKey:@"data"];

//    for (NSDictionary *d in list) {
//        HICPostMapLineModel *model = [HICPostMapLineModel new];
//        [model setValuesForKeysWithDictionary:d];
//        [models addObject:model];
//    }
    if ([list isKindOfClass:NSArray.class]) {
        NSMutableArray *models = [self mj_objectArrayWithKeyValuesArray:list];

        return [models copy];
    }
    return @[];
}

@end
