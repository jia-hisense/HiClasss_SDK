//
//  HICTabMenuModel.m
//  HiClass
//
//  Created by 铁柱， on 2020/3/24.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICTabMenuModel.h"

@implementation HICTabMenuModel

+ (NSArray *)createModelWithSourceData:(NSDictionary *)data {
    NSDictionary *dic = [data objectForKey:@"data"];
    NSArray *array = [dic objectForKey:@"navList"];
    NSMutableArray *mArr = [self mj_objectArrayWithKeyValuesArray:array];

    return [mArr copy];
}

@end
