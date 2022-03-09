//
//  HICLiveDetailVC.m
//  HiClass
//
//  Created by hisense on 2020/8/18.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import "HICLiveDetailVC.h"
#import "HomeTaskCenterDefaultView.h"
//#import <YSSDK/YSSDKManager.h>
@interface HICLiveDetailVC ()<HICCustomNaviViewDelegate>//
@property (nonatomic ,strong)HomeTaskCenterDefaultView *defaultView;
//@property (nonatomic ,strong)YSSDKManager *ysManager;
@end

@implementation HICLiveDetailVC
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    SystemManager.allowRotation = YES;
    self.tabBarController.tabBar.hidden = YES;

}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = NO;
    SystemManager.allowRotation = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.ysManager = [YSSDKManager sharedInstance];
//    [self.ysManager registerManagerDelegate:self];
    [self createNavi];
    [self initSDK];
}
- (void)createNavi {
    HICCustomNaviView *navi = [[HICCustomNaviView alloc] initWithTitle:NSLocalizableString(@"liveManagement", nil) rightBtnName:nil showBtnLine:NO];
    navi.delegate = self;
//    [self.view addSubview:navi];
}
- (void)initSDK {
//    __weak __typeof(self) weakSelf = self;
//       [weakSelf.ysManager joinRoomWithRoomId:_roomId nickName:USER_CID roomPassword:nil userId:nil userParams:nil];
    
}
-(HomeTaskCenterDefaultView *)defaultView{
    if (!_defaultView) {
        _defaultView = [[HomeTaskCenterDefaultView alloc]initWithFrame:CGRectMake(0, HIC_NavBarAndStatusBarHeight, 0, HIC_ScreenHeight - HIC_NavBarAndStatusBarHeight)];
    }
    return _defaultView;
}
- (void)leftBtnClicked{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
