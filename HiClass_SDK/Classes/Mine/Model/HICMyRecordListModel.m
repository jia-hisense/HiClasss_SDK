//
//  HICMyRecordListModel.m
//  HiClass
//
//  Created by WorkOffice on 2020/3/16.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICMyRecordListModel.h"

@implementation HICMyRecordListModel
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
