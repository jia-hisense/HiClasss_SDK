//
//  HICLectureDetailModel.m
//  HiClass
//
//  Created by WorkOffice on 2020/3/12.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICLectureDetailModel.h"

@implementation HICLectureDetailModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if([key isEqualToString:@"id"]){
        self.lectureId = value;
    }
}
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"lectureId":@"id"};
}
@end
