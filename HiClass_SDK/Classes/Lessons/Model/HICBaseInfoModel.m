//
//  HICBaseInfoModel.m
//  HiClass
//
//  Created by WorkOffice on 2020/2/17.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICBaseInfoModel.h"

@implementation HICBaseInfoModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if([key isEqualToString:@"id"]){
       [self setValue:value forKey:@"courseID"];
    }
}
+(NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"courseID":@"id"};
}
@end
