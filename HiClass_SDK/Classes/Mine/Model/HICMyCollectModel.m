//
//  HICMyCollectModel.m
//  HiClass
//
//  Created by WorkOffice on 2020/2/24.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICMyCollectModel.h"

@implementation HICMyCollectModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if([key isEqualToString:@"id"]){
        self.collectId = value;
    }
}
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"collectId":@"id"};
}
@end
