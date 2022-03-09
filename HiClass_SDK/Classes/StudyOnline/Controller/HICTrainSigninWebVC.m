//
//  HICTrainSigninWebVC.m
//  HiClass
//
//  Created by WorkOffice on 2020/7/21.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import "HICTrainSigninWebVC.h"

@interface HICTrainSigninWebVC ()

@end

@implementation HICTrainSigninWebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString * urlStr = [NSString stringWithFormat:@"%@/mweb/index.html?trainId=%@&attendanceTaskId=%@#/signin", APP_Web_DOMAIN, _trainId, _taskId];
      [HiWebViewManager addParentVC:self urlStr:urlStr isDelegate:YES isPush:YES hideCusNavi:YES hideCusTabBar:YES];
}

@end
