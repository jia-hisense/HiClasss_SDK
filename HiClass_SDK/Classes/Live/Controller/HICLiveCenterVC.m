//
//  HICLiveCenterVC.m
//  HiClass
//
//  Created by hisense on 2020/8/18.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import "HICLiveCenterVC.h"
#import "HICLiveListModel.h"
#import "HICLiveLessonListVC.h"
#import <YSLiveSDK/YSSDKManager.h>

#define btnW  HIC_ScreenWidth / 4
#define btnH  30
#define GetAppDelegate ((AppDelegate *)[[UIApplication sharedApplication] delegate])
@interface HICLiveCenterVC ()<HICCustomNaviViewDelegate,UIScrollViewDelegate,HICLiveLessonListDelegate,YSSDKDelegate>

@property (nonatomic ,copy) UIScrollView *titleView;
@property (nonatomic ,strong) NSMutableArray *titleArr;
@property (nonatomic ,strong) UIView *underLine;
@property (nonatomic ,assign) NSInteger currentIndex;
@property (nonatomic ,strong) UIScrollView *contentView;
@property (nonatomic ,strong) NSMutableArray *titleBtnArr;
@property (nonatomic ,strong) HICNetModel *netModel;
@property (nonatomic, strong) NSMutableArray<HICLiveLessonListVC *> *listVCArr;
@property (nonatomic ,assign) BOOL isBack;
@property (nonatomic ,strong) YSSDKManager *ysManager;
@end

@implementation HICLiveCenterVC
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
    SystemManager.allowRotation = NO;
    [self getNum];
    [self.listVCArr.firstObject getLessonList];
    [self setItemSelected:self.currentIndex];
    self.contentView.contentOffset = CGPointMake(LiveManager.contentSizeW, 0);
    [self reportEnteredLiveCenter];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    SystemManager.allowRotation = NO;
    LiveManager.contentSizeW = self.isBack ? 0 : self.contentView.contentOffset.x;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    [self createNavi];
    [self createTitleView];
    [self createContentView];
    self.currentIndex = 0;
    [self initSDKManager];
    
}

- (void)initSDKManager {
    self.ysManager = [YSSDKManager sharedInstance];
    [self.ysManager registerManagerDelegate:self];
}

- (void)createNavi {
    HICCustomNaviView *navi = [[HICCustomNaviView alloc] initWithTitle:NSLocalizableString(@"liveManagement", nil)
                                                          rightBtnName:nil showBtnLine:NO];
    if (_isTab) {
        navi.hideLeftBtn = YES;
        self.tabBarController.tabBar.hidden = NO;
    }else{
        self.tabBarController.tabBar.hidden = YES;
        navi.hideLeftBtn = NO;
    }
    navi.delegate = self;
    [self.view addSubview:navi];
}
- (void)createTitleView {
    self.titleView.backgroundColor = UIColor.whiteColor;
    self.titleView.pagingEnabled = YES;
    self.titleView.showsHorizontalScrollIndicator = NO;
    self.titleView.delegate = self;
    self.titleView.contentSize = CGSizeMake(btnW *self.titleArr.count, 0);
    [self.view addSubview:self.titleView];
    for (int i = 0; i < self.titleArr.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i;
        if(i == 0){
            [btn setTitleColor:[UIColor colorWithHexString:@"#00BED7"] forState:UIControlStateNormal];
        }else{
            [btn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
        }
        btn.backgroundColor = UIColor.whiteColor;
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn setTitleColor:[UIColor colorWithHexString:@"#00BED7"] forState:UIControlStateSelected];
        [btn setTitle:self.titleArr[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.frame = CGRectMake( i * btnW, 6, btnW, btnH);
        [self.titleView addSubview:btn];
        [self.titleBtnArr addObject:btn];
    }
    self.underLine.backgroundColor = [UIColor colorWithHexString:@"#00BED7"];
    [self.view addSubview:self.underLine];
    
}
- (void)createContentView {
    [self.view addSubview:self.contentView];
}
- (void)getNum {
    if (NetManager.netStatus == HICNetUnknown || NetManager.netStatus == HICNetNotReachable) {
        return;
    }
    [HICAPI getLiveStateNum:^(NSDictionary * _Nonnull responseObject) {
        if ([responseObject[@"data"] isKindOfClass:[NSArray class]]) {
            NSMutableArray *statusArr = [HICLiveStatusModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            if (statusArr.count > 0) {
                for (int i = 0; i < statusArr.count; i++) {
                    HICLiveStatusModel *model = statusArr[i];
                    if (model.status == HICLiveWait) {
                        if (model.count > 0) {
                            NSString *num = [NSString stringWithFormat:@"%@%@", NSLocalizableString(@"waitStart", nil),[NSString stringWithFormat:@"(%ld)",(long)model.count]];
                            [self.titleArr replaceObjectAtIndex:1 withObject:num];
                        }else{
                            [self.titleArr replaceObjectAtIndex:1 withObject:NSLocalizableString(@"waitStart", nil)];
                        }
                        
                    }else if (model.status == HICLiveInProgress){
                        if (model.count > 0) {
                            NSString *num = [NSString stringWithFormat:@"%@%@",NSLocalizableString(@"ongoing", nil), [NSString stringWithFormat:@"(%ld)",(long)model.count]];
                            [self.titleArr replaceObjectAtIndex:0 withObject:num];
                        }else{
                            [self.titleArr replaceObjectAtIndex:0 withObject:NSLocalizableString(@"ongoing", nil)];
                        }
                    }else if (model.status == HICLiveEnd){
                        if (model.count > 0) {
                            NSString *num = [NSString stringWithFormat:@"%@%@", NSLocalizableString(@"hasEnded", nil),[NSString stringWithFormat:@"(%ld)",(long)model.count]];
                            [self.titleArr replaceObjectAtIndex:2 withObject:num];
                        }else{
                            [self.titleArr replaceObjectAtIndex:2 withObject:NSLocalizableString(@"hasEnded", nil)];

                        }
                    }
                }
                [self.titleView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                [self.titleView removeFromSuperview];
                [self createTitleView];
                [self changeItemSelectLine:self.currentIndex];
            }
            [self.titleView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [self.titleView removeFromSuperview];
            [self createTitleView];
            [self changeItemSelectLine:self.currentIndex];
        }
    }];
}

- (void)btnClick:(UIButton *)btn {
    CGFloat offsetX = btn.center.x - HIC_ScreenWidth * 0.5;
    //  计算偏移量
    if (offsetX < 0) offsetX = 0;
    // 获取最大滚动范围
    CGFloat maxOffsetX = self.titleView.contentSize.width - HIC_ScreenWidth;
    if (offsetX > maxOffsetX) offsetX = maxOffsetX;
    // 滚动标题滚动条
    self.contentView.contentOffset = CGPointMake(btn.tag * HIC_ScreenWidth, 0);
    [self setItemSelected:btn.tag];
}
- (void)changeItemSelectLine:(NSInteger)index {
    for (int i = 0; i < self.titleBtnArr.count; i ++) {
        UIButton *btn = self.titleBtnArr[i];
        if (btn.tag == index) {
            [btn setTitleColor:[UIColor colorWithHexString:@"#00BED7"] forState:UIControlStateNormal];
            self.underLine.centerX = btn.centerX;
        } else {
            [btn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
        }
    }
}
- (void)setItemSelected:(NSInteger)index{
    [self changeItemSelectLine:index];
    self.currentIndex = index;
    index = index + 1;
    [self getNum];

    [self.listVCArr[self.currentIndex] getLessonList];
}

- (void)reportEnteredLiveCenter { //通过Tabbar进入时上报（通过push上报见HICPushViewManager）
    UIViewController *fromViewController = [[[self navigationController] transitionCoordinator] viewControllerForKey:UITransitionContextFromViewControllerKey];
    if (![[self.navigationController viewControllers] containsObject:fromViewController] && !self.presentedViewController) {
        DDLogDebug(@"reportEnteredLiveCenter");
        [HICLogManager.shared reportSerLogWithType:HICLiveCenter params:nil];
    }
}
#pragma mark progressDelegate
- (void)initLiveSDKWithRoomNumber:(NSString *)roomNum{//1481996298
    __weak __typeof(self) weakSelf = self;
    DDLogDebug(@"dhksaljdhasljkdh%@",USER_NAME);
    [self.ysManager checkRoomTypeBeforeJoinRoomWithRoomId:roomNum success:^(YSSDKUseTheType roomType, BOOL needpassword) {
        SystemManager.allowRotation = YES;
        [weakSelf.ysManager joinRoomWithRoomId:roomNum nickName:USER_NAME roomPassword:nil userId:USER_CID userParams:nil];
    } failure:^(NSInteger code, NSString * _Nonnull errorStr) {
        SystemManager.allowRotation = NO;
        DDLogDebug(@"code:%@, message: %@", @(code), errorStr);
    }];
}
- (void)initLiveSDKWithRoomNumberA:(NSString *)roomNum {
    __weak __typeof(self) weakSelf = self;
    SystemManager.allowRotation = YES;
    [weakSelf.ysManager joinRoomWithRoomId:roomNum nickName:USER_NAME roomPassword:nil userId:USER_CID userParams:nil];
}
- (void)initLiveSDKWithRoomNumberW:(NSString *)roomNum {
    __weak __typeof(self) weakSelf = self;
    SystemManager.allowRotation = YES;
    [weakSelf.ysManager joinRoomWithRoomId:roomNum nickName:USER_NAME roomPassword:nil userId:USER_CID userParams:nil];
}
- (void)onRoomReportFail:(YSSDKErrorCode)errorCode descript:(NSString *)descript {
    [HICToast showWithText:descript];
}
#pragma mark -scrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat offSetX = scrollView.contentOffset.x;
    NSInteger pageNum = offSetX / HIC_ScreenWidth;
    [self setItemSelected:pageNum];
}

- (void)leftBtnClicked {
    self.isBack = YES;
    SystemManager.allowRotation = NO;
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark ----lazyload
- (NSMutableArray *)listVCArr {
    if (!_listVCArr) {
        _listVCArr = [NSMutableArray array];
        NSArray *listTypes = @[@(HICLiveLessonListInProgress), @(HICLiveLessonListWait), @(HICLiveLessonListEnded), @(HICLiveLessonListAll)];
        for (int i = 0; i < listTypes.count; i++) {
            HICLiveLessonListVC *listVC = [[HICLiveLessonListVC alloc] initWithType:[listTypes[i] integerValue]];
            listVC.view.frame = CGRectMake(HIC_ScreenWidth * i, 0, HIC_ScreenWidth, HIC_ScreenHeight - HIC_NavBarAndStatusBarHeight - 44 - (self.isTab ? HIC_TabBarHeight : 0));
            [self addChildViewController:listVC];
            listVC.delegate = self;
            [self.contentView addSubview:listVC.view];
            [listVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView).offset(HIC_ScreenWidth * i);
                make.height.mas_equalTo(HIC_ScreenHeight - HIC_NavBarAndStatusBarHeight - 44 - (self.isTab ? HIC_TabBarHeight : 0));
                make.width.top.equalTo(self.contentView);
            }];
            __weak __typeof(self) weakSelf = self;
            listVC.getLiveNumBlock = ^{
                [weakSelf getNum];
            };
            [_listVCArr addObject:listVC];
        }
    }
    return _listVCArr;
}
- (NSMutableArray *)titleArr {
    if(!_titleArr){
        _titleArr = [NSMutableArray arrayWithArray:@[NSLocalizableString(@"ongoing", nil),NSLocalizableString(@"waitStart", nil),NSLocalizableString(@"hasEnded", nil),NSLocalizableString(@"all", nil)]];
    }
    return _titleArr;
}
- (UIScrollView *)titleView {
    if (!_titleView) {
        _titleView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, HIC_NavBarAndStatusBarHeight, HIC_ScreenWidth, 44)];
    }
    return _titleView;
}
- (NSMutableArray *)titleBtnArr {
    if (!_titleBtnArr) {
        _titleBtnArr  = [[NSMutableArray alloc]init];
    }
    return _titleBtnArr;
}
- (UIView *)underLine {
    if (!_underLine) {
        _underLine = [[UIView alloc]initWithFrame:CGRectMake((btnW - 30 )/2, 42 + HIC_NavBarAndStatusBarHeight, 30, 2.5)];
    }
    return _underLine;
}

- (UIScrollView *)contentView {
    if (!_contentView) {
        _contentView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, HIC_NavBarAndStatusBarHeight + 44, HIC_ScreenWidth, HIC_ScreenHeight - HIC_NavBarAndStatusBarHeight - 44 - (self.isTab ? HIC_TabBarHeight : 0))];
        _contentView.pagingEnabled = YES;
        _contentView.bounces = NO;
        _contentView.showsHorizontalScrollIndicator = NO;
        _contentView.contentSize = CGSizeMake(HIC_ScreenWidth * 4, 0);
        _contentView.scrollEnabled = YES;
        _contentView.backgroundColor = [UIColor colorWithHexString:@"#E9E9E9"];
        _contentView.delegate = self;
        _contentView.userInteractionEnabled = YES;
        _contentView.alwaysBounceVertical = NO;
    }
    return _contentView;
}

@end
