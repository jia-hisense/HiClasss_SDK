//
//  HICOfflineTrainInfoVC.m
//  HiClass
//
//  Created by hisense on 2020/4/14.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import "HICOfflineTrainInfoVC.h"
#import "HICNavgationBar.h"
#import "UIColor+OtherCreateColor.h"
#import "HICTrainingInfoModel.h"
#import "HICTrainingHeaderView.h"

#import "HICTrainingBriefCell.h"
#import "HICTrainingOtherInfoCell.h"
#import "UIView+Gradient.h"
#import "NSString+String.h"
#import "HomeTaskCenterDefaultView.h"
#import "HICOfflineCourseDetailVC.h"
#import "OfflineTrainPlanListVC.h"
#import "HICEnrollDetailModel.h"
#import "HICOfflineCourseEnrollCell.h"
#import "HICEnrollReviewVC.h"
#import "HICMixTrainArrangeVC.h"
#import "HICMixTrainArrangeMapVC.h"
#import "HICNotEnrollTrainArrangeVC.h"
#import "HICEnrollReviewVC.h"
#import "HICOfflineCourseNoAccessCell.h"
@interface HICOfflineTrainInfoVC()<UITableViewDelegate, UITableViewDataSource,HICOfflineCourseEnrollDelegate>
@property (nonatomic, weak) UITableView *table;

@property (nonatomic, weak) HICNavgationBar *navBar;

@property (nonatomic, weak) UIView *bottomView;

@property (nonatomic, strong) HomeTaskCenterDefaultView *defaultView;


@property (nonatomic, strong) HICTrainingInfoModel *trainingInfo;


@property (nonatomic, strong) HICTrainingHeaderFrame *headerFrame;

@property (nonatomic, strong) NSArray *datas;

@property (nonatomic ,strong) HICEnrollDetailModel *detailModel;

@property (nonatomic ,assign)BOOL isAccess;

@end

@implementation HICOfflineTrainInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController setNavigationBarHidden:YES];
    [self.tabBarController.tabBar setHidden:YES];
    self.isAccess = YES;
    HICNavgationBar *navBar = [[HICNavgationBar alloc] initWithTitle:NSLocalizableString(@"trainingDetails", nil) bgImage:@"navi_back" leftBtnImage:@"头部-返回-白色" rightBtnImg:nil];
    navBar.frame = CGRectMake(0, 0, HIC_ScreenWidth, HIC_NavBarAndStatusBarHeight);
    [self.view addSubview:navBar];
    [navBar setItemClicked:^(HICNavgationTapType tapType) {
        switch (tapType) {
            case LeftTap:
                if (self.presentingViewController && self.navigationController.viewControllers.count == 1) {
                    [self dismissViewControllerAnimated:YES completion:nil];
                } else {
                    [self.navigationController popViewControllerAnimated:YES];
                }
                break;
            case RightTap:
                
                break;
                
            default:
                break;
        }
    }];
    self.navBar = navBar;
    
    [self requestData];
    
    //    [navBar updateBgImageHeight:headerFrame.headerHeight];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.detailModel.registerId) {
        [self loadRegisterData];
    }
    //    [self.navigationController setNavigationBarHidden:YES];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //    [self.navigationController setNavigationBarHidden:YES];
    self.navigationController.navigationBarHidden = YES;
}

- (void)requestData {
    __weak typeof(self) weakSelf = self;
    [RoleManager showWindowLoadingView];
    [HICAPI offlineTrainingDetail:self.trainId success:^(NSDictionary * _Nonnull responseObject) {
        NSDictionary *dicData = [responseObject objectForKey:@"data"];
        if (dicData) {
            _trainingInfo = [HICTrainingInfoModel mj_objectWithKeyValues:dicData];
        } else {
            [self.defaultView setHidden:NO];
        }
        if (_trainingInfo.registChannel != 2) {
            [self loadRegisterData];
        }
        if (_trainingInfo.registChannel == 2 && _isRegisterJump) {
            [HICToast showWithText:NSLocalizableString(@"repeatRegistrationPrompt", nil)];
        }
        HICTrainingHeaderFrame *headerFrame = [[HICTrainingHeaderFrame alloc] initWithTrainingInfo:_trainingInfo];
        weakSelf.headerFrame = headerFrame;
        
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        weakSelf.datas = arr;
        
        HICTrainingBriefData *briefData = [[HICTrainingBriefData alloc] initWithTitle:NSLocalizableString(@"trainingIntroduction", nil) time:nil brief:_trainingInfo.trainComment];
        HICTrainingBriefFrame *briefFrame = [[HICTrainingBriefFrame alloc] initWithData:briefData isOpened:NO];
        [arr addObject:briefFrame];
        
        HICTrainingOtherInfoFrame *aimFrame = [[HICTrainingOtherInfoFrame alloc] initWithTitle:NSLocalizableString(@"trainingObjectives", nil) content:[NSString realString:_trainingInfo.trainGoal] isSeparatorHidden: NO];
        [arr addObject:aimFrame];
        HICTrainingOtherInfoFrame *objectFrame = [[HICTrainingOtherInfoFrame alloc] initWithTitle:NSLocalizableString(@"trainingObject", nil) content:[NSString realString:_trainingInfo.trainAudience] isSeparatorHidden: NO];
        [arr addObject:objectFrame];
        
        NSString *pointsText = self.trainingInfo.points.integerValue > 0 ? [NSString stringWithFormat:@"%@\n", HICLocalizedFormatString(@"rewardPoints", self.trainingInfo.points.integerValue)] : @"";
        
        NSString *rewardStr = [NSString stringWithFormat:@"%@：%@\n%@：%@\n%@%@：%@", NSLocalizableString(@"credits", nil),[NSString realString:_trainingInfo.rewardPointsStr],NSLocalizableString(@"studyTime", nil),[NSString realString:_trainingInfo.rewardCreditMinsStr], pointsText, NSLocalizableString(@"certificate", nil),[NSString realString:_trainingInfo.certificateListStr]];
        HICTrainingOtherInfoFrame *rewardtFrame = [[HICTrainingOtherInfoFrame alloc] initWithTitle:NSLocalizableString(@"trainingReward", nil) content:rewardStr isSeparatorHidden: YES];
        [arr addObject:rewardtFrame];
        
        [weakSelf.table reloadData];
        // 更新bar背景图片高度
        [weakSelf.navBar updateBgImageHeight:weakSelf.headerFrame.headerHeight];
        
        
        if (!weakSelf.isStarted) {
            [weakSelf.bottomView setHidden:NO];
        }
        if (weakSelf.isRegisterJump) {
            [weakSelf.bottomView setHidden:NO];
        }
        [RoleManager hiddenWindowLoadingView];
    } failure:^(NSError * _Nonnull error) {
        // 重新请求数据
        [RoleManager showErrorViewWith:self.view frame:CGRectMake(0, CGRectGetMaxY(weakSelf.navBar.frame), weakSelf.view.width, weakSelf.view.height-CGRectGetMaxY(weakSelf.navBar.frame)) blcok:^(NSInteger type) {
            [weakSelf requestData];
        }];
        [RoleManager hiddenWindowLoadingView];
    }];
    
}
- (void)loadRegisterData {
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setValue:USER_CID forKey:@"customerId"];
    [dic setValue:_registerActionId.integerValue > 0 ? _registerActionId :@-1 forKey:@"registerId"];
    [dic setValue:_trainId > 0 ? [NSNumber numberWithInteger:_trainId] :@0 forKey:@"trainId"];
    [dic setValue:[NSNumber numberWithInteger:_trainId] forKey:@"trainId"];
    [HICAPI registrationDetail:dic success:^(NSDictionary * _Nonnull responseObject){
        self.detailModel = [HICEnrollDetailModel mj_objectWithKeyValues:responseObject[@"data"]];
        [self.table reloadData];
    } failure:^(NSError * _Nonnull error) {
        self.isAccess = NO;
        [self.table reloadData];
    }];
    
    
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (UIView *)bottomView {
    if (!_bottomView) {
        CGFloat topPadding = 0;
        if (HIC_isIPhoneX) {
            topPadding += 34;
        }
        
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height-120-topPadding, self.view.width, 120+topPadding)];
        _bottomView = bottomView;
        [bottomView addGradientLayer:CGPointZero endPoint:CGPointMake(0, 1) colors:@[(__bridge id)[UIColor colorWithHexString:@"#00FFFFFF"].CGColor, (__bridge id)[UIColor colorWithHexString:@"#FFFFFFFF"].CGColor]];
        [self.view addSubview:bottomView];
        
        UIButton *arrangeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        arrangeBtn.frame = CGRectMake(16, 56, bottomView.width-32, 48);
        [arrangeBtn setTitle:NSLocalizableString(@"trainingArrangement", nil) forState:UIControlStateNormal];
        [arrangeBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        [arrangeBtn.titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:18]];
        [arrangeBtn addGradientLayer:CGPointZero endPoint:CGPointMake(1, 0) colors:@[(__bridge id)[UIColor colorWithHexString:@"#00E2D8"].CGColor, (__bridge id)[UIColor colorWithHexString:@"#00C5E0"].CGColor]];
        arrangeBtn.layer.cornerRadius = 4;
        arrangeBtn.layer.masksToBounds = YES;
        [bottomView addSubview:arrangeBtn];
        [arrangeBtn addTarget:self action:@selector(gotoArangePage:) forControlEvents:UIControlEventTouchUpInside];
        
        return _bottomView;
    }
    
    return _bottomView;
    
}

- (UITableView *)table {
    
    if (!_table) {
        UITableView *table = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        [self.view addSubview:table];
        _table = table;
        if (@available(iOS 11.0, *)) {
            _table.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        CGFloat topPadding = 96;
        if (HIC_isIPhoneX) {
            topPadding += 10;
        }
        
        if (_isStarted) {
            topPadding = 64 + HIC_BottomHeight;
        }
        
        _table.contentInset = UIEdgeInsetsMake(0, 0, topPadding, 0);
        _table.bounces = NO;
        _table.showsVerticalScrollIndicator = NO;
        _table.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
        _table.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _table.delegate = self;
        _table.dataSource = self;
        
        if (_navBar) {
            [self.view bringSubviewToFront:_navBar];
        }
        
        table.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
        table.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
        table.sectionHeaderHeight = CGFLOAT_MIN;
        table.sectionFooterHeight = CGFLOAT_MIN;
        if (@available(iOS 15.0, *)) {
            _table.sectionHeaderTopPadding = 0;
            table.sectionHeaderTopPadding = 0;
        }
        
    }
    
    return _table;
}


- (HomeTaskCenterDefaultView *)defaultView {
    if (!_defaultView) {
        HomeTaskCenterDefaultView *defaultView = [[HomeTaskCenterDefaultView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navBar.frame), self.view.width, self.view.height)];
        defaultView.titleStr = NSLocalizableString(@"temporarilyNoData", nil);
        [self.view addSubview:defaultView];
        _defaultView = defaultView;
    }
    return _defaultView;
}


- (void)gotoArangePage:(UIButton *)button {
    if (!_isAccess) {
        HICNotEnrollTrainArrangeVC *vc = HICNotEnrollTrainArrangeVC.new;
        vc.trainId = _trainingInfo.trainingId;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    // 跳转到培训安排页面
    if (_trainingInfo.trainType == 2) {
        if (self.detailModel.userRegisterStatus == HICFormalStudent || self.detailModel.registerId.integerValue == 0) {
            OfflineTrainPlanListVC *ct = [[OfflineTrainPlanListVC alloc] init];
            ct.trainId = self.trainId;
            [self.navigationController pushViewController:ct animated:YES];
        }else{
            HICNotEnrollTrainArrangeVC *vc = HICNotEnrollTrainArrangeVC.new;
            vc.trainId = _trainingInfo.trainingId;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    if (_trainingInfo.trainType == 3) {
        if (self.detailModel.userRegisterStatus == HICFormalStudent || self.detailModel.registerId.integerValue == 0) {//已报名||被指派\
            
            if ([_trainingInfo.scene isEqualToString:@"classic"]) {
                if (self.isShowArrange) {
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    HICMixTrainArrangeVC *vc = HICMixTrainArrangeVC.new;
                    vc.trainId = _trainingInfo.trainingId;
                    vc.isReload = NO;
                    vc.registerId = _registerActionId;
                    vc.isDesc = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }else{
                HICMixTrainArrangeMapVC *vc = HICMixTrainArrangeMapVC.new;
                vc.trainId = _trainingInfo.trainingId;
                vc.registerId = _registerActionId;
                vc.taskName = _trainingInfo.trainName;
                vc.isDesc = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }else{//未报名
            HICNotEnrollTrainArrangeVC *vc = HICNotEnrollTrainArrangeVC.new;
            vc.trainId = _trainingInfo.trainingId;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (void)doRegisterWithType:(NSNumber*)type{
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setValue:USER_CID forKey:@"customerId"];
    [dic setValue:_registerActionId ? _registerActionId :@0 forKey:@"registerId"];
    [dic setValue:self.detailModel.customerId ? self.detailModel.customerId :@"" forKey:@"customerId"];
    [dic setValue:self.detailModel.registerName ? self.detailModel.registerName :@"" forKey:@"registerName"];
    [dic setValue:type forKey:@"doRegister"];
    [dic setValue:[NSNumber numberWithInteger:_trainId] forKey:@"trainId"];
    [HICAPI doRegisterWithType:dic success:^(NSDictionary * _Nonnull responseObject) {
        NSString *title ;
        if ([type isEqual:@1]) {
            title = NSLocalizableString(@"registrationSuccessPrompt", nil);
        }else{
            title = [NSString stringWithFormat:@"%@！",NSLocalizableString(@"registrationHasBeenAbandoned", nil)];
        }
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:NSLocalizableString(@"prompt", nil) message:title preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *confirm = [UIAlertAction actionWithTitle:NSLocalizableString(@"determine", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alertVc addAction:confirm];
        [self presentViewController:alertVc animated:YES completion:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }];
}
#pragma mark --enrolldelegate
//报名/放弃报名
- (void)clickBtnWithTitle:(NSString *)title{
    if ([title isEqualToString:NSLocalizableString(@"signUpImmediately", nil)]) {
        if (self.detailModel.acceptAuditProcessStatus == 0) {//无审核
            [self doRegisterWithType:@1];
        }else{
            HICEnrollReviewVC *vc = HICEnrollReviewVC.new;
            vc.auditTemplateID = self.detailModel.acceptAuditProcessId;
            vc.auditInstanceId = self.detailModel.auditProcessInstanceId;
            vc.type = 1;
            vc.registerID = self.detailModel.registerId;
            vc.trainId = [NSNumber numberWithInteger:_trainId];
            vc.registerName = self.detailModel.registerName;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else{//放弃报名
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@?",NSLocalizableString(@"giveUpTheRegistration", nil)] message:NSLocalizableString(@"confirmCancellationPrompt", nil) preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * cancel = [UIAlertAction actionWithTitle:NSLocalizableString(@"cancel", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *confirm = [UIAlertAction actionWithTitle:NSLocalizableString(@"determine", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self doRegisterWithType:@-1];
        }];
        [alertVc addAction:cancel];
        [alertVc addAction:confirm];
        [self presentViewController:alertVc animated:YES completion:nil];
        //        [self doRegisterWithType:@-1];
    }
}
//查看审核状态
- (void)checkReviewStatus{
    HICEnrollReviewVC *vc = HICEnrollReviewVC.new;
    vc.type = 2;
    vc.registerID = self.detailModel.registerId;
    vc.auditTemplateID = self.detailModel.acceptAuditProcessId;
    vc.registerName = self.detailModel.registerName;
    vc.trainId = self.detailModel.trainId;
    vc.auditInstanceId = self.detailModel.auditProcessInstanceId;
    [self.navigationController pushViewController:vc animated:YES];
}
- (CGFloat)getContentHeight:(NSString *)str {
    UILabel *label = [[UILabel alloc] init];
    label.text = str;
    label.font = FONT_REGULAR_14;
    label.numberOfLines = 0;
    CGFloat labelHeight = [HICCommonUtils sizeOfString:str stringWidthBounding:HIC_ScreenWidth - 60 font:14 stringOnBtn:NO fontIsRegular:YES].height;
    label.frame = CGRectMake(0, 0, HIC_ScreenWidth - 32, labelHeight);
    [label sizeToFit];
    return label.frame.size.height;
}
#pragma UITableView Delegates
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        CGFloat limitHeight = [self getContentHeight:[NSString stringWithFormat:@"%@: %@",NSLocalizableString(@"signUpRequirements", nil),[NSString isValidStr:self.detailModel.limit]?self.detailModel.limit:@"--"]];
        if (!self.isAccess) {
            return 150;
        }
        if (_trainingInfo.registChannel == 2) {
            return 0;
        }
        if (_detailModel.isPassFlag < 0) {
            return 145 + 8- 20 + limitHeight;
        }
        if (self.detailModel.status == HICEnrollNotRegister) {
            if (self.detailModel.curTime.integerValue < self.detailModel.registerStartTime.integerValue) {
                return 140- 20 + limitHeight;
            }else{
                //                if (self.detailModel.applicationsNumber == self.detailModel.registerApplyNum) {
                return 152 + 8 - 20 + limitHeight;
                //                }
            }
            
        }else if (self.detailModel.status == HICEnrollExpired){
            return 124.5 + 8 -20 + limitHeight;
        }else{
            if (self.detailModel.userRegisterStatus == HICSubstituteStudent) {
                return 184 + 8 - 20 + limitHeight;
            }else if (self.detailModel.userRegisterStatus == HICAuditing || self.detailModel.userRegisterStatus == HICEnrollFaild){
                return 152 + 8 - 20 + limitHeight;
            }else if (self.detailModel.userRegisterStatus == HICFormalStudent){
                if (self.detailModel.curTime.integerValue > self.detailModel.abandonEndTime.integerValue) {
                    return 124 + 8;
                }else{
                    return 205 +8;
                }
            }else if(self.detailModel.userRegisterStatus == HICDisqualification){
                return 125 + 8;
            }
        }
        return 200;
    }else{
        NSInteger index = indexPath.row - 1;
        if (index < _datas.count) {
            if ([_datas[index] isKindOfClass:HICTrainingBriefFrame.class]) {
                HICTrainingBriefFrame *data = (HICTrainingBriefFrame *)_datas[index];
                return data.cellHeight;
            }
            
            if ([_datas[index] isKindOfClass:HICTrainingOtherInfoFrame.class]) {
                HICTrainingOtherInfoFrame *data = (HICTrainingOtherInfoFrame *)_datas[index];
                return data.cellHeight;
            }
        }
    }
    return 0;
    
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (indexPath.row == 0) {
        if (self.isAccess) {
            HICOfflineCourseEnrollCell *enrollCell = [[HICOfflineCourseEnrollCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OfflineEnrollCell"];
            if (self.detailModel.registerId.integerValue > 0) {
                enrollCell.model = self.detailModel;
                enrollCell.delegate = self;
                enrollCell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            return enrollCell;
        }else{
            HICOfflineCourseNoAccessCell *noCell = [[HICOfflineCourseNoAccessCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OfflineNoAccessCell"];
            return noCell;
        }
    }else{
        NSInteger index = indexPath.row - 1;
        if (index < _datas.count) {
            id _data = _datas[index];
            if ([_data isKindOfClass:HICTrainingBriefFrame.class]) {
                HICTrainingBriefFrame *data = (HICTrainingBriefFrame *)_data;
                HICTrainingBriefCell *cellBrief = [HICTrainingBriefCell cellWithTableView:tableView];
                cell = cellBrief;
                cellBrief.briefFrame = data;
                __weak typeof(self) weakSelf = self;
                [cellBrief setOpenOrShrinkBlock:^(HICTrainingBriefCell * _Nonnull _cell) {
                    _cell.briefFrame.isOpened = !_cell.briefFrame.isOpened;
                    [weakSelf.table reloadData];
                }];
            }
            
            if ([_data isKindOfClass:HICTrainingOtherInfoFrame.class]) {
                HICTrainingOtherInfoFrame *data = (HICTrainingOtherInfoFrame *)_data;
                HICTrainingOtherInfoCell *otherInfoCell = [HICTrainingOtherInfoCell cellWithTableView:tableView];
                otherInfoCell.infoFrame = data;
                cell = otherInfoCell;
            }
        }
        return cell;
    }
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!_trainingInfo) {
        return 0;
    }
    return _datas.count + 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (!_trainingInfo) {
        return 0;
    }
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (!_headerFrame) {
        return nil;
    }
    
    HICTrainingHeaderView *view = [[HICTrainingHeaderView alloc] initWithHeaderFrame:_headerFrame];
    view.frame = CGRectMake(0, 0, tableView.width, _headerFrame.headerHeight);
    
    return view ;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (!_headerFrame) {
        return 0;
    }
    return _headerFrame.headerHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}


@end
