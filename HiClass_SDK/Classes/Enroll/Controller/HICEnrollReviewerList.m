//
//  HICEnrollReviewerList.m
//  HiClass
//
//  Created by WorkOffice on 2020/6/9.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import "HICEnrollReviewerList.h"
#import "HICEnrollReviewerCell.h"
#import "HomeTaskCenterDefaultView.h"
static NSString *reviewrCell = @"reviewrCell";
@interface HICEnrollReviewerList ()<UITableViewDelegate,UITableViewDataSource,HICCustomNaviViewDelegate,UITextFieldDelegate,HICEnrollReviewerDelegate>
@property (nonatomic ,strong)UITableView *tableView;
@property (nonatomic ,strong)NSString *searchText;
@property (nonatomic ,strong)UITextField *textfild;
@property (nonatomic ,strong)UIView *bottomView;
//@property (nonatomic ,strong)UIButton *bottomBtn;
@property (nonatomic ,strong)HICNetModel *netModel;
@property (nonatomic ,strong)NSMutableArray *employeeListArr;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic ,strong)HomeTaskCenterDefaultView *defalutView;
@end
@implementation HICEnrollReviewerList
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
    [self createUI];
}
- (void)createUI{
    self.view.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomView];
    [self.view addSubview:self.defalutView];
    self.defalutView.hidden = YES;
    self.tableView.delegate  = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[HICEnrollReviewerCell class] forCellReuseIdentifier:reviewrCell];

}

-(void)setDataArr:(NSArray *)dataArr{
    self.employeeListArr = [NSMutableArray arrayWithArray:dataArr];
    if (self.employeeListArr.count == 0) {
        // 增加刷新机制
        __weak typeof(self) weakSelf = self;
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf.employeeListArr removeAllObjects];
            [weakSelf.tableView reloadData];
            weakSelf.pageIndex = 0;
            [weakSelf searchReviewer];
        }];
        MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            // 加载更多数据
            weakSelf.pageIndex++;
            [weakSelf searchReviewer];
        }];
        self.tableView.mj_footer = footer;
        [self searchReviewer];
    }else{
        if (!_auditorId) {
            return;
        }
        for (HICEnrollReviewerModel *model in self.employeeListArr) {
            if (model.customerId.integerValue == _auditorId.integerValue) {
                   model.isSelected = YES;
               }
           }
    }
    [self.tableView reloadData];
}
- (void)createNavi {
    HICCustomNaviView *navi = [[HICCustomNaviView alloc] initWithTitle:_naviTitle rightBtnName:nil showBtnLine:NO];
    navi.delegate = self;
    [self.view addSubview:navi];
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, HIC_NavBarHeight - 0.5, HIC_ScreenWidth, 0.5)];
    line.backgroundColor = DEVIDE_LINE_COLOR;
    [navi addSubview:line];
}
- (void)searchReviewer{
    [self.view endEditing:YES];
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setValue:self.textfild.text forKey:@"param"];
    [dic setValue:@1 forKey:@"terminalType"];
    [dic setValue:[NSNumber numberWithInteger:self.pageIndex * 10] forKey:@"start"];
    [HICAPI searchReviewer:dic success:^(NSDictionary * _Nonnull responseObject) {
        if ([responseObject[@"data"] isKindOfClass:[NSDictionary class]]) {
            if ([[responseObject[@"data"] valueForKey:@"employeeList"] isKindOfClass:[NSArray class]]) {
                NSMutableArray *tempArr = [HICEnrollReviewerModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"employeeList"]];
                if (tempArr.count > 0) {
                    self.defalutView.hidden = YES;
                    for (HICEnrollReviewerModel *model in tempArr) {
                        if ([model.customerId isEqualToNumber:(_auditorId?_auditorId:@0)]) {
                            model.isSelected = YES;
                        }
                    }
                    [self.employeeListArr addObjectsFromArray:tempArr];
                    [self.tableView reloadData];
                    [self.tableView.mj_footer endRefreshing];
                }else{
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                    [self.tableView.mj_header endRefreshing];
                    if (self.pageIndex>0) {
                        self.pageIndex--;
                    }
                    
                }
            }else{
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                [self.tableView.mj_header endRefreshing];
                if (self.pageIndex>0) {
                    self.pageIndex--;
                }
            }
        }else{
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            [self.tableView.mj_header endRefreshing];
            if (self.pageIndex>0) {
                self.pageIndex--;
            }
            if (self.employeeListArr.count == 0) {
                self.defalutView.hidden = NO;
            }
        }
    } failure:^(NSError * _Nonnull error) {
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        if (self.pageIndex>0) {
            self.pageIndex--;
        }
    }];
    if (self.employeeListArr.count == 0) {
        // 显示缺省页面
        self.defalutView.hidden = NO;
    }
}
#pragma mark textfildDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self searchReviewer];
    [self.employeeListArr removeAllObjects];
    [self.tableView reloadData];
    return YES;
}
#pragma mark ----navidelegate
- (void)leftBtnClicked {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)search{
    [self.employeeListArr removeAllObjects];
     [self.tableView reloadData];
    [self searchReviewer];
}
#pragma mark ---HICEnrollReviewerDelegate
//- (void)selectReviewerWithModel:(HICEnrollReviewerModel *)model andSelect:(BOOL)select{
//    if (select) {
//        [HICCommonUtils createGradientLayerWithBtn:self.bottomBtn fromColor:[UIColor colorWithHexString:@"00E2D8" alpha:1.0f] toColor:[UIColor colorWithHexString:@"00C5E0" alpha:1.0f]];
//        self.bottomBtn.userInteractionEnabled = YES;
//    }else{
//        [HICCommonUtils createGradientLayerWithBtn:self.bottomBtn fromColor:[UIColor colorWithHexString:@"00E2D8" alpha:0.7f] toColor:[UIColor colorWithHexString:@"00C5E0" alpha:0.7f]];
//        self.bottomBtn.userInteractionEnabled = NO;
//    }
//}
#pragma mark ---tableviewDatasource&&tableviewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.employeeListArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HICEnrollReviewerCell *cell = (HICEnrollReviewerCell *)[tableView dequeueReusableCellWithIdentifier:reviewrCell];
    if (cell == nil) {
        cell = [[HICEnrollReviewerCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reviewrCell];
    }
    //    cell.delegete = self;
    HICEnrollReviewerModel *model = self.employeeListArr[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setModel:model andIndexPath:indexPath];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HICEnrollReviewerModel *model = self.employeeListArr[indexPath.row];
    for (int i = 0; i < self.employeeListArr.count; i++) {
        if (i == indexPath.row) {
            model.isSelected = YES;
        }else{
            model.isSelected = NO;
        }
    }
    
    //    if (self.delegete && [self.delegete respondsToSelector:@selector(selectReviewerWithModel:)]) {
    //        [self.delegete selectReviewerWithModel:model];
    //    }
 
    if (self.returnNameBlock) {
        self.returnNameBlock(model.name,model.customerId);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, HIC_ScreenWidth, 60)];
    headerView.backgroundColor = UIColor.whiteColor;
    UIView *searchView = [[UIView alloc]initWithFrame:CGRectMake(16, 12, HIC_ScreenWidth - 12 - 82, 36)];
    searchView.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
    [headerView addSubview:searchView];
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 9, 18, 18)];
    icon.image = [UIImage  imageNamed:@"ICON-搜索框-搜索"];
    [searchView addSubview: icon];
    searchView.layer.cornerRadius = 18;
    searchView.layer.masksToBounds = YES;
    self.textfild = [[UITextField alloc] initWithFrame:CGRectMake(34, 3, headerView.bounds.size.width-34, 32)];
    _textfild.font = FONT_REGULAR_15;
//    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:NSLocalizableString(@"enterEmployeeNameOrOAAccount", nil) attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#858585"],NSFontAttributeName:_textfild.font}];
    NSString *placeholder = [HICCommonUtils appBundleIden] == HICAppBundleIdenZhiYu ? NSLocalizableString(@"checkName", nil) : NSLocalizableString(@"enterEmployeeNameOrOAAccount", nil);
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:placeholder attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#858585"],NSFontAttributeName:_textfild.font}];

    _textfild.attributedPlaceholder = attrString;
    _textfild.delegate = self;
    [_textfild resignFirstResponder];
    _textfild.returnKeyType = UIReturnKeyDone;
    [searchView addSubview:_textfild];
    
    UIButton *searchBtn = [[UIButton alloc]initWithFrame:CGRectMake(HIC_ScreenWidth - 66, 20, 50, 21)];
    //    searchBtn.backgroundColor = UIColor.redColor;
    [searchBtn setTitle:NSLocalizableString(@"search", nil) forState:UIControlStateNormal];
    [searchBtn setTitleColor:[UIColor colorWithHexString:@"#00BED7"] forState:UIControlStateNormal];
    [headerView addSubview:searchBtn];
    [searchBtn addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (_type == 1) {
        return 60;
    }
    return 0;
}
#pragma mark ---lazyload
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, HIC_NavBarAndStatusBarHeight, HIC_ScreenWidth, HIC_ScreenHeight - HIC_NavBarAndStatusBarHeight - 71) style:UITableViewStylePlain];
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0;
        }
    }
    return _tableView;
}
- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, HIC_ScreenHeight - 71, HIC_ScreenWidth, 71)];
        _bottomView.backgroundColor = UIColor.whiteColor;
    }
    return _bottomView;
}
- (NSMutableArray *)employeeListArr{
    if (!_employeeListArr) {
        _employeeListArr = [NSMutableArray array];
    }
    return _employeeListArr;
}
-(HomeTaskCenterDefaultView *)defalutView {
    if (!_defalutView) {
        _defalutView = [[HomeTaskCenterDefaultView alloc] initWithFrame:CGRectMake(0,HIC_NavBarAndStatusBarHeight + 60, HIC_ScreenWidth, HIC_ScreenHeight-HIC_NavBarAndStatusBarHeight-60)];
        [self.view addSubview:_defalutView];
        _defalutView.titleStr = NSLocalizableString(@"temporarilyNoData", nil);
        _defalutView.hidden = YES;
    }
    return _defalutView;
}
@end
