//
//  HICChildMineVC.m
//  HiClass
//
//  Created by Eddie Ma on 2020/2/20.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICChildMineVC.h"
#import "HICMyCommentsView.h"
#import "HICCustomNaviView.h"
@interface HICChildMineVC ()<HICCustomNaviViewDelegate>
@property (nonatomic, strong)HICMyCommentsView *commentsView;
@property (nonatomic, strong)HICCustomNaviView *navi;
@end

@implementation HICChildMineVC
- (HICMyCommentsView *)commentsView{
    if (!_commentsView) {
        _commentsView = [[HICMyCommentsView alloc]initWithFrame:CGRectMake(0, 44 + HIC_StatusBar_Height, HIC_ScreenWidth, HIC_ScreenHeight - 44 - HIC_StatusBar_Height - HIC_BottomHeight)];
    }
    return _commentsView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BACKGROUNG_COLOR;
//    UIApplication.sharedApplication.statusBarStyle = UIStatusBarStyleLightContent;
    [self createNavi];
    [self.view addSubview:self.commentsView];
}
// 建立自定义导航栏
- (void)createNavi {
     self.navi = [[HICCustomNaviView alloc] initWithTitle:NSLocalizableString(@"myComments", nil) rightBtnName:nil showBtnLine:YES];
    _navi.delegate = self;
    [self.view addSubview:_navi];
}
#pragma mark - - - HICCustomNaviViewDelegate  - - -
- (void)leftBtnClicked {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
