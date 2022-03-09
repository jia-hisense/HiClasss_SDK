//
//  HICExamBaseInfoModel.m
//  HiClass
//
//  Created by WorkOffice on 2020/2/19.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICExamBaseInfoModel.h"

@implementation HICExamBaseInfoModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if([key isEqualToString:@"id"]){
        self.examID = value;
    }
}
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"examID":@"id"};
}
@end
