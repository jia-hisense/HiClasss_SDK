//
//  PostMapMoreView.m
//  iTest
//
//  Created by Sir_Jing on 2020/3/17.
//  Copyright © 2020 Sir_Jing. All rights reserved.
//

#import "PostMapMoreView.h"

#import "DCPagerController.h"
#import "PostMapMoreDetailVCView.h"

#import "HICPostMapMoreModel.h"

@interface PostMapMoreView ()

@property (nonatomic, strong) DCPagerController *pageController;

@property (nonatomic, strong) UIView *backView;

@property (nonatomic, strong) NSArray *dataSource; // 得到数据列表

@end

@implementation PostMapMoreView

-(instancetype)initWithFrame:(CGRect)frame andParentController:(nonnull UIViewController *)controller {

    if (self = [super initWithFrame:CGRectMake(0, -(HIC_StatusBar_Height+44), UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height)]) {

        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - 477-49-HIC_BottomHeight, self.bounds.size.width, 477)];
        self.backView = backView;
        DCPagerController *vc = [[DCPagerController alloc] init];
        vc.isAlertView = YES;
        vc.isAgainView = YES;
        vc.view.frame = backView.bounds;
        vc.view.backgroundColor = UIColor.clearColor;

        [backView addSubview:vc.view];
        [self addSubview:backView];
        [controller addChildViewController:vc];
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        self.pageController = vc;
        [self createTitleView];
    }
    return self;
}
// 创建页面
-(void)createTitleView {

    CGFloat screenWidth = self.bounds.size.width;
    CGFloat titleViewHeight = 44.f;

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, titleViewHeight)];
    view.backgroundColor = UIColor.whiteColor;
    view.layer.masksToBounds = YES;

    CGFloat radius = 10; // 圆角大小
    UIRectCorner corner = UIRectCornerTopLeft|UIRectCornerTopRight; // 圆角位置，左上右上
    UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:corner cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = view.bounds;
    maskLayer.path = path.CGPath;
    view.layer.mask = maskLayer;

    UIButton *but = [[UIButton alloc] initWithFrame:CGRectMake(screenWidth-15-20, 15, 20, 20)];
    [but setImage:[UIImage imageNamed:@"岗位弹窗-关闭"] forState:UIControlStateNormal];
    [but addTarget:self action:@selector(clickCloseBut:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:but];

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15+20+15, 16, screenWidth-100, 24)];
    titleLabel.text = NSLocalizableString(@"moreJobs", nil);
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:17];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor blackColor];
    [view addSubview:titleLabel];

    [self.pageController.view addSubview:view];

    UIButton *closeBut = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height-500)];
    [self addSubview:closeBut];
    [closeBut addTarget:self action:@selector(clickCloseBut:) forControlEvents:UIControlEventTouchUpInside];
}
// 设置
-(void)setMenuView {
    for (NSInteger i =0; i < self.dataSource.count; i++) {
        HICPostMapMoreModel *model = self.dataSource[i];
        PostMapMoreDetailVCView *con = [[PostMapMoreDetailVCView alloc] init];
        [self.pageController addChildViewController:con];
        con.view.backgroundColor = UIColor.whiteColor;
        con.title = model.groupName;
        con.model = model;
        con.wayId = self.wayId;
    }
    if (self.dataSource.count != 0) {
        // 设置
        [self.pageController setUpDisplayStyle:^(UIColor *__autoreleasing *titleScrollViewBgColor, UIColor *__autoreleasing *norColor, UIColor *__autoreleasing *selColor, UIColor *__autoreleasing *proColor, UIFont *__autoreleasing *titleFont, BOOL *isShowProgressView, BOOL *isOpenStretch, BOOL *isOpenShade) {

            *titleScrollViewBgColor = UIColor.whiteColor;
            *selColor = [UIColor colorWithRed:3/255.0 green:179/255.0 blue:204/255.0 alpha:1];
            *isShowProgressView = YES;
            *titleFont = [UIFont fontWithName:@"PingFangSC-Medium" size:16];

        }];
        // 设置指示条
        [self.pageController setUpProgressAttribute:^(CGFloat *progressLength, CGFloat *progressHeight) {
            *progressLength = 30.f;
            *progressHeight = 2.f;
        }];
        [self.pageController createTitleViewAgain];
    }
}
#pragma mark - 关闭按钮的点击事件
-(void)clickCloseBut:(UIButton *)btn {

    [self hiddenAnimation];
}
#pragma mark - 显示隐藏动画
-(void)showAnimationWithController:(UIViewController *)vc {

    [vc.view addSubview:self];
    self.backView.center = CGPointMake(self.bounds.size.width/2.0, self.bounds.size.height+(477+HIC_BottomHeight+49)/2.0);
    [UIView animateWithDuration:0.7 animations:^{
        self.backView.center = CGPointMake(self.bounds.size.width/2.0, self.bounds.size.height - (477+HIC_BottomHeight+49) + (477)/2.0);
    }];
}

-(void)hiddenAnimation {
    [UIView animateWithDuration:0.4 animations:^{
        self.backView.center = CGPointMake(self.bounds.size.width/2.0, self.bounds.size.height+(477+HIC_BottomHeight+49)/2.0);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - 页面逻辑处理
-(void)setNodeId:(NSInteger)nodeId {
    _nodeId = nodeId;
    [self loadData];
}
// 网络数据请求
-(void)loadData {
    [HICAPI morePost:[NSNumber numberWithInteger:self.nodeId] success:^(NSDictionary * _Nonnull responseObject) {
        self.dataSource = [HICPostMapMoreModel getMapMoreDataWith:responseObject];
        [self setMenuView];
    }];
}

@end
