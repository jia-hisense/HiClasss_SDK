//
//  HICBaseTabBarViewController.m
//  HiClass
//
//  Created by wangggang on 2019/12/31.
//  Copyright © 2019 jingxianglong. All rights reserved.
//

#import "HICBaseTabBarViewController.h"

@interface HICBaseTabBarViewController ()

@end

@implementation HICBaseTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (BOOL)shouldAutorotate {
    return self.selectedViewController.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return self.selectedViewController.supportedInterfaceOrientations;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
     return UIInterfaceOrientationPortrait;
}


@end
