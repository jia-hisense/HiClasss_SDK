//
//  HICPostMapMoreModel.m
//  HiClass
//
//  Created by Sir_Jing on 2020/3/19.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICPostMapMoreModel.h"

@implementation MapMoreInfoModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key {
    // 空实现
}

@end

@implementation HICPostMapMoreModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"postList"]) {
        if ([value isKindOfClass:NSArray.class]) {
            NSMutableArray *array = [NSMutableArray array];
            for (NSDictionary *dic in value) {
                if ([dic isKindOfClass:NSDictionary.class]) {
                    MapMoreInfoModel *model = [MapMoreInfoModel new];
                    [model setValuesForKeysWithDictionary:dic];
                    [array addObject:model];
                }
            }
            _postList = [array copy];
        }
    }
}
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"postList":@"MapMoreInfoModel"};
}

+(NSArray *)getMapMoreDataWith:(NSDictionary *)dic {

//    NSMutableArray *models = [NSMutableArray array];
    NSArray *list = [dic objectForKey:@"data"];

//    for (NSDictionary *d in list) {
//        HICPostMapMoreModel *model = [HICPostMapMoreModel new];
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
