//
//  HICLessonsVC.m
//  HiClass
//
//  Created by WorkOffice on 2020/2/4.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICLessonsVC.h"
#import "HICLessonIntroductView.h"
#import "HICIndexView.h"
#import "HICBaseInfoModel.h"
#import "HICStudyBtmView.h"
#import "HICStudyShareView.h"
#import "HICCommentView.h"
#import "HICCommentWriteView.h"
#import "HICCommentModel.h"
#import "HICCheckNoteView.h"
#import "HICCourseDownloadView.h"
#import "HICCourseDownloadModel.h"
#import "HICCircleProgressView.h"
#import "HICCollectionHintView.h"
#import "HICCommentPopupView.h"
#import "HICCoursePlayRecordModel.h"
#import "HICKldSectionLIstModel.h"
#import "HICCourseKLDModel.h"
#import "HICCourseModel.h"
#import "HICCourseListModel.h"
#import "HICControlInfoModel.h"
#import "HICStudyVideoPlayExercisesListVC.h"
#import "HICStudyVideoPlayRelatedListVC.h"
#import "HICKnowledgeDetailVC.h"
#import "HomeTaskCenterDefaultView.h"
#import "HICCourseExamInfoModel.h"
#import "HICExamCenterDetailVC.h"
static NSString *logName = @"[HIC][LVC]";

@interface HICLessonsVC ()<UIScrollViewDelegate,HICStudyBtmViewDelegate,HICStudyShareViewDelegate,HICDownloadManagerDelegate, HICCommentWriteViewDelegate>{
    HICStudyBtmView *btmView;
    HICStudyShareView *studyView;
    HICCommentWriteView *cwv;
}
@property(nonatomic, strong) UIImageView *headerView;
@property(nonatomic, strong) UIButton *headerButton;
@property(nonatomic, strong) UILabel *headerTitleLabel;
@property(nonatomic, strong) UIScrollView *contentView;
@property(nonatomic, strong) NSMutableArray *titleBtnArr;
@property(nonatomic, strong) UIScrollView *titleView;
@property(nonatomic, strong) NSArray *titleArr;
@property(nonatomic, strong) UIView *underLine;
@property(nonatomic, assign) NSInteger currentIndex;
@property(nonatomic, strong) HICLessonIntroductView *lessonView;
@property(nonatomic, strong) HICIndexView *indexView;
@property(nonatomic, strong) NSMutableDictionary *postModel;
@property(nonatomic, strong) HICNetModel *netModel;
@property(nonatomic, strong) NSMutableArray *dataArr;
@property(nonatomic, strong) HICBaseInfoModel *baseInfoModel;
@property(nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) HICCoursePlayRecordModel *recordModel;
@property (nonatomic, strong) HICControlInfoModel *controlModel;
@property (nonatomic, strong)NSArray *recommendArr;
@property (nonatomic, strong)NSArray *exciseArr;
@property (nonatomic, strong)NSNumber *knowledgeId;
@property (nonatomic, assign)NSInteger knowledgeType;
@property (nonatomic, copy)NSString *partnerCode;
@property (nonatomic, assign)NSInteger knowledgeResource;
@property (nonatomic, assign) BOOL haveNote;
@property (nonatomic, strong)HomeTaskCenterDefaultView *defaultView;
@property (nonatomic ,strong)NSArray *downloadingArr;
@property (nonatomic ,strong)UIButton *backbutton;
@property (nonatomic ,strong)NSNumber *examId;
@property (nonatomic ,strong)NSNumber *sectionId;
@end

@implementation HICLessonsVC


#pragma mark ---生命周期
- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    [self loadData];
    [HICCommonUtils setDarkStatusBar:NO];
    [self uploadLog];
}
- (void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = NO;
    [HICCommonUtils setDarkStatusBar:YES];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    self.currentIndex = 1;
    [self createTabView];
    [self createHeader];
    [self createUI];
    [self createViews];
    [self requestData];
    [self addObservers];
}
- (void)uploadLog {
    HICStudyLogReportModel *reportModel = [[HICStudyLogReportModel alloc]initWithType:HICStudyExplosion];
    reportModel.mediaid = _objectID ?_objectID:@0 ;
    reportModel.knowtype = @-1;
    reportModel.mediatype = [NSNumber numberWithInteger:HICReportCourseType];
    NSMutableDictionary *report = [NSMutableDictionary dictionaryWithDictionary:[reportModel getParamDict]];
    [report setValuesForKeysWithDictionary:[LogManager getSerLogEventDictWithType:HICStudyExplosion]];
    [LogManager reportSerLogWithDict:report];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)requestData {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setValue:@(6) forKey:@"objectType"];
        [dic setValue:self->_objectID forKey:@"objectId"];
        [dic setValue:@(1) forKey:@"terminalType"];
        [HICAPI studyNoteDetail:dic success:^(NSDictionary * _Nonnull responseObject) {
            NSDictionary *data = [responseObject valueForKey:@"data"];
            if (data) {
                NSArray * learningNotesList = [data valueForKey:@"learningNotesList"];
                if ([HICCommonUtils isValidObject:learningNotesList] && learningNotesList.count > 0) {
                    self.haveNote = YES;
                    [self->studyView hasNote:self.haveNote];
                } else if (learningNotesList.count == 0) {
                    self.haveNote = NO;
                    [self->studyView hasNote:self.haveNote];
                }
            }
        } failure:^(NSError * _Nonnull error) {
            DDLogDebug(@"error");
        }];
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setValue:@"6" forKey:@"typeCode"];
        [dict setValue:self->_objectID forKey:@"objectid"];
        [dict setValue:@"9999" forKey:@"productCode"];
        [dict setValue:@(0) forKey:@"start"];
        [dict setValue:@(1) forKey:@"rows"];
        [HICAPI commentList:dict success:^(NSDictionary * _Nonnull responseObject) {
            NSNumber *totalnum = (NSNumber *)[responseObject valueForKey:@"totalnum"];
            if ([HICCommonUtils isValidObject:totalnum]) {
                [self->btmView updateCommentsCount:[totalnum toString]];
            }
        } failure:^(NSError * _Nonnull error) {
            DDLogDebug(@"error");
        }];
    });
}

- (void)addObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshNoteDataHandler) name:@"EIXT_NOTE_LIST_POP_WINDOW" object:nil];
}

- (void)refreshNoteDataHandler {
    [self requestData];
}

//创建顶部视图
- (void)createHeader {
    UIImage *image = [UIImage imageNamed:@""];
    self.headerView.image = image;
    self.headerView.userInteractionEnabled = YES;
    [self.view addSubview:self.headerView];
    [self.headerView addSubview:self.maskView];
    self.maskView.userInteractionEnabled = YES;
    self.backbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    _backbutton.frame = CGRectMake(16, 31 - 20 + HIC_StatusBar_Height, 12, 22);
    [_backbutton hicChangeButtonClickLength:30];
    [_backbutton setImage:[UIImage imageNamed:@"头部-返回-白色"] forState:UIControlStateNormal];
    [_backbutton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.maskView addSubview:_backbutton];
    self.headerTitleLabel  = [[UILabel alloc]init];
    self.headerTitleLabel.textColor = [UIColor whiteColor];
    self.headerTitleLabel.font = FONT_MEDIUM_17;
    self.headerTitleLabel.text = NSLocalizableString(@"firstStartStudy", nil);
    self.headerTitleLabel.textAlignment = NSTextAlignmentCenter;
    [self.maskView addSubview:self.headerTitleLabel];

    self.headerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.headerButton setTitle:NSLocalizableString(@"continueLearn", nil) forState:UIControlStateNormal];
     self.headerButton.titleLabel.font = FONT_MEDIUM_15;
    [self.headerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.headerButton.layer.cornerRadius = 4;
    self.headerButton.clipsToBounds = YES;
    [self.headerButton addTarget:self action:@selector(clickButton) forControlEvents:UIControlEventTouchUpInside];
    [self.maskView addSubview:self.headerButton];

}
//创建tableview
- (void)createTabView {
    self.titleView.backgroundColor = UIColor.whiteColor;
    self.titleView.pagingEnabled = YES;
    self.titleView.showsHorizontalScrollIndicator = NO;
    self.titleView.delegate = self;
    self.titleView.backgroundColor = [UIColor colorWithHexString:@"#E6E6E6"];
    [self.view addSubview:self.titleView];
    self.titleView.contentSize = CGSizeMake(HIC_ScreenWidth, 0);

    for (int i = 0; i < self.titleArr.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i;
        if(i == 0){
            [btn setTitleColor:[UIColor colorWithHexString:@"#00BED7"] forState:UIControlStateNormal];
        }else{
            [btn setTitleColor:[UIColor colorWithHexString:@"#858585"] forState:UIControlStateNormal];
        }
        btn.backgroundColor = UIColor.whiteColor;
        [btn setTitleColor:[UIColor colorWithHexString:@"#00BED7"] forState:UIControlStateSelected];
        [btn setTitle:self.self.titleArr[i] forState:UIControlStateNormal];
        btn.titleLabel.font = FONT_MEDIUM_17;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.frame = CGRectMake( i * HIC_ScreenWidth /2, 0, HIC_ScreenWidth /2, 47.5);
        [self.titleView addSubview:btn];
        [self.titleBtnArr addObject:btn];
    }
    self.underLine.backgroundColor = [UIColor colorWithHexString:@"#00BED7"];
    [self.view addSubview:self.underLine];
    
}
//创建contentscrollview
- (void)createContentView {
    self.contentView.pagingEnabled = YES;
    self.contentView.bounces = NO;
    self.contentView.showsHorizontalScrollIndicator = NO;
    self.contentView.showsVerticalScrollIndicator = NO;
    self.contentView.contentSize = CGSizeMake(HIC_ScreenWidth * self.titleArr.count, 0);
    self.contentView.delegate = self;
    [self.contentView addSubview:self.lessonView];
    [self.contentView addSubview:self.indexView];
    UIButton *btn = (UIButton *)[self.view viewWithTag:self.currentIndex];

    [self btnClick:btn];
}
//加载数据
- (void)loadData{
    [self.postModel setObject:@6 forKey:@"objectType"];
    //    [self.postModel setObject:@1831037005 forKey:@"customerId"];
    [self.postModel setObject:_objectID forKey:@"objectId"];
    [self.postModel setObject:@1 forKey:@"terminalType"];
    [self.postModel setValue:_trainId ? _trainId :@-1 forKey:@"trainInfoId"];
    [HICAPI knowledgeAndCourseDetails:self.postModel success:^(NSDictionary * _Nonnull responseObject) {
        if (responseObject) {
            self.baseInfoModel = [HICBaseInfoModel mj_objectWithKeyValues:responseObject[@"data"][@"baseInfo"]];
            self.controlModel = [HICControlInfoModel mj_objectWithKeyValues:responseObject[@"data"][@"controlInfo"]];
            btmView.knowType = [NSNumber numberWithInteger:self.baseInfoModel.resourceType];
            if ([NSString isValidStr:[NSString stringWithFormat:@"%ld",(long)self.controlModel.collectionFlag]]) {
                if (self.controlModel.collectionFlag == 1) {
                    [self->btmView isAlreadyCollected];
                }
            }
            if ([NSString isValidStr:[NSString stringWithFormat:@"%ld",(long)self.controlModel.likeFlag]]) {
                if (self.controlModel.likeFlag == 1) {
                    [self->btmView isAlreadyThumbup];
                }
            }
            self.lessonView.baseModel = [HICBaseInfoModel mj_objectWithKeyValues:responseObject[@"data"][@"baseInfo"]];
            self.lessonView.arrExercise = responseObject[@"data"][@"exerciseList"];
            self.lessonView.arrRelated = responseObject[@"data"][@"recommendList"];
            self.lessonView.trainId = _trainId;
            if (responseObject[@"data"][@"kldSectionList"]) {
                self.indexView.dataArr = responseObject[@"data"][@"kldSectionList"];
                if (self.controlModel.jumpFlag == 0) {
                    self.indexView.isJumpChapter = NO;
                }else{
                    self.indexView.isJumpChapter = YES;
                }
            }
            if ([HICCommonUtils isValidObject:responseObject[@"data"][@"playRecordInfo"]]){
                self.recordModel = [HICCoursePlayRecordModel mj_objectWithKeyValues:responseObject[@"data"][@"playRecordInfo"]];
                self.sectionId = self.recordModel.sectionId;
                if ([NSString isValidStr:[NSString stringWithFormat:@"%ld",(long)self.recordModel.recordId]]){
                    self.knowledgeId = self.recordModel.courseId;
                    //                    self.knowledgeType = self.recordModel.fileType;
                    [self.headerButton setTitle:NSLocalizableString(@"continueLearn", nil) forState:UIControlStateNormal];
                    if (self.indexView.dataArr.count > 0) {
                        for (NSDictionary *dic in self.indexView.dataArr) {
                            HICKldSectionLIstModel *model = [HICKldSectionLIstModel mj_objectWithKeyValues:dic];
                            if (model.chapterId == self.recordModel.sectionId) {
                                for (NSDictionary *dic1 in model.courseList) {
                                    HICBaseInfoModel *model1 = [HICBaseInfoModel mj_objectWithKeyValues:dic1[@"courseInfo"]];
                                    if ([model1.courseID integerValue] == [self.recordModel.courseId integerValue]) {
                                        self.headerTitleLabel.text = [NSString stringWithFormat:@"%@%@",model.name,model1.name];
                                        self.knowledgeType = model1.resourceType;
                                        self.partnerCode = model1.partnerCode;
                                    }
                                }
                            }
                        }
                    }
                }
            }else{
                if (self.indexView.dataArr.count > 0) {
                    for (int i = 0; i < self.indexView.dataArr.count; i ++) {
                        HICKldSectionLIstModel *listModel = [HICKldSectionLIstModel mj_objectWithKeyValues:self.indexView.dataArr[i]];
                        if (listModel.courseList.count > 0) {
                            self.sectionId = listModel.chapterId;
                            HICCourseListModel *courseModel = [HICCourseListModel mj_objectWithKeyValues:listModel.courseList[0]];
                            HICBaseInfoModel *baseCourse = [HICBaseInfoModel mj_objectWithKeyValues:courseModel.courseInfo];
                            if ([HICCommonUtils isValidObject:baseCourse]) {
                                self.headerTitleLabel.text = [NSString stringWithFormat:@"%@%@",listModel.name,baseCourse.name];
                                self.knowledgeId = baseCourse.courseID;
                                self.knowledgeType = baseCourse.resourceType;
                                [self.headerButton setTitle:NSLocalizableString(@"startStudy", nil) forState:UIControlStateNormal];
                                break;
                            }
                            HICCourseExamInfoModel *examModel = [HICCourseExamInfoModel mj_objectWithKeyValues:courseModel.examInfo[@"baseInfo"]];
                            if ([HICCommonUtils isValidObject:examModel]) {
                                self.headerTitleLabel.text = examModel.name;
                                self.examId = [NSNumber numberWithInteger:examModel.examId];
                                [self.headerButton setTitle:NSLocalizableString(@"startStudy", nil) forState:UIControlStateNormal];
                                break;
                            }
                        }
                    }
                }
            }
            
            if ([NSString isValidStr:self.baseInfoModel.coverPic]) {
                [self.headerView sd_setImageWithURL:[NSURL URLWithString:self.baseInfoModel.coverPic]];
                self.headerView.contentMode = UIViewContentModeScaleAspectFit;
            }
            
            [self createContentView];
        }
    } failure:^(NSError * _Nonnull error) {
        if (error.code == 40005) {
            [self.view addSubview:self.defaultView];
            self.maskView.backgroundColor = [UIColor whiteColor];
            [self.backbutton setImage:[UIImage imageNamed:@"头部-返回"] forState:UIControlStateNormal];
        }
    }];
}

//创建底部view
- (void)createViews {
    // 底部按钮集View
    btmView = [[HICStudyBtmView alloc] initWithFrame:CGRectMake(0, HIC_ScreenHeight - 52 - HIC_BottomHeight, HIC_ScreenWidth, 52 + HIC_BottomHeight) numberOfComments:@"0"];
    [btmView customLeftBtns:@[] rightBtns:@[@{NSLocalizableString(@"writeComment", nil):@"BT-写评论"}, @{NSLocalizableString(@"collection", nil):@"BT-收藏"}, @{NSLocalizableString(@"giveLike", nil):@"BT-点赞"}, @{NSLocalizableString(@"more", nil):@"更多操作"}]]; //, @{@"翻页":@"BT-翻页"}
    btmView.delegate = self;
    btmView.btmType = HICStudyBtmViewCourse;
    btmView.kldId = _objectID;
    [self.view addSubview:btmView];
}
- (void)btnClick:(UIButton *)btn {
        CGFloat offsetX = btn.center.x - HIC_ScreenWidth * 0.5;
        if (offsetX < 0) offsetX = 0;
        CGFloat maxOffsetX = self.titleView.contentSize.width - HIC_ScreenWidth;
        if (offsetX > maxOffsetX) offsetX = maxOffsetX;
        [self.titleView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
        [self setItemSelected:btn.tag];
        self.currentIndex = btn.tag;
        self.contentView.contentOffset = CGPointMake(btn.tag * HIC_ScreenWidth, 0);
}
- (void)setItemSelected:(NSInteger)index{
    for (int i = 0; i < self.titleBtnArr.count; i ++) {
        UIButton *btn = self.titleBtnArr[i];
        if (btn.tag == index) {
            [btn setTitleColor:[UIColor colorWithHexString:@"#00BED7"] forState:UIControlStateNormal];
            [self.underLine setCenter:CGPointMake(btn.center.x, 47 + lessonTopHeight)];
        } else {
            [btn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
        }
    }
}
- (void)createUI {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.contentView];
    [self updateViewConstraints];
}
- (void)updateViewConstraints {
    [super updateViewConstraints];
    [self.headerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView).offset(125 + HIC_StatusBar_Height - 20);
        make.left.equalTo(self.headerView).offset(HIC_ScreenWidth / 2 - 45);
        make.height.offset(36);
        make.width.offset(90);
    }];
    [self.headerTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView).offset(87 + HIC_StatusBar_Height - 20);
        make.width.offset(HIC_ScreenWidth - 32);
        make.left.equalTo(self.headerView).offset(16);
    }];
    [self.view layoutIfNeeded];
    [HICCommonUtils createGradientLayerWithBtn:self.headerButton fromColor:[UIColor colorWithHexString:@"00E2D8" alpha:1.0f] toColor:[UIColor colorWithHexString:@"00C5E0" alpha:1.0f]];
}

- (void)clickButton {
    if ([NSString isValidString:self.knowledgeId.stringValue]) {
        HICKnowledgeDetailVC *vc = [HICKnowledgeDetailVC new];
        vc.kType = self.knowledgeType;
        vc.partnerCode = self.partnerCode;
        vc.objectId = self.knowledgeId;
        vc.trainId = _trainId;
        vc.courseId = self.baseInfoModel.courseID;
        vc.sectionId = self.sectionId;
        if (self.baseInfoModel.resourceType == HICScromType || self.baseInfoModel.resourceType == HICHtmlType ) {
            vc.urlStr = self.baseInfoModel.mediaInfoList[0][@"url"];
            vc.hideNavi = YES;
            vc.hideTabbar = YES;
        }
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        HICExamCenterDetailVC *vc = HICExamCenterDetailVC.new;
        vc.examId = self.examId.stringValue;
        vc.trainId = [NSString stringWithFormat:@"%@",_trainId];         vc.courseId = [NSString stringWithFormat:@"%@",_objectID];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (void)backButtonClick {
    if (self.presentingViewController && self.navigationController.viewControllers.count == 1) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark -scrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat offSetX = scrollView.contentOffset.x;
    NSInteger pageNum = offSetX / HIC_ScreenWidth;
    self.currentIndex = pageNum;
    [self setItemSelected:pageNum];
}
#pragma mark - - - HICStudyBtmViewDelegate - - - Start
- (void)moreBtnClick {
    DLManager.delegate = self;
    BOOL hasExercise = NO;
    if ([HICCommonUtils isValidObject:self.lessonView.arrExercise]) {
        if (self.lessonView.arrExercise.count > 0) {
            hasExercise = YES;
        }
    }
    BOOL hasRelated = NO;
    if ([HICCommonUtils isValidObject:self.lessonView.arrRelated]) {
        if (self.lessonView.arrRelated.count > 0) {
            hasRelated = YES;
        }
    }

    HICDownloadStatus status = HICDownloadIdle;
    NSArray *kModelArr = [DBManager selectMediasByMediaId:self.objectID isCourseId:YES];
    if (kModelArr.count > 0) {
        HICKnowledgeDownloadModel *kModel = kModelArr.firstObject;
        if (kModel.mediaCount == kModelArr.count) {
            status = HICDownloadFinish;
        }
    }

    studyView = [[HICStudyShareView alloc] initWithDownloadStatus :status type:HICStudyBtmViewCourse subType:HICVideoType hasNote:self.haveNote itemsShow:self.controlModel hasExercise:hasExercise hasRelated:hasRelated andMediaId:_objectID];
    studyView.delegate = self;
    [self.view addSubview:studyView];
}

- (void)commentBtnClick {
    cwv = [[HICCommentWriteView alloc] initWithType:HICCommentWrite commentTo:@"二哈" identifer:[self.baseInfoModel.courseID toString]];
    [self.view addSubview:cwv];
    if (!cwv.delegate) {
        cwv.delegate = self;
    }
}

- (void)commentSectionBtnClick {
    HICCommentPopupView *cpv = [[HICCommentPopupView alloc] initWithVideoSectionHeight:191 + HIC_StatusBar_Height isFromCourse:YES identifier:[self.baseInfoModel.courseID toString]];
    cpv.onView = self.view;
    [self.view addSubview:cpv];
}

- (void)thumbup:(BOOL)isThumbup {
    isThumbup ? self.lessonView.baseModel.userLikeNum++ : self.lessonView.baseModel.userLikeNum--;
    [self.lessonView reloadData];
}

- (void)collectionSuccess:(BOOL)success {
    if (success) {
        if (!HIC_COLLECTION_HINT_SHOWN) {
            if (self.controlModel.collectionFlag == 1) {
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HICCollectionHintShown"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                return;
            }
            HICCollectionHintView *hv = [[HICCollectionHintView alloc] init];
            [self.view addSubview:hv];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HICCollectionHintShown"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    } else {
//        DDLogDebug(@"%@ Collection failed", logName);
    }
}
#pragma mark - - - HICStudyBtmViewDelegate - - - End

#pragma mark - - - HICStudyShareViewDelegate - - - Start
- (void)shareTo {
//    NSString *shareTitle = @"这是标题哈哈哈";
//    UIImage *shareImg = [UIImage imageNamed:@"share1"];
    NSURL *shareUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@/mweb/index.html?type=2&objectType=6&objectId=%@&kldType=3", APP_Web_DOMAIN, _objectID]];
    NSArray *activityItems = @[shareUrl];
    UIActivityViewController *activityVc = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    [self presentViewController:activityVc animated:YES completion:nil];
    activityVc.completionWithItemsHandler = ^(UIActivityType _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
        if (completed) {
            DDLogDebug(@"分享成功");
            [self->studyView hideShareView];
        }else{
            DDLogDebug(@"分享取消");
        }
    };
}

- (void)addNoteClicked {
    cwv = [[HICCommentWriteView alloc] initWithType:HICCommentNote commentTo:@"二哈" identifer:[self.baseInfoModel.courseID toString]];
    [self.view addSubview:cwv];
    if (!cwv.delegate) {
        cwv.delegate = self;
    }
}

- (void)checkNoteClicked {
    HICCheckNoteView *cnv = [[HICCheckNoteView alloc] initWithNotes:@[] type:HICStudyBtmViewCourse identifier:[self.baseInfoModel.courseID toString]];
    [self.view addSubview:cnv];
}

- (void)goToDownload:(HICDownloadStatus)downloadStatus type:(HICStudyBtmViewType)type {
    if (type == HICStudyBtmViewKnowledge) {
        DDLogDebug(@"用户点击了【知识】下载");
    } else {
        if (downloadStatus == HICDownloadIdle || downloadStatus == HICDownloadFinish || downloadStatus == HICDownloading) {
            DDLogDebug(@"用户点击了【课程】下载");
            NSMutableArray *temArr = [[NSMutableArray alloc] init];
            NSArray *arr = self.indexView.dataArr;
            NSInteger medieTotalCount = 0; // 该媒资（知识）所属的课程下所有可下载的媒资（知识）数
            for (int i = 0; i < arr.count; i++) {
                NSArray *knowledgeArr = arr[i][@"courseList"];
                for (int j = 0; j < knowledgeArr.count; j++) {
                    NSDictionary *courseInfo = [knowledgeArr[j] valueForKey:@"courseInfo"];
                    NSArray *mediaInfoList = [courseInfo valueForKey:@"mediaInfoList"];
                    if ([HICCommonUtils isValidObject:mediaInfoList] && mediaInfoList.count > 0) {
                        medieTotalCount = medieTotalCount + 1;
                    }
                }
            }
            for (int i = 0; i < arr.count; i++) {
                HICCourseDownloadModel *cModel = [[HICCourseDownloadModel alloc] init];
                cModel.mediaId = arr[i][@"id"]; // 章节id
                cModel.mediaName = arr[i][@"name"];
                NSArray *knowledgeArr = arr[i][@"courseList"];
                CGFloat mediaTotalSize = 0.0;
                NSMutableArray *knowledgeModelArr = [[NSMutableArray alloc] init];
                for (int j = 0; j < knowledgeArr.count; j++) {
                    NSDictionary *courseInfo = [knowledgeArr[j] valueForKey:@"courseInfo"];
                    if ([HICCommonUtils isValidObject:courseInfo]) {
                        NSInteger resourceType = [[courseInfo valueForKey:@"resourceType"] integerValue];
                        NSArray *mediaInfoList = [courseInfo valueForKey:@"mediaInfoList"];
                        if ([HICCommonUtils isValidObject:mediaInfoList] && mediaInfoList.count > 0) {
                            NSDictionary *media = mediaInfoList.firstObject;
                            HICKnowledgeDownloadModel *kModel = [[HICKnowledgeDownloadModel alloc] init];
                            if (resourceType == HICPictureType || resourceType == HICFileType) {
                                for (int i = 0; i < mediaInfoList.count; i++) {
                                    NSDictionary *aMedia = mediaInfoList[i];
                                    kModel.mediaSize = @([kModel.mediaSize longValue] + [aMedia[@"size"] longValue]);
                                    kModel.mediaURL = [NSString isValidStr:kModel.mediaURL] ? [NSString stringWithFormat:@"%@,%@", kModel.mediaURL, aMedia[@"url"]] : aMedia[@"url"];
                                    if ([aMedia valueForKey:@"fileId"]) {
                                        NSString *fileIdStr = [[aMedia valueForKey:@"fileId"] stringValue];
                                        kModel.fileId = [NSString isValidStr:kModel.fileId] ? [NSString stringWithFormat:@"%@,%@", kModel.fileId, fileIdStr] : fileIdStr;
                                    }
                                }
                            } else if (resourceType == HICVideoType || resourceType == HICAudioType) {
                                if ([media valueForKey:@"fileId"]) {
                                    kModel.fileId = [[media valueForKey:@"fileId"] stringValue];
                                }
                                kModel.mediaSize = media[@"size"];
                                kModel.mediaURL = media[@"url"];
                            } else {
                                DDLogDebug(@"%@ Unknow type: %ld", logName, (long)resourceType);
                            }
                            if ([media valueForKey:@"fileType"]) {
                                kModel.fileType = (NSNumber *)[media valueForKey:@"fileType"];
                            }
                            if ([media valueForKey:@"type"]) {
                                kModel.mediaType = (NSNumber *)[media valueForKey:@"type"];
                            }
                            if ([media valueForKey:@"definition"]) {
                                kModel.definition = (NSInteger)media[@"definition"];
                            }
                            if ([media valueForKey:@"suffixName"]) {
                                kModel.suffixName = media[@"suffixName"];
                            }
                            kModel.sectionId = cModel.mediaId;
                            kModel.mediaId = courseInfo[@"id"];
                            kModel.mediaName = courseInfo[@"name"];
                            kModel.mediaSingle = 0;
                            kModel.coverPic = [NSString isValidStr:[courseInfo valueForKey:@"coverPic"]] ? [courseInfo valueForKey:@"coverPic"] : @"";
                            kModel.cMediaId = self.baseInfoModel.courseID; // 课程id
                            kModel.cMediaName = self.baseInfoModel.name;
                            kModel.cCoverPic = self.baseInfoModel.coverPic;
                            kModel.mediaCount = medieTotalCount;
                            [knowledgeModelArr addObject:kModel];
                            mediaTotalSize = mediaTotalSize + [kModel.mediaSize floatValue];
                        }
                    }
                }
                cModel.knowledgeArr = knowledgeModelArr;
                cModel.mediaSize = [[NSString stringWithFormat:@"%f", mediaTotalSize] toNumber];
                [temArr addObject:cModel];
            }
            HICCourseDownloadView *cdV = [[HICCourseDownloadView alloc] initWithCourseName:self.baseInfoModel.name DownloadArr:temArr];
            [self.view addSubview:cdV];
        } else if (downloadStatus == HICDownloadStop) {
            for (HICKnowledgeDownloadModel *kModel in DLManager.readyForDownloadArr) {
                [DLManager pauseWith:kModel.mediaId];
            }
        } else if (downloadStatus == HICDownloadResume) {
            for (HICKnowledgeDownloadModel *kModel in DLManager.readyForDownloadArr) {
                [DLManager resumeWith:kModel.mediaId];
            }
        }
    }
}
#pragma mark - - - HICStudyShareViewDelegate - - - End

#pragma mark - - - HICDownloadManagerDelegate - - - Start
- (void)downloadProcess:(CGFloat)percent kModel:(HICKnowledgeDownloadModel *)kModel {
    HICDownloadStatus status = HICDownloading;
    if ([DLManager.readyForDownloadArr containsObject:kModel] && percent >= 1.0) {
        [DLManager.readyForDownloadArr removeObject:kModel];
    }
    if (DLManager.readyForDownloadArr.count == 0) {
        status = HICDownloadFinish;
    }
    [studyView updateDownloadStatus:status andProcess:percent];
}
#pragma mark - - - HICDownloadManagerDelegate - - - End

// eddie
#pragma mark - - - HICCommentWriteViewDelegate - - - Start
- (void)publishBtnClickedWithContent:(NSString *)content type:(HICCommentType)type starNum:(NSInteger)stars isImportant:(BOOL)important toAnybody:(NSString *)name {
    [HICAPI publishBtnClickedWithContent:content type:type starNum:stars isImportant:important toAnybody:name objectID:self.objectID typeCode:HICReportCourseType success:^(NSDictionary * _Nonnull responseObject) {
        NSString *hint = @"";
        if (type == HICCommentWrite) { // 发表评论
            hint = NSLocalizableString(@"releaseSuccess", nil);
        } else if (type == HICCommentReply) { // 回复评论
            hint = NSLocalizableString(@"replySuccess", nil);
        } else { // 添加笔记
            hint = NSLocalizableString(@"succeededSddingNotes", nil);
            if (responseObject[@"data"] && [responseObject[@"data"] isKindOfClass:NSDictionary.class]) {
                NSNumber *points = responseObject[@"data"][@"points"];
                if (points && points.integerValue > 0) {
                    hint = [NSString stringWithFormat:@"%@，%@", hint, HICLocalizedFormatString(@"rewardPointsToast", points.integerValue)];
                }
            }
            [self requestData];
        }
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"HICEditedInfoBefore"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [HICToast showWithText:hint];
        [self.view endEditing:YES];
        [UIView animateWithDuration:0.3 animations:^{
            self->cwv.frame = CGRectMake(self->cwv.frame.origin.x, HIC_ScreenHeight, self->cwv.frame.size.width, self->cwv.frame.size.height);
            [self->cwv removeFromSuperview];
        }];
    } failure:^(NSError * _Nonnull error) {
        NSString *hint = @"";
        if (type == HICCommentWrite) { // 发表评论
            hint = NSLocalizableString(@"postFailure", nil);
        } else if (type == HICCommentReply) { // 回复评论
            hint = NSLocalizableString(@"respondFailure", nil);
        } else { // 添加笔记
            hint = NSLocalizableString(@"failedAddNotes", nil);
        }
        [HICToast showWithText:hint];
    }];
}
#pragma mark -lazyload
-(HomeTaskCenterDefaultView *)defaultView{
    if (!_defaultView) {
        _defaultView = [[HomeTaskCenterDefaultView alloc]initWithFrame:CGRectMake(0, HIC_NavBarAndStatusBarHeight, HIC_ScreenWidth, HIC_ScreenHeight - HIC_NavBarAndStatusBarHeight)];
        _defaultView.titleStr = NSLocalizableString(@"noReadingPermissionPrompt", nil);
        _defaultView.imageName = @"无权限";
        _defaultView.number = 2;
    }
    return _defaultView;
}
- (NSArray *)titleArr {
    if(!_titleArr){
        _titleArr = @[NSLocalizableString(@"courseIntroduction", nil),NSLocalizableString(@"directory", nil)];
    }
    return _titleArr;
}
- (UIScrollView *)titleView {
    if (!_titleView) {
        _titleView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, lessonTopHeight, HIC_ScreenWidth, 48)];
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
        _underLine = [[UIView alloc]initWithFrame:CGRectMake(HIC_ScreenWidth /4 - 14, lessonTopHeight + 45, 28, 3)];
    }
    return _underLine;
}
- (UIScrollView *)contentView{
    if (!_contentView) {
        _contentView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, lessonTopHeight + 48, HIC_ScreenWidth, HIC_ScreenHeight - lessonTopHeight  - HIC_BottomHeight - 52 - 48)];
        _contentView.backgroundColor = [UIColor whiteColor];
    }
    return _contentView;
}
- (UIImageView *)headerView{
    if (!_headerView) {
        _headerView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, HIC_ScreenWidth, lessonTopHeight)];
    }
    return _headerView;
}
- (UIView *)maskView{
    if (!_maskView) {
        _maskView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, HIC_ScreenWidth, lessonTopHeight)];
        _maskView.backgroundColor =  [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.5/1.0];
    }
    return _maskView;
}
- (UILabel *)headerTitleLabel{
    if (!_headerTitleLabel) {
        _headerTitleLabel  = [[UILabel alloc]init];
    }
    return _headerTitleLabel;
}
- (HICIndexView *)indexView {
    if (!_indexView) {
        _indexView = [[HICIndexView alloc]initWithVC:self];
        _indexView.courseId = _objectID;
        _indexView.trainId = _trainId;
    }
    return _indexView;
}
- (HICLessonIntroductView *)lessonView{
    if (!_lessonView) {
        _lessonView = [[HICLessonIntroductView alloc]initWithVC:self];
        _lessonView.isInside = NO;
    }
    return _lessonView;
}
- (NSMutableDictionary *)postModel{
    if (!_postModel) {
        _postModel = [[NSMutableDictionary alloc]init];
    }
    return _postModel;
}
- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc]init];
    }
    return _dataArr;
}
#pragma mark - - - HICCommentWriteViewDelegate - - - End

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
