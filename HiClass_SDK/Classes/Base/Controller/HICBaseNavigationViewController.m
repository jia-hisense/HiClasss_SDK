//
//  HICBaseNavigationViewController.m
//  HiClass
//
//  Created by wangggang on 2019/12/31.
//  Copyright © 2019 jingxianglong. All rights reserved.
//

#import "HICBaseNavigationViewController.h"

@interface HICBaseNavigationViewController ()

@end

@implementation HICBaseNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (UIViewController *)childViewControllerForStatusBarStyle{
    return self.topViewController;
}
-(UIViewController *)childViewControllerForStatusBarHidden{
    return self.topViewController;
}

- (BOOL)shouldAutorotate {
    return self.topViewController.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return self.topViewController.supportedInterfaceOrientations;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

@end
