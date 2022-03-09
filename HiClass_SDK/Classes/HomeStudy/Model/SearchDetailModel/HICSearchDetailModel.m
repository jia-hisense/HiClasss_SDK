//
//  HICSearchDetailModel.m
//  HiClass
//
//  Created by Sir_Jing on 2020/3/20.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICSearchDetailModel.h"

@implementation SearchDetailInfoModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key {

    if ([key isEqualToString:@"id"]) {
        if ([value isKindOfClass:NSString.class]) {
            NSString *str = (NSString *)value;
            _infoId = str.integerValue;
        }else if ([value isKindOfClass:NSNumber.class]) {
            NSNumber *num = (NSNumber *)value;
            _infoId = num.integerValue;
        }
    }else if ([key isEqualToString:@"description"]) {
        _infoDescription = value;
    }
}
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"infoId":@"id",
             @"infoDescription":@"description"
    };
}
@end

@implementation HICSearchDetailModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key {

    if ([key isEqualToString:@"content"]) {
        if ([value isKindOfClass:NSArray.class]) {
            NSMutableArray *array = [NSMutableArray array];
            for (NSDictionary *dic in value) {
                if ([dic isKindOfClass:NSDictionary.class]) {
                    SearchDetailInfoModel *model = [SearchDetailInfoModel mj_objectWithKeyValues:dic];
//                    [model setValuesForKeysWithDictionary:dic];
                    [array addObject:model];
                }
            }
            _content = [array copy];
        }
    }
}

+ (NSDictionary *)mj_objectClassInArray {

    return @{@"content":@"SearchDetailInfoModel"};
}


+(HICSearchDetailModel *)createModelWithSourceData:(NSDictionary *)data {

//    HICSearchDetailModel *model = [HICSearchDetailModel new];
    NSDictionary *dic = [data objectForKey:@"data"];
//    [model setValuesForKeysWithDictionary:dic];
    HICSearchDetailModel *model = [self mj_objectWithKeyValues:dic];
    return model;
}


@end
