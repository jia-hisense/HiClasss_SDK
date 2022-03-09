//
//  HICEnrollDetailModel.m
//  HiClass
//
//  Created by WorkOffice on 2020/6/8.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import "HICEnrollDetailModel.h"

@implementation HICEnrollDetailModel
+(NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"registerId" : @"id"};
}
@end
