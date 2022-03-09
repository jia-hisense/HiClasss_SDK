//
//  HICPushCustoWebVC.m
//  HiClass
//
//  Created by 铁柱， on 2020/3/25.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICPushCustoWebVC.h"

@interface HICPushCustoWebVC ()<HomeWebViewVCDelegate>

@end

@implementation HICPushCustoWebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *url = self.urlStr;
    if (!url) {
        url = @"http://www.baidu.com";
    }

    if (_isCompanyUrl) {
        [HiWebViewManager addParentVC:self urlStr:url isDelegate:YES isPush:YES hideCusNavi:YES hideCusTabBar:YES];
    }else {
        [HiWebViewManager addParentVC:self urlStr:url isDelegate:YES isPush:YES hideCusNavi:YES isThirdUrl:YES hideCusTabBar:YES ];
    }

}


@end
