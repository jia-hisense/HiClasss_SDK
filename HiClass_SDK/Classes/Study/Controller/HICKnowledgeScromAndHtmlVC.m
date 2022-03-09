//
//  HICKnowledgeScromAndHtmlVC.m
//  HiClass
//
//  Created by WorkOffice on 2020/4/20.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICKnowledgeScromAndHtmlVC.h"
#import "HICStudyBtmView.h"
#import "HICStudyShareView.h"
#import "HICCommentView.h"
#import "HICCommentWriteView.h"
#import "HICCommentPopupView.h"
#import "HICCheckNoteView.h"
#import "HICCollectionHintView.h"
#import "HICNetModel.h"
#import "HICBaseInfoModel.h"
#import "HICControlInfoModel.h"
#import "HomeTaskCenterDefaultView.h"
#import "HICAuthorModel.h"
#import "HICContributorListVC.h"
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
#import "HICLessonIntroductView.h"
#import "HICStudyVideoPlayExercisesListVC.h"
#import "HICStudyVideoPlayRelatedListVC.h"
#import "HICMediaInfoModel.h"
#import "DDXML.h"
static NSString *logName = @"[HIC][KDVC]";

@interface HICKnowledgeScromAndHtmlVC () <HICCustomNaviViewDelegate, HICCommentViewDelegate,HICStudyBtmViewDelegate,HICStudyShareViewDelegate,HICDownloadManagerDelegate, HICCommentWriteViewDelegate,HICLessonContentDelegate> {
    HICStudyBtmView *btmView;
    HICStudyShareView * studyView;
    HICCommentWriteView * cwv;
}
@property (nonatomic, strong) HICCustomNaviView *navi;
@property (nonatomic, strong) NSString *naviTitle;
@property (nonatomic, strong) HICNetModel *netModel;
@property (nonatomic, strong) HICBaseInfoModel *baseInfoModel;
@property (nonatomic, strong) HICControlInfoModel *controlModel;
@property (nonatomic, strong) HomeTaskCenterDefaultView *defaultView;
@property (nonatomic, strong) NSArray *exciseArr;
@property (nonatomic, strong) NSArray *recommendArr;
@property (nonatomic, strong) HICLessonIntroductView *inductView;
@property (nonatomic ,strong) HICStudyVideoPlayRelatedListVC *relatedVC;
@property (nonatomic ,strong) HICStudyVideoPlayExercisesListVC *exericiseVC;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIView *container;
@property (nonatomic, strong) UIView *insideView;
@property (nonatomic, strong) UILabel *maskTitleLabel;
@property (nonatomic ,assign) BOOL haveNote;
@property (nonatomic, strong)NSString *playUrl;
@end

@implementation HICKnowledgeScromAndHtmlVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self requestData];
}
- (void)loadXML{
    NSError *error;
    NSData *xmlData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.playUrl]];
    DDXMLDocument *xmlDoc = [[DDXMLDocument alloc]initWithData:xmlData options:0 error:&error];
    if (error) {
        DDLogDebug(@"%@",error);
    }else{
        DDLogDebug(@"获取成功");
    }
    [self parseDire:xmlDoc];
}
- (void) parseDire:(DDXMLDocument *) document
{
    NSMutableArray *hrefArr = [NSMutableArray array];
    DDXMLElement *root = [document rootElement];
    NSArray *resourcesArr = [root elementsForName:@"resources"];
    for (DDXMLElement *res in resourcesArr) {
        NSArray *sourceArr = [res elementsForName:@"resource"];
        for (DDXMLElement *source in sourceArr) {
            NSString *ss = [[source attributeForName:@"href"] stringValue];
            if ([NSString isValidStr:ss]) {
                [hrefArr addObject:ss];
            }
        }
    }
    NSMutableArray *arr = [NSMutableArray array];
    if (hrefArr.count > 0) {
        NSString *htmlUrl = hrefArr[0];
        arr = (NSMutableArray *)[self.playUrl componentsSeparatedByString:@"/"];
        [arr replaceObjectAtIndex:arr.count - 1 withObject:htmlUrl];
        NSString *str = [arr componentsJoinedByString:@"/"];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setValue:USER_TOKEN forKey:@"accessToken"];
        [params setValue:@-1 forKey:@"trainInfoId"];
        [params setValue:@-1 forKey:@"completeFlag"];
        [params setValue:@-1 forKey:@"currentDuration"];
        [params setValue:@-1 forKey:@"totalDuration"];
        [params setValue:@0 forKey:@"currentPage"];
        [params setValue:@-1 forKey:@"totalPage"];
        [params setValue:@-1 forKey:@"courseKLDId"];
        [params setValue:@-1 forKey:@"sectionId"];
        [params setValue:@1 forKey:@"fileCategory"];
        [params setValue:@7 forKey:@"sourceType"];
        [params setValue:[NSNumber numberWithInteger:HICScromType] forKey:@"fileType"];
        [params setValue:_objectId forKey:@"kldId"];
        [params setValue:@-1 forKey:@"costTime"];
        [params setValue:@-1 forKey:@"kldCreditHours"];
        [params setValue:@-1 forKey:@"startTime"];
        [params setValue:@-1 forKey:@"endTime"];
        [params setValue:@-1 forKey:@"points"];
        [params setValue:@-1 forKey:@"credit"];
        [params setValue:@-1 forKey:@"learnTime"];
        [params setValue:USER_CID forKey:@"customerId"];
        if (self.baseInfoModel.mediaInfoList.count > 0) {
        HICMediaInfoModel *model = [HICMediaInfoModel mj_objectWithKeyValues:self.baseInfoModel.mediaInfoList[0]];
            [params setValue:model.fileId forKey:@"fileId"];
        }
        
        NSMutableDictionary *request = [NSMutableDictionary dictionary];
        [request setValue:[NSString stringWithFormat:@"%@/heduapi/v1.0/webapi/reportLearningRecord", DEFALUT_COMMENTS_DOMAIN] forKey:@"url"];
        [request setObject:params forKey:@"params"];
        NSString *requestStr = [self jsonStringPrettyPrintedFormatForDictionary:request];
        
        NSString *constUrl = [NSString stringWithFormat:@"%@/heduopapi/templetes/scorm-player/index.html", APP_DOC_CDN_DOMAIN];
        NSString *lastUrl = [NSString stringWithFormat:@"%@&url=%@&request=%@&timeDiff=0",constUrl,str,requestStr];
        [HiWebViewManager addParentVC:self urlStr:lastUrl isDelegate:YES isPush:YES hideCusNavi:YES hideCusTabBar:YES];
            [self createNavi];
        [self createBtmBar];
    }
}
- (NSString *)jsonStringPrettyPrintedFormatForDictionary:(NSDictionary *)dicJson {
    if (![dicJson isKindOfClass:[NSDictionary class]] || ![NSJSONSerialization isValidJSONObject:dicJson]) {

        return nil;

    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dicJson options:NSJSONWritingPrettyPrinted error:nil];
    NSString *strJson = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return strJson;
}
- (void)createNavi {
    self.navi = [[HICCustomNaviView alloc] initWithTitle:_naviTitle rightBtnName:nil showBtnLine:NO];
    _navi.delegate = self;
    [self.view addSubview:_navi];
}
- (void)createBtmBar {
    // 底部按钮集View
    NSArray *btmBtArr = @[@{NSLocalizableString(@"writeComment", nil):@"BT-写评论"}, @{NSLocalizableString(@"collection", nil):@"BT-收藏"}, @{NSLocalizableString(@"giveLike", nil):@"BT-点赞"}, @{NSLocalizableString(@"more", nil):@"更多操作"}];
    btmView = [[HICStudyBtmView alloc] initWithFrame:CGRectMake(0, HIC_ScreenHeight - 52 - HIC_BottomHeight, HIC_ScreenWidth, 52 + HIC_BottomHeight) numberOfComments:@"0"];
    [btmView customLeftBtns:@[] rightBtns:btmBtArr];
    btmView.delegate = self;
    btmView.btmType = HICStudyBtmViewKnowledge;
    //    btmView.kldId = _objectId;
    [self.view addSubview:btmView];
}
- (void)initData {
    self.naviTitle = @"";
    NSMutableDictionary *postModel = [NSMutableDictionary new];
    [postModel setObject:@7 forKey:@"objectType"];
    [postModel setValue:_objectId forKey:@"objectId"];
    [postModel setValue:_trainId ? _trainId :@0 forKey:@"trainInfoId"];
    [postModel setValue:_sectionId ? _sectionId :@-1 forKey:@"sectionId"];
    [postModel setValue:@1 forKey:@"terminalType"];
    [HICAPI knowledgeAndCourseDetails:postModel success:^(NSDictionary * _Nonnull responseObject) {
        if (responseObject) {
            self.baseInfoModel = [HICBaseInfoModel mj_objectWithKeyValues:responseObject[@"data"][@"baseInfo"]];
            //            self.baseInfoModel =
            self.playUrl = self.baseInfoModel.playUrl;
            [self loadXML];
            self.controlModel = [HICControlInfoModel mj_objectWithKeyValues:responseObject[@"data"][@"controlInfo"]];
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
            if ([NSString isValidStr:[NSString stringWithFormat:@"%ld",(long)self.controlModel.notOperatedIntervel]]) {
                if (self.controlModel.notOperatedIntervel != 0) {
                    //                    self.observerTimer = [NSTimer timerWithTimeInterval:self.controlModel.notOperatedIntervel *60 target:self selector:@selector(runObserver) userInfo:nil repeats:YES];
                    //                    self.isObserver = YES;
                }
            }
            self.naviTitle = self.baseInfoModel.name;
            [self.navi modifyTitleLabel:self.baseInfoModel.name];
            
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
                [self->btmView updateCommentsCount:[totalnum toString]];
            }
        } failure:^(NSError * _Nonnull error) {
            DDLogDebug(@"error");
        }];
    });
}

#pragma mark - - - HICCustomNaviViewDelegate  - - -
- (void)leftBtnClicked {
    if (self.presentingViewController && self.navigationController.viewControllers.count == 1) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)createMaskView{
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
        //        self.relatedVC = [HICStudyVideoPlayRelatedListVC new];
        //        self.relatedVC.objectId = _objectId;
        //        self.relatedVC.objectType = @7;
        //         [_insideView addSubview:self.relatedVC.tableView];
        [maskTable setDataArr:self.recommendArr andType:@1];
        [_insideView addSubview:maskTable];
        self.maskTitleLabel.text = NSLocalizableString(@"relatedRecommend", nil);
    }else if(type == 2){
        //        self.exericiseVC = [HICStudyVideoPlayExercisesListVC new];
        //        self.exericiseVC.objectId = _objectId;
        //        self.exericiseVC.objectType = @7;
        //        [_insideView addSubview:self.exericiseVC.view];
        [maskTable setDataArr:self.exciseArr andType:@0];
        [_insideView addSubview:maskTable];
        self.maskTitleLabel.text = NSLocalizableString(@"exercises", nil);
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
- (void)jumpToContributor:(HICAuthorModel *)model{
    HICContributorListVC *vc = HICContributorListVC.new;
    vc.type = 2000;
    vc.authorModel = model;
    [self.navigationController pushViewController:vc animated:YES];
}

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
    self.controlModel.downloadFlag = 0;
    studyView.delegate = self;
    [self.view addSubview:studyView];
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
    
    HICCommentPopupView *cpv = [[HICCommentPopupView alloc] initWithVideoSectionHeight:topMargin isFromCourse:NO identifier:[self.objectId toString]];
    [self.view addSubview:cpv];
}
- (void)thumbup:(BOOL)isThumbup {
    DDLogDebug(@"%@成功", isThumbup ? @"点赞" : @"取消点赞");
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
    NSURL *shareUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@/mweb/index.html?type=2&objectType=7&objectId=%@&kldType=%ld", APP_Web_DOMAIN,_objectId,(long)HICScromType]];
    //    NSArray *activityItems = @[shareTitle,shareImg,shareUrl];
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
/// 内容简介
- (void)goToContentIntro{
    [self loadMaskData:3];
}

/// 练习题
- (void)goToPractice{
    [self loadMaskData:2];
}

/// 相关推荐
- (void)goToRelated{
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


@end
