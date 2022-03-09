//
//  HICContributorModel.m
//  HiClass
//
//  Created by WorkOffice on 2020/2/14.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICContributorModel.h"

@implementation HICContributorModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if([key isEqualToString:@"id"]){
        self.customerId = value;
    }
}
+(NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"courseID":@"id"};
}
@end
