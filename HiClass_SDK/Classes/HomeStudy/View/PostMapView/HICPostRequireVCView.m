//
//  HICPostRequireVCView.m
//  iTest
//
//  Created by Sir_Jing on 2020/3/18.
//  Copyright © 2020 Sir_Jing. All rights reserved.
//

#import "HICPostRequireVCView.h"

#import "PostRequireDutyCell.h"
#import "PostRequireServingCell.h"
#import "PostRequistCreditCell.h"
#import "PostRequireCerCell.h"

#import "HomeTaskCenterDefaultView.h"

#import "HomeworkImagePreViewVC.h"

@interface HICPostRequireVCView ()<UITableViewDelegate, UITableViewDataSource, PostRequireBaseCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) BOOL isShowAllServing;
@property (nonatomic, assign) BOOL isShowAllReq;

@property (nonatomic, strong) HomeTaskCenterDefaultView *defaultView;
@property (nonatomic, strong) NSArray *cerDataArray; // 证书数据数组

@end

@implementation HICPostRequireVCView

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self.view addSubview:self.tableView];
    self.defaultView = [[HomeTaskCenterDefaultView alloc] initWithFrame:self.tableView.bounds];
    [self loadDataCer];
}

#pragma mark - TableDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger num = self.model?3:0;
    if (num != 0) {
        if (self.cerDataArray.count != 0) {
            num += 1;
        }
    }
    return num;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PostRequireBaseCell *cell;

    if (indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"DutyCell" forIndexPath:indexPath];
    }else if (indexPath.row == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"ServingCell" forIndexPath:indexPath];
    }else if (indexPath.row == 2){
        cell = [tableView dequeueReusableCellWithIdentifier:@"CreditCell" forIndexPath:indexPath];
    }else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"CerCell" forIndexPath:indexPath];
    }
    cell.delegate = self;
    cell.model = self.model;
    cell.cerModels = self.cerDataArray;

    return cell;
}

#pragma mark - TableDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 15;
    if (indexPath.row == 0) {
        CGFloat h = [PostRequireBaseCell getContentLabelHeightWith:self.model.duty];
        h -= 20;
        if (!self.isShowAllReq) {
            if (h>40) {
                h=40;
            }
        }
        height += (108+h);
    }else if (indexPath.row == 1) {
        CGFloat h = [PostRequireBaseCell getContentLabelHeightWith:self.model.demand];
        h -= 20;
        if (!self.isShowAllServing) {
            if (h>40) {
                h=40;
            }
        }
        height += (108+h);
    }else if (indexPath.row == 2){
        height += 285;
    }else {
        CGFloat h = 0;
        if (self.cerDataArray.count != 0) {
            h = (self.cerDataArray.count % 2 + self.cerDataArray.count / 2)*(111+16);
        }
        height += (h + 76);
    }
    return height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

//    [self.view addSubview:self.defaultView]; 测试数据需要修改
}

#pragma mark - CellDelegate
-(void)requireCell:(PostRequireBaseCell *)cell showMoreBut:(UIButton *)but isShow:(BOOL)isShow other:(id)data {

    if (data && [data isEqualToNumber:@1]) {
        self.isShowAllReq = isShow;
    }else {
        self.isShowAllServing = isShow;
    }
    [self.tableView reloadData];
}

-(void)requireCell:(PostRequireBaseCell *)cell clickBut:(UIButton *)but isShow:(BOOL)isShow andModel:(HICPostMapCerModel *)model other:(id)data {
    if (isShow) {
        // 不支持查看详情 -- 之后支持可以根据情况跳转
//        if (model.url) {
//            HomeworkImagePreViewVC *vc = [[HomeworkImagePreViewVC alloc] init];
//            vc.previewDownImages = @[model.url];
//            vc.modalPresentationStyle = UIModalPresentationFullScreen;
//            [self presentViewController:vc animated:YES completion:^{
// 1234
        
//            }];
//        }
        // 不支持跳转到详情页
//        PushViewControllerModel *pushModel = [[PushViewControllerModel alloc] initWithPushType:3 urlStr:nil detailId:model.employeeCertId studyResourceType:0 pushType:0];
//        [HICPushViewManager parentVC:self pushVCWithModel:pushModel];
    }
}

#pragma mark - 网络请求
-(void)loadData {
    [HICAPI postRequirement:self.postId success:^(NSDictionary * _Nonnull responseObject) {
        self.model = [HICPostMapDetailReqModel mj_objectWithKeyValues:responseObject];
        [self.tableView reloadData];
    } failure:^(NSError * _Nonnull error) {
        DDLogDebug(@"[HIC]-[MapMore] - 岗位地图详情数据请求失败");
    }];
}
// 证书请求
-(void)loadDataCer {
    [HICAPI loadDataCer:[NSNumber numberWithInteger:self.model.trainId] success:^(NSDictionary * _Nonnull responseObject) {
        self.cerDataArray = [HICPostMapCerModel getModelArrayWithRep:responseObject];
        if (self.cerDataArray.count > 0 && self.model) {
            [self.tableView reloadData];
        }
    } failure:^(NSError * _Nonnull error) {
        DDLogDebug(@"[HIC]-[MapMore] - 岗位地图证书数据请求失败");
    }];
}

#pragma mark - 懒加载
-(UITableView *)tableView {
    if (!_tableView) {
        UIApplication *manager = UIApplication.sharedApplication;
        CGFloat statusHeight = manager.statusBarFrame.size.height;
        CGFloat width = UIScreen.mainScreen.bounds.size.width;
        CGFloat height = UIScreen.mainScreen.bounds.size.height;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, width, height-(statusHeight+44+44)) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
        [_tableView registerClass:PostRequireDutyCell.class forCellReuseIdentifier:@"DutyCell"];
        [_tableView registerClass:PostRequireServingCell.class forCellReuseIdentifier:@"ServingCell"];
        [_tableView registerClass:PostRequistCreditCell.class forCellReuseIdentifier:@"CreditCell"];
        [_tableView registerClass:PostRequireCerCell.class forCellReuseIdentifier:@"CerCell"];
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0;
        }
    }
    return _tableView;
}

@end
