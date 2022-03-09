//
//  HICCourseRecommendModel.m
//  HiClass
//
//  Created by WorkOffice on 2020/2/17.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICCourseRecommendModel.h"

@implementation HICCourseRecommendModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if([key isEqualToString:@"id"]){
        self.recommendId = [value intValue];
    }
}
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"recommendId":@"id"};
}
@end
