//
//  HICHomeTaskCenterVC.m
//  iTest
//
//  Created by Sir_Jing on 2020/3/15.
//  Copyright © 2020 Sir_Jing. All rights reserved.
//

#import "HICHomeTaskCenterVC.h"

#import "HomeTaskCenterShowView.h"
#import "HomeTaskCenterDefaultView.h"
#import "HICEnrollDetailVC.h"
#import "HTCExaminationCell.h"  // 考试
#import "HTCTrainCell.h"        // 培训
#import "HTCSignUpCell.h"       // 报名 -- 可能用不到
#import "HTCQuestionnaireCell.h"// 问卷
#import "HTCTableViewCell.h"          // 直播
#import "HICExamBaseVC.h"
#import "HICOnlineTrainVC.h"
#import "HICHomeTaskCenterModel.h"
#import "HICTaskCneterVC.h"

#import "OfflineTrainPlanListVC.h" // 线下培训安排
#import "HICOfflineTrainInfoVC.h" // 培训详情
#import "HICMixTrainArrangeMapVC.h"
#import "HICQuestionVC.h"
#import "HICEnrollCenterVC.h"
#import "HICMixTrainArrangeVC.h"
#import "HICNotEnrollTrainArrangeVC.h"
#import "HICLiveCenterVC.h"
#import <YSLiveSDK/YSSDKManager.h>
#define TaskCenterVCTag 4000000

@interface HICHomeTaskCenterVC ()<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, HomeTaskCenterShowViewDelegate,YSSDKDelegate>{
    NSArray *_quickNameArray;
    NSArray *_quickImageArray;
}
// 进入功能提示页面
@property (nonatomic, strong) HomeTaskCenterShowView *showView;

// 缺省页面
@property (nonatomic, strong) NSArray<HomeTaskCenterDefaultView *> *defaultViews;

// 页面标题 -- 快捷背景
@property (nonatomic, strong) UILabel *vcTitleLabel;
@property (nonatomic, strong) UIView *quickButBackView;
@property (nonatomic, strong) NSMutableArray<UILabel *> *quickButNumLabels;

// 选择按钮
@property (nonatomic, strong) NSMutableArray<UIButton *> *selectButs;
@property (nonatomic, strong) NSMutableArray<UIView *> *selectLines;
@property (nonatomic, strong) UIView *selectBackView;

// 选择内容
@property (nonatomic, strong) UIScrollView *scrollContentView;
@property (nonatomic, strong) NSMutableArray<UITableView *> *contentTableViews;

// 当前选中的内容情况数据
@property (nonatomic, assign) NSInteger isSelectIndex;
@property (nonatomic, strong) NSArray *doDataSource;  // 进行中的数据
@property (nonatomic, strong) NSArray *willDataSource;// 即将开始的数据
@property (nonatomic, assign) NSInteger type;
@property (nonatomic ,strong) YSSDKManager *ysManager;
@end

@implementation HICHomeTaskCenterVC

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
//    _quickNameArray = @[@"考试中心", @"培训管理", @"报名", @"问卷", @"清缓存", @"知识课程"];
    _quickNameArray = @[NSLocalizableString(@"testCenter", nil), NSLocalizableString(@"trainingManagement", nil), NSLocalizableString(@"signUp", nil), NSLocalizableString(@"questionnaire", nil),NSLocalizableString(@"live", nil)];//, @"清缓存", @"知识课程"];
    _quickImageArray = @[@"考试中心",@"培训管理",@"报名",@"问卷",@"直播大图标"];
    _quickButNumLabels = [NSMutableArray array];
    _selectButs = [NSMutableArray array];
    _selectLines = [NSMutableArray array];
    _contentTableViews = [NSMutableArray array];
    _isSelectIndex = 0;
    self.doDataSource = @[];
    self.willDataSource = @[];

    self.view.backgroundColor = UIColor.whiteColor;
    [self createNativeUI];
    [self createQuickButUI];
    [self createSelectUI];
    [self createSelectContentUI];
    [self createDefaultView];

    // 2. 第一次进入时显示showView
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"TaskCenterShowView"]) {
        [self showJoinView];
    }
    [self initSDKManager];
}

- (void)initSDKManager{
     self.ysManager = [YSSDKManager sharedInstance];
    [self.ysManager registerManagerDelegate:self];
//    self.ysManager.useAppDelegateAllowRotation = SystemManager.allowRotation;
}

- (void)viewWillAppear:(BOOL)animated {
    if (!self.navigationController.isNavigationBarHidden) {
        self.navigationController.navigationBarHidden = YES;
    }
    if (self.showView.hidden) {
        self.tabBarController.tabBar.hidden = NO;
    }
    // 3. 网络请求数据
    [self loadData];
}

#pragma mark - 创建页面
// 1. 创建导航栏 -- 应该增加返回按钮(待添加)
- (void)createNativeUI {
    CGFloat nativeHeight = 32 - 20 + HIC_StatusBar_Height + 25;
    UIView *nativeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, HIC_ScreenWidth, nativeHeight)];
    [self.view addSubview:nativeView];

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, nativeHeight - 25, HIC_ScreenWidth-100*2, 25)];
    titleLabel.text = NSLocalizableString(@"taskCenter", nil);
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
    [nativeView addSubview:titleLabel];

    self.vcTitleLabel = titleLabel; // 方便设置ViewTitle
}
// 2. 创建功能按键
-(void)createQuickButUI {
    CGFloat top = self.vcTitleLabel.frame.origin.y + self.vcTitleLabel.bounds.size.height + 30;
    UIView *quiceButBackView = [[UIView alloc] init];
    [self.view addSubview:quiceButBackView];

    CGFloat BtnHeight = (HIC_ScreenWidth - 16*2 - 23*4)/5;
    CGFloat leftMargin = [[HICCommonUtils iphoneType] isEqualToString:@"l-iPhone"] ? 1.5 * 16 : 16;
    CGFloat BtnInterval = 23;

    UIScrollView *taskSV = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, HIC_ScreenWidth, TC_SECTION1_HEIGHT - 88)];
    taskSV.contentSize = CGSizeMake(BtnHeight * _quickNameArray.count + BtnInterval * (_quickNameArray.count - 1) + 2 * leftMargin, TC_SECTION1_HEIGHT - 88);
    taskSV.scrollEnabled = _quickNameArray.count > 5 ? YES : NO;
    taskSV.showsHorizontalScrollIndicator = NO;
    taskSV.showsVerticalScrollIndicator = NO;
    taskSV.pagingEnabled = NO;
    taskSV.bounces = NO;
    [quiceButBackView addSubview:taskSV];

    for(int i = 0; i < _quickNameArray.count; i++){
        UIButton *taskBtn = [[UIButton alloc]initWithFrame:CGRectMake(leftMargin + i * BtnInterval + i * BtnHeight, 0, BtnHeight, BtnHeight)];
        taskBtn.backgroundColor = [UIImage imageNamed:_quickImageArray[i]] ? [UIColor clearColor] : [UIColor redColor];
        [taskBtn addTarget:self action:@selector(taskBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [taskBtn setImage:[UIImage imageNamed:_quickImageArray[i]] forState:UIControlStateNormal];
        [taskBtn setTitle:_quickNameArray[i] forState:UIControlStateNormal];
        [taskBtn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        taskBtn.layer.masksToBounds = YES;
        taskBtn.layer.cornerRadius = BtnHeight/2;
        [taskBtn setClipsToBounds:YES];
        [taskSV addSubview:taskBtn];

        CGSize taskNameLabelSize = [HICCommonUtils sizeOfString:_quickNameArray[i] stringWidthBounding:HIC_ScreenWidth font:15 stringOnBtn:NO fontIsRegular:YES];
        CGFloat taskNameLabelX = leftMargin + BtnHeight/2 + i * BtnHeight + i * BtnInterval - 40;
        UILabel *taskNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(taskNameLabelX, 8 + BtnHeight, 80, taskNameLabelSize.height)];
        taskNameLabel.text = _quickNameArray[i];
        taskNameLabel.font = FONT_REGULAR_15;
        taskNameLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1/1.0];
        taskNameLabel.textAlignment = NSTextAlignmentCenter;
        [taskSV addSubview:taskNameLabel];
    }
    quiceButBackView.frame = CGRectMake(0, top, HIC_ScreenWidth, BtnHeight + 21 + 8);
    self.quickButBackView = quiceButBackView;
}

- (void)taskBtnClicked:(UIButton *)btn {
    HICStudyLogReportModel *reportModel = [[HICStudyLogReportModel alloc]initWithType:HICTaskCenterTaskType];
    if ([btn.titleLabel.text isEqualToString:NSLocalizableString(@"testCenter", nil)]) {
        HICExamBaseVC *vc = [[HICExamBaseVC alloc] init];
        ///日志上报
        reportModel.tasktype = [NSNumber numberWithInteger:HICReportExamType];
        NSMutableDictionary *report = [NSMutableDictionary dictionaryWithDictionary:[reportModel getParamDict]];
        [report setValuesForKeysWithDictionary:[LogManager getSerLogEventDictWithType:HICTaskCenterTaskType]];
        [LogManager reportSerLogWithDict:report];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([btn.titleLabel.text isEqualToString:NSLocalizableString(@"trainingManagement", nil)]) {
        HICOnlineTrainVC *vc = [[HICOnlineTrainVC alloc] init];
        reportModel.tasktype = [NSNumber numberWithInteger:HICReportTrainType];
        NSMutableDictionary *report = [NSMutableDictionary dictionaryWithDictionary:[reportModel getParamDict]];
        [report setValuesForKeysWithDictionary:[LogManager getSerLogEventDictWithType:HICTaskCenterTaskType]];
        [LogManager reportSerLogWithDict:report];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([btn.titleLabel.text isEqualToString:NSLocalizableString(@"signUp", nil)]) {
        HICEnrollCenterVC *vc = HICEnrollCenterVC.new;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([btn.titleLabel.text isEqualToString:NSLocalizableString(@"questionnaire", nil)]) {
        HICQuestionVC *vc = [[HICQuestionVC alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([btn.titleLabel.text isEqualToString:NSLocalizableString(@"clearCache", nil)]) {
        // 暂时加入，方便测试
        NSString *kFilePath = @"filePath";
        NSString *kFileSize = @"fileSize";
        NSMutableArray *cacheFileArr = [[NSMutableArray alloc]init];
        NSString *cacheDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        float folderSize = 0;
        if ([fileManager fileExistsAtPath:cacheDir]) {
            NSArray *childerFiles = [fileManager subpathsAtPath:cacheDir];
            for (NSString *fileName in childerFiles) {
                NSString *absolutePath = [cacheDir stringByAppendingPathComponent:fileName];
                float fileSize = [self fileSizeAtPath:absolutePath];
                NSNumber *fileSizeObj = [NSNumber numberWithFloat:fileSize];
                folderSize += fileSize;
                NSDictionary *cacheFileDic = [[NSDictionary alloc] initWithObjectsAndKeys:absolutePath, kFilePath, fileSizeObj, kFileSize, nil];
                [cacheFileArr addObject:cacheFileDic];
            }
        }
        
        NSFileManager *fileManager2 = [NSFileManager defaultManager];
        for (NSDictionary *cacheFileDic in cacheFileArr) {
            NSString *absolutePath = cacheFileDic[kFilePath];
            [fileManager2 removeItemAtPath:absolutePath error:nil];
        }
        [HICToast showWithText:NSLocalizableString(@"clearSuccess", nil)];
    } else if ([btn.titleLabel.text isEqualToString:NSLocalizableString(@"knowledgeCourse", nil)]) {
        HICTaskCneterVC *vc = [[HICTaskCneterVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([btn.titleLabel.text isEqualToString:NSLocalizableString(@"live", nil)]) {
        if ([RoleManager.showTabBarMenus containsObject:@"LiveF"]) {
            NSInteger index = [RoleManager.showTabBarMenus indexOfObject:@"LiveF"];
            if (index < self.tabBarController.childViewControllers.count) {
                [self.tabBarController setSelectedIndex:index];
            }
        }else{
            PushViewControllerModel *model = [PushViewControllerModel new];
            model.pushType = 1012;
            [HICPushViewManager parentVC:self pushVCWithModel:model];
        }
    }
}

- (float)fileSizeAtPath:(NSString *)path {
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:path]){
        long long size=[fileManager attributesOfItemAtPath:path error:nil].fileSize;
        return size/1024.0;
    }
    return 0;
}

// 3. 创建选中UI
- (void)createSelectUI {
    CGFloat screenWidth = UIScreen.mainScreen.bounds.size.width;
    CGFloat top = self.quickButBackView.frame.origin.y + self.quickButBackView.bounds.size.height + 16;
    UIView *selectView = [[UIView alloc] initWithFrame:CGRectMake(0, top, screenWidth, 44)];
    CGFloat selectWidth = 100;
    self.selectBackView = selectView;

    NSArray *name = @[[NSString stringWithFormat:@"%@(0)",NSLocalizableString(@"ongoing", nil)], [NSString stringWithFormat:@"%@(0)",NSLocalizableString(@"waitStart", nil)]];
    for (NSInteger i = 0; i < name.count; i++) {
        UIView *view = [self createSelectViewWith:CGRectMake(12 +(selectWidth+5)*i, 11.5, selectWidth, 32.5) titleName:name[i] tag:i];
        [selectView addSubview:view];
    }

    [self.view addSubview:selectView];
}

- (UIView *)createSelectViewWith:(CGRect)frame titleName:(NSString *)name tag:(NSInteger)tag {
    UIView *backView = [[UIView alloc] initWithFrame:frame];

    UIButton *selectBut = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 21)];
    [selectBut setTitle:name forState:UIControlStateNormal];
    [selectBut setTitleColor:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1] forState:UIControlStateNormal];
    [selectBut setTitleColor:[UIColor colorWithRed:3/255.0 green:179/255.0 blue:204/255.0 alpha:1] forState:UIControlStateSelected];
    [selectBut setTitleColor:[UIColor colorWithRed:3/255.0 green:179/255.0 blue:204/255.0 alpha:0.6] forState:UIControlStateSelected | UIControlStateHighlighted];
    selectBut.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    [_selectButs addObject:selectBut];
    if (tag == 0) {
        selectBut.selected = YES;
    }
    [selectBut addTarget:self action:@selector(clickSelectBut:) forControlEvents:UIControlEventTouchUpInside];

    UIView *selectLineView = [[UIView alloc] initWithFrame:CGRectMake(42, 9 + 21, 16, 2.5)];
    selectLineView.backgroundColor = [UIColor colorWithRed:3/255.0 green:179/255.0 blue:204/255.0 alpha:1];
    selectLineView.hidden = YES;
    [_selectLines addObject:selectLineView];
    if (tag == 0) {
        selectLineView.hidden = NO;
    }

    [backView addSubview:selectBut];
    [backView addSubview:selectLineView];

    return backView;
}

// 4. 创建底部选择内容View
- (void)createSelectContentUI {
    CGFloat top = self.selectBackView.frame.origin.y + self.selectBackView.bounds.size.height;
    CGFloat screenWidth = self.selectBackView.bounds.size.width;
    CGFloat screenHeight = UIScreen.mainScreen.bounds.size.height;
    UIScrollView *scrollContentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, top, screenWidth, screenHeight-top)];
    self.scrollContentView = scrollContentView;

    for (NSInteger i = 0; i < 2; i++) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0+screenWidth*i, 0, screenWidth, screenHeight-top) style:UITableViewStylePlain];
        tableView.backgroundColor = UIColor.whiteColor;
        tableView.dataSource = self;
        tableView.delegate = self;
        [scrollContentView addSubview:tableView];
        tableView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
        [self.contentTableViews addObject:tableView];
        tableView.tableFooterView = [UIView new];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.estimatedRowHeight = 100;
        tableView.rowHeight = UITableViewAutomaticDimension;

        [tableView registerClass:HTCExaminationCell.class forCellReuseIdentifier:@"ExaminationCell"];
        [tableView registerClass:HTCTrainCell.class forCellReuseIdentifier:@"TrainCell"];
        [tableView registerClass:HTCSignUpCell.class forCellReuseIdentifier:@"SignUpCell"];
        [tableView registerClass:HTCQuestionnaireCell.class forCellReuseIdentifier:@"QuestionnaireCell"];
        [tableView registerClass:HTCTableViewCell.class forCellReuseIdentifier:@"LiveCell"];
        if (@available(iOS 15.0, *)) {
            tableView.sectionHeaderTopPadding = 0;
        }
        // 增加刷新机制
        tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self loadData];
        }];
    }

    scrollContentView.contentSize = CGSizeMake(screenWidth*2, 0);
    scrollContentView.showsHorizontalScrollIndicator = NO;
    scrollContentView.pagingEnabled = YES;
    scrollContentView.delegate = self;
    [self.view addSubview:scrollContentView];
}

// 5. 显示ShowView
- (void)showJoinView {
    self.tabBarController.tabBar.hidden = YES;
    self.showView.hidden = NO;
    [self.view addSubview:self.showView];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"TaskCenterShowView"];
}

// 6. 创建defaultView
- (void)createDefaultView {
    HomeTaskCenterDefaultView *view1 = [[HomeTaskCenterDefaultView alloc] initWithFrame:self.contentTableViews.firstObject.frame];
    HomeTaskCenterDefaultView *view2 = [[HomeTaskCenterDefaultView alloc] initWithFrame:self.contentTableViews.lastObject.frame];

    self.defaultViews = @[view1, view2];
}

#pragma mark - 页面事件处理
// 点击快捷按钮
-(void)clickQuickBut:(UIButton *)btn {
    NSInteger tag = btn.tag - TaskCenterVCTag;

    DDLogDebug(@"--- %ld ---", (long)tag);
}

// 点击选择but --- 切换都会走下边两个方法
-(void)clickSelectBut:(UIButton *)but {
     NSInteger index = 0;
    for (NSInteger i = 0; i < _selectButs.count; i++) {
        if (but == _selectButs[i]) {
            [_selectButs[i] setSelected:YES];
            _selectLines[i].hidden = NO;
            index = i;
            self.type = i;
        }else {
            [_selectButs[i] setSelected:NO];
            _selectLines[i].hidden = YES;
        }
    }
    for (UITableView *tableview in self.contentTableViews) {
        CGPoint offset = tableview.contentOffset;
         (tableview.contentOffset.y > 0) ? offset.y-- : offset.y++;
        [tableview setContentOffset:offset animated:NO];
    }

    // 当前选中的是哪个but
    CGFloat width = UIScreen.mainScreen.bounds.size.width;
    self.scrollContentView.contentOffset = CGPointMake(width*index, 0);
    _isSelectIndex = index;
    [self.contentTableViews[_isSelectIndex] reloadData];
}
// 改变选中的but -- 滑动切换会走
-(void)changeSelectBut:(UIButton *)but {
    for (NSInteger i = 0; i < _selectButs.count; i++) {
        if (but == _selectButs[i]) {
            [_selectButs[i] setSelected:YES];
            _selectLines[i].hidden = NO;
            _isSelectIndex = i;
        }else {
            [_selectButs[i] setSelected:NO];
            _selectLines[i].hidden = YES;
        }
    }
    [self.contentTableViews[_isSelectIndex] reloadData];
}

#pragma mark - 网络加载
-(void)loadData {
    for (int i = 0; i < self.contentTableViews.count; i ++) {
        UITableView *tableView = self.contentTableViews[i];
        HomeTaskCenterDefaultView *view = self.defaultViews[i];
        view.frame = CGRectMake(0, 0, HIC_ScreenWidth, self.scrollContentView.frame.size.height);
        view.hidden = YES;
        [tableView addSubview:view];
    }

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self requestTaskCenterList];
    });
}

- (void)requestTaskCenterList {
    NSMutableDictionary *dic  = [[NSMutableDictionary alloc] init];
    [dic setValue:@(0) forKey:@"listFlag"];
    [dic setValue:USER_CID forKey:@"customerId"];
    [HICAPI taskList:dic success:^(NSDictionary * _Nonnull responseObject) {
        self.doDataSource = [HICHomeTaskCenterModel createModelWithSourceData:responseObject name:@"inProgressList"];
        self.willDataSource = [HICHomeTaskCenterModel createModelWithSourceData:responseObject name:@"todoList"];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.doDataSource.count > 0) {
                UIButton *btn = _selectButs.firstObject;
                NSString *btnTitle = [NSString stringWithFormat:@"%@(%ld)", NSLocalizableString(@"ongoing", nil),(long)self.doDataSource.count ];
                [btn setTitle:btnTitle forState:UIControlStateNormal];
                
            }else{
                HomeTaskCenterDefaultView *view = self.defaultViews.firstObject;
                self.doDataSource = @[];
                view.hidden = NO;
            }
            if (self.willDataSource.count > 0) {
                UIButton *btn = _selectButs.lastObject;
                NSString *btnTitle = [NSString stringWithFormat:@"%@(%ld)",NSLocalizableString(@"waitStart", nil),(long)self.willDataSource.count ];
                [btn setTitle:btnTitle forState:UIControlStateNormal];
            }else{
                HomeTaskCenterDefaultView *view = self.defaultViews.lastObject;
                self.willDataSource = @[];
                view.hidden = NO;
            }
            for (int i = 0; i < self.contentTableViews.count; i ++) {
                UITableView *tableView = self.contentTableViews[i];
                [tableView reloadData];
                [tableView.mj_header endRefreshing];
            }
        });
    } failure:^(NSError * _Nonnull error) {
        DDLogDebug(@"error");
        for (int i = 0; i < self.contentTableViews.count; i ++) {
            UITableView *tableView = self.contentTableViews[i];
            [tableView reloadData];
            [tableView.mj_header endRefreshing];
        }
    }];
}


#pragma mark - ScrollerViewDelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView != self.scrollContentView) {
        return;
    }
    CGPoint point = scrollView.contentOffset;
    CGFloat width = UIScreen.mainScreen.bounds.size.width;

    NSInteger index = point.x/width;

    switch (index) {
        case 0:
            [self changeSelectBut:_selectButs.firstObject];
            break;
        case 1:
            [self changeSelectBut:_selectButs.lastObject];
            break;
        default:
            break;
    }
}

#pragma mark TableDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (_isSelectIndex == 0 && tableView == self.contentTableViews.firstObject) {
        return self.doDataSource.count;
    }else if (_isSelectIndex == 1 && tableView == self.contentTableViews.lastObject) {
        return self.willDataSource.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    HomeTaskCenterBaseCell *cell;

    NSArray *temArr;
    if (_isSelectIndex == 0) {
        temArr = self.doDataSource;
    } else {
        temArr = self.willDataSource;
    }
    if (!temArr || [temArr isEqual:@[]]) {
        return [tableView dequeueReusableCellWithIdentifier:@"ExaminationCell" forIndexPath:indexPath];
    }
    if (temArr.count - 1 >= indexPath.row) {
        HICHomeTaskCenterModel *model = temArr[indexPath.row];
        switch (model.taskType) {
            case HICTaskTypeExam:
                cell = [tableView dequeueReusableCellWithIdentifier:@"ExaminationCell" forIndexPath:indexPath];
                break;
            case HICTaskTypeTrain:
                cell = [tableView dequeueReusableCellWithIdentifier:@"TrainCell" forIndexPath:indexPath];
                break;
            case HICTaskTypeQuestionnaire:
                cell = [tableView dequeueReusableCellWithIdentifier:@"QuestionnaireCell" forIndexPath:indexPath];
                break;
            case HICTaskTypeEnroll:
                cell = [tableView dequeueReusableCellWithIdentifier:@"SignUpCell" forIndexPath:indexPath];
                break;
            case HICTaskTypeLive:
                cell = [tableView dequeueReusableCellWithIdentifier:@"LiveCell" forIndexPath:indexPath];
                break;
            default:
                cell = [tableView dequeueReusableCellWithIdentifier:@"QuestionnaireCell" forIndexPath:indexPath];
                break;
        }
        cell.model = model;
    }
    if (_isSelectIndex == 1) {
        cell.isWillDo = YES;
    }else {
        cell.isWillDo = NO;
    }

    return cell;
}

#pragma mark - TableDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *temArr;
    if (_isSelectIndex == 0) {
        temArr = self.doDataSource;
    } else {
        temArr = self.willDataSource;
    }
    HICHomeTaskCenterModel *tModel = [[HICHomeTaskCenterModel alloc] init];
    if (temArr.count -1 >= indexPath.row) {
        tModel = temArr[indexPath.row];
    }
    if ([HICCommonUtils isValidObject:tModel]) {
        ///日志上报
           HICStudyLogReportModel *reportModel = [[HICStudyLogReportModel alloc]initWithType:HICTaskClick];

        if (tModel.taskType == 1) { // 考试
            PushViewControllerModel *model = [[PushViewControllerModel alloc] initWithPushType:4 urlStr:[NSString stringWithFormat:@"%ld", (long)tModel.taskId] detailId:tModel.taskId studyResourceType:HICHtmlType pushType:0];
            reportModel.mediaid = [NSNumber numberWithInteger:tModel.taskId];
            reportModel.tasktype = [NSNumber numberWithInteger:HICReportExamType];
            if (self.type == 0) {
                reportModel.taskstatus = NSLocalizableString(@"haveBegunTo", nil);
            }else{
                reportModel.taskstatus = NSLocalizableString(@"notStarted", nil);
            }
            reportModel.trainmode = @-1;
            [self reportWithModel:reportModel];
            [HICPushViewManager parentVC:self pushVCWithModel:model];
        } else if (tModel.taskType == 2) { // 培训
            reportModel.mediaid = [NSNumber numberWithInteger:tModel.taskId];
            reportModel.tasktype = [NSNumber numberWithInteger:HICReportTrainType];
            reportModel.trainmode = [NSNumber numberWithInteger:tModel.trainType];
            if (self.type == 0) {
                reportModel.taskstatus = NSLocalizableString(@"ongoing", nil);
            }else{
                reportModel.taskstatus = NSLocalizableString(@"waitStart", nil);
            }
            [self reportWithModel:reportModel];
            if (tModel.trainType == 1) {
                PushViewControllerModel *model = [[PushViewControllerModel alloc] initWithPushType:12 urlStr:nil detailId:tModel.taskId studyResourceType:HICHtmlType pushType:0];
                [HICPushViewManager parentVC:self pushVCWithModel:model];
            }else if (tModel.trainType == 2) {
                // 线下培训
                 PushViewControllerModel *model = [[PushViewControllerModel alloc] initWithPushType:122 urlStr:nil detailId:tModel.taskId studyResourceType:HICHtmlType pushType:0];
                model.registChannel = tModel.registChannel;
                model.workId = tModel.registerTrainId;
                if (_isSelectIndex == 0) {
                    // 进行中的
//                    OfflineTrainPlanListVC *ct = [[OfflineTrainPlanListVC alloc] init];
//                    ct.trainId = tModel.taskId;
//                    ct.isShowRightMore = YES;
//                    [self.navigationController pushViewController:ct animated:YES];
                    model.childType = 1; // 培训安排页面
                }else {
                    // 跳转到培训详情页面
//                    HICOfflineTrainInfoVC *vc = [HICOfflineTrainInfoVC new];
//                    vc.trainId = tModel.taskId;
//                    vc.isStarted = NO;
//                    [self.navigationController pushViewController:vc animated:YES];
                     model.childType = 0; // 培训详情页面
                }
                  [HICPushViewManager parentVC:self pushVCWithModel:model];
            }else{//混合培训
                if (_isSelectIndex == 0) {
                    // 进行中的
//                    HICMixTrainArrangeVC *ct = [[HICMixTrainArrangeVC alloc] init];
//                    ct.trainId = [NSNumber numberWithInteger:tModel.taskId];
//                    ct.registerId = [NSNumber numberWithInteger:tModel.registerTrainId];;
//                    [self.navigationController pushViewController:ct animated:YES];
                    
                    PushViewControllerModel *model = [[PushViewControllerModel alloc] initWithPushType:123 urlStr:nil detailId:tModel.taskId studyResourceType:HICHtmlType pushType:0];
                    if (tModel.registChannel == 1) {
                        model.workId = tModel.registerId.integerValue;
                    }
                    model.registChannel = tModel.registChannel;
                    model.mixTrainType = tModel.scene;
                    model.titleName = tModel.taskName;
                    [HICPushViewManager parentVC:self pushVCWithModel:model];
                }else {
                    // 跳转到培训详情页面
                    HICOfflineTrainInfoVC *vc = [HICOfflineTrainInfoVC new];
                    vc.trainId = tModel.taskId;
                    if (tModel.registChannel == 1) {
                         vc.registerActionId = tModel.registerId;
                    }
                    vc.isStarted = NO;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                
            }
        } else if (tModel.taskType == 3 || tModel.taskType == 5) { // 问卷
            NSString * urlStr = [NSString stringWithFormat:@"%@/mweb/index.html#/questionnaire?questionActionId=%ld",APP_Web_DOMAIN,(long)tModel.taskId];
            PushViewControllerModel *model = [[PushViewControllerModel alloc] initWithPushType:13 urlStr:urlStr detailId:tModel.taskId studyResourceType:HICHtmlType pushType:0];
            [HICPushViewManager parentVC:self pushVCWithModel:model];
        } else if (tModel.taskType == 4) { // 报名

            if (tModel.registerTrainId  == 0) {//独立报名
                HICEnrollDetailVC *vc = HICEnrollDetailVC.new;
                vc.registerID = [NSNumber numberWithInteger: tModel.taskId];
                [self.navigationController pushViewController:vc animated:YES];
            }else{
               // 跳转到培训详情页面
                HICOfflineTrainInfoVC *vc = [HICOfflineTrainInfoVC new];
                vc.trainId = tModel.registerTrainId;
                vc.registerActionId = [NSNumber numberWithInteger:tModel.taskId];
                vc.isRegisterJump = 1;
                if (_isSelectIndex == 0) {
                   vc.isStarted = YES;
                }else{
                     vc.isStarted = NO;
                }
                [self.navigationController pushViewController:vc animated:YES];
            }

        }else if (tModel.taskType == 6) { // 直播
            [self getRoomNumWithID:[NSNumber numberWithLong:tModel.taskId]];
        }
        
    }
}

- (void)getRoomNumWithID:(NSNumber *)lessonId{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [HICAPI getRoomNumWithID:lessonId success:^(NSDictionary * _Nonnull responseObject) {
            if (responseObject[@"data"][@"liveRoom"]) {
                HICLiveRoomModel *model = [HICLiveRoomModel mj_objectWithKeyValues:responseObject[@"data"][@"liveRoom"]];
                [self initLiveSDKWithRoomNumber:model.roomNum];
                if ([NSString isValidStr:model.roomNum] && [model.status integerValue] == 2) {
                    [self initLiveSDKWithRoomNumber:model.roomNum];
                } else {
                    [HICToast showWithText:NSLocalizableString(@"liveNotStartPrompt", nil)];
                }
            }else{
                [HICToast showWithText:NSLocalizableString(@"networkAnomaliesPrompt", nil)];
            }
        } failure:^(NSError * _Nonnull error) {
            [HICToast showWithText:NSLocalizableString(@"networkAnomaliesPrompt", nil)];
        }];
    });
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

- (void)reportWithModel:(HICStudyLogReportModel*)model{
    NSMutableDictionary *report = [NSMutableDictionary dictionaryWithDictionary:[model getParamDict]];
    [report setValuesForKeysWithDictionary:[LogManager getSerLogEventDictWithType:HICTaskClick]];
    [LogManager reportSerLogWithDict:report];
}
#pragma mark - 懒加载
-(HomeTaskCenterShowView *)showView {
    if (!_showView) {
        _showView = [[HomeTaskCenterShowView alloc] initWithFrame:UIScreen.mainScreen.bounds];
        _showView.delegate = self;
    }
    return _showView;
}

#pragma mark - - - HomeTaskCenterShowViewDelegate - - -
- (void)enter {
    self.tabBarController.tabBar.hidden = NO;
}

@end
