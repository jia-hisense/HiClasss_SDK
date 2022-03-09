//
//  PostMapMoreDetailVCView.m
//  iTest
//
//  Created by Sir_Jing on 2020/3/17.
//  Copyright © 2020 Sir_Jing. All rights reserved.
//

#import "PostMapMoreDetailVCView.h"

#import "PostMapMoreDetailCell.h"

#import "HICHomePostDetailVC.h"

@interface PostMapMoreDetailVCView ()<UITableViewDataSource, UITableViewDelegate, PostMapMoreDetailCellDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation PostMapMoreDetailVCView

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, 477-88) style:UITableViewStylePlain];
    [self.tableView registerClass:PostMapMoreDetailCell.class forCellReuseIdentifier:@"cell"];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1];
    self.tableView.tableFooterView = [UIView new];
    [self.tableView setSeparatorColor:[UIColor colorWithHexString:@"#E6E6E6"]];
    if (@available(iOS 15.0, *)) {
        self.tableView.sectionHeaderTopPadding = 0;
    }
    [self.view addSubview:self.tableView];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark - TableDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.model.postList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PostMapMoreDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];

    cell.delegate = self;
    cell.infoModel = self.model.postList[indexPath.row];

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 52.f;
}

#pragma mark - cellDelegate
-(void)moreDetailCell:(PostMapMoreDetailCell *)cell didClickBut:(UIButton *)but dataSource:(id)data other:(id)other {

    // 点击当前的cell
    if ([data isKindOfClass:MapMoreInfoModel.class]) {
        MapMoreInfoModel *infoModel = (MapMoreInfoModel *)data;
        HICHomePostDetailVC *vc = HICHomePostDetailVC.new;
        vc.trainPostId = infoModel.trainPostId;
        vc.postLineId = infoModel.postId;
        vc.wayId = self.wayId.integerValue;
    //TODO:是否需要添加参数
        vc.titleName = infoModel.postName;
        [self.parentViewController.parentViewController.navigationController pushViewController:vc animated:YES];
    }

}

@end
