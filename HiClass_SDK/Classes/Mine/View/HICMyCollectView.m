//
//  HICMyCollectView.m
//  HiClass
//
//  Created by WorkOffice on 2020/2/20.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICMyCollectView.h"
#import "HICMyCollectCell.h"
#import "HICCourseModel.h"
#import "HICKnowledgeDetailVC.h"
#import "HICLessonsVC.h"

static NSString *collectCell = @"collectCell";
@interface HICMyCollectView()<UITableViewDelegate,UITableViewDataSource,HICMyCollectDelegate>
@property (nonatomic, strong) UIImageView *blackView;
@property (nonatomic ,strong)UILabel *blackLabel;
@property (nonatomic, strong) HICNetModel *netModel;
@property (nonatomic ,assign) BOOL isEdit;
@property (nonatomic ,strong) NSMutableArray *checkArr;
@property (nonatomic ,assign)BOOL isChecked;

@end
@implementation HICMyCollectView
-(UIImageView *)blackView{
    if (!_blackView) {
        _blackView = [[UIImageView alloc]initWithFrame:CGRectMake(HIC_ScreenWidth / 2 - 60, 101.5, 120, 120)];
        _blackView.image = [UIImage imageNamed:@"暂无收藏"];
    }
    return _blackView;
}
- (UILabel *)blackLabel{
    if (!_blackLabel) {
        _blackLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 221.5 + 8, HIC_ScreenWidth, 20)];
        _blackLabel.text = NSLocalizableString(@"noCollection", nil);
        _blackLabel.textColor = TEXT_COLOR_LIGHTS;
        _blackLabel.font = FONT_REGULAR_15;
        _blackLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _blackLabel;
}
- (void)setDataArr:(NSMutableArray *)dataArr{
    _dataArr = [NSMutableArray arrayWithArray:dataArr];
    if (_dataArr.count == 0) {
        [self addSubview:self.blackView];
        [self addSubview:self.blackLabel];
    }
    [self reloadData];
}
- (NSMutableArray *)checkArr{
    if (!_checkArr) {
        _checkArr = [NSMutableArray new];
    }
    return _checkArr;
}
- (void)isEditSelect:(BOOL)isEdit{
    self.isEdit = isEdit;
    self.isChecked = false;
    [self.checkArr removeAllObjects];
    [self reloadData];
}
- (void)setCheckedArr:(NSMutableArray *)checkedArr{
    if (checkedArr.count) {
        self.checkArr = checkedArr;
        [self reloadData];
    }
}
- (instancetype)init {
    if (self = [super init]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    self.backgroundColor = [UIColor colorWithHexString:@"#E9E9E9"];
    self.frame = CGRectMake(0, 0 , HIC_ScreenWidth, HIC_ScreenHeight - HIC_NavBarAndStatusBarHeight);
    [self configTableView];
}
- (void)configTableView {
    self.delegate = self;
    self.dataSource = self;
    self.backgroundColor = [UIColor whiteColor];
    [self registerClass:[HICMyCollectCell class] forCellReuseIdentifier:collectCell];
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (@available(iOS 15.0, *)) {
        self.sectionHeaderTopPadding = 0;
    }
}
- (void)returnArr:(checkArrBlock)block{
    self.checkArrblock = block;
}
-(void)checkIndex:(NSIndexPath *)indexPath{
    if ([self.checkArr containsObject:indexPath]) {
        [self.checkArr removeObject:indexPath];
    }else{
        [self.checkArr addObject:indexPath];
    }
    if (self.checkArrblock != nil) {
        self.checkArrblock(self.checkArr);
    }
    [self reloadData];
}

#pragma mark -uitableview
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HICMyCollectCell *cell = (HICMyCollectCell *)[tableView dequeueReusableCellWithIdentifier:collectCell];
    if (!cell) {
        cell = [[HICMyCollectCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:collectCell];
    }
    cell.collectDelegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    self.isChecked = false;
    if (self.checkArr.count > 0) {
        for (NSIndexPath *index in self.checkArr) {
            if (index.row == indexPath.row) {
                self.isChecked = true;
            }
        }
    }
    [cell setModel:[HICMyCollectModel mj_objectWithKeyValues:self.dataArr[indexPath.row]] andIndexPath:indexPath andIsEdit:self.isEdit andIsChecked:self.isChecked];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HICMyCollectModel *model = [HICMyCollectModel mj_objectWithKeyValues:self.dataArr[indexPath.row]];
    HICCourseModel *course = [HICCourseModel mj_objectWithKeyValues:model.courseKLDInfo];
    if (course.courseKLDType >= 0 && [NSString isValidStr:course.courseKLDId.stringValue]) {
        if (course.courseKLDType == 7) {
            HICKnowledgeDetailVC *vc = [HICKnowledgeDetailVC new];
            vc.kType = course.resourceType;
            vc.objectId = course.courseKLDId;
            vc.partnerCode = course.partnerCode;
            ///日志上报
            HICStudyLogReportModel *reportModel = [[HICStudyLogReportModel alloc]initWithType:HICMyCollectToKnowledge];
            reportModel.mediaid = course.courseKLDId;
            reportModel.knowtype = [NSNumber numberWithInteger:course.resourceType];
            reportModel.mediatype = [NSNumber numberWithInteger:HICReportKnowledgeType];
            NSMutableDictionary *report = [NSMutableDictionary dictionaryWithDictionary:[reportModel getParamDict]];
            [report setValuesForKeysWithDictionary:[LogManager getSerLogEventDictWithType:HICMyCollectToKnowledge]];
            [LogManager reportSerLogWithDict:report];
            [[HICCommonUtils viewController:self].navigationController pushViewController:vc animated:YES];
        }else if (course.courseKLDType == 6) {
            HICLessonsVC *lessVC = [HICLessonsVC new];
            lessVC.objectID = course.courseKLDId ?course.courseKLDId:@0 ;
            ///日志上报
            HICStudyLogReportModel *reportModel = [[HICStudyLogReportModel alloc]initWithType:HICMyCollectToKnowledge];
            reportModel.mediaid = course.courseKLDId ?course.courseKLDId:@0 ;
            reportModel.knowtype = [NSNumber numberWithInteger:course.resourceType];
            reportModel.mediatype = [NSNumber numberWithInteger:HICReportCourseType];
            NSMutableDictionary *report = [NSMutableDictionary dictionaryWithDictionary:[reportModel getParamDict]];
            [report setValuesForKeysWithDictionary:[LogManager getSerLogEventDictWithType:HICMyCollectToKnowledge]];
            [LogManager reportSerLogWithDict:report];
            [[HICCommonUtils viewController:self].navigationController pushViewController:lessVC animated:YES];
        }
    }
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:NSLocalizableString(@"sureCollectionPrompt", nil) message:@"" preferredStyle:UIAlertControllerStyleAlert];
        // 取消按钮
        UIAlertAction * canleBtn = [UIAlertAction actionWithTitle:NSLocalizableString(@"cancel", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [canleBtn setValue:[UIColor colorWithRed:76/255.0 green:81/255.0 blue:87/255.0 alpha:1/1.0] forKey:@"_titleTextColor"];
        [alertVc addAction :canleBtn];
        [canleBtn setValue:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1/1.0] forKey:@"_titleTextColor"];
        UIAlertAction * identityBtn = [UIAlertAction actionWithTitle:NSLocalizableString(@"determine", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSMutableDictionary *postModel = [NSMutableDictionary new];
            HICMyCollectModel *collectModel = [HICMyCollectModel mj_objectWithKeyValues:self.dataArr[indexPath.row]];
            [postModel setValue:[NSString stringWithFormat:@"%@",collectModel.collectId] forKey:@"collectionIds"];
            [postModel setValue:@(1) forKey:@"terminalType"];
            NSString *url = [NSString stringWithFormat:@"%@?collectionIds=%@", MY_COLLECT_DELETE, [collectModel.collectId toString]];
            [HICAPI deleteCollection:postModel url:url success:^(NSDictionary * _Nonnull responseObject) {
                if (responseObject) {
                    [self.dataArr removeObjectAtIndex:indexPath.row];
                    [self deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
                    if (self.dataArr.count == 0) {
                        [self addSubview:self.blackView];
                        [self addSubview:self.blackLabel];
                    }
                    [self reloadData];
                }
            }];
        }];
        [identityBtn setValue:[UIColor colorWithRed:0/255.0 green:190/255.0 blue:215/255.0 alpha:1/1.0] forKey:@"_titleTextColor"];
        [alertVc addAction :identityBtn];
        [alertVc setPreferredAction:identityBtn];
        [[HICCommonUtils viewController:self] presentViewController:alertVc animated:YES completion:nil];
    }
    
    
}

@end
