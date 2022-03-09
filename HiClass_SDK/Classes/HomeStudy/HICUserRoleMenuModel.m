//
//  HICUserRoleModel.m
//  HiClass
//
//  Created by Sir_Jing on 2020/3/21.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICUserRoleMenuModel.h"

@implementation HICUserRoleMenuModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key {

    if ([key isEqualToString:@"children"]) {
        if ([value isKindOfClass:NSArray.class]) {
            NSMutableArray *array = [NSMutableArray array];
            for (NSDictionary *dic in value) {
                HICUserRoleMenuModel *model = [HICUserRoleMenuModel new];
                [model setValuesForKeysWithDictionary:dic];
                [array addObject:model];
            }
            _children = [array copy];
        }
    } else if ([key isEqualToString:@"id"]) {
        if ([value isKindOfClass:NSNumber.class]) {
            NSNumber *num = (NSNumber *)value;
            _roleMenuID = num.integerValue;
        }else if ([value isKindOfClass:NSString.class]) {
            NSString *str = (NSString *)value;
            _roleMenuID = str.integerValue;
        }
    }
}

+(NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"roleMenuID":@"id"};
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"children" : @"HICUserRoleMenuModel"};
}

+ (NSArray *)createModelWithSourceData:(NSDictionary *)data {

    NSArray *array = [data objectForKey:@"data"];
    NSMutableArray *mArr = [self mj_objectArrayWithKeyValuesArray:array];
//    if ([array isKindOfClass:NSArray.class]) {
//        for (NSDictionary *dic in array) {
//            if ([dic isKindOfClass:NSDictionary.class]) {
//                HICUserRoleMenuModel *model = [HICUserRoleMenuModel new];
//                [model setValuesForKeysWithDictionary:dic];
//                [mArr addObject:model];
//            }
//        }
//    }

    return [mArr copy];
}

@end
