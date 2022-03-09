//
//  HICAuthorModel.m
//  HiClass
//
//  Created by WorkOffice on 2020/2/14.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICAuthorModel.h"

@implementation HICAuthorModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if([key isEqualToString:@"id"]){
        self.authorID = value;
    }
}
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"authorID":@"id"};
}
@end
