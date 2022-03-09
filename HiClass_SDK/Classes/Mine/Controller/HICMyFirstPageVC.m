//
//  HICMyFirstPageVC.m
//  HiClass
//
//  Created by WorkOffice on 2020/3/16.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICMyFirstPageVC.h"
#import "HICMyInfoCell.h"
#import "HICFirstPageREcordCell.h"
#import "HICNetModel.h"
#import "HICMyBaseInfoModel.h"
#import "HICMySettingVC.h"
#import "HICMyInformationVC.h"
#import "HICRankingListVC.h"
#import "HICMineTableVC.h"
#import "HICMyDownloadVC.h"
#import "HICMyRecordModel.h"
#import "HICKnowledgeDetailVC.h"
#import "HICCourseModel.h"
#import "HICLessonsVC.h"
#import "HICCertificatesVC.h"
#import "HICChildMineVC.h"
#import "HICWorkSpaceVC.h"
#import "HICPushCustoWebVC.h"
#import "HICMyScoreViewController.h"
static NSString *myInfoCell = @"myInfoCell";
static NSString *myRecordCell = @"myRecordCell";
@interface HICMyFirstPageVC ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong)UIView *headerView;
@property (nonatomic ,strong)UIScrollView *scrollBackView;
@property (nonatomic, strong)UIView *cardView;
@property (nonatomic, strong)UIImageView *headerImage;
@property (nonatomic, strong)UILabel *nameLabel;
@property (nonatomic, strong)UILabel *partmentLabel;
@property (nonatomic, strong)UILabel *timeLabel;
@property (nonatomic, strong)UILabel *timeRank;
@property (nonatomic, strong)UILabel *scoreLabel;
@property (nonatomic, strong)UILabel *scoreRank;
@property (nonatomic, strong)UIView *middleView;
@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic ,strong)NSMutableArray *imageArr;
@property (nonatomic ,strong)NSMutableArray *titleArr;
@property (nonatomic ,strong)HICNetModel *netModel;
@property (nonatomic ,strong)HICMyBaseInfoModel *baseInfoModel;
@property (nonatomic ,strong)NSArray *recordList;
@property (nonatomic ,strong)NSArray *scoreArr;
@property (nonatomic ,strong)NSArray *timeArr;
@property (nonatomic ,strong)UILabel *headerLabel;
@property (nonatomic ,assign)HICMyRankType rankType;
@property (nonatomic ,assign)BOOL isTime;
@property (nonatomic ,assign)BOOL isScore;

@property (nonatomic ,strong)UIButton *myScorebtn;
@end

@implementation HICMyFirstPageVC
- (UIScrollView *)scrollBackView{
    if (!_scrollBackView) {
        _scrollBackView  = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, HIC_ScreenWidth, HIC_ScreenHeight - HIC_TabBarHeight)];
        _scrollBackView.contentSize = CGSizeMake(HIC_ScreenWidth, 78 +144 + HIC_StatusBar_Height + 211.5 + 253);
        _scrollBackView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
        _scrollBackView.scrollEnabled = YES;
        
    }
    return _scrollBackView;
   
}
-(UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, HIC_ScreenWidth,130 + HIC_StatusBar_Height + 86)];
        _headerView.userInteractionEnabled = YES;
//        [self.view addSubview:_headerView];
      
    }
    return _headerView;
}
-(UIView *)middleView{
    if (!_middleView) {
        _middleView = [[UIView alloc]initWithFrame:CGRectMake(0, 130 + HIC_StatusBar_Height + 94, HIC_ScreenWidth, 187.5)];
        _middleView.backgroundColor = UIColor.whiteColor;
//         [self.view addSubview:_middleView];
    }
    return _middleView;
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 453 + HIC_StatusBar_Height, HIC_ScreenWidth, 202) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0;
        }
//        [self.view addSubview:_tableView];
    }
    return _tableView;
}
-(NSArray *)scoreArr{
    if (!_scoreArr) {
        _scoreArr = [NSArray array];
    }
    return _scoreArr;
}
-(NSArray *)timeArr{
    if (!_timeArr) {
        _timeArr = [NSArray array];
    }
    return _timeArr;
}
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        // 每一列cell之间的间距
        flowLayout.minimumInteritemSpacing = 10;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 9, 0, 16);
        flowLayout.itemSize = CGSizeMake(130, 199.5-12-53);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(10, 53, HIC_ScreenWidth - 10, 199.5-12-53) collectionViewLayout:flowLayout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
    }
    return _collectionView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.scrollBackView];
    if (@available(iOS 11.0, *)) {
        self.scrollBackView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.titleArr = [NSMutableArray array];
    self.imageArr = [NSMutableArray array];
//    [self createMiddleView];
    
    CGFloat height = 17 + 86 + 130 + HIC_StatusBar_Height;
    if ([RoleManager isSuccessMenu]) {
        if ([RoleManager menuCodes].count > 0) {
            if ([[RoleManager menuCodes] containsObject:@"AppCommentS"]) {
                [self.titleArr addObject:NSLocalizableString(@"comments", nil)];
                [self.imageArr addObject:@"评论"];
                height += 50.5;
            }
            if ([[RoleManager menuCodes] containsObject:@"AppFavoriteS"]){
                [self.titleArr addObject:NSLocalizableString(@"collection", nil)];
                [self.imageArr addObject:@"收藏"];
                height += 50.5;
            }
            if ([[RoleManager menuCodes] containsObject:@"AppNoteS"]){
                [self.titleArr addObject:NSLocalizableString(@"note", nil)];
                [self.imageArr addObject:@"笔记"];
                height += 50.5;
            }
            if ([[RoleManager menuCodes] containsObject:@"AppDownloadS"]){
                [self.titleArr addObject:NSLocalizableString(@"downloadContent", nil)];
                [self.imageArr addObject:@"我的-下载"];
                height += 50.5;
            }
            if ([[RoleManager menuCodes] containsObject:@"AppCertificateS"]){
                [self.titleArr addObject:NSLocalizableString(@"certificate", nil)];
                [self.imageArr addObject:@"证书"];
                height += 50.5;
            }
            if ([[RoleManager menuCodes] containsObject:@"WorkTable"]){
                [self.titleArr addObject:NSLocalizableString(@"workbench", nil)];
                [self.imageArr addObject:@"工作台"];
                height += 50.5;
            }
            if ([[RoleManager menuCodes] containsObject:@"MyFilesS"]){
                           [self.titleArr addObject:NSLocalizableString(@"myFiles", nil)];
                           [self.imageArr addObject:@"档案"];
                           height += 50.5;
                       }
            if ([[RoleManager menuCodes] containsObject:@"AppCreditS"]){
                self.isScore = YES;
            }
            if ([[RoleManager menuCodes] containsObject:@"AppSchoolHoursS"]){
                self.isTime = YES;
            }
            if([[RoleManager menuCodes] containsObject:@"AppLearningRecordS"]){
            [self createMiddleView];
                height += 195;
            }
            [self.titleArr addObject:NSLocalizableString(@"setUp", nil)];
            [self.imageArr addObject:@"setting"];
            height += 50.5;
            self.scrollBackView.contentSize = CGSizeMake(HIC_ScreenWidth, height);
            [self createBottomView];
        }
    }else{
        self.titleArr = [NSMutableArray arrayWithArray:@[NSLocalizableString(@"comments", nil),NSLocalizableString(@"collection", nil),NSLocalizableString(@"note", nil),NSLocalizableString(@"downloadContent", nil),NSLocalizableString(@"certificate", nil),NSLocalizableString(@"setUp", nil)]];
        self.imageArr = [NSMutableArray arrayWithArray:@[@"评论",@"收藏",@"笔记",@"我的-下载",@"证书",@"setting"]];
        self.isScore = YES;
        self.isTime = YES;
        [self createMiddleView];
        [self createBottomView];
        height = 86 + 130 + HIC_StatusBar_Height + 50.5 *self.titleArr.count + 156 + 25;
    }
    [self createHeader];
    [self.scrollBackView setContentSize:CGSizeMake(HIC_ScreenWidth, height > (HIC_ScreenHeight - HIC_TabBarHeight - HIC_BottomHeight) ? height : HIC_ScreenHeight - HIC_TabBarHeight - HIC_BottomHeight)];
    
    [self initData];
   
}
- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
    if (self.cardView) {
        [self initData];
    }
}
- (void)viewWillDisappear:(BOOL)animated{
//    self.navigationController.navigationBar.hidden = NO;
}
- (void)createHeader{
    [self.scrollBackView addSubview:self.headerView];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, HIC_ScreenWidth, 130 + HIC_StatusBar_Height)];
    UIImage *headImage = [UIImage imageNamed:@"mineHeadBg"];
    imageView.userInteractionEnabled = YES;
    imageView.image = headImage;
    [self.headerView addSubview:imageView];
    self.cardView = [[UIView alloc]initWithFrame:CGRectMake(0, 130 + HIC_StatusBar_Height, HIC_ScreenWidth, 86)];
    self.cardView.backgroundColor = [UIColor whiteColor];
    
    [self.headerView addSubview:self.cardView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goToMyInfo)];
    self.headerImage = [[UIImageView alloc]initWithFrame:CGRectMake(20, 40 + HIC_StatusBar_Height, 60, 60)];
    self.headerImage.backgroundColor = [UIColor colorWithHexString:@"#EBEBEB"];
    self.headerImage.layer.cornerRadius = 4;
    self.headerImage.clipsToBounds = YES;
    self.headerImage.userInteractionEnabled = YES;
    [self.headerImage addGestureRecognizer:tap];
    [self.headerView addSubview:self.headerImage];
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.headerImage.rightX + 12, 48.5 + HIC_StatusBar_Height, 200 ,20)];
    self.nameLabel.textColor = [UIColor whiteColor];
    self.nameLabel.font = FONT_MEDIUM_20;
    self.nameLabel.textAlignment = NSTextAlignmentLeft;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goToMyInfo)];
    [self.nameLabel addGestureRecognizer:tap1];
    self.nameLabel.userInteractionEnabled = YES;
    [self.headerView addSubview:self.nameLabel];
    self.partmentLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.headerImage.rightX + 12, self.nameLabel.bottomY + 9.5, 200 ,13)];
    self.partmentLabel.textColor = [UIColor whiteColor];
    self.partmentLabel.font = FONT_MEDIUM_13;
    self.partmentLabel.textAlignment = NSTextAlignmentLeft;
    [self.headerView addSubview:self.partmentLabel];
    
    self.myScorebtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.myScorebtn.frame = CGRectMake(HIC_ScreenWidth - 96, HIC_StatusBar_Height + 53, 96, 34);
    [self.myScorebtn setBackgroundImage:[UIImage imageNamed:@"bg_我的积分"] forState:UIControlStateNormal];
    [self.myScorebtn setTitle:@"我的积分" forState:UIControlStateNormal];
    [self.myScorebtn setImage:[UIImage imageNamed:@"icon_integral"] forState:UIControlStateNormal];
    self.myScorebtn.titleLabel.font = FONT_MEDIUM_13;
    [self.myScorebtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.myScorebtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    [self.myScorebtn addTarget:self action:@selector(myScore) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView addSubview:self.myScorebtn];
    
    CGFloat labelW;
    if (self.isScore  && self.isTime ) {
        labelW = self.cardView.frame.size.width/4;
    }else if(self.isScore || self.isTime) {
        labelW = self.cardView.frame.size.width/3;
    }else{
        labelW = self.cardView.frame.size.width/2;
    }
    
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 53, labelW, 13)];
    label1.text = NSLocalizableString(@"thisYearSchool", nil);
    label1.textColor = TEXT_COLOR_LIGHTM;
    label1.font = FONT_REGULAR_13;
    label1.textAlignment = NSTextAlignmentCenter;
    [self.cardView addSubview:label1];
    self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, labelW, 21)];
    self.timeLabel.textColor = [UIColor colorWithHexString:@"#00BED7"];
    self.timeLabel.font = FONT_MEDIUM_22;
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    self.timeLabel.text = @"-";
    [self.cardView addSubview:self.timeLabel];
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(labelW, 20, 0.5, 45)];
    line1.backgroundColor = [UIColor colorWithHexString:@"#DCDCDC"];
    [self.cardView addSubview:line1];
    UILabel *label2 = [[UILabel alloc]init];
    label2.text = NSLocalizableString(@"studyHourList", nil);
    label2.textColor = TEXT_COLOR_LIGHTM;
    label2.font = FONT_REGULAR_13;
    label2.textAlignment = NSTextAlignmentCenter;
    UIButton *timeBtn = [[UIButton alloc]init];
    [timeBtn setImage:[UIImage imageNamed:@"icon_学时"] forState:UIControlStateNormal];
    [timeBtn addTarget:self action:@selector(goToTimeRank) forControlEvents:UIControlEventTouchUpInside];
    timeBtn.userInteractionEnabled = YES;
    UIView *line2 = [[UIView alloc]init];
    if (self.isTime) {
        label2.frame = CGRectMake(labelW, 53, labelW, 13);
        [self.cardView addSubview:label2];
        timeBtn.frame = CGRectMake(labelW + labelW / 2 - 10, 20, 20, 21);
        [self.cardView addSubview:timeBtn];
        line2.frame = CGRectMake(labelW *2, 20, 0.5, 45);
        line2.backgroundColor = [UIColor colorWithHexString:@"#DCDCDC"];
        [self.cardView addSubview:line2];
    }
    UILabel *label3 = [[UILabel alloc]init];
    label3.text = NSLocalizableString(@"thisYearCredit", nil);
    label3.textColor = TEXT_COLOR_LIGHTM;
    label3.font = FONT_REGULAR_13;
    label3.textAlignment = NSTextAlignmentCenter;
    [self.cardView addSubview:label3];
    if (self.isTime) {
        label3.frame = CGRectMake(labelW *2, 53, labelW, 13);
        self.scoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(labelW *2,20, labelW, 21)];
    }else{
       label3.frame = CGRectMake(labelW, 53, labelW, 13);
        self.scoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(labelW, 20, labelW, 21)];
    }
    self.scoreLabel.textColor = [UIColor colorWithHexString:@"#00BED7"];
    self.scoreLabel.font = FONT_MEDIUM_22;
    self.scoreLabel.textAlignment = NSTextAlignmentCenter;
     self.scoreLabel.text = @"-";
    [self.cardView addSubview:self.scoreLabel];
    
    UIView *line3 = [[UIView alloc]init];
    line3.backgroundColor = [UIColor colorWithHexString:@"#DCDCDC"];
    UILabel *label4 = [[UILabel alloc]initWithFrame:CGRectMake(labelW *3, 53, labelW, 13)];
        label4.text = NSLocalizableString(@"creditsList", nil);
        label4.textColor = TEXT_COLOR_LIGHTM;
        label4.font = FONT_REGULAR_13;
        label4.textAlignment = NSTextAlignmentCenter;
        
     UIButton *scoreBtn = [[UIButton alloc]init];
     [scoreBtn setImage:[UIImage imageNamed:@"icon_学分"] forState:UIControlStateNormal];
     [scoreBtn addTarget:self action:@selector(goToScoreRank) forControlEvents:UIControlEventTouchUpInside];
     [scoreBtn hicChangeButtonClickLength:30];
     scoreBtn.userInteractionEnabled = YES;
    
    if (self.isScore) {
        if (self.isTime) {
           line3.frame = CGRectMake(labelW *3, 20, 0.5, 45);
            label4.frame = CGRectMake(labelW *3,53, labelW, 13);
            scoreBtn.frame = CGRectMake(labelW *3 + labelW / 2 - 10, 20, 20, 21);
        }else{
            line3.frame = CGRectMake(labelW*2, 20, 0.5, 45);
            label4.frame = CGRectMake(labelW*2,53, labelW, 13);
            scoreBtn.frame = CGRectMake(labelW *2 + labelW / 2 - 10, 20, 20, 21);
        }
         [self.cardView addSubview:line3];
        [self.cardView addSubview:label4];
         [self.cardView addSubview:scoreBtn];
    }

}

-(void)myScore{
    NSBundle *b = [NSBundle bundleForClass:[self class]];
    NSString *path = [b pathForResource:@"HiClassBundle" ofType:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:path];
    NSString *imagePath = [bundle pathForResource:@"HICMyScoreViewController" ofType:@"xib"];
    HICMyScoreViewController *vc = [[HICMyScoreViewController alloc]initWithNibName:imagePath bundle:bundle];
    vc.points = self.baseInfoModel.points;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)createMiddleView{
    [self.scrollBackView addSubview:self.middleView];
    UILabel *recordLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 16, 80, 18)];
    recordLabel.text = NSLocalizableString(@"studyRecord", nil);
    recordLabel.font = FONT_MEDIUM_17;
    recordLabel.textColor = TEXT_COLOR_DARK;
    [self.middleView addSubview:recordLabel];
    CGFloat space = 5;// 图片和文字的间距
       NSString *titleString = NSLocalizableString(@"all", nil);
    UIImage *image = [UIImage imageNamed:@"跳转箭头"];
       CGFloat titleWidth = [titleString sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}].width;
       CGFloat imageWidth = image.size.width;
       CGFloat btnWidth = 50;// 按钮的宽度
       if (titleWidth > btnWidth - imageWidth - space) {
           titleWidth = btnWidth- imageWidth - space;
       }
    UIButton *allBtn = [UIButton buttonWithType:UIButtonTypeCustom];
       [allBtn setImage:[UIImage imageNamed:@"跳转箭头"] forState:UIControlStateNormal];
       [allBtn setTitleColor:TEXT_COLOR_LIGHTM forState:UIControlStateNormal];
       [allBtn setTitle:NSLocalizableString(@"all", nil) forState:UIControlStateNormal];
       [allBtn hicChangeButtonClickLength:30];
       [allBtn addTarget:self action:@selector(btnAllRecord) forControlEvents:UIControlEventTouchUpInside];
       allBtn.titleLabel.font = FONT_REGULAR_13;
       [allBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -(imageWidth+space*0.5), 0,(imageWidth+space*0.5))];
       [allBtn setImageEdgeInsets:UIEdgeInsetsMake(0, (titleWidth + space*0.5), 0, -(titleWidth + space*0.5))];
    allBtn.X = HIC_ScreenWidth - 52;
    allBtn.Y = recordLabel.Y;
    allBtn.width = 36;
    allBtn.height = 18.5;
    [self.middleView addSubview:allBtn];
    self.middleView.userInteractionEnabled = YES;
    [self.middleView addSubview:self.collectionView];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[HICFirstPageREcordCell class] forCellWithReuseIdentifier:myRecordCell];
    
}
- (void)createBottomView{
     self.tableView.height = 50.5 * self.titleArr.count;
    if (([RoleManager menuCodes].count > 0 && ![[RoleManager menuCodes] containsObject:@"AppLearningRecordS"])) {
        self.tableView.Y = self.middleView.Y;
        self.middleView.hidden = YES;
    }
    [self.scrollBackView addSubview:self.tableView];
//    self.imageArr = @[@"评论",@"收藏",@"笔记",@"我的-下载",@"证书"];
//     self.imageArr = @[@"评论",@"收藏",@"笔记",@"我的-下载"];
//    self.titleArr = @[@"评论",@"收藏",@"笔记",@"下载内容",@"证书"];
//    self.titleArr = @[@"评论",@"收藏",@"笔记",@"下载内容"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollEnabled = NO;
}
- (void)initData{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [HICAPI homePageDataQuery:^(NSDictionary * _Nonnull responseObject) {
            if (responseObject[@"data"] ) {
                self.baseInfoModel = [HICMyBaseInfoModel mj_objectWithKeyValues:responseObject[@"data"][@"baseInfo"]];
                if ([NSString isValidStr:self.baseInfoModel.department]) {
                    if ([self.baseInfoModel.department containsString:@"\\"]) {
                        NSArray *Arr = [self.baseInfoModel.department componentsSeparatedByString:@"\\"];
                        self.baseInfoModel.department = [Arr lastObject];
                    }
                }
                if ([NSString  isValidStr:self.baseInfoModel.headPic]) {
                    
                    [self.headerImage sd_setImageWithURL:[NSURL URLWithString:self.baseInfoModel.headPic]];
                    self.headerLabel.hidden = YES;
                }else{
                    self.headerLabel = [HICCommonUtils setHeaderFrameMineCenter:CGRectMake(0, 0, 60, 60) andText:self.baseInfoModel.name];
                    self.headerLabel.hidden = NO;
                    [self.headerImage addSubview:self.headerLabel];
                }
                if([[RoleManager menuCodes] containsObject:@"AppPoints"]){
                    self.myScorebtn.hidden = NO;
                }else{
                    self.myScorebtn.hidden = YES;
                }
                
                self.nameLabel.text = self.baseInfoModel.name;
                self.partmentLabel.text = self.baseInfoModel.department;
                self.timeLabel.text = [NSString isValidStr:self.baseInfoModel.creditHours] ? self.baseInfoModel.creditHours : @"-";
                self.scoreLabel.text = [NSString isValidStr:self.baseInfoModel.credit] ? self.baseInfoModel.credit : @"-";
                self.recordList = [NSArray arrayWithArray:responseObject[@"data"][@"learningRecordList"]];
                if([[RoleManager menuCodes] containsObject:@"AppLearningRecordS"]){
                    if(self.recordList.count == 0){
                        self.tableView.Y = self.middleView.Y;
                        self.middleView.hidden = YES;
                    }else{
                        self.middleView.hidden = NO;
                        self.tableView.Y = self.middleView.Y + self.middleView.height + 8;
                        [self.collectionView reloadData];
                    }
                }
            }
        } failure:^(NSError * _Nonnull error) {
            
        }];
    });
}
- (void)btnAllRecord{
    HICMineTableVC  *vc = [[HICMineTableVC alloc]initWithTitle:NSLocalizableString(@"myRecord", nil) andType:HICMyStudyRecord];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)goToScoreRank{
    HICRankingListVC *rankVc = [HICRankingListVC new];
    rankVc.rankType = HICMyRankScore;
    [self.navigationController pushViewController:rankVc animated:YES];
}
- (void)goToTimeRank{
    HICRankingListVC *rankVc = [HICRankingListVC new];
    rankVc.rankType = HICMyRankTime;
    [self.navigationController pushViewController:rankVc animated:YES];
}
- (void)goToMyInfo{
    HICMyInformationVC *infoVc = [HICMyInformationVC new];
    infoVc.model = self.baseInfoModel;
    [self.navigationController pushViewController:infoVc animated:YES];
}
#pragma mark -----tableviewdelegate&&datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HICMyInfoCell *cell = (HICMyInfoCell *)[tableView dequeueReusableCellWithIdentifier:myInfoCell];
    if (!cell) {
        if (indexPath.row == self.titleArr.count-1) {
             cell = [[HICMyInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myInfoCell andTitle:self.titleArr[indexPath.row] andIcon:self.imageArr[indexPath.row] andLast:YES];
        }else{
             cell = [[HICMyInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myInfoCell andTitle:self.titleArr[indexPath.row] andIcon:self.imageArr[indexPath.row] andLast:NO];
        }
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *str = self.titleArr[indexPath.row];
    NSString *title;
    if ([str isEqualToString:NSLocalizableString(@"comments", nil)]) {
        HICChildMineVC *vc = [[HICChildMineVC alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([str isEqualToString:NSLocalizableString(@"collection", nil)]) {
         HICMineTableVC *vc = [[HICMineTableVC alloc]initWithTitle:NSLocalizableString(@"myColletion", nil) andType:HICMyCollect];
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([str isEqualToString:NSLocalizableString(@"note", nil)]) {
        HICMineTableVC *vc = [[HICMineTableVC alloc]initWithTitle:NSLocalizableString(@"myNote", nil) andType:HICMyNote];
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([str isEqualToString:NSLocalizableString(@"certificate", nil)]) {
        HICCertificatesVC *vc = [[HICCertificatesVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if([str isEqualToString:NSLocalizableString(@"downloadContent", nil)]){//下载
        title = NSLocalizableString(@"myDownload", nil);
        HICMyDownloadVC *vc = [[HICMyDownloadVC alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([str isEqualToString:NSLocalizableString(@"workbench", nil)]){
        HICWorkSpaceVC *vc = [HICWorkSpaceVC new];
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([str isEqualToString:NSLocalizableString(@"myFiles", nil)]){
        HICPushCustoWebVC *vc = HICPushCustoWebVC.new;
        vc.urlStr = [NSString stringWithFormat:@"%@/mweb/index.html?#/mine-record", APP_Web_DOMAIN];
        vc.isCompanyUrl = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([str isEqualToString:NSLocalizableString(@"setUp", nil)]){
        HICMySettingVC *settingVc = [HICMySettingVC new];
        [self.navigationController pushViewController:settingVc animated:YES];
    }
}
#pragma mark -----uicollectionviewdelegate&&uicollectionviewdatasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.recordList.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HICFirstPageREcordCell *cell = (HICFirstPageREcordCell *)[collectionView dequeueReusableCellWithReuseIdentifier:myRecordCell forIndexPath:indexPath];
    if (!cell) {
        cell = [[HICFirstPageREcordCell alloc]init];
    }
    cell.model = [HICMyRecordModel mj_objectWithKeyValues:self.recordList[indexPath.row]];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    HICMyRecordModel *model = [HICMyRecordModel mj_objectWithKeyValues:self.recordList[indexPath.row]];
    HICCourseModel *courseModel = [HICCourseModel mj_objectWithKeyValues:model.courseKLDInfo];
    ///日志上报
    HICStudyLogReportModel *reportModel = [[HICStudyLogReportModel alloc]initWithType:HICMyRecordClickToKnowledge];
    reportModel.mediaid = courseModel.courseKLDId;
    reportModel.knowtype = [NSNumber numberWithInteger:courseModel.resourceType];
    reportModel.mediatype = [NSNumber numberWithInteger:HICReportKnowledgeType];
    NSMutableDictionary *report = [NSMutableDictionary dictionaryWithDictionary:[reportModel getParamDict]];
    [report setValuesForKeysWithDictionary:[LogManager getSerLogEventDictWithType:HICMyRecordClickToKnowledge]];
    [LogManager reportSerLogWithDict:report];
    if (courseModel.courseKLDType >= 0 && [NSString isValidStr:courseModel.courseKLDId.stringValue]) {
        if (courseModel.courseKLDType == 7) {
            HICKnowledgeDetailVC *vc = [HICKnowledgeDetailVC new];
            vc.kType = courseModel.resourceType;
            vc.objectId = courseModel.courseKLDId;
            vc.partnerCode = courseModel.partnerCode;
            [self.navigationController pushViewController:vc animated:YES];
        }else if (courseModel.courseKLDType == 6) {
            HICLessonsVC *lessVC = [HICLessonsVC new];
            lessVC.objectID = courseModel.courseKLDId ?courseModel.courseKLDId:@0 ;
            [self.navigationController pushViewController:lessVC animated:YES];
        }
    }
    
}
@end
                                 
