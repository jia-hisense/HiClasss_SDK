//
//  HICNotEnrollTrainArrangeVC.m
//  HiClass
//
//  Created by WorkOffice on 2020/6/5.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import "HICNotEnrollTrainArrangeVC.h"
#import "HICNotEnrollSingleCell.h"
#import "HICNotEnrollMultiCell.h"
#import "HICNotEnrollSingleCell.h"
#import "HICNotEnrollMultiCell.h"
#import "HICNotEnrollCourseArrangeModel.h"
static NSString *singleCellEnroll = @"singleCellEnroll";
static NSString *multiCellEnroll = @"multiCellEnroll";
@interface HICNotEnrollTrainArrangeVC ()<UITableViewDataSource,UITableViewDelegate,HICCustomNaviViewDelegate>
@property (nonatomic ,strong)UITableView *tableView;
@property (nonatomic ,strong)NSMutableArray *listArr;
@property (nonatomic ,strong)HICNetModel *netModel;
@property (nonatomic ,strong)UIView *backView;
@end

@implementation HICNotEnrollTrainArrangeVC
#pragma mark --lazyload
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 6, HIC_ScreenWidth, HIC_ScreenHeight - HIC_NavBarAndStatusBarHeight - HIC_BottomHeight - 6) style:UITableViewStylePlain];
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0;
        }
    }
    return _tableView;
}
-(UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc]initWithFrame:CGRectMake(0, HIC_NavBarAndStatusBarHeight , HIC_ScreenWidth, HIC_ScreenHeight - HIC_NavBarAndStatusBarHeight - HIC_BottomHeight)];
        _backView.backgroundColor = BACKGROUNG_COLOR;
    }
    return _backView;
}
- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    [self createNavi];
    [self configTableView];
}
- (void)configTableView{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = BACKGROUNG_COLOR;
    [self.view addSubview:self.backView];
    [self.backView addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self getListData];
}

- (void)getListData {
    [HICAPI curriculum:_trainId success:^(NSDictionary * _Nonnull responseObject) {
        self.listArr = [HICNotEnrollCourseArrangeModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
        [self.tableView reloadData];
    }];
}
- (void)createNavi {
    HICCustomNaviView *navi = [[HICCustomNaviView alloc] initWithTitle:NSLocalizableString(@"trainingArrangement", nil) rightBtnName:nil showBtnLine:NO];
    navi.delegate = self;
    [self.view addSubview:navi];
}
- (CGFloat)getContentHeight:(NSString *)str {
    UILabel *label = [[UILabel alloc] init];
    label.text = str;
    label.font = FONT_REGULAR_16;
    label.numberOfLines = 2;
    CGFloat labelHeight = [HICCommonUtils sizeOfString:str stringWidthBounding:HIC_ScreenWidth - 60 font:16 stringOnBtn:NO fontIsRegular:YES].height;
    label.frame = CGRectMake(0, 0, HIC_ScreenWidth - 60, labelHeight);
    [label sizeToFit];
    return label.frame.size.height;
}
#pragma mark ---naviDelegate
- (void)leftBtnClicked {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ---uitableviewDatasource&&delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HICNotEnrollCourseArrangeModel *model = self.listArr[indexPath.row];
    if (model.classStages.count == 1) {
        HICNotEnrollSingleCell *cell = (HICNotEnrollSingleCell *)[tableView dequeueReusableCellWithIdentifier:singleCellEnroll];
        if (!cell) {
            cell = [[HICNotEnrollSingleCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:singleCellEnroll];
        }
        cell.model = model;
        [cell setBorderStyleWithTableView:tableView indexPath:indexPath];
        return cell;
    }else{
        HICNotEnrollMultiCell *cell = (HICNotEnrollMultiCell *)[tableView dequeueReusableCellWithIdentifier:multiCellEnroll];
        if (!cell) {
            cell = [[HICNotEnrollMultiCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:multiCellEnroll];
        }
        cell.model = model;
         [cell setBorderStyleWithTableView:tableView indexPath:indexPath];
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    HICNotEnrollCourseArrangeModel *model = self.listArr[indexPath.row];
    if (model.classStages.count == 0) {
        return 0;
    }else if(model.classStages.count == 1){
        if (model.taskType == 1 || model.taskType == 2) {//线上课 |知识
            return 58 + [self getContentHeight:[NSString stringWithFormat:@"%@ %@",NSLocalizableString(@"onlineCourses", nil),model.resClassName]] + 12;
        }else {
            return 102.5 + 12 + [self getContentHeight:[NSString stringWithFormat:@"%@ %@",NSLocalizableString(@"offlinePrograms", nil),model.resClassName]];
        }
    }else{
        return 57.5 + [self getContentHeight:[NSString stringWithFormat:@"%@ %@",NSLocalizableString(@"offlinePrograms", nil),model.resClassName]] + 44 + model.classStages.count *52;
    }
}
@end
