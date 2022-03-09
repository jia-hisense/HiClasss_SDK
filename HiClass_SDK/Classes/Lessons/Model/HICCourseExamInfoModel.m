//
//  HICCourseExamInfoModel.m
//  HiClass
//
//  Created by WorkOffice on 2020/2/17.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICCourseExamInfoModel.h"

@implementation HICCourseExamInfoModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if([key isEqualToString:@"id"]){
        self.examId = [value intValue];
    }
}
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"examId":@"id"};
}
@end
