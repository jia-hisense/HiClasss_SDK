//
//  HICMyStudyRecordView.m
//  HiClass
//
//  Created by WorkOffice on 2020/2/21.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICMyStudyRecordView.h"
#import "HICMyRecordCell.h"
#import "HICMyRecordModel.h"
#import "HICKnowledgeDetailVC.h"
#import "HICCourseModel.h"
#import "HICLessonsVC.h"
static NSString *recordCell = @"recordCell";
@interface HICMyStudyRecordView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *arrData;
@property (nonatomic, strong) UIImageView *blackView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UILabel *headerLabel;
@property (nonatomic, strong) NSNumber *time;
@property (nonatomic ,strong)UILabel *blackLabel;
@end
@implementation HICMyStudyRecordView
- (NSMutableArray *)arrData{
    if (!_arrData) {
        _arrData = [NSMutableArray new];
    }
    return _arrData;
}

- (instancetype)init {
    if (self = [super init]) {
        [self createUI];
    }
    return self;
}
-(UIImageView *)blackView{
    if (!_blackView) {
        _blackView = [[UIImageView alloc]initWithFrame:CGRectMake(HIC_ScreenWidth / 2 - 60, 101.5, 120, 120)];
        _blackView.image = [UIImage imageNamed:@"暂无学习记录"];
    }
    return _blackView;
}
- (UILabel *)blackLabel{
    if (!_blackLabel) {
        _blackLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 221.5 + 8, HIC_ScreenWidth, 20)];
        _blackLabel.text = NSLocalizableString(@"noStudyRecord", nil);
        _blackLabel.textColor = TEXT_COLOR_LIGHTS;
        _blackLabel.font = FONT_REGULAR_15;
        _blackLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _blackLabel;
}
- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, HIC_ScreenWidth, 40)];
        _headerView.backgroundColor = UIColor.whiteColor;
    }
    return _headerView;
}
- (UILabel *)headerLabel{
    if (!_headerLabel) {
        _headerLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 10, HIC_ScreenWidth, 21)];
        _headerLabel.font = FONT_MEDIUM_15;
        _headerLabel.textColor = TEXT_COLOR_LIGHTM;
        
    }
    return _headerLabel;
}
- (void)createUI {
    self.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    self.frame = CGRectMake(0, 0 , HIC_ScreenWidth, HIC_ScreenHeight - HIC_NavBarAndStatusBarHeight);
    [self configTableView];
}
- (void)configTableView {
    self.delegate = self;
    self.dataSource = self;
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self registerClass:[HICMyRecordCell class] forCellReuseIdentifier:recordCell];
    if (@available(iOS 15.0, *)) {
        self.sectionHeaderTopPadding = 0;
    }
}
- (void)setDataArr:(NSMutableArray *)dataArr{
    if(dataArr.count == 0){
        [self addSubview:self.blackView];
        [self addSubview:self.blackLabel];
        return;
    }
    //    _dataArr = dataArr;

    _dataArr = [HICMyRecordModel mj_objectArrayWithKeyValuesArray:dataArr];

    self.time = @0;
    //    if (_dataArr.count == 1) {
    //        HICMyRecordModel *model = [HICMyRecordModel mj_objectWithKeyValues:_dataArr[0]];
    //        NSArray *arr = [NSArray arrayWithObject:model];
    ////        NSArray *arr = [NSArray arrayWithObject:_dataArr[0]];
    //        [self.arrData addObject:arr];
    //    }else{
    //        HICMyRecordModel *model1 = [HICMyRecordModel mj_objectWithKeyValues:_dataArr[0]];
    //        if (model1.updateTime && [model1.updateTime isKindOfClass:[NSNumber class]]) {
    //            self.time = model1.updateTime;
    //        }else{
    //            self.time = @0;
    //        }
    //        NSMutableArray *arr = [[NSMutableArray alloc]init];
    //        [arr addObject:model1];
    //        for (int i = 1; i < _dataArr.count; i ++) {
    //         HICMyRecordModel *model = [HICMyRecordModel mj_objectWithKeyValues:_dataArr[i]];
    //            if ([HICCommonUtils isSameDayWithTime:self.time isSecs:YES beComparedTime:model.updateTime]) {
    //                [arr addObject:model];
    //            }else{
    //                NSArray *arrtemp = [[NSArray alloc]initWithArray:arr];
    //                DDLogDebug(@"arrr:%p",arr);
    //                DDLogDebug(@"arrtemp:%p",arrtemp);
    //                [self.arrData addObject:arrtemp];
    //                self.time = model.updateTime;
    //                [arr removeAllObjects];
    //                [arr addObject:model];
    //            }
    //        }
    //        [self.arrData addObject:[[NSMutableArray alloc]initWithArray:arr]];
    //    }

    HICMyRecordModel *model1 = _dataArr[0];
    if (model1.updateTime && [model1.updateTime isKindOfClass:[NSNumber class]]) {
        self.time = model1.updateTime;
    }else{
        self.time = @0;
    }
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    [arr addObject:model1];
    if (_dataArr.count == 1) {
        [self.arrData addObject:arr];
    }else{
        for (int i = 1; i < _dataArr.count; i ++) {
            HICMyRecordModel *model = _dataArr[i];
            if ([HICCommonUtils isSameDayWithTime:self.time isSecs:YES beComparedTime:model.updateTime]) {
                [arr addObject:model];
            }else{
                NSArray *arrtemp = [[NSArray alloc]initWithArray:arr];
                [self.arrData addObject:arrtemp];
                self.time = model.updateTime;
                [arr removeAllObjects];
                [arr addObject:model];
            }
        }
        [self.arrData addObject:[[NSMutableArray alloc]initWithArray:arr]];
    }
    [self reloadData];
    
}
#pragma mark -uitableview
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 104;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray  *arr = [[NSArray alloc]initWithArray:self.arrData[section]];
    return arr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HICMyRecordCell *cell = (HICMyRecordCell *)[tableView dequeueReusableCellWithIdentifier:recordCell];
    if (cell == nil) {
        cell = [[HICMyRecordCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:recordCell];
    }
    NSInteger section = indexPath.section;
    NSArray  *arr = [[NSArray alloc]initWithArray:self.arrData[section]];
    cell.model = [HICMyRecordModel mj_objectWithKeyValues:arr[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
//    [self.dataArr removeObjectAtIndex:indexPath.row];
//    [self deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
//}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.arrData.count ? self.arrData.count :0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(16, 15, HIC_ScreenWidth - 32, 21)];
    label.font = FONT_MEDIUM_15;
    label.textColor = TEXT_COLOR_LIGHTM;
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, HIC_ScreenWidth, 40)];
    [headerView addSubview:label];
    headerView.backgroundColor = UIColor.whiteColor;
    //    [self.headerView addSubview:self.headerLabel];
    if (self.arrData.count == 0) {
        return headerView;
    }
    NSArray *arr = [[NSArray alloc]initWithArray:self.arrData[section]];
    if (arr.count == 0) {
        label.text = @"";
        return headerView;
    }
    HICMyRecordModel *model = arr[0];
    if (!(model && [model isKindOfClass:[HICMyRecordModel class]])) {
        //    if (!(model)){
        label.text = @"";
        return headerView;
    }
    if (model.updateTime && [model.updateTime isKindOfClass:[NSNumber class]]) {
        if ([HICCommonUtils validateWithDate:model.updateTime]) {
            label.text = NSLocalizableString(@"today", nil);
        }else{
            label.text = [HICCommonUtils timeStampToReadableDate:model.updateTime isSecs:YES format:@"yyyy-MM-dd"];
        }
    }else{
        label.text = @"";
    }
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return self.arrData.count ? 40 : 0;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    NSArray  *arr = [[NSArray alloc]initWithArray:self.arrData[section]];
    HICMyRecordModel *model = [HICMyRecordModel mj_objectWithKeyValues:arr[indexPath.row]];
    HICCourseModel *course = [HICCourseModel mj_objectWithKeyValues:model.courseKLDInfo];

    if (course.courseKLDType >= 0 && [NSString isValidStr:course.courseKLDId.stringValue]) {
        if (course.courseKLDType == 7) {
            HICKnowledgeDetailVC *vc = [HICKnowledgeDetailVC new];
            vc.kType = course.resourceType;
            vc.objectId = course.courseKLDId;
            vc.partnerCode = course.partnerCode;
            ///日志上报
            HICStudyLogReportModel *reportModel = [[HICStudyLogReportModel alloc]initWithType:HICMyRecordClickToKnowledge];
            reportModel.mediaid = course.courseKLDId;
            reportModel.knowtype = [NSNumber numberWithInteger:course.resourceType];
            reportModel.mediatype = [NSNumber numberWithInteger:HICReportKnowledgeType];
            NSMutableDictionary *report = [NSMutableDictionary dictionaryWithDictionary:[reportModel getParamDict]];
            [report setValuesForKeysWithDictionary:[LogManager getSerLogEventDictWithType:HICMyRecordClickToKnowledge]];
            [LogManager reportSerLogWithDict:report];
            [[HICCommonUtils viewController:self].navigationController pushViewController:vc animated:YES];
        }else if (course.courseKLDType == 6) {
            HICLessonsVC *lessVC = [HICLessonsVC new];
            lessVC.objectID = course.courseKLDId ?course.courseKLDId:@0 ;
            ///日志上报
            HICStudyLogReportModel *reportModel = [[HICStudyLogReportModel alloc]initWithType:HICMyRecordClickToKnowledge];
            reportModel.mediaid = course.courseKLDId ?course.courseKLDId:@0;
            reportModel.knowtype = [NSNumber numberWithInteger:course.resourceType];
            reportModel.mediatype = [NSNumber numberWithInteger:HICReportCourseType];
            NSMutableDictionary *report = [NSMutableDictionary dictionaryWithDictionary:[reportModel getParamDict]];
            [report setValuesForKeysWithDictionary:[LogManager getSerLogEventDictWithType:HICMyRecordClickToKnowledge]];
            [LogManager reportSerLogWithDict:report];
            [[HICCommonUtils viewController:self].navigationController pushViewController:lessVC animated:YES];
        }
    }
}
@end
