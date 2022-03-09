//
//  HICEnrollExpiredView.m
//  HiClass
//
//  Created by WorkOffice on 2020/6/4.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import "HICEnrollExpiredView.h"
#import "HICEnrollListModel.h"
#import "HICEnrollListCell.h"
#import "HICEnrollDetailVC.h"
#import "HICOfflineTrainInfoVC.h"
static NSString *enrollExpiredID = @"enrollExpiredID";
@interface HICEnrollExpiredView ()<UITableViewDelegate,UITableViewDataSource>

@end
@implementation HICEnrollExpiredView

- (instancetype)init {
    if (self = [super init]) {
        [self createUI];
    }
    return self;
}
- (void)createUI{
    self.frame = CGRectMake(HIC_ScreenWidth *2, 0, HIC_ScreenWidth, HIC_ScreenHeight - HIC_NavBarAndStatusBarHeight - 44 -6);
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.separatorColor = [UIColor clearColor];
    self.backgroundColor = BACKGROUNG_COLOR;
    [self configTableView];
}
- (void)configTableView{
    self.delegate = self;
    self.dataSource = self;
    self.estimatedRowHeight = 160;
    self.rowHeight = UITableViewAutomaticDimension;
    [self registerClass:[HICEnrollListCell class] forCellReuseIdentifier:enrollExpiredID];
    if (@available(iOS 15.0, *)) {
        self.sectionHeaderTopPadding = 0;
    }
}
-(void)setDataArr:(NSMutableArray *)dataArr{
    _dataArr = dataArr;
    [self reloadData];
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
#pragma mark tableviewDelegate&&dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HICEnrollListCell *cell = (HICEnrollListCell *)[tableView dequeueReusableCellWithIdentifier:enrollExpiredID];
    if (cell == nil) {
        cell = [[HICEnrollListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:enrollExpiredID];
    }
    cell.model = _dataArr[indexPath.row];
    [cell setBorderStyleWithTableView:tableView indexPath:indexPath];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 124.5 + 12;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HICEnrollListModel *model = _dataArr[indexPath.row];
    if (![model.trainId isEqual:@0]) {
        HICOfflineTrainInfoVC *vc = HICOfflineTrainInfoVC.new;
        vc.trainId = model.trainId.integerValue;
        vc.registerActionId = model.enrollId;
        vc.isRegisterJump = 1;
        [[HICCommonUtils viewController:self].navigationController pushViewController:vc animated:YES];
    }else{
        HICEnrollDetailVC *detailVC = HICEnrollDetailVC.new;
        detailVC.registerID = model.enrollId;
        detailVC.trainId = model.trainId;
        [[HICCommonUtils viewController:self].navigationController pushViewController:detailVC animated:YES];
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 6;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, HIC_ScreenWidth, 6)];
    line.backgroundColor = BACKGROUNG_COLOR;
    return line;
}
-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    view.backgroundColor = [UIColor clearColor];
}

@end
