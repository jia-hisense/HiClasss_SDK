//
//  HICExamBaseVC.m
//  HiClass
//
//  Created by 铁柱， on 2020/1/14.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICExamBaseVC.h"
#import "HICAllExamView.h"
#import "HICAbsentView.h"
#import "HICFinishedExam.h"
#import "HICWaitingExamView.h"
#import "HICMarkingExamView.h"
#import "HICExamControlModel.h"
#import "HomeTaskCenterDefaultView.h"
//考试中心按钮高度宽度
#define BtnW  HIC_ScreenWidth / 5
#define BtnH  44
#define margin 10;
@interface HICExamBaseVC ()<UIScrollViewDelegate,UITableViewDelegate,HICCustomNaviViewDelegate>
@property(nonatomic, copy) UIScrollView *titleView;
@property(nonatomic, strong) NSMutableArray *titleArr;
@property(nonatomic, strong) UIView *underLine;
@property(nonatomic, assign) NSInteger currentIndex;
@property(nonatomic, strong) UIScrollView *contentView;
@property(nonatomic, strong) HICWaitingExamView *waitView;
@property(nonatomic, strong) HICAbsentView *absentView;
@property(nonatomic, strong) HICFinishedExam *finishView;
@property(nonatomic, strong) HICAllExamView *allView;
@property(nonatomic, strong) HICMarkingExamView *markingView;
@property(nonatomic, strong) NSMutableArray *titleBtnArr;
@property(nonatomic, strong) HICNetManager *manager;
@property(nonatomic, strong) NSMutableDictionary *examPostModel;
@property(nonatomic, strong) HICNetModel *netModel;
@property(nonatomic, strong) NSMutableArray *dataArr;
@property(nonatomic, strong) NSNumber *systemTime;
@property (nonatomic ,weak)NSTimer *timer;
@property (nonatomic ,strong)NSMutableArray *timeArr;
@property (nonatomic, strong)HICExamControlModel *controlModel;
@property (nonatomic ,assign)NSInteger timeDeffer;
@property (nonatomic ,strong)NSMutableArray *countArr;
@property (nonatomic ,assign)BOOL isBack;
@property (nonatomic ,strong)HomeTaskCenterDefaultView *defaultView;
@end

@implementation HICExamBaseVC
#pragma mark -lazyload
-(HomeTaskCenterDefaultView *)defaultView{
    if (!_defaultView) {
        _defaultView = [[HomeTaskCenterDefaultView alloc]initWithFrame:CGRectMake(0, 0, HIC_ScreenWidth, HIC_ScreenHeight - HIC_NavBarAndStatusBarHeight)];
        _defaultView.titleStr = NSLocalizableString(@"noExamAssignments", nil);
        _defaultView.imageName = @"考试空白页";
    }
    return _defaultView;
}
- (NSMutableArray *)titleArr {
    if(!_titleArr){
//        _titleArr = @[@"待考",NSLocalizableString(@"immediatelyTest", nil),@"已完成",@"缺考",@"全部"];
        _titleArr = [NSMutableArray arrayWithArray:@[NSLocalizableString(@"waitKao", nil),NSLocalizableString(@"reviewing", nil),NSLocalizableString(@"hasBeenCompleted", nil),NSLocalizableString(@"lackOfTest", nil),NSLocalizableString(@"all", nil)]];
//        _titleArr = [NSMutableArray array];
    }
    return _titleArr;
}
- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray new];
    }
    return _dataArr;
}
- (UIScrollView *)titleView {
    if (!_titleView) {
        _titleView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, HIC_NavBarAndStatusBarHeight, HIC_ScreenWidth, 50)];
        _titleView.tag = 1000;
        _titleView.pagingEnabled = YES;
        _titleView.bounces = NO;
        _titleView.showsHorizontalScrollIndicator = NO;
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
        _underLine = [[UIView alloc]initWithFrame:CGRectMake((BtnW - 35 )/2, 47.5, 35, 2.5)];
    }
    return _underLine;
}
- (UIScrollView *)contentView{
    if (!_contentView) {
        _contentView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, HIC_NavBarAndStatusBarHeight + 50, HIC_ScreenWidth, HIC_ScreenHeight - HIC_NavBarAndStatusBarHeight - 50)];
        _contentView.pagingEnabled = YES;
        _contentView.bounces = NO;
        _contentView.showsHorizontalScrollIndicator = NO;
        _contentView.contentSize = CGSizeMake(HIC_ScreenWidth * 5, HIC_ScreenHeight - HIC_NavBarAndStatusBarHeight - 50);
        _contentView.scrollEnabled = YES;
        _contentView.backgroundColor = BACKGROUNG_COLOR;
        _contentView.delegate = self;
        _contentView.userInteractionEnabled = YES;
        _contentView.tag = 1001;
    }
    return _contentView;
}
- (HICAllExamView *)allView {
    if (!_allView) {
        _allView  = [[HICAllExamView alloc]init];
    }
    return _allView;
}
- (HICMarkingExamView *)markingView {
    if (!_markingView) {
        _markingView = [[HICMarkingExamView alloc]init];
    }
    return _markingView;
}
- (HICFinishedExam *)finishView {
    if (!_finishView) {
        _finishView = [[HICFinishedExam alloc]init];
    }
    return _finishView;
}
- (HICAbsentView *)absentView {
    if (!_absentView) {
        _absentView = [[HICAbsentView alloc]init];
    }
    return _absentView;
}
- (HICWaitingExamView *)waitView {
    if (!_waitView) {
        _waitView = [[HICWaitingExamView alloc]init];
    }
    return _waitView;
}
- (NSMutableDictionary *)examPostModel {
    if(!_examPostModel){
        _examPostModel = [[NSMutableDictionary alloc]init];
    }
    return _examPostModel;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.currentIndex = 0;
    [self createNavi];
    self.countArr = [NSMutableArray array];
    [self createInitTitleView];
//    [self getStatusListCount];
    [self createContentView];
//    self.defaultView.hidden = YES;
    [self setItemSelected:0];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getStatusListCount];
    if (self.currentIndex > 0) {
        [self getData:self.currentIndex + 1];
    }else{
        [self getData:self.currentIndex];
    }
    self.navigationController.navigationBarHidden = YES;
    if (ExamManager.contentSizeW) {
        self.contentView.contentOffset = CGPointMake(ExamManager.contentSizeW, 0);
    }
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    if (self.isBack) {
        ExamManager.contentSizeW = 0;
    }else{
        ExamManager.contentSizeW = self.contentView.contentOffset.x;
    }
}
- (void)createNavi {
    HICCustomNaviView *navi = [[HICCustomNaviView alloc] initWithTitle:NSLocalizableString(@"testCenter", nil) rightBtnName:nil showBtnLine:NO];
    navi.delegate = self;
    [self.view addSubview:navi];
}
-(void)createInitTitleView {
    self.titleView.backgroundColor = UIColor.whiteColor;
    self.titleView.pagingEnabled = YES;
    self.titleView.showsHorizontalScrollIndicator = NO;
    self.titleView.delegate = self;
    self.titleView.contentSize = CGSizeMake(BtnW *self.titleArr.count, 0);
    if (self.titleView.subviews) {
        [self.titleView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    [self.view addSubview:self.titleView];
    CGFloat contentWidth = 0;
    CGFloat btnX = 10;
    for (int i = 0; i < self.titleArr.count; i++) {
        CGFloat width = BtnW;
        if (i > 0) {
            btnX += width;
        }
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i;
        if (i == self.currentIndex) {
            [btn setTitleColor:[UIColor colorWithHexString:@"#00BED7"] forState:UIControlStateNormal];
        }else{
         [btn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
        }
        btn.backgroundColor = UIColor.whiteColor;
        btn.titleLabel.font = [UIFont systemFontOfSize:15];

        [btn setTitle:self.titleArr[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.frame = CGRectMake(btnX, 6, width, BtnH);
        [self.titleView addSubview:btn];
        [self.titleBtnArr addObject:btn];
    }
    self.titleView.contentSize = CGSizeMake(contentWidth, 50);
    self.underLine.backgroundColor = [UIColor colorWithHexString:@"#00BED7"];
    [self.titleView addSubview:self.underLine];
}
- (void)createTitleView {
    self.titleView.backgroundColor = UIColor.whiteColor;
    self.titleView.pagingEnabled = YES;
    self.titleView.showsHorizontalScrollIndicator = NO;
    self.titleView.delegate = self;
//    self.titleView.contentSize = CGSizeMake(BtnW *self.titleArr.count, 0);
    if (self.titleView.subviews) {
        [self.titleView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    [self.view addSubview:self.titleView];
    CGFloat contentWidth = 10;
    CGFloat btnX = 10;
    CGFloat btnBefoW = 0;
    for (int i = 0; i < self.titleArr.count; i++) {
        CGFloat width = [self widthForString:self.titleArr[i] fontSize:15 andHeight:20];
        if (width > BtnW) {
            if (i > 0) {
                btnX += btnBefoW;
            }
        }else{
            width = BtnW;
            if (i > 0) {
                btnX += btnBefoW;
            }
        }
         contentWidth += width;
        btnBefoW = width;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i;
        if (i == self.currentIndex) {
            [btn setTitleColor:[UIColor colorWithHexString:@"#00BED7"] forState:UIControlStateNormal];
        }else{
         [btn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
        }
        btn.backgroundColor = UIColor.whiteColor;
        btn.titleLabel.font = [UIFont systemFontOfSize:15];

        [btn setTitle:self.titleArr[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.frame = CGRectMake(btnX, 6, width, BtnH);
        [self.titleView addSubview:btn];
        [self.titleBtnArr addObject:btn];
    }

    self.titleView.contentSize = CGSizeMake(contentWidth, 50);
    self.underLine.backgroundColor = [UIColor colorWithHexString:@"#00BED7"];
    [self.titleView addSubview:self.underLine];
}
- (void)createContentView {
    [self.view addSubview:self.contentView];
    [self.contentView setContentSize:CGSizeMake(HIC_ScreenWidth *5, HIC_ScreenHeight - HIC_NavBarAndStatusBarHeight - 50)];
    [self.contentView addSubview:self.waitView];
    [self.contentView addSubview:self.markingView];
    [self.contentView addSubview:self.finishView];
    [self.contentView addSubview:self.absentView];
    [self.contentView addSubview:self.allView];
    
    // 增加刷新机制
    self.allView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getStatusListCount];
        if (self.currentIndex > 0) {
            [self getData:self.currentIndex + 1];
        }else{
            [self getData:self.currentIndex];
        }
    }];
    self.waitView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getStatusListCount];
        if (self.currentIndex > 0) {
            [self getData:self.currentIndex + 1];
        }else{
            [self getData:self.currentIndex];
        }
    }];
    self.markingView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getStatusListCount];
        if (self.currentIndex > 0) {
            [self getData:self.currentIndex + 1];
        }else{
            [self getData:self.currentIndex];
        }
    }];
    self.finishView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getStatusListCount];
        if (self.currentIndex > 0) {
            [self getData:self.currentIndex + 1];
        }else{
            [self getData:self.currentIndex];
        }
    }];
    self.absentView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getStatusListCount];
        if (self.currentIndex > 0) {
            [self getData:self.currentIndex + 1];
        }else{
            [self getData:self.currentIndex];
        }
    }];
}
- (void)getStatusListCount{
    [HICAPI examStatesNum:^(NSDictionary * _Nonnull responseObject) {
        NSArray *countArr = [NSArray arrayWithArray:responseObject[@"data"]];
               if (countArr.count == 0) {
                   return ;
               }
        [self.titleArr removeAllObjects];
        NSNumber *waitCount = @0;
        NSNumber *progressCount = @0;
        NSNumber *markingCount = @0;
        NSNumber *finishedCount = @0;
        NSNumber *absentCount = @0;
        for (int i = 0; i < countArr.count; i++) {
            if ([countArr[i][@"status"] isEqualToNumber:@0]) {
                waitCount = countArr[i][@"count"];
            }else if ([countArr[i][@"status"] isEqualToNumber:@1]){
                progressCount = countArr[i][@"count"];
            }else if ([countArr[i][@"status"] isEqualToNumber:@2]){
                markingCount = countArr[i][@"count"];
            }else if ([countArr[i][@"status"] isEqualToNumber:@3]){
                finishedCount = countArr[i][@"count"];
            }else{
                absentCount = countArr[i][@"count"];
            }
        }
        if (![progressCount isEqualToNumber:@0]) {
            NSInteger count;
            count = [waitCount integerValue] + [progressCount integerValue];
            [self.titleArr addObject:[NSString stringWithFormat:@"%@(%ld)",NSLocalizableString(@"waitKao", nil),(long)count]];
        }else{
            if ([waitCount integerValue] == 0) {
                [self.titleArr addObject:NSLocalizableString(@"waitKao", nil)];
            }else{
                [self.titleArr addObject:[NSString stringWithFormat:@"%@(%@)",NSLocalizableString(@"waitKao", nil),waitCount]];
            }
        }
//        [self.countArr addObject:waitCount];
        if (![markingCount isEqualToNumber:@0]) {
        [self.titleArr addObject:[NSString stringWithFormat:@"%@(%@)",NSLocalizableString(@"reviewing", nil),markingCount]];
        }else{
        [self.titleArr addObject:NSLocalizableString(@"reviewing", nil)];
        }
//        [self.countArr addObject:markingCount];
        if (![finishedCount isEqualToNumber:@0]) {
        [self.titleArr addObject:[NSString stringWithFormat:@"%@(%@)",NSLocalizableString(@"hasBeenCompleted", nil),finishedCount]];
        }else{
        [self.titleArr addObject:NSLocalizableString(@"hasBeenCompleted", nil)];
        }
//        [self.countArr addObject:finishedCount];
        if (![absentCount isEqualToNumber:@0]) {
            [self.titleArr addObject:[NSString stringWithFormat:@"%@(%@)",NSLocalizableString(@"lackOfTest", nil),absentCount]];
        }else{
            [self.titleArr addObject:NSLocalizableString(@"lackOfTest", nil)];
        }
//        [self.countArr addObject:absentCount];
        if (self.titleArr.count == 4) {
            [self.titleArr addObject:NSLocalizableString(@"all", nil)];
//            [self.countArr addObject:@"全部"];
            [self.titleView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [self.titleView removeFromSuperview];
            [self createTitleView];
        }
        [self changeItemSelectLine:self.currentIndex];
    }];
}
-(float) widthForString:(NSString *)value fontSize:(float)fontSize andHeight:(float)height
{
    CGSize sizeToFit = [value sizeWithFont:[UIFont systemFontOfSize:fontSize] maxSize:CGSizeMake(CGFLOAT_MAX, height)];
    return sizeToFit.width + 10;

}
- (void)getData:(NSInteger)status {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [self.examPostModel setObject:@1 forKey:@"objectType"];
    if(status == 5){
        [self.examPostModel setObject:@"" forKey:@"examStatus"];
    }else{
        [self.examPostModel setObject:[NSNumber numberWithInteger:status] forKey:@"examStatus"];
    }
    [HICAPI examCenterList:self.examPostModel success:^(NSDictionary * _Nonnull responseObject) {

        [self.allView.mj_header endRefreshing];
        [self.waitView.mj_header endRefreshing];
        [self.markingView.mj_header endRefreshing];
        [self.finishView.mj_header endRefreshing];
        [self.absentView.mj_header endRefreshing];
        NSInteger i = status;
        if (i > 1) {
            i  = i - 1;
        }
        if (![HICCommonUtils isValidObject:responseObject[@"data"][@"examList"]]) {
            if (status == 0) {
                [self.waitView addSubview:self.defaultView];
            }else if (status == 2){
                [self.markingView addSubview:self.defaultView];
            }else if (status == 3){
                [self.finishView addSubview:self.defaultView];
            }else if (status == 4){
                [self.absentView addSubview:self.defaultView];
            }else if (status == 5){
                [self.allView addSubview:self.defaultView];
            }
            self.defaultView.hidden = NO;
            return ;
        }
        self.dataArr = responseObject[@"data"][@"examList"];
        if (self.dataArr.count == 0) {
            if (status == 0) {
                [self.waitView addSubview:self.defaultView];
            }else if (status == 2){
                [self.markingView addSubview:self.defaultView];
            }else if (status == 3){
                [self.finishView addSubview:self.defaultView];
            }else if (status == 4){
                [self.absentView addSubview:self.defaultView];
            }else if (status == 5){
                [self.allView addSubview:self.defaultView];
            }
            self.defaultView.hidden = NO;
            return ;
        }
        self.defaultView.hidden = YES;
        if (status == 5) {
            if (self.dataArr.count != 0) {
                self.allView.dataArray = [NSMutableArray arrayWithArray:self.dataArr];
            }
        }else if (status == 0){
            if (!self.systemTime) {
                self.systemTime = responseObject[@"data"][@"systemTime"];
                NSString *deviceTime = [HICCommonUtils getNowTimeTimestamp];
                self.timeDeffer = [self.systemTime integerValue] - [deviceTime integerValue];
                NSTimer *timer = [NSTimer timerWithTimeInterval:60.0 target:self selector:@selector(timerRun) userInfo:nil repeats:YES];
                [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
                self.timer = timer;
                for(int i = 0;i < self.dataArr.count; i ++){
                    //                    NSDictionary *dic = [NSDictionary new];
                    self.controlModel = [HICExamControlModel mj_objectWithKeyValues:self.dataArr[i][@"controlParams"]];
                    [self.timeArr addObject:self.controlModel];
                }
            }
            if (self.dataArr.count != 0) {
                self.waitView.dataArray = [NSMutableArray arrayWithArray:self.dataArr];
            }
        }else if (status == 2){
            if (self.dataArr.count != 0) {
                self.markingView.dataArray = [NSMutableArray arrayWithArray:self.dataArr];
            }
        }else if (status == 3){
            if (self.dataArr.count != 0) {
                self.finishView.dataArray = [NSMutableArray arrayWithArray:self.dataArr];
            }
        }else if(status == 4){
            if (self.dataArr.count != 0) {
                self.absentView.dataArray = [NSMutableArray arrayWithArray:self.dataArr];
            }
        }else{
        }
        
    } failure:^(NSError * _Nonnull error) {
        [self.allView.mj_header endRefreshing];
        [self.waitView.mj_header endRefreshing];
        [self.markingView.mj_header endRefreshing];
        [self.finishView.mj_header endRefreshing];
        [self.absentView.mj_header endRefreshing];
        [self setErrorNilWithStatus:status];
    }];
    
}
- (void)setErrorNilWithStatus:(NSUInteger)status{
    NSInteger i = status;
    if (i > 1) {
        i  = i - 1;
    }
    if (status == 5) {
        self.allView.dataArray = [NSMutableArray arrayWithArray:@[]];
    }else if (status == 0){
        self.waitView.dataArray = [NSMutableArray arrayWithArray:@[]];;
    }else if (status == 2){
        self.markingView.dataArray = [NSMutableArray arrayWithArray:@[]];;
    }else if (status == 3){
        self.finishView.dataArray = [NSMutableArray arrayWithArray:@[]];;
    }else if(status == 4){
        self.absentView.dataArray = [NSMutableArray arrayWithArray:@[]];;
    }else{
    }
     self.defaultView.hidden = NO;
}
- (void)timerRun{
    NSString *deviceSysTime = [HICCommonUtils getNowTimeTimestamp];
    for (int i = 0; i < self.timeArr.count; i ++) {
        HICExamControlModel *model = self.timeArr[i];
        if ([model.joinStartTime integerValue] <= ([deviceSysTime integerValue] + self.timeDeffer) &&([model.joinEndTime integerValue] >= ([deviceSysTime integerValue] + self.timeDeffer))) {
            NSDictionary *dic = @{@"index":[NSNumber numberWithInt:i]};
            [[NSNotificationCenter defaultCenter] postNotificationName:@"labeladd" object:nil userInfo:dic];
        }
    }
}
- (void)dealloc {
    [self.timer invalidate];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)backBtnClick{
    
    self.isBack = YES;
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)btnClick:(UIButton *)btn{
    CGFloat offsetX = btn.center.x - HIC_ScreenWidth * 0.5;
    //  计算偏移量
    if (offsetX < 0) offsetX = 0;
    // 获取最大滚动范围
    CGFloat maxOffsetX = self.titleView.contentSize.width - HIC_ScreenWidth;
    if (offsetX > maxOffsetX) offsetX = maxOffsetX;
    // 滚动标题滚动条
//    [self.titleView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    self.contentView.contentOffset = CGPointMake(btn.tag * HIC_ScreenWidth, 0);
    [self setItemSelected:btn.tag];
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
- (void)setItemSelected:(NSInteger)index{
    [self changeItemSelectLine:index];
    self.currentIndex = index;
    if (index > 0) {
        index = index + 1;
    }
    [self getStatusListCount];
    [self getData:index];
}
#pragma mark -scrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView.tag == 1001) {
        CGFloat offSetX = scrollView.contentOffset.x;
        NSInteger pageNum = offSetX / HIC_ScreenWidth;
        [self setItemSelected:pageNum];
    }
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

}
#pragma mark - - - HICCustomNaviViewDelegate - - -

- (void)leftBtnClicked {
    [self backBtnClick];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
