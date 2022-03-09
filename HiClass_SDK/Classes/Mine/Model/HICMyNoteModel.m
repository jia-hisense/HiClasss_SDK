//
//  HICMyNoteModel.m
//  HiClass
//
//  Created by WorkOffice on 2020/2/24.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICMyNoteModel.h"

@implementation HICMyNoteModel
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
