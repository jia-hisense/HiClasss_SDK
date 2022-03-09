//
//  HICNoteInfoModel.m
//  HiClass
//
//  Created by WorkOffice on 2020/2/24.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICNoteInfoModel.h"

@implementation HICNoteInfoModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if([key isEqualToString:@"id"]){
        self.noteInfoId = value;
    }
}
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"noteInfoId":@"id"};
}
@end
