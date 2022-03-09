//
//  HICHomeStudyDetailView.m
//  iTest
//
//  Created by Sir_Jing on 2020/3/10.
//  Copyright © 2020 Sir_Jing. All rights reserved.
//

#import "HICHomeStudyDetailView.h"

#import "HICHomeStudyVC.h"
#import "HomeStudyBannerCell.h"
#import "HomeStudyQuickButCell.h"
#import "HomeStudyAdvCell.h"
#import "HomeStudyTodyCell.h"
#import "HomeStudyTeacherCell.h"
#import "HomeStudyModelOneCell.h"
#import "HomeStudyModelTwoCell.h"
#import "HomeStudyModelThriceCell.h"
#import "HomeStudyModelFourCell.h"
#import "HomeStudyListCell.h"
#import "HomeStudyCallListCell.h"
#import "HomeTaskCenterDefaultView.h"
#import "OfflineTrainPlanListVC.h"
#import <YSLiveSDK/YSSDKManager.h>

@interface HICHomeStudyDetailView ()<UITableViewDataSource, UITableViewDelegate, HomeStudyBaseCellDelegate,YSSDKDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) HomeTaskCenterDefaultView *defaultView;

@property (nonatomic, assign) NSInteger pageNum;

@property (nonatomic,strong) NSNotification *notification;
@property (nonatomic ,strong) YSSDKManager *ysManager;

@end

@implementation HICHomeStudyDetailView

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _pageNum = 1; // 初始化数据
    [self.tableView addSubview:self.defaultView]; // 添加默认视图
    if (!self.homeDataSource && self.resourceID != 0) {
        [self loadDataSever];
        ///日志上报
//         HICStudyLogReportModel *reportModel = [[HICStudyLogReportModel alloc]initWithType:HICFirstSearch];
//                   reportModel.mediaid = [NSNumber numberWithInteger:model.infoId];
//                   reportModel.knowtype = [NSNumber numberWithInteger:model.resourceType];
//                   reportModel.mediatype = [NSNumber numberWithInteger:HICReportKnowledgeType];
//                   reportModel.teacherid = @-1;
//                   NSMutableDictionary *report = [NSMutableDictionary dictionaryWithDictionary:[reportModel getParamDict]];
//                   [report setValuesForKeysWithDictionary:[LogManager getSerLogEventDictWithType:HICFirstSearch]];
//                   [LogManager reportSerLogWithDict:report];
    }else {
        if (self.homeDataSource.count == 0) {
            self.defaultView.hidden = NO;
        }
    }

    [self.tableView registerClass:HomeStudyBannerCell.class         forCellReuseIdentifier:@"BannerCell"];
    [self.tableView registerClass:HomeStudyQuickButCell.class       forCellReuseIdentifier:@"QuickButCell"];
    [self.tableView registerClass:HomeStudyAdvCell.class            forCellReuseIdentifier:@"AdvCell"];
    [self.tableView registerClass:HomeStudyTodyCell.class           forCellReuseIdentifier:@"TodyCell"];
    [self.tableView registerClass:HomeStudyTeacherCell.class        forCellReuseIdentifier:@"TeacherCell"];
    [self.tableView registerClass:HomeStudyModelOneCell.class       forCellReuseIdentifier:@"ModelOneCell"];
    [self.tableView registerClass:HomeStudyModelTwoCell.class       forCellReuseIdentifier:@"ModelTwoCell"];
    [self.tableView registerClass:HomeStudyModelThriceCell.class    forCellReuseIdentifier:@"ModelThriceCell"];
    [self.tableView registerClass:HomeStudyModelFourCell.class      forCellReuseIdentifier:@"ModelFourCell"];
    [self.tableView registerClass:HomeStudyListCell.class           forCellReuseIdentifier:@"ListCell"];
    [self.tableView registerClass:HomeStudyCallListCell.class       forCellReuseIdentifier:@"CallListCell"];
    
    self.notification =[NSNotification notificationWithName:@"reload" object:nil];
    [self initSDKManager];
}

- (void)initSDKManager{
     self.ysManager = [YSSDKManager sharedInstance];
    [self.ysManager registerManagerDelegate:self];
//    self.ysManager.useAppDelegateAllowRotation = SystemManager.allowRotation;
    
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];

    DDLogDebug(@"-------");

    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if ( !weakSelf.homeDataSource && weakSelf.resourceID != 0) {
            [weakSelf.dataSource removeAllObjects];
            [weakSelf.tableView reloadData];
            [weakSelf.tableView.mj_footer resetNoMoreData];
            weakSelf.pageNum = 1;
            [weakSelf loadDataSever];
        }else {
            weakSelf.homeDataSource = @[];
            [weakSelf.tableView reloadData];
            [weakSelf loadDataRefresh];
            //通过通知中心发送通知
            [weakSelf postNoti];
        }
    }];

    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        // 加载更多数据
        if ( !weakSelf.homeDataSource && weakSelf.resourceID != 0) {
            weakSelf.pageNum += 1;
            [weakSelf loadDataSever];
        }else {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
    self.tableView.mj_footer = footer;
}
- (void)postNoti {
     [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"reload" object:nil]];
}
#pragma mark - 网络请求数据
-(void)loadDataSever {
    self.defaultView.hidden = YES;
    NSDictionary *dic = @{@"categoryId":[NSNumber numberWithInteger:self.resourceID], @"page":[NSNumber numberWithInteger:self.pageNum], @"size":@10};
    [HICAPI loadDataSever:dic success:^(NSDictionary * _Nonnull responseObject) {
        NSArray *modelArray = [HICHomeStudyClassModel createModelWithSourceData:responseObject];
        if (modelArray && modelArray.count > 0) {
            [self.dataSource addObjectsFromArray:modelArray];
            [self.tableView reloadData];
        }
        [self.tableView.mj_header endRefreshing];
        if (modelArray.count == 0) {
            self.pageNum--;
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else {
            [self.tableView.mj_footer endRefreshing];
        }
        if (self.dataSource.count == 0) {
            self.defaultView.hidden = NO;
        }
    } failure:^(NSError * _Nonnull error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        self.defaultView.hidden = NO;
        self.pageNum --;
    }];
}

-(void)loadDataRefresh {
    self.defaultView.hidden = YES;
    if (!RoleManager.isSuccessMenu) {
        [HICCommonUtils setRootViewToMainVC];
        return;
    }
    // 任务中心获取数据
    __block NSArray *willCenterModels;
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
        if (!USER_CID) {
            return;
        }
        dispatch_semaphore_t se = dispatch_semaphore_create(0);
        NSDictionary *dic = @{@"listFlag":@1, @"customerId":USER_CID};
        [HICAPI taskList:dic success:^(NSDictionary * _Nonnull responseObject) {
            willCenterModels = [HICHomeTaskCenterModel createModelWithSourceData:responseObject name:@"inProgressList"];
            dispatch_semaphore_signal(se);
        } failure:^(NSError * _Nonnull error) {
            DDLogDebug(@"[HIC]-[JXL] - 网络请求任务中心失败");
            dispatch_semaphore_signal(se);
        }];
        dispatch_semaphore_wait(se, DISPATCH_TIME_FOREVER);
    });
    
    __block NSArray *dataModels;
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
        dispatch_semaphore_t se = dispatch_semaphore_create(0);
        [HICAPI homePageDetail:^(NSDictionary * _Nonnull responseObject) {
            if ([HICCommonUtils isValidObject: responseObject] ) {
                dataModels = [HICHomeStudyModel createModelWithSourceData:responseObject];
                dispatch_semaphore_signal(se);
            }
        } failure:^(NSError * _Nonnull error) {
            DDLogDebug(@"[HIC]-[JXL] - 网络请求首页数据失败");
            dispatch_semaphore_signal(se);
        }];
        
        dispatch_semaphore_wait(se, DISPATCH_TIME_FOREVER);
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        if (dataModels != nil ) {
            //            NSArray *array = [HICHomeStudyModel getHomeDataWithModels:dataModels];
            self.homeDataSource = [HICHomeStudyModel getHomeDataWithModels:dataModels addTaskCenters:willCenterModels];
            [self.tableView reloadData];
            if (self.homeDataSource.count == 0) {
                self.defaultView.hidden = NO;
            }
        }else {
            if (self.homeDataSource.count == 0) {
                self.defaultView.hidden = NO;
            }
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    });
}

#pragma mark - TableDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.homeDataSource ? self.homeDataSource.count:self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HICHomeStudyModel *model = self.homeDataSource ? self.homeDataSource[indexPath.row]:nil;
    HomeStudyBaseCell *cell;
    if (model) {
        cell = [tableView dequeueReusableCellWithIdentifier:model.cellID forIndexPath:indexPath];
        cell.homeStudyModel = model;
    }else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"ListCell" forIndexPath:indexPath];
        if (self.dataSource.count > indexPath.row) {
            cell.studyClassModel = self.dataSource[indexPath.row];
        }
    }

    cell.cellIndexPath = indexPath;
    cell.delegate = self;

    return cell;
}

#pragma mark - TableDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (self.homeDataSource == nil && self.dataSource.count != 0) {
        return 95;
    }

    HICHomeStudyModel *model = self.homeDataSource ? self.homeDataSource[indexPath.row]:nil;
    if (model) {
        return model.cellHeight;
    }
    return 0;
}

#pragma mark - Cell的协议方法
-(void)studyCell:(HomeStudyBaseCell *)cell onTap:(ResourceListItem *)item other:(id)data {

    // 这里有跳转的方法
    DDLogDebug(@"进行不同的业务跳转！");
     NSIndexPath *indexPath = cell.cellIndexPath;
     HICHomeStudyModel *studyModel;
     if (self.dataSource.count != 0 && indexPath.row <= self.dataSource.count-1) {
         studyModel = self.dataSource[indexPath.row];
     }
    if (!studyModel && self.homeDataSource.count != 0 && indexPath.row <= self.homeDataSource.count-1) {
        studyModel = self.homeDataSource[indexPath.row];
    }
     PushViewControllerModel *model = [PushViewControllerModel new];
     model.pushType = item.resourceType;
     model.urlStr = item.linkUrl;
     model.detailID = item.resourceId;
    model.companyOnlyVideo = item.dirTypeFilter;
     NSDictionary *dic = item.courseInfo;
     id fileType = [dic objectForKey:@"fileType"];
     if (fileType && [fileType isKindOfClass:NSString.class]) {
         NSString *str = (NSString *)fileType;
         model.studyResourceType = str.intValue;
     }else if (fileType && [fileType isKindOfClass:NSNumber.class]) {
         NSNumber *num = (NSNumber *)fileType;
         model.studyResourceType = num.intValue;
     }
     if (studyModel && item.resourceType == 30) {
         NSDictionary *rank = studyModel.boardParam;
         id countType = [rank objectForKey:@"countType"];
         if (countType && [countType isKindOfClass:NSString.class]) {
             NSString *str = (NSString *)countType;
             model.detailID = str.intValue;
         }else if (countType && [countType isKindOfClass:NSNumber.class]) {
             NSNumber *num = (NSNumber *)countType;
             model.detailID = num.intValue;
         }
     }
    
    if (item.resourceType == 1007 || item.resourceType == 5 || item.resourceType == 1009 ||item.resourceType == 15) {///企业知识 201007
           ///日志上报
           HICStudyLogReportModel *reportModel = [[HICStudyLogReportModel alloc]initWithType:HICFirstAllKnowledge];
        reportModel.tabid = [NSNumber numberWithInteger:self.resourceID];
           NSMutableDictionary *report = [NSMutableDictionary dictionaryWithDictionary:[reportModel getParamDict]];
           [report setValuesForKeysWithDictionary:[LogManager getSerLogEventDictWithType:HICFirstAllKnowledge]];
           [LogManager reportSerLogWithDict:report];
    }else if (item.resourceType == 14) {///日志上报
        HICStudyLogReportModel *reportModel = [[HICStudyLogReportModel alloc]initWithType:HICFirstLectureClick];
        reportModel.teacherid = [NSNumber numberWithInteger:item.resourceId];
        reportModel.tabid = [NSNumber numberWithInteger:self.resourceID];
        NSMutableDictionary *report = [NSMutableDictionary dictionaryWithDictionary:[reportModel getParamDict]];
        [report setValuesForKeysWithDictionary:[LogManager getSerLogEventDictWithType:HICFirstLectureClick]];
        [LogManager reportSerLogWithDict:report];
    }else if (item.resourceType == 30){
        HICStudyLogReportModel *reportModel = [[HICStudyLogReportModel alloc]initWithType:HICFirstRankClick];
              reportModel.tabid = [NSNumber numberWithInteger:self.resourceID];
              NSMutableDictionary *report = [NSMutableDictionary dictionaryWithDictionary:[reportModel getParamDict]];
              [report setValuesForKeysWithDictionary:[LogManager getSerLogEventDictWithType:HICFirstRankClick]];
              [LogManager reportSerLogWithDict:report];
    }else if (item.resourceType == 6 || item.resourceType == 7){
        ///日志上报
           HICStudyLogReportModel *reportModel = [[HICStudyLogReportModel alloc]initWithType:HICFirstKnowledgeClick];
           reportModel.mediaid = [NSNumber numberWithInteger:item.resourceId];
           reportModel.knowtype = [NSNumber numberWithInteger:model.studyResourceType];
           if (item.resourceType == 6) {
               reportModel.mediatype = [NSNumber numberWithInteger:HICReportCourseType];
           }else{
               reportModel.mediatype = [NSNumber numberWithInteger:HICReportKnowledgeType];
           }
           reportModel.tabid = [NSNumber numberWithInteger:self.resourceID];
           NSMutableDictionary *report = [NSMutableDictionary dictionaryWithDictionary:[reportModel getParamDict]];
           [report setValuesForKeysWithDictionary:[LogManager getSerLogEventDictWithType:HICFirstKnowledgeClick]];
           [LogManager reportSerLogWithDict:report];
    }
    else{
        HICStudyLogReportModel *reportModel = [[HICStudyLogReportModel alloc]initWithType:HICFirstTaskTypeClick];
           if (item.resourceType == 1005) {
               reportModel.tasktype = [NSNumber numberWithInteger:HICReportQuestionType];
           }else if (item.resourceType == 1003){
               reportModel.tasktype = [NSNumber numberWithInteger:HICReportExamType];
           }else if (item.resourceType == 1004){
               reportModel.tasktype = [NSNumber numberWithInteger:HICReportTrainType];
           }else if (item.resourceType == 1002){
               reportModel.tasktype = [NSNumber numberWithInteger:HICReportMapType];
           }else if (item.resourceType == 1006){
               reportModel.tasktype = [NSNumber numberWithInteger:HICReportEnrollType];
           }
              reportModel.tabid = [NSNumber numberWithInteger:self.resourceID];
              NSMutableDictionary *report = [NSMutableDictionary dictionaryWithDictionary:[reportModel getParamDict]];
              [report setValuesForKeysWithDictionary:[LogManager getSerLogEventDictWithType:HICFirstTaskTypeClick]];
              [LogManager reportSerLogWithDict:report];
    }
    
    if (item.resourceType == 1012){
        if ([RoleManager.showTabBarMenus containsObject:@"LiveF"]) {
            NSInteger index = [RoleManager.showTabBarMenus indexOfObject:@"LiveF"];
            if (index < self.tabBarController.childViewControllers.count) {
                [self.tabBarController setSelectedIndex:index];
            }
        }else{
            [HICPushViewManager parentVC:self pushVCWithModel:model];
        }
    }else{
        [HICPushViewManager parentVC:self pushVCWithModel:model];
    }
     
}

-(void)studyCell:(HomeStudyBaseCell *)cell clickMoreBut:(UIButton *)but model:(HICHomeStudyModel *)model type:(NSInteger)type {

    if (model.source == 1) {
        // TODO: 企业知识上报
        PushViewControllerModel *modelPush = [PushViewControllerModel new];
        modelPush.pushType = 5;
        modelPush.pushId = model.sourceDir;
        modelPush.titleName = model.name;
        modelPush.orderBy = model.courseKldOrderBy;
        [HICPushViewManager parentVC:self pushVCWithModel:modelPush];
        
        HICStudyLogReportModel *reportModel = [[HICStudyLogReportModel alloc]initWithType:HICFirstAllKnowledge];
         reportModel.tabid = [NSNumber numberWithInteger:self.resourceID];
           NSMutableDictionary *report = [NSMutableDictionary dictionaryWithDictionary:[reportModel getParamDict]];
           [report setValuesForKeysWithDictionary:[LogManager getSerLogEventDictWithType:HICFirstAllKnowledge]];
           [LogManager reportSerLogWithDict:report];
        
    }else if (model.source == 2) {
        PushViewControllerModel *modelPush = [PushViewControllerModel new];
        modelPush.pushType = 30;
        ///日志上报
        HICStudyLogReportModel *reportModel = [[HICStudyLogReportModel alloc]initWithType:HICFirstRankClick];
              reportModel.tabid = [NSNumber numberWithInteger:self.resourceID];
              NSMutableDictionary *report = [NSMutableDictionary dictionaryWithDictionary:[reportModel getParamDict]];
              [report setValuesForKeysWithDictionary:[LogManager getSerLogEventDictWithType:HICFirstRankClick]];
              [LogManager reportSerLogWithDict:report];
        NSDictionary *rank = model.boardParam;
        id countType = [rank objectForKey:@"countType"];
        if (countType && [countType isKindOfClass:NSString.class]) {
            NSString *str = (NSString *)countType;
            modelPush.detailID = str.intValue;
        }else if (countType && [countType isKindOfClass:NSNumber.class]) {
            NSNumber *num = (NSNumber *)countType;
            modelPush.detailID = num.intValue;
        }
        [HICPushViewManager parentVC:self pushVCWithModel:modelPush];
    }else if (model.source == 3) {

    }
}

-(void)studyCell:(HomeStudyBaseCell *)cell clickItem:(HICHomeStudyClassModel *)item other:(id)data {

    // 这是知识cell的详情页跳转 -- 需要
    PushViewControllerModel *model = [PushViewControllerModel new];
    model.pushType = item.courseKLD.courseKLDType;
    model.detailID = item.courseKLD.courseKLDId;
    model.studyResourceType = item.courseKLD.resourceType;
    ///日志上报
    HICStudyLogReportModel *reportModel = [[HICStudyLogReportModel alloc]initWithType:HICFirstKnowledgeClick];
    reportModel.mediaid = [NSNumber numberWithInteger:model.detailID];
    reportModel.knowtype = [NSNumber numberWithInteger:model.studyResourceType];
    if (model.pushType == 6) {
        reportModel.mediatype = [NSNumber numberWithInteger:HICReportCourseType];
    }else{
        reportModel.mediatype = [NSNumber numberWithInteger:HICReportKnowledgeType];
    }
    reportModel.tabid = [NSNumber numberWithInteger:self.resourceID];
    NSMutableDictionary *report = [NSMutableDictionary dictionaryWithDictionary:[reportModel getParamDict]];
    [report setValuesForKeysWithDictionary:[LogManager getSerLogEventDictWithType:HICFirstKnowledgeClick]];
    [LogManager reportSerLogWithDict:report];
    [HICPushViewManager parentVC:self pushVCWithModel:model];
}

-(void)studyCell:(HomeStudyBaseCell *)cell clickOtherBut:(UIButton *)but model:(id)model type:(NSInteger)type {
    //TODO:201003 首页-具体任务点击
    // 今日任务的的 全部按钮
    DDLogDebug(@"跳转到 -- 任务中心列表");
    
    ///日志上报
    HICStudyLogReportModel *reportModel = [[HICStudyLogReportModel alloc]initWithType:HICFirstOtherTaskClick];
 
    if (type == 1) {
        // 具体的每个任务
        HICHomeTaskCenterModel *tModel = (HICHomeTaskCenterModel *)model;
        if (tModel.taskType == 1) { // 考试
            PushViewControllerModel *model = [[PushViewControllerModel alloc] initWithPushType:4 urlStr:[NSString stringWithFormat:@"%ld", (long)tModel.taskId] detailId:tModel.taskId studyResourceType:HICHtmlType pushType:0];
            reportModel.mediaid = [NSNumber numberWithInteger:tModel.taskId];
            reportModel.taskstatus = NSLocalizableString(@"ongoing", nil);
            reportModel.tasktype = [NSNumber numberWithInteger:tModel.taskType];
             reportModel.tabid = [NSNumber numberWithInteger:self.resourceID];
            NSMutableDictionary *report = [NSMutableDictionary dictionaryWithDictionary:[reportModel getParamDict]];
             [report setValuesForKeysWithDictionary:[LogManager getSerLogEventDictWithType:HICFirstOtherTaskClick]];
             [LogManager reportSerLogWithDict:report];
            [HICPushViewManager parentVC:self pushVCWithModel:model];
        } else if (tModel.taskType == 2) { // 培训
            reportModel.mediaid = [NSNumber numberWithInteger:tModel.taskId];
                                    reportModel.taskstatus = NSLocalizableString(@"ongoing", nil);
                                    reportModel.tasktype = [NSNumber numberWithInteger:tModel.taskType];
                          reportModel.tasktype = [NSNumber numberWithInteger:tModel.taskType];
                           reportModel.tabid = [NSNumber numberWithInteger:self.resourceID];
                          NSMutableDictionary *report = [NSMutableDictionary dictionaryWithDictionary:[reportModel getParamDict]];
                           [report setValuesForKeysWithDictionary:[LogManager getSerLogEventDictWithType:HICFirstOtherTaskClick]];
                           [LogManager reportSerLogWithDict:report];
            if (tModel.trainType == 1) {
                PushViewControllerModel *model = [[PushViewControllerModel alloc] initWithPushType:12 urlStr:nil detailId:tModel.taskId studyResourceType:HICHtmlType pushType:0];
                [HICPushViewManager parentVC:self pushVCWithModel:model];
            }else if (tModel.trainType == 2) {
                // 线下培训 -- 培训安排页面带有右上按钮
                PushViewControllerModel *model = [[PushViewControllerModel alloc] initWithPushType:122 urlStr:nil detailId:tModel.taskId studyResourceType:HICHtmlType pushType:0];
                model.childType = 1; // 培训安排页面
                model.registChannel = tModel.registChannel;
                if (tModel.registChannel == 1) {
                    model.workId = tModel.registerTrainId;
                }

                [HICPushViewManager parentVC:self pushVCWithModel:model];
            }else{
                //混合培训
                PushViewControllerModel *model = [[PushViewControllerModel alloc] initWithPushType:123 urlStr:nil detailId:tModel.taskId studyResourceType:HICHtmlType pushType:0];
                model.mixTrainType = tModel.scene;
                model.registChannel = tModel.registChannel;
                if ( tModel.registChannel == 1) {
                    model.workId = tModel.registerTrainId;
                }
                 [HICPushViewManager parentVC:self pushVCWithModel:model];
            }
        } else if (tModel.taskType == 3) { // 问卷
            NSString * urlStr = [NSString stringWithFormat:@"%@/mweb/index.html#/questionnaire?questionActionId=%ld",APP_Web_DOMAIN, (long)tModel.taskId];
            PushViewControllerModel *model = [[PushViewControllerModel alloc] initWithPushType:13 urlStr:urlStr detailId:tModel.taskId studyResourceType:HICHtmlType pushType:0];
            reportModel.tasktype = [NSNumber numberWithInteger:tModel.taskType];
             reportModel.tabid = [NSNumber numberWithInteger:self.resourceID];
            reportModel.mediaid = [NSNumber numberWithInteger:tModel.taskId];
                      reportModel.taskstatus = NSLocalizableString(@"ongoing", nil);
                      reportModel.tasktype = [NSNumber numberWithInteger:tModel.taskType];
            NSMutableDictionary *report = [NSMutableDictionary dictionaryWithDictionary:[reportModel getParamDict]];
             [report setValuesForKeysWithDictionary:[LogManager getSerLogEventDictWithType:HICFirstOtherTaskClick]];
             [LogManager reportSerLogWithDict:report];
            [HICPushViewManager parentVC:self pushVCWithModel:model];
        } else if (tModel.taskType == 4) { // 报名
            reportModel.tasktype = [NSNumber numberWithInteger:tModel.taskType];
             reportModel.tabid = [NSNumber numberWithInteger:self.resourceID];
            reportModel.mediaid = [NSNumber numberWithInteger:tModel.taskId];
                      reportModel.taskstatus = NSLocalizableString(@"ongoing", nil);
                      reportModel.tasktype = [NSNumber numberWithInteger:tModel.taskType];
            NSMutableDictionary *report = [NSMutableDictionary dictionaryWithDictionary:[reportModel getParamDict]];
             [report setValuesForKeysWithDictionary:[LogManager getSerLogEventDictWithType:HICFirstOtherTaskClick]];
             [LogManager reportSerLogWithDict:report];
            PushViewControllerModel *model = [[PushViewControllerModel alloc] initWithPushType:8 urlStr:nil detailId:tModel.taskId studyResourceType:HICHtmlType pushType:0];
            model.workId = tModel.registerTrainId;
            [HICPushViewManager parentVC:self pushVCWithModel:model];
             
        }else if (tModel.taskType == 6) { // 直播
            [self getRoomNumWithID:[NSNumber numberWithLong:tModel.taskId]];

        }
    }else if (type == 0) {
        if ([RoleManager.showTabBarMenus containsObject:@"AppTaskCenterF"]) {
            NSInteger index = [RoleManager.showTabBarMenus indexOfObject:@"AppTaskCenterF"];
            if (index < self.tabBarController.childViewControllers.count) {
                [self.tabBarController setSelectedIndex:index];
            }
        }
    }
    
}

- (void)getRoomNumWithID:(NSNumber *)lessonId{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [HICAPI getRoomNumWithID:lessonId success:^(NSDictionary * _Nonnull responseObject) {
            if (responseObject[@"data"][@"liveRoom"]) {
                HICLiveRoomModel *model = [HICLiveRoomModel mj_objectWithKeyValues:responseObject[@"data"][@"liveRoom"]];
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

#pragma mark - 懒加载
-(UITableView *)tableView {
    if (!_tableView) {
        CGFloat screenWidth = UIScreen.mainScreen.bounds.size.width;
        CGFloat screenHeight = UIScreen.mainScreen.bounds.size.height;
        UIApplication *manager = UIApplication.sharedApplication;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight-manager.statusBarFrame.size.height-44-44-49-HIC_BottomHeight) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [self.view addSubview:_tableView];
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor whiteColor];
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0;
        }
    }
    return _tableView;
}

-(NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

-(HomeTaskCenterDefaultView *)defaultView {
    if (!_defaultView) {
        _defaultView = [[HomeTaskCenterDefaultView alloc] initWithFrame:CGRectMake(0, 0, HIC_ScreenWidth, HIC_ScreenHeight-HIC_StatusBar_Height-44-44-49-HIC_BottomHeight)];
        _defaultView.hidden = YES;
        _defaultView.titleStr = NSLocalizableString(@"temporarilyNoData", nil);
        _defaultView.imageName = @"首页-暂无数据";
    }
    return _defaultView;
}

@end
