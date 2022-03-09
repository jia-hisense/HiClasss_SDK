//
//  HICOnlineTrainVC.m
//  HiClass
//
//  Created by WorkOffice on 2020/3/3.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICOnlineTrainVC.h"
#import "HICTrainAllView.h"
#import "HICTrainWaitingView.h"
#import "HICTrainFinishedView.h"
#import "HICTrainInProgressView.h"
#define btnW  HIC_ScreenWidth / 4
#define btnH  22.5
@interface HICOnlineTrainVC ()<UIScrollViewDelegate,HICCustomNaviViewDelegate>
@property(nonatomic, copy) UIScrollView *titleView;
@property(nonatomic, strong) NSMutableArray *titleArr;
@property(nonatomic, strong) UIView *underLine;
@property(nonatomic, assign) NSInteger currentIndex;
@property(nonatomic, strong) UIScrollView *contentView;
@property(nonatomic, strong) NSMutableArray *titleBtnArr;
@property(nonatomic, strong) NSMutableArray *dataArr;
@property(nonatomic, strong) HICNetModel *netModel;
@property(nonatomic, strong) HICTrainAllView *allView;
@property(nonatomic, strong) HICTrainWaitingView *waitView;
@property(nonatomic, strong) HICTrainFinishedView *finishedView;
@property(nonatomic, strong) HICTrainInProgressView *inProgressView;
@property(nonatomic, strong) UIImageView *blackView;
@property(nonatomic, strong) UILabel *blackLabel;
@property(nonatomic, assign) BOOL isBack;
@end

@implementation HICOnlineTrainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    [self createNavi];
    [self createTitleView];
    [self createContentView];
    self.currentIndex = 0;
//    [self getNum];
//    [self getData:1];
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    self.contentView.contentOffset = CGPointMake(TrainManager.contentSizeW, 0);
    
    [self getNum];
    [self getData:self.currentIndex + 1];
}
- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = NO;
    if (self.isBack) {
        TrainManager.contentSizeW = 0;
    }else{
       TrainManager.contentSizeW = self.contentView.contentOffset.x;
    }
}

- (void)createNavi {
    HICCustomNaviView *navi = [[HICCustomNaviView alloc] initWithTitle:NSLocalizableString(@"training", nil) rightBtnName:nil showBtnLine:NO];
    navi.delegate = self;
    [self.view addSubview:navi];
    
}
- (void)createTitleView {
    self.titleView.backgroundColor = UIColor.whiteColor;
    self.titleView.pagingEnabled = YES;
    self.titleView.showsHorizontalScrollIndicator = NO;
    self.titleView.delegate = self;
    self.titleView.contentSize = CGSizeMake(btnW *self.titleArr.count, 0);
    [self.view addSubview:self.titleView];
    for (int i = 0; i < self.titleArr.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i;
        if(i == 0){
            [btn setTitleColor:[UIColor colorWithHexString:@"#00BED7"] forState:UIControlStateNormal];
        }else{
            [btn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
        }
        btn.backgroundColor = UIColor.whiteColor;
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn setTitleColor:[UIColor colorWithHexString:@"#00BED7"] forState:UIControlStateSelected];
        [btn setTitle:self.titleArr[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.frame = CGRectMake( i * btnW, 6, btnW, btnH);
        [self.titleView addSubview:btn];
        [self.titleBtnArr addObject:btn];
    }
    self.underLine.backgroundColor = [UIColor colorWithHexString:@"#00BED7"];
    [self.view addSubview:self.underLine];

}
- (void)createContentView{
    [self.view addSubview:self.contentView];
    [self.contentView addSubview:self.allView];
    [self.contentView addSubview:self.waitView];
    [self.contentView addSubview:self.inProgressView];
    [self.contentView addSubview:self.finishedView];
    
    // 增加刷新机制
    self.allView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getData:self.currentIndex + 1];
        [self getNum];
    }];
    self.waitView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getData:self.currentIndex + 1];
        [self getNum];
    }];
    self.inProgressView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getData:self.currentIndex + 1];
        [self getNum];
    }];
    self.finishedView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getData:self.currentIndex + 1];
        [self getNum];
    }];
}
- (void)getNum{
    [HICAPI getTrainingManagementNum:^(NSDictionary * _Nonnull responseObject) {
        if (responseObject[@"data"] ) {
            NSNumber * doNum = responseObject[@"data"][@"doneNum"];
            NSNumber *inProgressNum = responseObject[@"data"][@"inProgressNum"];
            NSNumber *todoNum = responseObject[@"data"][@"todoNum"];
            if (![doNum isEqual:@0]) {
                NSString  *str3 = [NSString stringWithFormat:@"%@%@",NSLocalizableString(@"hasBeenCompleted", nil),[NSString isValidStr:[doNum toString]] ? [NSString stringWithFormat:@"(%@)", doNum] : @""];
                [self.titleArr replaceObjectAtIndex:2 withObject:str3];
            }
            if (![inProgressNum isEqual:@0]) {
                 NSString  *str1 = [NSString stringWithFormat:@"%@%@",NSLocalizableString(@"ongoing", nil),[NSString isValidStr:[inProgressNum toString]] ? [NSString stringWithFormat:@"(%@)", inProgressNum] : @""];
                [self.titleArr replaceObjectAtIndex:0 withObject:str1];
            }
            if (![todoNum isEqual:@0]) {
                 NSString  *str2 = [NSString stringWithFormat:@"%@%@",NSLocalizableString(@"waitStart", nil),[NSString isValidStr:[todoNum toString]] ? [NSString stringWithFormat:@"(%@)", todoNum] : @""];
                [self.titleArr replaceObjectAtIndex:1 withObject:str2];
            }
            [self.titleView removeFromSuperview];
            [self createTitleView];
            [self changeItemSelectLine:self.currentIndex];
            
        }
    }];
}
- (void)changeItemSelectLine:(NSInteger) index {
    for (int i = 0; i < self.titleBtnArr.count; i ++) {
            UIButton *btn = self.titleBtnArr[i];
            if (btn.tag == index) {
                [btn setTitleColor:[UIColor colorWithHexString:@"#00BED7"] forState:UIControlStateNormal];
    //            [self.underLine setCenter:CGPointMake(btn.center.x, 48 + HIC_NavBarAndStatusBarHeight)];
                self.underLine.centerX = btn.centerX;
            }else{
                [btn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
            }
        }
}
- (void)getData:(NSInteger)status {
    [HICAPI getTrainingManagementList:status success:^(NSDictionary * _Nonnull responseObject) {
        if (responseObject[@"data"][@"trainList"]) {
            if (status == HICTrainInProgress) {
                self.inProgressView.dataArr = responseObject[@"data"][@"trainList"];
                if (self.inProgressView.dataArr.count == 0) {
                    [self.inProgressView addSubview:self.blackView];
                    [self.inProgressView addSubview:self.blackLabel];
                    self.blackView.hidden = NO;
                    self.blackLabel.hidden = NO;
                }else{
                    self.blackView.hidden = YES;
                    self.blackLabel.hidden = YES;
                }
            }else if (status == HICTrainWait){
                self.waitView.dataArr = responseObject[@"data"][@"trainList"];
                if (self.waitView.dataArr.count == 0) {
                    [self.waitView addSubview:self.blackView];
                    [self.waitView addSubview:self.blackLabel];
                    self.blackView.hidden = NO;
                    self.blackLabel.hidden = NO;
                }else{
                    self.blackView.hidden = YES;
                    self.blackLabel.hidden = YES;
                }
            }else if(status == HICTrainFinished){
                self.finishedView.dataArr = responseObject[@"data"][@"trainList"];
                if (self.finishedView.dataArr.count == 0) {
                    [self.finishedView addSubview:self.blackView];
                    [self.finishedView addSubview:self.blackLabel];
                    self.blackView.hidden = NO;
                    self.blackLabel.hidden = NO;
                }else{
                    self.blackView.hidden = YES;
                    self.blackLabel.hidden = YES;
                }
            }else{
                self.allView.dataArr = responseObject[@"data"][@"trainList"];
                if (self.allView.dataArr.count == 0) {
                    [self.allView addSubview:self.blackView];
                    [self.allView addSubview:self.blackLabel];
                    self.blackView.hidden = NO;
                    self.blackLabel.hidden = NO;
                }else{
                    self.blackView.hidden = YES;
                    self.blackLabel.hidden = YES;
                }
            }
        }
        [self.allView.mj_header endRefreshing];
        [self.waitView.mj_header endRefreshing];
        [self.inProgressView.mj_header endRefreshing];
        [self.finishedView.mj_header endRefreshing];
    } failure:^(NSError * _Nonnull error) {
        [self.allView.mj_header endRefreshing];
        [self.waitView.mj_header endRefreshing];
        [self.inProgressView.mj_header endRefreshing];
        [self.finishedView.mj_header endRefreshing];
    }];
}
- (void)btnClick:(UIButton *)btn{
    CGFloat offsetX = btn.center.x - HIC_ScreenWidth * 0.5;
    //  计算偏移量
    if (offsetX < 0) offsetX = 0;
    // 获取最大滚动范围
    CGFloat maxOffsetX = self.titleView.contentSize.width - HIC_ScreenWidth;
    if (offsetX > maxOffsetX) offsetX = maxOffsetX;
    // 滚动标题滚动条
    [self.titleView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    self.contentView.contentOffset = CGPointMake(btn.tag * HIC_ScreenWidth, 0);
    [self setItemSelected:btn.tag];
}
- (void)setItemSelected:(NSInteger)index{
    for (int i = 0; i < self.titleBtnArr.count; i ++) {
        UIButton *btn = self.titleBtnArr[i];
        if (btn.tag == index) {
            [btn setTitleColor:[UIColor colorWithHexString:@"#00BED7"] forState:UIControlStateNormal];
            [self.underLine setCenter:CGPointMake(btn.center.x, 42 + HIC_NavBarAndStatusBarHeight)];
        }else{
            [btn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
        }
    }
    self.currentIndex = index;
    index +=1;
    [self getData:index];
    [self getNum];
    
}
#pragma mark -scrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat offSetX = scrollView.contentOffset.x;
    NSInteger pageNum = offSetX / HIC_ScreenWidth;
    [self setItemSelected:pageNum];
}

- (void)leftBtnClicked {
    self.isBack = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --lazyLoad
- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray new];
    }
    return _dataArr;
}
- (NSMutableArray *)titleArr {
    if(!_titleArr){
        _titleArr = [NSMutableArray arrayWithArray:@[NSLocalizableString(@"ongoing", nil),NSLocalizableString(@"waitStart", nil),NSLocalizableString(@"hasBeenCompleted", nil),NSLocalizableString(@"all", nil)]];
    }
    return _titleArr;
}
- (UIScrollView *)titleView {
    if (!_titleView) {
        _titleView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, HIC_NavBarAndStatusBarHeight, HIC_ScreenWidth, 44)];
    }
    return _titleView;
}
- (NSMutableArray *)titleBtnArr {
    if (!_titleBtnArr) {
        _titleBtnArr  = [[NSMutableArray alloc]init];
    }
    return _titleBtnArr;
}
- (UIView *)underLine {
    if (!_underLine) {
        _underLine = [[UIView alloc]initWithFrame:CGRectMake((btnW - 30 )/2, 42 + HIC_NavBarAndStatusBarHeight, 30, 2.5)];
    }
    return _underLine;
}
- (HICTrainWaitingView *)waitView{
    if (!_waitView) {
        _waitView = [[HICTrainWaitingView alloc]init];
    }
    return _waitView;
}
- (HICTrainAllView *)allView{
    if (!_allView) {
        _allView = [[HICTrainAllView alloc]init];
    }
    return _allView;
}
- (HICTrainInProgressView *)inProgressView{
    if (!_inProgressView) {
        _inProgressView = [[HICTrainInProgressView alloc]init];
    }
    return _inProgressView;
}
- (HICTrainFinishedView *)finishedView{
    if (!_finishedView) {
        _finishedView  = [[HICTrainFinishedView alloc]init];
    }
    return _finishedView;
}
-(UIView *)blackView{
    if (!_blackView) {
        _blackView = [[UIImageView alloc]initWithFrame:CGRectMake(HIC_ScreenWidth/2 - 60, (HIC_ScreenHeight -HIC_NavBarAndStatusBarHeight)/ 2 - 120, 120, 120)];
        _blackView.image = [UIImage imageNamed:@"考试空白页"];
    }
    return _blackView;
}
- (UILabel *)blackLabel {
    if (!_blackLabel) {
        _blackLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, (HIC_ScreenHeight -HIC_NavBarAndStatusBarHeight)/ 2, HIC_ScreenWidth, 20)];
        _blackLabel.text = NSLocalizableString(@"noTrainTask", nil);
        _blackLabel.textColor = TEXT_COLOR_LIGHTS;
        _blackLabel.font = FONT_REGULAR_16;
        _blackLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _blackLabel;
}
- (UIScrollView *)contentView{
    if (!_contentView) {
        _contentView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, HIC_NavBarAndStatusBarHeight + 44, HIC_ScreenWidth, HIC_ScreenHeight - HIC_NavBarAndStatusBarHeight - 44)];
        _contentView.pagingEnabled = YES;
        _contentView.bounces = NO;
        _contentView.showsHorizontalScrollIndicator = NO;
        _contentView.contentSize = CGSizeMake(HIC_ScreenWidth * 4, HIC_ScreenHeight - HIC_NavBarAndStatusBarHeight - 44);
        _contentView.scrollEnabled = YES;
        _contentView.backgroundColor = [UIColor colorWithHexString:@"#E9E9E9"];
        _contentView.delegate = self;
        _contentView.userInteractionEnabled = YES;
    }
    return _contentView;
}

@end
