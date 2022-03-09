//
//  HICLectureKnowledgeView.m
//  HiClass
//
//  Created by WorkOffice on 2020/3/12.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICLectureKnowledgeView.h"
#import "HICContributeKnowledgeCell.h"
#import "HICKnowledgeDetailVC.h"
#import "HICLessonsVC.h"
static NSString *lecKnowledge = @"lecKnowledge";
@interface HICLectureKnowledgeView ()<UITableViewDelegate,UITableViewDataSource>
@end
@implementation HICLectureKnowledgeView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}
- (void)setDataArray:(NSMutableArray *)dataArray{
    _dataArr = dataArray;
}
- (void)createUI {
    self.backgroundColor = [UIColor whiteColor];
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.separatorColor = [UIColor clearColor];
    [self configTableView];
}
//配置tableview
- (void)configTableView {
    self.delegate = self;
    self.dataSource = self;
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.separatorColor = [UIColor clearColor];
    //    [self registerClass:[HICContributeKnowledgeCell class] forCellReuseIdentifier:lecKnowledge];
    if (@available(iOS 15.0, *)) {
        self.sectionHeaderTopPadding = 0;
    }
}
#pragma mark -uitableviewdelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
    //    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HICContributeKnowledgeCell *cell = (HICContributeKnowledgeCell *)[tableView dequeueReusableCellWithIdentifier:lecKnowledge];
    if (!cell) {
        cell = [[HICContributeKnowledgeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lecKnowledge];
    }
    cell.courseModel = [HICCourseModel mj_objectWithKeyValues:self.dataArr[indexPath.row][@"courseKLD"]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HICCourseModel *model = [HICCourseModel mj_objectWithKeyValues:self.dataArr[indexPath.row][@"courseKLD"]];
    if (model.courseKLDType >= 0 && [NSString isValidStr:model.courseKLDId.stringValue]) {
        if (model.courseKLDType == 7) {
            HICKnowledgeDetailVC *vc = [HICKnowledgeDetailVC new];
            vc.kType = model.resourceType;
            vc.objectId = model.courseKLDId;
            vc.partnerCode = model.partnerCode;
            ///日志上报
            HICStudyLogReportModel *reportModel = [[HICStudyLogReportModel alloc]initWithType:HICLectureClick];
            reportModel.mediaid = model.courseKLDId;
            reportModel.knowtype = [NSNumber numberWithInteger:model.resourceType];
            reportModel.mediatype = [NSNumber numberWithInteger:HICReportKnowledgeType];
            reportModel.teacherid = _lectureId;
            NSMutableDictionary *report = [NSMutableDictionary dictionaryWithDictionary:[reportModel getParamDict]];
            [report setValuesForKeysWithDictionary:[LogManager getSerLogEventDictWithType:HICLectureClick]];
            [LogManager reportSerLogWithDict:report];
            [[HICCommonUtils viewController:self].navigationController pushViewController:vc animated:YES];
        }else if (model.courseKLDType == 6) {
            HICLessonsVC *lessVC = [HICLessonsVC new];
            lessVC.objectID = model.courseKLDId ?model.courseKLDId:@0 ;
            HICStudyLogReportModel *reportModel = [[HICStudyLogReportModel alloc]initWithType:HICLectureClick];
            ///日志上报
            reportModel.mediaid = model.courseKLDId ?model.courseKLDId:@-1;
            reportModel.knowtype = @-1;
            reportModel.mediatype = [NSNumber numberWithInteger:HICReportCourseType];
            reportModel.teacherid = _lectureId;
            NSMutableDictionary *report = [NSMutableDictionary dictionaryWithDictionary:[reportModel getParamDict]];
            [report setValuesForKeysWithDictionary:[LogManager getSerLogEventDictWithType:HICLectureClick]];
            [LogManager reportSerLogWithDict:report];
            [[HICCommonUtils viewController:self].navigationController pushViewController:lessVC animated:YES];
        }
    }
}
@end
