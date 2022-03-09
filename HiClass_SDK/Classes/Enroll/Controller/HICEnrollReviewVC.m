//
//  HICEnrollReviewVC.m
//  HiClass
//
//  Created by WorkOffice on 2020/6/5.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import "HICEnrollReviewVC.h"
#import "HICEnrollReviewCell.h"
#import "HICEnrollReviewModel.h"
#import "HICEnrollReviewerList.h"
#import "HICEnrollReviewStatusCell.h"
static NSString *reviewCell = @"reviewCell";
static NSString *reviewStatusCell = @"reviewStatusCell";
@interface HICEnrollReviewVC ()<UITableViewDelegate,UITableViewDataSource,HICCustomNaviViewDelegate,HICEnrollReviewerSelectDelegate>
@property (nonatomic ,strong)UITableView *tableView;
@property (nonatomic ,strong)HICNetModel *netModel;
@property (nonatomic ,strong)NSMutableArray *dataSourceTemplate;
@property (nonatomic ,strong)NSMutableArray *dataSourceStatus;
@property (nonatomic ,strong)UIButton *bottomBtn;
@property (nonatomic ,strong)NSIndexPath *indexPath;
@property (nonatomic ,strong)NSMutableArray *infoArr;
@end

@implementation HICEnrollReviewVC
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavi];
    [self configTableView];
    self.view.backgroundColor = UIColor.whiteColor;
    self.bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.bottomBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [self.bottomBtn setTitle:NSLocalizableString(@"urgedToDeal", nil) forState:UIControlStateNormal];
     self.bottomBtn.frame = CGRectMake(42, HIC_ScreenHeight - HIC_BottomHeight - 48 - 20, HIC_ScreenWidth - 84, 48);
    [HICCommonUtils createGradientLayerWithBtn:self.bottomBtn fromColor:[UIColor colorWithHexString:@"00E2D8" alpha:1.0f] toColor:[UIColor colorWithHexString:@"00C5E0" alpha:1.0f]];
    self.bottomBtn.layer.cornerRadius = 4;
     self.bottomBtn.clipsToBounds = YES;
    if (_type == 2) {
        [self.view addSubview:self.bottomBtn];
    }
    [self.bottomBtn addTarget:self action:@selector(forceReview) forControlEvents:UIControlEventTouchUpInside];
}
- (void)configTableView{
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = UIColor.whiteColor;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (_type == 1) {
        [self getDataReviewTemplate];
    }else{
        [self getDataReviewProgressStatus];
    }
    if (@available(iOS 15.0, *)) {
        self.tableView.sectionHeaderTopPadding = 0;
    }
}
- (void)createNavi {
    HICCustomNaviView *navi;
    if (_type == 1) {
        navi = [[HICCustomNaviView alloc] initWithTitle:NSLocalizableString(@"fillInAuditFlow", nil) rightBtnName:NSLocalizableString(@"submit", nil) showBtnLine:NO];
    }else{
        navi = [[HICCustomNaviView alloc] initWithTitle:NSLocalizableString(@"cancellationPrompt", nil) rightBtnName:nil showBtnLine:NO];
    }
    navi.delegate = self;
    [self.view addSubview:navi];
    
}
- (void)forceReview{
    [HICAPI forceReview:_auditInstanceId];
}
- (void)leftBtnClicked {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)rightBtnClicked:(NSString *)str{
    [self submitInfo];
}
- (void)submitInfo{
    NSInteger n = 0;
    NSMutableArray *subArr = [NSMutableArray array];
    for (int i = 0; i < self.dataSourceTemplate.count; i++) {
        HICEnrollReviewModel *model = self.dataSourceTemplate[i];
        NSMutableDictionary *dic = [NSMutableDictionary new];
        [dic setValue:model.auditId forKey:@"nodeId"];
        [dic setValue:model.name forKey:@"nodeName"];
        [dic setValue:model.auditorId forKey:@"auditor"];
        [dic setValue:model.displayOrder forKey:@"displayOrder"];
        [subArr addObject:dic];
        if ([NSString isValidStr:model.auditorName]) {
            n ++;
        }
    }
    if (n == self.dataSourceTemplate.count) {
        NSString *subStr = [subArr mj_JSONString];
        [self doRegisterWithString:subStr];
    }
    
}
- (void)doRegisterWithString:(NSString *)str{
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setValue:_registerID ? _registerID :@-1 forKey:@"registerId"];
    [dic setValue:USER_CID forKey:@"customerId"];
    [dic setValue:_registerName ? _registerName :@"" forKey:@"registerName"];
    [dic setValue:@1 forKey:@"doRegister"];
    [dic setValue:_trainId ? _trainId : @0 forKey:@"trainId"];
    [dic setValue:str forKey:@"auditTemplateNodes"];
    [dic setValue:_auditTemplateID ?_auditTemplateID :@0 forKey:@"acceptAuditProcessId"];
    [HICAPI doRegisterWithString:dic success:^(NSDictionary * _Nonnull responseObject) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)getDataReviewTemplate{
    [HICAPI getDataReviewTemplate:_auditTemplateID success:^(NSDictionary * _Nonnull responseObject) {
        self.dataSourceTemplate = [HICEnrollReviewModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"auditTemplateNodes"]];
        NSMutableArray *temp = self.dataSourceTemplate;
        NSMutableArray *arr ;
        for (int i = 0; i < self.dataSourceTemplate.count; i ++) {
            HICEnrollReviewModel *model = self.dataSourceTemplate[i];
            [arr addObject:@-1];
            if (model.auditTemplateNodeAuditors.count == 1) {
                HICEnrollReviewerModel *remodel = model.auditTemplateNodeAuditors[0];
                model.auditorName = remodel.name;
                model.auditorId = remodel.customerId;
                [temp replaceObjectAtIndex:i withObject:model];
            }
        }
        self.dataSourceTemplate = temp;
        [self.tableView reloadData];
    }];
}
- (void)getDataReviewProgressStatus{
    [HICAPI getDataReviewProgressStatus:_auditInstanceId success:^(NSDictionary * _Nonnull responseObject) {
        self.dataSourceStatus = [HICEnrollReviewProcessModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"auditProcessNodes"]];
        for (int i = 0; i < self.dataSourceStatus.count; i++) {
            HICEnrollReviewProcessModel * model = self.dataSourceStatus[i];
            if (model.status == 0) {
                model.status = 1;
                break ;
            }
        }
        [self.tableView reloadData];
    }];
}
- (void)jumpWithModelArr:(NSArray *)arr andIndexPath:(nonnull NSIndexPath *)indexPath{
    HICEnrollReviewModel *model = self.dataSourceTemplate[indexPath.row];
    HICEnrollReviewerList *vc = HICEnrollReviewerList.new;
    _indexPath = indexPath;
    vc.auditorId = model.auditorId;
    vc.dataArr = [HICEnrollReviewerModel mj_objectArrayWithKeyValuesArray:model.auditTemplateNodeAuditors];
    vc.type = 0;
    vc.naviTitle = NSLocalizableString(@"selectionAuditors", nil);
    vc.returnNameBlock = ^(NSString * _Nonnull name, NSNumber * _Nonnull ID) {
        model.auditorName = name;
        model.auditorId = ID;
        [self.dataSourceTemplate replaceObjectAtIndex:indexPath.row withObject:model];
        [self.tableView reloadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)jumpSearchWithIndexPath:(nonnull NSIndexPath *)indexPath{
    HICEnrollReviewModel *model = self.dataSourceTemplate[indexPath.row];
    _indexPath = indexPath;
    HICEnrollReviewerList *vc = HICEnrollReviewerList.new;
    vc.type = 1;
    vc.naviTitle = NSLocalizableString(@"chooseFromTheOrganizationalStructure", nil);
    vc.auditorId = model.auditorId;
    vc.returnNameBlock = ^(NSString * _Nonnull name, NSNumber * _Nonnull ID) {
        model.auditorName = name;
        model.auditorId = ID;
        [self.dataSourceTemplate replaceObjectAtIndex:indexPath.row withObject:model];
        [self.tableView reloadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark ----uitableViewdelegate&&datasource
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *header = [[UIView alloc]init];
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, HIC_ScreenWidth, 8)];
    topView.backgroundColor = BACKGROUNG_COLOR;
    [header addSubview:topView];
    UIView *downView = [[UIView alloc]initWithFrame:CGRectMake(0, 8, HIC_ScreenWidth, 9)];
    downView.backgroundColor = UIColor.whiteColor;
    [header addSubview:downView];
    return header;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_type == 1) {
     return self.dataSourceTemplate.count;
    }else{
        return self.dataSourceStatus.count;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 17;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 95;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_type == 1) {
        HICEnrollReviewCell *cell = (HICEnrollReviewCell *)[tableView dequeueReusableCellWithIdentifier:reviewCell];
        if (cell == nil) {
            cell = [[HICEnrollReviewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reviewCell];
        }
        cell.reviewModel = self.dataSourceTemplate[indexPath.row];
        cell.indexPath = indexPath;
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        HICEnrollReviewStatusCell *cell = (HICEnrollReviewStatusCell *)[tableView dequeueReusableCellWithIdentifier:reviewStatusCell];
        if (cell == nil) {
            cell = [[HICEnrollReviewStatusCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reviewCell];
        }
//        cell.statusModel = self.dataSourceStatus[indexPath.row];
        cell.processModel = self.dataSourceStatus[indexPath.row];
        cell.indexPath = indexPath;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}
#pragma mark --lazyload
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, HIC_NavBarAndStatusBarHeight, HIC_ScreenWidth, HIC_ScreenHeight - HIC_NavBarAndStatusBarHeight) style:UITableViewStylePlain];
    }
    return _tableView;
}
-(NSMutableArray *)infoArr{
    if (!_infoArr) {
        _infoArr = [NSMutableArray array];
    }
    return _infoArr;
}
@end
