//
//  HICUserDetailModel.m
//  HiClass
//
//  Created by Sir_Jing on 2020/3/21.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICUserDetailModel.h"

@implementation HICUserDetailModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        if ([value isKindOfClass:NSNumber.class]) {
            NSNumber *num = (NSNumber *)value;
            _userId = num.integerValue;
        }else if ([value isKindOfClass:NSString.class]) {
            NSString *str = (NSString *)value;
            _userId = str.integerValue;
        }
    }
}

+ (instancetype)createModelWithSourceData:(NSDictionary *)data {

    NSDictionary *dic = [data objectForKey:@"data"];
    HICUserDetailModel *model = [HICUserDetailModel mj_objectWithKeyValues:dic];
//    if ([dic isKindOfClass:NSDictionary.class]) {
//        [model setValuesForKeysWithDictionary:dic];
//        
//    }

    return model;
}

-(NSString *)getRoleIdStr {

    NSMutableString *roleStr = [NSMutableString string];

    if (_roleList && [_roleList isKindOfClass:NSArray.class] &&_roleList.count > 0) {
        for (NSDictionary *dic in _roleList) {
            if ([dic isKindOfClass:NSDictionary.class]) {
                NSString *roleId = [dic objectForKey:@"id"];
                if (roleId) {
                    [roleStr appendFormat:@"%@,", roleId];
                }
            }
        }
    }

    if (roleStr.length > 0) {
        [roleStr deleteCharactersInRange:NSMakeRange(roleStr.length-1, 1)];
    }

    return [roleStr copy];
}

@end
