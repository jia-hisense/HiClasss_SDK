//
//  HICScoreDetailsViewController.m
//  HiClass
//
//  Created by 聚好看 on 2021/11/11.
//  Copyright © 2021 hisense. All rights reserved.
//

#import "HICScoreDetailsViewController.h"
#import "HICScoreDetailTableViewCell.h"
#import "HICCustomNaviView.h"
#import "IntegralSubsidiaryModel.h"
#import "HomeTaskCenterDefaultView.h"
@interface HICScoreDetailsViewController ()<UITableViewDelegate,UITableViewDataSource,HICCustomNaviViewDelegate>
@property (nonatomic, strong)HICCustomNaviView *navi;
@property(nonatomic, strong) UITableView *scoreDetailTableView;
@property (nonatomic, assign) NSInteger pageIndex;
@property(nonatomic, strong) NSMutableArray *dataArray;
/// 缺省页面
@property (nonatomic, strong) HomeTaskCenterDefaultView *defaultView;
@end

@implementation HICScoreDetailsViewController

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
    [self loadDataList];
    self.view.backgroundColor = BACKGROUNG_COLOR;
}
- (void)createNavi {
    self.navi = [[HICCustomNaviView alloc] initWithTitle:NSLocalizableString(@"scoreDetail", nil) rightBtnName:nil showBtnLine:YES];
    _navi.delegate = self;
    [self.view addSubview:_navi];
}
#pragma mark - 网络数据请求
-(void)loadDataList {
    
    [HICAPI IntegralSubsidiaryList:_pageIndex success:^(NSDictionary * _Nonnull responseObject) {
        [IntegralSubsidiaryModel mj_setupObjectClassInArray:^NSDictionary *{
            return @{
                @"list":[IntegralSubsidiaryListModel class]
            };
        }];
        IntegralSubsidiaryModel *model = [IntegralSubsidiaryModel mj_objectWithKeyValues:responseObject[@"data"]];
        
        [self.dataArray addObjectsFromArray:model.list];
        [self.scoreDetailTableView reloadData];
        if (self.dataArray.count == 0) {
            self.defaultView.hidden = NO;
        }else{
            self.defaultView.hidden = YES;
        }
        if (model.list.count == 0) {
            [self.scoreDetailTableView.mj_footer endRefreshingWithNoMoreData];
            if (self.pageIndex>0) {
                self.pageIndex--;
            }
        }else {
            [self.scoreDetailTableView.mj_footer endRefreshing];
        }
        [self.scoreDetailTableView.mj_header endRefreshing];
    } failure:^(NSError * _Nonnull error) {
        if (self.pageIndex>0) {
            self.pageIndex--;
        }
        [self.scoreDetailTableView.mj_footer endRefreshing];
        [self.scoreDetailTableView.mj_header endRefreshing];
    }];
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
    _dataArray = @[].mutableCopy;
    _pageIndex = 0;
    self.scoreDetailTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, HIC_NavBarAndStatusBarHeight, HIC_ScreenWidth, HIC_ScreenHeight - HIC_NavBarAndStatusBarHeight) style:UITableViewStylePlain];
    self.scoreDetailTableView.delegate = self;
    self.scoreDetailTableView.dataSource = self;
    //设置预估行高
    self.scoreDetailTableView.estimatedRowHeight = 100.0f;
    self.scoreDetailTableView.rowHeight = UITableViewAutomaticDimension;
    self.scoreDetailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.scoreDetailTableView];
    [self.scoreDetailTableView addSubview:self.defaultView];
    if (@available(iOS 15.0, *)) {
        self.scoreDetailTableView.sectionHeaderTopPadding = 0;
    }
    
    // 增加刷新机制
    __weak typeof(self) weakSelf = self;
    self.scoreDetailTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf.dataArray removeAllObjects];
        [weakSelf.scoreDetailTableView reloadData];
        weakSelf.pageIndex = 0;
        [weakSelf loadDataList];
    }];

    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        // 加载更多数据
        weakSelf.pageIndex++;
        [weakSelf loadDataList];
    }];
    self.scoreDetailTableView.mj_footer = footer;
    self.scoreDetailTableView.mj_footer.ignoredScrollViewContentInsetBottom = HIC_isIPhoneX ? 34 : 0;
}
#pragma mark tableviewDelegate&&dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HICScoreDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HICScoreDetailTableViewCell"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"HICScoreDetailTableViewCell" owner:self options:nil].firstObject;
    }
    cell.cellModel = self.dataArray[indexPath.row];
    
    return cell;
}

-(HomeTaskCenterDefaultView *)defaultView {
    if (!_defaultView) {
        _defaultView = [[HomeTaskCenterDefaultView alloc] initWithFrame:CGRectMake(0, 0, HIC_ScreenWidth, HIC_ScreenHeight-HIC_NavBarAndStatusBarHeight)];
        _defaultView.titleStr = NSLocalizableString(@"temporarilyNoData", nil);
    }
    return _defaultView;
}

@end
