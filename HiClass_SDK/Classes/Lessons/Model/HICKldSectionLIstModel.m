//
//  HICKldSectionLIstModel.m
//  HiClass
//
//  Created by WorkOffice on 2020/2/17.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICKldSectionLIstModel.h"

@implementation HICKldSectionLIstModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if([key isEqualToString:@"id"]){
        self.chapterId = value;
    }
}
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"chapterId":@"id"};
}
@end
