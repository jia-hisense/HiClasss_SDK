//
//  UIAlertController+Rotation.m
//  HiClass
//
//  Created by 铁柱， on 2020/12/23.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import "UIAlertController+Rotation.h"
@implementation UIAlertController (Rotation)
- (BOOL)shouldAutorotate
{
    return NO;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAll;
}
@end
