//
//  HICHomePostDetailVC.m
//  iTest
//
//  Created by Sir_Jing on 2020/3/18.
//  Copyright © 2020 Sir_Jing. All rights reserved.
//

#import "HICHomePostDetailVC.h"

#import "HICPostRequireVCView.h"
#import "HICTrainDetailVC.h"

#import "HICPostMapDetailReqModel.h"
#import "HICTrainDetailBaseModel.h"
#import "HICSyncProgressPopview.h"

@interface HICHomePostDetailVC ()
@property (nonatomic, strong) HICPostMapDetailReqModel *model;
@property (nonatomic, strong) UIView *rightAlertBut; // 同步学习进度
@property (nonatomic, assign) BOOL isShowAlertBut;
@property (nonatomic, strong) UIBarButtonItem *rightItem;
@property (nonatomic, strong) HICTrainDetailVC *trainDetailVC;
@end

@implementation HICHomePostDetailVC

#pragma mark - 生命周期
- (void)viewDidLoad {
    self.isCustomer = YES;
    [super viewDidLoad];
    
    self.isMenuEqualWidth = YES;
    _isShowAlertBut = NO;
    [self createNavigationBar];
    self.isAgainView = YES;
    [self loadData];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController.navigationBar setBarTintColor:UIColor.whiteColor];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [self.navigationController setNavigationBarHidden:YES];
}

#pragma mark - 创建View
- (void)setUpAllChildViewController {
    for (NSInteger i = 0; i < 2; i++) {
        UIViewController *vc;
        if (i == 0) {
            vc = [HICPostRequireVCView new];
            HICPostRequireVCView *req = (HICPostRequireVCView *)vc;
            req.model = self.model;
            vc.title = NSLocalizableString(@"postRequirements", nil);
        }else {
            vc = [HICTrainDetailVC new];
            HICTrainDetailVC *detail = (HICTrainDetailVC *)vc;
            detail.trainId = [NSNumber numberWithInteger:self.model.trainId];
            detail.isMapPush = YES;
            detail.postId = self.postLineId;
            detail.wayId = [NSNumber numberWithInteger:self.wayId];
            self.trainDetailVC = detail;
            __weak typeof(self) weakSelf = self;
            detail.block = ^(BOOL isSync) {
                if (isSync) {
                    weakSelf.navigationItem.rightBarButtonItem = weakSelf.rightItem;
                    [weakSelf showSyncProgressToast];
                }
            };
            vc.title = NSLocalizableString(@"learningPlan", nil);
        }

        [self addChildViewController:vc];
    }

    // 设置
    [self setUpDisplayStyle:^(UIColor *__autoreleasing *titleScrollViewBgColor, UIColor *__autoreleasing *norColor, UIColor *__autoreleasing *selColor, UIColor *__autoreleasing *proColor, UIFont *__autoreleasing *titleFont, BOOL *isShowProgressView, BOOL *isOpenStretch, BOOL *isOpenShade) {
        *selColor = [UIColor colorWithRed:3/255.0 green:179/255.0 blue:204/255.0 alpha:1];
        *titleFont = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        *isShowProgressView = YES;

    }];
    // 设置指示条
    [self setUpProgressAttribute:^(CGFloat *progressLength, CGFloat *progressHeight) {
        *progressLength = 30.f;
        *progressHeight = 2.f;
    }];
    //创建标题栏
    [self createTitleViewAgain];
    //设置选中的index
    [self setSelectIndex:1];

}
// 2. 创建顶部状态栏
- (void)createNavigationBar {
    UIImage *image = [[UIImage imageNamed:@"返回"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStyleDone target:self action:@selector(clickLeftBarItem:)];
    self.navigationItem.leftBarButtonItem = leftItem;

    UIImage *rightImage = [[UIImage imageNamed:@"更多"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:rightImage style:UIBarButtonItemStyleDone target:self action:@selector(clickRightBarItem:)];
    self.rightItem = rightItem;

    self.title = self.titleName;
}

- (void)showSyncProgressToast {
    BOOL hadShow = [[NSUserDefaults standardUserDefaults] boolForKey:hadShowPostSyncProgressToastKey];
    if (hadShow) {
        return;
    }
    // 显示同步进度提示
    HICSyncProgressPopview *syncView = [[HICSyncProgressPopview alloc] initWithFrame:self.view.bounds from:HICSyncProgressPagePostDetail];
    [self.view addSubview:syncView];
    [syncView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - 网络请求
-(void)loadData {
    if (!USER_CID) { return; }
    [HICAPI postRequirement:self.trainPostId success:^(NSDictionary * _Nonnull responseObject) {
        self.model = [HICPostMapDetailReqModel mj_objectWithKeyValues:responseObject[@"data"]];
        [self setUpAllChildViewController];
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)getRightAlertLoadData {
    [HICAPI getRightAlertLoadData:[NSNumber numberWithInteger:26] success:^(NSDictionary * _Nonnull responseObject) {
        HICTrainDetailBaseModel *baseModel = [HICTrainDetailBaseModel mj_objectWithKeyValues:responseObject[@"data"]];
        if (baseModel.syncProgress == 1) {
            self.navigationItem.rightBarButtonItem = self.rightItem;
            [self showSyncProgressToast];
        }
    }];
}

- (void)syncProgress{
    [HICAPI syncProgress:[NSNumber numberWithInteger:self.model.trainId] success:^(NSDictionary * _Nonnull responseObject) {
        if (responseObject[@"data"]) {
            NSInteger i = [responseObject[@"data"] integerValue];
            if (i == 1) {
                [HICToast showWithText:NSLocalizableString(@"synchronousSuccess", nil)];
                self.trainDetailVC.isReload = YES;
            }else {
                [HICToast showWithText:NSLocalizableString(@"donNotNeedSynchronize", nil)];
            }
        }
    } failure:^(NSError * _Nonnull error) {
        [HICToast showWithText:NSLocalizableString(@"synchronizationFailure", nil)];
    }];
}

#pragma mark - 页面事件处理
-(void)clickLeftBarItem:(UIBarButtonItem *)item {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)clickRightBarItem:(UIBarButtonItem *)item {
    _isShowAlertBut = !_isShowAlertBut;
    if (_isShowAlertBut) {
        [self.view addSubview:self.rightAlertBut];
    }else {
        [self.rightAlertBut removeFromSuperview];
    }
}
-(void)clickRightAlertBut:(UIButton *)but {
    _isShowAlertBut = NO;
    [self.rightAlertBut removeFromSuperview];
    [self syncProgress]; // 更新进度
}

#pragma mark - 懒加载
-(UIView *)rightAlertBut {
    if (!_rightAlertBut) {
        _rightAlertBut = [[UIButton alloc] initWithFrame:CGRectMake(HIC_ScreenWidth-113-10, HIC_NavBarAndStatusBarHeight, 100, 50)];
//        _rightAlertBut.layer.cornerRadius = 4.f;
//        _rightAlertBut.layer.masksToBounds = YES;
        _rightAlertBut.layer.shadowColor = [UIColor blackColor].CGColor;
        _rightAlertBut.layer.shadowOpacity = 0.6;
        _rightAlertBut.layer.shadowOffset = CGSizeZero;
        UIButton *but = [[UIButton alloc] initWithFrame:_rightAlertBut.bounds];
        [but setTitle:NSLocalizableString(@"synchronousProgress", nil) forState:UIControlStateNormal];
        [but setTitleColor:TEXT_COLOR_DARK forState:UIControlStateNormal];
        but.titleLabel.font = FONT_MEDIUM_16;
        but.backgroundColor = UIColor.whiteColor;
        but.layer.cornerRadius = 4.f;
        but.layer.masksToBounds = YES;
        [but addTarget:self action:@selector(clickRightAlertBut:) forControlEvents:UIControlEventTouchUpInside];
        [_rightAlertBut addSubview:but];
    }
    return _rightAlertBut;
}

@end
