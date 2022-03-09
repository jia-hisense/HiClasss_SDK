//
//  HICPostMapVC.m
//  iTest
//
//  Created by Sir_Jing on 2020/3/16.
//  Copyright © 2020 Sir_Jing. All rights reserved.
//

#import "HICPostMapVC.h"

#import "PostMapLineView.h"
#import "PostMapMoreView.h"

#import "HICHomePostDetailVC.h"

@interface HICPostMapVC ()<PostMapLineViewDelegate>

@property (nonatomic, strong) PostMapLineView *lineView;
@property (nonatomic, strong) PostMapMoreView *moreView;

@end

@implementation HICPostMapVC

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.


    [self.navigationController setNavigationBarHidden:YES];

    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, HIC_ScreenWidth, HIC_ScreenHeight - (HIC_StatusBar_Height+44+49)-HIC_BottomHeight)];
    PostMapLineView *view = [[PostMapLineView alloc] initWithFrame:CGRectMake(0, 0, HIC_ScreenWidth, HIC_ScreenWidth/375.0*740)];
    view.layer.backgroundColor = UIColor.cyanColor.CGColor;
    view.model = self.model;
    view.delegate = self;
    [scrollView addSubview:view];
    [self.view addSubview:scrollView]; // 背景。
    [scrollView setContentSize:CGSizeMake(HIC_ScreenWidth, HIC_ScreenWidth/375.0*740)];
    _lineView = view;
}
#pragma mark - 路线视图的协议方法
-(void)lineView:(PostMapLineView *)view didClickNode:(MapLineInfoModel *)infoMode type:(NSInteger)type other:(id)other {

    if (type == 1) {
        _moreView = [[PostMapMoreView alloc] initWithFrame:CGRectZero andParentController:self];
        [self.moreView showAnimationWithController:self];
        self.moreView.nodeId = infoMode.nodeId;
        self.moreView.postId = infoMode.postId;
        self.moreView.wayId = [NSNumber numberWithInteger:self.model.wayId];
    }else {
        HICHomePostDetailVC *vc = HICHomePostDetailVC.new;
        vc.trainPostId = infoMode.trainPostId;
        vc.postLineId = infoMode.postId;
        vc.titleName = infoMode.postName;
        vc.wayId = self.model.wayId;
        [self.parentViewController.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark - 页面赋值
-(void)setIsShowCurrentProgress:(BOOL)isShowCurrentProgress {
    _isShowCurrentProgress = isShowCurrentProgress;
    if (isShowCurrentProgress) {
        _lineView.isShowCurrentProgress = YES;
    }
}

-(void)setRefreshModel:(HICPostMapLineModel *)refreshModel {
    _refreshModel = refreshModel;
    if (refreshModel) {
        _lineView.model = refreshModel; // 重新赋值
    }
    // 值不存在的情况下不处理
}

#pragma mark - 懒加载
//-(PostMapMoreView *)moreView {
//    if (!_moreView) {
//        _moreView = [[PostMapMoreView alloc] initWithFrame:CGRectZero andParentController:self];
//    }
//    return _moreView;
//}


@end
