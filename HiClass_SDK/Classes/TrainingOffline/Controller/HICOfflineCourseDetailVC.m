//
//  HICCourseDetailVC.m
//  HiClass
//
//  Created by hisense on 2020/4/24.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import "HICOfflineCourseDetailVC.h"
#import "HICNavgationBar.h"
#import "HICOfflineClassInfoModel.h"
#import "HomeTaskCenterDefaultView.h"
#import "HICOfflineClassHeaderView.h"
#import "NSString+String.h"
#import "HICOfflineScoreCell.h"
#import "HICOfflineAllScoreCell.h"
#import "HICOfflineLecturerCell.h"
#import "HICOfflineTitleCell.h"
#import "HICOfflineMaterialCell.h"
#import "HICOfflineClassTaskCell.h"
#import "HICTrainingBriefCell.h"
#import "HICTrainingOtherInfoCell.h"
#import "HICCommonUtils.h"
#import "HICToast.h"
#import <AVKit/AVKit.h>
#import "HICStudyDocPhotoDetailView.h"
#import "OTPSignManager.h"
#import "HICOfflineClassInfoModel.h"
#import "OTPSignPassView.h"
#import "HICLectureDetailVC.h"
#import "HICHomeworkListVC.h"
#import "HICTrainQuestionVC.h"
#import "OTPSignBackView.h"
#import "OTPSignMapViewVC.h"
#import "MUPhotoPreviewController.h"
#import "HICPreviewScrollVC.h"

@interface HICOfflineCourseDetailVC ()<UITableViewDelegate, UITableViewDataSource, HICStudyDocPhotoDetailDelegate>
@property (nonatomic, weak) UITableView *table;

@property (nonatomic, weak) HICNavgationBar *navBar;

@property (nonatomic, strong) HICOfflineClassInfoModel *classInfo;

@property (nonatomic, weak) HomeTaskCenterDefaultView *defaultView;

@property (nonatomic, strong) HICStudyDocPhotoDetailView *detailView;


@property (nonatomic, strong) HICOfflineClassHeaderFrame *headerFrame;
@property (nonatomic, strong) NSMutableArray<NSMutableArray *> *dataSections;


@property (nonatomic, strong) NSMutableArray<NSDictionary *> *signBackSources; // 早退原因



@end

@implementation HICOfflineCourseDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController setNavigationBarHidden:YES];
    [self.tabBarController.tabBar setHidden:YES];

    self.signBackSources = [NSMutableArray array];

    HICNavgationBar *navBar = [[HICNavgationBar alloc] initWithTitle:NSLocalizableString(@"offlineCoursesDetail", nil) bgImage:@"navi_back" leftBtnImage:@"头部-返回-白色" rightBtnImg:nil];
    navBar.frame = CGRectMake(0, 0, HIC_ScreenWidth, HIC_NavBarAndStatusBarHeight);
    [self.view addSubview:navBar];
    [navBar setItemClicked:^(HICNavgationTapType tapType) {
        switch (tapType) {
            case LeftTap:
                if (_detailView) {
                    [_detailView removeFromSuperview];
                }
                if (self.presentingViewController && self.navigationController.viewControllers.count == 1) {
                    [self dismissViewControllerAnimated:YES completion:nil];
                } else {
                    [self.navigationController popViewControllerAnimated:YES];
                }
                break;
            case RightTap:

                break;

            default:
                break;
        }
    }];
    self.navBar = navBar;


    [self requestData];

    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setNeedsStatusBarAppearanceUpdate];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     self.navigationController.navigationBarHidden = YES;
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    if (@available(iOS 13.0, *)) {
        return UIStatusBarStyleDarkContent;
    } else {
        // Fallback on earlier versions
        return UIStatusBarStyleDefault;
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
//    self.navigationController.navigationBarHidden = NO;
    [_detailView removeFromSuperview];
}


- (void)requestData {
    HICNetModel *netModel;
    if (self.pageType == TrainCourse) {
        NSMutableDictionary *requestDic = [[NSMutableDictionary alloc] init];
        // 课程活动id
        [requestDic setValue:[NSNumber numberWithLong:self.trainId] forKey:@"trainId"];
        [requestDic setValue:[NSNumber numberWithLong:self.taskId] forKey:@"taskId"];
        netModel = [[HICNetModel alloc] initWithURL:@"1.0/app/train/offclass/detail" params:requestDic];
        netModel.contentType = HTTPContentTypeWwwFormType;
        netModel.method = HTTPMethodGET;
        netModel.urlType = DefaultExamURLType;
    } else if (self.pageType == LectureCourse) {
        NSMutableDictionary *requestDic = [[NSMutableDictionary alloc] init];
        // 课程活动id
        [requestDic setValue:[NSNumber numberWithLong:self.taskId] forKey:@"resId"];
        netModel = [[HICNetModel alloc] initWithURL:@"1.0/app/train/lecturer/classes/detail" params:requestDic];
        netModel.contentType = HTTPContentTypeWwwFormType;
        netModel.method = HTTPMethodGET;
        netModel.urlType = DefaultExamURLType;
    }
    [RoleManager showWindowLoadingView];
    __weak typeof(self) weakSelf = self;
    [HICAPI instructorOfflineCourseDetails:netModel success:^(NSDictionary * _Nonnull responseObject) {
        NSDictionary *dicData = [responseObject objectForKey:@"data"];
        if (dicData) {
            weakSelf.classInfo = [HICOfflineClassInfoModel mj_objectWithKeyValues: dicData];
            HICOfflineClassHeaderData *headerData = [[HICOfflineClassHeaderData alloc] initWithTitle:[NSString realString:_classInfo.name] time:[NSString stringWithFormat:@"%@：%@", NSLocalizableString(@"classTime", nil),[NSString getTimeFormate:weakSelf.classInfo.startTime andEndTime:weakSelf.classInfo.endTime]] place: [NSString stringWithFormat:@"%@：%@", NSLocalizableString(@"venue", nil),_classInfo.locationStr] scoreGroup:_classInfo.scoreGroup];
            headerData.pageType = weakSelf.pageType;
            HICOfflineClassHeaderFrame *headerFrame = [[HICOfflineClassHeaderFrame alloc] initWithData:headerData];
            weakSelf.headerFrame = headerFrame;
//=======
// - (void)requestData {
//
//     HICNetModel *netModel;
//
//     if (self.pageType == TrainCourse) {
//         NSMutableDictionary *requestDic = [[NSMutableDictionary alloc] init];
//         // 课程活动id
//         [requestDic setValue:[NSNumber numberWithLong:self.trainId] forKey:@"trainId"];
//         [requestDic setValue:[NSNumber numberWithLong:self.taskId] forKey:@"taskId"];
//         netModel = [[HICNetModel alloc] initWithURL:@"1.0/app/train/offclass/detail" params:requestDic];
//         netModel.contentType = HTTPContentTypeWwwFormType;
//         netModel.method = HTTPMethodGET;
//         netModel.urlType = DefaultExamURLType;
//     } else if (self.pageType == LectureCourse) {
//         NSMutableDictionary *requestDic = [[NSMutableDictionary alloc] init];
//         // 课程活动id
//         [requestDic setValue:[NSNumber numberWithLong:self.taskId] forKey:@"resId"];
//         netModel = [[HICNetModel alloc] initWithURL:@"1.0/app/train/lecturer/classes/detail" params:requestDic];
//         netModel.contentType = HTTPContentTypeWwwFormType;
//         netModel.method = HTTPMethodGET;
//         netModel.urlType = DefaultExamURLType;
//     }
//
//     [RoleManager showWindowLoadingView];
//
//     __weak typeof(self) weakSelf = self;
//     [NetManager sentHTTPRequest:netModel success:^(NSDictionary * _Nonnull responseObject) {
//         [RoleManager hiddenWindowLoadingView];
//
//         NSDictionary *dicData = [responseObject objectForKey:@"data"];
//
//         if (dicData) {
//             weakSelf.classInfo = [HICOfflineClassInfoModel mj_objectWithKeyValues: dicData];
//
//             HICOfflineClassHeaderData *headerData = [[HICOfflineClassHeaderData alloc] initWithTitle:[NSString realString:_classInfo.name] time:[NSString stringWithFormat:@"%@：%@", NSLocalizableString(@"classTime", nil),[NSString getTimeFormate:weakSelf.classInfo.startTime andEndTime:weakSelf.classInfo.endTime]] place: [NSString stringWithFormat:@"%@：%@", NSLocalizableString(@"venue", nil),_classInfo.locationStr] scoreGroup:_classInfo.scoreGroup];
//             headerData.pageType = weakSelf.pageType;
//             HICOfflineClassHeaderFrame *headerFrame = [[HICOfflineClassHeaderFrame alloc] initWithData:headerData];
//             weakSelf.headerFrame = headerFrame;
//
//             // 二维数组，将每个section作为一个元素放入，section内是cell数组
//
//             NSMutableArray *dataSections = [[NSMutableArray alloc] init];
//             weakSelf.dataSections = dataSections;
//
//             NSMutableArray *sectionDatas = [[NSMutableArray alloc] init];
//
//
//             // 上课表现
//             if (_classInfo.classPerformRating.count > 0) {
//                 CGFloat performSum = 0;
//                 // 下发了上课表现
//                 NSInteger count = _classInfo.classPerformRating.count;
//                 if (count > 3) {
//                     count = 3;
//                 }
//                 for (int i = 0; i < count; i++) {
//                     HICClassPerformRating *perform = _classInfo.classPerformRating[i];
//                     HICOfflineScoreCellData *scoreCellData = [HICOfflineScoreCellData dataWithTitle:[NSString realString:perform.reason] score:[NSString stringWithFormat:@"%@%@", [NSString formatFloat:perform.points],NSLocalizableString(@"points", nil)] isSeparatorHidden:YES maxFormatScore:[NSString stringWithFormat:@"100%@",NSLocalizableString(@"points", nil)] textFont:[UIFont fontWithName:@"PingFangSC-Regular" size:15] textColor:[UIColor colorWithHexString:@"#666666"] lblBgColor:[UIColor colorWithHexString:@"#F5F5F5"] topPadding:2 cellHeight:44];
//                     [sectionDatas addObject:scoreCellData];
//                 }
//                 for (int i = 0; i < _classInfo.classPerformRating.count; i++) {
//                     HICClassPerformRating *perform = _classInfo.classPerformRating[i];
//                     performSum += perform.points;
//                 }
//
//                 if (_classInfo.classPerformRating.count > 3) {
//                     HICOfflineAllScoreCellData *data = [HICOfflineAllScoreCellData initWithTitle:[NSString stringWithFormat:@"%@>",NSLocalizableString(@"lookAtAll", nil)] textFont:[UIFont fontWithName:@"PingFangSC-Regular" size:15] textColor:[UIColor colorWithHexString:@"#858585"] lblBgColor:[UIColor colorWithHexString:@"#F5F5F5"] cellHeight:44];
//                     [sectionDatas addObject:data];
//                 }
//                 if (performSum > 0) {
//                     HICOfflineScoreCellData *scoreCellData = [HICOfflineScoreCellData dataWithTitle:[NSString stringWithFormat:@"%@：",NSLocalizableString(@"classPerformanceScore", nil)] score:[NSString stringWithFormat:@"%@%@", [NSString formatFloat:performSum],NSLocalizableString(@"points", nil)] isSeparatorHidden:YES maxFormatScore:[NSString stringWithFormat:@"100%@",NSLocalizableString(@"points", nil)] textFont:[UIFont fontWithName:@"PingFangSC-Medium" size:16] textColor:[UIColor colorWithHexString:@"#333333"] lblBgColor:[UIColor clearColor] topPadding:5 cellHeight:48];
//                     [sectionDatas insertObject:scoreCellData atIndex:0];
//                 }
//             }
//             if (_classInfo.score && _classInfo.score.floatValue >= 0) {
//                 // 课程成绩
//                 HICOfflineScoreCellData *scoreCellData = [HICOfflineScoreCellData dataWithTitle:[NSString stringWithFormat:@"%@：",NSLocalizableString(@"courseGrade", nil)] score:[NSString stringWithFormat:@"%@%@", [NSString formatFloat: _classInfo.score.floatValue],NSLocalizableString(@"points", nil)] isSeparatorHidden:NO maxFormatScore:[NSString stringWithFormat:@"%@%@",_classInfo.score,NSLocalizableString(@"points", nil)] textFont:[UIFont fontWithName:@"PingFangSC-Medium" size:16] textColor:[UIColor colorWithHexString:@"#333333"] lblBgColor:[UIColor clearColor] topPadding:10 cellHeight:55];
//                 [sectionDatas insertObject:scoreCellData atIndex:0];
//             }
//
//             if (sectionDatas.count > 0) {
//                 id lastData = sectionDatas.lastObject;
//                 if ([lastData isKindOfClass:HICOfflineScoreCellData.class]) {
//                     HICOfflineScoreCellData *scoreData = (HICOfflineScoreCellData *)lastData;
//                     scoreData.cellHeight += 10;
//                     scoreData.isSeparatorHidden = YES;
//                 } else if ([lastData isKindOfClass:HICOfflineAllScoreCellData.class]) {
//                     HICOfflineAllScoreCellData *scoreData = (HICOfflineAllScoreCellData *)lastData;
//                     scoreData.cellHeight += 10;
//                 }
//                 [dataSections addObject:sectionDatas];
//                 sectionDatas = [[NSMutableArray alloc] init];
//             }
//
//             // 课程简介
//             NSString *classCuration = @"";
//             if (self.pageType == TrainCourse) {
//                 classCuration = [NSString stringWithFormat:@"%@：%@", NSLocalizableString(@"standardOfClass", nil),weakSelf.classInfo.getCourseHourStr];
//             }
//             if (self.pageType == LectureCourse) {
//                 classCuration = [NSString stringWithFormat:@"%@：%@", NSLocalizableString(@"standardOfClass", nil),weakSelf.classInfo.getClassDurationStr];
//             }
//             HICTrainingBriefData *briefData = [[HICTrainingBriefData alloc] initWithTitle:NSLocalizableString(@"courseIntroduction", nil) time:classCuration brief:weakSelf.classInfo.commentStr];
//             HICTrainingBriefFrame *briefFrame = [[HICTrainingBriefFrame alloc] initWithData:briefData isOpened:NO];
//             [sectionDatas addObject:briefFrame];
//             // 课程奖励
//             HICTrainingOtherInfoFrame *rewardFrame = [[HICTrainingOtherInfoFrame alloc] initWithTitle:NSLocalizableString(@"courseRewards", nil) content:weakSelf.classInfo.rewardStr isSeparatorHidden:NO];
//             [sectionDatas addObject:rewardFrame];
//             // 培训对象
//             HICTrainingOtherInfoFrame *traineesFrame = [[HICTrainingOtherInfoFrame alloc] initWithTitle:NSLocalizableString(@"trainingObject", nil) content:weakSelf.classInfo.trainees isSeparatorHidden:YES];
//             [sectionDatas addObject:traineesFrame];
//             if (sectionDatas.count > 0) {
//                 [dataSections addObject:sectionDatas];
//                 sectionDatas = [[NSMutableArray alloc] init];
//             }
//
//
//             // 讲师简介
//             HICOfflineLecturerData *lecturerData = [[HICOfflineLecturerData alloc] initWithTitle:NSLocalizableString(@"lecturerIntroduction", nil) iconUrl:weakSelf.classInfo.lecturePicUrl name:[NSString realString:weakSelf.classInfo.lecturerName] post:weakSelf.classInfo.lecturerPost brief:weakSelf.classInfo.lecturerInfo isSeparatorHidden:NO];
//
//             if (weakSelf.classInfo.referenceMaterials.count > 0) {
//                 lecturerData.isSeparatorHidden = NO;
//             } else {
//                 lecturerData.isSeparatorHidden = YES;
//             }
//             HICOfflineLecturerFrame *lecturerFrame = [[HICOfflineLecturerFrame alloc] initWithData:lecturerData isOpened:NO];
//             [sectionDatas addObject:lecturerFrame];
//             if (weakSelf.classInfo.referenceMaterials.count > 0) {
//
//                 HICOfflineTitleData *data = [HICOfflineTitleData initWithTitle:NSLocalizableString(@"referenceMaterial", nil) cellHeight:50];
//                 [sectionDatas addObject:data];
//
//                 //有附件
//                 HICOfflineMaterialData *lastData;
//                 for (int i = 0; i < weakSelf.classInfo.referenceMaterials.count; i++) {
//                     HICReferenceMaterial *material = weakSelf.classInfo.referenceMaterials[i];
//                     HICOfflineMaterialData *data = [HICOfflineMaterialData initWithMaterial:material isSeparatorHidden:NO cellHeight:60];
//                     [sectionDatas addObject:data];
//                     lastData = data;
//                 }
//                 lastData.isSeparatorHidden = YES;
//             }
//             if (sectionDatas.count > 0) {
//                 [dataSections addObject:sectionDatas];
//                 sectionDatas = [[NSMutableArray alloc] init];
//             }
//
//
//             // 课程任务
//             if (weakSelf.classInfo.subTasks.count > 0) {
//                 HICOfflineTitleData *data = [HICOfflineTitleData initWithTitle:NSLocalizableString(@"courseTasks", nil) cellHeight:38];
//                 [sectionDatas addObject:data];
//
//                 HICOfflineClassTaskFrame *lastTaskFrame;
//                 for (int i = 0; i < weakSelf.classInfo.subTasks.count; i++) {
//                     HICSubTask *task = weakSelf.classInfo.subTasks[i];
//                     task.curTime = weakSelf.classInfo.curTime;
//
//                     HICOfflineClassTaskFrame *taskFrame = [HICOfflineClassTaskFrame initWithTask:task isSeparatorHidden:NO alpha:1.0];
//                     if (taskFrame.typeLblAtt && taskFrame.titleLblAtt && taskFrame.operateBtnAtt && taskFrame.timeLblAtt) {
//                         [sectionDatas addObject:taskFrame];
//                         lastTaskFrame = taskFrame;
//                     }
//
//                 }
//                 if (sectionDatas.count > 0) {
//                     lastTaskFrame.isSeparatorHidden = YES;
//                     [dataSections addObject:sectionDatas];
//                 }
//             }
//
//>>>>>>> af8d49656bc2961e17a970ac85b15a27a8ced5b0
            
            // 二维数组，将每个section作为一个元素放入，section内是cell数组
            NSMutableArray *dataSections = [[NSMutableArray alloc] init];
            weakSelf.dataSections = dataSections;
            NSMutableArray *sectionDatas = [[NSMutableArray alloc] init];
            // 上课表现
            if (_classInfo.classPerformRating.count > 0) {
                CGFloat performSum = 0;
                // 下发了上课表现
                NSInteger count = _classInfo.classPerformRating.count;
                if (count > 3) {
                    count = 3;
                }
                for (int i = 0; i < count; i++) {
                    HICClassPerformRating *perform = _classInfo.classPerformRating[i];
                    HICOfflineScoreCellData *scoreCellData = [HICOfflineScoreCellData dataWithTitle:[NSString realString:perform.reason] score:[NSString stringWithFormat:@"%@%@", [NSString formatFloat:perform.points],NSLocalizableString(@"points", nil)] isSeparatorHidden:YES maxFormatScore:[NSString stringWithFormat:@"100%@",NSLocalizableString(@"points", nil)] textFont:[UIFont fontWithName:@"PingFangSC-Regular" size:15] textColor:[UIColor colorWithHexString:@"#666666"] lblBgColor:[UIColor colorWithHexString:@"#F5F5F5"] topPadding:2 cellHeight:44];
                    [sectionDatas addObject:scoreCellData];
                }
                for (int i = 0; i < _classInfo.classPerformRating.count; i++) {
                    HICClassPerformRating *perform = _classInfo.classPerformRating[i];
                    performSum += perform.points;
                }
                
                if (_classInfo.classPerformRating.count > 3) {
                    HICOfflineAllScoreCellData *data = [HICOfflineAllScoreCellData initWithTitle:[NSString stringWithFormat:@"%@>",NSLocalizableString(@"lookAtAll", nil)] textFont:[UIFont fontWithName:@"PingFangSC-Regular" size:15] textColor:[UIColor colorWithHexString:@"#858585"] lblBgColor:[UIColor colorWithHexString:@"#F5F5F5"] cellHeight:44];
                    [sectionDatas addObject:data];
                }
                if (performSum > 0) {
                    HICOfflineScoreCellData *scoreCellData = [HICOfflineScoreCellData dataWithTitle:[NSString stringWithFormat:@"%@：",NSLocalizableString(@"classPerformanceScore", nil)] score:[NSString stringWithFormat:@"%@%@", [NSString formatFloat:performSum],NSLocalizableString(@"points", nil)] isSeparatorHidden:YES maxFormatScore:[NSString stringWithFormat:@"100%@",NSLocalizableString(@"points", nil)] textFont:[UIFont fontWithName:@"PingFangSC-Medium" size:16] textColor:[UIColor colorWithHexString:@"#333333"] lblBgColor:[UIColor clearColor] topPadding:5 cellHeight:48];
                    [sectionDatas insertObject:scoreCellData atIndex:0];
                }
            }
            if (_classInfo.score && _classInfo.score.floatValue >= 0) {
                // 课程成绩
                HICOfflineScoreCellData *scoreCellData = [HICOfflineScoreCellData dataWithTitle:[NSString stringWithFormat:@"%@：",NSLocalizableString(@"courseGrade", nil)] score:[NSString stringWithFormat:@"%@%@", [NSString formatFloat: _classInfo.score.floatValue],NSLocalizableString(@"points", nil)] isSeparatorHidden:NO maxFormatScore:[NSString stringWithFormat:@"100%@",NSLocalizableString(@"points", nil)] textFont:[UIFont fontWithName:@"PingFangSC-Medium" size:16] textColor:[UIColor colorWithHexString:@"#333333"] lblBgColor:[UIColor clearColor] topPadding:10 cellHeight:55];
                [sectionDatas insertObject:scoreCellData atIndex:0];
            }
            if (sectionDatas.count > 0) {
                id lastData = sectionDatas.lastObject;
                if ([lastData isKindOfClass:HICOfflineScoreCellData.class]) {
                    HICOfflineScoreCellData *scoreData = (HICOfflineScoreCellData *)lastData;
                    scoreData.cellHeight += 10;
                    scoreData.isSeparatorHidden = YES;
                } else if ([lastData isKindOfClass:HICOfflineAllScoreCellData.class]) {
                    HICOfflineAllScoreCellData *scoreData = (HICOfflineAllScoreCellData *)lastData;
                    scoreData.cellHeight += 10;
                }
                [dataSections addObject:sectionDatas];
                sectionDatas = [[NSMutableArray alloc] init];
            }
            // 课程简介
            NSString *classCuration = @"";
            if (self.pageType == TrainCourse) {
                classCuration = [NSString stringWithFormat:@"%@：%@", NSLocalizableString(@"standardOfClass", nil),weakSelf.classInfo.getCourseHourStr];
            }
            if (self.pageType == LectureCourse) {
                classCuration = [NSString stringWithFormat:@"%@：%@", NSLocalizableString(@"standardOfClass", nil),weakSelf.classInfo.getClassDurationStr];
            }
            HICTrainingBriefData *briefData = [[HICTrainingBriefData alloc] initWithTitle:NSLocalizableString(@"courseIntroduction", nil) time:classCuration brief:weakSelf.classInfo.commentStr];
            HICTrainingBriefFrame *briefFrame = [[HICTrainingBriefFrame alloc] initWithData:briefData isOpened:NO];
            [sectionDatas addObject:briefFrame];
            // 课程奖励
            HICTrainingOtherInfoFrame *rewardFrame = [[HICTrainingOtherInfoFrame alloc] initWithTitle:NSLocalizableString(@"courseRewards", nil) content:weakSelf.classInfo.rewardStr isSeparatorHidden:NO];
            [sectionDatas addObject:rewardFrame];
            // 培训对象
            HICTrainingOtherInfoFrame *traineesFrame = [[HICTrainingOtherInfoFrame alloc] initWithTitle:NSLocalizableString(@"trainingObject", nil) content:weakSelf.classInfo.trainees isSeparatorHidden:YES];
            [sectionDatas addObject:traineesFrame];
            if (sectionDatas.count > 0) {
                [dataSections addObject:sectionDatas];
                sectionDatas = [[NSMutableArray alloc] init];
            }
            // 讲师简介
            HICOfflineLecturerData *lecturerData = [[HICOfflineLecturerData alloc] initWithTitle:NSLocalizableString(@"lecturerIntroduction", nil) iconUrl:weakSelf.classInfo.lecturePicUrl name:[NSString realString:weakSelf.classInfo.lecturerName] post:weakSelf.classInfo.lecturerPost brief:weakSelf.classInfo.lecturerInfo isSeparatorHidden:NO];
            if (weakSelf.classInfo.referenceMaterials.count > 0) {
                lecturerData.isSeparatorHidden = NO;
            } else {
                lecturerData.isSeparatorHidden = YES;
            }
            HICOfflineLecturerFrame *lecturerFrame = [[HICOfflineLecturerFrame alloc] initWithData:lecturerData isOpened:NO];
            [sectionDatas addObject:lecturerFrame];
            if (weakSelf.classInfo.referenceMaterials.count > 0) {
                HICOfflineTitleData *data = [HICOfflineTitleData initWithTitle:NSLocalizableString(@"referenceMaterial", nil) cellHeight:50];
                [sectionDatas addObject:data];
                
                //有附件
                HICOfflineMaterialData *lastData;
                for (int i = 0; i < weakSelf.classInfo.referenceMaterials.count; i++) {
                    HICReferenceMaterial *material = weakSelf.classInfo.referenceMaterials[i];
                    HICOfflineMaterialData *data = [HICOfflineMaterialData initWithMaterial:material isSeparatorHidden:NO cellHeight:60];
                    [sectionDatas addObject:data];
                    lastData = data;
                }
                lastData.isSeparatorHidden = YES;
            }
            if (sectionDatas.count > 0) {
                [dataSections addObject:sectionDatas];
                sectionDatas = [[NSMutableArray alloc] init];
            }
            // 课程任务
            if (weakSelf.classInfo.subTasks.count > 0) {
                HICOfflineTitleData *data = [HICOfflineTitleData initWithTitle:NSLocalizableString(@"courseTasks", nil) cellHeight:38];
                [sectionDatas addObject:data];
                HICOfflineClassTaskFrame *lastTaskFrame;
                for (int i = 0; i < weakSelf.classInfo.subTasks.count; i++) {
                    HICSubTask *task = weakSelf.classInfo.subTasks[i];
                    task.curTime = weakSelf.classInfo.curTime;
                    
                    HICOfflineClassTaskFrame *taskFrame = [HICOfflineClassTaskFrame initWithTask:task isSeparatorHidden:NO alpha:1.0];
                    if (taskFrame.typeLblAtt && taskFrame.titleLblAtt && taskFrame.operateBtnAtt && taskFrame.timeLblAtt) {
                        [sectionDatas addObject:taskFrame];
                        lastTaskFrame = taskFrame;
                    }
                }
                if (sectionDatas.count > 0) {
                    lastTaskFrame.isSeparatorHidden = YES;
                    [dataSections addObject:sectionDatas];
                }
            }
            [weakSelf.table reloadData];
            // 更新bar背景图片高度
            [weakSelf.navBar updateBgImageHeight:weakSelf.headerFrame.headerHeight];
        } else {
            [self.defaultView setHidden:NO];
        }
        [RoleManager hiddenWindowLoadingView];
        
    } failure:^(NSError * _Nonnull error) {
        // 重新请求数据
        [RoleManager showErrorViewWith:self.view frame:CGRectMake(0, CGRectGetMaxY(weakSelf.navBar.frame), weakSelf.view.width, weakSelf.view.height-CGRectGetMaxY(weakSelf.navBar.frame)) blcok:^(NSInteger type) {
            [weakSelf requestData];
        }];
        [RoleManager hiddenWindowLoadingView];
    }];
}


/*
 #pragma mark - Navigation

 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
- (UITableView *)table {

    if (!_table) {
        UITableView *table = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        [self.view addSubview:table];
        _table = table;
        if (@available(iOS 11.0, *)) {
            _table.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        CGFloat bottomPadding = 0;
        if (HIC_isIPhoneX) {
            bottomPadding = HIC_BottomHeight;
        }
        _table.contentInset = UIEdgeInsetsMake(0, 0, bottomPadding, 0);
        _table.bounces = NO;
        _table.showsVerticalScrollIndicator = NO;
        _table.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
        _table.separatorStyle = UITableViewCellSeparatorStyleNone;

        _table.delegate = self;
        _table.dataSource = self;

        if (_navBar) {
            [self.view bringSubviewToFront:_navBar];
        }

        table.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
        table.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
        table.sectionHeaderHeight = CGFLOAT_MIN;
        table.sectionFooterHeight = CGFLOAT_MIN;
        if (@available(iOS 15.0, *)) {
            _table.sectionHeaderTopPadding = 0;
            table.sectionHeaderTopPadding = 0;
        }
    }

    return _table;
}


-(HomeTaskCenterDefaultView *)defaultView {
    if (!_defaultView) {
        HomeTaskCenterDefaultView *defaultView = [[HomeTaskCenterDefaultView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navBar.frame), self.view.width, self.view.height)];
        defaultView.titleStr = NSLocalizableString(@"temporarilyNoData", nil);
        [self.view addSubview:defaultView];
        _defaultView = defaultView;
    }
    return _defaultView;
}

- (HICStudyDocPhotoDetailView *)detailView {
    if (!_detailView) {
        CGFloat top = HIC_StatusBar_Height + 44;
        _detailView = [[HICStudyDocPhotoDetailView alloc] initWithFrame:CGRectMake(0, top, HIC_ScreenWidth, HIC_ScreenHeight - top)];
        _detailView.alpha = 0;
    }
    return _detailView;
}

- (void)playPhotos:(NSArray <HICOfflineTransFile *>*)datas {
    if (datas.count > 0) {

        NSMutableArray *urls = [[NSMutableArray alloc] init];
        for (int i = 0; i < datas.count; i++) {
            if ([NSString isValidString:datas[i].fileUrl]) {
                NSURL *url = [NSURL URLWithString: datas[i].fileUrl];
                if (url) {
                    [urls addObject:datas[i].fileUrl];
                }
            }
        }

        if (urls.count > 0) {
            HICPreviewScrollVC *photoVC = [HICPreviewScrollVC new];
            photoVC.dataSource = urls;
            [self.navigationController pushViewController:photoVC animated:YES];
            return;
        }
    }

    [HICToast showAtDefWithText:NSLocalizableString(@"contentIsNotSupported", nil)];
}

- (void)playPhoto:(NSString *)urlStr {
    if ([NSString isValidString:urlStr]) {
        NSURL *url = [NSURL URLWithString:urlStr];
        if (url) {
            HICPreviewScrollVC *photoVC = [HICPreviewScrollVC new];
            photoVC.dataSource = @[urlStr];
            [self.navigationController pushViewController:photoVC animated:NO];
            return;
        }
    }

    [HICToast showAtDefWithText:NSLocalizableString(@"contentIsNotSupported", nil)];
}

- (void)playVideoOrVoice:(NSURL *)url {
    if (url) {
        AVPlayer *player = [AVPlayer playerWithURL:url];
        AVPlayerViewController *playerViewController = [AVPlayerViewController new];
        playerViewController.player = player;
        [self presentViewController:playerViewController animated:YES completion:nil];
        [playerViewController.player play];
    } else {
        [HICToast showAtDefWithText:NSLocalizableString(@"contentIsNotSupported", nil)];
    }

}


- (void)handleSignIn:(HICOfflineClassTaskFrame *)taskFrame indexPath:(NSIndexPath *)indexPath {
    // 签到
    BOOL isSuccess = NO;
    NSInteger errorCode = 0;
    NSString *errorMsg;
    NSInteger signSeverType = 1; // 默认位置签
    // 1. 判断是否在时间范围内
    if (taskFrame.task.attendanceRequires.startTime <= taskFrame.task.curTime) {
        // 表示此时时间正确
        if (taskFrame.task.attendanceRequires.latitude.doubleValue > 0 && taskFrame.task.attendanceRequires.longitude.doubleValue > 0) {
            // 1. 表示存在位置签到
            [[OTPSignManager shareInstance] updateLocationUserInfo];
            if ([[OTPSignManager shareInstance] isInClassLocationWithLat:taskFrame.task.attendanceRequires.latitude.doubleValue andLon:taskFrame.task.attendanceRequires.longitude.doubleValue radiu:taskFrame.task.attendanceRequires.radius]) {
                // 位置正确
                isSuccess = YES;
            }else if (taskFrame.task.attendanceRequires.password && ![taskFrame.task.attendanceRequires.password isEqualToString:@""]) {
                // 存在口令签到， 进行口令签到
                isSuccess = YES;
                signSeverType = 2;
            }else {
                // 位置不正确
                errorCode = 1;
                errorMsg = NSLocalizableString(@"noSignInRange", nil);
            }
        }else if (taskFrame.task.attendanceRequires.password && ![taskFrame.task.attendanceRequires.password isEqualToString:@""]) {
            // 存在口令签到， 进行口令签到
            isSuccess = YES;
            signSeverType = 2;
        }else {
            // 没有位置签到，同时也没有口令签到
            isSuccess = YES;
            signSeverType = 3;
        }
    }else {
        // 表示未到签到时间范围
        errorCode = 1;
        errorMsg = NSLocalizableString(@"earlySignInTime", nil);
    }

    [self handleSignWithTaskFrame:taskFrame signType:1 signToSeverType:signSeverType isSignSuccess:isSuccess errorMsg:errorMsg errorCode:errorCode indexPath:indexPath];
}


- (void)handleSignBack:(HICOfflineClassTaskFrame *)taskFrame indexPath:(NSIndexPath *)indexPath {

    // 签退
    BOOL isSuccess = NO;
    NSInteger errorCode = 0;
    NSString *errorMsg;
    NSInteger signSeverType = 1; // 默认位置签
    // 1. 判断当前时间是否是签退的正常时间
    if (taskFrame.task.attendanceRequires.startTime < taskFrame.task.curTime) {
        // 表示时间正常可以签退
        if (taskFrame.task.attendanceRequires.latitude.doubleValue > 0 && taskFrame.task.attendanceRequires.longitude.doubleValue > 0) {
            // 1. 表示存在位置签退
            [[OTPSignManager shareInstance] updateLocationUserInfo];
            if ([[OTPSignManager shareInstance] isInClassLocationWithLat:taskFrame.task.attendanceRequires.latitude.doubleValue andLon:taskFrame.task.attendanceRequires.longitude.doubleValue radiu:taskFrame.task.attendanceRequires.radius]) {
                // 位置正确
                isSuccess = YES;
            }else if (taskFrame.task.attendanceRequires.password && ![taskFrame.task.attendanceRequires.password isEqualToString:@""]) {
                // 存在口令签退， 进行口令签退
                isSuccess = YES;
                signSeverType = 2;
            }else {
                // 位置不正确 - 并且不存在口令签退
                errorCode = 1;
                errorMsg = NSLocalizableString(@"signOffRangeNotReached", nil);
            }
        }else if (taskFrame.task.attendanceRequires.password && ![taskFrame.task.attendanceRequires.password isEqualToString:@""]) {
            // 存在口令签到， 进行口令签退
            isSuccess = YES;
            signSeverType = 2;
        }else {
            // 没有位置签到，同时也没有口令签退
            isSuccess = YES;
            signSeverType = 3;
        }
    }else {
        // 签退的时间早了 -- 早退
        errorCode = 3;
        errorMsg = NSLocalizableString(@"leaveEarly", nil);
        if (taskFrame.task.attendanceRequires.latitude.doubleValue > 0 && taskFrame.task.attendanceRequires.longitude.doubleValue > 0) {
            // 1. 表示存在位置签退
            [[OTPSignManager shareInstance] updateLocationUserInfo];
            if ([[OTPSignManager shareInstance] isInClassLocationWithLat:taskFrame.task.attendanceRequires.latitude.doubleValue andLon:taskFrame.task.attendanceRequires.longitude.doubleValue radiu:taskFrame.task.attendanceRequires.radius]) {
                // 位置正确
                isSuccess = YES;
            }else if (taskFrame.task.attendanceRequires.password && ![taskFrame.task.attendanceRequires.password isEqualToString:@""]) {
                // 存在口令签退， 进行口令签退
                isSuccess = YES;
                signSeverType = 2;
            }else {
                // 位置不正确 - 并且不存在口令签退
                errorMsg = NSLocalizableString(@"signOffRangeNotReached", nil);
            }
        }else if (taskFrame.task.attendanceRequires.password && ![taskFrame.task.attendanceRequires.password isEqualToString:@""]) {
            // 存在口令签到， 进行口令签退
            isSuccess = YES;
            signSeverType = 2;
        }else {
            // 没有位置签到，同时也没有口令签退
            isSuccess = YES;
            signSeverType = 3;
        }
    }
    [self handleSignWithTaskFrame:taskFrame signType:2 signToSeverType:signSeverType isSignSuccess:isSuccess errorMsg:errorMsg errorCode:errorCode  indexPath:indexPath];

}


- (void)handleSignWithTaskFrame:(HICOfflineClassTaskFrame *)taskFrame signType:(NSInteger)signType signToSeverType:(NSInteger)severType isSignSuccess:(BOOL)isSuccess errorMsg:(NSString *)msg errorCode:(NSInteger)errorCode indexPath:(NSIndexPath *)indexPath {


    HICSubTask *model = taskFrame.task;

    BOOL isSuc = isSuccess;
    if (isSuccess && errorCode != 3) {
        // 成功的
        if (signType == 1) {
            // 签到
            if (severType == 2) {
                // 需要输入口令
                [OTPSignPassView showWindowPassViewBlock:^(NSString * _Nonnull inputText) {
                    if ([inputText isEqualToString:model.attendanceRequires.password]) {
                        // 口令一致的情况下
                        [self signBackToSever:NO andIsBefore:NO andTaskFrame:taskFrame andSeverType:severType msg:inputText indexPath:indexPath];
                    }else {
                        [HICToast showWithText:NSLocalizableString(@"incorrectPasswordPrompt", nil)];
                    }
                }];
            }else {
                [self signBackToSever:NO andIsBefore:NO andTaskFrame:taskFrame andSeverType:severType msg:@"" indexPath:indexPath];
            }
        }else if (signType == 2) {
            // 签退
            if (severType == 2) {
                // 需要输入口令
                [OTPSignPassView showWindowPassViewBlock:^(NSString * _Nonnull inputText) {
                    if ([inputText isEqualToString:model.attendanceRequires.password]) {
                        // 口令一致的情况下
                        [self signBackToSever:YES andIsBefore:NO andTaskFrame:taskFrame andSeverType:severType msg:@"" indexPath:indexPath];
                    }else {
                        [HICToast showWithText:NSLocalizableString(@"incorrectPasswordPrompt", nil)];
                    }
                }];
            }else {
                [self signBackToSever:YES andIsBefore:NO andTaskFrame:taskFrame andSeverType:severType msg:@"" indexPath:indexPath];
            }
        }
    }else {
        // 失败的 再判断是否为早退
        if (errorCode == 3) {
            // 早退
            isSuc = isSuccess;
            if (isSuccess) {
                if (severType == 2) {
                    // 需要输入口令
                    [OTPSignPassView showWindowPassViewBlock:^(NSString * _Nonnull inputText) {
                        if ([inputText isEqualToString:model.attendanceRequires.password]) {
                            // 口令一致的情况下 -- 输入原因
                            [OTPSignBackView showWindowSignBackViewBlock:^(NSString * _Nonnull inputText) {
                                if ([inputText isEqualToString:@""]) {
                                    [HICToast showWithText:NSLocalizableString(@"enterReasonForLeavingEarly", nil)];
                                }else {
                                    // 早退签到
                                    //                                    NSInteger backId = model.taskId*100 + model.taskType; - 理由不需要存储
                                    //                                    NSDictionary *dic = @{@"backId":[NSNumber numberWithInteger:backId],
                                    //                                                          @"msg": inputText
                                    //                                    };
                                    //                                    OfflineTrainPlanListVC *vc = (OfflineTrainPlanListVC *)self.parentViewController;
                                    //                                    [vc.signBackSources addObject:dic];
                                    // 进行签退处理
                                    [self signBackToSever:YES andIsBefore:YES andTaskFrame:taskFrame andSeverType:severType msg:inputText indexPath:indexPath];
                                }
                            }];
                        }else {
                            [HICToast showWithText:NSLocalizableString(@"incorrectPasswordPrompt", nil)];
                        }
                    }];
                }else {
                    [OTPSignBackView showWindowSignBackViewBlock:^(NSString * _Nonnull inputText) {
                        if ([inputText isEqualToString:@""]) {
                            [HICToast showWithText:NSLocalizableString(@"enterReasonForLeavingEarly", nil)];
                        }else {
                            // 早退签到
                            //                            NSInteger backId = model.taskId*100 + model.taskType;
                            //                            NSDictionary *dic = @{@"backId":[NSNumber numberWithInteger:backId],
                            //                                                  @"msg": inputText
                            //                            };
                            //                            OfflineTrainPlanListVC *vc = (OfflineTrainPlanListVC *)self.parentViewController;
                            //                            [vc.signBackSources addObject:dic];
                            // 进行签退处理
                            [self signBackToSever:YES andIsBefore:YES andTaskFrame:taskFrame andSeverType:severType msg:inputText indexPath:indexPath];
                        }
                    }];
                }
            }

        }
    }
    // 签到/退流程
    if (isSuc) {
        // 请求接口
    }else {
        [HICToast showWithText:msg];
    }
}

-(void)signBackToSever:(BOOL)isBack andIsBefore:(BOOL)isBefore andTaskFrame:(HICOfflineClassTaskFrame *)taskFrame andSeverType:(NSInteger)severType msg:(NSString *)msg  indexPath:(NSIndexPath *)indexPath {
    
    HICSubTask *model = taskFrame.task;
    
    NSInteger taskType = 0;
    NSString *message = @"";
    NSString *pass = @"";
    if (isBack) {
        // 签退
        taskType = 10;
    }else {
        // 签到
        taskType = 9;
    }
    if (isBefore) {
        message = msg;
    }
    if (severType == 2) {
        // 口令
        pass = msg;
    }
    __weak typeof(self) weakSelf = self;
    NSDictionary *dic;// 重新刷新的时候不用穿message
    if (severType == 4) {
        dic = @{@"attendanceTaskId":[NSNumber numberWithInteger:model.taskId], @"customerId":USER_CID, @"taskType":[NSNumber numberWithInteger:taskType], @"signInTime":[HICCommonUtils getNowTimeTimestamp], @"signInSecret":pass};
    }else {
        dic = @{@"attendanceTaskId":[NSNumber numberWithInteger:model.taskId], @"customerId":USER_CID, @"taskType":[NSNumber numberWithInteger:taskType], @"signInTime":[HICCommonUtils getNowTimeTimestamp], @"message":message, @"signInSecret":pass};
    }
    [HICAPI checkInAndSignOut:dic success:^(NSDictionary * _Nonnull responseObject) {
        // 成功后刷新页面
        [weakSelf requestData];
    } failure:^(NSError * _Nonnull error) {
        // 失败后刷新页面
        [weakSelf requestData];
    }];
}

// 重新签退
- (void)signBackAgain:(HICOfflineClassTaskFrame *)taskFrame password:(BOOL)isPassword  indexPath:(NSIndexPath *)indexPath {

    HICSubTask *model = taskFrame.task;

    // 重新签退
    // 存在可以签退刷新 -- 签退处理
    if (isPassword) {
        [OTPSignPassView showWindowPassViewBlock:^(NSString * _Nonnull inputText) {
            if ([inputText isEqualToString:model.attendanceRequires.password]) {
                // 口令一致的情况下 -- 输入原因
                [self signBackToSever:YES andIsBefore:YES andTaskFrame:taskFrame andSeverType:4 msg:@"" indexPath:indexPath];
            }else {
                [HICToast showWithText:NSLocalizableString(@"incorrectPasswordPrompt", nil)];
            }

        }];
    }else {
        [self signBackToSever:YES andIsBefore:YES andTaskFrame:taskFrame andSeverType:4 msg:@"" indexPath:indexPath];
    }
}


#pragma UITableView Delegates
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSInteger section = indexPath.section;
    NSInteger index = indexPath.row;

    if (_dataSections.count > section) {

        NSArray *sectionDatas = _dataSections[section];
        if (sectionDatas.count > index) {

            id data = sectionDatas[index];

            if ([data isKindOfClass:HICOfflineScoreCellData.class]) {
                HICOfflineScoreCellData *_data = (HICOfflineScoreCellData *)data;
                return _data.cellHeight;
            }

            if ([data isKindOfClass:HICOfflineAllScoreCellData.class]) {
                HICOfflineAllScoreCellData *_data = (HICOfflineAllScoreCellData *)data;
                return _data.cellHeight;
            }

            if ([data isKindOfClass:HICTrainingBriefFrame.class]) {
                HICTrainingBriefFrame *_data = (HICTrainingBriefFrame *)data;
                return _data.cellHeight;
            }

            if ([data isKindOfClass:HICTrainingOtherInfoFrame.class]) {
                HICTrainingOtherInfoFrame *_data = (HICTrainingOtherInfoFrame *)data;
                return _data.cellHeight;
            }

            if ([data isKindOfClass:HICOfflineLecturerFrame.class]) {
                HICOfflineLecturerFrame *_data = (HICOfflineLecturerFrame *)data;
                return _data.cellHeight;
            }

            if ([data isKindOfClass:HICOfflineTitleData.class]) {
                HICOfflineTitleData *_data = (HICOfflineTitleData *)data;
                return _data.cellHeight;
            }


            if ([data isKindOfClass:HICOfflineMaterialData.class]) {
                HICOfflineMaterialData *_data = (HICOfflineMaterialData *)data;
                return _data.cellHeight;
            }

            if ([data isKindOfClass:HICOfflineClassTaskFrame.class]) {
                HICOfflineClassTaskFrame *_data = (HICOfflineClassTaskFrame *)data;
                return _data.cellHeight;
            }

        }

    }


    return 0;

}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell;

    NSInteger section = indexPath.section;
    NSInteger index = indexPath.row;

    if (_dataSections.count > section) {

        NSArray *sectionDatas = _dataSections[section];
        if (sectionDatas.count > index) {

            id data = sectionDatas[index];

            if ([data isKindOfClass:HICOfflineScoreCellData.class]) {
                HICOfflineScoreCellData *_data = (HICOfflineScoreCellData *)data;
                HICOfflineScoreCell  *cell = [HICOfflineScoreCell cellWithTableView:tableView];
                cell.data = _data;
                return cell;
            }

            if ([data isKindOfClass:HICOfflineAllScoreCellData.class]) {
                HICOfflineAllScoreCellData *_data = (HICOfflineAllScoreCellData *)data;
                HICOfflineAllScoreCell *cell = [HICOfflineAllScoreCell cellWithTableView:tableView];
                cell.data = _data;
                return cell;
            }

            if ([data isKindOfClass:HICTrainingBriefFrame.class]) {
                HICTrainingBriefFrame *_data = (HICTrainingBriefFrame *)data;
                HICTrainingBriefCell *cell = [HICTrainingBriefCell cellWithTableView:tableView];
                __weak typeof(self) weakSelf = self;
                [cell setOpenOrShrinkBlock:^(HICTrainingBriefCell * _Nonnull _cell) {
                    _cell.briefFrame.isOpened = !_cell.briefFrame.isOpened;
                    [weakSelf.table reloadData];
                }];
                cell.briefFrame = _data;
                return cell;
            }

            if ([data isKindOfClass:HICTrainingOtherInfoFrame.class]) {
                HICTrainingOtherInfoFrame *_data = (HICTrainingOtherInfoFrame *)data;
                HICTrainingOtherInfoCell *cell = [HICTrainingOtherInfoCell cellWithTableView:tableView];
                cell.infoFrame = _data;
                return cell;
            }

            if ([data isKindOfClass:HICOfflineLecturerFrame.class]) {
                HICOfflineLecturerFrame *_data = (HICOfflineLecturerFrame *)data;
                HICOfflineLecturerCell *cell = [HICOfflineLecturerCell cellWithTableView:tableView];
                __weak typeof(self) weakSelf = self;
                [cell setOpenOrShrinkBlock:^(HICOfflineLecturerCell * _Nonnull _cell) {
                    _cell.lecturerFrame.isOpened = !_cell.lecturerFrame.isOpened;
                    [weakSelf.table reloadData];
                }];
                [cell setIconClickedBlock:^(HICOfflineLecturerCell * _Nonnull  _cell) {
                    HICLectureDetailVC *lecVC = [[HICLectureDetailVC alloc] init];
                    lecVC.lecturerId = weakSelf.classInfo.lecturerId;
                    if (self.navigationController) {
                        [weakSelf.navigationController pushViewController:lecVC animated:YES];
                    } else {
                        [weakSelf presentViewController:lecVC animated:YES completion:nil];
                    }

                }];
                cell.lecturerFrame = _data;
                return cell;
            }

            if ([data isKindOfClass:HICOfflineTitleData.class]) {
                HICOfflineTitleData *_data = (HICOfflineTitleData *)data;
                HICOfflineTitleCell *cell = [HICOfflineTitleCell cellWithTableView:tableView];
                cell.data = _data;
                return cell;
            }

            if ([data isKindOfClass:HICOfflineMaterialData.class]) {
                HICOfflineMaterialData *_data = (HICOfflineMaterialData *)data;
                HICOfflineMaterialCell *cell = [HICOfflineMaterialCell cellWithTableView:tableView];
                cell.data = _data;
                return cell;
            }

            if ([data isKindOfClass:HICOfflineClassTaskFrame.class]) {
                HICOfflineClassTaskFrame *_data = (HICOfflineClassTaskFrame *)data;
                HICOfflineClassTaskCell *cell = [HICOfflineClassTaskCell cellWithTableView:tableView];
                __weak typeof(self) weakSelf = self;
                [cell setClickedTaskBlock:^(HICOfflineClassTaskCell * _Nonnull _cell) {
                    // 签到、签退；打开作业；打开考评；打开问卷；

                    HICSubTask *task = _cell.taskFrame.task;

                    if (task.taskType == Homework) {
                        // 直接调转到指定页面
                        HICHomeworkListVC *vc = HICHomeworkListVC.new;
                        vc.trainId = [NSNumber numberWithInteger:weakSelf.trainId];
                        vc.workId = [NSNumber numberWithInteger:task.taskId];
                        vc.homeworkTitle = task.taskName;
                        [self.navigationController pushViewController:vc animated:YES];
                    } else if (task.taskType == Questionnaire) {
                        // 问卷 -- 跳转到问卷页面
                        HICTrainQuestionVC *vc = HICTrainQuestionVC.new;
                        vc.trainId = [NSNumber numberWithInteger:weakSelf.trainId];
                        vc.taskId = [NSNumber numberWithInteger:task.taskId];
                        [self.navigationController pushViewController:vc animated:YES];
                    } else if (task.taskType == Evaluate){
                        // 评价 -- 跳转页面
                        HICTrainQuestionVC *vc = HICTrainQuestionVC.new;
                        vc.trainId = [NSNumber numberWithInteger:weakSelf.trainId];
                        vc.taskId = [NSNumber numberWithInteger:task.taskId];
                        [self.navigationController pushViewController:vc animated:YES];
                    } else {
                        // 签到、签退
                        NSIndexPath *indexPath = [weakSelf.table indexPathForCell:_cell];
                        if (task.taskType == SignIn) {
                            [weakSelf handleSignIn:_cell.taskFrame  indexPath:indexPath];
                        } else if (cell.taskFrame.task.taskType == SignBack) {
                            [weakSelf handleSignBack:_cell.taskFrame  indexPath:indexPath];
                        }
                    }

                }];
                [cell setClickedMapBlock:^(HICOfflineClassTaskCell * _Nonnull _cell) {
                    // 跳转地图
                    OTPSignMapViewVC *vc = [OTPSignMapViewVC new];
                    vc.center = CLLocationCoordinate2DMake(_cell.taskFrame.task.attendanceRequires.latitude.doubleValue, _cell.taskFrame.task.attendanceRequires.longitude.doubleValue);
                    vc.radius = _cell.taskFrame.task.attendanceRequires.radius;
                    vc.modalPresentationStyle = UIModalPresentationFullScreen;
                    [self presentViewController:vc animated:YES completion:^{

                    }];
                }];
                [cell setClickedRefreshBlock:^(HICOfflineClassTaskCell * _Nonnull _cell) {
                    // 重新签退

                    HICSubTask *task = _cell.taskFrame.task;

                    NSIndexPath *indexPath = [weakSelf.table indexPathForCell:_cell];

                    if (task.attendanceRequires.latitude.doubleValue > 0 && task.attendanceRequires.longitude.doubleValue > 0) {
                        // 1. 表示存在位置签退
                        [[OTPSignManager shareInstance] updateLocationUserInfo];
                        if ([[OTPSignManager shareInstance] isInClassLocationWithLat:task.attendanceRequires.latitude.doubleValue andLon:task.attendanceRequires.longitude.doubleValue radiu:task.attendanceRequires.radius]) {
                            [weakSelf signBackAgain:_cell.taskFrame password:NO indexPath:indexPath];
                        }else if (task.attendanceRequires.password && ![task.attendanceRequires.password isEqualToString:@""]) {
                            // 存在口令签退， 进行口令签退
                            [weakSelf signBackAgain:_cell.taskFrame password:YES indexPath:indexPath];
                        }else {
                            // 位置不正确 - 并且不存在口令签退
                            [HICToast showWithText:NSLocalizableString(@"signOffRangeNotReached", nil)];
                        }
                    }else if (task.attendanceRequires.password && ![task.attendanceRequires.password isEqualToString:@""]) {
                        // 存在口令签到， 进行口令签退
                        [weakSelf signBackAgain:_cell.taskFrame password:YES indexPath:indexPath];
                    }else {
                        // 没有位置签到，同时也没有口令签退
                        [weakSelf signBackAgain:_cell.taskFrame password:NO indexPath:indexPath];
                    }

                }];
                cell.taskFrame = _data;
                return cell;
            }

        }

    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger index = indexPath.row;

    if (_dataSections.count > section) {

        NSArray *sectionDatas = _dataSections[section];
        if (sectionDatas.count > index) {

            id data = sectionDatas[index];

            if ([data isKindOfClass:HICOfflineClassTaskFrame.class]) {
                HICOfflineClassTaskFrame *_data = (HICOfflineClassTaskFrame *)data;

                if (!_data.operateBtnAtt.isBtnEnable) {
                    return;
                }


                HICSubTask *task = _data.task;

                if (task.taskType == Homework) {
                    // 直接调转到指定页面
                    HICHomeworkListVC *vc = HICHomeworkListVC.new;
                    vc.trainId = [NSNumber numberWithInteger:self.trainId];
                    vc.workId = [NSNumber numberWithInteger:task.taskId];
                    vc.homeworkTitle = task.taskName;
                    [self.navigationController pushViewController:vc animated:YES];
                } else if (task.taskType == Questionnaire) {
                    // 问卷 -- 跳转到问卷页面
                    HICTrainQuestionVC *vc = HICTrainQuestionVC.new;
                    vc.trainId = [NSNumber numberWithInteger:self.trainId];
                    vc.taskId = [NSNumber numberWithInteger:task.taskId];
                    [self.navigationController pushViewController:vc animated:YES];
                } else if (task.taskType == Evaluate){
                    // 评价 -- 跳转页面
                    HICTrainQuestionVC *vc = HICTrainQuestionVC.new;
                    vc.trainId = [NSNumber numberWithInteger:self.trainId];
                    vc.taskId = [NSNumber numberWithInteger:task.taskId];
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }

            if ([data isKindOfClass:HICOfflineAllScoreCellData.class]) {
                // 展示全部表现
                NSInteger count = _classInfo.classPerformRating.count;
                if (count > 3) {
                    NSMutableArray *datas = _dataSections.firstObject;
                    [datas removeLastObject];
                    HICOfflineScoreCellData *lastScoreData;
                    for (int i = 3; i < count; i++) {
                        HICClassPerformRating *perform = _classInfo.classPerformRating[i];
                                               HICOfflineScoreCellData *scoreCellData = [HICOfflineScoreCellData dataWithTitle:[NSString realString:perform.reason] score:[NSString stringWithFormat:@"%@%@", [NSString formatFloat:perform.points],NSLocalizableString(@"points", nil)] isSeparatorHidden:YES maxFormatScore:[NSString stringWithFormat:@"100%@",NSLocalizableString(@"points", nil)] textFont:[UIFont fontWithName:@"PingFangSC-Regular" size:15] textColor:[UIColor colorWithHexString:@"#666666"] lblBgColor:[UIColor colorWithHexString:@"#F5F5F5"] topPadding:2 cellHeight:44];
                        [datas addObject:scoreCellData];
                        lastScoreData = scoreCellData;
                    }
                    lastScoreData.cellHeight += 14;
                    lastScoreData.isSeparatorHidden = YES;

                    [tableView reloadData];
                }
            }


            if ([data isKindOfClass:HICOfflineMaterialData.class]) {
                HICOfflineMaterialData *_data = (HICOfflineMaterialData *)data;
                switch (_data.data.type) {
                    case Image:
                        [self playPhoto:_data.data.url];
                        break;
                    case Document:
                        [self playPhotos:_data.data.transFiles];
                        break;
                    case Video:
                        if ([_data.data.transFiles.firstObject isKindOfClass:HICOfflineTransFile.class]) {
                            HICOfflineTransFile *fileData = (HICOfflineTransFile *)_data.data.transFiles.firstObject;
                            if (fileData.fileUrl) {
                                NSURL *url = [NSURL URLWithString:fileData.fileUrl];
                                [self playVideoOrVoice:url];
                            }
                        }
                        break;
                    case Voice:
                        if ([_data.data.transFiles.firstObject isKindOfClass:HICOfflineTransFile.class]) {
                            HICOfflineTransFile *fileData = (HICOfflineTransFile *)_data.data.transFiles.firstObject;
                            if (fileData.fileUrl) {
                                NSURL *url = [NSURL URLWithString:fileData.fileUrl];
                                [self playVideoOrVoice:url];
                            }
                        }
                        break;
                }
            }
        }
    }
}



- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (_dataSections.count > section) {

        NSArray *sectionDatas = _dataSections[section];
        return sectionDatas.count;
    }

    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataSections.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (!_headerFrame) {
        return nil;
    }

    UIView *view = nil;
    if (section == 0) {
        view = [[HICOfflineClassHeaderView alloc] initWithHeaderFrame:_headerFrame];
    } else {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 8)];
        view.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    }


    return view ;

}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    if (!_headerFrame) {
        return 0;
    }

    CGFloat height = 0;
    if (section == 0) {
        height = _headerFrame.headerHeight;
    } else {
        height = 8;
    }

    return height;

}


- (void)removeDetailViewWithIndex:(NSInteger)currentIndex{
    [self.detailView removeFromSuperview];
}
- (void)returnIndex:(NSInteger)currentIndex {

}



@end
