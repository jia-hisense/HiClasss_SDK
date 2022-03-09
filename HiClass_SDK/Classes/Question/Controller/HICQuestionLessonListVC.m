//
//  HICQuestionLessonListVC.m
//  HiClass
//
//  Created by 聚好看 on 2021/11/26.
//  Copyright © 2021 hisense. All rights reserved.
//

#import "HICQuestionLessonListVC.h"
#import "HICQuestionCell.h"
#import "HICQuestionModel.h"
#import "HICTrainQuestionVC.h"
#import "HomeTaskCenterDefaultView.h"

#define kQuestionCellIden  @"HICQuestionCellIden"
@interface HICQuestionLessonListVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)NSArray *dataSource;
@property (nonatomic, strong)UITableView *table;
@property (nonatomic, assign)HICQuestionLessonListType type;
@property (nonatomic, strong)HomeTaskCenterDefaultView *defaultView;


@end

@implementation HICQuestionLessonListVC

- (instancetype)initWithType:(HICQuestionLessonListType)type {
    if (self = [super init]) {
        self.type = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getQuestionList];
    [self addUI];
}
- (void)updateWithData:(NSArray *)dataSource {
    if (!dataSource || dataSource.count == 0) {
        self.defaultView.hidden = NO;
//        self.table.hidden = YES;
        return;
    }
    self.defaultView.hidden = YES;
//    self.table.hidden = NO;
    self.dataSource = dataSource;
    [self.table reloadData];
}

#pragma mark -- 私有方法
- (void)addUI {
//    if (!_table) {
        [self.view addSubview:self.table];
//    }
//    if (!_defaultView) {
        [self.table addSubview:self.defaultView];
//    }
    __weak __typeof(self) weakSelf = self;
    self.table.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getQuestionList];
        weakSelf.getQuestionNumBlock();
    }];
}

- (void)getQuestionList {
    [HICAPI getQuestionnaireList:self.type success:^(NSDictionary * _Nonnull responseObject) {
        if (responseObject[@"data"][@"questionList"]) {
            NSArray *dataArr = [HICQuestionListModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"questionList"]];
            [self updateWithData:dataArr];
        }
        _defaultView.titleStr = NSLocalizableString(@"noCanParticipatingQuestionnaire", nil);
        _defaultView.imageName = @"暂无问卷";
        if (self.type == 2) {
            self.defaultView.titleStr = NSLocalizableString(@"noCanParticipatingQuestionnaire", nil);
        }
        if (self.type == 5) {
            self.defaultView.titleStr = NSLocalizableString(@"noCompletedQuestionnaireAtPresent", nil);
        }
        if (self.type == 6) {
            self.defaultView.titleStr = NSLocalizableString(@"noExpiredQuestionnairesAreAvailable", nil);
        }
        [self.table.mj_header endRefreshing];
    } failure:^(NSError * _Nonnull error) {
        [self updateWithData:nil];
        [self.table.mj_header endRefreshing];
    }];
}



- (void)makeAutoLayout {
    [self.table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.defaultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}


#pragma mark -- UITableViewDelegate & UITableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HICQuestionListModel *qmodel = _dataSource[indexPath.row];
    if (qmodel.state == HICQuestionExpired) {
        [HICToast showWithText:NSLocalizableString(@"questionnaireIsOverdue", nil)];
        return;
    }
    NSString * urlStr = [NSString stringWithFormat:@"%@/mweb/index.html#/questionnaire?questionActionId=%ld", APP_Web_DOMAIN, (long)qmodel.actionId.integerValue];
    PushViewControllerModel *model = [[PushViewControllerModel alloc] initWithPushType:13 urlStr:urlStr detailId:qmodel.actionId.integerValue studyResourceType:HICHtmlType pushType:0];
           [HICPushViewManager parentVC:[HICCommonUtils viewController:self.table] pushVCWithModel:model];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HICQuestionCell *cell = (HICQuestionCell *)[tableView dequeueReusableCellWithIdentifier:kQuestionCellIden forIndexPath:indexPath];
    cell.isAll = YES;
    cell.model = _dataSource[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    DDLogDebug(@"HICLiveLessonListVC:%lu", (unsigned long)self.dataSource.count);
    return self.dataSource.count;
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

#pragma mark -- 懒加载
- (UITableView *)table {
    if (!_table) {
        _table = [[UITableView alloc] initWithFrame:self.view.bounds];
        _table.delegate = self;
        _table.dataSource = self;
        _table.estimatedRowHeight = 110;
        _table.rowHeight = UITableViewAutomaticDimension;
        [_table registerClass:[HICQuestionCell class] forCellReuseIdentifier:kQuestionCellIden];
        _table.separatorStyle = UITableViewCellSeparatorStyleNone;
        _table.separatorColor = [UIColor clearColor];
        _table.backgroundColor = BACKGROUNG_COLOR;
        if (@available(iOS 15.0, *)) {
            _table.sectionHeaderTopPadding = 0;
        }
    }
    return _table;
}

- (HomeTaskCenterDefaultView *)defaultView {
    if (!_defaultView) {
        _defaultView = [[HomeTaskCenterDefaultView alloc] initWithFrame:self.view.bounds];
        _defaultView.titleStr = NSLocalizableString(@"noLiveNow", nil);
        _defaultView.imageName = @"暂无直播";
    }
    return _defaultView;
}

- (NSArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSArray array];
    }
    return _dataSource;
}

@end
