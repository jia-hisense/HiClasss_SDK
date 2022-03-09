//
//  HICQuestionAllView.m
//  HiClass
//
//  Created by WorkOffice on 2020/6/8.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import "HICQuestionAllView.h"
#import "HICQuestionCell.h"
#import "HICQuestionModel.h"
#import "HICTrainQuestionVC.h"
static NSString *questionAll = @"questionAll";
@interface HICQuestionAllView ()<UITableViewDelegate,UITableViewDataSource>

@end
@implementation HICQuestionAllView
- (instancetype)init {
    if (self = [super init]) {
        [self createUI];
    }
    return self;
}
- (void)createUI {
    self.frame = CGRectMake(HIC_ScreenWidth*3, 0, HIC_ScreenWidth, HIC_ScreenHeight - HIC_NavBarAndStatusBarHeight - 44 -6);
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.separatorColor = [UIColor clearColor];
    self.backgroundColor = BACKGROUNG_COLOR;
    [self configTableView];
}
- (void)configTableView {
    self.delegate = self;
    self.dataSource = self;
    self.estimatedRowHeight = 160;
    self.rowHeight = UITableViewAutomaticDimension;
    [self registerClass:[HICQuestionCell class] forCellReuseIdentifier:questionAll];
    if (@available(iOS 15.0, *)) {
        self.sectionHeaderTopPadding = 0;
    }
}
- (void)setDataArr:(NSMutableArray *)dataArr{
    _dataArr = dataArr;
    [self reloadData];
}

#pragma mark tableviewDelegate&&dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}
 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HICQuestionCell *cell = (HICQuestionCell *)[tableView dequeueReusableCellWithIdentifier:questionAll forIndexPath:indexPath];
    cell.isAll = YES;
    cell.model = _dataArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HICQuestionListModel *qmodel = _dataArr[indexPath.row];
    if (qmodel.state == HICQuestionExpired) {
        [HICToast showWithText:NSLocalizableString(@"questionnaireIsOverdue", nil)];
        return;
    }
    NSString * urlStr = [NSString stringWithFormat:@"%@/mweb/index.html#/questionnaire?questionActionId=%ld", APP_Web_DOMAIN, (long)qmodel.actionId.integerValue];
    PushViewControllerModel *model = [[PushViewControllerModel alloc] initWithPushType:13 urlStr:urlStr detailId:qmodel.actionId.integerValue studyResourceType:HICHtmlType pushType:0];
           [HICPushViewManager parentVC:[HICCommonUtils viewController:self] pushVCWithModel:model];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 6;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, HIC_ScreenWidth, 6)];
    line.backgroundColor = BACKGROUNG_COLOR;
    return line;
}
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    view.backgroundColor = [UIColor clearColor];
}


@end
