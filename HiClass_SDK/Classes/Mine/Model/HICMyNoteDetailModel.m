//
//  HICMyNoteDetailModel.m
//  HiClass
//
//  Created by WorkOffice on 2020/3/26.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICMyNoteDetailModel.h"

@implementation HICMyNoteDetailModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if([key isEqualToString:@"id"]){
        self.noteId = value;
    }
}
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"noteId":@"id"};
}
@end
