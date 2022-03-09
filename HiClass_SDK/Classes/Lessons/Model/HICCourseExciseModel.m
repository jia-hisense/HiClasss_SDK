//
//  HICCourseExciseModel.m
//  HiClass
//
//  Created by WorkOffice on 2020/2/17.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICCourseExciseModel.h"

@implementation HICCourseExciseModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if([key isEqualToString:@"id"]){
        self.reletedId = [value intValue];
    }
}
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"reletedId":@"id"};
}
@end
