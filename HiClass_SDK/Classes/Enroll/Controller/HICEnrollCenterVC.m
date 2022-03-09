//
//  HICEnrollCenterVC.m
//  HiClass
//
//  Created by WorkOffice on 2020/6/4.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import "HICEnrollCenterVC.h"
#import "HICEnrollWaitView.h"
#import "HICEnrolledView.h"
#import "HICEnrollExpiredView.h"
#import "HICEnrollAllView.h"
#import "HICEnrollListModel.h"
#define btnW  HIC_ScreenWidth / 4
#define btnH  22.5
@interface HICEnrollCenterVC ()<HICCustomNaviViewDelegate,UIScrollViewDelegate>
@property (nonatomic ,copy) UIScrollView *titleView;
@property (nonatomic ,strong) NSMutableArray *titleArr;
@property (nonatomic ,strong) UIView *underLine;
@property (nonatomic ,assign) NSInteger currentIndex;
@property (nonatomic ,strong) UIScrollView *contentView;
@property (nonatomic ,strong) NSMutableArray *titleBtnArr;
@property (nonatomic ,strong) NSMutableArray *dataArr;
@property (nonatomic ,strong) HICNetModel *netModel;
@property (nonatomic ,strong) HICEnrollWaitView *waitView;
@property (nonatomic ,strong) HICEnrollAllView *allView;
@property (nonatomic ,strong) HICEnrolledView *enrolledView;
@property (nonatomic ,strong) HICEnrollExpiredView *expiredView;
@property (nonatomic ,strong) UIImageView *blackView;
@property (nonatomic ,strong) UILabel *blackLabel;
@property (nonatomic ,assign) BOOL isBack;
@end

@implementation HICEnrollCenterVC


#pragma mark --lazyLoad
- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray new];
    }
    return _dataArr;
}
- (NSMutableArray *)titleArr {
    if(!_titleArr){
        _titleArr = [NSMutableArray arrayWithArray:@[NSLocalizableString(@"waitSignUp", nil),NSLocalizableString(@"haveToSignUp", nil),NSLocalizableString(@"expired", nil),NSLocalizableString(@"all", nil)]];
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
- (HICEnrollWaitView *)waitView{
    if (!_waitView) {
        _waitView = [[HICEnrollWaitView alloc]init];
    }
    return _waitView;
}
- (HICEnrollAllView *)allView{
    if (!_allView) {
        _allView = [[HICEnrollAllView alloc]init];
    }
    return _allView;
}
- (HICEnrollExpiredView *)expiredView{
    if (!_expiredView) {
        _expiredView = [[HICEnrollExpiredView alloc]init];
    }
    return _expiredView;
}
-(HICEnrolledView *)enrolledView{
    if (!_enrolledView) {
        _enrolledView = [[HICEnrolledView alloc]init];
    }
    return _enrolledView;
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
        _blackLabel.text = NSLocalizableString(@"notSigningUpForTasks", nil);
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
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    [self getNum];
    [self getData:self.currentIndex + 1];
    self.contentView.contentOffset = CGPointMake(EnrollManager.contentSizeW, 0);
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = NO;
    if (self.isBack) {
        EnrollManager.contentSizeW = 0;
    }else{
       EnrollManager.contentSizeW = self.contentView.contentOffset.x;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    [self createNavi];
    [self createTitleView];
    [self createContentView];
    self.currentIndex = 0;
    [self setItemSelected:0];
}
- (void)createNavi {
    HICCustomNaviView *navi = [[HICCustomNaviView alloc] initWithTitle:NSLocalizableString(@"registrationCenter", nil) rightBtnName:nil showBtnLine:NO];
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
    [self.contentView addSubview:self.expiredView];
    [self.contentView addSubview:self.enrolledView];
    // 增加刷新机制
    self.allView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getData:self.currentIndex + 1];
        [self getNum];
    }];
    self.waitView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getData:self.currentIndex + 1];
        [self getNum];
    }];
    self.expiredView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getData:self.currentIndex + 1];
        [self getNum];
    }];
    self.enrolledView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getData:self.currentIndex + 1];
        [self getNum];
    }];
}
- (void)getNum{
    [HICAPI getRegistrationStateNum:^(NSDictionary * _Nonnull responseObject) {
        NSNumber * doNum = responseObject[@"data"][@"doneNum"];
        NSNumber *overdueNum = responseObject[@"data"][@"overdueNum"];
        NSNumber *todoNum = responseObject[@"data"][@"todoNum"];
        if (![doNum isEqual:@0]) {
            NSString  *str3 = [NSString stringWithFormat:@"%@%@",NSLocalizableString(@"haveToSignUp", nil),[NSString isValidStr:[doNum toString]] ? [NSString stringWithFormat:@"(%@)", doNum] : @""];
            [self.titleArr replaceObjectAtIndex:1 withObject:str3];
        }else{
            [self.titleArr replaceObjectAtIndex:1 withObject:NSLocalizableString(@"haveToSignUp", nil)];
        }
        if (![overdueNum isEqual:@0]) {
            NSString  *str1 = [NSString stringWithFormat:@"%@%@",NSLocalizableString(@"expired", nil),[NSString isValidStr:[overdueNum toString]] ? [NSString stringWithFormat:@"(%@)", overdueNum] : @""];
            [self.titleArr replaceObjectAtIndex:2 withObject:str1];
        }else{
            [self.titleArr replaceObjectAtIndex:2 withObject:NSLocalizableString(@"expired", nil)];
        }
        if (![todoNum isEqual:@0]) {
            NSString  *str2 = [NSString stringWithFormat:@"%@%@",NSLocalizableString(@"waitSignUp", nil),[NSString isValidStr:[todoNum toString]] ? [NSString stringWithFormat:@"(%@)", todoNum] : @""];
            [self.titleArr replaceObjectAtIndex:0 withObject:str2];
        }else{
            [self.titleArr replaceObjectAtIndex:0 withObject:NSLocalizableString(@"waitSignUp", nil)];
        }
        [self.titleView removeFromSuperview];
        [self createTitleView];
        [self changeItemSelectLine:self.currentIndex];
    }];
}

- (void)getData:(NSInteger)status {
    [HICAPI getRegistrationList:status success:^(NSDictionary * _Nonnull responseObject) {
        if (status == HICEnrollNotRegister) {
            self.waitView.dataArr = [HICEnrollListModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
            if (self.waitView.dataArr.count == 0) {
                [self.waitView addSubview:self.blackView];
                [self.waitView addSubview:self.blackLabel];
                self.blackView.hidden = NO;
                self.blackLabel.hidden = NO;
            }else{
                self.blackView.hidden = YES;
                self.blackLabel.hidden = YES;
            }
        }else if (status == HICEnrolled){
            self.enrolledView.dataArr = [HICEnrollListModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
            if (self.enrolledView.dataArr.count == 0) {
                [self.enrolledView addSubview:self.blackView];
                [self.enrolledView addSubview:self.blackLabel];
                self.blackView.hidden = NO;
                self.blackLabel.hidden = NO;
            }else{
                self.blackView.hidden = YES;
                self.blackLabel.hidden = YES;
            }
        }else if(status == HICEnrollExpired){
            self.expiredView.dataArr = [HICEnrollListModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
            if (self.expiredView.dataArr.count == 0) {
                [self.expiredView addSubview:self.blackView];
                [self.expiredView addSubview:self.blackLabel];
                self.blackView.hidden = NO;
                self.blackLabel.hidden = NO;
            }else{
                self.blackView.hidden = YES;
                self.blackLabel.hidden = YES;
            }
        }else{
            self.allView.dataArr = [HICEnrollListModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
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
        [self.allView.mj_header endRefreshing];
        [self.waitView.mj_header endRefreshing];
        [self.expiredView.mj_header endRefreshing];
        [self.enrolledView.mj_header endRefreshing];
    } failure:^(NSError * _Nonnull error) {
        [self.allView.mj_header endRefreshing];
        [self.waitView.mj_header endRefreshing];
        [self.expiredView.mj_header endRefreshing];
        [self.enrolledView.mj_header endRefreshing];
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
     [self changeItemSelectLine:index];
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

@end
