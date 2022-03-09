//
//  OfflineTrainPlanListDetailVCView.m
//  HiClass
//
//  Created by 铁柱， on 2020/4/15.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "OfflineTrainPlanListDetailVCView.h"

#import "OTPListDetailAllCell.h"
#import "OTPListDetailClassCell.h"
#import "OTPListDetailSignCell.h"
#import "OTPListDetailExamCell.h"
#import "OTPListDetailHomeworkCell.h"
#import "OTPListDetailQuestionnaireCell.h"
#import "OTPListDetailEvaluateCell.h"
#import "OTPListDetailLineGradeCell.h"

#import "OTPSignPassView.h"
#import "OTPSignBackView.h"
#import "OTPSignBackVC.h"
#import "OTPSignMapViewVC.h"
#import "HomeTaskCenterDefaultView.h"
#import "HICExamCenterDetailVC.h"
#import "OfflineTrainingListModel.h"
#import "HICHomeworkListVC.h"
#import "HICTrainQuestionVC.h"
#import "HICOfflineCourseDetailVC.h"
#import "OfflineTrainPlanListVC.h"
@interface OfflineTrainPlanListDetailVCView ()<UITableViewDataSource, UITableViewDelegate, OTPListBaseCellDelegate>

@property (nonatomic, strong) UITableView *tableView; // 内部滑动视图
@property (nonatomic, strong) HomeTaskCenterDefaultView *defalutView; // 缺省页面

@end

@implementation OfflineTrainPlanListDetailVCView
#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
//    self.tableView.estimatedRowHeight =0;
//    self.tableView.estimatedSectionHeaderHeight =0;
//    self.tableView.estimatedSectionFooterHeight =0;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#f8f8f8"];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self reloadDataTableView]; // 刷新页面
}

-(void)reloadDataTableView {
    // 进入时隐藏缺省页面
    self.defalutView.hidden = YES;
    if (self.cellModel && _tableView) {
        [self.tableView reloadData];
        if (self.cellModel.currentTimeIndex < self.cellModel.listModels.count && self.cellModel.currentTimeIndex != -1) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.cellModel.currentTimeIndex inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:YES];
            });
        }
        if (self.cellModel.listModels.count == 0) {
            // 显示缺省页面
            self.defalutView.hidden = NO;
        }
    }else {
        // 显示缺省页面
        self.defalutView.hidden = NO;
    }
}

#pragma mark - 页面刷新
-(void)refreshData {
    [self reloadDataTableView];
}

#pragma mark - Tableview DataSource协议方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cellModel ? self.cellModel.listModels.count : 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OTPListBaseCell *cell;
    if (_detailType == PlanDetailType_All) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"AllCell" forIndexPath:indexPath];
    }else if (_detailType == PlanDetailType_Class) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"ClassCell" forIndexPath:indexPath];
    }else if (_detailType == PlanDetailType_Sign){
        cell = [tableView dequeueReusableCellWithIdentifier:@"SignCell" forIndexPath:indexPath];
    }else if (_detailType == PlanDetailType_Exam){
        cell = [tableView dequeueReusableCellWithIdentifier:@"ExamCell" forIndexPath:indexPath];
    }else if (_detailType == PlanDetailType_Homework){
        cell = [tableView dequeueReusableCellWithIdentifier:@"HomeworkCell" forIndexPath:indexPath];
    }else if (_detailType == PlanDetailType_Questionnaire){
        cell = [tableView dequeueReusableCellWithIdentifier:@"QuestionnaireCell" forIndexPath:indexPath];
    }else if (_detailType == PlanDetailType_Evaluate){
        cell = [tableView dequeueReusableCellWithIdentifier:@"EvaluateCell" forIndexPath:indexPath];
    }else if (_detailType == PlabDetailType_Grade) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"LineGradeCell" forIndexPath:indexPath];
    }else {
        // 最后兜底的 基本cell
        cell = [tableView dequeueReusableCellWithIdentifier:@"BaseCell" forIndexPath:indexPath];
    }

    cell.cellIndexPath = indexPath;
    if (indexPath.row < self.cellModel.listModels.count) {
        cell.modelDatas = [self.cellModel.listModels objectAtIndex:indexPath.row];
    }

    // 时间颜色赋值
    if (indexPath.row < self.cellModel.listCellTimes.count) {
        if (self.cellModel.currentTimeIndex == indexPath.row) {
            // 两个数据相同则表示同一个时间即为今天
            cell.circleLayer.strokeColor = cell.circleColors.firstObject.CGColor;
            cell.timeCellLabel.text = NSLocalizableString(@"today", nil);
            cell.timeCellLabel.textColor = cell.circleColors.firstObject;
        }else {
            cell.circleLayer.strokeColor = cell.circleColors.lastObject.CGColor;
            cell.timeCellLabel.text = [self.cellModel.listCellTimes objectAtIndex:indexPath.row];
            cell.timeCellLabel.textColor = cell.circleColors.lastObject;
        }
    }
    cell.delegate = self;

    return cell;
}

#pragma mark - tableView delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0.f;
    if (indexPath.row < self.cellModel.listCellHeight.count) {
        NSNumber *cellHeight = self.cellModel.listCellHeight[indexPath.row];
        height = [cellHeight doubleValue];
    }

    return height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.row % 3 == 0) {

//    }else if (indexPath.row % 3 == 1) {
//        OTPSignBackVC *vc = [OTPSignBackVC new];
//        vc.modalPresentationStyle = UIModalPresentationFullScreen;
//        [self presentViewController:vc animated:YES completion:nil];
//    } else {
//
//    }

}

#pragma mark - cell的点击事件处理
/// 签到/退的事件处理
/// @param cell 当前cell
/// @param model 当前的数据模型
/// @param signType 签到/退类型 1：签到 2：签退
/// @param severType 签到/退是按什么签到/退 1：位置签 2：口令签 3：什么都没有
/// @param isSuccess 是否成功
/// @param msg 错误信息
/// @param errorCode 错误code 1：位置错误 2：时间错误 3：早退
-(void)listBaseCell:(OTPListBaseCell *)cell signModel:(OfflineTrainingListModel *)model signType:(NSInteger)signType signToSeverType:(NSInteger)severType isSignSuccess:(BOOL)isSuccess errorMsg:(NSString *)msg errorCode:(NSInteger)errorCode {

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
                        [self signBackToSever:NO andIsBefore:NO andModel:model andSeverType:severType msg:inputText];
                    }else {
                        [HICToast showWithText:NSLocalizableString(@"incorrectPasswordPrompt", nil)];
                    }
                }];
            }else {
                [self signBackToSever:NO andIsBefore:NO andModel:model andSeverType:severType msg:@""];
            }
        }else if (signType == 2) {
            // 签退
            if (severType == 2) {
                // 需要输入口令
                [OTPSignPassView showWindowPassViewBlock:^(NSString * _Nonnull inputText) {
                    if ([inputText isEqualToString:model.attendanceRequires.password]) {
                        // 口令一致的情况下
                        [self signBackToSever:YES andIsBefore:NO andModel:model andSeverType:severType msg:@""];
                    }else {
                        [HICToast showWithText:NSLocalizableString(@"incorrectPasswordPrompt", nil)];
                    }
                }];
            }else {
                [self signBackToSever:YES andIsBefore:NO andModel:model andSeverType:severType msg:@""];
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
                                    [self signBackToSever:YES andIsBefore:YES andModel:model andSeverType:severType msg:inputText];
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
                            [self signBackToSever:YES andIsBefore:YES andModel:model andSeverType:severType msg:inputText];
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

-(void)listBaseCell:(OTPListBaseCell *)cell signAgainModel:(OfflineTrainingListModel *)model passWord:(BOOL)isPassword{
    // 重新签退
    // 存在可以签退刷新 -- 签退处理
    if (isPassword) {
        [OTPSignPassView showWindowPassViewBlock:^(NSString * _Nonnull inputText) {
            if ([inputText isEqualToString:model.attendanceRequires.password]) {
                // 口令一致的情况下 -- 输入原因
                [self signBackToSever:YES andIsBefore:YES andModel:model andSeverType:4 msg:@""];
            }else {
                [HICToast showWithText:NSLocalizableString(@"incorrectPasswordPrompt", nil)];
            }

        }];
    }else {
        [self signBackToSever:YES andIsBefore:YES andModel:model andSeverType:4 msg:@""];
    }
}

// 跳转地图
-(void)listBaseCell:(OTPListBaseCell *)cell clickMapViewWithModel:(OfflineTrainingListModel *)model {
    // 跳转到地图页面
    OTPSignMapViewVC *vc = [OTPSignMapViewVC new];
    vc.center = CLLocationCoordinate2DMake(model.attendanceRequires.latitude.doubleValue, model.attendanceRequires.longitude.doubleValue);
    vc.radius = model.attendanceRequires.radius;
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:^{

    }];
}
// 跳转不同的业务页面
-(void)listBaseCell:(OTPListBaseCell *)cell clickOtherButWithModel:(OfflineTrainingListModel *)model {
    if (model.taskType == 3){
        // 考试 -- 跳转页面
        HICExamCenterDetailVC *vc = HICExamCenterDetailVC.new;
        vc.examId = [NSString stringWithFormat:@"%ld",(long)model.taskId];
        vc.trainId = [NSString stringWithFormat:@"%ld",(long)model.trainId];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (model.taskType == 4){
        // 作业 -- 跳转到作业页面
        HICHomeworkListVC *vc = HICHomeworkListVC.new;
        vc.trainId = [NSNumber numberWithInteger:self.trainId];
        vc.workId = [NSNumber numberWithInteger:model.taskId];
        vc.homeworkTitle = model.taskName;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (model.taskType == 6){
        // 问卷 -- 跳转到问卷页面
        HICTrainQuestionVC *vc = HICTrainQuestionVC.new;
        vc.trainId = [NSNumber numberWithInteger:self.trainId];
        vc.taskId = [NSNumber numberWithInteger:model.taskId];
        [self.navigationController pushViewController:vc animated:YES];
    }else if ( model.taskType == 7){
        // 评价 -- 跳转页面
        HICTrainQuestionVC *vc = HICTrainQuestionVC.new;
        vc.trainId = [NSNumber numberWithInteger:self.trainId];
        vc.taskId = [NSNumber numberWithInteger:model.taskId];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (model.taskType == 8){
        // 课程 -- 跳转课程页面
        HICOfflineCourseDetailVC *vc = [HICOfflineCourseDetailVC new];
        vc.trainId = self.trainId;
        vc.taskId = model.taskId;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - 上传数据
// 签到/退接口请求  -- severType签到/退的类型 1：位置 2：口令 3：什么都没得 4：重新签退的没有早退理由
-(void)signBackToSever:(BOOL)isBack andIsBefore:(BOOL)isBefore andModel:(OfflineTrainingListModel *)model andSeverType:(NSInteger)severType msg:(NSString *)msg {
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
    NSDictionary *dic;// 重新刷新的时候不用穿message
    if (severType == 4) {
        dic = @{@"attendanceTaskId":[NSNumber numberWithInteger:model.taskId], @"customerId":USER_CID, @"taskType":[NSNumber numberWithInteger:taskType], @"signInTime":[HICCommonUtils getNowTimeTimestamp], @"signInSecret":pass};
    }else {
        dic = @{@"attendanceTaskId":[NSNumber numberWithInteger:model.taskId], @"customerId":USER_CID, @"taskType":[NSNumber numberWithInteger:taskType], @"signInTime":[HICCommonUtils getNowTimeTimestamp], @"message":message, @"signInSecret":pass};
    }
    [HICAPI checkInAndSignOut:dic success:^(NSDictionary * _Nonnull responseObject) {
        // 成功后刷新页面
        if (self.refreshBlock) {
            self.refreshBlock(self.detailType);
        }
    } failure:^(NSError * _Nonnull error) {
        // 失败后刷新页面
        if (self.refreshBlock) {
            self.refreshBlock(self.detailType);
        }
    }];
}

#pragma mark - 懒加载
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, HIC_ScreenWidth, HIC_ScreenHeight-44-44-HIC_StatusBar_Height - HIC_BottomHeight) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:OTPListDetailAllCell.class forCellReuseIdentifier:@"AllCell"];
        [_tableView registerClass:OTPListDetailClassCell.class forCellReuseIdentifier:@"ClassCell"];
        [_tableView registerClass:OTPListDetailSignCell.class forCellReuseIdentifier:@"SignCell"];
        [_tableView registerClass:OTPListDetailExamCell.class forCellReuseIdentifier:@"ExamCell"];
        [_tableView registerClass:OTPListDetailHomeworkCell.class forCellReuseIdentifier:@"HomeworkCell"];
        [_tableView registerClass:OTPListDetailQuestionnaireCell.class forCellReuseIdentifier:@"QuestionnaireCell"];
        [_tableView registerClass:OTPListDetailEvaluateCell.class forCellReuseIdentifier:@"EvaluateCell"];
        [_tableView registerClass:OTPListBaseCell.class forCellReuseIdentifier:@"BaseCell"];
        [_tableView registerClass:OTPListDetailLineGradeCell.class forCellReuseIdentifier:@"LineGradeCell"];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0;
        }
    }
    return _tableView;
}

-(HomeTaskCenterDefaultView *)defalutView {
    if (!_defalutView) {
        _defalutView = [[HomeTaskCenterDefaultView alloc] initWithFrame:CGRectMake(0, 0, HIC_ScreenWidth, HIC_ScreenHeight-44-44-HIC_StatusBar_Height)];
        [self.view addSubview:_defalutView];
        _defalutView.hidden = YES;
    }
    return _defalutView;
}

@end
