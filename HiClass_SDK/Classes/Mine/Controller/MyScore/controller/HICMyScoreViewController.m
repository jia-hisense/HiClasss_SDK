//
//  HICMyScoreViewController.m
//  HiClass
//
//  Created by 聚好看 on 2021/11/11.
//  Copyright © 2021 hisense. All rights reserved.
//

#import "HICMyScoreViewController.h"
#import "HICCustomNaviView.h"
#import "HICScoreTaskTableViewCell.h"
#import "HICScoreDetailsViewController.h"
#import "HICRankingListVC.h"
#import "IntegralTaskModel.h"
#import "IntegralTaskListModel.h"
#import "HICIntegralTaskHeadView.h"
@interface HICMyScoreViewController ()<HICCustomNaviViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)HICCustomNaviView *navi;

@property (weak, nonatomic) IBOutlet UITableView *scoreTaskTableView;

///数据源
@property (nonatomic, strong) IntegralTaskModel *model;
///推荐任务数据
@property(nonatomic, strong) NSMutableArray *recommendArray;
///每日任务数据
@property(nonatomic, strong) NSMutableArray *dailyArray;
@property(nonatomic, strong) HICIntegralTaskHeadView *tableHeadView;
@end

@implementation HICMyScoreViewController

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavi];
    [self createUI];
    [self initData];
}
- (void)createNavi {
    self.navi = [[HICCustomNaviView alloc] initWithTitle:NSLocalizableString(@"myScore", nil) rightBtnName:nil showBtnLine:NO];
    [self.navi setBackgroundColor:[UIColor colorWithHexString:@"#00BED7"]];
    self.navi.titleLabel.textColor = [UIColor whiteColor];
    [self.navi.goBackBtn setImage:[UIImage imageNamed:@"头部-返回-白色"] forState:UIControlStateNormal];
    _navi.delegate = self;
    [self.view addSubview:_navi];
}
#pragma mark - - - HICCustomNaviViewDelegate  - - -
- (void)leftBtnClicked {
    if (self.presentingViewController && self.navigationController.viewControllers.count == 1) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)createUI{
    
    _dailyArray = @[].mutableCopy;
    _recommendArray = @[].mutableCopy;
    self.view.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
    
    [self.scoreTaskTableView setBackgroundColor:[UIColor clearColor]];
    self.scoreTaskTableView.delegate = self;
    self.scoreTaskTableView.dataSource = self;
    //设置预估行高
    self.scoreTaskTableView.estimatedRowHeight = 100.0f;
    self.scoreTaskTableView.rowHeight = UITableViewAutomaticDimension;
    self.scoreTaskTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.scoreTaskTableView.bounces = NO;
    if (@available(iOS 15.0, *)) {
        self.scoreTaskTableView.sectionHeaderTopPadding = 0;
    }
    self.tableHeadView = [[HICIntegralTaskHeadView alloc]init];
    self.tableHeadView.lbAllScore.text = self.points;
    self.scoreTaskTableView.tableHeaderView = self.tableHeadView;
    UIView *headerView = self.scoreTaskTableView.tableHeaderView;
    headerView.height = 234;
    self.scoreTaskTableView.tableHeaderView = headerView;
    __weak typeof(self) weakSelf = self;
    self.tableHeadView.integralRankPushBlock = ^{
        HICRankingListVC *rankVc = [HICRankingListVC new];
        rankVc.rankType = HICMyRankPoints;
        [weakSelf.navigationController pushViewController:rankVc animated:YES];
    };
    self.tableHeadView.integralSubsidiaryPushBlock = ^{
        HICScoreDetailsViewController *vc = [[HICScoreDetailsViewController alloc]init];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    if(![[RoleManager menuCodes] containsObject:@"AppPointsTop"]){
        self.tableHeadView.btnScoreRank.hidden = YES;
        self.tableHeadView.lbScoreRank.hidden = YES;
        self.tableHeadView.line.hidden = YES;
        self.tableHeadView.leftDistence.constant -= HIC_ScreenWidth ;
    }
}
#pragma mark tableviewDelegate&&dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if ((section == 0 && _dailyArray.count == 0) || section != 0) {
        return _recommendArray.count;
    }else {
        return _dailyArray.count;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (_recommendArray.count != 0 && _dailyArray.count != 0) {
        return 2;
    }else if (_recommendArray.count != 0 || _dailyArray.count != 0){
        return 1;
    }else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HICScoreTaskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HICScoreTaskTableViewCell"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"HICScoreTaskTableViewCell" owner:self options:nil].firstObject;
    }
    if ((indexPath.section == 0 && _dailyArray.count == 0) || indexPath.section != 0) {
        cell.cellModel = _recommendArray[indexPath.row];
    }else {
        cell.cellModel = _dailyArray[indexPath.row];
    }
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 8;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, HIC_ScreenWidth, 46)];
    headView.backgroundColor = [UIColor whiteColor];
    UILabel *headTitle = [[UILabel alloc]initWithFrame:CGRectMake(16, 0, HIC_ScreenWidth, 46)];
    headTitle.font = FONT_MEDIUM_17;
    if ((section == 0 && _dailyArray.count == 0) || section != 0) {
        headTitle.text = NSLocalizableString(@"recommendTask", nil);
    }else{
        headTitle.text = NSLocalizableString(@"dailyTask", nil);
    }
    [headView addSubview:headTitle];
    return headView;
}

- (void)initData{
    [HICAPI integralTaskList:^(NSDictionary * _Nonnull responseObject) {
        [IntegralTaskModel mj_setupObjectClassInArray:^NSDictionary *{
            return @{
                @"dailyTasklist":[IntegralTaskListModel class],
                @"recoTaskList":[IntegralTaskListModel class]
            };
        }];
        self.model = [IntegralTaskModel mj_objectWithKeyValues:responseObject[@"data"]];
        
        for (int i = 0; i < self.model.dailyTasklist.count; i++) {
            IntegralTaskListModel *model = self.model.dailyTasklist[i];
//            if (![model.maxNum isEqualToString:@"0"]) {
                [self.dailyArray addObject:model];
//            }
        }
        for (int l = 0; l < self.model.recoTaskList.count; l++) {
            IntegralTaskListModel *model = self.model.recoTaskList[l];
//            if (![model.maxNum isEqualToString:@"0"]) {
                [self.recommendArray addObject:model];
//            }
        }
        [self.scoreTaskTableView reloadData];
        
    }];
}


@end
