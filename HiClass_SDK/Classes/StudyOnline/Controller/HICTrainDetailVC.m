//
//  HICTrainDetailVC.m
//  HiClass
//
//  Created by WorkOffice on 2020/3/4.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICTrainDetailVC.h"
#import "HICTrainDetailBaseModel.h"
#import "HICTrainDetailListModel.h"
#import "HICTrainDetailCell.h"
#import "HICDetailShareVC.h"
#import "HICKnowledgeDetailVC.h"
#import "HICLessonsVC.h"
#import "HICExamCenterDetailVC.h"
#import "HICTrainQuestionVC.h"
#import "HICHomeworkListVC.h"
#import "HICBaseMaskView.h"
#import "HomeTaskCenterDefaultView.h"
#import "HICPushCustoWebVC.h"
#import "HICSyncProgressPopview.h"

static NSString *TrainListCell = @"TrainListCell";
@interface HICTrainDetailVC ()<UITableViewDelegate,UITableViewDataSource,HICTrainDetailDelegate,HICBaseMaskViewDelegate>
@property (nonatomic, strong)UIView *headerView;
@property (nonatomic, strong)UILabel *trainNameLabel;//
@property (nonatomic, strong)UILabel *trainTimeLabel;//
@property (nonatomic, strong)UILabel *trainAssigorLabel;//
@property (nonatomic, strong)UILabel *trainChargeLabel;//
@property (nonatomic, strong)UIView *cardView;
@property (nonatomic, strong)UILabel *progressLabel;
@property (nonatomic, strong)UIProgressView *progressView;
@property (nonatomic, strong)UILabel *totalScoreLabel;
@property (nonatomic, strong)UILabel *scoreLabel;
@property (nonatomic, strong)UILabel *rankLabel;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *listArr;
@property (nonatomic ,assign)CGFloat cellHeight;
@property (nonatomic ,strong)NSIndexPath *indexPath;
@property (nonatomic ,strong)NSMutableArray *heightArr;
@property (nonatomic, strong)NSMutableArray *showArr;
@property (nonatomic ,strong)HICNetModel *netModel;
@property (nonatomic ,strong)HICTrainDetailBaseModel *baseModel;
@property (nonatomic ,strong)UIView *moreView;
@property (nonatomic ,assign)BOOL isFirst;
@property (nonatomic ,assign)NSInteger firstHeight;
@property (nonatomic ,strong)HICBaseMaskView *maskView;
@property (nonatomic ,strong)UIScrollView *descView;
@property (nonatomic ,strong)UILabel *contentLabel;
@property (nonatomic ,strong)UILabel *contentLabelLong;
@property (nonatomic ,strong)UIButton *extensionBtn;
@property (nonatomic ,strong)UIView *contentView;
@property (nonatomic ,strong)UIView *middleView;
@property (nonatomic ,strong)UIView *line2;
@property (nonatomic ,strong)UIView *bottomView;
@property (nonatomic ,strong)UILabel *bottomLabel;
@property (nonatomic ,strong)UILabel *middleLabel;
@property (nonatomic ,strong)UILabel *middleTitle;
@property (nonatomic ,strong)UILabel *bottomContent;
@property (nonatomic ,strong)UIView *line3;
@property (nonatomic ,strong)UIView *certiView;
@property (nonatomic ,strong)UILabel *certiLabel;
@property (nonatomic ,strong)UILabel *certiScoreLabel;
@property (nonatomic ,strong)UILabel *certiHourLabel;
@property (nonatomic ,strong)UILabel *pointsLabel;
@property (nonatomic ,strong)UILabel *certiTitleLabel;
@property (nonatomic ,strong)UIView *certiContent;
@property (nonatomic ,strong)NSMutableArray *certiArr;
@property (nonatomic ,assign)BOOL isStart;
@property (nonatomic, assign)NSInteger trainTerminated;
@property (nonatomic, strong)NSNumber *rankNum;
@property (nonatomic ,strong)UIImageView *headerBackView;
/// 给岗位地图使用的缺省页面
@property (nonatomic, strong) HomeTaskCenterDefaultView *defaultView;
@end

@implementation HICTrainDetailVC
#pragma mark ---lazyload
- (HomeTaskCenterDefaultView *)defaultView {
    if (!_defaultView) {
        CGFloat top = self.isMapPush ? 0:291 + HIC_StatusBar_Height;
        CGFloat height = self.isMapPush ? HIC_ScreenHeight - HIC_StatusBar_Height-44-44-HIC_BottomHeight:HIC_ScreenHeight - 291 - HIC_StatusBar_Height;
        _defaultView = [[HomeTaskCenterDefaultView alloc] initWithFrame:CGRectMake(0, top, HIC_ScreenWidth, height)];
        _defaultView.titleStr = NSLocalizableString(@"noContent", nil);
    }
    return _defaultView;
}
- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, HIC_ScreenWidth, 206)];
    }
    return _headerView;
}
- (HICBaseMaskView *)maskView  {
    if (!_maskView) {
        _maskView = [[HICBaseMaskView alloc]initWithTitle:NSLocalizableString(@"trainingIntroduction", nil)];
        _maskView.maskDelegate = self;
    }
    return _maskView;
}
- (UIScrollView *)descView {
    if (!_descView) {
        _descView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,102 + HIC_StatusBar_Height, HIC_ScreenWidth, HIC_ScreenHeight - 102 - HIC_StatusBar_Height)];
    }
    return _descView;
}
- (UITableView *)tableView {
    if (!_tableView) {
        CGFloat top = self.isMapPush ? 0:0;
        CGFloat height = self.isMapPush ? HIC_ScreenHeight - HIC_StatusBar_Height-44-44-HIC_BottomHeight:HIC_ScreenHeight - HIC_BottomHeight;
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, top, HIC_ScreenWidth, height) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.separatorColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = UIColor.whiteColor;
        [_tableView registerClass:[HICTrainDetailCell class] forCellReuseIdentifier:TrainListCell];
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0;
        }
    }
    return _tableView;
}
- (UIView *)moreView {
    if (!_moreView) {
        _moreView = [[UIView alloc]initWithFrame:CGRectMake(HIC_ScreenWidth - 16 - 113 - 12,44 + HIC_StatusBar_Height, 113, 150)];
        _moreView.backgroundColor = [UIColor whiteColor];
        _moreView.layer.cornerRadius = 3;
        _moreView.layer.shadowRadius = 3;
        _moreView.layer.shadowColor = [UIColor blackColor].CGColor;
        _moreView.clipsToBounds = YES;
        _moreView.layer.shadowOpacity = 0.1;
        _moreView.layer.shadowOffset = CGSizeZero;
        NSArray *arr = @[NSLocalizableString(@"synchronousProgress", nil),NSLocalizableString(@"taskDescription", nil),NSLocalizableString(@"shareRanking", nil)];
        for (int i = 0; i < arr.count; i ++) {
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 50 *i, 113, 50)];
            [btn setTitle:arr[i] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(moreInClick:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = 20000 + i;
            [btn setTitleColor:TEXT_COLOR_DARK forState:UIControlStateNormal];
            btn.titleLabel.textAlignment = NSTextAlignmentCenter;
            btn.titleLabel.font = FONT_MEDIUM_16;
            [_moreView addSubview:btn];
            [btn setTitleColor:[UIColor colorWithHexString:@"#e6e6e6"] forState:UIControlStateDisabled];
        }
        UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 50, 113, 0.5)];
        line1.backgroundColor = [UIColor colorWithHexString:@"#E6E6E6"];
        [_moreView addSubview:line1];
        UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, 100, 113, 0.5)];
        line2.backgroundColor = [UIColor colorWithHexString:@"#E6E6E6"];
        [_moreView addSubview:line2];
    }
    return _moreView;
}
- (NSMutableArray *)heightArr {
    if (!_heightArr) {
        _heightArr = [NSMutableArray new];
    }
    return _heightArr;
}
- (NSMutableArray *)showArr {
    if (!_showArr) {
        _showArr =[NSMutableArray new];
    }
    return _showArr;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_isMapPush) {
        [self initListData];
    } else {
        self.navigationController.navigationBar.hidden = YES;
        [self initBaseData];
        [self initListData];
    }
    DDLogDebug(@"dsaukgdhjkasgdaks%@",USER_CID);
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (!_isMapPush) {
        self.navigationController.navigationBar.hidden = NO;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.firstHeight = 0;
    self.rankNum = @0;
    self.isFirst = YES;
    
    if (self.isMapPush) {
        [self createTableView];
    } else {
        [self createHeader];
        [self createTableView];
        [self createNavView];
        [self createDescView];
        if (@available(iOS 13.0, *)) {
            self.tableView.automaticallyAdjustsScrollIndicatorInsets = NO;
        } else {
            // Fallback on earlier versions
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        self.tableView.contentInset = UIEdgeInsetsMake(-HIC_StatusBar_Height, 0, 0, 0);
    }
}

- (void)createNavView {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, HIC_ScreenWidth, HIC_StatusBar_Height + 44)];
    imageView.userInteractionEnabled = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.layer.masksToBounds = YES;
    UIImageView *backImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, HIC_ScreenWidth, 206 + HIC_StatusBar_Height)];
    [backImage setImage:[UIImage imageNamed:@"头部背景"]];
    [imageView addSubview:backImage];
    UIButton *backbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    backbutton.frame = CGRectMake(16, 11 + HIC_StatusBar_Height, 12, 22);
    [backbutton hicChangeButtonClickLength:30];
    [backbutton setImage:[UIImage imageNamed:@"头部-返回-白色"] forState:UIControlStateNormal];
    [backbutton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:backbutton];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10 + HIC_StatusBar_Height, HIC_ScreenWidth, 25)];
    titleLabel.text = NSLocalizableString(@"trainingDetails", nil);
    titleLabel.textColor = UIColor.whiteColor;
    titleLabel.font = FONT_MEDIUM_18;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [imageView addSubview:titleLabel];
    
    UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [moreBtn setImage:[UIImage imageNamed:@"头部-更多"] forState:UIControlStateNormal];
    moreBtn.frame = CGRectMake(HIC_ScreenWidth - 16 - 12, 11 + HIC_StatusBar_Height, 12, 22);
    [moreBtn hicChangeButtonClickLength:30];
    moreBtn.tag = 100000;
    [moreBtn addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:moreBtn];
    [self.view addSubview:self.moreView];
    self.moreView.hidden = YES;
    [self.view addSubview:imageView];
}

- (void)createHeader {
    self.view.backgroundColor = [UIColor whiteColor];
    //    [self.view addSubview:self.headerView];
    
    self.headerBackView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, HIC_ScreenWidth, 206 + HIC_StatusBar_Height)];
    UIImage *headImage = [UIImage imageNamed:@"头部背景"];
    self.headerBackView.userInteractionEnabled = YES;
    self.headerBackView.image = headImage;
    //    self.headerBackView = imageView;
    [self.headerView addSubview:self.headerBackView];
    
    self.trainNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 76 + HIC_Status_Phase_Height, HIC_ScreenWidth - 24, 25)];
    self.trainNameLabel.textColor = [UIColor whiteColor];
    self.trainNameLabel.font = FONT_REGULAR_18;
    [self.headerView addSubview:self.trainNameLabel];
    
    self.trainTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 105+ HIC_Status_Phase_Height, HIC_ScreenWidth - 24, 22)];
    self.trainTimeLabel.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.9/1.0];
    self.trainTimeLabel.font = FONT_REGULAR_14_half;
    [self.headerView addSubview:self.trainTimeLabel];
    self.trainAssigorLabel = [[UILabel alloc]init];
    [self.headerView addSubview:self.trainAssigorLabel];
    [self.trainAssigorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.trainTimeLabel.mas_bottom);
        make.left.equalTo(self.trainTimeLabel);
        make.right.equalTo(self.trainTimeLabel);
    }];
    self.trainAssigorLabel.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.9/1.0];
    self.trainAssigorLabel.numberOfLines = 2;
    self.trainAssigorLabel.font = FONT_REGULAR_14_half;
 
    self.cardView = [[UIView alloc]initWithFrame:CGRectMake(12, 162 + HIC_Status_Phase_Height, HIC_ScreenWidth - 24, 126)];
    self.cardView.backgroundColor = [UIColor whiteColor];
    self.cardView.alpha = 0.95;
    self.cardView.layer.cornerRadius = 6.0;
    self.cardView.layer.shadowRadius = 6.0;
    self.cardView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.cardView.layer.shadowOpacity = 0.1;
    self.cardView.layer.shadowOffset = CGSizeZero;
    
    [self.headerBackView addSubview:self.cardView];
    self.progressLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 22, 110, 21)];
    self.progressLabel.textColor = TEXT_COLOR_DARK;
    self.progressLabel.font = FONT_MEDIUM_15;
    [self.cardView addSubview:self.progressLabel];
    
    self.progressView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
    self.progressView.progressTintColor = [UIColor colorWithHexString:@"#00BED7"];
    self.progressView.backgroundColor = [UIColor colorWithHexString:@"#e9e9e9"];
    self.progressView.layer.cornerRadius = 4;
    self.progressView.clipsToBounds = YES;
    [self.cardView addSubview:self.progressView];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.progressLabel.mas_right).offset(11);
        make.top.equalTo(self.cardView).offset(28.5);
        make.right.equalTo(self.cardView).offset(-16);
        make.height.offset(8);
    }];
    CGFloat labelH = self.cardView.frame.size.width/3;
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(0,67.5, labelH, 18.5)];
    label1.text = NSLocalizableString(@"allCredits", nil);
    label1.textColor = TEXT_COLOR_LIGHTM;
    label1.font = FONT_REGULAR_14;
    label1.textAlignment = NSTextAlignmentCenter;
    [self.cardView addSubview:label1];
    self.totalScoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,86, labelH, 28)];
    self.totalScoreLabel.textColor = TEXT_COLOR_DARK;
    self.totalScoreLabel.font = FONT_REGULAR_15;
    self.totalScoreLabel.textAlignment = NSTextAlignmentCenter;
    self.totalScoreLabel.text = @"3.9";
    [self.cardView addSubview:self.totalScoreLabel];
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(labelH, 72, 0.5, 36)];
    line1.backgroundColor = [UIColor colorWithHexString:@"#DCDCDC"];
    [self.cardView addSubview:line1];
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(labelH,67.5, labelH, 18.5)];
    label2.text = NSLocalizableString(@"getCredits", nil);
    label2.textColor = TEXT_COLOR_LIGHTM;
    label2.font = FONT_REGULAR_14;
    label2.textAlignment = NSTextAlignmentCenter;
    [self.cardView addSubview:label2];
    self.scoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(labelH,86, labelH, 28)];
    self.scoreLabel.textColor = TEXT_COLOR_DARK;
    self.scoreLabel.font = FONT_REGULAR_15;
    self.scoreLabel.textAlignment = NSTextAlignmentCenter;
    self.scoreLabel.text = @"1.0";
    [self.cardView addSubview:self.scoreLabel];
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(labelH *2, 72, 0.5, 36)];
    line2.backgroundColor = [UIColor colorWithHexString:@"#DCDCDC"];
    [self.cardView addSubview:line2];
    UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(labelH *2,67.5, labelH, 18.5)];
    label3.text = NSLocalizableString(@"currentRanking", nil);
    label3.textColor = TEXT_COLOR_LIGHTM;
    label3.font = FONT_REGULAR_14;
    label3.textAlignment = NSTextAlignmentCenter;
    [self.cardView addSubview:label3];
    self.rankLabel = [[UILabel alloc]initWithFrame:CGRectMake(labelH *2,86, labelH, 28)];
    self.rankLabel.textColor = TEXT_COLOR_DARK;
    self.rankLabel.font = FONT_REGULAR_15;
    self.rankLabel.textAlignment = NSTextAlignmentCenter;
    self.rankLabel.text = @"2/100";
    [self.cardView addSubview:self.rankLabel];
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableHeaderView.height += 100;
}
- (void)createDescView{
    self.descView.backgroundColor = [UIColor whiteColor];
    self.contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, HIC_ScreenWidth, 100)];
    [self.descView addSubview:self.contentView];

    UILabel *contentTitle = [[UILabel alloc]initWithFrame:CGRectMake(16, 16, HIC_ScreenWidth - 32, 22.5)];
    contentTitle.text = NSLocalizableString(@"trainingDescription", nil);
    contentTitle.font = FONT_MEDIUM_17;
    contentTitle.textColor = TEXT_COLOR_DARK;
    [self.contentView addSubview:contentTitle];
    self.contentLabel = [[UILabel alloc]init];
    self.contentLabel.font = FONT_REGULAR_14;
    self.contentLabel.textColor = TEXT_COLOR_LIGHT;
    self.contentLabel.numberOfLines = 3;
    [self.contentView addSubview:self.contentLabel];
    self.contentLabel.hidden = NO;
    self.contentLabelLong = [[UILabel alloc]init];
    self.contentLabelLong.numberOfLines = 0;
    self.contentLabelLong.font = FONT_REGULAR_14;
    self.contentLabelLong.textColor = TEXT_COLOR_LIGHT;
    [self.contentView addSubview:self.contentLabelLong];
    self.contentLabelLong.hidden = YES;
    self.extensionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.extensionBtn.titleLabel.font = FONT_REGULAR_14;
    [self.extensionBtn setTitle:NSLocalizableString(@"develop", nil) forState:UIControlStateNormal];
    [self.extensionBtn setTitleColor:[UIColor colorWithHexString:@"#00BED7"] forState:UIControlStateNormal];
    [self.extensionBtn addTarget:self action:@selector(extensionBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.extensionBtn];
    self.extensionBtn.hidden = YES;
    self.middleView = [[UIView alloc]init];
    [self.descView addSubview:self.middleView];
    //    self.middleView.backgroundColor = UIColor.redColor;
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(16, 0, HIC_ScreenWidth - 32, 0.5)];
    line1.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6"];
    [self.middleView addSubview:line1];
    self.middleTitle = [[UILabel alloc]init];
    self.middleTitle.text = NSLocalizableString(@"trainingObjectives", nil);
    self.middleTitle.font = FONT_MEDIUM_17;
    self.middleTitle.textColor = TEXT_COLOR_DARK;
    [self.middleView addSubview:self.middleTitle];
    self.middleLabel = [[UILabel alloc]init];
    self.middleLabel.numberOfLines = 0;
    self.middleLabel.font = FONT_REGULAR_14;
    self.middleLabel.textColor = TEXT_COLOR_LIGHT;
    [self.middleView addSubview:self.middleLabel];
    self.line2 = [[UIView alloc]init];
    self.line2.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6"];
    [self.middleView addSubview:self.line2];
    
    self.bottomView = [[UIView alloc]init];
    [self.descView addSubview:self.bottomView];
    self.bottomLabel = [[UILabel alloc]init];
    self.bottomLabel.text = NSLocalizableString(@"trainingObject", nil);
    self.bottomLabel.font = FONT_MEDIUM_17;
    self.bottomLabel.textColor = TEXT_COLOR_DARK;
    [self.bottomView addSubview:self.bottomLabel];
    self.bottomContent = [[UILabel alloc]init];
    self.bottomContent.numberOfLines = 0;
    self.bottomContent.font = FONT_REGULAR_14;
    self.bottomContent.textColor = TEXT_COLOR_LIGHT;
    [self.bottomView addSubview:self.bottomContent];
    [self.maskView addSubview:self.descView];
    
    self.line3 = [[UIView alloc]init];
    self.line3.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6"];
    [self.middleView addSubview:self.line3];
    self.certiView = [[UIView alloc]init];
    [self.bottomView addSubview:self.certiView];
    
    self.certiLabel = [[UILabel alloc]init];
    self.certiLabel.text = NSLocalizableString(@"trainingReward", nil);
    self.certiLabel.font = FONT_MEDIUM_17;
    self.certiLabel.textColor = TEXT_COLOR_DARK;
    [self.certiView addSubview:self.certiLabel];
    self.certiScoreLabel = [[UILabel alloc]init];
    self.certiScoreLabel.font = FONT_REGULAR_14;
    self.certiScoreLabel.textColor = TEXT_COLOR_LIGHT;
    [self.certiView addSubview:self.certiScoreLabel];
    self.certiHourLabel = [[UILabel alloc]init];
    self.certiHourLabel.font = FONT_REGULAR_14;
    self.certiHourLabel.textColor = TEXT_COLOR_LIGHT;
    
    self.pointsLabel = [[UILabel alloc]init];
    self.pointsLabel.font = FONT_REGULAR_14;
    self.pointsLabel.textColor = TEXT_COLOR_LIGHT;
    [self.certiView addSubview:self.pointsLabel];
    
    [self.certiView addSubview:self.certiHourLabel];
    self.certiContent = [[UIView alloc]init];
    [self.contentView addSubview:self.certiContent];
    self.certiTitleLabel = [[UILabel alloc]init];
    self.certiTitleLabel.font = FONT_REGULAR_14;
    self.certiTitleLabel.textColor = TEXT_COLOR_LIGHT;
    self.certiTitleLabel.text = [NSString stringWithFormat:@"%@: ",NSLocalizableString(@"certificate", nil)];
    [self.certiContent addSubview:self.certiTitleLabel];
    
    [self updateConstraints];
}
- (void)extensionBtnClick{
    if ([self.extensionBtn.titleLabel.text isEqualToString:NSLocalizableString(@"develop", nil)]) {
        [self.extensionBtn setTitle:NSLocalizableString(@"packUp", nil) forState:UIControlStateNormal];
        self.contentLabelLong.hidden = NO;
        self.contentView.frame = CGRectMake(0, 0, HIC_ScreenWidth, [self getContentHeight:self.contentLabelLong.text] + 16 + 34 + 30);
        self.contentLabel.hidden = YES;
        
    }else{
        [self.extensionBtn setTitle:NSLocalizableString(@"develop", nil) forState:UIControlStateNormal];
        self.contentLabel.hidden = NO;
        self.contentView.frame = CGRectMake(0, 0, HIC_ScreenWidth, 60 + 16 + 34 + 30);
        self.contentLabelLong.hidden = YES;
    }
    [self updateConstraints];
}
- (void)updateConstraints{
    [self.contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(50.5);
        make.left.equalTo(self.contentView).offset(16);
        make.width.offset(HIC_ScreenWidth - 32);
    }];
    
    [self.contentLabelLong mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(50.5);
        make.left.equalTo(self.contentView).offset(16);
        make.width.offset(HIC_ScreenWidth - 32);
    }];
    [self.extensionBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(16);
        make.height.offset(30);
        make.bottom.equalTo(self.contentView).offset(-5);
    }];
    [self.middleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_bottom);
        make.left.equalTo(self.contentView);
        make.width.offset(HIC_ScreenWidth);
    }];
    [self.middleTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.middleView).offset(12);
        make.left.equalTo(self.middleView).offset(16);
        make.width.offset(HIC_ScreenWidth -32);
    }];
    [self.middleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.middleView).offset(50.5);
        make.left.equalTo(self.middleView).offset(16);
        make.width.offset(HIC_ScreenWidth - 32);
    }];
    [self.line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.middleView).offset(16);
        make.top.equalTo(self.middleLabel.mas_bottom).offset(16);
        make.width.offset(HIC_ScreenWidth - 32);
        make.height.offset(0.5);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line2.mas_bottom);
        make.left.equalTo(self.middleView);
        make.width.offset(HIC_ScreenWidth);
    }];
    [self.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomView).offset(16);
        make.left.equalTo(self.bottomView).offset(16);
        make.width.offset(HIC_ScreenWidth - 32);
    }];
    [self.bottomContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomLabel.mas_bottom).offset(16);
        make.left.equalTo(self.bottomLabel);
        make.width.offset(HIC_ScreenWidth - 32);
    }];
    [self.line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomView).offset(16);
        make.top.equalTo(self.bottomContent.mas_bottom).offset(16);
        make.width.offset(HIC_ScreenWidth - 32);
        make.height.offset(0.5);
    }];
    [self.certiView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line3.mas_bottom);
        make.left.equalTo(self.middleView);
        make.width.offset(HIC_ScreenWidth);
    }];
    [self.certiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.certiView).offset(16);
        make.left.equalTo(self.certiView).offset(16);
        make.width.offset(HIC_ScreenWidth - 32);
    }];
    [self.certiScoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.certiLabel.mas_bottom).offset(16);
        make.left.equalTo(self.certiLabel);
        make.width.offset(HIC_ScreenWidth - 32);
    }];
    [self.certiHourLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.certiScoreLabel.mas_bottom).offset(16);
        make.left.equalTo(self.certiScoreLabel);
        make.width.offset(HIC_ScreenWidth - 32);
    }];
    [self.pointsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.certiHourLabel.mas_bottom).offset(16);
        make.left.equalTo(self.certiScoreLabel);
        make.width.offset(HIC_ScreenWidth - 32);
    }];
    [self.certiContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.pointsLabel.mas_bottom).offset(16);
        make.left.equalTo(self.certiScoreLabel);
        make.width.offset(HIC_ScreenWidth - 32);
    }];
    [self.certiTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.certiContent);
        make.left.equalTo(self.certiScoreLabel);
        make.width.offset(40);
    }];

}
- (void)createTableView{
    [self.view addSubview:self.tableView];
}
///培详情训基本信息请求
- (void)initBaseData {
    [HICAPI getRightAlertLoadData:_trainId success:^(NSDictionary * _Nonnull responseObject) {
        self.baseModel = [HICTrainDetailBaseModel mj_objectWithKeyValues:responseObject[@"data"]];
        [self showSyncProgressToast];
        if (!self.isMapPush) {
            self.trainNameLabel.text = self.baseModel.trainName;
            self.trainTimeLabel.text = [NSString stringWithFormat:@"%@: %@",NSLocalizableString(@"trainingTime", nil),[HICCommonUtils returnReadableTimeZoneWithStartTime:self.baseModel.startTime andEndTime:self.baseModel.endTime]];
            NSString *assginText = [NSString isValidStr:self.baseModel.assigner] ? self.baseModel.assigner : @"-";
            self.trainAssigorLabel.text = [NSString stringWithFormat:@"%@:%@", NSLocalizableString(@"leadingCadre", nil),[NSString isValidStr:self.baseModel.leaderNames] ? self.baseModel.leaderNames : assginText];
            CGFloat textH = [HICCommonUtils returnLabelHeightWithStr:self.trainAssigorLabel.text font:14.5 andWidth:HIC_ScreenWidth - 24 andNumberOfLine:2 fontIsRegular:YES];
            if (textH > 25) {
                [self.headerView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.offset(228 + HIC_StatusBar_Height);
                }];
                [self.headerBackView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.offset(228+ HIC_StatusBar_Height);
                    make.width.offset(HIC_ScreenWidth);
                }];
                [self.cardView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.headerView).offset(182 + HIC_Status_Phase_Height);
                    make.left.equalTo(self.headerView).offset(12);
                    make.height.offset(126);
                    make.width.offset(HIC_ScreenWidth - 24);
                }];
                self.tableView.tableHeaderView.height += 22;
            }
            
            NSString *per = @"%";
            self.progressLabel.text = [NSString stringWithFormat:@"%@%@%@",NSLocalizableString(@"learningProcess", nil),[HICCommonUtils formatFloat:self.baseModel.progress],per];
            self.progressView.progress = self.baseModel.progress /100;
            if (self.baseModel.totalCredit == 0) {
                self.totalScoreLabel.text = @"-";
            } else {
                self.totalScoreLabel.text = [HICCommonUtils formatFloat:self.baseModel.totalCredit];
            }
            self.certiScoreLabel.text = [NSString stringWithFormat:@"%@: %@",NSLocalizableString(@"credits", nil),self.totalScoreLabel.text];
            if (self.baseModel.points.integerValue > 0) {
                self.pointsLabel.text = HICLocalizedFormatString(@"rewardPoints", self.baseModel.points.integerValue);
            }
            self.pointsLabel.hidden = self.baseModel.points.integerValue <= 0;
            [self.certiContent mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.pointsLabel.hidden ? self.certiHourLabel.mas_bottom :  self.pointsLabel.mas_bottom).offset(16);
            }];
            if (self.baseModel.totalCreditHours ) {
                self.certiHourLabel.text = [NSString stringWithFormat:@"%@: %@",NSLocalizableString(@"studyTime", nil),self.baseModel.totalCreditHours];
            } else {
                self.certiHourLabel.text = [NSString stringWithFormat:@"%@:-",NSLocalizableString(@"studyTime", nil)];
            }
            if (self.baseModel.completedCredit == 0) {
                self.scoreLabel.text = @"-";
            } else {
                self.scoreLabel.text = [HICCommonUtils formatFloat: self.baseModel.completedCredit];
            }
            self.rankLabel.text = [NSString stringWithFormat:@"-/%ld",(long)self.baseModel.totalNum];
            [self initRankData];
            [self initCertData];
            if ([NSString isValidStr:self.baseModel.trainComment]) {
                self.contentLabel.text = self.baseModel.trainComment;
                self.contentLabelLong.text = self.baseModel.trainComment;
                if ( [self getContentHeight:self.baseModel.trainComment] > 60) {
                    self.extensionBtn.hidden = NO;
                    self.contentView.frame = CGRectMake(0, 0, HIC_ScreenWidth, 60 + 34 + 50);
                }else{
                    self.extensionBtn.hidden = YES;
                    self.contentView.frame = CGRectMake(0, 0, HIC_ScreenWidth, [self getContentHeight:self.baseModel.trainComment] + 12 + 50);
                }
                [self updateConstraints];
            } else {
                self.contentLabel.text = NSLocalizableString(@"noNow", nil);
            }
            if ([NSString isValidStr:self.baseModel.trainGoal]) {
                self.middleLabel.text  = self.baseModel.trainGoal;
            } else {
                self.middleLabel.text  = NSLocalizableString(@"noNow", nil);
            }
            if ([NSString isValidStr:self.baseModel.trainAudience]) {
                self.bottomContent.text  = self.baseModel.trainAudience;
            } else {
                self.bottomContent.text  = NSLocalizableString(@"noNow", nil);
            }
            
            if (self.baseModel.status == HICTrainWait) {//待开始
                // 当前不需要同步进度
                UIButton *sysBut = [self.moreView viewWithTag:20000];
                sysBut.enabled = NO;
                
                UIButton *shareBtn = [self.moreView viewWithTag:20002];
                shareBtn.enabled = NO;
                
            }
            self.descView.contentSize = CGSizeMake(HIC_ScreenWidth, 24*4 + 43*4 + [self getContentHeight:self.middleLabel.text] + [self getContentHeight:self.contentLabelLong.text] + [self getContentHeight:self.bottomLabel.text]+20+HIC_BottomHeight + 40 + 20 + 32);
        }
    }];
}
///排名数据请求
- (void)initRankData{
    [HICAPI traineesRanking:_trainId success:^(NSDictionary * _Nonnull responseObject) {
        if (responseObject) {
            if ([responseObject[@"data"] isKindOfClass:NSString.class]) {
                if ([NSString isValidStr:responseObject[@"data"]]) {
                    self.rankLabel.text = [NSString stringWithFormat:@"%@/%ld",responseObject[@"data"],(long)self.baseModel.totalNum];
                }
            } else {
                if (![responseObject[@"data"] isEqual:@0]) {
                    self.rankLabel.text = [NSString stringWithFormat:@"%@/%ld",responseObject[@"data"],(long)self.baseModel.totalNum];
                    self.rankNum = responseObject[@"data"];
                }
                if (self.baseModel.syncProgress != 1 ) {
                    for (UIButton *but in self.moreView.subviews) {
                        if (but.tag == 20000) {
                            but.frame = CGRectMake(0, 0, 0, 0);
                            but.hidden = YES;
                        }else if (but.tag == 20001) {
                            but.Y = 0;
                        }else if (but.tag == 20002) {
                            but.Y = but.height;
                        }
                    }
                    self.moreView.height = 100;
                }
            }
        }
    }];
}
///证书数据请求
- (void)initCertData{
    [HICAPI loadDataCer:_trainId success:^(NSDictionary * _Nonnull responseObject) {
        if (responseObject) {
            if ([[responseObject valueForKey:@"data"] isKindOfClass:[NSArray class]]) {
                NSArray * rr = [NSArray arrayWithArray:[responseObject valueForKey:@"data"]];
                if (rr.count > 0) {
                    for (int i = 0; i < rr.count; i++) {
                        HICTrainCertificateModel *model = [HICTrainCertificateModel mj_objectWithKeyValues:rr[i]];
                        UILabel *certlabel = [[UILabel alloc]initWithFrame:CGRectMake(40, i *20, HIC_ScreenWidth - 100, 20)];
                        certlabel.text = model.name;
                        certlabel.font = FONT_REGULAR_14;
                        certlabel.textColor = TEXT_COLOR_LIGHT;
                        [self.certiContent addSubview:certlabel];
                        [self.certiArr addObject:model];
                    }
                }else{
                    UILabel *certlabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 0, HIC_ScreenWidth - 100, 20)];
                    certlabel.text = @"-";
                    certlabel.font = FONT_REGULAR_14;
                    certlabel.textColor = TEXT_COLOR_LIGHT;
                    [self.certiContent addSubview:certlabel];
                }
            }
            self.descView.contentSize = CGSizeMake(HIC_ScreenWidth, 24*4 + 43*4 + [self getContentHeight:self.middleLabel.text] + [self getContentHeight:self.contentLabelLong.text] + [self getContentHeight:self.bottomLabel.text]+20+HIC_BottomHeight + 40 + 20 * (self.certiArr.count == 0 ? 1 : self.certiArr.count) + 32);
        }
    } failure:^(NSError * _Nonnull error) {
        UILabel *certlabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 0, HIC_ScreenWidth - 100, 20)];
        certlabel.text = @"-";
        certlabel.font = FONT_REGULAR_14;
        certlabel.textColor = TEXT_COLOR_LIGHT;
        [self.certiContent addSubview:certlabel];
        self.descView.contentSize = CGSizeMake(HIC_ScreenWidth, 24*4 + 43*4 + [self getContentHeight:self.middleLabel.text] + [self getContentHeight:self.contentLabelLong.text] + [self getContentHeight:self.bottomLabel.text]+20+HIC_BottomHeight + 40 + 20 + 48);
    }];
}
- (CGFloat)getContentHeight:(NSString *)str {
    UILabel *label = [[UILabel alloc] init];
    label.text = str;
    label.font = FONT_REGULAR_14;
    label.numberOfLines = 0;
    CGFloat labelHeight = [HICCommonUtils sizeOfString:str stringWidthBounding:HIC_ScreenWidth - 32 font:14 stringOnBtn:NO fontIsRegular:YES].height;
    label.frame = CGRectMake(0, 0, HIC_ScreenWidth - 32, labelHeight);
    [label sizeToFit];
    return label.frame.size.height;
}
///列表数据请求
- (void)initListData {
    [HICAPI trainingTaskList:_trainId success:^(NSDictionary * _Nonnull responseObject) {
        if (responseObject[@"data"] && [responseObject[@"data"] isKindOfClass:NSArray.class]) {
            self.listArr = [NSMutableArray arrayWithArray:responseObject[@"data"]];
            NSString *str;
            if (self.listArr.count == 0 && self.isMapPush) {
                [self.view addSubview:self.defaultView];
            }
            if (self.listArr.count == 0) {
                return ;
            }
            
            HICTrainDetailListModel *model = [HICTrainDetailListModel mj_objectWithKeyValues:self.listArr[0]];
            self.firstHeight = model.stageActionList.count *88 + 16;
            
            for (int i = 0; i  < self.listArr.count; i ++) {
                if (i == 0) {
                    str = @"yes";
                    [self.showArr addObject:str];
                }else{
                    str = @"no";
                    [self.showArr addObject:str];
                }
                if (self.heightArr.count < self.listArr.count) {
                    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
                    if (self.isFirst) {
                        if (i == 0) {
                            [dic setValue:[NSNumber numberWithInteger:self.firstHeight + 70] forKey:[NSString stringWithFormat:@"%d",i]];
                        }else{
                            [dic setValue:@70 forKey:[NSString stringWithFormat:@"%d",i]];
                        }
                    }else{
                        [dic setValue:@70 forKey:[NSString stringWithFormat:@"%d",i]];
                    }
                    [self.heightArr addObject:dic];
                }
                
            }
            [self.tableView reloadData];
            if (self.listArr.count > 0 || [self.listArr.firstObject isKindOfClass:NSDictionary.class]) {
                NSNumber *sync = [self.listArr.firstObject objectForKey:@"syncProgress"];
                if (sync && [sync isKindOfClass:NSNumber.class]) {
                    if ([sync isEqualToNumber:@1]) {
                        if (self.block) {
                            self.block(YES);
                        }
                    }
                }
            }
        }
    } failure:^(NSError * _Nonnull error) {
        if (self.isMapPush) {
            [self.view addSubview:self.defaultView];
        }
    }];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint point=[[touches anyObject]locationInView:self.view];
    CALayer *layer=[self.moreView.layer hitTest:point];
    if (layer!=self.moreView.layer) {
        self.moreView.hidden = YES;
    }
}
- (void)backButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)moreBtnClick:(UIButton *)btn{
    if (btn.tag == 100000) {
        self.moreView.hidden = !self.moreView.hidden;
    }
}
///三点点击
- (void)moreInClick:(UIButton *)btn {
    self.moreView.hidden = YES;
    if (btn.tag == 20000) {//同步进度
        if (self.baseModel.syncProgress) {
            [self syncProgress];
        }else{
            [HICToast showWithText:NSLocalizableString(@"noSynchronizationIsCurrentlyRequired", nil)];
        }
    }else if(btn.tag == 20001){
        [self.view addSubview:self.maskView];
        
    }else{
        HICDetailShareVC *shareVc = [HICDetailShareVC new];
        shareVc.model = self.baseModel;
        shareVc.rankNum = self.rankNum;
        [self.navigationController pushViewController:shareVc animated:YES];
    }
}
///同步进度
- (void)syncProgress {
    [HICAPI syncProgress:_trainId success:^(NSDictionary * _Nonnull responseObject) {
        if (responseObject[@"data"]) {
            NSInteger i = [responseObject[@"data"] integerValue];
            if (i == 1) {
                [HICToast showWithText:NSLocalizableString(@"synchronousSuccess", nil)];
                [self initListData];
            } else {
                [HICToast showWithText:NSLocalizableString(@"noNeedSynchronizeProgress", nil)];
            }
        } else {
            [HICToast showWithText:NSLocalizableString(@"noNeedSynchronizeProgress", nil)];
        }
    } failure:^(NSError * _Nonnull error) {
        [HICToast showWithText:NSLocalizableString(@"synchronizationFailure", nil)];
    }];
}

- (void)showSyncProgressToast {
    BOOL hadShow = [[NSUserDefaults standardUserDefaults] boolForKey:hadShowTrainSyncProgressToastKey];
    if (hadShow || self.baseModel.syncProgress != 1){
        return;
    }
    // 显示同步进度提示
    HICSyncProgressPopview *syncView = [[HICSyncProgressPopview alloc] initWithFrame:self.view.bounds from:HICSyncProgressPageTrainDetail];
    [self.view addSubview:syncView];
    [syncView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
#pragma mark ----HICBaseMaskViewDelegate
- (void)closeMaskView {
    [self.maskView removeFromSuperview];
}
#pragma mark -indexviewCellDelegate (展开收起)
- (void)clickExtension:(CGFloat)cellHeight andIndex:(NSInteger)index andIsShowContent:(BOOL)isShowContent{
    self.isFirst = NO;
    self.cellHeight = cellHeight;
    for (int i = 0; i < self.heightArr.count; i ++) {
        if ([[self.heightArr[i] allKeys][0] isEqual:[NSString stringWithFormat:@"%ld",(long)index]]) {
            [self.heightArr[i] setValue:[NSString stringWithFormat:@"%f",self.cellHeight] forKey:[NSString stringWithFormat:@"%ld",(long)index]];
        }
        if (i == index) {
            NSString *str;
            if (isShowContent) {
                str = @"yes";
            }else{
                str = @"no";
            }
            [self.showArr replaceObjectAtIndex:i withObject:str];
        }
    }
    [self.tableView reloadData];
}
- (void)jumpKonwledge:(HICTrainDetailStageActionsModel *)model andSectionId:(NSNumber *)sectionId andIsEnd:(NSInteger)isEnd andIsStart:(NSInteger)isStart andIndx:(NSInteger)index{
    if (isStart < self.baseModel.startTime.integerValue) {
        [HICToast showWithText:NSLocalizableString(@"trainingNotStarted", nil)];
        return;
    }
    if (isEnd == 10) {
        [HICToast showWithText:NSLocalizableString(@"trainingHasBeenCompleted", nil)];
        return;
    }
    if (index > 0) {
        HICTrainDetailListModel *model = [HICTrainDetailListModel mj_objectWithKeyValues:self.listArr[index - 1]];
        if (model.stageIsOrder) {
            if (model.completedTaskNum < model.taskNum) {
                [HICToast showWithText:NSLocalizableString(@"learnInOrder", nil)];
                return;
            }
        }
    }
    if (model.taskType == HICCourseType) {
        HICLessonsVC *lessconVc = [HICLessonsVC new];
        lessconVc.objectID = model.resourceId;
        lessconVc.trainId = _trainId;
        if (!_isMapPush) {
            HICStudyLogReportModel *reportModel = [[HICStudyLogReportModel alloc]initWithType:HICTrainOnlineKnowledgeClick];
            reportModel.mediatype = [NSNumber numberWithInteger:HICReportCourseType];
            reportModel.knowtype = @-1;
            reportModel.mediaid = model.resourceId;
            reportModel.traincourseid = _trainId;
            NSMutableDictionary *report = [NSMutableDictionary dictionaryWithDictionary:[reportModel getParamDict]];
            [report setValuesForKeysWithDictionary:[LogManager getSerLogEventDictWithType:HICTrainOnlineKnowledgeClick]];
            [LogManager reportSerLogWithDict:report];
        }else{
            HICStudyLogReportModel *reportModel = [[HICStudyLogReportModel alloc]initWithType:HICPosKnowledgeClick];
            reportModel.knowtype = @-1;
            reportModel.mediaid = model.resourceId;
            reportModel.traincourseid = _trainId;
            reportModel.mediatype = [NSNumber numberWithInteger:HICReportCourseType];
            NSMutableDictionary *report = [NSMutableDictionary dictionaryWithDictionary:[reportModel getParamDict]];
            [report setValuesForKeysWithDictionary:[LogManager getSerLogEventDictWithType:HICPosKnowledgeClick]];
            [LogManager reportSerLogWithDict:report];
        }
        
        [self.navigationController pushViewController:lessconVc animated:YES];
    }else if(model.taskType == HICKonwledeType){
        HICKnowledgeDetailVC *detailVc = [HICKnowledgeDetailVC new];
        detailVc.objectId = model.resourceId;
        detailVc.kType = model.resourceType;
        detailVc.partnerCode = model.partnerCode;
        detailVc.trainId = _trainId;
        if (!_isMapPush) {
            HICStudyLogReportModel *reportModel = [[HICStudyLogReportModel alloc]initWithType:HICTrainOnlineKnowledgeClick];
            reportModel.mediaid = model.resourceId;
            reportModel.mediatype = [NSNumber numberWithInteger:HICReportKnowledgeType];
            reportModel.knowtype = [NSNumber numberWithInteger:model.resourceType];
            reportModel.traincourseid = _trainId;
            NSMutableDictionary *report = [NSMutableDictionary dictionaryWithDictionary:[reportModel getParamDict]];
            [report setValuesForKeysWithDictionary:[LogManager getSerLogEventDictWithType:HICTrainOnlineKnowledgeClick]];
            [LogManager reportSerLogWithDict:report];
        }else{
            HICStudyLogReportModel *reportModel = [[HICStudyLogReportModel alloc]initWithType:HICPosKnowledgeClick];
            reportModel.mediaid = model.resourceId;
            reportModel.knowtype = [NSNumber numberWithInteger:model.resourceType];
            reportModel.mediatype = [NSNumber numberWithInteger:HICReportKnowledgeType];
            reportModel.traincourseid = _trainId;
            NSMutableDictionary *report = [NSMutableDictionary dictionaryWithDictionary:[reportModel getParamDict]];
            [report setValuesForKeysWithDictionary:[LogManager getSerLogEventDictWithType:HICPosKnowledgeClick]];
            [LogManager reportSerLogWithDict:report];
        }
        
        [self.navigationController pushViewController:detailVc animated:YES];
    }else if(model.taskType == HICExamType){
        HICExamCenterDetailVC *vc = [HICExamCenterDetailVC new];
        vc.examId = [NSString stringWithFormat:@"%@",model.resourceId];
        vc.trainId = [NSString stringWithFormat:@"%@",model.taskId];
        if (!_isMapPush) {
            HICStudyLogReportModel *reportModel = [[HICStudyLogReportModel alloc]initWithType:HICTrainOnlineTaskClick];
            reportModel.mediaid = model.resourceId;
            reportModel.tasktype = [NSNumber numberWithInteger:HICReportExamType];
            if (model.examStatus == 0 ) {// "examStatus1":"integer,考试状态 0-待考试，1-进行中，2-批阅中，3-已完成，4-缺考",
                reportModel.taskstatus = NSLocalizableString(@"waitTest", nil);
            }else if (model.examStatus == 1){
                reportModel.taskstatus = NSLocalizableString(@"ongoing", nil);
            }else if (model.examStatus == 2){
                reportModel.taskstatus = NSLocalizableString(@"reviewing", nil);
            }else if (model.examStatus == 3){
                reportModel.taskstatus = NSLocalizableString(@"hasBeenCompleted", nil);
            }else{
                reportModel.taskstatus = NSLocalizableString(@"lackOfTest", nil);
            }
            reportModel.traincourseid = _trainId;
            NSMutableDictionary *report = [NSMutableDictionary dictionaryWithDictionary:[reportModel getParamDict]];
            [report setValuesForKeysWithDictionary:[LogManager getSerLogEventDictWithType:HICTrainOnlineTaskClick]];
            [LogManager reportSerLogWithDict:report];
        }else{
            HICStudyLogReportModel *reportModel = [[HICStudyLogReportModel alloc]initWithType:HICPosTaskClick];
            reportModel.mediaid = model.resourceId;
            reportModel.tasktype = [NSNumber numberWithInteger:HICReportExamType];
            reportModel.traincourseid = _trainId;
            if (model.examStatus == 0 ) {// "examStatus1":"integer,考试状态 0-待考试，1-进行中，2-批阅中，3-已完成，4-缺考",
                reportModel.taskstatus = NSLocalizableString(@"waitTest", nil);
            }else if (model.examStatus == 1){
                reportModel.taskstatus = NSLocalizableString(@"ongoing", nil);
            }else if (model.examStatus == 2){
                reportModel.taskstatus = NSLocalizableString(@"reviewing", nil);
            }else if (model.examStatus == 3){
                reportModel.taskstatus = NSLocalizableString(@"hasBeenCompleted", nil);
            }else{
                reportModel.taskstatus = NSLocalizableString(@"lackOfTest", nil);
            }
            NSMutableDictionary *report = [NSMutableDictionary dictionaryWithDictionary:[reportModel getParamDict]];
            [report setValuesForKeysWithDictionary:[LogManager getSerLogEventDictWithType:HICPosTaskClick]];
            [LogManager reportSerLogWithDict:report];
        }
        
        [self.navigationController pushViewController:vc animated:YES];
    }else if (model.taskType == HICQuestionType || model.taskType == HICAppraiseType){
        HICTrainQuestionVC *vc = [HICTrainQuestionVC new];
        vc.taskId = model.taskId;
        vc.trainId = _trainId;
        if (!_isMapPush) {
            HICStudyLogReportModel *reportModel = [[HICStudyLogReportModel alloc]initWithType:HICTrainOnlineTaskClick];
            reportModel.mediaid = model.resourceId;
            if (model.taskType == HICQuestionType) {
                reportModel.tasktype = [NSNumber numberWithInteger:HICReportQuestionType];
            }else{
                reportModel.tasktype = [NSNumber numberWithInteger:HICReportAppraiseType];
            }
            
            reportModel.taskstatus = @"";
            reportModel.traincourseid = _trainId;
            NSMutableDictionary *report = [NSMutableDictionary dictionaryWithDictionary:[reportModel getParamDict]];
            [report setValuesForKeysWithDictionary:[LogManager getSerLogEventDictWithType:HICTrainOnlineTaskClick]];
            [LogManager reportSerLogWithDict:report];
        }else{
            HICStudyLogReportModel *reportModel = [[HICStudyLogReportModel alloc]initWithType:HICPosTaskClick];
            reportModel.mediaid = model.resourceId;
            reportModel.traincourseid = _trainId;
            if (model.taskType == HICQuestionType) {
                reportModel.tasktype = [NSNumber numberWithInteger:HICReportQuestionType];
            }else{
                reportModel.tasktype = [NSNumber numberWithInteger:HICReportAppraiseType];
            }
            
            reportModel.taskstatus = @"";
            NSMutableDictionary *report = [NSMutableDictionary dictionaryWithDictionary:[reportModel getParamDict]];
            [report setValuesForKeysWithDictionary:[LogManager getSerLogEventDictWithType:HICPosTaskClick]];
            [LogManager reportSerLogWithDict:report];
        }
        [self.navigationController pushViewController:vc animated:YES];
    }else if(model.taskType == HICHomeWorkType) {
        HICHomeworkListVC *vc = [HICHomeworkListVC new];
        vc.homeworkTitle = model.taskName;
        vc.trainId = self.trainId;
        vc.workId = model.taskId;
        if (!_isMapPush) {
            HICStudyLogReportModel *reportModel = [[HICStudyLogReportModel alloc]initWithType:HICTrainOnlineTaskClick];
            reportModel.mediaid = model.resourceId;
            reportModel.tasktype = [NSNumber numberWithInteger:HICReportHomeWorkType];
            if (model.workStatus == 0 ) {// int, optional, 作业状态，0-待开始，1-进行中，3-待批阅，4-批阅中，5-已完成",
                reportModel.taskstatus = NSLocalizableString(@"waitStart", nil);
            }else if (model.examStatus == 1){
                reportModel.taskstatus = NSLocalizableString(@"ongoing", nil);
            }else if (model.examStatus == 4){
                reportModel.taskstatus = NSLocalizableString(@"reviewing", nil);
            }else if (model.examStatus == 3){
                reportModel.taskstatus = NSLocalizableString(@"waitExamines", nil);
            }else{
                reportModel.taskstatus = NSLocalizableString(@"hasBeenCompleted", nil);
            }
            reportModel.traincourseid = _trainId;
            NSMutableDictionary *report = [NSMutableDictionary dictionaryWithDictionary:[reportModel getParamDict]];
            [report setValuesForKeysWithDictionary:[LogManager getSerLogEventDictWithType:HICTrainOnlineTaskClick]];
            [LogManager reportSerLogWithDict:report];
        }else{
            HICStudyLogReportModel *reportModel = [[HICStudyLogReportModel alloc]initWithType:HICPosTaskClick];
            reportModel.mediaid = model.resourceId;
            reportModel.tasktype = [NSNumber numberWithInteger:HICReportHomeWorkType];
            reportModel.traincourseid = _trainId;
            if (model.workStatus == 0 ) {// int, optional, 作业状态，0-待开始，1-进行中，3-待批阅，4-批阅中，5-已完成",
                reportModel.taskstatus = NSLocalizableString(@"waitStart", nil);
            }else if (model.examStatus == 1){
                reportModel.taskstatus = NSLocalizableString(@"ongoing", nil);
            }else if (model.examStatus == 4){
                reportModel.taskstatus = NSLocalizableString(@"reviewing", nil);
            }else if (model.examStatus == 3){
                reportModel.taskstatus = NSLocalizableString(@"waitExamines", nil);
            }else{
                reportModel.taskstatus = NSLocalizableString(@"hasBeenCompleted", nil);
            }
            NSMutableDictionary *report = [NSMutableDictionary dictionaryWithDictionary:[reportModel getParamDict]];
            [report setValuesForKeysWithDictionary:[LogManager getSerLogEventDictWithType:HICPosTaskClick]];
            [LogManager reportSerLogWithDict:report];
        }
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}
#pragma mark -- UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HICTrainDetailCell *cell = (HICTrainDetailCell *)[tableView dequeueReusableCellWithIdentifier:TrainListCell];
    if (cell == nil) {
        cell = [[HICTrainDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TrainListCell];
    }
    cell.isPushMap = self.isMapPush;
    cell.extensionDelegate = self;
    cell.indexPath = indexPath;
    cell.isFirst = self.isFirst;
    cell.model = [HICTrainDetailListModel mj_objectWithKeyValues:self.listArr[indexPath.row]];
    if ([self.showArr[indexPath.row] isEqualToString:@"yes"]) {
        cell.isShowContent = YES;
    }else{
        cell.isShowContent = NO;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
///申请打分
- (void)clickScoreBtnWithType:(NSInteger)type andTaskId:(NSNumber *)taskId{
    if (type == 1) {//申请打分
        NSMutableDictionary *dic = [NSMutableDictionary new];
        [dic setValue:taskId forKey:@"taskId"];
        [dic setValue:self.postId.integerValue ? self.postId :@-1 forKey:@"postId"];
        [dic setValue:self.wayId.integerValue ? self.wayId:@-1 forKey:@"wayId"];
        [dic setValue:@-1 forKey:@"mapId"];
        [HICAPI clickScoreBtnWithType:dic success:^(NSDictionary * _Nonnull responseObject) {
            if ([responseObject objectForKey:@"resultCode"]) {
                NSNumber *code = (NSNumber *)responseObject[@"resultCode"];
                if ([code isEqualToNumber:@0]) {
                    [HICToast showWithText:NSLocalizableString(@"toApplyGradeSuccess", nil)];
                     [self initListData];
                }
            }
        }];
    }else{//查看打分表，跳转h5页面
        HICPushCustoWebVC *vc = [HICPushCustoWebVC new];
        NSString *name = USER_NAME;
        name = [name stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        vc.urlStr = [NSString stringWithFormat:@"%@/mweb/index.html#/train-result?taskId=%@&customerName=%@&customerId=%@&isFromApp=1",APP_Web_DOMAIN,taskId,name,USER_CID];
        vc.isCompanyUrl = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0.0;
    for (int i = 0; i < self.heightArr.count; i ++) {
        if ([[self.heightArr[i] allKeys][0] isEqual:[NSString stringWithFormat:@"%ld",(long) indexPath.row]]){
            height = [self.heightArr[i][[NSString stringWithFormat:@"%ld",(long)indexPath.row]] floatValue];
        }
    }
    return height;
}

- (void)setIsReload:(BOOL)isReload {
    _isReload = isReload;
    if (isReload) {
        [self initListData];
    }
}

@end
