//
//  HICTrainManager.m
//  HiClass
//
//  Created by WorkOffice on 2020/3/5.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICTrainManager.h"

@implementation HICTrainManager
+ (instancetype)shared {
    static HICTrainManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}
@end
