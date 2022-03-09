//
//  HICMyRecordModel.m
//  HiClass
//
//  Created by WorkOffice on 2020/2/24.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICMyRecordModel.h"

@implementation HICMyRecordModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if([key isEqualToString:@"id"]){
        self.recordId = value;
    }
}
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"recordId":@"id"};
}
@end
