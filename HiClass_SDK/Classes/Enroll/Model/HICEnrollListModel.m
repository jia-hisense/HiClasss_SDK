//
//  HICEnrollListModel.m
//  HiClass
//
//  Created by WorkOffice on 2020/6/4.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import "HICEnrollListModel.h"

@implementation HICEnrollListModel
+(NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"enrollId" : @"id",@"enrollDesc":@"description"};
}

@end
