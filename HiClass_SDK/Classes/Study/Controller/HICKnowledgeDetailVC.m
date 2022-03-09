//
//  HICKnowledgeDetailVC.m
//  HiClass/Users/eddiema/Desktop/HiProject/HiClass_iOS/HiClass/StudyOnline
//
//  Created by Eddie Ma on 2020/3/10.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICKnowledgeDetailVC.h"
#import <WebKit/WKWebView.h>
#import "HICStudyBtmView.h"
#import "HICStudyShareView.h"
#import "HICCommentView.h"
#import "HICCommentWriteView.h"
#import "HICCollectionHintView.h"
#import "HICCommentPopupView.h"
#import "HICCheckNoteView.h"
#import "HICCourseDownloadModel.h"
#import "HICCourseDownloadView.h"
#import "HICStudyVideoPlayExercisesListVC.h"
#import "HICStudyVideoPlayRelatedListVC.h"
#import "HICLessonIntroductView.h"
#import "HICControlInfoModel.h"
#import "HICCoursePlayRecordModel.h"
#import "HICStudyDocPhotoDetailView.h"
#import "HICStudyDocPhotoListItemCell.h"
#import <JHKVideoPlayerSDK/JHKVideoPlayerSDK-Swift.h>
#import <HIClassSwift_SDK/HIClassSwift_SDK.h>
#import "HICVideoModel.h"
#import "HICLessonContentCell.h"
#import "HICStudyVideoPlayExercisesCell.h"
#import "HICStudyVideoPlayRelatedCell.h"
#import "HICLessonIntroductCell.h"
#import "HICStudyVideoPlayCommentCell.h"
#import "HICContributorListVC.h"
#import "HICKonwledgeMaskTableView.h"
#import "HICLessonsVC.h"
#import "HICCourseModel.h"
#import "HICExamCenterDetailVC.h"
#import "HICExerciseModel.h"
#import "HICStudyLogReportModel.h"
#import "HomeTaskCenterDefaultView.h"
#import "HICExamCenterDetailVC.h"
#import "HICWeakScriptMessageDelegate.h"

static NSString *logName = @"[HIC][KDVC]";

//智胜webview播放器播放/停止打点上报的方法名
static NSString *zhiShengJSMethodName = @"reportLearningRecord";

@interface HICKnowledgeDetailVC () <HICCustomNaviViewDelegate, HICCommentViewDelegate,HICStudyBtmViewDelegate,HICStudyShareViewDelegate,HICDownloadManagerDelegate, UITableViewDelegate, UITableViewDataSource, HICStudyDocPhotoDetailDelegate, HICLessonIntroductDelegate, HICStudyVideoPlayBaseCellDelegate,HICLessonContentDelegate,JHKVideoPlayerOCDelegate,HICCommentWriteViewDelegate, WKScriptMessageHandler> {
    HICStudyShareView *studyView;
    HICCommentWriteView *cwv;
    HICSDKHelper *helper;
    HICSDKVideoPlayer *playerHelper;
}

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIView *container;
@property (nonatomic, strong) UIView *insideView;

@property (nonatomic, strong)NSTimer *observerTimer;
@property (nonatomic, assign)BOOL isObserver;

@property (nonatomic, strong) NSMutableDictionary *postModel;
@property (nonatomic, strong) HICNetModel *netModel;
@property (nonatomic, strong) HICControlInfoModel *controlModel;
@property (nonatomic, strong) HICBaseInfoModel *baseInfoModel;
@property (nonatomic, strong) HICCoursePlayRecordModel *recordModel;
@property (nonatomic, assign) BOOL haveNote;
@property (nonatomic, strong) NSTimer *sysTimer;
@property (nonatomic, strong) NSNumber *startStamp;
@property (nonatomic, strong) NSNumber *endStamp;

@property (nonatomic, strong) HICCustomNaviView *navi;
@property (nonatomic, strong) HICLessonIntroductView *inductView;
@property (nonatomic, strong) HICStudyVideoPlayRelatedListVC *relatedVC;
@property (nonatomic, strong) HICStudyVideoPlayExercisesListVC *exericiseVC;
@property (nonatomic, strong) NSString *naviTitle;
@property (nonatomic, strong) UILabel *maskTitleLabel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) HICStudyBtmView *btmView;
@property (nonatomic, strong) UIButton *backbutton;
@property (nonatomic, strong) UIButton *rotateBtn;
// 图片详情
@property (nonatomic, strong) UILabel *topTimeLabel;
@property (nonatomic, strong) NSMutableArray *tableViewDataSource;
@property (nonatomic, strong) UILabel *numPageLabel;
@property (nonatomic, strong) UISlider *pageSlider;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) HICStudyDocPhotoDetailView *detailView;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic ,strong) UIView *topTimeBackView;
@property (nonatomic ,strong) UIView *docPhotoBackView;

// 音视频详情
@property (nonatomic, strong) UIView *videoPlayBackView;
@property (nonatomic, strong) NSArray *exciseArr;
@property (nonatomic, strong) NSArray *recommendArr;
@property (nonatomic, strong) JHKVideoPlayer *videoPlayer;
@property (nonatomic, strong) NSMutableArray *mediaArr;
@property (nonatomic, strong) UIImageView *fileView;
@property (nonatomic, strong) UILabel *fileLabel;
@property (nonatomic, strong) NSString *titleStr;
@property (nonatomic, assign) NSInteger videoIndex;
@property (nonatomic, strong) NSNumber *currentDuration;
@property (nonatomic, strong) NSNumber *startDuration;
@property (nonatomic, assign) BOOL startAgain;

@property (nonatomic, strong) WKWebView *webView;

@property (nonatomic, strong) NSNumber *completeFlag;       // 第三方内嵌播放器回调是否完成
@property (nonatomic, assign) BOOL firstAlive;              // 第三方内嵌播放器第一次心跳
@property (nonatomic, assign) BOOL hadToastDragNotRecord;   // 只提示一次音视频快进不累计学分
@property (nonatomic, assign) BOOL hadToastWillJumpNext;    // 只提示一次音视频自动跳转
@property (nonatomic, assign) BOOL hadToastStudyFinished;    // 只提示一次文档知识已学习完成

@property (nonatomic, strong) HICStudyLogReportModel *model;
@property (nonatomic, assign) BOOL isStart;
@property (nonatomic, assign) BOOL isEnd;
@property (nonatomic, strong) HomeTaskCenterDefaultView *defaultView;
@property (nonatomic, assign) NSTimeInterval startDate;

@property (nonatomic, assign) CGFloat speed;
@property (nonatomic, assign) BOOL isFullScreen;
@property (nonatomic, strong) UIView *alertView;
@property (nonatomic, assign) BOOL isLandscape;
@property (nonatomic, assign) BOOL needsHideDetailView;
@property (nonatomic, readonly, assign)CGFloat learningRate;

@property (nonatomic, assign) BOOL hasNextCourse;


@end

@implementation HICKnowledgeDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.currentPage = 1;
    self.speed = 1.0;
    self.startDuration = @0;
    self.currentDuration = @(0);
    self.startDate = [[NSDate date] timeIntervalSince1970];
    self.isObserver = NO;
    if (_kType == HICAudioType ||_kType == HICVideoType || _kType == HICFileType || _kType == HICPictureType) {
        self.sysTimer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(reportRecordWithReportType:) userInfo:nil repeats:YES];
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
    if (!self.navigationController.isNavigationBarHidden) {
        self.navigationController.navigationBarHidden = YES;
    }
    [self createUI];
    [self initData]; // 请求数据，初始化了VideoPlayerHelper
    [self requestData];
    [self addObservers];
    self.isLandscape = NO;
    [self getNextCoursWithReloadData:NO];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    self.currentPage = 1;
    self.currentDuration = @0;
    if (_kType == HICAudioType || _kType == HICVideoType || _kType == HICZipType || _kType == HICPictureType || _kType == HICScromType || _kType == HICWebVideoType) {
        [HICCommonUtils setDarkStatusBar:NO];
    }else{
        [HICCommonUtils setDarkStatusBar:YES];
    }
    self.tabBarController.tabBar.hidden = YES;
    NSInteger temp = [[HICCommonUtils getNowTimeTimestamp] integerValue];
    self.startStamp = [NSNumber numberWithInteger:temp];
    [self uploadLog];
    SystemManager.allowRotation = (_kType == HICPictureType || _kType == HICFileType || _kType == HICWebVideoType);
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = NO;
    [HICCommonUtils setDarkStatusBar:YES];
    NSInteger temp = [[HICCommonUtils getNowTimeTimestamp] integerValue];
    self.endStamp = [NSNumber numberWithInteger:temp];
    self.isEnd = YES;
    [self reportRecordWithReportType:1];
    [playerHelper pause];
    [self.timer invalidate];
    [self.sysTimer invalidate];
    [self.observerTimer invalidate];
    SystemManager.allowRotation = NO;
    [self setInterfaceOrientation:UIInterfaceOrientationPortrait];
}
- (void)uploadLog {
    HICStudyLogReportModel *reportModel = [[HICStudyLogReportModel alloc]initWithType:HICStudyExplosion];
    reportModel.mediaid = _objectId ? _objectId : @0 ;
    reportModel.knowtype = _kType ? [NSNumber numberWithInteger:_kType]:@-1;
    reportModel.mediatype = [NSNumber numberWithInteger:HICReportKnowledgeType];
    NSMutableDictionary *report = [NSMutableDictionary dictionaryWithDictionary:[reportModel getParamDict]];
    [report setValuesForKeysWithDictionary:[LogManager getSerLogEventDictWithType:HICStudyExplosion]];
    [LogManager reportSerLogWithDict:report];
}
- (void)dealloc {
    [self.timer invalidate];
    [self.sysTimer invalidate];
    [self.observerTimer invalidate];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (_webView) {
        [[_webView configuration].userContentController removeScriptMessageHandlerForName:zhiShengJSMethodName];
    }
}
- (void)runObserver {
    NSMutableAttributedString *messageStr = [[NSMutableAttributedString alloc] initWithString:NSLocalizableString(@"qinAsk", nil)];
    [messageStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1/1.0] range:NSMakeRange(0,9)];
    [messageStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14]range:NSMakeRange(0,9)];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizableString(@"studyTips", nil) message:messageStr.string preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:NSLocalizableString(@"confirm", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        __weak typeof(self) weakSelf = self;
        self.observerTimer = [NSTimer timerWithTimeInterval:weakSelf.controlModel.notOperatedIntervel * 60 target:weakSelf selector:@selector(runObserver) userInfo:nil repeats:YES];
        [self->playerHelper play];
        [[NSRunLoop currentRunLoop] addTimer:self.observerTimer forMode:NSDefaultRunLoopMode];
    }];
    [confirm setValue:[UIColor colorWithHexString:@"#00BED7"] forKey:@"titleTextColor"];
    [alert setValue:messageStr forKey:@"attributedMessage"];
    [playerHelper pause];
    if (!_isFullScreen) {
        [self presentViewController:alert animated:YES completion:nil];
        [alert addAction:confirm];
    } else {
        [[UIApplication sharedApplication].delegate.window addSubview:self.alertView];
    }
    [self.observerTimer invalidate];
}
- (UIView *)alertView {
    if (!_alertView) {
        CGFloat width = HIC_ScreenWidth - 92;
        _alertView = [[UIView alloc]initWithFrame:CGRectMake(46, HIC_ScreenHeight / 2 - 50, width, 120)];
        _alertView.backgroundColor = UIColor.whiteColor;
        _alertView.layer.cornerRadius = 10;
        _alertView.clipsToBounds = YES;
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, width, 30)];
        title.text = NSLocalizableString(@"studyTips", nil);
        title.textColor = TEXT_COLOR_DARK;
        title.font = FONT_MEDIUM_18;
        title.textAlignment = NSTextAlignmentCenter;
        [_alertView addSubview:title];
        
        UILabel *message = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, width, 30)];
        message.text = NSLocalizableString(@"areYouStillStudying", nil);
        message.textColor = TEXT_COLOR_LIGHTM;
        message.font = FONT_REGULAR_14;
        message.textAlignment = NSTextAlignmentCenter;
        [_alertView addSubview:message];
        
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 80, width, 0.5)];
        line.backgroundColor = DEVIDE_LINE_COLOR;
        [_alertView addSubview:line];
        
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(20, 81, width-40, 40)];
        [button setTitle:NSLocalizableString(@"confirm", nil) forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:@"#00BED7"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(removeAlert) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_alertView addSubview:button];
        
        CGAffineTransform transform = CGAffineTransformIdentity;
        transform = CGAffineTransformRotate(transform, M_PI_2);
        _alertView.transform = transform;
    }
    return _alertView;
}

- (void)removeAlert {
    if ([[UIApplication sharedApplication].delegate.window.subviews containsObject:self.alertView]) {
        [self.alertView removeFromSuperview];
        __weak typeof(self) weakSelf = self;
        self.observerTimer = [NSTimer timerWithTimeInterval:weakSelf.controlModel.notOperatedIntervel *60  target:weakSelf selector:@selector(runObserver) userInfo:nil repeats:YES];
        [playerHelper play];
        [[NSRunLoop currentRunLoop] addTimer:self.observerTimer forMode:NSDefaultRunLoopMode];
    }
}

- (void)initData {
    self.naviTitle = @"";
    helper = [[HICSDKHelper alloc]init];
    playerHelper = [[HICSDKVideoPlayer alloc]init];
    self.postModel = [NSMutableDictionary new];
    [self.postModel setObject:@7 forKey:@"objectType"];
    [self.postModel setValue:_objectId forKey:@"objectId"];
    [self.postModel setValue:_trainId ? _trainId :@-1 forKey:@"trainInfoId"];
    [self.postModel setValue:_sectionId ? _sectionId :@-1 forKey:@"sectionId"];
    [self.postModel setValue:@1 forKey:@"terminalType"];
    [HICAPI knowledgeAndCourseDetails:self.postModel success:^(NSDictionary * _Nonnull responseObject) {
        if (responseObject) {
            self.baseInfoModel = [HICBaseInfoModel mj_objectWithKeyValues:responseObject[@"data"][@"baseInfo"]];
            self.controlModel = [HICControlInfoModel mj_objectWithKeyValues:responseObject[@"data"][@"controlInfo"]];
            self.btmView.knowType = [NSNumber numberWithInteger:self.baseInfoModel.resourceType];
            if ([NSString isValidStr:[NSString stringWithFormat:@"%ld",(long)self.controlModel.collectionFlag]]) {
                if (self.controlModel.collectionFlag == 1) {
                    [self->_btmView isAlreadyCollected];
                }
            }
            if ([NSString isValidStr:[NSString stringWithFormat:@"%ld",(long)self.controlModel.likeFlag]]) {
                if (self.controlModel.likeFlag == 1) {
                    [self->_btmView isAlreadyThumbup];
                }
            }
            if ([NSString isValidStr:[NSString stringWithFormat:@"%ld",(long)self.controlModel.notOperatedIntervel]]) {
                if (self.controlModel.notOperatedIntervel != 0) {
                    __weak typeof(self) weakSelf = self;
                    self.observerTimer = [NSTimer timerWithTimeInterval:weakSelf.controlModel.notOperatedIntervel *60 target:weakSelf selector:@selector(runObserver) userInfo:nil repeats:YES];
                    self.isObserver = YES;
                }
            }
            self.naviTitle = self.baseInfoModel.name;
            [self.navi modifyTitleLabel:self.baseInfoModel.name];
            if (self.kType == HICPictureType || self.kType == HICFileType) {
                [self formatTopTime];
                NSDictionary *playRecordInfo = responseObject[@"data"][@"playRecordInfo"];
                [self initPicDetailWithData:playRecordInfo];
                
                if (self.isObserver) {
                    [[NSRunLoop currentRunLoop] addTimer:self.observerTimer forMode:NSDefaultRunLoopMode];
                }
            } else if (self.kType == HICVideoType || self.kType == HICAudioType || self.kType == HICZipType || self.kType == HICScromType) {
                [self initVideoDetailWithData:responseObject[@"data"] andRecordInfo:responseObject[@"data"][@"playRecordInfo"]];
            } else if (self.kType == HICWebVideoType) {
                [self initWebVideoWithData:responseObject[@"data"] andRecordInfo:responseObject[@"data"][@"playRecordInfo"]];
            }
            if ([HICCommonUtils isValidObject:[responseObject[@"data"] valueForKey:@"exerciseList"]]) {
                self.exciseArr = [NSArray arrayWithArray:[responseObject[@"data"] valueForKey:@"exerciseList"]];
            }
            if ([HICCommonUtils isValidObject:[responseObject[@"data"] valueForKey:@"recommendList"]]) {
                self.recommendArr = [NSArray arrayWithArray:[responseObject[@"data"] valueForKey:@"recommendList"]];
            }
        }
    } failure:^(NSError * _Nonnull error) {
        if (error.code == 40005) {
            [self.view addSubview:self.defaultView];
            [self createNavi];
            self.videoPlayBackView.backgroundColor = UIColor.whiteColor;
        }
    }];
}

- (void)requestData {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setValue:@(7)  forKey:@"objectType"];
        [dic setValue:self->_objectId forKey:@"objectId"];
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
        [dict setValue:@"7" forKey:@"typeCode"];
        [dict setValue:self->_objectId forKey:@"objectid"];
        [dict setValue:@"9999" forKey:@"productCode"];
        [dict setValue:@(0) forKey:@"start"];
        [dict setValue:@(10) forKey:@"rows"];
        [HICAPI commentList:dict success:^(NSDictionary * _Nonnull responseObject) {
            NSNumber *totalnum = (NSNumber *)[responseObject valueForKey:@"totalnum"];
            if ([HICCommonUtils isValidObject:totalnum]) {
                [self->_btmView updateCommentsCount:[totalnum toString]];
            }
        } failure:^(NSError * _Nonnull error) {
            DDLogDebug(@"error");
        }];
    });
}

- (void)addObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(leftBtnClicked) name:@"goBackPageNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshNoteDataHandler) name:@"EIXT_NOTE_LIST_POP_WINDOW" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeSelfNoti:) name:@"HICKnowledgeDetailVCRemoveSelf" object:nil];
}

- (void)refreshNoteDataHandler {
    [self requestData];
}

- (void)createUI {
    self.backbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    _backbutton.frame = CGRectMake(16, 31- 20 + HIC_StatusBar_Height, 12, 22);
    [_backbutton hicChangeButtonClickLength:30];
    [_backbutton setImage:[UIImage imageNamed:@"头部-返回-白色"] forState:UIControlStateNormal];
    [_backbutton addTarget:self action:@selector(leftBtnClicked) forControlEvents:UIControlEventTouchUpInside];
   if (_kType == HICHtmlType ) {//html
        [self createNavi];
    } else if (_kType == HICPictureType || _kType == HICFileType) {//图片类型
        [self createNavi];
        [self createPicTableView];
        [self.view bringSubviewToFront:self.rotateBtn];
        [self createBtmBar];
    } else {//音视频 文档
        [self createVideoTableView];
        [self createBtmBar];
    }
}

- (void)initHTMLDetail {
    [HiWebViewManager addParentVC:self urlStr:_urlStr isDelegate:YES isPush:YES hideCusNavi:self.hideNavi hideCusTabBar:self.hideTabbar];
    if (!self.hideNavi) {
        [self createNavi];
    }
    if (!self.hideTabbar) {
        [self createBtmBar];
    }
}

- (void)createPicTableView {
    CGFloat top = HIC_NavBarAndStatusBarHeight;
    //    CGFloat bottom = 127.0;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, top, HIC_ScreenWidth, HIC_ScreenHeight - top - 52 - HIC_BottomHeight) style:UITableViewStylePlain];
    self.tableView.backgroundColor = UIColor.blackColor;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navi.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).inset(52 + HIC_BottomHeight);
    }];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:HICStudyDocPhotoListItemCell.class forCellReuseIdentifier:@"DocPhotoCell"];
    
    // 2.创建底部翻页工具条
    CGFloat docBottom = 52;
    CGFloat docHeight = 75;
    self.docPhotoBackView = [[UIView alloc] initWithFrame:CGRectMake(0, HIC_ScreenHeight - docBottom - docHeight - HIC_BottomHeight, HIC_ScreenWidth, docHeight)];
    self.docPhotoBackView.backgroundColor = [UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1];
    [self.view addSubview:self.docPhotoBackView];
    self.numPageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 12, HIC_ScreenWidth, 15)];
    self.numPageLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:11.f];
    self.numPageLabel.textColor = [UIColor colorWithHexString:@"#858585"];
    self.numPageLabel.textAlignment = NSTextAlignmentCenter;
    [self.docPhotoBackView addSubview:self.numPageLabel];
    [self changeCurrentPage:1];
    
    UIImage *pageUpImage = [UIImage imageNamed:@"返回"];
    UIButton *pageUpBut = [[UIButton alloc] initWithFrame:CGRectMake(4, 26, 44, 44)];
    [pageUpBut setImage:pageUpImage forState: UIControlStateNormal];
    [self.docPhotoBackView addSubview:pageUpBut];
    [pageUpBut addTarget:self action:@selector(clickPageUpBut:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *nextImage = [UIImage imageWithCGImage:pageUpImage.CGImage scale:pageUpImage.scale orientation:UIImageOrientationUpMirrored];
    UIButton *pageNexBut = [[UIButton alloc] initWithFrame:CGRectMake(HIC_ScreenWidth - 4 - 44, 26, 44, 44)];
    [pageNexBut setImage:nextImage forState: UIControlStateNormal];
    [self.docPhotoBackView addSubview:pageNexBut];
    [pageNexBut addTarget:self action:@selector(clickPageNextBut:) forControlEvents:UIControlEventTouchUpInside];
    
    self.pageSlider = [[UISlider alloc] initWithFrame:CGRectMake(4+44+4, 38, HIC_ScreenWidth - (4+44+4)*2, 20)];
    [self.docPhotoBackView addSubview:self.pageSlider];
    UIColor *startColor = [UIColor colorWithHexString:@"#00E2D8"];
    UIColor *endColor = [UIColor colorWithHexString:@"#00C5E0"];
    UIImage *sliderMinImage = [self getGradientImageWithColors:@[startColor, endColor] imgSize:self.pageSlider.bounds.size];
    [self.pageSlider setMinimumTrackImage:sliderMinImage forState:UIControlStateNormal];
    [self.pageSlider addTarget:self action:@selector(changeSliderValue:forEvent:) forControlEvents:UIControlEventValueChanged];

    // 4. 顶部系统时间
    self.topTimeBackView = [[UIView alloc] initWithFrame:CGRectMake(0, top, HIC_ScreenWidth, 40)];
    self.topTimeBackView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    [self.view addSubview:self.topTimeBackView];
    self.topTimeBackView.hidden = YES;
    self.topTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 9.5, HIC_ScreenWidth, 21)];
    self.topTimeLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15.f];
    self.topTimeLabel.textColor = UIColor.whiteColor;
    self.topTimeLabel.textAlignment = NSTextAlignmentCenter;
    [self changeTopTimeStr:[NSString stringWithFormat:@"0%@",NSLocalizableString(@"seconds", nil)]];
    [self.topTimeBackView addSubview:self.topTimeLabel];
}

-(UIImage *)getGradientImageWithColors:(NSArray*)colors imgSize:(CGSize)imgSize {
    NSMutableArray *arRef = [NSMutableArray array];
    for(UIColor *ref in colors) {
        [arRef addObject:(id)ref.CGColor];
        
    }
    UIGraphicsBeginImageContextWithOptions(imgSize, YES, 1);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGColorSpaceRef colorSpace = CGColorGetColorSpace([[colors lastObject] CGColor]);
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)arRef, NULL);
    CGPoint start = CGPointMake(0.0, 0.0);
    CGPoint end = CGPointMake(imgSize.width, imgSize.height);
    CGContextDrawLinearGradient(context, gradient, start, end, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGGradientRelease(gradient);
    CGContextRestoreGState(context);
    CGColorSpaceRelease(colorSpace);
    UIGraphicsEndImageContext();
    return image;
}

- (void)initPicDetailWithData:(NSDictionary *)dic {
    [self formatTopTime];
    self.tableViewDataSource = (NSMutableArray *)self.baseInfoModel.mediaInfoList;
    if ([HICCommonUtils isValidObject: dic]) {
        self.recordModel = [HICCoursePlayRecordModel mj_objectWithKeyValues: dic];
        self.recordModel.currentPageNum = self.recordModel.currentPageNum == -1 ? 0 : self.recordModel.currentPageNum;
    }
    if (self.tableViewDataSource.count == 1) {
        self.pageSlider.maximumValue = (CGFloat)self.tableViewDataSource.count;// 最大值在获取数据后设置
        self.pageSlider.value = 1;
    }else if (self.tableViewDataSource.count > 1) {
        self.pageSlider.maximumValue = (CGFloat)self.tableViewDataSource.count-1;
    }
    self.isStart = YES;
    __weak typeof(self) weakSelf = self;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:weakSelf selector:@selector(removeTimeLabel) userInfo:nil repeats:NO];
    [self reportRecordWithReportType:1];
    [self.tableView reloadData];
    
    if ([HICCommonUtils isValidObject:self.recordModel]) {
        [self changeCurrentPage:self.recordModel.currentPageNum];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if(self.tableViewDataSource.count > 0 && (self.tableViewDataSource.count >= self.recordModel.currentPageNum) && self.recordModel.currentPageNum >= 1){
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.recordModel.currentPageNum - 1 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:YES];
            }
        });
        if (self.recordModel.currentPageNum <= 0) {
            self.currentPage = 1;
        }
        self.numPageLabel.text = [NSString stringWithFormat:@"%ld/%lu",(long)self.recordModel.currentPageNum, (unsigned long)self.tableViewDataSource.count];
    }else{
        self.numPageLabel.text = [NSString stringWithFormat:@"1/%lu", (unsigned long)self.tableViewDataSource.count];
    }
}

- (void)initVideoDetailWithData:(NSDictionary *)dic andRecordInfo:(NSDictionary *)playRecordInfo{
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"0"]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"isOn" forKey:@"0"];
    }
    self.mediaArr = [NSMutableArray arrayWithArray:self.baseInfoModel.mediaInfoList];
    
    NSMutableArray *arr = [NSMutableArray array];
    if (self.mediaArr.count > 0) {
        if (_kType == HICVideoType || _kType == HICAudioType) {
            [self.backbutton removeFromSuperview];
            NSMutableDictionary *resolutionURLs = [NSMutableDictionary dictionary];
            NSMutableDictionary *dic = [NSMutableDictionary new];
            HICVideoModel *model0 = [HICVideoModel mj_objectWithKeyValues:self.mediaArr[0]];
            [dic setValue:model0.url forKey:@"assetStr"];
            [dic setValue:self.baseInfoModel.name forKey:@"title"];
            for (int i = 0; i < self.mediaArr.count; i ++) {
                HICVideoModel *model = [HICVideoModel mj_objectWithKeyValues:self.mediaArr[i]];
                //                NSDictionary *resolutionURLs = @{@"1080":model.url};
                [resolutionURLs setValue:model.url forKey:[NSString stringWithFormat:@"%ld",(long)model.definition]];
                
                [arr addObject:model.url];
                
            }
            if (arr.count == self.mediaArr.count) {
                [dic setObject:resolutionURLs forKey:@"resolutionURLs"];
                NSArray *meArr = @[dic];
                self.videoPlayer = [self->playerHelper generateVedioPlayerWithContaninerView:self.videoPlayBackView videoArray:meArr controller:self type:0];
                // 音频的情况下需要开启后台播放
                if (self.kType == HICAudioType) {
                    [self->playerHelper audioBackPlay];
                }
                self.videoPlayer.ocDelegate = self;
                if ([HICCommonUtils isValidObject:playRecordInfo]) {
                    HICCoursePlayRecordModel *recordModel = [HICCoursePlayRecordModel mj_objectWithKeyValues:playRecordInfo];
                    self.currentDuration = recordModel.currentDuration;
                    DDLogDebug(@"recordModel=%@, %ld", recordModel.currentDuration, (long)recordModel.totalDuration);
                    // 如果记录中没有播放完成，则从记录点起播。毫秒容易存在误差，所以转成s去比较
                    if ([recordModel.currentDuration integerValue]/1000 < recordModel.totalDuration/1000) {
                        self.startDuration = @([recordModel.currentDuration integerValue] / 1000); //转成s
                    }
                }
                if (self.controlModel.watermarkFlag) {
                    [playerHelper setUserInfo:self.controlModel.watermarkText];
                }
                if ([NSString isValidStr:self.baseInfoModel.coverPic]){
                    [playerHelper setAudioBackImageWithImage:nil imageData:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.baseInfoModel.coverPic]]]];
                }
                self.isStart = YES;
                if (self.shouldFullScreen) {
                    [self.videoPlayer enterFullScreenWithFullScreen:YES animate:NO];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"HICKnowledgeDetailVCRemoveSelf" object:nil userInfo:@{@"target": self.objectId}];
                }
            }
        }
    }
    [self.tableView reloadData];
}

- (void)initWebVideoWithData:(NSDictionary *)dic andRecordInfo:(NSDictionary *)playRecordInfo{
    self.mediaArr = [NSMutableArray arrayWithArray:self.baseInfoModel.mediaInfoList];
    if ([self.mediaArr.firstObject isKindOfClass:NSDictionary.class]) {
        NSDictionary *media = (NSDictionary *)self.mediaArr.firstObject;
        NSString *url = media[@"url"];
        [self.videoPlayBackView bringSubviewToFront:self.webView];
        NSString *finalUrl = [[NSString stringWithFormat:@"%@&clienttype=ios", url] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:finalUrl]]];
        DDLogDebug(@"webView url=%@", finalUrl);
    }
    [self.tableView reloadData];
}

- (void)createVideoTableView {
    CGFloat videoPlayHeight = lessonTopHeight;
    CGFloat bottom = HIC_isIPhoneX? HIC_BottomHeight+52:52.f;
    self.videoPlayBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, HIC_ScreenWidth, videoPlayHeight)];
    self.videoPlayBackView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.6];
    [self.view addSubview:self.videoPlayBackView];
    [self.view addSubview:_backbutton];
    if (_kType == HICWebVideoType) {
        videoPlayHeight = HIC_ScreenWidth / 1.78 + HIC_StatusBar_Height;
        self.videoPlayBackView.frame = CGRectMake(0, 0, HIC_ScreenWidth, videoPlayHeight);
        [self.videoPlayBackView addSubview:self.webView];
    } else if (_kType == HICVideoType || _kType == HICAudioType) {
        
    } else {
        self.fileView = [[UIImageView alloc]initWithFrame:CGRectMake(HIC_ScreenWidth/2 - 20, (_videoPlayBackView.frame.size.height - 50)/2 - 1, 50, 50)];
        [self.videoPlayBackView addSubview:self.fileView];
        
        self.fileLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.fileView.frame.origin.y + self.fileView.frame.size.height + 12, HIC_ScreenWidth, 21)];
        self.fileLabel.textColor = UIColor.whiteColor;
        self.fileLabel.font = FONT_REGULAR_15;
        self.fileLabel.textAlignment = NSTextAlignmentCenter;
        [self.videoPlayBackView addSubview:self.fileLabel];
        if (_kType == HICZipType) {
            self.fileView.image = [UIImage imageNamed:@"知识类型-压缩包"];
            self.fileLabel.text = NSLocalizableString(@"downloadOnPCPage", nil);
        }else if(_kType == HICScromType){
            self.fileView.image = [UIImage imageNamed:@"知识类型-文档-scorm"];
            self.fileLabel.text = NSLocalizableString(@"openOnPCPage", nil);
        }
    }
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, videoPlayHeight, HIC_ScreenWidth, HIC_ScreenHeight - videoPlayHeight - bottom) style:UITableViewStylePlain];
    self.tableView.backgroundColor = BACKGROUNG_COLOR;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerClass:HICLessonIntroductCell.class forCellReuseIdentifier:@"IntroductCell"];
    [self.tableView registerClass:HICLessonContentCell.class forCellReuseIdentifier:@"ContentCell"];
    [self.tableView registerClass:HICStudyVideoPlayExercisesCell.class forCellReuseIdentifier:@"ExercisesCell"];
    [self.tableView registerClass:HICStudyVideoPlayRelatedCell.class forCellReuseIdentifier:@"RelateCell"];
    [self.tableView registerClass:HICStudyVideoPlayCommentCell.class forCellReuseIdentifier:@"CommentCell"];
    [self.view addSubview:self.tableView];
    if (@available(iOS 15.0, *)) {
        self.tableView.sectionHeaderTopPadding = 0;
    }
}

- (void)createNavi {
    self.navi = [[HICCustomNaviView alloc] initWithTitle:@"" rightBtnName:nil showBtnLine:NO];
    _navi.delegate = self;
    [self.view addSubview:_navi];
    [self.navi mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(HIC_NavBarHeight + HIC_StatusBar_Height);
    }];
    [self.navi.goBackBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.navi).offset(5);
        make.bottom.equalTo(self.navi).inset(10);
        make.width.equalTo(@40);
        make.height.equalTo(@25);
    }];
    
    [self.navi.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.navi.goBackBtn.mas_right);
        make.right.equalTo(self.navi).inset(45);
        make.centerY.equalTo(self.navi.goBackBtn);
    }];
}

- (void)createBtmBar {
    NSArray *btmBtArr = _kType == HICPictureType || _kType == HICFileType ? @[@{NSLocalizableString(@"writeComment", nil):@"BT-写评论"}, @{NSLocalizableString(@"collection", nil):@"BT-收藏"}, @{NSLocalizableString(@"giveLike", nil):@"BT-点赞"},@{NSLocalizableString(@"turnPage", nil):@"BT-翻页"},@{NSLocalizableString(@"more", nil):@"更多操作"}] : @[@{NSLocalizableString(@"writeComment", nil):@"BT-写评论"}, @{NSLocalizableString(@"collection", nil):@"BT-收藏"}, @{NSLocalizableString(@"giveLike", nil):@"BT-点赞"}, @{NSLocalizableString(@"more", nil):@"更多操作"}];
    self.btmView = [[HICStudyBtmView alloc] initWithFrame:CGRectMake(0, HIC_ScreenHeight - 52 - HIC_BottomHeight, HIC_ScreenWidth, 52 + HIC_BottomHeight) numberOfComments:@"0"];
    [self.btmView customLeftBtns:@[] rightBtns:btmBtArr];
    self.btmView.delegate = self;
    self.btmView.btmType = HICStudyBtmViewKnowledge;
    self.btmView.kldId = _objectId;
    [self.view addSubview:self.btmView];
    [self.btmView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(52 + HIC_BottomHeight);
    }];
}

- (void)createMaskView {
    self.inductView = [[HICLessonIntroductView alloc]initWithVC:self];
    [self.inductView setFrame:CGRectMake(0, 0, HIC_ScreenWidth, HIC_ScreenHeight - 72 - 50)];
    self.inductView.isInside = YES;
    self.maskView =[[UIView alloc]initWithFrame: CGRectMake(0, 0, HIC_ScreenWidth, HIC_ScreenHeight)];
    self.maskView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.5];
    [self.view addSubview:self.maskView];
    _container = [[UIView alloc] init];
    _container.frame = CGRectMake(0, HIC_ScreenHeight, HIC_ScreenWidth, HIC_ScreenHeight - 72);
    [self.maskView addSubview: _container];
    self.maskTitleLabel = [[UILabel alloc] init];
    [_container addSubview:self.maskTitleLabel];
    self.maskTitleLabel.frame = CGRectMake(16, 15, 68, 24);
    self.maskTitleLabel.font = FONT_MEDIUM_17;
    self.maskTitleLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    UIButton *cancelBtn = [[UIButton alloc] init];
    [_container addSubview: cancelBtn];
    cancelBtn.tag = 10000;
    [cancelBtn addTarget:self action:@selector(closeMask) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setImage:[UIImage imageNamed:@"关闭弹窗"] forState:UIControlStateNormal];
    cancelBtn.frame = CGRectMake(_container.frame.size.width - 20 - 16, 15, 20, 20);
    [UIView animateWithDuration:0.3 animations:^{
        self->_container.frame = CGRectMake(0, 72 + HIC_StatusBar_Height, HIC_ScreenWidth, HIC_ScreenHeight - 72-HIC_StatusBar_Height);
    }];
    UIView *dividedLine = [[UIView alloc] initWithFrame:CGRectMake(0, 50-0.5, _container.frame.size.width, 0.5)];
    [_container addSubview: dividedLine];
    dividedLine.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1/1.0];
    _insideView = [[UIView alloc]initWithFrame:CGRectMake(0, 50, HIC_ScreenWidth, HIC_ScreenHeight - 50 - HIC_NavBarAndStatusBarHeight)];
    //    _insideView.backgroundColor = [UIColor blueColor];
    [_container addSubview:_insideView];
    [HICCommonUtils setRoundingCornersWithView:_container TopLeft:YES TopRight:YES bottomLeft:NO bottomRight:NO cornerRadius:15];
    _container.backgroundColor = [UIColor whiteColor];
}

//加载遮罩层数据
- (void)loadMaskData:(NSInteger)type{
    [self createMaskView];
    HICKonwledgeMaskTableView *maskTable = [[HICKonwledgeMaskTableView alloc]init];
    if (type == 1) {
        [maskTable setDataArr:self.recommendArr andType:@1];
        [_insideView addSubview:maskTable];
        self.maskTitleLabel.text = NSLocalizableString(@"relatedRecommend", nil);
    }else if(type == 2){
        [maskTable setDataArr:self.exciseArr andType:@0];
        [_insideView addSubview:maskTable];
        self.maskTitleLabel.text = @"练习题";
    }else{
        [_insideView addSubview:self.inductView];
        self.inductView.baseModel = self.baseInfoModel;
        self.inductView.arrExercise = @[];
        self.inductView.arrRelated = @[];
        self.maskTitleLabel.text = NSLocalizableString(@"contentAbstract", nil);
    }
}

- (void)closeMask{
    [self.maskView removeFromSuperview];
}
//转换文档也顶部时间
- (void)formatTopTime {
    if ([self learningRate] >= 1) {
        self.topTimeLabel.text = NSLocalizableString(@"congratulationsCompletingStudy", nil);
        if (!self.hadToastStudyFinished) {
            self.hadToastStudyFinished = YES;
            self.topTimeBackView.hidden = NO;
            [self performSelector:@selector(removeTimeLabel) withObject:nil afterDelay:3];
        }
        return;
    }
    NSInteger time = self.baseInfoModel.creditHours - self.baseInfoModel.creditHoursUsed;
    if (time < 0) {
        time = 0;
    }
    if (time < 60) {
        [self changeTopTimeStr:[NSString stringWithFormat:@"%ld%@",(long)time,NSLocalizableString(@"minutes", nil)]];
    } else {
        NSInteger hour = time/60;
        NSInteger min = time%60;
        NSString *timeStr = [NSString stringWithFormat:@"%ld%@%ld%@",(long)hour,NSLocalizableString(@"hours", nil),(long)min,NSLocalizableString(@"minutes", nil)];
        [self changeTopTimeStr:timeStr];
    }
}

// 修改富文本
-(void)changeTopTimeStr:(NSString *)str {
    NSString*content = [NSString stringWithFormat:@"%@%@%@", NSLocalizableString(@"youHave", nil),str,NSLocalizableString(@"canCompleteStudy", nil)];
    NSArray*number =@[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"];
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:content];
    for(int i =0; i < content.length; i ++) {
        //这里的小技巧，每次只截取一个字符的范围
        NSString *a = [content substringWithRange:NSMakeRange(i,1)];
        //判断装有0-9的字符串的数字数组是否包含截取字符串出来的单个字符，从而筛选出符合要求的数字字符的范围NSMakeRange
        if([number containsObject:a]) {
            [attributeString setAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#00BED7"]}range:NSMakeRange(i,1)];
        }
    }
    self.topTimeLabel.attributedText = [attributeString copy];
}

// 修改页码
-(void)changeCurrentPage:(NSInteger)currentIndex {
    NSInteger index = currentIndex;
    if (currentIndex > self.tableViewDataSource.count) {
        index = self.tableViewDataSource.count;
    }
    
    if (self.tableViewDataSource.count == 1) {
        //        self.pageSlider.maximumValue = (CGFloat)self.tableViewDataSource.count; // 最大值在获取数据后设置
        self.pageSlider.value = 1;
    }else if (self.tableViewDataSource.count > 1) {
        //        self.pageSlider.maximumValue = (CGFloat)self.tableViewDataSource.count-1;
        CGFloat sliderValue = (CGFloat)index-1;
        self.pageSlider.value = sliderValue;
    }
    self.currentPage = index;
    self.numPageLabel.text = [NSString stringWithFormat:@"%ld/%lu",(long)index, (unsigned long)self.tableViewDataSource.count];
}

// 只修改页码
- (void)changeOnlyCurrentPage:(NSInteger)currentIndex {
    NSInteger index = currentIndex;
    if (currentIndex > self.tableViewDataSource.count) {
        index = self.tableViewDataSource.count;
    }
    self.currentPage = index;
    self.numPageLabel.text = [NSString stringWithFormat:@"%ld/%lu",(long)index, (unsigned long)self.tableViewDataSource.count];
}

- (void)clickPageUpBut:(UIButton *)btn {
    [self.timer setFireDate:[NSDate distantFuture]];
    CGFloat tableH = self.tableView.frame.size.height;
    CGFloat cellH = tableH/2.0 - 20;
    
    CGPoint currentPoint = self.tableView.contentOffset;
    CGPoint changePoint = CGPointMake(0, 0);
    if (currentPoint.y <= 0) {
        // 此时已经是第一页了不用滚动
        return;
    }else if (currentPoint.y - cellH <= 0) {
        // 此时已经是接近第一页了
    }else if (self.tableViewDataSource.count - 2 > 0 && currentPoint.y >= (self.tableViewDataSource.count - 2) * cellH - 40) {
        changePoint = CGPointMake(0, currentPoint.y-40);
    }else {
        changePoint = CGPointMake(0, currentPoint.y-cellH);
    }
    [self.tableView setContentOffset:changePoint];
    [self.timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:3]];
}

- (void)clickPageNextBut:(UIButton *)btn {
    [self.timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:100000000000]];
    CGFloat tableH = self.tableView.frame.size.height;
    CGFloat cellH = tableH/2.0 - 20;
    
    CGPoint currentPoint = self.tableView.contentOffset;
    CGFloat fullPageY = (self.tableViewDataSource.count - 2) * cellH - 40;
    CGPoint changePoint = CGPointMake(0, fullPageY);
    
    if (currentPoint.y+40 > fullPageY) {
        // 此时已经接近 文章结尾 直接跳到结尾
    }else if (currentPoint.y < 40) {
        // 此时还在首页位置
        changePoint = CGPointMake(0, 41);
    }else {
        if (currentPoint.y + cellH < fullPageY) {
            changePoint = CGPointMake(0, currentPoint.y + cellH);
        }
    }
    if (self.tableViewDataSource.count <= 2) {
        changePoint = CGPointMake(0, 0);
    }
    
    [self.tableView setContentOffset:changePoint];
    [self.timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:3]];
}

-(void)changeSliderValue:(UISlider *)slider forEvent:(UIEvent *)event{
    UITouch*touchEvent = [[event allTouches]anyObject];
    switch(touchEvent.phase) {
        case UITouchPhaseBegan:
            DDLogDebug(@"开始拖动");
            [self.timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:100000000000]];
            break;
        case UITouchPhaseMoved:
            DDLogDebug(@"正在拖动");
            if (self.tableViewDataSource.count <= 1) {
                // 忽略
                [self changeOnlyCurrentPage:1];
            }else {
                self.currentPage = (NSInteger)slider.value + 1;
                [self changeOnlyCurrentPage:(NSInteger)slider.value + 1];
            }
            break;
        case UITouchPhaseEnded:
            DDLogDebug(@"结束拖动");
            [self.timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:3]];
            if (self.tableViewDataSource.count <= 1) {
                // 忽略
                self.currentPage = 1;
                [self changeCurrentPage:1];
            }else {
                self.currentPage = (NSInteger)slider.value;
                [self scrollPageToNumber:(NSInteger)slider.value];
            }
            break;
        default:
            break;
    }
}

- (void)rotateScreenAction:(UIButton *)sender {
    self.isLandscape = !self.isLandscape;
    [self setInterfaceOrientation:self.isLandscape ? UIInterfaceOrientationLandscapeRight : UIInterfaceOrientationPortrait];
    
    [self.rotateBtn setImage:[UIImage imageNamed:self.isLandscape ? @"hic_file_portrait" : @"hic_file_landscape"] forState:UIControlStateNormal];
    [self.rotateBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        self.isLandscape ? make.bottom.equalTo(self.view).inset(16) : make.centerY.equalTo(self.view);;
        make.right.equalTo(self.view).inset(16);
        make.width.height.equalTo(@56);
    }];
  
    [self.detailView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.view.height - (self.isLandscape ? 0 : HIC_NavBarAndStatusBarHeight));
        make.left.right.bottom.equalTo(self.view);
    }];
        
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 20 * NSEC_PER_MSEC), dispatch_get_main_queue(), ^{
        [self.detailView relayoutWithOrentation:self.isLandscape];
        if (self.detailView.hidden && self.isLandscape) {
            self.needsHideDetailView = YES;
            [self showDetailViewWithIndex:self.currentPage > 0 ? self.currentPage - 1 : 0];
        } else if (!self.detailView.hidden && !self.isLandscape && self.needsHideDetailView) {
            self.needsHideDetailView = NO;
            self.detailView.hidden = YES;
            [self hideDetailViewWithIndex:self.detailView.currentIndex];
        }
    });
}

- (void)scrollPageToNumber:(NSInteger)index {
    if ([self.tableView numberOfRowsInSection:0] <= index) { return;};
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
}

- (void)showDetailViewWithIndex:(NSInteger)index {
    self.detailView.dataSource = [self.tableViewDataSource copy];
    self.detailView.model = self.controlModel;
    self.detailView.hidden = NO;
    self.detailView.currentIndex = index;
    self.detailView.alpha = 0;
    [UIView animateWithDuration:0.2 animations:^{
        self.detailView.alpha = 1;
    } completion:^(BOOL finished) {
        [self.detailView scrollViewTo:index];
    }];
    self.btmView.hidden = YES;
}

- (void)hideDetailViewWithIndex:(NSInteger)index {
    [self scrollPageToNumber:index];
    self.btmView.hidden = NO;
}

- (void)showVideoToastWithMessage:(NSString *)message width:(CGFloat)labelWidth isCenter:(BOOL)isCenter duration:(NSTimeInterval)duration {
    UILabel *toastLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, labelWidth, 30)];
    toastLabel.text = message;
    toastLabel.layer.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6].CGColor;
    toastLabel.textAlignment = NSTextAlignmentCenter;
    toastLabel.textColor = [UIColor whiteColor];
    toastLabel.font = [UIFont systemFontOfSize:15];
    toastLabel.layer.cornerRadius = 15.0;
    toastLabel.adjustsFontSizeToFitWidth = YES;
    self.isFullScreen ? [self.videoPlayer.controlView addSubview:toastLabel]
    : [self.view addSubview:toastLabel];
    
    [toastLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.height.equalTo(@30);
        make.width.mas_equalTo(labelWidth);
        if (isCenter) {
            make.centerY.equalTo(self.isFullScreen ? self.videoPlayer.controlView : self.view);
        } else {
            make.bottom.equalTo(self.videoPlayer.controlView).offset(self.isFullScreen ? -66 : -30);
        }
    }];
    toastLabel.alpha = 0;
    [UIView animateWithDuration:0.2 animations:^{
        toastLabel.alpha = 1;
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration*NSEC_PER_SEC) , dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.2 animations:^{
            toastLabel.alpha = 0;
        } completion:^(BOOL finished) {
            [toastLabel removeFromSuperview];
        }];
    });
}

- (void)removeTimeLabel {
    self.docPhotoBackView.hidden = YES;
    self.topTimeBackView.hidden = YES;
    [self.timer invalidate];
}

- (CGFloat)getContentHeight:(NSString *)str {
    UILabel *label = [[UILabel alloc] init];
    label.text = str;
    label.font = FONT_MEDIUM_18;
    label.numberOfLines = 2;
    CGFloat labelHeight = [HICCommonUtils sizeOfString:str stringWidthBounding:HIC_ScreenWidth - 32 font:18 stringOnBtn:NO fontIsRegular:NO].height;
    label.frame = CGRectMake(0, 0, HIC_ScreenWidth - 32, labelHeight);
    [label sizeToFit];
    return label.frame.size.height;
}
- (CGFloat)getContentHeightS:(NSString *)str {
    UILabel *label = [[UILabel alloc] init];
    label.text = str;
    label.font = FONT_REGULAR_14;
    label.numberOfLines = 0;
    CGFloat labelHeight = [HICCommonUtils sizeOfString:str stringWidthBounding:HIC_ScreenWidth - 32 font:14 stringOnBtn:NO fontIsRegular:YES].height;
    label.frame = CGRectMake(0, 0, HIC_ScreenWidth - 32, labelHeight);
    [label sizeToFit];
    return label.frame.size.height;
}
//- (void)reportRecord{}
/*customerId（用户）、courseKLDId（课程ID）、sourceType（资源类型）、sectionId（章节Id）、kldId(知识ID)、fileType（知识文件类型）、startTime（开始时间）、endTime（结束时间）、currentPage（当前播放页数）、duration（已播放时长/文档停留时长）、totalPage（总页数）、totalDuration（总时长）*/
//reportType： 1（）
- (void)reportRecordWithReportType:(NSInteger)reportType {
    NSTimeInterval deltaTime = [[NSDate date] timeIntervalSince1970] - self.startDate;
    dispatch_async(dispatch_get_global_queue(-2, 0), ^{
        NSMutableDictionary *recordDic = [NSMutableDictionary new];
        HICStudyLogReportModel *reportModelT = [[HICStudyLogReportModel alloc]initWithType:HICStudyLogTypeTiming];
        HICStudyLogReportModel *reportModelS = [[HICStudyLogReportModel alloc]initWithType:HICStudyLogTypeStart];
        HICStudyLogReportModel *reportModelE = [[HICStudyLogReportModel alloc]initWithType:HICStudyLogTypeEnd];
        [recordDic setValue:USER_CID forKey:@"customerId"];
        [recordDic setValue:USER_TOKEN forKey:@"accessToken"];
        
        if ([NSString isValidStr:[NSString stringWithFormat:@"%@",self->_trainId]] && (self->_trainId != 0)) {
            [recordDic setValue:self->_trainId forKey:@"trainInfoId"];
            reportModelT.traincourseid = self->_trainId;
            reportModelS.traincourseid = self->_trainId;
            reportModelE.traincourseid = self->_trainId;
        }else{
            [recordDic setValue:@-1 forKey:@"trainInfoId"];
            reportModelT.traincourseid = @-1;
            reportModelS.traincourseid = @-1;
            reportModelE.traincourseid = @-1;
        }
        if ([NSString isValidStr:[NSString stringWithFormat:@"%@",self->_courseId]]) {
            [recordDic setValue:self->_courseId forKey:@"courseKLDId"];
            reportModelT.courseid = self->_courseId;
            reportModelS.courseid = self->_courseId;
            reportModelE.courseid = self->_courseId;
        }else{
            [recordDic setValue:@-1 forKey:@"courseKLDId"];
            reportModelT.courseid = @-1;
            reportModelS.courseid = @-1;
            reportModelE.courseid = @-1;
        }
        [recordDic setValue:self->_objectId forKey:@"kldId"];
        reportModelT.mediaid = self->_objectId;
        reportModelS.mediaid = self->_objectId;
        reportModelE.mediaid = self->_objectId;
        NSNumber *type = @3;
        if (self->_kType == HICAudioType) {
            type = [NSNumber numberWithInteger:2];
        }else if (self->_kType == HICVideoType) {
            type = [NSNumber numberWithInteger:1];
        }
        reportModelT.knowtype = [NSNumber numberWithInteger:self->_kType];
        reportModelS.knowtype = [NSNumber numberWithInteger:self->_kType];
        reportModelE.knowtype = [NSNumber numberWithInteger:self->_kType];
        
        [recordDic setValue:type forKey:@"fileType"];
        if ([NSString isValidStr:[NSString stringWithFormat:@"%@",self->_sectionId]]) {
            [recordDic setValue:self->_sectionId forKey:@"sectionId"];
            reportModelT.sectionId = self->_sectionId;
            [recordDic setValue:@6 forKey:@"sourceType"];
        }else{
            [recordDic setValue:@-1 forKey:@"sectionId"];
            reportModelT.sectionId = @-1;
            [recordDic setValue:@7 forKey:@"sourceType"];
        }
        //        [recordDic setValue:@7 forKey:@"sourceType"];
        [recordDic setValue:self.startStamp forKey:@"startTime"];
        reportModelT.startTime = self.startStamp;
        if ([NSString isValidStr:[NSString stringWithFormat:@"%@",self.endStamp]]) {
            [recordDic setValue:self.endStamp forKey:@"endTime"];
            reportModelT.endTime = self.endStamp;
        }else{
            [recordDic setValue:@-1 forKey:@"endTime"];
            reportModelT.endTime = @-1;
        }
        [recordDic setValue:@-1 forKey:@"costTime"];
        reportModelE.learnTime = @0;
        reportModelS.learnTime = @0;
        [recordDic setValue:self.completeFlag ?: @-1 forKey:@"completeFlag"];
        [recordDic setValue:self.baseInfoModel.credit forKey:@"credit"];
        [recordDic setValue:[NSNumber numberWithInteger:self.baseInfoModel.creditHours] forKey:@"kldCreditHours"];
        reportModelT.credits = [self.baseInfoModel.credit toNumber];
        [recordDic setValue:[NSNumber numberWithFloat:self.baseInfoModel.points] forKey:@"points"];
        if (self->_kType == HICFileType || self->_kType == HICPictureType || self->_kType == HICScromType) {
            if ([NSString isValidStr:[NSString stringWithFormat:@"%ld",(long)self.currentPage]] && self.tableViewDataSource.count != 0 && self.currentPage != 0) {
                if (self.currentPage >= 1 && self.tableViewDataSource.count > self.currentPage - 1) {
                    HICMediaInfoModel *model = [HICMediaInfoModel mj_objectWithKeyValues:self.tableViewDataSource[self.currentPage-1]];
                    [recordDic setValue:model.fileId forKey:@"fileId"];
                    //                    [recordDic setValue:[NSNumber numberWithInteger:model.fileType] forKey:@"fileCategory"];
                    [recordDic setValue:[NSNumber numberWithInteger:1] forKey:@"fileCategory"];
                    [recordDic setValue:[NSNumber numberWithInteger:self.currentPage] forKey:@"currentPage"];
                    [recordDic setValue:model.totalNumber forKey:@"totalPage"];
                    [recordDic setValue:@-1 forKey:@"totalDuration"];
                    [recordDic setValue:@-1 forKey:@"currentDuration"];
                    reportModelT.kldCreditHours = [NSNumber numberWithInteger:self.baseInfoModel.creditHours];
                    reportModelT.totalDuration = @-1;
                }
            }
        } else {
            if (self.baseInfoModel.mediaInfoList.count > 0) {
                HICMediaInfoModel *model = [HICMediaInfoModel mj_objectWithKeyValues:self.baseInfoModel.mediaInfoList[self.videoIndex]];
                [recordDic setValue:model.fileId forKey:@"fileId"];
                [recordDic setValue:[NSNumber numberWithInteger:model.fileType] forKey:@"fileCategory"];
                [recordDic setValue:self.currentDuration forKey:@"currentDuration"];
                [recordDic setValue:model.totalNumber forKey:@"totalDuration"];
                reportModelT.totalDuration = model.totalNumber;
                [recordDic setValue:@-1 forKey:@"totalPage"];
                [recordDic setValue:@-1 forKey:@"currentPage"];
                reportModelT.kldCreditHours = @-1;
                reportModelE.videoquality = [NSNumber numberWithInteger:model.definition];
                reportModelS.videoquality = [NSNumber numberWithInteger:model.definition];
                reportModelE.duration = self.currentDuration;
                
                if (self.isStart) {
                    NSMutableDictionary *reportS = [NSMutableDictionary dictionaryWithDictionary:[reportModelS getParamDict]];
                    [reportS setValuesForKeysWithDictionary:[LogManager getSerLogEventDictWithType:HICStudyLogTypeStart]];
                    [LogManager reportSerLogWithDict:reportS];
                }
                if (self.isEnd) {
                    NSMutableDictionary *reportE = [NSMutableDictionary dictionaryWithDictionary:[reportModelE getParamDict]];
                    [reportE setValuesForKeysWithDictionary:[LogManager getSerLogEventDictWithType:HICStudyLogTypeEnd]];
                    [LogManager reportSerLogWithDict:reportE];
                }
            }
        }
        if (reportType == 1) {
            [recordDic setValue:@0 forKey:@"learnTime"];
            reportModelT.learnTime = @0;
            if (self.isStart || self.startAgain) {
                self.isStart = NO;
                self.startAgain = NO;
            }
        }else if(reportType == 2) {
            [recordDic setValue:[NSNumber numberWithInteger:(deltaTime + 1) *self.speed] forKey:@"learnTime"];
            reportModelT.learnTime = [NSNumber numberWithInteger:(deltaTime + 1) *self.speed];
        }else{
            [recordDic setValue:[NSNumber numberWithFloat:30 *self.speed] forKey:@"learnTime"];
            reportModelT.learnTime = [NSNumber numberWithFloat:30 *self.speed];
        }
        
        NSMutableDictionary *reportT = [NSMutableDictionary dictionaryWithDictionary:[reportModelT getParamDict]];
        [reportT setValuesForKeysWithDictionary:[LogManager getSerLogEventDictWithType:HICStudyLogTypeTiming]];
        [LogManager reportSerLogWithDict:reportT];
        [HICAPI reportLearningRecords:recordDic success:^(NSDictionary * _Nonnull responseObject) {
            if (responseObject) {
                DDLogDebug(@"上报学习进度完成");
                self.startDate = [[NSDate date] timeIntervalSince1970];
                NSDictionary *resultDict = responseObject[@"data"];
                if ([resultDict isKindOfClass:[NSDictionary class]]) {
                    if ([resultDict.allKeys containsObject:@"credit"]) {
                        self.baseInfoModel.credit = resultDict[@"credit"];
                    }
                    if ([resultDict.allKeys containsObject:@"creditHoursUsed"]) {
                        self.baseInfoModel.creditHoursUsed = [resultDict[@"creditHoursUsed"] integerValue];
                    }
                    if (_kType == HICPictureType || _kType == HICFileType) {
                        [self formatTopTime];
                    } else {
                        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                    }
                }
            }
        } failure:^(NSError * _Nonnull error) {
            DDLogDebug(@"上报学习进度失败：%@", error.localizedDescription);
        }];
    });
}

// 视频结束时上报，需要带回调Block以自动播放下一个，上面方法上报因为Timer共用，添加回调后会造成野指针问题而不能共用。
- (void)reportEndRecordWithReportType:(NSInteger)reportType finished:(void(^)(BOOL isSuccess))finished {
    NSTimeInterval deltaTime = [[NSDate date] timeIntervalSince1970] - self.startDate;
    dispatch_async(dispatch_get_global_queue(-2, 0), ^{
        NSMutableDictionary *recordDic = [NSMutableDictionary new];
        HICStudyLogReportModel *reportModelT = [[HICStudyLogReportModel alloc]initWithType:HICStudyLogTypeTiming];
        HICStudyLogReportModel *reportModelS = [[HICStudyLogReportModel alloc]initWithType:HICStudyLogTypeStart];
        HICStudyLogReportModel *reportModelE = [[HICStudyLogReportModel alloc]initWithType:HICStudyLogTypeEnd];
        [recordDic setValue:USER_CID forKey:@"customerId"];
        [recordDic setValue:USER_TOKEN forKey:@"accessToken"];
        
        if ([NSString isValidStr:[NSString stringWithFormat:@"%@",self->_trainId]] && (self->_trainId != 0)) {
            [recordDic setValue:self->_trainId forKey:@"trainInfoId"];
            reportModelT.traincourseid = self->_trainId;
            reportModelS.traincourseid = self->_trainId;
            reportModelE.traincourseid = self->_trainId;
        }else{
            [recordDic setValue:@-1 forKey:@"trainInfoId"];
            reportModelT.traincourseid = @-1;
            reportModelS.traincourseid = @-1;
            reportModelE.traincourseid = @-1;
        }
        if ([NSString isValidStr:[NSString stringWithFormat:@"%@",self->_courseId]]) {
            [recordDic setValue:self->_courseId forKey:@"courseKLDId"];
            reportModelT.courseid = self->_courseId;
            reportModelS.courseid = self->_courseId;
            reportModelE.courseid = self->_courseId;
        }else{
            [recordDic setValue:@-1 forKey:@"courseKLDId"];
            reportModelT.courseid = @-1;
            reportModelS.courseid = @-1;
            reportModelE.courseid = @-1;
        }
        [recordDic setValue:self->_objectId forKey:@"kldId"];
        reportModelT.mediaid = self->_objectId;
        reportModelS.mediaid = self->_objectId;
        reportModelE.mediaid = self->_objectId;
        NSNumber *type = @3;
        if (self->_kType == HICAudioType) {
            type = [NSNumber numberWithInteger:2];
        }else if (self->_kType == HICVideoType) {
            type = [NSNumber numberWithInteger:1];
        }
        reportModelT.knowtype = [NSNumber numberWithInteger:self->_kType];
        reportModelS.knowtype = [NSNumber numberWithInteger:self->_kType];
        reportModelE.knowtype = [NSNumber numberWithInteger:self->_kType];
        
        [recordDic setValue:type forKey:@"fileType"];
        if ([NSString isValidStr:[NSString stringWithFormat:@"%@",self->_sectionId]]) {
            [recordDic setValue:self->_sectionId forKey:@"sectionId"];
            reportModelT.sectionId = self->_sectionId;
            [recordDic setValue:@6 forKey:@"sourceType"];
        }else{
            [recordDic setValue:@-1 forKey:@"sectionId"];
            reportModelT.sectionId = @-1;
            [recordDic setValue:@7 forKey:@"sourceType"];
        }
        [recordDic setValue:self.startStamp forKey:@"startTime"];
        reportModelT.startTime = self.startStamp;
        if ([NSString isValidStr:[NSString stringWithFormat:@"%@",self.endStamp]]) {
            [recordDic setValue:self.endStamp forKey:@"endTime"];
            reportModelT.endTime = self.endStamp;
        }else{
            [recordDic setValue:@-1 forKey:@"endTime"];
            reportModelT.endTime = @-1;
        }
        [recordDic setValue:@-1 forKey:@"costTime"];
        reportModelE.learnTime = @0;
        reportModelS.learnTime = @0;
        [recordDic setValue:@-1 forKey:@"completeFlag"];
        [recordDic setValue:self.baseInfoModel.credit forKey:@"credit"];
        [recordDic setValue:[NSNumber numberWithInteger:self.baseInfoModel.creditHours] forKey:@"kldCreditHours"];
        reportModelT.credits = [self.baseInfoModel.credit toNumber];
        [recordDic setValue:[NSNumber numberWithFloat:self.baseInfoModel.points] forKey:@"points"];
        if (self->_kType == HICFileType || self->_kType == HICPictureType || self->_kType == HICScromType) {
            if ([NSString isValidStr:[NSString stringWithFormat:@"%ld",(long)self.currentPage]] && self.tableViewDataSource.count != 0 && self.currentPage != 0) {
                if (self.currentPage >= 1 && self.tableViewDataSource.count > self.currentPage - 1) {
                    HICMediaInfoModel *model = [HICMediaInfoModel mj_objectWithKeyValues:self.tableViewDataSource[self.currentPage-1]];
                    [recordDic setValue:model.fileId forKey:@"fileId"];
                    [recordDic setValue:[NSNumber numberWithInteger:1] forKey:@"fileCategory"];
                    [recordDic setValue:[NSNumber numberWithInteger:self.currentPage] forKey:@"currentPage"];
                    [recordDic setValue:model.totalNumber forKey:@"totalPage"];
                    [recordDic setValue:@-1 forKey:@"totalDuration"];
                    [recordDic setValue:@-1 forKey:@"currentDuration"];
                    reportModelT.kldCreditHours = [NSNumber numberWithInteger:self.baseInfoModel.creditHours];
                    reportModelT.totalDuration = @-1;
                }
            }
        } else if (self.baseInfoModel.mediaInfoList.count > 0) {
            HICMediaInfoModel *model = [HICMediaInfoModel mj_objectWithKeyValues:self.baseInfoModel.mediaInfoList[self.videoIndex]];
            [recordDic setValue:model.fileId forKey:@"fileId"];
            [recordDic setValue:[NSNumber numberWithInteger:model.fileType] forKey:@"fileCategory"];
            [recordDic setValue:self.currentDuration forKey:@"currentDuration"];
            [recordDic setValue:model.totalNumber forKey:@"totalDuration"];
            reportModelT.totalDuration = model.totalNumber;
            [recordDic setValue:@-1 forKey:@"totalPage"];
            [recordDic setValue:@-1 forKey:@"currentPage"];
            reportModelT.kldCreditHours = @-1;
            reportModelE.videoquality = [NSNumber numberWithInteger:model.definition];
            reportModelS.videoquality = [NSNumber numberWithInteger:model.definition];
            reportModelE.duration = self.currentDuration;
            
            if (self.isStart) {
                NSMutableDictionary *reportS = [NSMutableDictionary dictionaryWithDictionary:[reportModelS getParamDict]];
                [reportS setValuesForKeysWithDictionary:[LogManager getSerLogEventDictWithType:HICStudyLogTypeStart]];
                [LogManager reportSerLogWithDict:reportS];
            }
            if (self.isEnd) {
                NSMutableDictionary *reportE = [NSMutableDictionary dictionaryWithDictionary:[reportModelE getParamDict]];
                [reportE setValuesForKeysWithDictionary:[LogManager getSerLogEventDictWithType:HICStudyLogTypeEnd]];
                [LogManager reportSerLogWithDict:reportE];
            }
        }
        if (reportType == 1) {
            [recordDic setValue:@0 forKey:@"learnTime"];
            reportModelT.learnTime = @0;
            if (self.isStart || self.startAgain) {
                self.isStart = NO;
                self.startAgain = NO;
            }
        } else if(reportType == 2) {
            [recordDic setValue:[NSNumber numberWithInteger:(deltaTime + 1) *self.speed] forKey:@"learnTime"];
            reportModelT.learnTime = [NSNumber numberWithInteger:(deltaTime + 1) *self.speed];
        } else {
            [recordDic setValue:[NSNumber numberWithFloat:30 *self.speed] forKey:@"learnTime"];
            reportModelT.learnTime = [NSNumber numberWithFloat:30 *self.speed];
        }
        
        NSMutableDictionary *reportT = [NSMutableDictionary dictionaryWithDictionary:[reportModelT getParamDict]];
        [reportT setValuesForKeysWithDictionary:[LogManager getSerLogEventDictWithType:HICStudyLogTypeTiming]];
        [LogManager reportSerLogWithDict:reportT];
        [HICAPI reportLearningRecords:recordDic success:^(NSDictionary * _Nonnull responseObject) {
            if (responseObject && finished) {
                finished(YES);
                self.startDate = [[NSDate date] timeIntervalSince1970];
                DDLogDebug(@"上报学习进度完成");
                NSDictionary *resultDict = responseObject[@"data"];
                if ([resultDict isKindOfClass:[NSDictionary class]]) {
                    if ([resultDict.allKeys containsObject:@"credit"]) {
                        self.baseInfoModel.credit = resultDict[@"credit"];
                    }
                    if ([resultDict.allKeys containsObject:@"creditHoursUsed"]) {
                        self.baseInfoModel.creditHoursUsed = [resultDict[@"creditHoursUsed"] integerValue];
                    }
                    if (_kType == HICPictureType || _kType == HICFileType) {
                        [self formatTopTime];
                    } else {
                        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                    }
                }
            } else if (finished) {
                finished(NO);
            }
        } failure:^(NSError * _Nonnull error) {
            DDLogDebug(@"error");
            if (finished) {
                finished(NO);
            }
        }];
    });
}

// 如果是在播放课程且当前是音视频，需要自动播放下一个知识内容
- (void)autoPlayNextKnowledge {
    [self reportEndRecordWithReportType:1 finished:^(BOOL isSuccess) {
        if (isSuccess) {
            [self getNextCoursWithReloadData:YES];
        }
    }];
}

- (void)getNextCoursWithReloadData:(BOOL)needsReload {
    if (!self.courseId) { return; }
    DDLogDebug(@"courseId= %@, objectID=%@", self.courseId, self.objectId);
    [self.postModel setObject:@6 forKey:@"objectType"];
    [self.postModel setObject:self.courseId forKey:@"objectId"];
    [self.postModel setObject:@1 forKey:@"terminalType"];
    [self.postModel setValue:self.trainId ? self.trainId :@-1 forKey:@"trainInfoId"];
    [HICAPI knowledgeAndCourseDetails:self.postModel success:^(NSDictionary * _Nonnull responseObject) {
        if (responseObject) {
            NSArray *sectionList = (NSArray *)responseObject[@"data"][@"kldSectionList"];
            BOOL sectionAllowJump = [responseObject[@"data"][@"controlInfo"][@"jumpFlag"] boolValue];
            for (int i = 0; i<sectionList.count; i++) {
                NSDictionary *sectionDict = (NSDictionary *)sectionList[i];
                if ([self.sectionId isEqualToNumber:sectionDict[@"id"]]) {
                    BOOL courseAllowJump = [sectionDict[@"jumpFlag"] boolValue];
                    NSString *sectionLearningRate = sectionDict[@"learningRate"];
                    NSArray *sectionRateArr = [sectionLearningRate componentsSeparatedByString:@"/"];
                    BOOL sectionFinished = sectionRateArr.count == 2 && [sectionRateArr.firstObject isEqualToString:sectionRateArr.lastObject];
                    DDLogDebug(@"sectionLearningRate=%@", sectionLearningRate);
                    
                    NSArray *courseList = sectionDict[@"courseList"];
                    BOOL allowPlayNextSection = sectionAllowJump || sectionFinished;
                    for (int j = 0; j < courseList.count; j++) {
                        NSDictionary *courseDict = courseList[j];
                        NSNumber *courseId = courseDict[@"courseInfo"][@"id"];
                        if (courseId && [self.objectId isEqualToNumber:courseId]) {
                            self.hasNextCourse = j < courseList.count-1 || i < sectionList.count - 1;
                            if (needsReload) {
                                NSString *courseLearningRate = courseDict[@"learningRate"];
                                DDLogDebug(@"courseLearningRate=%@", courseLearningRate);
                                BOOL allowPlayNextCourse = courseAllowJump || [courseLearningRate isEqualToString:@"100%"];
                                NSDictionary *nextCourseDict;
                                NSNumber *nextSectionId = self.sectionId;
                                if (j == courseList.count - 1) { // 当前Section最后一个课程
                                    if (i == sectionList.count - 1) { //当前课程最后一个Section
                                        return;
                                    }
                                    if (!allowPlayNextSection) {
                                        [self showVideoToastWithMessage:NSLocalizableString(@"nextChapterNotAllowed", nil) width:350 isCenter:YES duration:3];
                                        return;
                                    }
                                    // 获取下一个章节第一个课程
                                    NSDictionary *nextSection = sectionList[i+1];
                                    nextSectionId = nextSection[@"id"];
                                    NSArray *nextSectionCourseList = nextSection[@"courseList"];
                                    if (nextSectionCourseList.count > 0) {
                                        nextCourseDict = nextSectionCourseList[0];
                                    }
                                } else if (j < courseList.count - 1) {
                                    if (!allowPlayNextCourse) {
                                        [self showVideoToastWithMessage:@"该知识没有学习完成不允许学习下一个内容" width:320 isCenter:YES duration:3];
                                        return;
                                    }
                                    // 获取当前章节下一个课程
                                    nextCourseDict = courseList[j+1];
                                }
                                if (nextCourseDict) {
                                    BOOL isExam = [nextCourseDict[@"type"] integerValue] == 4;
                                    NSNumber *objcID = isExam ? nextCourseDict[@"examInfo"][@"baseInfo"][@"id"] : nextCourseDict[@"courseInfo"][@"id"];
                                    NSInteger objcType = isExam ? -1 : [nextCourseDict[@"courseInfo"][@"resourceType"] integerValue];
                                    [self playNextWith:objcID knowledgeType:objcType isExam:isExam sectionId:nextSectionId];
                                }
                            }
                            break;
                        }
                    }
                    break;
                }
            }
        }
    } failure:^(NSError * _Nonnull error) {
        DDLogDebug(@"请求课程列表失败");
    }];
}

- (void)playNextWith:(NSNumber *)objcID knowledgeType:(HICStudyResourceType)knowledgeType isExam:(BOOL)isExam sectionId:(NSNumber *)sectionId {
    UIViewController *vc;
    if (isExam) {
        HICExamCenterDetailVC *examVC = HICExamCenterDetailVC.new;
        examVC.examId = [objcID stringValue];
        examVC.trainId = [NSString stringWithFormat:@"%@",self.trainId];
        examVC.courseId = [NSString stringWithFormat:@"%@",self.courseId];
        vc = examVC;
    } else {
        HICKnowledgeDetailVC *knowledgeVC = [HICKnowledgeDetailVC new];
        knowledgeVC.kType = knowledgeType;
        knowledgeVC.objectId = objcID;
        knowledgeVC.trainId = self.trainId;
        knowledgeVC.courseId = self.courseId;
        knowledgeVC.sectionId = sectionId;
        knowledgeVC.shouldFullScreen = self.isFullScreen;
        vc = knowledgeVC;
        if (self.baseInfoModel.resourceType == HICScromType || self.baseInfoModel.resourceType == HICHtmlType ) {
            knowledgeVC.urlStr = self.baseInfoModel.mediaInfoList[0][@"url"];
            knowledgeVC.hideNavi = YES;
            knowledgeVC.hideTabbar = YES;
        }
    }

    if ((knowledgeType == HICVideoType || knowledgeType == HICAudioType) && self.isFullScreen) {
        // 因为横屏问题，此处需要延迟销毁移除自己，所以只跳转至下一页即可
        [self.navigationController pushViewController:vc animated:NO];
    } else {
        if (self.kType == HICVideoType || self.kType == HICAudioType) {
            [self.videoPlayer enterFullScreenWithFullScreen:NO animate:NO];
        }
        [self.navigationController pushViewController:vc animated:NO];
        [self removeFromParentViewController];
    }
}

- (void)removeSelfNoti:(NSNotification *)noti {
    if (noti.userInfo && ![noti.userInfo[@"target"] isEqualToNumber:self.objectId]) {
        [self.videoPlayer enterFullScreenWithFullScreen:NO animate:NO];
        [self removeFromParentViewController];
    }
}

- (void)reloadData {
    self.currentPage = 1;
    self.speed = 1.0;
    self.startDuration = @0;
    self.currentDuration = @(0);
    self.startDate = [[NSDate date] timeIntervalSince1970];
    self.isObserver = NO;
    if (_kType == HICAudioType ||_kType == HICVideoType || _kType == HICFileType || _kType == HICPictureType) {
        self.sysTimer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(reportRecordWithReportType:) userInfo:nil repeats:YES];
    }

    self.view.backgroundColor = [UIColor whiteColor];
    if (!self.navigationController.isNavigationBarHidden) {
        self.navigationController.navigationBarHidden = YES;
    }
    [self createUI];
    [self initData]; // 请求数据，初始化了VideoPlayerHelper
    [self requestData];
    self.isLandscape = NO;

    [self getNextCoursWithReloadData:NO];
}

#pragma mark - 屏幕旋转
- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return self.isLandscape ? UIInterfaceOrientationMaskLandscapeRight : UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (void)setInterfaceOrientation:(UIInterfaceOrientation)orientation {
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = (int)orientation;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

#pragma mark - JHKVideoPlayerDelegate
- (void)goBackPageWithVideoPlayer:(JHKVideoPlayer *)videoPlayer{
    [self leftBtnClicked];
}
- (void)videoPlayerWithVideoPlayer:(JHKVideoPlayer *)videoPlayer didPauseToPlay:(NSTimeInterval)currentTime totalTime:(NSTimeInterval)totalTime index:(NSInteger)index {
    DDLogDebug(@"videoPlayer didPauseToPlay");
    self.videoIndex = index;
    NSNumber *num = [NSNumber numberWithInteger:currentTime];
    if ([num isEqual: @-1]) {
        return;
    }
    self.currentDuration = [NSNumber numberWithInteger:currentTime * 1000];
    [self reportRecordWithReportType:2];
    if (self.sysTimer) {
        [self.sysTimer invalidate];
    }
    if (self.observerTimer) {
        [self.observerTimer invalidate];
    }
}
- (void)videoPlayerWithVideoPlayer:(JHKVideoPlayer * _Nonnull)videoPlayer didStoppedPlay:(NSTimeInterval)totalTime playedTime:(NSTimeInterval)playedTime index:(NSInteger)index isAutoPlayed:(BOOL)isAutoPlayed{
    DDLogDebug(@"videoPlayer didStoppedPlay");
    self.videoIndex = index;
    NSNumber *num = [NSNumber numberWithInteger:playedTime];
    if ([num isEqual:@-1]) {
        return;
    }
    self.currentDuration = [NSNumber numberWithInteger:playedTime * 1000];
    self.startAgain = YES;
    self.hasNextCourse ? [self autoPlayNextKnowledge] : [self reportRecordWithReportType:1];
    
    if (self.sysTimer) {
        [self.sysTimer invalidate];
    }
    if (self.observerTimer) {
        [self.observerTimer invalidate];
    }
}

- (void)videoPlayerWithVideoPlayer:(JHKVideoPlayer *)videoPlayer changePlay:(NSTimeInterval)changeTime totalTime:(NSTimeInterval)totalTime index:(NSInteger)index{
    NSNumber *num = [NSNumber numberWithInteger:changeTime];
    if ([num isEqual:@-1] ) {
        return;
    }
    self.currentDuration = @(changeTime * 1000);
    self.videoIndex = index;
    
    if (self.hasNextCourse && !self.hadToastWillJumpNext && (totalTime - changeTime <= 5)) {
        [self showVideoToastWithMessage:NSLocalizableString(@"learnNextContent", nil) width:170 isCenter:NO duration:2];
        self.hadToastWillJumpNext = YES;
    }
}

- (void)videoPlayerWithVideoPlayer:(JHKVideoPlayer *)videoPlayer didDraggedSlider:(NSTimeInterval)fromTime toTime:(NSTimeInterval)toTime {
    if (toTime > fromTime && self.learningRate < 1 && !self.hadToastDragNotRecord) {
        [self showVideoToastWithMessage:NSLocalizableString(@"fastForwardNoHaveScore", nil) width:200 isCenter:NO duration:2];
        self.hadToastDragNotRecord = YES;
    }
}

- (void)videoPlayerWithVideoPlayer:(JHKVideoPlayer *)videoPlayer didPrepareToPlay:(NSTimeInterval)totalTime index:(NSInteger)index isAutoPlayed:(BOOL)isAutoPlayed {
    NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:@"0"];
    if(self.startDuration){
        [playerHelper seekWithTimerInterval:[self.startDuration stringValue].floatValue];
    }
    if ([str isEqualToString:@"isOn"]) {
        self.videoIndex = index;
        if (!self.sysTimer) {
            self.sysTimer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(reportRecordWithReportType:) userInfo:nil repeats:YES];
        }
        if (self.isObserver ) {
            if(!self.observerTimer){
                __weak typeof(self) weakSelf = self;
                self.observerTimer = [NSTimer timerWithTimeInterval:weakSelf.controlModel.notOperatedIntervel * 60 target:weakSelf selector:@selector(runObserver) userInfo:nil repeats:YES];
            }
            [[NSRunLoop currentRunLoop] addTimer:self.observerTimer forMode:NSRunLoopCommonModes];
        }
    }else {
        [playerHelper pause];
        if (self.sysTimer) {
            [self.sysTimer invalidate];
        }
    }
}
- (void)videoPlayerWithVideoPlayer:(JHKVideoPlayer *)videoPlayer didAgainPlay:(NSTimeInterval)totalTime currentTime:(NSTimeInterval)currentTime index:(NSInteger)index{
    self.videoIndex = index;
    if (currentTime != -1) {
        self.currentDuration = [NSNumber numberWithInteger:currentTime];
    }else{
        self.currentDuration = @0;
    }
    if (!self.sysTimer) {
        self.sysTimer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(reportRecordWithReportType:) userInfo:nil repeats:YES];
    }
    
    if (self.isObserver) {
        if(!self.observerTimer){
            __weak typeof(self) weakSelf = self;
            self.observerTimer = [NSTimer timerWithTimeInterval:weakSelf.controlModel.notOperatedIntervel * 60 target:weakSelf selector:@selector(runObserver) userInfo:nil repeats:YES];
        }
        [[NSRunLoop currentRunLoop] addTimer:self.observerTimer forMode:NSDefaultRunLoopMode];
    }
    self.startAgain = YES;
    [self reportRecordWithReportType:1];
}
// 全屏和小屏时的转化
-(void)videoPlayerWithVideoPlayer:(JHKVideoPlayer *)videoPlayer videoPlayerWithVideoPlayer:(BOOL)isFull {
    [self setNeedsStatusBarAppearanceUpdate];
    [playerHelper setAudioBackImageFrameWithIsFull:isFull];
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"setVideoGuidePage"]) {
        if (isFull) {
            // 全屏时 -- 需要读取本地信息 进行引导展示
            [playerHelper addVideoBackImageFrameWithIsFull:isFull];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"setVideoGuidePage"];
        }
    }
}
- (void)videoPlayerWithVideoPlayer:(JHKVideoPlayer *)videoPlayer changeRate:(NSInteger)Index rate:(float)rate{
    [self.sysTimer invalidate];
    [self reportRecordWithReportType:2];
    self.speed = rate;
    self.sysTimer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(reportRecordWithReportType:) userInfo:nil repeats:YES];
}

- (void)videoPlayerWithVideoPlayer:(JHKVideoPlayer *)videoPlayer didEnterFullScreen:(BOOL)isFull {
    [self setNeedsStatusBarAppearanceUpdate];
    if (@available(iOS 11.0, *)) {
        [self setNeedsUpdateOfHomeIndicatorAutoHidden];
    }
}

- (BOOL)prefersStatusBarHidden {
    self.isFullScreen = [playerHelper getVideoisFullScreen];
    return self.isFullScreen;
}

- (BOOL)prefersHomeIndicatorAutoHidden {
    return [playerHelper getVideoisFullScreen];
}

#pragma mark - TableView 数据源方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_kType == HICPictureType ||_kType == HICFileType) {
        return self.tableViewDataSource.count;
    } else {
        return 4;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_kType == HICPictureType ||_kType == HICFileType) {
        HICStudyDocPhotoListItemCell *cell = (HICStudyDocPhotoListItemCell *)[tableView dequeueReusableCellWithIdentifier:@"DocPhotoCell" forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[HICStudyDocPhotoListItemCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DocPhotoCell"];
        }
        cell.model = [HICMediaInfoModel mj_objectWithKeyValues:self.tableViewDataSource[indexPath.row]];
        cell.controlModel = self.controlModel;
        return cell;
    } else {
        UITableViewCell *cell;
        if (indexPath.row == 0) {
            HICLessonIntroductCell *inductCell;
            inductCell = (HICLessonIntroductCell*)[tableView dequeueReusableCellWithIdentifier:@"IntroductCell" forIndexPath:indexPath];
            inductCell.baseModel = self.baseInfoModel;
            inductCell.lessonDelegate = self;
            inductCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return inductCell;
        }else if (indexPath.row == 1) {
            HICLessonContentCell *contentCell;
            contentCell = (HICLessonContentCell *)[tableView dequeueReusableCellWithIdentifier:@"ContentCell" forIndexPath:indexPath];
            contentCell.baseModel = self.baseInfoModel;
            contentCell.extensionDelegate = self;
            contentCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return contentCell;
        }else if (indexPath.row == 2) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"ExercisesCell" forIndexPath:indexPath];
            HICStudyVideoPlayExercisesCell *exCell = (HICStudyVideoPlayExercisesCell *)cell;
            exCell.delegate = self;
            exCell.dataArr = self.exciseArr;
            exCell.selectionStyle = UITableViewCellSelectionStyleNone;
            if ([HICCommonUtils isValidObject:self.exciseArr] && self.exciseArr.count > 0) {
                exCell.hidden = NO;
            }else {
                exCell.hidden = YES;
            }
            return exCell;
        }else {
            cell = [tableView dequeueReusableCellWithIdentifier:@"RelateCell" forIndexPath:indexPath];
            HICStudyVideoPlayRelatedCell *relateCell = (HICStudyVideoPlayRelatedCell *)cell;
            relateCell.delegate = self;
            relateCell.dataArr = self.recommendArr;
            relateCell.selectionStyle = UITableViewCellSelectionStyleNone;
            if ([HICCommonUtils isValidObject:self.recommendArr] && self.recommendArr.count > 0) {
                relateCell.hidden = NO;
            }else {
                relateCell.hidden = YES;
            }
            return relateCell;
        }
    }
}
#pragma mark ---videoPlayerDelegate
- (void)goBackPageWithVideoPlayer {
    [self leftBtnClicked];
}
#pragma mark ---hiclessonContentdelegate
- (void)extensionClicked:(NSString *)title{
    self.titleStr = title;
    [self.tableView reloadData];
}
#pragma mark - TableView 的协议方法
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_kType == HICPictureType || _kType == HICFileType) {
        CGFloat tableH = tableView.frame.size.height;
        CGFloat cellH = tableH/(self.isLandscape ? 1.0 : 2.0) - 20;
        return cellH;
    } else {
        if (indexPath.row == 0) {
            tableView.estimatedRowHeight = 200;
            tableView.rowHeight = UITableViewAutomaticDimension;
            CGFloat height = [HICCommonUtils sizeOfString:self.baseInfoModel.name stringWidthBounding:HIC_ScreenWidth - 32 font:18 stringOnBtn:NO fontIsRegular:NO].height;
            return  height > 50 ?50 + 50 + 96.5 + 30:height + 50 + 96.5 + 30;
        }else if(indexPath.row == 1){
            if ([HICCommonUtils isValidObject:self.baseInfoModel.author]) {
                tableView.estimatedRowHeight = 230;
                tableView.rowHeight = UITableViewAutomaticDimension;
                if ([NSString isValidStr:self.baseInfoModel.desc]) {
                    if( [self getContentHeightS:self.baseInfoModel.desc] > 60){
                        if ([self.titleStr isEqualToString:NSLocalizableString(@"develop", nil)]) {
                            return [self getContentHeightS:self.baseInfoModel.desc] + 104 + 42 + 38;
                        }else{
                            return 60 + 104 + 42 + 38;
                        }
                    } else{
                        return [self getContentHeightS:self.baseInfoModel.desc] + 104 + 42 + 16;
                    }
                }else{
                    return 104 + 42 + 38 + 20;
                }
            }else{
                return 104 + 48 + 6;
            }
        }else if(indexPath.row == 2){
            if ([HICCommonUtils isValidObject:self.exciseArr] && self.exciseArr.count > 0) {
                return self.exciseArr.count *50 + 56 + 16;
            }else{
                return 0;
            }
        }else{
            if ([HICCommonUtils isValidObject:self.recommendArr] && self.recommendArr.count > 0) {
                return self.recommendArr.count *50 + 56 + 16;
            }else{
                return 0;
            }
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_kType == HICPictureType ||_kType == HICFileType) {
        DDLogDebug(@"当前点击了第几个 -- %ld", (long)indexPath.row);
        [self showDetailViewWithIndex:indexPath.row];
    } else {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat tableH = scrollView.frame.size.height;
    CGFloat cellH = tableH/2.0 - 20;
    CGPoint setPoint = scrollView.contentOffset;
    CGFloat contentY = setPoint.y;
    if (contentY <= 40) {
        [self changeCurrentPage:1];
    }else if (contentY <= cellH) {
        [self changeCurrentPage:2];
    }else if (self.tableViewDataSource.count - 2 > 0 && contentY < (self.tableViewDataSource.count - 2) * cellH - 40) {
        DDLogDebug(@"%f --- %f --- %f", contentY/cellH, contentY, cellH);
        [self changeCurrentPage:contentY/cellH + 2];
    }else if (self.tableViewDataSource.count - 2 > 0 && contentY >= (self.tableViewDataSource.count - 2) * cellH - 40) {
        [self changeCurrentPage:self.tableViewDataSource.count];
    }
}

#pragma mark - 自定义Cell的协议方法
// 1. 点击更多的协议方法
- (void)studyVideoPlayCell:(HICStudyVideoPlayBaseCell *)cell clickMoreBut:(UIButton *)btn cellType:(StudyVideoPlayCellType)cellType {
    if (cellType == StudyVideoPlayCellExercises) {
        DDLogDebug(@"VC ==== 点击练习题更多");
        HICStudyVideoPlayExercisesListVC *vc = HICStudyVideoPlayExercisesListVC.new;
        vc.objectId = self.baseInfoModel.courseID;
        vc.trainId = _trainId;
        vc.objectType = @7;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (cellType == StudyVideoPlayCellRelated) {
        DDLogDebug(@"VC ==== 点击相关更多");
        HICStudyVideoPlayRelatedListVC *vc = HICStudyVideoPlayRelatedListVC.new;
        vc.objectId = self.baseInfoModel.courseID;
        vc.objectType = @7;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

// 2. 点击cell内容Item的协议方法
-(void)studyVideoPlayCell:(HICStudyVideoPlayBaseCell *)cell clickItemBut:(UIButton *)btn cellType:(StudyVideoPlayCellType)cellType itemModel:(id)data {
    NSNumber *index = (NSNumber *)data;
    if (cellType == StudyVideoPlayCellExercises) {
        HICExamCenterDetailVC *vc = [HICExamCenterDetailVC new];
        HICExerciseModel *model = [HICExerciseModel mj_objectWithKeyValues:self.exciseArr[index.integerValue]];
        if (![NSString isValidStr:[NSString stringWithFormat:@"%@",model.exerciseId]]) {
            return;
        }
        vc.examId = [NSString stringWithFormat:@"%@",model.exerciseId];
        vc.courseId = [NSString stringWithFormat:@"%@",_courseId];
        vc.trainId = [NSString stringWithFormat:@"%@",_trainId];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (cellType == StudyVideoPlayCellRelated) {
        HICCourseModel *model = [HICCourseModel mj_objectWithKeyValues:self.recommendArr[index.integerValue][@"courseKLDInfo"]];
        if (model.courseKLDType == 6) {
            HICLessonsVC *vc = [HICLessonsVC new];
            vc.objectID = model.courseKLDId;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            HICKnowledgeDetailVC *vc = [HICKnowledgeDetailVC new];
            vc.objectId = model.courseKLDId;
            vc.kType = model.resourceType;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

#pragma mark -贡献者的协议方法
- (void)jumpContributorList:(HICContributorModel *)model{
    HICContributorListVC *vc = HICContributorListVC.new;
    vc.type = 1000;
    vc.contributor = model;
    if (!model.customerId) {
        [HICToast showWithText:NSLocalizableString(@"currentContributorHasNoSource", nil)];
        return;
    }
    [self.navigationController pushViewController:vc animated:YES];
    
}
//作者跳转贡献者列表
- (void)jumpToContributor:(HICAuthorModel *)model {
    HICContributorListVC *vc = HICContributorListVC.new;
    vc.type = 2000;
    vc.authorModel = model;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - - - HICStudyDocPhotoDetailDelegate - - - Start
- (void)removeDetailViewWithIndex:(NSInteger)currentIndex {
    [self hideDetailViewWithIndex:currentIndex];
}

- (void)studyDocPhotoDetailViewDidClickedPicture {
    if (self.isLandscape) {
        [self rotateScreenAction:nil];
    }
}

#pragma mark - - - HICStudyDocPhotoDetailDelegate - - - End

#pragma mark - - - HICStudyBtmViewDelegate - - - Start
- (void)moreBtnClick {
    DLManager.delegate = self;
    BOOL hasExercise = NO;
    if ([HICCommonUtils isValidObject:self.exciseArr]) {
        if (self.exciseArr.count > 0) {
            hasExercise = YES;
        }
    }
    BOOL hasRelated = NO;
    if ([HICCommonUtils isValidObject:self.recommendArr]) {
        if (self.recommendArr.count > 0) {
            hasRelated = YES;
        }
    }
    dispatch_async([DBManager database_queue], ^{
        HICKnowledgeDownloadModel *kModel = [DBManager selectMediasByMediaId:self.objectId isCourseId:NO].firstObject;
        self.controlModel.downloadFlag = self->_kType == HICZipType ? 0 : self.controlModel.downloadFlag;
        self.controlModel.downloadFlag = self->_kType == HICScromType ? 0 : self.controlModel.downloadFlag;
        dispatch_async(dispatch_get_main_queue(), ^{
            self->studyView = [[HICStudyShareView alloc] initWithDownloadStatus :kModel && [kModel.mediaId isEqual:self.objectId] ? kModel.mediaStatus : HICDownloadIdle type:HICStudyBtmViewKnowledge subType:self->_kType hasNote:self->_haveNote itemsShow:self.controlModel hasExercise:hasExercise hasRelated:hasRelated andMediaId:self->_objectId];
            self->studyView.delegate = self;
            [self.view addSubview:self->studyView];
        });
    });
}

- (void)commentBtnClick {
    cwv = [[HICCommentWriteView alloc] initWithType:HICCommentWrite commentTo:@"二哈" identifer:@"1001"];
    [self.view addSubview:cwv];
    if (!cwv.delegate) {
        cwv.delegate = self;
    }
}

- (void)commentSectionBtnClick {
    CGFloat topMargin = 0;
    if (_kType == HICVideoType || _kType == HICAudioType) {
        topMargin = 191 + HIC_StatusBar_Height;
    }
    HICCommentPopupView *cpv = [[HICCommentPopupView alloc] initWithVideoSectionHeight:topMargin isFromCourse:NO identifier:[self.objectId toString]];
    cpv.onView = self.view;
    [self.view addSubview:cpv];
}

- (void)pageBtnClick {
    self.docPhotoBackView.hidden = NO;
    self.topTimeBackView.hidden = NO;
    __weak typeof(self) weakSelf = self;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:weakSelf selector:@selector(removeTimeLabel) userInfo:nil repeats:NO];
}

- (void)thumbup:(BOOL)isThumbup {
    isThumbup ? self.baseInfoModel.userLikeNum++ : self.baseInfoModel.userLikeNum--;
    if (_kType == HICPictureType ||_kType == HICFileType) {
        [self.inductView reloadData];
    }else{
        [self.tableView reloadData];
    }
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
    NSURL *shareUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@/mweb/index.html?type=2&objectType=7&objectId=%@&kldType=%ld",APP_Web_DOMAIN ,_objectId,(long)_kType]];
    NSArray *activityItems = @[shareUrl];
    UIActivityViewController *activityVc = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    [self presentViewController:activityVc animated:YES completion:nil];
    activityVc.completionWithItemsHandler = ^(UIActivityType _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
        if (completed) {
            DDLogDebug(@"分享成功");
            [self->studyView hideShareView];
        } else {
            DDLogDebug(@"分享取消");
        }
    };
}
/// 内容简介
- (void)goToContentIntro {
    [self loadMaskData:3];
}

/// 练习题
- (void)goToPractice {
    [self loadMaskData:2];
}

/// 相关推荐
- (void)goToRelated {
    [self loadMaskData:1];
}
- (void)addNoteClicked {
    cwv = [[HICCommentWriteView alloc] initWithType:HICCommentNote commentTo:@"二哈" identifer:@"1001"];
    [self.view addSubview:cwv];
    if (!cwv.delegate) {
        cwv.delegate = self;
    }
}

- (void)checkNoteClicked {
    HICCheckNoteView *cnv = [[HICCheckNoteView alloc] initWithNotes:@[] type:HICStudyBtmViewKnowledge identifier:[self.objectId toString]];
    [self.view addSubview:cnv];
}

- (void)goToDownload:(HICDownloadStatus)downloadStatus type:(HICStudyBtmViewType)type {
    if (type == HICStudyBtmViewCourse) {
        DDLogDebug(@"用户点击了【课程】下载");
    } else {
        DDLogDebug(@"用户点击了【知识】下载");
        if (downloadStatus == HICDownloading) {
            NSMutableArray *knowledgeModelArr = [[NSMutableArray alloc] init];
            NSInteger resourceType = self.baseInfoModel.resourceType;
            NSArray *mediaInfoList = self.baseInfoModel.mediaInfoList;
            if ([HICCommonUtils isValidObject:mediaInfoList] && mediaInfoList.count > 0) {
                HICKnowledgeDownloadModel *kModel = [[HICKnowledgeDownloadModel alloc] init];
                NSDictionary *media = mediaInfoList.firstObject;
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
                kModel.mediaName = self.baseInfoModel.name;
                kModel.mediaSingle = 1;
                kModel.mediaId = self.baseInfoModel.courseID;
                kModel.mediaCount = 1;
                kModel.mediaStatus = HICDownloading;
                kModel.coverPic = self.baseInfoModel.coverPic;
                kModel.trainID = _trainId?_trainId:@0;
                kModel.sectionId = _sectionId?_sectionId:@0;
                kModel.cMediaId = _courseId?_courseId:@0;
                [knowledgeModelArr addObject:kModel];
                [DLManager startDownloadWith:knowledgeModelArr];
            }
        } else if (downloadStatus == HICDownloadStop) {
            [DLManager pauseWith:self.objectId];
        } else if (downloadStatus == HICDownloadResume) {
            [DLManager resumeWith:self.objectId];
        }
    }
}
#pragma mark - - - HICStudyShareViewDelegate - - - End

#pragma mark - - - HICDownloadManagerDelegate - - - Start
- (void)downloadProcess:(CGFloat)percent kModel:(HICKnowledgeDownloadModel *)kModel {
    if ([kModel.mediaId isEqual:self.objectId]) {
        HICDownloadStatus status = kModel.mediaStatus;
        [studyView updateDownloadStatus:status andProcess:percent];
    }
}
#pragma mark - - - HICDownloadManagerDelegate - - - End

#pragma mark - - - HICCommentWriteViewDelegate - - - End
- (void)publishBtnClickedWithContent:(NSString *)content type:(HICCommentType)type starNum:(NSInteger)stars isImportant:(BOOL)important toAnybody:(NSString *)name {
    [HICAPI publishBtnClickedWithContent:content type:type starNum:stars isImportant:important toAnybody:name objectID:self.objectId typeCode:HICReportKnowledgeType success:^(NSDictionary * _Nonnull responseObject) {
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
#pragma mark - - - HICCommentWriteViewDelegate - - - Start

#pragma mark - - - HICCustomNaviViewDelegate  - - -
- (void)leftBtnClicked {
    [playerHelper pause];
    if (self.presentingViewController && self.navigationController.viewControllers.count == 1) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark -- WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.name isEqualToString:zhiShengJSMethodName]) {
        NSDictionary *bodyDict = [HICCommonUtils convertJsonStringToDictinary:message.body];
        DDLogDebug(@"智胜播放器打点上报 body:%@, dict:%@", message.body, bodyDict);
        if ([bodyDict isKindOfClass:NSDictionary.class]) {
            NSString *msgType = bodyDict[@"msgType"];
            self.completeFlag = bodyDict[@"completeFlag"];
            if ([msgType isEqualToString:@"start"]) {
                [self reportRecordWithReportType:1];
            } else if ([msgType isEqualToString:@"alive"]) {
                if (self.firstAlive) {
                    [self reportRecordWithReportType:2];
                } else {
                    [self reportRecordWithReportType:3];
                    self.firstAlive = YES;
                }
            } else if ([msgType isEqualToString:@"end"]) {
                [self reportRecordWithReportType:2];
            }
        }
        if ([self.completeFlag integerValue] == 1 && self.hasNextCourse) {
            [self getNextCoursWithReloadData:YES];
        }
    }
}

#pragma Mark - Getters
- (CGFloat)learningRate {
    NSArray *learnRatingArr = [self.baseInfoModel.credit componentsSeparatedByString:@"/"];
    if (learnRatingArr.count < 2 || !learnRatingArr.firstObject || !learnRatingArr.lastObject) {
        return 0.0;
    }
    return [learnRatingArr.firstObject floatValue] / [learnRatingArr.lastObject floatValue];
}

#pragma mark -- 懒加载
- (HomeTaskCenterDefaultView *)defaultView {
    if (!_defaultView) {
        _defaultView = [[HomeTaskCenterDefaultView alloc]initWithFrame:CGRectMake(0, HIC_NavBarAndStatusBarHeight, HIC_ScreenWidth, HIC_ScreenHeight - HIC_NavBarAndStatusBarHeight)];
        _defaultView.titleStr = NSLocalizableString(@"noReadingPermissionPrompt", nil);
        _defaultView.imageName = @"无权限";
        _defaultView.number = 2;
    }
    return _defaultView;
}

- (NSMutableArray *)tableViewDataSource {
    if (!_tableViewDataSource) {
        _tableViewDataSource = [[NSMutableArray alloc]init];
    }
    return _tableViewDataSource;
}

- (UIButton *)rotateBtn {
    if (!_rotateBtn) {
        _rotateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rotateBtn setImage:[UIImage imageNamed:@"hic_file_landscape"] forState:UIControlStateNormal];
        [_rotateBtn addTarget:self action:@selector(rotateScreenAction:) forControlEvents:UIControlEventTouchUpInside];
        [_rotateBtn setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
        _rotateBtn.frame = CGRectMake(0, 0, 56, 56);
        [self.view insertSubview:_rotateBtn aboveSubview:self.detailView];
        [_rotateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.view);
            make.right.equalTo(self.view).inset(16);
            make.width.height.equalTo(@56);
        }];
    }
    return _rotateBtn;
}

- (HICStudyDocPhotoDetailView *)detailView {
    if (!_detailView) {
        CGFloat top = self.isLandscape ? HIC_NavBarHeight : HIC_NavBarAndStatusBarHeight;
        _detailView = [[HICStudyDocPhotoDetailView alloc] initWithFrame:CGRectMake(0, top, HIC_ScreenWidth, HIC_ScreenHeight - top)];
        _detailView.alpha = 0;
        _detailView.delegate = self;
        [self.view addSubview:_detailView];
        [_detailView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(HIC_ScreenHeight - HIC_NavBarAndStatusBarHeight);
            make.left.right.bottom.equalTo(self.view);
        }];
        _detailView.hidden = YES;
    }
    return _detailView;
}

- (WKWebView *)webView {
    if (!_webView) {
        WKUserContentController *userContentController = [[WKUserContentController alloc] init];
        [userContentController addScriptMessageHandler:[[HICWeakScriptMessageDelegate alloc] initWithDelegate:self] name:zhiShengJSMethodName];
        WKWebViewConfiguration* webViewConfig = [[WKWebViewConfiguration alloc] init];
        webViewConfig.userContentController = userContentController;
//        webViewConfig.allowsInlineMediaPlayback = true;
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, HIC_ScreenWidth, HIC_ScreenWidth / 1.78 + HIC_StatusBar_Height) configuration:webViewConfig];
        _webView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _webView.backgroundColor = [UIColor blackColor];
        if ([self.mediaArr.firstObject isKindOfClass:NSDictionary.class]) {
            NSDictionary *media = (NSDictionary *)self.mediaArr.firstObject;
            NSString *url = media[@"url"];
            [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"%@&clienttype=ios", url] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]]];
            DDLogDebug(@"webView url=%@", url);
        }
    }
    return _webView;
}

- (NSArray *)exciseArr {
    if (!_exciseArr) {
        _exciseArr = [NSArray array];
    }
    return _exciseArr;
}

- (NSArray *)recommendArr {
    if (!_recommendArr) {
        _recommendArr = [NSArray array];
    }
    return _recommendArr;
}

@end
