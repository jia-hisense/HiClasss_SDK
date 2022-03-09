//
//  HICHomeStudyVC.m
//  iTest
//
//  Created by Sir_Jing on 2020/3/9.
//  Copyright © 2020 Sir_Jing. All rights reserved.
//

#import "HICHomeStudyVC.h"

#import "HICHomeStudyNavView.h"
#import "HICHomeStudyDetailView.h"
#import "HICHomeStudyLastRecordView.h"
#import "HICCompanyKnowledgeVC.h"
#import "HICRankingListVC.h"
#import "HICQRScanVC.h"
#import "HICSearchDetailVC.h"
#import "HICMsgCenterVC.h"
#import "HICCustomerNetErrorView.h"
#import "HICKnowledgeScromAndHtmlVC.h"
#import "HICHomeStudyModel.h"
#import "HICKnowledgeDetailVC.h"
#import "HICLessonsVC.h"
#import <AVFoundation/AVFoundation.h>

@interface HICHomeStudyVC ()<HICHomeStudyLastRecordViewDelegate>

/// 获取得到首页的全部数据模型
@property (nonatomic, strong) NSArray *dataModels;
/// 获取任务中心的在做的数据模型
@property (nonatomic, strong) NSArray *doCenterModels;
/// 获取任务中心的要做的数据模型
@property (nonatomic, strong) NSArray *willCenterModels;
@property (nonatomic, strong) HICHomeStudyNavView *navView;

@property (nonatomic, strong) NSDictionary *lastRecordDict;
@property (nonatomic, assign) BOOL hadShowLastRecord;
@end

@implementation HICHomeStudyVC

#pragma mark - 生命周期
- (void)viewDidLoad {
    self.isCustomer = YES;
    self.view.backgroundColor = UIColor.whiteColor;
    [super viewDidLoad];
    __weak typeof(self) weakSelf = self;
    UIView * v = [[UIView alloc] initWithFrame:CGRectMake(0, HIC_ScreenHeight - HIC_BottomHeight, HIC_ScreenWidth, HIC_BottomHeight)];
    [self.view addSubview:v];
    _navView = [[HICHomeStudyNavView alloc] initDefaultWithClickScan:^(UIView * _Nonnull clickView) {
        NSString *mediaType = AVMediaTypeVideo;
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
        if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
            [HICToast showWithText:NSLocalizableString(@"cameraPermissions", nil)];
            return;
        }
        [self uploadLog];
        [weakSelf.navigationController pushViewController:HICQRScanVC.new animated:YES];
    } clickSearchText:^(UIView * _Nonnull clickView) {
        [weakSelf.navigationController pushViewController:HICSearchDetailVC.new animated:YES];
    } clickMessage:^(UIView * _Nonnull clickView) {
        [weakSelf.navigationController pushViewController:HICMsgCenterVC.new animated:YES];
    }];
    [self.view addSubview:_navView];
    
    [self loadDataSever];
    self.isAgainView = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload) name:@"reload"object:nil];
    
    [self getLastLearningRecord];
}

- (void)uploadLog {
    HICStudyLogReportModel *reportModel = [[HICStudyLogReportModel alloc]initWithType:HICFirstScan];
    ///日志上报
    NSMutableDictionary *report = [NSMutableDictionary dictionaryWithDictionary:[reportModel getParamDict]];
    [report setValuesForKeysWithDictionary:[LogManager getSerLogEventDictWithType:HICFirstScan]];
    [LogManager reportSerLogWithDict:report];
}
- (void)reload {
    [self.navView loadDataMessageNum];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [self.navView loadDataMessageNum];
}

#pragma mark - 创建View
- (void)setUpAllChildViewController {
    if (self.dataModels.count == 0) {
        __weak typeof(self) weakSelf = self;
        [RoleManager showErrorViewWith:self.view blcok:^(NSInteger type) {
            [weakSelf loadDataSever];
            [weakSelf.navView loadDataMessageNum];
        }];
    }
    HICHomeStudyModel *model = [HICHomeStudyModel getMenuDataWithModels:self.dataModels];
    NSArray *dataArray = [HICHomeStudyModel getHomeDataWithModels:self.dataModels addTaskCenters:self.willCenterModels];
    NSArray *titles = model.resourceList;
    for (NSInteger i = 0; i < titles.count; i++) {
        HICHomeStudyDetailView *vc = [HICHomeStudyDetailView new];
        vc.homeNavi = self.navView;
        ResourceListItem *item = [titles objectAtIndex:i];
        vc.title = item.name;
        if (item.pageType == 1) {
            // 此时为首页
            vc.homeDataSource = dataArray;
        }else if (item.pageType == 0) {
            vc.resourceID = item.resourceId;
        }
        [self addChildViewController:vc];
    }

    // 设置
    [self setUpDisplayStyle:^(UIColor *__autoreleasing *titleScrollViewBgColor, UIColor *__autoreleasing *norColor, UIColor *__autoreleasing *selColor, UIColor *__autoreleasing *proColor, UIFont *__autoreleasing *titleFont, BOOL *isShowProgressView, BOOL *isOpenStretch, BOOL *isOpenShade) {
        *selColor = [UIColor colorWithHexString:@"#03B3CC"];
        *titleFont = FONT_REGULAR_18;//[UIFont fontWithName:@"PingFangSC-Medium" size:18];
    }];
}


// 任务中心获取数据
- (void)loadDataSever {
    [RoleManager showWindowLoadingView];
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if (!USER_CID) {
            dispatch_group_leave(group);
            return;
        }
        NSDictionary *dic = @{@"listFlag":@1, @"customerId":USER_CID};
        [HICAPI taskList:dic success:^(NSDictionary * _Nonnull responseObject) {
            self.willCenterModels = [HICHomeTaskCenterModel createModelWithSourceData:responseObject name:@"inProgressList"];
            dispatch_group_leave(group);
        } failure:^(NSError * _Nonnull error) {
            dispatch_group_leave(group);
            DDLogDebug(@"[HIC]-[JXL] - 网络请求任务中心失败");
        }];
    });
    dispatch_group_enter(group);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if (!USER_CID) {
            dispatch_group_leave(group);
            return;
        }
        [HICAPI homePageDetail:^(NSDictionary * _Nonnull responseObject) {
            if ([HICCommonUtils isValidObject:responseObject] ) {
                self.dataModels = [HICHomeStudyModel createModelWithSourceData:responseObject];
            }
            dispatch_group_leave(group);
        } failure:^(NSError * _Nonnull error) {
            DDLogDebug(@"[HIC]-[JXL] - 网络请求首页数据失败");
            dispatch_group_leave(group);
        }];
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [RoleManager hiddenWindowLoadingView];
        [self setUpAllChildViewController];
        [self createTitleViewAgain];
        
    });
}

- (void)getLastLearningRecord {
    if (!USER_CID || self.hadShowLastRecord) { return; }
    [HICAPI getLastLearningRecord:^(NSDictionary * _Nonnull responseObject) {
        NSArray *recordArr = responseObject[@"data"][@"learningRecordList"];
        if (recordArr && recordArr.count > 0) {
            self.lastRecordDict = recordArr.firstObject;
        }
        [self showLastRLearningRecord];
    }];
}

- (void)showLastRLearningRecord {
    if (!self.lastRecordDict) { return; }
    NSDictionary *courseInfo = self.lastRecordDict[@"courseKLDInfo"];
    if (!courseInfo) { return; }
    NSString *credit = courseInfo[@"credit"];
    NSArray *creditArr = [credit componentsSeparatedByString:@"/"];
    if (creditArr.count < 2 || [creditArr.firstObject isEqualToString:creditArr.lastObject]) {
        DDLogDebug(@"最后记录的学分异常或者已完成全部进度 credit=%@", credit);
        return;
    }
    NSString *courseName = courseInfo[@"courseKLDName"];
    HICHomeStudyLastRecordView *lastRecordView = [[HICHomeStudyLastRecordView alloc] initWithFrame:CGRectMake(0, 0, HIC_ScreenWidth - 24, 55) recordTitle:courseName];
    lastRecordView.delegate = self;
    [self.view addSubview:lastRecordView];
    [lastRecordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view).inset(12);
        make.height.equalTo(@55);
        make.bottom.equalTo(self.view).inset(HIC_TabBarHeight+10);
    }];
    self.hadShowLastRecord = YES;
}

#pragma mark - HICHomeStudyLastRecordViewDelegate
- (void)continueLearnLastRecord {
    if (!self.lastRecordDict) { return; }
    NSDictionary *courseInfo = self.lastRecordDict[@"courseKLDInfo"];
    if (!courseInfo) { return; }
    HICStudyResourceType resourceType = [courseInfo[@"resourceType"] integerValue];
    NSNumber *objcID = courseInfo[@"courseKLDId"];
    NSNumber *type = courseInfo[@"courseKLDType"];
    NSString *partnerCode = courseInfo[@"partnerCode"];
    if (type.integerValue == 6) { // 课程
        HICLessonsVC *vc = [[HICLessonsVC alloc] init];
        vc.objectID = objcID;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (type.integerValue == 7) { // 知识
        HICKnowledgeDetailVC *vc = [[HICKnowledgeDetailVC alloc] init];
        vc.objectId = objcID;
        vc.kType = resourceType;
        vc.partnerCode = partnerCode;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"reload" object:nil];
}

@end
