//
//  HICCourseListModel.m
//  HiClass
//
//  Created by WorkOffice on 2020/2/17.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICCourseListModel.h"

@implementation HICCourseListModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if([key isEqualToString:@"id"]){
        self.chapterDetailId = value;
    }
}
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"chapterDetailId":@"id"};
}
@end
