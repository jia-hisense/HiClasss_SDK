//
//  UIViewController+HICExtension.m
//  HiClass
//
//  Created by jiafujia on 2021/11/19.
//  Copyright © 2021 hisense. All rights reserved.
//

#import "UIViewController+HICExtension.h"

@implementation UIViewController (HICExtension)

- (BOOL)isNaviRoot {
    return self.navigationController.viewControllers.firstObject == self;
}

@end
