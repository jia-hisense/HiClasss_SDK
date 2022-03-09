//
//  HICCompanyMenuModel.m
//  HiClass
//
//  Created by Sir_Jing on 2020/3/20.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICCompanyMenuModel.h"

@implementation HICCompanyMenuModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key {
    // 空实现
    if ([key isEqualToString:@"children"]) {
        if ([value isKindOfClass:NSArray.class]) {
            NSMutableArray *array = [NSMutableArray array];
            for (NSDictionary *dic in value) {
                if ([dic isKindOfClass:NSDictionary.class]) {
                    HICCompanyMenuModel *model = [HICCompanyMenuModel mj_objectWithKeyValues:dic];
                    if (model) {
                        [array addObject:model];
                    }
                }
            }
            _children = [array copy];
        }
    }
}

+(NSDictionary *)mj_objectClassInArray {
    return @{@"children":@"HICCompanyMenuModel"};
}


+(NSArray *)createModelWithSourceData:(NSDictionary *)data {

//    NSMutableArray *array = [NSMutableArray array];

    NSArray *list = [data objectForKey:@"data"];
//    for (NSDictionary *dic in list) {
//        HICCompanyMenuModel *model = [HICCompanyMenuModel new];
//        [model setValuesForKeysWithDictionary:dic];
//        [array addObject:model];
//    }
    if ([list isKindOfClass:NSArray.class]) {
        NSMutableArray *array = [self mj_objectArrayWithKeyValuesArray:list];

        return [array copy];
    }
    return @[];
}

@end
