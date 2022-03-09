//
//  HICExamRecordModel.m
//  HiClass
//
//  Created by Eddie Ma on 2020/1/21.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICExamRecordModel.h"

@implementation HICExamRecordModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if([key isEqualToString:@"id"]){
        self.examRecordID = value;
    }
}
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"examRecordID":@"id"};
}
@end
