//
//  HICPostMapDetailReqModel.m
//  HiClass
//
//  Created by Sir_Jing on 2020/3/19.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICPostMapDetailReqModel.h"

@implementation HICPostMapCerModel

+(NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"cerId" : @"id",
    };
}

+(NSArray *)getModelArrayWithRep:(NSDictionary *)dic {

    NSMutableArray *array = [NSMutableArray array];
    id data = [dic valueForKey:@"data"];
    if (data && [data isKindOfClass:NSArray.class]) {
        array = [HICPostMapCerModel mj_objectArrayWithKeyValuesArray:data];
    }
//    if (array.count != 0) {
//        NSMutableArray *dataArray = [NSMutableArray array];
//        for (HICPostMapCerModel *model in array) {
//            if (model.acquired == 1) {
//                [dataArray addObject:model];
//            }
//        }
//        array = dataArray; // 重新指向
//    }

    return [array copy];
}

@end

@implementation HICPostMapDetailReqModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key {
    // 空实现
}

@end
