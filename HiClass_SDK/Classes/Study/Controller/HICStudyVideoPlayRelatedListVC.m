//
//  HICStudyVideoPlayRelatedListVC.m
//  iTest
//
//  Created by Sir_Jing on 2020/2/5.
//  Copyright © 2020 Sir_Jing. All rights reserved.
//

#import "HICStudyVideoPlayRelatedListVC.h"
#import "HICRelatedListItemCell.h"
#import "HICCourseModel.h"
#import "HICContributeKnowledgeCell.h"
#import "HICLessonsVC.h"
#import "HICKnowledgeDetailVC.h"
@interface HICStudyVideoPlayRelatedListVC ()<UITableViewDelegate, UITableViewDataSource>


@property (nonatomic, strong) NSMutableDictionary *postModel;
@property (nonatomic, strong) HICNetModel *netModel;
@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation HICStudyVideoPlayRelatedListVC

- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.whiteColor;
    [self initData];
    [self createTableView];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:NO];
    [self createNavigationBar];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [self.navigationController setNavigationBarHidden:YES];
}

#pragma mark - 创建视图
// 1. 创建tableview
-(void)createTableView {

    CGFloat top = HIC_isIPhoneX? HIC_StatusBar_Height : 0.f;
    
    CGFloat bottom = 0.f;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, top, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height-top-bottom) style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerClass:HICRelatedListItemCell.class forCellReuseIdentifier:@"RelatedCell"];
    self.tableView.tableFooterView = [UIView new];
    if (@available(iOS 15.0, *)) {
        self.tableView.sectionHeaderTopPadding = 0;
    }

    [self.view addSubview:self.tableView];
}

// 2. 创建顶部状态栏
- (void)createNavigationBar {
    UIImage *image = [[UIImage imageNamed:@"返回"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStyleDone target:self action:@selector(clickLeftBarItem:)];
    self.navigationItem.leftBarButtonItem = leftItem;

    self.title = NSLocalizableString(@"moreKnowledgeRecommendation", nil);
}
- (void)initData{
    self.postModel = [NSMutableDictionary new];
    self.dataArr = [NSMutableArray new];
    [self.postModel setObject:_objectType ? _objectType : @-1 forKey:@"objectType"];
    [self.postModel setObject:_objectId ? _objectId : @-1 forKey:@"objectId"];
    [self.postModel setObject:@1 forKey:@"terminalType"];
    [HICAPI courseRelatedRecommendation:self.postModel success:^(NSDictionary * _Nonnull responseObject) {
        if (responseObject) {
            self.dataArr = responseObject[@"data"][@"recommendList"];
            [self.tableView reloadData];
        }
    }];
}
#pragma mark - 页面点击事件
-(void)clickLeftBarItem:(UIBarButtonItem *)item {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - TableView Datasource的协议
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HICContributeKnowledgeCell *cell = (HICContributeKnowledgeCell *)[tableView dequeueReusableCellWithIdentifier:@"RelatedCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[HICContributeKnowledgeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RelatedCell"];
    }
    cell.courseModel = [HICCourseModel mj_objectWithKeyValues:self.dataArr[indexPath.row][@"courseKLDInfo"]];
    return cell;
}
#pragma mark - TableView Delegate的协议
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 95.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HICCourseModel *model = [HICCourseModel mj_objectWithKeyValues:self.dataArr[indexPath.row][@"courseKLDInfo"]];
    if (model.courseKLDType == 6) {
        HICLessonsVC *vc = [HICLessonsVC new];
        vc.objectID = model.courseKLDId;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        HICKnowledgeDetailVC *vc = [HICKnowledgeDetailVC new];
        vc.objectId = model.courseKLDId;
        vc.kType = model.resourceType;
        vc.partnerCode = model.partnerCode;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
@end
