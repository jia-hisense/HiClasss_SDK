//
//  HICIndexView.m
//  HiClass
//
//  Created by WorkOffice on 2020/2/4.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICIndexView.h"
#import "HICIndexViewCell.h"
#import "HICKnowledgeDetailVC.h"
#import "HICExamCenterDetailVC.h"
static NSString *indexCell = @"indexCell";

@interface HICIndexView ()<UITableViewDelegate,UITableViewDataSource,HICIndexCellDelegate>
@property (nonatomic ,assign)CGFloat cellHeight;
@property (nonatomic ,strong)NSIndexPath *indexPath;
@property (nonatomic ,strong)NSMutableArray *heightArr;
@property (nonatomic, strong)NSMutableArray *showArr;
@property (nonatomic ,assign)BOOL isFirst;
@property (nonatomic ,assign)NSInteger firstHeight;
@end
@implementation HICIndexView
- (instancetype)initWithVC:(UIViewController *)vc{
    if (self = [super init]) {
        _vc = vc;
        self.isFirst = YES;
        [self createUI];
    }
    return self;
}
-(NSMutableArray *)showArr{
    if (!_showArr) {
        _showArr =[NSMutableArray new];
    }
    return _showArr;
}
-(void)setDataArr:(NSArray *)dataArr{
    if (dataArr.count == 0) {
        return;
    }
    _dataArr = dataArr;
    NSString *str;
    for (int i = 0; i < _dataArr.count; i++) {
        if (i == 0) {
            str = @"yes";
            [self.showArr addObject:str];
        }else{
            str = @"no";
            [self.showArr addObject:str];
        }
    }
    HICKldSectionLIstModel *model = [HICKldSectionLIstModel mj_objectWithKeyValues:_dataArr[0]];
    self.firstHeight = 0;
    NSArray *arr = [NSArray arrayWithArray:model.courseList];
    for ( int i = 0; i < arr.count; i ++) {
        if ([HICCommonUtils isValidObject:arr[i][@"courseInfo"]]) {
            self.firstHeight += 88;
        }
        if ([HICCommonUtils isValidObject:arr[i][@"examInfo"]]) {
            self.firstHeight += 88;
        }
    }
    for (int i = 0;i < self.dataArr.count; i++) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        if (self.isFirst) {
            if (i == 0) {
                [dic setValue:[NSNumber numberWithInteger:self.firstHeight + 66 + 16] forKey:[NSString stringWithFormat:@"%d",i]];
            }else{
                [dic setValue:@66 forKey:[NSString stringWithFormat:@"%d",i]];
            }
        }else{
            [dic setValue:@66 forKey:[NSString stringWithFormat:@"%d",i]];
        }
        [self.heightArr addObject:dic];
    }
    [self reloadData];
}
- (void)createUI {
    self.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    self.frame = CGRectMake(HIC_ScreenWidth, 0, HIC_ScreenWidth , HIC_ScreenHeight - lessonTopHeight  - HIC_BottomHeight - 52 - 48);
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.separatorColor = [UIColor clearColor];
    self.heightArr = [[NSMutableArray alloc]init];
    [self configTableView];
}
- (void)configTableView {
    self.delegate = self;
    self.dataSource = self;
    if (@available(iOS 15.0, *)) {
        self.sectionHeaderTopPadding = 0;
    }
}
#pragma mark -indexviewCellDelegate (展开收起)
- (void)clickExtension:(CGFloat)cellHeight andIndex:(nonnull NSIndexPath *)indexPath andShowContent:(BOOL)isShowContent{
    self.isFirst = NO;
    self.cellHeight = cellHeight;
    self.indexPath = indexPath;
    [self.heightArr[indexPath.row] setValue:[NSString stringWithFormat:@"%f",self.cellHeight] forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
    DDLogDebug(@"====cellClick:%@===%ld === %f", self.heightArr.firstObject, (long)indexPath.row, cellHeight);
    for (int i = 0; i < self.heightArr.count; i ++) {
        //        if ([[self.heightArr[i] allKeys][0] isEqualToString:[NSString stringWithFormat:@"%ld",(long)indexPath.row]]) {
        //            [self.heightArr[i] setValue:[NSString stringWithFormat:@"%f",self.cellHeight] forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
        //        }
        if (i == indexPath.row) {
            NSString *str;
            if (isShowContent) {
                str = @"yes";
            }else{
                str = @"no";
            }
            [self.showArr replaceObjectAtIndex:i withObject:str];
        }
    }
    [self reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}
- (void)jumpKnowledge:(HICBaseInfoModel *)baseModel andSectionId:(NSNumber *)sectionId andIndexPath:(NSIndexPath *)indexPath andIndex:(NSInteger)index{
    if (![self isJumpWithIndexPath:indexPath andIndex:index]){
        [HICToast showWithText:NSLocalizableString(@"AccordingOrderStudy", nil)];
        return;
    }
    HICKnowledgeDetailVC *vc = HICKnowledgeDetailVC.new;
    vc.kType = baseModel.resourceType;
    vc.objectId = baseModel.courseID;
    vc.sectionId = sectionId;
    vc.trainId = _trainId;
    vc.courseId = _courseId;
    vc.partnerCode = baseModel.partnerCode;
    HICStudyLogReportModel *reportModel = [[HICStudyLogReportModel alloc]initWithType:HICCourseIndexClickKnowledge];
    reportModel.courseid = _courseId;
    reportModel.mediaid = baseModel.courseID;
    reportModel.knowtype = [NSNumber numberWithInteger:baseModel.resourceType];
    NSMutableDictionary *report = [NSMutableDictionary dictionaryWithDictionary:[reportModel getParamDict]];
    [report setValuesForKeysWithDictionary:[LogManager getSerLogEventDictWithType:HICCourseIndexClickKnowledge]];
    [LogManager reportSerLogWithDict:report];
    if (baseModel.resourceType == HICScromType || baseModel.resourceType == HICHtmlType) {
        vc.urlStr = baseModel.playUrl;
        vc.hideNavi = YES;
        vc.hideTabbar = YES;
    }
    [_vc.navigationController pushViewController:vc animated:YES];
}
- (BOOL)isJumpWithIndexPath:(NSIndexPath *)indexPath andIndex:(NSInteger)index{
    HICKldSectionLIstModel *listModel = [HICKldSectionLIstModel mj_objectWithKeyValues:self.dataArr[indexPath.row]];
    NSArray * arrCurrent = [listModel.learningRate componentsSeparatedByString:@"/"];
    if (_isJumpChapter) {//章节可以跳过
        if (listModel.jumpFlag == 1) {//章节内可以跳过
           return YES;
        }else{
            if (index > [arrCurrent[0] integerValue]) {
                return NO;
            }else{
                return YES;
            }
        }
    }else{
        if (indexPath.row > 0) {//非一个章节
           HICKldSectionLIstModel *listModel = [HICKldSectionLIstModel mj_objectWithKeyValues:self.dataArr[indexPath.row - 1]];
            NSArray * arrBefore = [listModel.learningRate componentsSeparatedByString:@"/"];
            if ([arrBefore[0] integerValue] < [arrBefore[1] integerValue]) {//上一章节未学完
                return NO;
            }else{
                if (listModel.jumpFlag == 1) {//章节内可以跳过
                   return YES;
                }else{
                if (index > [arrCurrent[0] integerValue]) {
                    return NO;
                }else{
                    return YES;
                }
                }
            }
        }else{
            if (listModel.jumpFlag == 1) {//章节内可以跳过
               return YES;
            }else{
            if (index > [arrCurrent[0] integerValue]) {
                return NO;
            }else{
                return YES;
            }
            }
        }
    }
    return NO;
}
- (void)jumpExam:(NSNumber *)examId andStatus:(NSInteger)status andIndexPath:(NSIndexPath *)indexPath andIndex:(NSInteger)index{
    if (![self isJumpWithIndexPath:indexPath andIndex:index]){
        [HICToast showWithText:NSLocalizableString(@"AccordingOrderStudy", nil)];
        return;
    }
    HICExamCenterDetailVC *vc = [HICExamCenterDetailVC new];
    vc.examId = [NSString stringWithFormat:@"%@",examId];
    vc.courseId = [NSString stringWithFormat:@"%@",_courseId];
    vc.trainId = [NSString stringWithFormat:@"%@",_trainId];
    HICStudyLogReportModel *reportModel = [[HICStudyLogReportModel alloc]initWithType:HICCourseIndexClickTask];
    reportModel.mediaid = examId;
     reportModel.courseid = _courseId;
    reportModel.tasktype = [NSNumber numberWithInteger:HICReportExamType];
    if (status == HICExamWait) {
       reportModel.taskstatus = NSLocalizableString(@"waitTest", nil);
    }else if (status == HICExamProgress){
         reportModel.taskstatus = NSLocalizableString(@"ongoing", nil);
    }else if (status == HICExamMark){
         reportModel.taskstatus = NSLocalizableString(@"reviewing", nil);
    }else if (status == HICExamAbsent){
         reportModel.taskstatus = NSLocalizableString(@"lackOfTest", nil);
    }else{
        reportModel.taskstatus = NSLocalizableString(@"hasBeenCompleted", nil);
    }
    
    NSMutableDictionary *report = [NSMutableDictionary dictionaryWithDictionary:[reportModel getParamDict]];
    [report setValuesForKeysWithDictionary:[LogManager getSerLogEventDictWithType:HICCourseIndexClickTask]];
    [LogManager reportSerLogWithDict:report];
    [_vc.navigationController pushViewController:vc animated:YES];
};
#pragma mark -uitableviewdelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HICIndexViewCell *cell =(HICIndexViewCell *)[tableView dequeueReusableCellWithIdentifier:indexCell];
    if (!cell) {
        cell = [[HICIndexViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indexCell];
        cell.extensionDelegate = self;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //    cell.kldModel = [HICKldSectionLIstModel mj_objectWithKeyValues:self.dataArr[indexPath.row]];
    if ([self.showArr[indexPath.row] isEqualToString:@"yes"]) {
        [cell setIsfirst:NO andCellIndex:indexPath andModel:[HICKldSectionLIstModel mj_objectWithKeyValues:self.dataArr[indexPath.row]] andShowContent:YES];
    }else{
        [cell setIsfirst:NO andCellIndex:indexPath andModel:[HICKldSectionLIstModel mj_objectWithKeyValues:self.dataArr[indexPath.row]] andShowContent:NO];
    }
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0.0;
    if (self.heightArr.count > 0) {
        //        for (int i = 0; i < self.heightArr.count; i ++) {
        if ([[self.heightArr[indexPath.row] allKeys][0] isEqualToString:[NSString stringWithFormat:@"%ld",(long)indexPath.row]]){
            height = [self.heightArr[indexPath.row][[NSString stringWithFormat:@"%ld",(long)indexPath.row]] floatValue];
            DDLogDebug(@"dhakshdpsajdl;%fdddd%ld",height,(long)indexPath.row);
        }
        //        }
    }
    return height;
}

@end
