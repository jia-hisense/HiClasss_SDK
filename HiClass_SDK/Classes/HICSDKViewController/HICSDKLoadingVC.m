//
//  HICSDKWLodaingVC.m
//  HiClass_SDK
//
//  Created by 铁柱， on 2020/8/28.
//  Copyright © 2020 铁柱，. All rights reserved.
//

#import "HICSDKLoadingVC.h"

@interface HICSDKLoadingVC ()<HICCustomNaviViewDelegate>

@end

@implementation HICSDKLoadingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavi];
}
- (void)createNavi {
    HICCustomNaviView *navi = [[HICCustomNaviView alloc] initWithTitle:@"学堂" rightBtnName:nil showBtnLine:NO];
    navi.delegate = self;
    [self.view addSubview:navi];
}
- (void)leftBtnClicked {
    [HICSDKManager.shared backApp];
}


@end
