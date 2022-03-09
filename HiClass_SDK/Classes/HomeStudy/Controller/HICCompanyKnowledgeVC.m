//
//  HICCompanyKnowledgeVC.m
//  iTest
//
//  Created by Sir_Jing on 2020/3/11.
//  Copyright © 2020 Sir_Jing. All rights reserved.
//

#import "HICCompanyKnowledgeVC.h"

#import "CompanyKnowledgeMenuView.h"
#import "HomeTaskCenterDefaultView.h"

#import "HomeStudyListCell.h"

#import "HICCompanyKnowledgeModel.h"
#import "HICCompanyMenuModel.h"

#import "HICSearchDetailVC.h"

@interface HICCompanyKnowledgeVC ()<UITableViewDataSource, UITableViewDelegate, HomeStudyBaseCellDelegate, CompanyKnowledgeMenuViewDelegate>

/// 菜单筛选
@property (nonatomic, strong) CompanyKnowledgeMenuView *menuView;

@property (nonatomic, strong) UITableView *tableView;
/// 列表数组 -- 企业知识
@property (nonatomic, strong) NSMutableArray *listDataSource;
/// 菜单栏筛选 -- 课程分类
@property (nonatomic, strong) NSArray *menuDataSource;
/// 缺省页面
@property (nonatomic, strong) HomeTaskCenterDefaultView *defaultView;

// 筛选条件
@property (nonatomic, assign) NSInteger resourceType; // 0-图片，1-视频，2-音频，3-文档，4-压缩包，5-scrom,6-html, 7-课程

@property (nonatomic, copy) NSString *allDirID; // 记录进入时的dirID，这样选择全部时可以继续使用

@property (nonatomic, assign) NSInteger pageIndex;

@end

@implementation HICCompanyKnowledgeVC

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.whiteColor;
            
    // 设置初始数据 -- 因为可以从0开始所以 负值代表全选
    _resourceType = -1;
    _pageIndex = 0;
    if ([NSString isValidStr:_isOnleVideo] && [_isOnleVideo isEqualToString:@"1"]) {
        _resourceType = 1;
    }
    _allDirID = self.dirId;

    _listDataSource = [NSMutableArray array];
    [self createNavigationBarItem];
    [self.tableView registerClass:HomeStudyListCell.class forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.defaultView];
    self.defaultView.hidden = YES;
    if (!self.isHiddenNav) {
        [self.view addSubview:self.menuView];
    }

    [self loadDataList];
    [self loadDataMenu];
    
    // 增加刷新机制
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf.listDataSource removeAllObjects];
        [weakSelf.tableView reloadData];
        weakSelf.pageIndex = 0;
        [weakSelf loadDataList];
    }];

    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        // 加载更多数据
        weakSelf.pageIndex++;
        [weakSelf loadDataList];
    }];
    self.tableView.mj_footer = footer;

}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:NO];
//    if (@available(iOS 13.0, *)) {
//        self.navigationController.navigationBar.standardAppearance.backgroundColor = UIColor.whiteColor;
//    } else {
//        // Fallback on earlier versions
//    }
    [self.navigationController.navigationBar setBarTintColor:UIColor.whiteColor];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [self.navigationController setNavigationBarHidden:YES];
}

#pragma mark - 自定义视图
-(void)createNavigationBarItem {
    UIImage *image = [[UIImage imageNamed:@"返回"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStyleDone target:self action:@selector(clickLeftBarItem:)];
    self.navigationItem.leftBarButtonItem = leftItem;

    UIImage *imageRight = [[UIImage imageNamed:@"BT-搜索"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:imageRight style:UIBarButtonItemStyleDone target:self action:@selector(clickRightBarItem:)];
    self.navigationItem.rightBarButtonItem = rightItem;

//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(100, 0, HIC_ScreenWidth-200, 44)];
//    view.backgroundColor = [UIColor whiteColor];
//    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, HIC_ScreenWidth-200, 44)];
//    title.textColor = UIColor.blackColor;
//    title.textAlignment = NSTextAlignmentCenter;
//    title.font = [UIFont systemFontOfSize:20];
//    title.text = @"企业知识";
//    [view addSubview:title];
//    self.navigationItem.titleView = view;
    if (!self.title || [self.title isEqualToString:@""]) {
        self.title = NSLocalizableString(@"enterpriseKnowledge", nil);
    }
}

#pragma mark - 视图处理事件
// 导航栏返回
-(void)clickLeftBarItem:(UIBarButtonItem *)item {
    [self.navigationController popViewControllerAnimated:YES];
}
// 导航栏搜索
-(void)clickRightBarItem:(UIBarButtonItem *)item {
    [self.navigationController pushViewController:HICSearchDetailVC.new animated:YES];
}

#pragma mark - 网络数据请求
-(void)loadDataList {

    self.defaultView.hidden = YES;
    NSMutableDictionary *mDic = [NSMutableDictionary dictionaryWithDictionary:@{@"pageNum":[NSNumber numberWithInteger:_pageIndex], @"pageSize":@50, @"orderBy":[NSNumber numberWithInteger:_orderBy]}];
    if (_resourceType != -1) {
        [mDic setValue:[NSNumber numberWithInteger:_resourceType] forKey:@"resourceType"];
    }
    if (_dirId != nil) {
        [mDic setValue:_dirId forKey:@"dirId"];
    }
    [HICAPI queryCourseKnowledgeContent:mDic success:^(NSDictionary * _Nonnull responseObject) {
        HICCompanyKnowledgeModel *model = [HICCompanyKnowledgeModel createModelWithSourceData:responseObject];
        [self.listDataSource addObjectsFromArray:model.content];
        [self.tableView reloadData];
        if (self.listDataSource.count == 0) {
            self.defaultView.hidden = NO;
        }
        if (model.content.count == 0) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            if (self.pageIndex>0) {
                self.pageIndex--;
            }
        }else {
            [self.tableView.mj_footer endRefreshing];
        }
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSError * _Nonnull error) {
        if (self.pageIndex>0) {
            self.pageIndex--;
        }
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
    }];
}

-(void)loadDataMenu {
    [HICAPI directoryQuery:self.dirId success:^(NSDictionary * _Nonnull responseObject) {
        self.menuDataSource = [HICCompanyMenuModel createModelWithSourceData:responseObject];
        self.menuView.dataSource = self.menuDataSource;
        [RoleManager hiddenWindowLoadingView];
        if (self.menuDataSource.count == 0) {
            self.menuView.isHiddenSoreView = YES;
        }
    } failure:^(NSError * _Nonnull error) {
        self.menuView.isHiddenSoreView = YES;
        [RoleManager hiddenWindowLoadingView];
    }];
}

#pragma mark - TableDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.listDataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeStudyBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.cellIndexPath = indexPath;
    cell.companyKnoledgeModel = self.listDataSource[indexPath.row];
    cell.delegate = self;

    return cell;
}

#pragma mark - Cell协议方法
-(void)studyCell:(HomeStudyBaseCell *)cell knoledgeModel:(HSCourseKLD *)model other:(id)data {

    // 知识的跳转
    DDLogDebug(@"----跳转知识详情----");
    PushViewControllerModel *pushModel = [[PushViewControllerModel alloc] init];
    pushModel.pushType = model.courseKLDType;
    pushModel.detailID = model.courseKLDId;
    pushModel.studyResourceType = model.resourceType;
    HICStudyLogReportModel *reportModel = [[HICStudyLogReportModel alloc]initWithType:HICAllKnowledgeClick];
    reportModel.mediaid = [NSNumber numberWithInteger:model.courseKLDId];
    reportModel.knowtype = [NSNumber numberWithInteger:model.resourceType];
    reportModel.mediatype = [NSNumber numberWithInteger:model.courseKLDType];
    NSMutableDictionary *report = [NSMutableDictionary dictionaryWithDictionary:[reportModel getParamDict]];
    [report setValuesForKeysWithDictionary:[LogManager getSerLogEventDictWithType:HICAllKnowledgeClick]];
    [LogManager reportSerLogWithDict:report];
    [HICPushViewManager parentVC:self pushVCWithModel:pushModel];
}

#pragma mark - menuViewDelegate
-(void)menuView:(CompanyKnowledgeMenuView *)view changeMenuItemWith:(NSInteger)soreId andSoreStrId:(NSString *)soreStr selectType:(NSInteger)type selectTime:(NSInteger)time {
    if ([NSString isValidStr:soreStr]) {
        self.dirId = soreStr;
    }else {
        self.dirId = _allDirID;
    }
    self.resourceType = type;
    self.orderBy = time;
    [self.listDataSource removeAllObjects];
    [self.tableView reloadData];
    [self loadDataList];
}

#pragma mark - 懒加载
-(CompanyKnowledgeMenuView *)menuView {
    if (!_menuView) {
        CGFloat screenWidth = UIScreen.mainScreen.bounds.size.width;
//        CGFloat screenHeight = UIScreen.mainScreen.bounds.size.height;
        UIApplication *manager = UIApplication.sharedApplication;
        CGFloat statusH = manager.statusBarFrame.size.height;
        _menuView = [[CompanyKnowledgeMenuView alloc] initWithFrame:CGRectMake(0, statusH+44, screenWidth, 40)];
        [_menuView addContentViewWithParentView:self.view];
        _menuView.delegate = self;
        if ([NSString isValidStr:self.isOnleVideo] && [self.isOnleVideo isEqualToString:@"1"]) {
            _menuView.isNotEnableTypeClick = YES;
        }
    }
    return _menuView;
}

-(UITableView *)tableView {
    if (!_tableView) {
        CGFloat screenWidth = UIScreen.mainScreen.bounds.size.width;
        CGFloat screenHeight = UIScreen.mainScreen.bounds.size.height;
        UIApplication *manager = UIApplication.sharedApplication;
        CGFloat statusH = manager.statusBarFrame.size.height;
        CGFloat top = _isHiddenNav?statusH+44:statusH+44+40;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, top, screenWidth, screenHeight - (statusH+44+40)-HIC_BottomHeight) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 95.f;
        _tableView.tableFooterView = UIView.new;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0;
        }
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

-(HomeTaskCenterDefaultView *)defaultView {
    if (!_defaultView) {
        CGFloat top = _isHiddenNav?HIC_StatusBar_Height+44:HIC_StatusBar_Height+44+40;
        _defaultView = [[HomeTaskCenterDefaultView alloc] initWithFrame:CGRectMake(0, top, HIC_ScreenWidth, HIC_ScreenHeight-top-HIC_BottomHeight)];
        _defaultView.titleStr = NSLocalizableString(@"temporarilyNoData", nil);
    }
    return _defaultView;
}

@end
