//
//  OfflineTrainPlanListVC.m
//  HiClass
//
//  Created by 铁柱， on 2020/4/15.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "OfflineTrainPlanListVC.h"

#import "OfflineTrainPlanListDetailVCView.h"
#import "HICOfflineTrainInfoVC.h"

@interface OfflineTrainPlanListVC ()

@property (nonatomic, strong) NSDictionary *dicData;

@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, strong) UIButton *rightMoreBut;

@property (nonatomic, strong) UIView *backDefaultView;

@property (nonatomic, strong) UIView *rightAlertBut;

@property (nonatomic, assign) BOOL isRefresh; // 是否在ViewWill中刷新数据

@end

@implementation OfflineTrainPlanListVC

- (void)viewDidLoad {
    self.isCustomer = YES;
    self.isAgainView = YES;
    [super viewDidLoad];
    // 初始化数据
//    self.signBackSources = [NSMutableArray array];
    _isRefresh = NO;

    // 设置标题 - 导航栏
    [self createNavView];
    [self loadData];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];

    if (self.isShowRightMore) {
        self.rightMoreBut.hidden = NO;
    }

    if (!_isRefresh) {
        _isRefresh = YES;
    }else {
        [self refreshLoadData];
    }
}

#pragma mark - 创建View
// 创建底部导航栏
-(void)createNavView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, HIC_StatusBar_Height, HIC_ScreenWidth, 44)];
    view.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:view];

    UIButton *leftBut = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [leftBut setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [leftBut addTarget:self action:@selector(clickLeftBut:) forControlEvents:UIControlEventTouchUpInside];
    leftBut.imageView.frame = CGRectMake(16, 11, 12, 22);

    UIButton *rightBut = [[UIButton alloc] initWithFrame:CGRectMake(HIC_ScreenWidth-44, 0, 44, 44)];
    [rightBut setImage:[UIImage imageNamed:@"更多"] forState:UIControlStateNormal];
    [rightBut addTarget:self action:@selector(clickRightBut:) forControlEvents:UIControlEventTouchUpInside];
    UIEdgeInsets insets = UIEdgeInsetsMake(10, 16, 10, 16);
    [rightBut setImageEdgeInsets:insets];
    rightBut.hidden = YES;
    self.rightMoreBut = rightBut;

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 0, HIC_ScreenWidth-90, 44)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = NSLocalizableString(@"trainingArrangement", nil);
    titleLabel.font = FONT_MEDIUM_18;

    [view addSubview:leftBut];
    [view addSubview:rightBut];
    [view addSubview:titleLabel];
}
// 设置菜单栏
- (void)setUpAllChildViewController
{
    NSArray *titles = @[NSLocalizableString(@"all", nil), NSLocalizableString(@"course", nil), NSLocalizableString(@"attendance", nil), NSLocalizableString(@"exam", nil), NSLocalizableString(@"homework", nil), NSLocalizableString(@"questionnaire", nil), NSLocalizableString(@"evaluation", nil), NSLocalizableString(@"offlineResults", nil)];
    for (NSInteger i = 0; i < titles.count; i++) {
        OfflineTrainPlanListDetailVCView *vc = [OfflineTrainPlanListDetailVCView new];
        vc.title = titles[i];
        if (i == 0) {
            vc.cellModel = [OfflineTrainListCellModel createModelWithRep:self.dicData];
        }else {
            OfflineTrainListCellModel *model = [OfflineTrainListCellModel createModelWithRep:self.dicData withType:i];
            vc.cellModel = model;
        }
        vc.trainId = self.trainId;
        vc.detailType = i;
        __weak typeof(self) weakSelf = self;
        vc.refreshBlock = ^(NSInteger index) {
            weakSelf.currentIndex = index;
            [weakSelf refreshLoadData];
        };
        [self addChildViewController:vc];
    }

    // 设置
    [self setUpDisplayStyle:^(UIColor *__autoreleasing *titleScrollViewBgColor, UIColor *__autoreleasing *norColor, UIColor *__autoreleasing *selColor, UIColor *__autoreleasing *proColor, UIFont *__autoreleasing *titleFont, BOOL *isShowProgressView, BOOL *isOpenStretch, BOOL *isOpenShade) {

        *selColor = [UIColor colorWithRed:3/255.0 green:179/255.0 blue:204/255.0 alpha:1];
        *titleFont = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        *isShowProgressView = YES;

    }];

    // 设置指示条
    [self setUpProgressAttribute:^(CGFloat *progressLength, CGFloat *progressHeight) {
        *progressLength = 16.f;
        *progressHeight = 2.5f;
    }];

    [self createTitleViewAgain];
    if (self.webSelectIndex < self.childViewControllers.count && self.webSelectIndex != 0) {
        self.selectIndex = self.webSelectIndex;
        self.webSelectIndex = 0; // 重置
    }
}

-(void)refreshData {
    NSInteger index = 0;
    for (OfflineTrainPlanListDetailVCView *vc in self.childViewControllers) {
        if (index == 0) {
            vc.cellModel = [OfflineTrainListCellModel createModelWithRep:self.dicData];
        }else {
            vc.cellModel = [OfflineTrainListCellModel createModelWithRep:self.dicData withType:index];
        }
        vc.trainId = self.trainId;
        [vc refreshData]; // 重新刷新数据 --- 
        index++;
    }

    if (self.currentIndex != 0) {
        self.selectIndex = self.currentIndex;
        self.currentIndex = 0; // 重置
    }

}

#pragma mark - 网络数据请求
-(void)loadData {
    [HICAPI trainingArrangement:_trainId success:^(NSDictionary * _Nonnull responseObject) {
        self.dicData = responseObject;
        [self setUpAllChildViewController];
    } failure:^(NSError * _Nonnull error) {
        self.backDefaultView.hidden = NO;
        [RoleManager showErrorViewWith:self.backDefaultView blcok:^(NSInteger type) {
            self.backDefaultView.hidden = YES;
            [self loadData]; // 重新刷新数据
        }];
    }];
}

-(void)refreshLoadData {
    [HICAPI trainingArrangement:_trainId success:^(NSDictionary * _Nonnull responseObject) {
        [RoleManager hiddenWindowLoadingView];
        self.dicData = responseObject;
        [self refreshData];
    } failure:^(NSError * _Nonnull error) {
        self.backDefaultView.hidden = NO;
        [RoleManager showErrorViewWith:self.backDefaultView blcok:^(NSInteger type) {
            self.backDefaultView.hidden = NO;
            [RoleManager showErrorViewWith:self.backDefaultView blcok:^(NSInteger type) {
                self.backDefaultView.hidden = YES;
                [self refreshLoadData]; // 重新刷新数据
            }];
        }];
    }];
}

#pragma mark - 页面点击事件
-(void)clickLeftBut:(UIButton *)but {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)clickRightBut:(UIButton *)but {
    // 显示弹出框
    if (self.rightAlertBut.isHidden) {
        [self.view addSubview:self.rightAlertBut];
        self.rightAlertBut.hidden = NO;
    }else {
        self.rightAlertBut.hidden = YES;
        [self.rightAlertBut removeFromSuperview];
    }

}

-(void)clickRightAlertBut:(UIButton *)but {
    // 点击右侧弹出按钮
    self.rightAlertBut.hidden = YES;
    [self.rightAlertBut removeFromSuperview];

    // 跳转到培训详情页面
    HICOfflineTrainInfoVC *vc = [HICOfflineTrainInfoVC new];
    vc.trainId = self.trainId;
    vc.isStarted = YES;
    vc.registerActionId = _registerId;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 懒加载
-(UIView *)backDefaultView {
    if (!_backDefaultView) {
        _backDefaultView = [[UIView alloc] initWithFrame:CGRectMake(0, HIC_NavBarAndStatusBarHeight, HIC_ScreenWidth, HIC_ScreenHeight-HIC_NavBarAndStatusBarHeight)];
        [self.view addSubview:_backDefaultView];
        _backDefaultView.hidden = YES;
    }
    return _backDefaultView;
}
-(UIView *)rightAlertBut {
    if (!_rightAlertBut) {
        _rightAlertBut = [[UIView alloc] initWithFrame:CGRectMake(HIC_ScreenWidth-113-10, HIC_NavBarAndStatusBarHeight, 100, 50)];
//        _rightAlertBut.layer.cornerRadius = 4.f;
//        _rightAlertBut.layer.masksToBounds = YES;
        _rightAlertBut.layer.shadowColor = [UIColor blackColor].CGColor;
        _rightAlertBut.layer.shadowOpacity = 0.2;
        _rightAlertBut.layer.shadowOffset = CGSizeZero;
        UIButton *but = [[UIButton alloc] initWithFrame:_rightAlertBut.bounds];
        [but setTitle:NSLocalizableString(@"trainingDetails", nil) forState:UIControlStateNormal];
        [but setTitleColor:TEXT_COLOR_DARK forState:UIControlStateNormal];
        but.titleLabel.font = FONT_MEDIUM_16;
        but.backgroundColor = UIColor.whiteColor;
        but.layer.cornerRadius = 4.f;
        but.layer.masksToBounds = YES;
        [but addTarget:self action:@selector(clickRightAlertBut:) forControlEvents:UIControlEventTouchUpInside];
        [_rightAlertBut addSubview:but];
        _rightAlertBut.hidden = YES;
    }
    return _rightAlertBut;
}

@end
