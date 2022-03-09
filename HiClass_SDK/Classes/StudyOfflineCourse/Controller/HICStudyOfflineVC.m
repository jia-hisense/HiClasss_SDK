//
//  HICStudyOfflineVC.m
//  HiClass
//
//  Created by WorkOffice on 2020/4/22.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICStudyOfflineVC.h"
#import "JHKOfflineCourseTopView.h"
#import "JHKOfflineCourseScoreCell.h"
#import "JHKOfflineCourseScoreSectionView.h"
#import "JHKOfflineCourseInfoCell.h"
#import "JHKOfflineCourseIntroduceCell.h"
#import "JHKOfflineCourseDefaultSectionView.h"
#import "JHKOfflineCourseDataCell.h"
#import "JHKOfflineCourseTaskCell.h"
#import "HICNetModel.h"
#import "HICOfflineCourseModel.h"
#import "HICOfflineSubTasksModel.h"
@interface HICStudyOfflineVC ()<UITableViewDelegate,UITableViewDataSource>
{
    BOOL _scoreCellOpenFlag;
    CGFloat _courseDetailCellH;
    CGFloat _introduceCellH;
}
@property (strong, nonatomic) JHKOfflineCourseTopView * topView;
@property (strong, nonatomic) UITableView * aTableView;
@property (strong, nonatomic) JHKOfflineCourseScoreSectionView * scoreSectionView;
@property (strong, nonatomic) NSMutableArray * dataArray;
@property (strong, nonatomic) NSMutableArray * taskArray;
@property (strong, nonatomic) HICNetModel *netModel;
@property (strong, nonatomic) HICOfflineCourseModel *courseModel;

@end

@implementation HICStudyOfflineVC

- (void)viewDidLoad {
    [super viewDidLoad];
      [self initData];
      [self buildView];
}
-(void)initData {
    _scoreCellOpenFlag = NO;
     NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setValue:USER_CID forKey:@"customerId"];
    [dic setValue:_trainId ? _trainId : @0 forKey:@"trainId"];
    [dic setValue:_taskId ?_taskId:@-1 forKey:@"taskId"];
    [HICAPI lineClassDetails:dic success:^(NSDictionary * _Nonnull responseObject) {
        self.courseModel = [HICOfflineCourseModel mj_objectWithKeyValues:[responseObject valueForKey:@"data"]];
        self.topView.model = self.courseModel;
        self.dataArray = (NSMutableArray *)self.courseModel.classPerformRating;
        self.taskArray = (NSMutableArray *)self.courseModel.subTasks;
    }];
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
-(NSMutableArray *)taskArray{
    if (!_taskArray) {
        _taskArray = [NSMutableArray array];
    }
    return _taskArray;
}
-(JHKOfflineCourseTopView *)topView{
    if (!_topView) {
        _topView = [JHKOfflineCourseTopView getTopView];
        [_topView setFrame:CGRectMake(0, 0, HIC_ScreenWidth, 388 * HIC_Divisor)];
    }
    return _topView;
}
-(UITableView *)aTableView{
    if (!_aTableView) {
        _aTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _aTableView.delegate = self;
        _aTableView.dataSource = self;
        _aTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if (@available(iOS 15.0, *)) {
            _aTableView.sectionHeaderTopPadding = 0;
        }
    }
    return _aTableView;
}
-(JHKOfflineCourseScoreSectionView *)scoreSectionView{
    if (!_scoreSectionView) {
        _scoreSectionView = [JHKOfflineCourseScoreSectionView getScoreSectionView];
        [_scoreSectionView setFrame:CGRectMake(0, 0, HIC_ScreenWidth, 100 * HIC_Divisor)];
    }
    return _scoreSectionView;
}
-(void)buildView{
    [self.view addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(388 * HIC_Divisor);
    }];
    [self.view addSubview:self.aTableView];
    [self.aTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(self.topView.mas_bottom);
    }];
}
#pragma mark - TableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        if ([self.dataArray count]>3) {
            if (_scoreCellOpenFlag) {
                return [self.dataArray count]+1;
            }else{
                return 4;
            }
        }else{
            return [self.dataArray count];
        }
    }else if (section == 2) {
        return 1;
    }else if (section == 4){
        return [self.taskArray count];
    }
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 44;
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            return _courseDetailCellH;
        }else if (indexPath.row == 1){
            return 120;
        }else{
            return 85;
        }
    }else if (indexPath.section == 2){
        return _introduceCellH;
    }else if (indexPath.section == 3){
        return 50;
    }else if (indexPath.section == 4){
        return 90;
    }
    return 44;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 100;
    }else if (section == 3 || section == 4){
        return 40;
    }else{
        return 0;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 2) {
        return 0;
    }
    return 8;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return self.scoreSectionView;
    }else if (section == 3){
        JHKOfflineCourseDefaultSectionView * defaultSectionView = [JHKOfflineCourseDefaultSectionView getDefaultSectionView];
        [defaultSectionView setFrame:CGRectMake(0, 0, HIC_ScreenWidth, 44)];
        defaultSectionView.titleLabel.text = NSLocalizableString(@"referenceMaterial", nil);
        return defaultSectionView;
    }else if (section == 4){
        JHKOfflineCourseDefaultSectionView * defaultSectionView = [JHKOfflineCourseDefaultSectionView getDefaultSectionView];
        [defaultSectionView setFrame:CGRectMake(0, 0, HIC_ScreenWidth, 44)];
        defaultSectionView.titleLabel.text = NSLocalizableString(@"courseTasks", nil);
        return defaultSectionView;
    }
    return nil;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * footView = [UIView new];
    [footView setFrame:CGRectMake(0, 0, HIC_ScreenWidth, 8)];
    [footView setBackgroundColor:HexRGB(0xF5F5F5)];
    return footView;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        JHKOfflineCourseScoreCell * cell = [tableView dequeueReusableCellWithIdentifier:JHKOfflineCourseScoreCellIdentifier];
        if (!cell) {
            cell = [JHKOfflineCourseScoreCell getScoreCell];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.moreBtn addTarget:self action:@selector(moreBtnTouch) forControlEvents:UIControlEventTouchUpInside];
        }
        HICOfflineClassPerformModel *model = [HICOfflineClassPerformModel mj_objectWithKeyValues:self.dataArray[indexPath.row]];
        if (_scoreCellOpenFlag) {
            if (indexPath.row < [self.dataArray count]) {
                [cell setCellWithTitle:model.reason score:[NSNumber numberWithFloat:model.points] andMoreFlag:NO];
            }else{
                [cell setCellWithTitle:NSLocalizableString(@"packUp", nil) score:@0 andMoreFlag:YES];
            }
        }else{
            if (indexPath.row < 3) {
                [cell setCellWithTitle:model.reason score:[NSNumber numberWithFloat:model.points] andMoreFlag:NO];
            }else{
                [cell setCellWithTitle:NSLocalizableString(@"lookAtAll", nil) score:@0 andMoreFlag:YES];
            }
        }
        return cell;
    }else if (indexPath.section == 1){
        JHKOfflineCourseInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:JHKOfflineCourseInfoCellIdentifier];
        if (!cell) {
            cell = [JHKOfflineCourseInfoCell getInfoCell];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.infoCellHeightBlock = ^(CGFloat height) {
            self->_courseDetailCellH = height;
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
            [self.aTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        };
        if (indexPath.row == 0) {
            [cell setCellWithTitle:NSLocalizableString(@"courseIntroduction", nil) hours:@"2" detailInfo:self.courseModel.comment];
//                [cell setCellWithTitle:@"课程简介" hours:@"2" detailInfo:NSLocalizableString(@"noIntroduction", nil)];
        }else if (indexPath.row == 1){
            [cell setCellWithTitle:NSLocalizableString(@"courseRewards", nil) score:[NSString stringWithFormat:@"%f",self.courseModel.rewardPoints] credit:[NSString stringWithFormat:@"%f",self.courseModel.rewardCredit] hours:[NSString stringWithFormat:@"%f",self.courseModel.rewardCreditHours]];
        }else if (indexPath.row == 2){
            [cell setCellWithTitle:NSLocalizableString(@"trainingObject", nil) position:self.courseModel.trainees];
        }
        return cell;
    }else if (indexPath.section == 2){
        JHKOfflineCourseIntroduceCell * cell = [tableView dequeueReusableCellWithIdentifier:JHKOfflineCourseIntroduceCellIdentifier];
        if (!cell) {
            cell = [JHKOfflineCourseIntroduceCell getIntroduceCell];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.introduceCellHeightBlock = ^(CGFloat height) {
            self->_introduceCellH = height;
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
            [self.aTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        };
        [cell setCellWithHeaderImage:@"" andName:self.courseModel.lecturerName andInfo:self.courseModel.lecturerPost andIntroduce:self.courseModel.lecturerInfo];
        return cell;
    } else if (indexPath.section == 3){
        JHKOfflineCourseDataCell * cell = [tableView dequeueReusableCellWithIdentifier:JHKOfflineCourseDataCellIdentifier];
        if (!cell) {
            cell = [JHKOfflineCourseDataCell getDataCell];
        }
        return cell;
    } else if (indexPath.section == 4){
        JHKOfflineCourseTaskCell * cell = [tableView dequeueReusableCellWithIdentifier:JHKOfflineCourseTaskCellIdentifier];
        if (!cell) {
            cell = [JHKOfflineCourseTaskCell getTaskCell];
        }

        return cell;
    }
    return nil;
}

-(void)moreBtnTouch {
    if (_scoreCellOpenFlag) {
        _scoreCellOpenFlag = NO;
        [UIView performWithoutAnimation:^{
            NSIndexSet *reloadSet = [NSIndexSet indexSetWithIndex:0];
            [self.aTableView reloadSections:reloadSet withRowAnimation:UITableViewRowAnimationNone];
        }];
    }else{
        _scoreCellOpenFlag = YES;
        [UIView performWithoutAnimation:^{
            NSIndexSet *reloadSet = [NSIndexSet indexSetWithIndex:0];
            [self.aTableView reloadSections:reloadSet withRowAnimation:UITableViewRowAnimationNone];
        }];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
