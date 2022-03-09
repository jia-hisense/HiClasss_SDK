//
//  HICMyCommentsModel.m
//  HiClass
//
//  Created by WorkOffice on 2020/5/21.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import "HICMyCommentsModel.h"

@implementation HICMyCommentsModel
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"commentId":@"id"};
}
@end

@implementation HICMyCommentsObjectModel
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"commentObjectId":@"id"};
}
@end
