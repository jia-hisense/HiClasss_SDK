//
//  HICHomePostMapVC.m
//  iTest
//
//  Created by Sir_Jing on 2020/3/17.
//  Copyright © 2020 Sir_Jing. All rights reserved.
//

#import "HICHomePostMapVC.h"

#import "HICPostMapVC.h"
#import "HomeTaskCenterDefaultView.h"

#import "HICPostMapLineModel.h"

@interface HICHomePostMapVC ()

@property (nonatomic, strong) NSArray<HICPostMapLineModel *> *mapLines;

@property (nonatomic, strong) HomeTaskCenterDefaultView *defaultView;

@end

@implementation HICHomePostMapVC

- (void)viewDidLoad {
    self.isAgainView = YES;
    [self.navigationController setNavigationBarHidden:YES];
    self.isAddBackBut = NO;
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.backgroundColor = [UIColor colorWithRed:3/255.0 green:198/255.0 blue:223/255.0 alpha:1/1.0];
    
//    [self createBackBut];
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.mapLines.count == 0) {
        [self loadDataSever];
    }else {
        // 当前已经存在线路时需要刷新显示当前进度
        [self refreshLoadDataSever];
    }
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (@available(iOS 13.0, *)) {
        UIApplication.sharedApplication.statusBarStyle = UIStatusBarStyleDarkContent;
    } else {
        // Fallback on earlier versions
        UIApplication.sharedApplication.statusBarStyle = UIStatusBarStyleDefault;
    }
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
#pragma mark - 重新显示当前进度
-(void)showCurrentProgressView {
    for (HICPostMapVC *vc in self.childViewControllers) {
        vc.isShowCurrentProgress = YES;
    }
}
-(void)changeView {
    [super changeView];
    [self showCurrentProgressView];
}
#pragma mark - 创建View
- (void)setUpAllChildViewController {

    if (self.mapLines.count == 0) {
        [self.view addSubview:self.defaultView];
        return;
    }
    [self.defaultView removeFromSuperview];
    for (NSInteger i = 0; i < self.mapLines.count; i++) {
        HICPostMapLineModel *model = [self.mapLines objectAtIndex:i];
        HICPostMapVC *vc = [HICPostMapVC new];
        vc.title = model.wayName;
        [self addChildViewController:vc];
        vc.model = model;
    }

    // 设置
    [self setUpDisplayStyle:^(UIColor *__autoreleasing *titleScrollViewBgColor, UIColor *__autoreleasing *norColor, UIColor *__autoreleasing *selColor, UIColor *__autoreleasing *proColor, UIFont *__autoreleasing *titleFont, BOOL *isShowProgressView, BOOL *isOpenStretch, BOOL *isOpenShade) {

        *norColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:.7];
        *selColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1];

        *titleFont = [UIFont fontWithName:@"PingFangSC-Medium" size:16];

    }];

    [self setUpTitleScale:^(CGFloat *titleScale) { //titleScale范围在0到1之间  <0 或者 > 1 则默认不缩放 默认设置titleScale就开启缩放，不设置则关闭
        *titleScale = 0.05;
    }];


}

-(void)createBackBut {
    UIApplication *manager = UIApplication.sharedApplication;
    UIButton *backBut = [[UIButton alloc] initWithFrame:CGRectMake(0, manager.statusBarFrame.size.height, 38, 44)];
    [backBut setImage:[UIImage imageNamed:@"头部-返回-白色"] forState:UIControlStateNormal];
    backBut.imageView.frame = CGRectMake(16, 13, 12, 22);
    [self.view addSubview:backBut];

    [backBut addTarget:self action:@selector(clickBackBut:) forControlEvents:UIControlEventTouchUpInside];
}

// 刷新页面内容数据
-(void)refreshViewDataWith:(NSArray *)datas {
    // 1.判断当前的datas是否满足所有当前页面
    if (datas.count != self.childViewControllers.count && datas.count != 0) {
        // 数据与原有的数据不对等
        [self clearnTitleViewAndContentView]; // 清空原来的所有页面显示数据，重新加载
        self.mapLines = datas;
        [self setUpAllChildViewController];
        [self createTitleViewAgain];
    }else if (datas.count == self.childViewControllers.count) {
        // 数据量级相同，需要判断一下是否数据内容相同即包含的数据是否是相同的
        if ([self isRefreshData:datas equalToData:self.mapLines]) {
            // 刷新页面就可以了
            for (HICPostMapVC *vc in self.childViewControllers) {
                HICPostMapLineModel *model = [self getEqualVCModel:vc.model withData:datas];
                vc.refreshModel = model;
            }
        }else {
            [self clearnTitleViewAndContentView]; // 清空原来的所有页面显示数据，重新加载
            self.mapLines = datas;
            [self setUpAllChildViewController];
            [self createTitleViewAgain];
        }
    }
}
// 获取相同路线下的数据信息模型
-(HICPostMapLineModel *)getEqualVCModel:(HICPostMapLineModel *)vcModel withData:(NSArray *)datas {
    for (HICPostMapLineModel *model in datas) {
        if (model.wayId == vcModel.wayId) {
            return model; // 找到同路线的返回信息
        }
    }
    return nil;
}
// 判断两个数据是否相同
-(BOOL)isRefreshData:(NSArray *)refreshData equalToData:(NSArray *)data {

    if (refreshData.count == 0 || data.count == 0) {
        return NO; // 两组数据中有一组为空的情况下返回
    }
    if (refreshData.count != data.count) {
        return NO; // 数据量不对等也直接返回
    }
    if (refreshData.count == data.count) {
        BOOL isequal = YES;
        for (HICPostMapLineModel *refreshModel in refreshData) {
            if (![self isRefreshModel:refreshModel incloudData:data]) {
                isequal = NO;
                break;// 结束循环
            }
        }
        return isequal;
    }

    return NO;
}
-(BOOL)isRefreshModel:(HICPostMapLineModel *)model incloudData:(NSArray *)data {

    for (HICPostMapLineModel *dataModel in data) {
        if (dataModel.wayId == model.wayId) {
            return YES; // 找到一个相同的数据
        }
    }

    return NO;
}

#pragma mark - 数据请求
// 请求初始数据
-(void)loadDataSever {
    [HICAPI postMapRoute:^(NSDictionary * _Nonnull responseObject) {
        self.mapLines = [HICPostMapLineModel getMapLineDataWith:responseObject];
        [self setUpAllChildViewController];
        [self createTitleViewAgain];
        [RoleManager hiddenWindowLoadingView];
    } failure:^(NSError * _Nonnull error) {
        DDLogDebug(@"[HIC]-[POST_MAP] :路线图失败%@", error.userInfo);
        [RoleManager hiddenWindowLoadingView];
        [RoleManager showErrorViewWith:self.view blcok:^(NSInteger type) {
            [self loadDataSever];
        }];
    }];
}
// 刷新数据 -- 由于刷新的操作不需要进行额外的错误显示
-(void)refreshLoadDataSever {
    [HICAPI postMapRoute:^(NSDictionary * _Nonnull responseObject) {
        [RoleManager hiddenWindowLoadingView];
        NSArray *data = [HICPostMapLineModel getMapLineDataWith:responseObject];
        [self refreshViewDataWith:data]; // 去刷新数据
    } failure:^(NSError * _Nonnull error) {
        DDLogDebug(@"[HIC]-[POST_MAP] :路线图失败%@", error.userInfo);
        [RoleManager hiddenWindowLoadingView];
        [self showCurrentProgressView]; // 显示当前进度
    }];
}
#pragma mark - 页面事件处理
-(void)clickBackBut:(UIButton *)btn {

    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 懒加载
-(HomeTaskCenterDefaultView *)defaultView {
    if (!_defaultView) {
        _defaultView = [[HomeTaskCenterDefaultView alloc] initWithFrame:self.view.frame];
        _defaultView.titleStr = NSLocalizableString(@"noMapDataAvailableYet", nil);
        _defaultView.imageName = @"icon_map_no_data";
    }
    return _defaultView;
}

@end
