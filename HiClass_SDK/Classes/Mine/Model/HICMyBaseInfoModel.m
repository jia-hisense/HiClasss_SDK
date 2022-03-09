//
//  HICMyBaseInfoModel.m
//  HiClass
//
//  Created by WorkOffice on 2020/3/16.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICMyBaseInfoModel.h"

@implementation HICMyBaseInfoModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if([key isEqualToString:@"id"]){
        self.workerId = value;
    }
}
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"workerId":@"id"};
}

@end
