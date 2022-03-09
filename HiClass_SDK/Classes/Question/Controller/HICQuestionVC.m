//
//  HICQuestionVC.m
//  HiClass
//
//  Created by WorkOffice on 2020/6/8.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import "HICQuestionVC.h"
#import "HICQuestionListModel.h"
#import "HICQuestionLessonListVC.h"
#define btnW  HIC_ScreenWidth / 4
#define btnH  22.5
@interface HICQuestionVC ()<HICCustomNaviViewDelegate,UIScrollViewDelegate>
@property (nonatomic ,copy) UIScrollView *titleView;
@property (nonatomic ,strong) NSMutableArray *titleArr;
@property (nonatomic ,strong) UIView *underLine;
@property (nonatomic ,assign) NSInteger currentIndex;
@property (nonatomic ,strong) UIScrollView *contentView;
@property (nonatomic ,strong) NSMutableArray *titleBtnArr;
@property (nonatomic ,strong) NSMutableArray *dataArr;
@property (nonatomic ,strong) HICNetModel *netModel;
@property (nonatomic ,assign) BOOL isBack;

@property (nonatomic, strong) NSMutableArray<HICQuestionLessonListVC *> *listVCArr;
@end

@implementation HICQuestionVC
#pragma mark --lazyLoad

- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray new];
    }
    return _dataArr;
}
- (NSMutableArray *)titleArr {
    if(!_titleArr){
        _titleArr = [NSMutableArray arrayWithArray:@[NSLocalizableString(@"toParticipateIn", nil),NSLocalizableString(@"hasBeenCompleted", nil),NSLocalizableString(@"expired", nil),NSLocalizableString(@"all", nil)]];
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
    [self.listVCArr.firstObject getQuestionList];
    [self setItemSelected:self.currentIndex];
    self.contentView.contentOffset = CGPointMake(QuestionManager.contentSizeW, 0);
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = NO;
    if (self.isBack) {
        QuestionManager.contentSizeW = 0;
    }else{
       QuestionManager.contentSizeW = self.contentView.contentOffset.x;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
     [self createNavi];
     [self createTitleView];
     [self createContentView];
    self.currentIndex = 0;
    [self setItemSelected:self.currentIndex];
}

- (void)createNavi {
    HICCustomNaviView *navi = [[HICCustomNaviView alloc] initWithTitle:NSLocalizableString(@"questionnaire", nil) rightBtnName:nil showBtnLine:NO];
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
        if(i == self.currentIndex){
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

- (void)createContentView {
    [self.view addSubview:self.contentView];
    

}
- (void)getNum {
    [HICAPI getQuestionnaireStateNum:^(NSDictionary * _Nonnull responseObject) {
        if (responseObject[@"data"] ) {
            NSNumber * doNum = responseObject[@"data"][@"doneNum"];
            NSNumber *overdueNum = responseObject[@"data"][@"overdueNum"];
            NSNumber *todoNum = responseObject[@"data"][@"todoNum"];
            if (![doNum isEqual:@0]) {
                NSString  *str3 = [NSString stringWithFormat:@"%@%@",NSLocalizableString(@"hasBeenCompleted", nil),[NSString isValidStr:[doNum toString]] ? [NSString stringWithFormat:@"(%@)", doNum] : @""];
                [self.titleArr replaceObjectAtIndex:1 withObject:str3];
            }else{
                [self.titleArr replaceObjectAtIndex:1 withObject:NSLocalizableString(@"hasBeenCompleted", nil)];
            }
            if (![overdueNum isEqual:@0]) {
                NSString  *str1 = [NSString stringWithFormat:@"%@%@",NSLocalizableString(@"expired", nil),[NSString isValidStr:[overdueNum toString]] ? [NSString stringWithFormat:@"(%@)", overdueNum] : @""];
                [self.titleArr replaceObjectAtIndex:2 withObject:str1];
            }else{
                [self.titleArr replaceObjectAtIndex:2 withObject:NSLocalizableString(@"expired", nil)];
            }
            if (![todoNum isEqual:@0]) {
                NSString  *str2 = [NSString stringWithFormat:@"%@%@",NSLocalizableString(@"toParticipateIn", nil),[NSString isValidStr:[todoNum toString]] ? [NSString stringWithFormat:@"(%@)", todoNum] : @""];
                [self.titleArr replaceObjectAtIndex:0 withObject:str2];
            }else{
                [self.titleArr replaceObjectAtIndex:0 withObject:NSLocalizableString(@"toParticipateIn", nil)];
            }
            [self.titleView removeFromSuperview];
            [self createTitleView];
        }
    }];
}
- (NSMutableArray *)listVCArr {
    if (!_listVCArr) {
        _listVCArr = [NSMutableArray array];
        NSArray *listTypes = @[@(HICQuestionLessonListWait), @(HICQuestionLessonListFinish), @(HICQuestionLessonListoverdue), @(HICQuestionLessonListAll)];
        for (int i = 0; i < listTypes.count; i++) {
            HICQuestionLessonListVC *listVC = [[HICQuestionLessonListVC alloc] initWithType:[listTypes[i] integerValue]];
            listVC.view.frame = CGRectMake(HIC_ScreenWidth * i, 0, HIC_ScreenWidth, HIC_ScreenHeight - HIC_NavBarAndStatusBarHeight - 44 );
            [self addChildViewController:listVC];
            [self.contentView addSubview:listVC.view];
            [listVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView).offset(HIC_ScreenWidth * i);
                make.height.mas_equalTo(HIC_ScreenHeight - HIC_NavBarAndStatusBarHeight - 44 );
                make.width.top.equalTo(self.contentView);
            }];
            __weak __typeof(self) weakSelf = self;
            listVC.getQuestionNumBlock = ^{
                [weakSelf getNum];
            };
            [_listVCArr addObject:listVC];
        }
    }
    return _listVCArr;
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
//    index +=1;
    self.currentIndex = index;
    [self.listVCArr[self.currentIndex] getQuestionList];
    
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
