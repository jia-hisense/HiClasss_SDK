//
//  HICStudyVideoPlayExercisesListVC.m
//  iTest
//
//  Created by Sir_Jing on 2020/2/4.
//  Copyright © 2020 Sir_Jing. All rights reserved.
//

#import "HICStudyVideoPlayExercisesListVC.h"
#import "HICExercisesListItemCell.h"
#import "HICNetModel.h"
#import "HICExerciseModel.h"
#import "HICExamCenterDetailVC.h"
@interface HICStudyVideoPlayExercisesListVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableDictionary *postModel;
@property (nonatomic, strong) HICNetModel *netModel;
@property (nonatomic, strong) NSMutableArray *dataArr;
@end

@implementation HICStudyVideoPlayExercisesListVC
- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    [self initData];
    [self createTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
    [self createNavigationBar];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
}
- (void)initData {
    self.postModel = [NSMutableDictionary new];
    self.dataArr = [NSMutableArray new];
    [self.postModel setObject:_objectType forKey:@"objectType"];
    [self.postModel setObject:_objectId forKey:@"objectId"];
    [self.postModel setObject:@1 forKey:@"terminalType"];
    [HICAPI exercisesList:self.postModel success:^(NSDictionary * _Nonnull responseObject) {
        if (responseObject) {
            self.dataArr = responseObject[@"data"][@"exerciseList"];
        }
    }];
    
}
#pragma mark - 创建视图
// 1. 创建tableview
-(void)createTableView {
    
    CGFloat top = HIC_isIPhoneX? HIC_StatusBar_Height : 0.f;
    CGFloat bottom = 0.f;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, top, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height-top-bottom) style:UITableViewStylePlain];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerClass:HICExercisesListItemCell.class forCellReuseIdentifier:@"ExercisesCell"];
    self.tableView.tableFooterView = [UIView new];
    if (@available(iOS 15.0, *)) {
        self.tableView.sectionHeaderTopPadding = 0;
    }
    
    [self.view addSubview:self.tableView];
}

// 2. 创建顶部状态栏
-(void)createNavigationBar {
    
    UIImage *image = [[UIImage imageNamed:@"返回"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStyleDone target:self action:@selector(clickLeftBarItem:)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    self.title = NSLocalizableString(@"exercises", nil);
}

#pragma mark - 页面点击事件
-(void)clickLeftBarItem:(UIBarButtonItem *)item {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - TableView Datasource的协议
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
    //    return 6;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HICExercisesListItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ExercisesCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[HICExercisesListItemCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ExercisesCell"];
    }
    cell.exciseModel = [HICExerciseModel mj_objectWithKeyValues:self.dataArr[indexPath.row]];
    return cell;
}

#pragma mark - TableView Delegate的协议
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 56.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HICExamCenterDetailVC *vc = [HICExamCenterDetailVC new];
    HICExerciseModel *model = [HICExerciseModel mj_objectWithKeyValues:self.dataArr[indexPath.row]];
    vc.examId = [NSString stringWithFormat:@"%@",model.exerciseId];
    vc.courseId = [NSString stringWithFormat:@"%@",_objectId];
    vc.trainId = [NSString stringWithFormat:@"%@",_trainId];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
