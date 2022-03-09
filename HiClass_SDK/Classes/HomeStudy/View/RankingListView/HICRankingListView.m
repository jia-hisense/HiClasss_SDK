//
//  HICRankingListView.m
//  iTest
//
//  Created by Sir_Jing on 2020/3/12.
//  Copyright © 2020 Sir_Jing. All rights reserved.
//

#import "HICRankingListView.h"
#import "RankingListHeaderView.h"
#import "HICMyRankInfoModel.h"
#import "RankingListItemCell.h"
#import "HICNetModel.h"
#import "HomeTaskCenterDefaultView.h"

@interface HICRankingListView ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) HICNetModel *netModel;

@property (nonatomic, strong) HomeTaskCenterDefaultView *defaultView;

@end

@implementation HICRankingListView

#pragma mark - 生命周期
-(NSArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSArray array];
    }
    return _dataArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.tableView registerClass:RankingListItemCell.class forCellReuseIdentifier:@"cell"];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self initData];
    
}
- (void)initData{
    self.defaultView.hidden = YES;
    NSMutableDictionary *postModel = [NSMutableDictionary new];
    [postModel setObject:[NSNumber numberWithInteger:_rankIndex] forKey:@"countTime"];
    [postModel setObject:[NSNumber numberWithInteger:_rankType] forKey:@"countType"];
    [HICAPI getRankList:postModel success:^(NSDictionary * _Nonnull responseObject) {
        self.dataArr = responseObject[@"data"];
        if (self.dataArr.count > 0) {
            RankingListHeaderView *headerView = [[RankingListHeaderView alloc] initWithModel:[HICMyRankInfoModel mj_objectWithKeyValues:self.dataArr[0]]];
            self.tableView.tableHeaderView = headerView;
            [self.tableView reloadData];
        }
        if (self.dataArr.count == 0) {
            self.defaultView.hidden = NO;
        }
    } failure:^(NSError * _Nonnull error) {
        self.defaultView.hidden = NO;
    }];
}
#pragma mark - TableDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [HICCommonUtils isValidObject:self.dataArr] && self.dataArr.count > 1 ? _dataArr.count - 1 : 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RankingListItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.cellIndexPath = indexPath;
    cell.model = [HICMyRankInfoModel mj_objectWithKeyValues:_dataArr[indexPath.row + 1]];
    return cell;
}

#pragma mark - TableDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 82;
}

#pragma mark - 懒加载
-(UITableView *)tableView {
    if (!_tableView) {
        CGFloat screenWidth = UIScreen.mainScreen.bounds.size.width;
        CGFloat screenHeight = UIScreen.mainScreen.bounds.size.height;
        UIApplication *manager = UIApplication.sharedApplication;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight-manager.statusBarFrame.size.height-44-44) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [self.view addSubview:_tableView];
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0;
        }
    }
    return _tableView;
}

-(HomeTaskCenterDefaultView *)defaultView {
    if (!_defaultView) {
        _defaultView = [[HomeTaskCenterDefaultView alloc] initWithFrame:self.view.bounds];
        _defaultView.titleStr = NSLocalizableString(@"noList", nil);
        [self.view addSubview:_defaultView];
        _defaultView.hidden = YES;
    }
    return _defaultView;
}

@end
