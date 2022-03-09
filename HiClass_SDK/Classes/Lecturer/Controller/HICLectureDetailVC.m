//
//  HICLectureDetailVC.m
//  HiClass
//
//  Created by WorkOffice on 2020/3/13.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICLectureDetailVC.h"
#import "HICLectureDetailModel.h"
#import "HICLectureInductView.h"
#import "HICLectureKnowledgeView.h"
#import "HICLectureCourseView.h"
#import "HICLectureTeachCalendarView.h"
#import "HICOfflineCourseDetailVC.h"

#define btnW  HIC_ScreenWidth / 4
#define btnH  44
@interface HICLectureDetailVC ()<UIScrollViewDelegate>
@property (nonatomic,strong)UIView *topView;
@property (nonatomic ,strong)UIImageView *headerBackView;
@property (nonatomic,strong)UIButton *backButton;
@property(nonatomic, copy) UIScrollView *titleView;
@property(nonatomic, strong) NSMutableArray *titleArr;
@property(nonatomic, strong) UIView *underLine;
@property(nonatomic, assign) NSInteger currentIndex;
@property(nonatomic, strong) UIScrollView *contentView;
@property(nonatomic, strong) NSMutableArray *titleBtnArr;
@property(nonatomic, strong) NSMutableArray *dataArr;
@property(nonatomic, strong) HICNetModel *netModel;
@property (nonatomic, strong)UIImageView *headerImageView;
@property (nonatomic, strong)UILabel *nameLabel;
@property (nonatomic,strong)UILabel *groupLevel;
@property (nonatomic,strong)UILabel *companyLevel;
@property (nonatomic ,strong)HICLectureDetailModel *lectureModel;
@property (nonatomic, strong)HICLectureInductView *lectureInductView;
@property (nonatomic,strong)HICLectureKnowledgeView *lectureKnowledgeView;
@property (nonatomic, strong)UIView *line;
@property (nonatomic ,strong)UILabel *label1;
@property (nonatomic ,strong)UILabel *label2;
@property (nonatomic ,strong)HICLectureCourseView *courseView;
@property (nonatomic ,strong)HICLectureTeachCalendarView *calendarView;
@property (nonatomic ,strong)UIImageView *blackView;
@property (nonatomic ,strong)UILabel *blackLabel;

@property (nonatomic, strong) NSNumber *knowledgeCount;
@property (nonatomic, strong) NSNumber *courseCount;

@property (nonatomic, assign) NSInteger selectedIndex;

@end

@implementation HICLectureDetailVC

-(UIView *)topView{
    if (!_topView) {
        _topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, HIC_ScreenWidth, 167.5 + HIC_StatusBar_Height)];
        self.headerBackView = [[UIImageView alloc]initWithFrame:_topView.frame];
        self.headerBackView.image = [UIImage imageNamed:@"贡献者主页-背景"];
        [_topView addSubview:self.headerBackView];
        self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.backButton.frame = CGRectMake(16, 11.5 + HIC_StatusBar_Height, 12, 22);
        [self.backButton setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
        [self.backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [self.backButton hicChangeButtonClickLength:30];
        self.headerBackView.userInteractionEnabled = true;
        [self.headerBackView addSubview:self.backButton];
    }
    return _topView;
}
- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray new];
    }
    return _dataArr;
}
- (NSMutableArray *)titleArr {
    if(!_titleArr){
        _titleArr = [NSMutableArray arrayWithArray:@[NSLocalizableString(@"introduction", nil),NSLocalizableString(@"knowledge", nil),NSLocalizableString(@"offlinePrograms", nil),NSLocalizableString(@"teachingCalendar", nil)]];
    }
    return _titleArr;
}
- (UIScrollView *)titleView {
    if (!_titleView) {
        _titleView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 167.5 + HIC_StatusBar_Height, HIC_ScreenWidth, 44)];
        
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
        _underLine = [[UIView alloc]initWithFrame:CGRectMake((btnW - 16 )/2, 41, 16, 2.5)];
    }
    return _underLine;
}
- (UIScrollView *)contentView{
    if (!_contentView) {
        _contentView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 167.5 + HIC_StatusBar_Height + 44.5, HIC_ScreenWidth, HIC_ScreenHeight - 167.5 - HIC_StatusBar_Height - 44.5)];
        _line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, HIC_ScreenWidth *4, 0.5)];
        _line.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6"];
        [_contentView bringSubviewToFront:_line];
        [_contentView addSubview:_line];
        _contentView.pagingEnabled = YES;
        _contentView.bounces = NO;
        _contentView.showsHorizontalScrollIndicator = NO;
        _contentView.contentSize = CGSizeMake(HIC_ScreenWidth * 4, HIC_ScreenHeight - 167.5 - HIC_StatusBar_Height - 44.5);
        _contentView.scrollEnabled = YES;
        _contentView.backgroundColor = UIColor.whiteColor;
        _contentView.delegate = self;
        _contentView.userInteractionEnabled = YES;
    }
    return _contentView;
}
-(HICLectureInductView *)lectureInductView{
    if (!_lectureInductView) {
        _lectureInductView = [[HICLectureInductView alloc]initWithFrame:CGRectMake(0, 0, HIC_ScreenWidth, HIC_ScreenHeight - 167.5 - HIC_StatusBar_Height -44.5)];
    }
    return _lectureInductView;
}
- (HICLectureKnowledgeView *)lectureKnowledgeView{
    if (!_lectureKnowledgeView) {
        _lectureKnowledgeView  = [[HICLectureKnowledgeView alloc]initWithFrame:CGRectMake(HIC_ScreenWidth, 0, HIC_ScreenWidth, HIC_ScreenHeight - 167.5 - HIC_StatusBar_Height -44.5)];
    }
    return _lectureKnowledgeView;
}

-(UIImageView *)blackView{
    if (!_blackView) {
        _blackView = [[UIImageView alloc]initWithFrame:CGRectMake(HIC_ScreenWidth / 2 - 60, 101.5, 120, 120)];
        _blackView.image = [UIImage imageNamed:@"暂无数据"];
    }
    return _blackView;
}
- (UILabel *)blackLabel{
    if (!_blackLabel) {
        _blackLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 221.5 + 8, HIC_ScreenWidth, 20)];
        _blackLabel.text = NSLocalizableString(@"temporarilyNoData", nil);
        _blackLabel.textColor = TEXT_COLOR_LIGHTS;
        _blackLabel.font = FONT_REGULAR_15;
        _blackLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _blackLabel;
}
- (HICLectureCourseView *)courseView{
    if (!_courseView) {
        _courseView  = [[HICLectureCourseView alloc]initWithFrame:CGRectMake(HIC_ScreenWidth *2, 0, HIC_ScreenWidth, HIC_ScreenHeight - 167.5 - HIC_StatusBar_Height -44.5 - HIC_BottomHeight)];
        _courseView.lecturerId = _lecturerId;
    }
    return _courseView;
}
- (HICLectureTeachCalendarView *)calendarView{
    if (!_calendarView) {
        _calendarView  = [[HICLectureTeachCalendarView alloc]initWithFrame:CGRectMake(HIC_ScreenWidth *3, 0, HIC_ScreenWidth, HIC_ScreenHeight - 167.5 - HIC_StatusBar_Height -44.5 - HIC_BottomHeight)];
        _calendarView.lecturerId = _lecturerId;
    }
    return _calendarView;
}
- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    [self createHeader];
    [self createTitleView];
    [self createContentView];
    [self getLectureData];
    [self getKnowledges];
    [self getCourseData];
//    [self getCalendarData];
}
- (void)createHeader{
    [self.view addSubview:self.topView];
    self.headerImageView = [[UIImageView alloc]initWithFrame:CGRectMake((HIC_ScreenWidth - 60) / 2, 32.5 + HIC_StatusBar_Height, 60, 60)];
    self.headerImageView.backgroundColor = [UIColor lightGrayColor];
    [self.headerBackView addSubview:self.headerImageView];
    _headerImageView.layer.cornerRadius = 4;
    _headerImageView.layer.masksToBounds = YES;
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 100 + HIC_StatusBar_Height, HIC_ScreenWidth, 28)];
    self.nameLabel.font = FONT_MEDIUM_20;
    self.nameLabel.textColor = TEXT_COLOR_DARK;
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    [self.headerBackView addSubview:self.nameLabel];
    self.label1 = [[UILabel alloc]initWithFrame:CGRectMake(HIC_ScreenWidth / 2 - 40 - 40, 132 + HIC_StatusBar_Height, 40.5, 15)];
    _label1.text = NSLocalizableString(@"groupLevel", nil);
    _label1.font = FONT_REGULAR_11;
    _label1.textColor = [UIColor colorWithHexString:@"#979797"];
    _label1.textAlignment = NSTextAlignmentCenter;
    _label1.layer.borderColor = [[UIColor colorWithHexString:@"#979797"]CGColor];
    _label1.layer.borderWidth = 0.5;
    _label1.layer.masksToBounds = YES;
    _label1.layer.cornerRadius = 1.5;
    //    label1.clipsToBounds = YES;
    [self.headerBackView addSubview:_label1];
    self.groupLevel = [[UILabel alloc]initWithFrame:CGRectMake(HIC_ScreenWidth / 2 - 37, 132 + HIC_StatusBar_Height, 40, 15)];
    self.groupLevel.textColor = TEXT_COLOR_LIGHT;
    self.groupLevel.font = FONT_REGULAR_14;
    self.groupLevel.text = NSLocalizableString(@"lecturer", nil);
    [self.headerBackView addSubview:self.groupLevel];
    self.label2 = [[UILabel alloc]initWithFrame:CGRectMake(HIC_ScreenWidth / 2 + 5, 132 + HIC_StatusBar_Height, 40.5, 15)];
    _label2.text = NSLocalizableString(@"corporateLevel", nil);
    _label2.font = FONT_REGULAR_11;
    _label2.textColor = [UIColor colorWithHexString:@"#979797"];
    _label2.textAlignment = NSTextAlignmentCenter;
    _label2.layer.borderColor = [[UIColor colorWithHexString:@"#979797"]CGColor];
    _label2.layer.borderWidth = 0.5;
    _label2.layer.masksToBounds = YES;
    _label2.layer.cornerRadius = 1.5;
    [self.headerBackView addSubview:_label2];
    self.companyLevel = [[UILabel alloc]initWithFrame:CGRectMake(HIC_ScreenWidth / 2 + 50, 132 + HIC_StatusBar_Height, 100, 15)];
    self.companyLevel.textColor = TEXT_COLOR_LIGHT;
    self.companyLevel.font = FONT_REGULAR_14;
    self.companyLevel.text = NSLocalizableString(@"levelOne", nil);
    [self.headerBackView addSubview:self.companyLevel];
}
- (void)createContentView{
    [self.view addSubview:self.contentView];
    [self.contentView addSubview:self.lectureInductView];
    [self.contentView addSubview:self.lectureKnowledgeView];
    [self.contentView addSubview:self.courseView];
    [self.contentView addSubview:self.calendarView];

    [_contentView bringSubviewToFront:_line];
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
        btn.frame = CGRectMake( i * btnW, 4, btnW, btnH);
        [self.titleView addSubview:btn];
        [self.titleBtnArr addObject:btn];
    }
    self.underLine.backgroundColor = [UIColor colorWithHexString:@"#00BED7"];
    [self.titleView addSubview:self.underLine];
}

//返回按钮
- (void)back {
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
    [self.titleView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    self.contentView.contentOffset = CGPointMake(btn.tag * HIC_ScreenWidth, 0);
    [self setItemSelected:btn.tag];
}
- (void)setItemSelected:(NSInteger)index{
    self.selectedIndex = index;
    for (int i = 0; i < self.titleBtnArr.count; i ++) {
        UIButton *btn = self.titleBtnArr[i];
        if (btn.tag == index) {
            [btn setTitleColor:[UIColor colorWithHexString:@"#00BED7"] forState:UIControlStateNormal];
            [self.underLine setCenter:CGPointMake(btn.center.x, 42)];
        }else{
            [btn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
        }
    }
    if (index == 0) {
        [self getLectureData];
    }else if (index == 1){
        [self getKnowledges];
    }else if(index == 2){
        [self getCourseData];
    }else{
        [self getCalendarData];
    }
}
- (void)getLectureData{
    NSMutableDictionary *dic = [NSMutableDictionary new];
    //    [dic setValue:@17 forKey:@"lecturerId"];
    if ([NSString isValidStr:[NSString stringWithFormat:@"%ld",(long)_lecturerId]]) {
        [dic setValue:[NSNumber numberWithInteger:_lecturerId] forKey:@"lecturerId"];
    }
    [HICAPI getLectureDetail:dic success:^(NSDictionary * _Nonnull responseObject) {
        if ([HICCommonUtils isValidObject:responseObject[@"data"]] ) {
            self.lectureModel = [HICLectureDetailModel mj_objectWithKeyValues:responseObject[@"data"]];
            self.lectureInductView.model = self.lectureModel;
            if ([NSString isValidStr:self.lectureModel.headPortraitUrl]) {
                [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:self.lectureModel.headPortraitUrl]];
            }else{
                UILabel *label = [HICCommonUtils setHeaderFrame:CGRectMake(0, 0, self.headerImageView.width, self.headerImageView.height) andText:self.lectureModel.name];
                label.hidden = NO;
                [self.headerImageView addSubview:label];
                
            }
            self.nameLabel.text = self.lectureModel.name;
            self.groupLevel.text = self.lectureModel.groupLevel;
            self.companyLevel.text = self.lectureModel.companyLevel;
            CGSize size = [self.groupLevel.text sizeWithAttributes:@{NSFontAttributeName:self.groupLevel.font}];
            CGSize size1 = [self.companyLevel.text sizeWithAttributes:@{NSFontAttributeName:self.companyLevel.font}];
            self.groupLevel.width = size.width;
            self.companyLevel.width = size1.width;
            [self.label1 mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.view).offset((HIC_ScreenWidth - size.width  - size1.width - 91) / 2);
                make.top.equalTo(self.view).offset(134 + HIC_StatusBar_Height);
            }];
            [self.groupLevel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.offset(size.width);
                make.left.equalTo(self.label1.mas_right).offset(2);
                make.top.equalTo(self.view).offset(132 + HIC_StatusBar_Height);
            }];
            [self.label2 mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.groupLevel.mas_right).offset(2);
                make.top.equalTo(self.label1);
            }];
            [self.companyLevel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.label2.mas_right).offset(2);
                make.top.equalTo(self.groupLevel);
            }];
            
        }else{
            [self.lectureInductView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [self.lectureInductView addSubview:self.blackLabel];
            [self.lectureInductView addSubview:self.blackView];
        }
    }];
}
- (void)getKnowledges{
    NSMutableDictionary *postModel = [NSMutableDictionary new];
    [postModel setObject:[NSNumber numberWithInteger:_lecturerId] forKey:@"masterCusId"];
    __weak typeof(self) weakSelf = self;
    [HICAPI knowledgeAndCourseEnquiries:postModel success:^(NSDictionary * _Nonnull responseObject) {
        if (responseObject[@"data"]) {
            weakSelf.lectureKnowledgeView.dataArr = responseObject[@"data"][@"courseKLDList"];
            weakSelf.lectureKnowledgeView.lectureId = self.lectureModel.lectureId;
            if(weakSelf.lectureKnowledgeView.dataArr.count == 0){
                [weakSelf.lectureKnowledgeView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                [weakSelf.lectureKnowledgeView addSubview:weakSelf.blackView];
                [weakSelf.lectureKnowledgeView addSubview:weakSelf.blackLabel];
            }else{
                [weakSelf.lectureKnowledgeView reloadData];
            }
            
            if (weakSelf.lectureKnowledgeView.dataArr.count == 0 && !weakSelf.knowledgeCount) {
                return;
            }
            
            if (weakSelf.lectureKnowledgeView.dataArr.count != weakSelf.knowledgeCount.integerValue) {
                weakSelf.knowledgeCount = [NSNumber numberWithInteger:weakSelf.lectureKnowledgeView.dataArr.count];
                [weakSelf updateTitleBtnWithKnowledgeCount:[NSNumber numberWithInteger:weakSelf.lectureKnowledgeView.dataArr.count] courseCount:nil];
            }
        }
    }];
}
- (void)getCourseData{

    __weak typeof(self)weakSelf = self;
    if (!self.courseView.refreshDoneBlock) {
        [self.courseView setRefreshDoneBlock:^(BOOL isSuccess, NSInteger total) {
            if (total == 0 && !weakSelf.courseCount) {
                return;
            }
            if (weakSelf.courseCount.integerValue != total) {
                weakSelf.courseCount = [NSNumber numberWithInteger:total];
                [weakSelf updateTitleBtnWithKnowledgeCount:nil courseCount:weakSelf.courseCount];
            }
        }];
    }

    if (!self.courseView.gotoCourseDetailBlock) {
        [self.courseView setGotoCourseDetailBlock:^(NSInteger taskId) {
            // 跳转到课程详情页
            HICOfflineCourseDetailVC *ct = [[HICOfflineCourseDetailVC alloc] init];
            ct.pageType = LectureCourse;
            ct.taskId = taskId;
            [weakSelf.navigationController pushViewController:ct animated:YES];
        }];
    }

    // 网络错误
    if (!self.courseView.netErrorBlock) {
        [self.courseView setNetErrorBlock:^{
            CGRect hintFrame = CGRectMake(HIC_ScreenWidth *2, 0, HIC_ScreenWidth, HIC_ScreenHeight - 167.5 - HIC_StatusBar_Height -44.5);
            [RoleManager showErrorViewWith:weakSelf.contentView frame:hintFrame blcok:^(NSInteger type) {
                [weakSelf.courseView topRefresh];
            }];
        }];
    }


    if (!self.courseView.isDataOnceSuccess) {
//        [self.contentView.mj_header beginRefreshing];
        [self.courseView topRefresh];
    }
}
- (void)getCalendarData{

    __weak typeof(self)weakSelf = self;

    // 网络错误
    if (!self.calendarView.netErrorBlock) {
        [self.calendarView setNetErrorBlock:^{
            CGRect hintFrame = CGRectMake(HIC_ScreenWidth *3, 0, HIC_ScreenWidth, HIC_ScreenHeight - 167.5 - HIC_StatusBar_Height -44.5);
            [RoleManager showErrorViewWith:weakSelf.contentView frame:hintFrame blcok:^(NSInteger type) {
                [weakSelf.calendarView topRefresh];
            }];
        }];
    }


    if (!self.calendarView.isDataOnceSuccess) {
//        [self.calendarView.mj_header beginRefreshing];
        [self.calendarView topRefresh];
    }
}

- (void)updateTitleBtnWithKnowledgeCount:(NSNumber *)knowledgeCount courseCount:(NSNumber *)courseCount {
    if (knowledgeCount) {
        NSString *knowledgeTitle;
        if (knowledgeCount.integerValue > 0) {
            knowledgeTitle = [NSString stringWithFormat:@"%@(%ld)", NSLocalizableString(@"knowledge", nil),(long)knowledgeCount.integerValue];
        } else {
            knowledgeTitle = NSLocalizableString(@"knowledge", nil);
        }

        if (self.titleArr.count>1) {
            self.titleArr[1] = knowledgeTitle;
        }
    }
    if (courseCount) {
        NSString *courseTitle;
        if (courseCount.integerValue > 0) {
            courseTitle = [NSString stringWithFormat:@"%@(%ld)",NSLocalizableString(@"offlinePrograms", nil), (long)courseCount.integerValue];
        } else {
            courseTitle = NSLocalizableString(@"offlinePrograms", nil);
        }
        if (self.titleArr.count > 2) {
            self.titleArr[2] = courseTitle;
        }
    }

    if (self.titleArr.count > 0 && self.titleArr.count == self.titleBtnArr.count) {
        CGFloat leftPadding = 22;
        CGFloat rightPadding = 22;
        CGFloat viewW = HIC_ScreenWidth;

        NSMutableArray<NSNumber *> *titleWs = [NSMutableArray new];
        CGFloat titleWSum = 0.0;
        for (int i = 0; i < self.titleArr.count; i++) {
            NSString *title = self.titleArr[i];
            CGSize titleSize = [title sizeWithFont:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(MAXFLOAT, btnH)];
            titleWs[i] = [NSNumber numberWithFloat:titleSize.width];
            titleWSum += titleSize.width;

            id data = self.titleBtnArr[i];
            if ([data isKindOfClass:UIButton.class]) {
                UIButton *btn = (UIButton *)data;
                [btn setTitle:title forState:UIControlStateNormal];
            }
        }

        CGFloat intervalW1 = 0;
        CGFloat intervalW2 = 0;
        CGFloat intervalW3 = 0;
        if (titleWSum+leftPadding+rightPadding > viewW) {
            intervalW1 = 0;
            intervalW2 = 0;
            intervalW3 = 0;
        } else {
            intervalW1 = 0.38*(viewW - (titleWSum+leftPadding+rightPadding));
            intervalW2 = 0.31*(viewW - (titleWSum+leftPadding+rightPadding));
            intervalW3 = 0.31*(viewW - (titleWSum+leftPadding+rightPadding));
        }

        CGFloat leftX = leftPadding;
        for (int i = 0; i < self.titleArr.count; i++) {
            id data = self.titleBtnArr[i];
            if ([data isKindOfClass:UIButton.class]) {
                UIButton *btn = (UIButton *)data;
                btn.frame = CGRectMake(leftX, 4, titleWs[i].floatValue, btnH);
                if (i == 0) {
                    leftX = CGRectGetMaxX(btn.frame)+intervalW1;
                }
                if (i == 1) {
                    leftX = CGRectGetMaxX(btn.frame)+intervalW2;
                }
                if (i == 2) {
                    leftX = CGRectGetMaxX(btn.frame)+intervalW3;
                }

            }
        }

        for (int i = 0; i < self.titleBtnArr.count; i ++) {
            UIButton *btn = self.titleBtnArr[i];
            if (btn.tag == self.selectedIndex) {
                [self.underLine setCenter:CGPointMake(btn.center.x, 42.25)];
            }
        }

    }

}

#pragma mark -scrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat offSetX = scrollView.contentOffset.x;
    NSInteger pageNum = offSetX / HIC_ScreenWidth;
    [self setItemSelected:pageNum];
}
@end
