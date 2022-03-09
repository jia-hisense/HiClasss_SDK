//
//  HICTrainFinishedView.m
//  HiClass
//
//  Created by WorkOffice on 2020/3/3.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICTrainFinishedView.h"
#import "HICOnlineTrainCell.h"
#import "HICTrainDetailVC.h"
#import "HICOnlineTrainListModel.h"
#import "HICOfflineTrainInfoVC.h"
#import "OfflineTrainPlanListVC.h"
#import "HICMixTrainArrangeMapVC.h"
#import "HICMixTrainArrangeVC.h"
#import "HICNotEnrollTrainArrangeVC.h"
static NSString *trainFinishId = @"trainFinishId";
@interface HICTrainFinishedView()<UITableViewDelegate,UITableViewDataSource>

@end
@implementation HICTrainFinishedView
- (instancetype)init {
    if (self = [super init]) {
        [self createUI];
    }
    return self;
}
- (void)createUI{
    self.frame = CGRectMake(HIC_ScreenWidth *2, 0, HIC_ScreenWidth, HIC_ScreenHeight - HIC_NavBarAndStatusBarHeight - 44-6);
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.separatorColor = [UIColor clearColor];
    self.backgroundColor = BACKGROUNG_COLOR;
    [self configTableView];
}
- (void)configTableView{
    self.delegate = self;
    self.dataSource = self;
    self.estimatedRowHeight = 160;
    self.rowHeight = UITableViewAutomaticDimension;
    [self registerClass:[HICOnlineTrainCell class] forCellReuseIdentifier:trainFinishId];
    if (@available(iOS 15.0, *)) {
        self.sectionHeaderTopPadding = 0;
    }
}
-(void)setDataArr:(NSMutableArray *)dataArr{
    _dataArr = dataArr;
    [self reloadData];
}
- (CGFloat)getContentHeight:(NSString *)str {
    UILabel *label = [[UILabel alloc] init];
    label.text = str;
    label.font = FONT_REGULAR_16;
    label.numberOfLines = 2;
    CGFloat labelHeight = [HICCommonUtils sizeOfString:str stringWidthBounding:HIC_ScreenWidth - 60 font:16 stringOnBtn:NO fontIsRegular:YES].height;
    label.frame = CGRectMake(0, 0, HIC_ScreenWidth - 60, labelHeight);
    [label sizeToFit];
    return label.frame.size.height;
}
#pragma mark tableviewDelegate&&dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HICOnlineTrainCell *cell = (HICOnlineTrainCell *)[tableView dequeueReusableCellWithIdentifier:trainFinishId];
       if (cell == nil) {
           cell = [[HICOnlineTrainCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:trainFinishId];
       }
       cell.model = [HICOnlineTrainListModel mj_objectWithKeyValues:_dataArr[indexPath.row]];
    [cell setBorderStyleWithTableView:tableView indexPath:indexPath];
       return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = _dataArr[indexPath.row];
    NSString *nameStr;
   if ([dic[@"trainCat"] integerValue] == 11) {
        nameStr = [dic[@"trainName"] stringByAppendingFormat:NSLocalizableString(@"internalTraining", nil)];
    }else if ([dic[@"trainCat"] integerValue] == 12 || [dic[@"trainCat"] integerValue] == 13){
        nameStr = [dic[@"trainName"] stringByAppendingFormat:NSLocalizableString(@"outsideDeliveredTraining", nil)];
    }else{
        nameStr = dic[@"trainName"];
    }
    return [self getContentHeight:nameStr] + 16 + 36 + 68 + 12;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HICTrainDetailVC *detailVC = HICTrainDetailVC.new;
    HICOnlineTrainListModel *model = [HICOnlineTrainListModel mj_objectWithKeyValues:self.dataArr[indexPath.row]];
    detailVC.trainId = self.dataArr[indexPath.row][@"trainId"];
    ///日志上报
    HICStudyLogReportModel *reportModel = [[HICStudyLogReportModel alloc]initWithType:HICTaskTabClick];
    reportModel.tab = NSLocalizableString(@"hasBeenCompleted", nil);
    reportModel.mediaid = detailVC.trainId;
    reportModel.tasktype = [NSNumber numberWithInteger:HICReportTrainType];
    reportModel.trainmode = self.dataArr[indexPath.row][@"trainType"];
    NSMutableDictionary *report = [NSMutableDictionary dictionaryWithDictionary:[reportModel getParamDict]];
    [report setValuesForKeysWithDictionary:[LogManager getSerLogEventDictWithType:HICTaskTabClick]];
    [LogManager reportSerLogWithDict:report];
    if (model.trainType == 1) {//线上培训
        [[HICCommonUtils viewController:self].navigationController pushViewController:detailVC animated:YES];
    } else if (model.trainType == 2) {//线下培训
        OfflineTrainPlanListVC *vc = [[OfflineTrainPlanListVC alloc] init];
        vc.trainId = model.trainId? model.trainId.integerValue:0;
        vc.isShowRightMore = YES;
        vc.registerId = model.registerId;
        [[HICCommonUtils viewController:self].navigationController pushViewController:vc animated:YES];
    }else{//混合培训
        if (([model.registerId isEqualToNumber:@0] && model.registChannel == 1)|| model.registChannel == 0) {//未报名
            HICNotEnrollTrainArrangeVC *vc = [HICNotEnrollTrainArrangeVC new];
            vc.trainId = model.trainId;
            [[HICCommonUtils viewController:self].navigationController pushViewController:vc animated:YES];
        }else{
            if ([model.scene isEqualToString:@"classic"]) {
                HICMixTrainArrangeVC *vc = [HICMixTrainArrangeVC new];
                vc.trainId = model.trainId;
                vc.registerId = model.registerId;
                vc.isDesc = NO;
                [[HICCommonUtils viewController:self].navigationController pushViewController:vc animated:YES];
            }else{
                HICMixTrainArrangeMapVC *vc = [HICMixTrainArrangeMapVC new];
                vc.trainId = model.trainId;
                vc.registerId = model.registerId;
                vc.isDesc = NO;
                vc.taskName = model.trainName;
                [[HICCommonUtils viewController:self].navigationController pushViewController:vc animated:YES];
            }
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 6;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, HIC_ScreenWidth, 6)];
    line.backgroundColor = BACKGROUNG_COLOR;
    return line;
}
-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    view.backgroundColor = [UIColor clearColor];
}

@end
