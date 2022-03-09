//
//  HICRankingListVC.m
//  iTest
//
//  Created by Sir_Jing on 2020/3/11.
//  Copyright © 2020 Sir_Jing. All rights reserved.
//

#import "HICRankingListVC.h"

#import "HICRankingListView.h"
#import "RankingListShareView.h"

@interface HICRankingListVC ()<RankingListShareViewDelegate>

@property (nonatomic, strong) RankingListShareView *shareView;

@property (nonatomic, strong) NSMutableArray *rankListVCs;

@end

@implementation HICRankingListVC

#pragma mark - 生命周期

- (void)viewDidLoad {
    self.isCustomer = YES;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizableString(@"list", nil);
    self.view.backgroundColor = UIColor.whiteColor;
    _rankListVCs = [NSMutableArray array];
    self.isMenuEqualWidth = YES;

    [self createNavigationBarItem];
    [self setTitleMenu];

}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [self.navigationController setNavigationBarHidden:YES];
}

#pragma mark - 自定义视图
-(void)createNavigationBarItem {
    UIImage *image = [[UIImage imageNamed:@"返回"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStyleDone target:self action:@selector(clickLeftBarItem:)];
    self.navigationItem.leftBarButtonItem = leftItem;

    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizableString(@"baskInTheSun", nil) style:UIBarButtonItemStyleDone target:self action:@selector(clickRightBarItem:)];
    [rightItem setTintColor:[UIColor colorWithRed:0 green:190/255.0 blue:215/255.0 alpha:1]];
    self.navigationItem.rightBarButtonItem = rightItem;
}

-(void)setTitleMenu {
    NSArray *titles = @[NSLocalizableString(@"thisWeek", nil), NSLocalizableString(@"thisMonth", nil), NSLocalizableString(@"thisYear", nil)];
    for (NSInteger i = 0; i < titles.count; i++) {
        HICRankingListView *vc = [HICRankingListView new];
        vc.title = titles[i];
        vc.view.backgroundColor = RandColor; //随机色
        vc.rankType = _rankType;
        vc.rankIndex = i;
        [_rankListVCs addObject:vc];
        [self addChildViewController:vc];
    }

    // 设置
    self.isCustomer = YES;
    [self setUpDisplayStyle:^(UIColor *__autoreleasing *titleScrollViewBgColor, UIColor *__autoreleasing *norColor, UIColor *__autoreleasing *selColor, UIColor *__autoreleasing *proColor, UIFont *__autoreleasing *titleFont, BOOL *isShowProgressView, BOOL *isOpenStretch, BOOL *isOpenShade) {

        *selColor = [UIColor colorWithRed:3/255.0 green:179/255.0 blue:204/255.0 alpha:1];
        *isShowProgressView = YES;
        *titleFont = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    }];
}

#pragma mark - 视图处理事件
// 导航栏返回
-(void)clickLeftBarItem:(UIBarButtonItem *)item {
    [self.navigationController popViewControllerAnimated:YES];
}
// 导航栏搜索
-(void)clickRightBarItem:(UIBarButtonItem *)item {
    DDLogDebug(@"点击晒一晒 -----   ");
    if (self.selectIndex <= self.rankListVCs.count-1) {
        HICRankingListView *vc = [self.rankListVCs objectAtIndex:self.selectIndex];
        if (vc.dataArr.count == 0) {
            [HICToast showWithText:NSLocalizableString(@"noRankingInformationIsAvailable", nil)];
        }else {
            self.shareView.rankType = _rankType;
            self.shareView.rankIndex = self.selectIndex;
            [self.shareView createView];
            self.shareView.rankInfoModels = vc.dataArr;
            [self.shareView showShare];
        }
    }

}

#pragma mark - 图片分享的接口协议方法
-(void)clickShareView:(RankingListShareView *)view shareImage:(UIImage *)image {
    NSArray *activityItems = @[image];
    UIActivityViewController *activityVc = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    [self presentViewController:activityVc animated:YES completion:nil];
    activityVc.completionWithItemsHandler = ^(UIActivityType _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
        if (completed) {
            DDLogDebug(@"分享成功");
        }else{
            DDLogDebug(@"分享取消");
        }
    };
}

#pragma mark - 懒加载
-(RankingListShareView *)shareView {
    if (!_shareView) {
        _shareView = [[RankingListShareView alloc] initWithDefault];
        _shareView.delegate = self;
    }
    return _shareView;
}

@end
