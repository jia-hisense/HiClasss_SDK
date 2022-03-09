//
//  HICLectureCourseModel.m
//  HiClass
//
//  Created by hisense on 2020/5/13.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import "HICLectureCourseModel.h"
#import "NSString+String.h"

@implementation HICLectureCourseModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"list" : @"HICLectureCourseSubModel"};
}
@end

@implementation HICLectureCourseSubModel

- (NSString *)resClassName {
    if ([NSString isValidString:_resClassName]) {
        return _resClassName;
    }
    return @"";
}

@end
