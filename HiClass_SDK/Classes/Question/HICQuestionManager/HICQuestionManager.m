//
//  HICQuestionManager.m
//  HiClass
//
//  Created by WorkOffice on 2020/6/8.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import "HICQuestionManager.h"

@implementation HICQuestionManager
+ (instancetype)shared {
    static HICQuestionManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}
@end
