//
//  HICLessonIntroductView.m
//  HiClass
//
//  Created by WorkOffice on 2020/2/4.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICLessonIntroductView.h"
#import "HICLessonIntroductCell.h"
#import "HICLessonContentCell.h"
#import "HICContributorListVC.h"
#import "HICStudyVideoPlayCommentCell.h"
#import "HICCommentView.h"
#import "HICContributorModel.h"
#import "HICAuthorModel.h"
#import "HICAuthorCustomerModel.h"
#import "HICStudyVideoPlayRelatedCell.h"
#import "HICStudyVideoPlayRelatedListVC.h"
#import "HICStudyVideoPlayExercisesCell.h"
#import "HICStudyVideoPlayExercisesListVC.h"
#import "HICExamCenterDetailVC.h"
#import "HICExerciseModel.h"
#import "HICCourseModel.h"
#import "HICLessonsVC.h"
#import "HICKnowledgeDetailVC.h"
static NSString * Lesson_Introduct_Cell = @"Lesson_Introduct_Cell";
static NSString * Lesson_Related_Cell = @"Lesson_Related_Cell";
static NSString * Lesson_Exercise_Cell = @"Lesson_Exercise_Cell";
static NSString * Lesson_Content_Cell = @"Lesson_Content_Cell";
static NSString * Lesson_comment_Cell = @"Lesson_comment_Cell";
@interface HICLessonIntroductView ()<UITableViewDelegate,UITableViewDataSource,HICLessonIntroductDelegate,HICCommentViewDelegate,HICLessonContentDelegate,HICStudyVideoPlayBaseCellDelegate>
{HICLessonIntroductCell *inductCell;
    NSIndexPath *commentIndexPath;
}
@property (nonatomic ,strong)HICBaseInfoModel *bModel;
@property (nonatomic ,strong)NSString *title;
//@property (nonatomic ,strong)NSArray *recommendArr;
//@property (nonatomic ,strong)NSArray *exciseArr;
@end
@implementation HICLessonIntroductView
- (instancetype)initWithVC:(UIViewController *)vc{
    if (self = [super init]) {
        _vc = vc;
        [self createUI];
    }
    return self;
}
- (void)createUI {
    self.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    self.frame = CGRectMake(0, 0 , HIC_ScreenWidth, HIC_ScreenHeight - lessonTopHeight  - HIC_BottomHeight - 52 - 48);
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.separatorColor = [UIColor whiteColor];
    [self configTableView];
}
- (void)configTableView {
    self.delegate = self;
    self.dataSource = self;
    [self addObserver:self forKeyPath:@"commentOffSet" options:NSKeyValueObservingOptionNew context:nil];
    if (@available(iOS 15.0, *)) {
        self.sectionHeaderTopPadding = 0;
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([scrollView isEqual: self]) {
        
    }
}
- (void)setBaseModel:(HICBaseInfoModel *)baseModel{
    _baseModel = baseModel;
    [self reloadData];
}
- (CGFloat)getContentHeight:(NSString *)str {
    UILabel *label = [[UILabel alloc] init];
    label.text = str;
    label.font = FONT_REGULAR_14;
    label.numberOfLines = 0;
    CGFloat labelHeight = [HICCommonUtils sizeOfString:str stringWidthBounding:HIC_ScreenWidth - 32 font:14 stringOnBtn:NO fontIsRegular:YES].height;
    label.frame = CGRectMake(0, 0, HIC_ScreenWidth - 32, labelHeight);
    [label sizeToFit];
    return label.frame.size.height;
}
- (CGFloat)getContentHeightB:(NSString *)str {
    UILabel *label = [[UILabel alloc] init];
    label.text = str;
    label.font = FONT_MEDIUM_18;
    label.numberOfLines = 0;
    CGFloat labelHeight = [HICCommonUtils sizeOfString:str stringWidthBounding:HIC_ScreenWidth - 32 font:18 stringOnBtn:NO fontIsRegular:NO].height;
    label.frame = CGRectMake(0, 0, HIC_ScreenWidth - 32, labelHeight);
    [label sizeToFit];
    return label.frame.size.height;
}
#pragma mark - 自定义Cell的协议方法
//// 1. 点击更多的协议方法
-(void)studyVideoPlayCell:(HICStudyVideoPlayBaseCell *)cell clickMoreBut:(UIButton *)btn cellType:(StudyVideoPlayCellType)cellType {
    if (cellType == StudyVideoPlayCellExercises) {
        DDLogDebug(@"VC ==== 点击练习题更多");
        HICStudyVideoPlayExercisesListVC *vc = HICStudyVideoPlayExercisesListVC.new;
        vc.objectId = self.baseModel.courseID;
        vc.trainId = _trainId;
        vc.objectType = @6;
        [_vc.navigationController pushViewController:vc animated:YES];
    }else if (cellType == StudyVideoPlayCellRelated) {
        DDLogDebug(@"VC ==== 点击相关更多");
        HICStudyVideoPlayRelatedListVC *vc = HICStudyVideoPlayRelatedListVC.new;
        vc.objectId = self.baseModel.courseID;
        vc.objectType = @6;
        [_vc.navigationController pushViewController:vc animated:YES];
    }
}
// 2. 点击cell内容Item的协议方法
-(void)studyVideoPlayCell:(HICStudyVideoPlayBaseCell *)cell clickItemBut:(UIButton *)btn cellType:(StudyVideoPlayCellType)cellType itemModel:(id)data {
    NSNumber *index = (NSNumber *)data;
    if (cellType == StudyVideoPlayCellExercises) {
        HICExamCenterDetailVC *vc = [HICExamCenterDetailVC new];
        HICExerciseModel *model = [HICExerciseModel mj_objectWithKeyValues:self.arrExercise[index.integerValue]];
        if (![NSString isValidStr:[NSString stringWithFormat:@"%@",model.exerciseId]]) {
            return;
        }
        ///日志上报
        HICStudyLogReportModel *reportModel = [[HICStudyLogReportModel alloc]initWithType:HICExamClick];
        reportModel.mediaid = _baseModel.courseID;
        NSMutableDictionary *report = [NSMutableDictionary dictionaryWithDictionary:[reportModel getParamDict]];
        [report setValuesForKeysWithDictionary:[LogManager getSerLogEventDictWithType:HICExamClick]];
        [LogManager reportSerLogWithDict:report];
        vc.examId = [NSString stringWithFormat:@"%@",model.exerciseId];
         vc.courseId = [NSString stringWithFormat:@"%@",_baseModel.courseID];
        vc.trainId = [NSString stringWithFormat:@"%@",_trainId];
        [_vc.navigationController pushViewController:vc animated:YES];
    }else if (cellType == StudyVideoPlayCellRelated) {
        HICCourseModel *model = [HICCourseModel mj_objectWithKeyValues:self.arrRelated[index.integerValue][@"courseKLDInfo"]];
        if (model.courseKLDType == 6) {
            HICLessonsVC *vc = [HICLessonsVC new];
            vc.objectID = model.courseKLDId;
            ///日志上报
            HICStudyLogReportModel *reportModel = [[HICStudyLogReportModel alloc]initWithType:HICRecommendClick];
            reportModel.mediaid = model.courseKLDId;
            reportModel.mediatype = [NSNumber numberWithInteger:HICReportCourseType];
            reportModel.knowtype = [NSNumber numberWithInteger:model.resourceType];
            NSMutableDictionary *report = [NSMutableDictionary dictionaryWithDictionary:[reportModel getParamDict]];
            [report setValuesForKeysWithDictionary:[LogManager getSerLogEventDictWithType:HICRecommendClick]];
            [LogManager reportSerLogWithDict:report];
            [_vc.navigationController pushViewController:vc animated:YES];
        }else{
            HICKnowledgeDetailVC *vc = [HICKnowledgeDetailVC new];
            vc.objectId = model.courseKLDId;
            vc.kType = model.resourceType;
            vc.partnerCode = model.partnerCode;
            ///日志上报
            HICStudyLogReportModel *reportModel = [[HICStudyLogReportModel alloc]initWithType:HICRecommendClick];
            reportModel.mediaid = model.courseKLDId;
            reportModel.mediatype = [NSNumber numberWithInteger:HICReportKnowledgeType];
            reportModel.knowtype = [NSNumber numberWithInteger:model.resourceType];
            NSMutableDictionary *report = [NSMutableDictionary dictionaryWithDictionary:[reportModel getParamDict]];
            [report setValuesForKeysWithDictionary:[LogManager getSerLogEventDictWithType:HICRecommendClick]];
            [LogManager reportSerLogWithDict:report];
            [_vc.navigationController pushViewController:vc animated:YES];
        }
    }
}
#pragma mark ------HICLessonIntroductDelegate
- (void)jumpContributorList:(HICContributorModel *)model{
    HICContributorListVC *vc = HICContributorListVC.new;
    vc.contributor = model;
    if (!model.customerId) {
        [HICToast showWithText:NSLocalizableString(@"currentContributorHasNoSource", nil)];
        return;
    }
    vc.type = 1000;
    ///日志上报
    HICStudyLogReportModel *reportModel = [[HICStudyLogReportModel alloc]initWithType:HICCourseDetailClick];
    reportModel.mediaid = _baseModel.courseID;
    reportModel.knowtype = [NSNumber numberWithInteger:_baseModel.resourceType];
    if (_baseModel.type == 6) {
        reportModel.mediatype = [NSNumber numberWithInteger:HICReportCourseType];
    }else{
        reportModel.mediatype = [NSNumber numberWithInteger:HICReportKnowledgeType];
    }
    reportModel.buttonname = NSLocalizableString(@"contributors", nil);
    NSMutableDictionary *report = [NSMutableDictionary dictionaryWithDictionary:[reportModel getParamDict]];
    [report setValuesForKeysWithDictionary:[LogManager getSerLogEventDictWithType:HICCourseDetailClick]];
    [LogManager reportSerLogWithDict:report];
    [_vc.navigationController pushViewController:vc animated:YES];
}
#pragma mark ---hiclessondelegate
- (void)extensionClicked:(NSString *)title{
    self.title = title;
    [self reloadData];
}
- (void)jumpToContributor:(HICAuthorModel *)authorModel{
    HICContributorListVC *vc = HICContributorListVC.new;
    vc.authorModel = authorModel;
    vc.type = 2000;
    HICStudyLogReportModel *reportModel = [[HICStudyLogReportModel alloc]initWithType:HICCourseDetailClick];
    reportModel.mediaid = _baseModel.courseID;
    reportModel.knowtype = [NSNumber numberWithInteger:_baseModel.resourceType];
    if (_baseModel.type == 6) {
        reportModel.mediatype = [NSNumber numberWithInteger:HICReportCourseType];
    }else{
        reportModel.mediatype = [NSNumber numberWithInteger:HICReportKnowledgeType];
    }
    reportModel.buttonname = NSLocalizableString(@"author", nil);
    NSMutableDictionary *report = [NSMutableDictionary dictionaryWithDictionary:[reportModel getParamDict]];
    [report setValuesForKeysWithDictionary:[LogManager getSerLogEventDictWithType:HICCourseDetailClick]];
    [LogManager reportSerLogWithDict:report];
    [_vc.navigationController pushViewController:vc animated:YES];
}
#pragma mark -uitableviewdelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_isInside) {
        return 2;
    }else{
        return 4;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        self.estimatedRowHeight = 200;
        self.rowHeight = UITableViewAutomaticDimension;
        return [self getContentHeightB:self.baseModel.name] > 50 + 50 + 96.5 + 24 ?50 :[self getContentHeightB:self.baseModel.name]  + 50 + 96.5 + 24;
    }else if(indexPath.row == 1){
        if ([HICCommonUtils isValidObject:self.baseModel.author]) {
            tableView.estimatedRowHeight = 230;
            tableView.rowHeight = UITableViewAutomaticDimension;
            if ([NSString isValidStr:self.baseModel.desc]) {
                if([self getContentHeight:self.baseModel.desc] > 60){
                    if ([self.title isEqualToString:NSLocalizableString(@"develop", nil)]) {
                        return [self getContentHeight:self.baseModel.desc] + 104 + 42 + 38;
                    }else{
                        return 60 + 104 + 42 + 38;
                    }
                } else{
                    return [self getContentHeight:self.baseModel.desc] + 104 + 42 + 24;
                }
            }else{
                return 104 + 42 + 16 + 20;
            }
        }else{
            return 104 + 48 + 6;
        }
    }else if(indexPath.row == 2){
        if ([HICCommonUtils isValidObject:_arrExercise] && _arrExercise.count > 0) {
            return _arrExercise.count *50 + 56 + 16;
        }else{
            return 0;
        }
        
    }else{
        if ([HICCommonUtils isValidObject:_arrRelated] && _arrRelated.count > 0) {
            return _arrRelated.count *50 + 56 + 16;
        }else{
            return 0;
        }
        
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        [self registerClass:[HICLessonIntroductCell class] forCellReuseIdentifier:Lesson_Introduct_Cell];
        inductCell = (HICLessonIntroductCell *)[tableView dequeueReusableCellWithIdentifier:Lesson_Introduct_Cell];
        inductCell.lessonDelegate = self;
        inductCell.selectionStyle = UITableViewCellSelectionStyleNone;
        inductCell.baseModel = self.baseModel;
        return inductCell;
    }else if(indexPath.row == 1){
        [self registerClass:[HICLessonContentCell class] forCellReuseIdentifier:Lesson_Content_Cell];
        HICLessonContentCell *cell = (HICLessonContentCell *)[tableView dequeueReusableCellWithIdentifier:Lesson_Content_Cell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.baseModel = self.baseModel;
        cell.extensionDelegate = self;
        return cell;
    }else if (indexPath.row == 2) {
        [self registerClass:[HICStudyVideoPlayExercisesCell class] forCellReuseIdentifier:Lesson_Exercise_Cell];
        HICStudyVideoPlayExercisesCell *exCell = [tableView dequeueReusableCellWithIdentifier:Lesson_Exercise_Cell forIndexPath:indexPath];
        exCell.delegate = self;
        exCell.dataArr = _arrExercise;
        exCell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([HICCommonUtils isValidObject:_arrExercise] && _arrExercise.count > 0) {
            exCell.hidden = NO;
        }else {
            exCell.hidden = YES;
        }
        return exCell;
    }else {
        [self registerClass:[HICStudyVideoPlayRelatedCell class] forCellReuseIdentifier:Lesson_Related_Cell];
        HICStudyVideoPlayRelatedCell *relateCell = [tableView dequeueReusableCellWithIdentifier:Lesson_Related_Cell forIndexPath:indexPath];
        relateCell.delegate = self;
        relateCell.dataArr = _arrRelated;
        relateCell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([HICCommonUtils isValidObject:_arrRelated] && _arrRelated.count > 0) {
            relateCell.hidden = NO;
        }else {
            relateCell.hidden = YES;
        }
        return relateCell;
    }
}

@end
