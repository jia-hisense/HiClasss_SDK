//
//  UIAlertController+Rotation.h
//  HiClass
//
//  Created by 铁柱， on 2020/12/23.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIAlertController (Rotation)
- (BOOL)shouldAutorotate;
- (UIInterfaceOrientationMask)supportedInterfaceOrientations;
@end

NS_ASSUME_NONNULL_END
