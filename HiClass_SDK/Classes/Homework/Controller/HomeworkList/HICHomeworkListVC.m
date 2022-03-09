//
//  HICHomeworkListVC.m
//  HiClass
//
//  Created by Eddie Ma on 2020/3/11.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICHomeworkListVC.h"
#import "HICHomeworkListView.h"

#import "HICHomeWorkDetail.h"

static NSString *logName = @"[HIC][HLVC]";

@interface HICHomeworkListVC () <HICCustomNaviViewDelegate, HICHomeworkListViewDelegate>
@property (nonatomic, strong) HICCustomNaviView *navi;
@property (nonatomic, strong) HICHomeworkListView *listView;

@end

@implementation HICHomeworkListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated {
    if (!self.navigationController.isNavigationBarHidden) {
        self.navigationController.navigationBarHidden = YES;
    }
    [self initData];
    [self createUI];
}

- (void)initData {

}

- (void)createUI {
    [self createNavi];
    [self createHomeworkListView];
}

- (void)createNavi {
    self.navi = [[HICCustomNaviView alloc] initWithTitle:self.homeworkTitle rightBtnName:nil showBtnLine:YES];
    _navi.delegate = self;
    [self.view addSubview:_navi];
}

- (void)createHomeworkListView {
    self.listView = [[HICHomeworkListView alloc] initWithFrame:CGRectMake(0, HIC_NavBarAndStatusBarHeight, HIC_ScreenWidth, HIC_ScreenHeight - HIC_NavBarAndStatusBarHeight)];
    self.listView.trainId = self.trainId;
    self.listView.workId = self.workId;
    self.listView.delegate = self;
    [self.view addSubview:_listView];
    [self.listView requestData];
}

#pragma mark - - - HICCustomNaviViewDelegate  - - -
- (void)leftBtnClicked {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - ListDelegate
-(void)listView:(HICHomeworkListView *)view didCell:(UITableViewCell *)cell model:(HICHomeworkModel *)model indexPath:(NSIndexPath *)indexPath {

    if (indexPath.row != 0 && model.jobStatus != HICHomeworkNotStart) {
        // 跳转到作业详情页
        HICHomeWorkDetail *detail = [[HICHomeWorkDetail alloc] init];
        detail.jobId = model.jobId?model.jobId.integerValue:0;
        detail.trainId = [NSString stringWithFormat:@"%@", _trainId];
        detail.status = model.jobStatus;
        detail.workId = _workId?_workId.integerValue:0;
        detail.jobName = model.name;
        detail.endTime = model.endTime;
        if (model.jobStatus == HICHomeworkCompleted) {
            // 作业已完成的是否显示分数
            if ([model.scoreType isEqualToNumber:@1]) {
                detail.isShowScore = YES;
            }
        }
        [self.navigationController pushViewController:detail animated:YES];
    }
}

@end

