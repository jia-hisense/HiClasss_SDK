//
//  HICCourseKLDModel.m
//  HiClass
//
//  Created by WorkOffice on 2020/2/19.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICCourseKLDModel.h"

@implementation HICCourseKLDModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if([key isEqualToString:@"id"]){
        self.courseID = [value intValue];
    }
}
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"courseID":@"id"};
}
@end
