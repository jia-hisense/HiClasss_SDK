//
//  HICStudyShareView.m
//  HiClass
//
//  Created by Eddie Ma on 2020/2/4.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICStudyShareView.h"
#import "HICCircleProgressView.h"

static NSString *logName = @"[HIC][SSV]";

@interface HICStudyShareView() {
    HICCircleProgressView *circleView;
    CGFloat _duration;
    BOOL _hasNote;
    CGFloat _downloadProcess;
    BOOL _hasFirstLine;
    BOOL _hasExercise;
    BOOL _hasRelated;
}

@property (nonatomic, strong) UIView *shareView;
@property (nonatomic, strong) UIImageView *downloadStatusIV;
@property (nonatomic, strong) UIButton *downloadContainer;
@property (nonatomic, assign) HICDownloadStatus downloadStatus;
@property (nonatomic, assign) HICStudyBtmViewType type;
@property (nonatomic, assign) HICStudyResourceType subType;
@property (nonatomic, strong) UILabel *checkNoteLabel;
@property (nonatomic, strong) HICControlInfoModel *controlModel;
@property (nonatomic ,strong) NSNumber *mediaId;
@end

@implementation HICStudyShareView

- (instancetype)initWithDownloadStatus:(HICDownloadStatus)status type:(HICStudyBtmViewType)type subType:(HICStudyResourceType)subType hasNote:(BOOL)hasNote itemsShow:(HICControlInfoModel *)controlModel hasExercise:(BOOL)hasExercise hasRelated:(BOOL)hasRelated andMediaId:(nonnull NSNumber *)mediaId{
    if (self = [super init]) {
        _downloadProcess = 0.0;
        _hasNote = hasNote;
        self.type = type;
        self.subType = subType;
        self.downloadStatus = status;
        self.controlModel = controlModel;
        _hasExercise = hasExercise;
        _hasRelated= hasRelated;
        self.mediaId = mediaId;
        self.frame = CGRectMake(0, 0, HIC_ScreenWidth, HIC_ScreenHeight);
        self.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.50];
        UITapGestureRecognizer *viewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(event:)];
        [viewTap setNumberOfTapsRequired:1];
        [self addGestureRecognizer:viewTap];
        [self createUI];
        [self addObservers];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)addObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(courseDownloadingHanlder) name:@"COURSE_DOWNLOADING" object:nil];
}

- (void)courseDownloadingHanlder {
    [self updateDownloadStatus];
}

- (void)createUI {
    // 第一排按钮设置
    NSString *downloadStr = NSLocalizableString(@"download", nil);
    NSString *imgDownLoad = @"下载";
    if (_downloadStatus == HICDownloading || _downloadStatus == HICDownloadResume) {
        downloadStr = NSLocalizableString(@"isDownloading", nil);
        imgDownLoad = @"正在下载";
    } else if (_downloadStatus == HICDownloadStop) {
        downloadStr = NSLocalizableString(@"hasSuspended", nil);
        imgDownLoad = @"已暂停";
    } else if (_downloadStatus == HICDownloadFinish) {
        downloadStr = NSLocalizableString(@"downloadComplete", nil);
        imgDownLoad = @"下载完成";
    } else {}
    NSArray *firstLineArr = @[downloadStr, NSLocalizableString(@"contentAbstract", nil), NSLocalizableString(@"exercises", nil), NSLocalizableString(@"relatedRecommend", nil)];
    NSArray *firstImageArr = @[imgDownLoad, @"内容简介", @"练习题", @"相关推荐"];
    if (_subType == HICPictureType || _subType == HICHtmlType || _subType == HICScromType || _subType == HICFileType) {
        if (_hasExercise && _hasRelated) {
            firstLineArr = @[downloadStr, NSLocalizableString(@"contentAbstract", nil), NSLocalizableString(@"exercises", nil), NSLocalizableString(@"relatedRecommend", nil)];
            firstImageArr = @[imgDownLoad,@"内容简介",@"练习题",@"相关推荐"];
        } else if (_hasExercise && !_hasRelated) {
            firstLineArr = @[downloadStr, NSLocalizableString(@"contentAbstract", nil), NSLocalizableString(@"exercises", nil)];
            firstImageArr = @[imgDownLoad,@"内容简介",@"练习题"];
        } else if (!_hasExercise && _hasRelated) {
            firstLineArr = @[downloadStr, NSLocalizableString(@"contentAbstract", nil), NSLocalizableString(@"relatedRecommend", nil)];
            firstImageArr = @[imgDownLoad,@"内容简介",@"相关推荐"];
        } else if (!_hasExercise && !_hasRelated) {
            firstLineArr = @[downloadStr, NSLocalizableString(@"contentAbstract", nil)];
            firstImageArr = @[imgDownLoad,@"内容简介"];
        }
    } else {
        firstLineArr = @[downloadStr];
        firstImageArr = @[imgDownLoad];
    }
    if (_controlModel.downloadFlag == 0 || _type == HICStudyBtmViewCourse) {
        NSMutableArray *temFirstLineArr = [[NSMutableArray alloc] initWithArray:firstLineArr];
        [temFirstLineArr removeObjectAtIndex:0];
        firstLineArr = temFirstLineArr;
        NSMutableArray *temFirstImageArr = [[NSMutableArray alloc] initWithArray:firstImageArr];
        [temFirstImageArr removeObjectAtIndex:0];
        firstImageArr = temFirstImageArr;
    }
    
    CGFloat shareViewHeight = 275;
    if (firstLineArr.count == 0) {
        shareViewHeight = 57 + 92.5 + 26;
    } else {
        _hasFirstLine = YES;
    }
    // 第二排按钮设置
    NSArray *secondLineArr = _controlModel.shareFlag == 0 ? @[NSLocalizableString(@"addNote", nil),NSLocalizableString(@"readNote", nil)] : @[NSLocalizableString(@"addNote", nil),NSLocalizableString(@"readNote", nil),NSLocalizableString(@"share", nil)];
    NSArray *secondImageArr = _controlModel.shareFlag == 0 ? @[@"添加笔记",@"查阅笔记"] : @[@"添加笔记",@"查阅笔记",@"分享"];
    
    self.shareView = [[UIView alloc] init];
    [self addSubview:self.shareView];
    self.shareView.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1/1.0];
    self.shareView.frame = CGRectMake(0, HIC_ScreenHeight, self.frame.size.width, shareViewHeight + HIC_BottomHeight);
    [UIView animateWithDuration:0.3 animations:^{
        self.shareView.frame = CGRectMake(0, self.frame.size.height - shareViewHeight - HIC_BottomHeight, self.frame.size.width, shareViewHeight + HIC_BottomHeight);
    }];
    [HICCommonUtils setRoundingCornersWithView:self.shareView TopLeft:YES TopRight:YES bottomLeft:NO bottomRight:NO cornerRadius:15];
    
    // 适配齐刘海屏幕底部view
    UIView *btmView = [[UIView alloc] initWithFrame:CGRectMake(0, self.shareView.frame.size.height - HIC_BottomHeight, self.shareView.frame.size.width, HIC_BottomHeight)];
    btmView.backgroundColor = [UIColor whiteColor];
    [self.shareView addSubview:btmView];
    // 取消按钮
    UIButton *cancelBtn = [[UIButton alloc] init];
    cancelBtn.frame = CGRectMake(0, self.shareView.frame.size.height - 50 - HIC_BottomHeight, self.frame.size.width, 50);
    [cancelBtn setBackgroundColor: [UIColor whiteColor]];
    [cancelBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#e6e6e6"]] forState:UIControlStateHighlighted];
    [cancelBtn setTitleColor:[UIColor colorWithRed:133/255.0 green:133/255.0 blue:133/255.0 alpha:1/1.0] forState:UIControlStateNormal];
    [cancelBtn setTitle:NSLocalizableString(@"cancel", nil) forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = FONT_REGULAR_17;
    cancelBtn.tag = 1000;
    [cancelBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.shareView addSubview:cancelBtn];
    
    // 第一排按钮创建
    if (firstLineArr.count > 0) {
        [self shareGroups:firstLineArr imageGroups:firstImageArr intervalBetweenImgAndLabel:6 imgWidth:57 intervalBetweenContainerV:35.5 leftMargin:20 topMargin:26 tagStart:3000 itemImgWidth:24];
    }
    // 第二排按钮创建
    [self shareGroups:secondLineArr imageGroups:secondImageArr intervalBetweenImgAndLabel:6 imgWidth:57 intervalBetweenContainerV:35.5 leftMargin:20 topMargin: _hasFirstLine ? 125.5 : 26 tagStart:2000 itemImgWidth:24];
    
}

- (void)shareGroups:(NSArray *)group imageGroups:(NSArray *)imageGroup intervalBetweenImgAndLabel:(CGFloat)iBIALabel imgWidth:(CGFloat)imgW intervalBetweenContainerV:(CGFloat)iBCV leftMargin:(CGFloat)lM topMargin:(CGFloat)tM tagStart:(NSInteger)tS itemImgWidth:(CGFloat)iIW {
    CGFloat intervalBetweenImgAndLabel = iBIALabel;
    CGFloat imgWidth = imgW;
    CGFloat intervalBetweenContainerV = iBCV;
    CGFloat leftMargin = lM;
    CGFloat topMargin = tM;
    CGFloat itemImgWidth = iIW;
    NSInteger tagStart = tS;
    for (int i = 0; i < group.count; i++) {
        NSString *labelText = group[i];
        NSString *imgText = imageGroup[i];
        
        UIButton *containerV = [[UIButton alloc] init];
        [containerV setTitle:labelText forState:UIControlStateNormal];
        [containerV setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        
        UIView *imgContainer = [[UIView alloc] init];
        imgContainer.backgroundColor = [UIColor whiteColor];
        imgContainer.layer.cornerRadius = 8;
        imgContainer.layer.masksToBounds = YES;
        imgContainer.frame = CGRectMake(0, 0, imgWidth, imgWidth);
        imgContainer.userInteractionEnabled = NO;
        [containerV addSubview:imgContainer];
        
        NSString *downloadStr = imgText;
        
        self.downloadStatusIV = [[UIImageView alloc] init];
        if (_downloadStatus == HICDownloadIdle || i  > 0 || tagStart < 3000){
            UIImageView *imgV = [[UIImageView alloc] init];
            imgV.image = [UIImage imageNamed:downloadStr];
            [imgContainer addSubview:imgV];
            imgV.frame = CGRectMake(imgWidth/2 - itemImgWidth/2, imgWidth/2 - itemImgWidth/2, itemImgWidth, itemImgWidth);
            [imgV addSubview:self.downloadStatusIV];
        } else {
            itemImgWidth = itemImgWidth + 4;
            circleView = [[HICCircleProgressView alloc]initWithFrame:CGRectMake(imgWidth/2 - itemImgWidth/2, imgWidth/2 - itemImgWidth/2, itemImgWidth, itemImgWidth)];
            [imgContainer addSubview:circleView];
            [circleView addSubview:self.downloadStatusIV];
        }
        
        if (tagStart >= 3000 && i == 0) {
            NSString *imgName = @"";
            CGFloat imgHeight = 0;
            CGFloat imgWidth = 0;
            if (_downloadStatus == HICDownloading || _downloadStatus == HICDownloadResume) {
                imgName = @"暂停";
                imgWidth = 8;
                imgHeight = 10;
            } else if (_downloadStatus == HICDownloadStop) {
                imgName = @"点击下载";
                imgWidth = 11;
                imgHeight = 11;
            } else if (_downloadStatus == HICDownloadFinish) {
                imgName = @"下载完成";
                imgWidth = 14;
                imgHeight = 14;
                [circleView updateProgressStatus:1];
            } else {}
            
            self.downloadStatusIV.image = [UIImage imageNamed:imgName];
            self.downloadStatusIV.frame = CGRectMake(itemImgWidth/2 - imgWidth/2, itemImgWidth/2 - imgHeight/2, imgWidth, imgHeight);
        } else {
            
        }
        
        UILabel *label = [[UILabel alloc] init];
        label.font = FONT_REGULAR_12
        label.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha: (!_hasNote && tagStart == 2000 && i == 1) ? 0.5 : 1/1.0];
        [containerV addSubview:label];
        label.text = labelText;
        label.textAlignment = NSTextAlignmentCenter;
//        CGFloat labelTextWidth = [HICCommonUtils sizeOfString:labelText stringWidthBounding:HIC_ScreenWidth font:12 stringOnBtn:NO fontIsRegular:YES].width;
        CGFloat labelTextWidth = (HIC_ScreenWidth - 40) / 4;
        CGFloat labelTextHeight = [HICCommonUtils sizeOfString:labelText stringWidthBounding:HIC_ScreenWidth font:12 stringOnBtn:NO fontIsRegular:YES].height;
        if (labelTextWidth > imgWidth) {
            imgContainer.frame = CGRectMake(labelTextWidth/2 - imgWidth/2, 0, imgWidth, imgWidth);
            containerV.frame = CGRectMake(leftMargin + i * intervalBetweenContainerV + i * imgWidth, topMargin, labelTextWidth, imgWidth + intervalBetweenImgAndLabel + labelTextHeight);
        } else {
            imgContainer.frame = CGRectMake(0, 0, imgWidth, imgWidth);
            containerV.frame = CGRectMake(leftMargin + i * intervalBetweenContainerV + i * imgWidth, topMargin, imgWidth, imgWidth + intervalBetweenImgAndLabel + labelTextHeight);
        }
        label.frame = CGRectMake(0, imgWidth + intervalBetweenImgAndLabel, containerV.frame.size.width, labelTextHeight);
        if (tagStart == 2000 && i == 1) {
            self.checkNoteLabel = label;
        }
        
        containerV.tag = tagStart + i;
        [containerV addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        if (tagStart >= 3000 && i == 0) {
            self.downloadContainer = containerV;
            [self.shareView addSubview:self.downloadContainer];
        } else {
            [self.shareView addSubview:containerV];
        }
    }
}

- (void)updateDownloadStatus {
    [self.downloadContainer.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSString *downloadStr = NSLocalizableString(@"download", nil);
    NSString *imageDownLoad = @"下载";
    if (_downloadStatus == HICDownloading || _downloadStatus == HICDownloadResume) {
        _downloadStatus = HICDownloadStop;
        downloadStr = NSLocalizableString(@"hasSuspended", nil);
        imageDownLoad = @"已暂停";
        //        [self deleteTimer];
    } else if (_downloadStatus == HICDownloadIdle) {
        _downloadStatus = HICDownloading;
        downloadStr = NSLocalizableString(@"isDownloading", nil);
        imageDownLoad = @"正在下载";
    } else if (_downloadStatus == HICDownloadStop) {
        _downloadStatus = HICDownloadResume;
        downloadStr = NSLocalizableString(@"isDownloading", nil);
        imageDownLoad = @"正在下载";
    } else if (_downloadStatus == HICDownloadFinish) {
        downloadStr = NSLocalizableString(@"downloadComplete", nil);
        imageDownLoad = @"下载完成";
    } else {}
    [self shareGroups:@[downloadStr] imageGroups:@[imageDownLoad] intervalBetweenImgAndLabel:6 imgWidth:57 intervalBetweenContainerV:35.5 leftMargin:20 topMargin:26 tagStart:3000 itemImgWidth:24];
    if (_downloadStatus != HICDownloadIdle) {
        [circleView updateProgressStatus:_downloadStatus == HICDownloadFinish ? 1 : _downloadProcess];
    }
}

- (void)updateDownloadStatus:(HICDownloadStatus)status andProcess:(CGFloat)percent {
    _downloadStatus = status;
    if (status != HICDownloadIdle) {
        _downloadProcess = percent;
        if (status != HICDownloadFinish) {
            [circleView updateProgressStatus:percent];
        } else {
            [self updateDownloadStatus];
        }
    }
}

- (void)btnClick:(UIButton *)btn {
    ///日志上报
    HICStudyLogReportModel *reportModel = [[HICStudyLogReportModel alloc]initWithType:HICCourseDetailClick];
    reportModel.mediaid = self.mediaId;
    reportModel.knowtype = [NSNumber numberWithInteger:self.subType];
    if (self.type == HICStudyBtmViewCourse) {
        reportModel.mediatype = [NSNumber numberWithInteger:HICReportCourseType];
    }else{
        reportModel.mediatype = [NSNumber numberWithInteger:HICReportKnowledgeType];
    }
    reportModel.buttonname = btn.titleLabel.text;
    NSMutableDictionary *report = [NSMutableDictionary dictionaryWithDictionary:[reportModel getParamDict]];
    [report setValuesForKeysWithDictionary:[LogManager getSerLogEventDictWithType:HICCourseDetailClick]];
    if (btn.tag != 1000) {
        [LogManager reportSerLogWithDict:report];
    }
    
    if (btn.tag == 1000) {
        [self hideShareView];
    } else if ([btn.titleLabel.text isEqualToString:NSLocalizableString(@"addNote", nil)]) { // 添加笔记
        DDLogDebug(@"%@ Add note", logName);
        if ([self.delegate respondsToSelector:@selector(addNoteClicked)]) {
            [self.delegate addNoteClicked];
        }
    } else if ([btn.titleLabel.text isEqualToString:NSLocalizableString(@"readNote", nil)]) { // 查阅笔记
        if ([self.delegate respondsToSelector:@selector(checkNoteClicked)] && _hasNote) {
            DDLogDebug(@"%@ check note", logName);
            [self.delegate checkNoteClicked];
        }
    } else if ([btn.titleLabel.text isEqualToString:NSLocalizableString(@"share", nil)]) { // 分享
        DDLogDebug(@"%@ Go to system Share Page", logName);
        if ([self.delegate respondsToSelector:@selector(shareTo)]) {
            [self.delegate shareTo];
        }
    } else if ([btn.titleLabel.text isEqualToString:NSLocalizableString(@"download", nil)] || [btn.titleLabel.text isEqualToString:NSLocalizableString(@"isDownloading", nil)] || [btn.titleLabel.text isEqualToString:NSLocalizableString(@"hasSuspended", nil)] || [btn.titleLabel.text isEqualToString:NSLocalizableString(@"downloadComplete", nil)]) { // 下载
        DDLogDebug(@"%@ Go to Download", logName);
        if (_type == HICStudyBtmViewKnowledge || (_type == HICStudyBtmViewCourse && _downloadStatus != HICDownloadIdle)) {
            [self updateDownloadStatus];
        }
        if ([self.delegate respondsToSelector:@selector(goToDownload:type:)]) {
            [self.delegate goToDownload:_downloadStatus type:_type];
        }
    } else if ([btn.titleLabel.text isEqualToString:NSLocalizableString(@"contentAbstract", nil)]) { // 内容简介
        DDLogDebug(@"%@ Go to Content Intro", logName);
        if ([self.delegate respondsToSelector:@selector(goToContentIntro)]) {
            [self.delegate goToContentIntro];
        }
    } else if ([btn.titleLabel.text isEqualToString:NSLocalizableString(@"exercises", nil)]) { // 练习题
        DDLogDebug(@"%@ Go to Practice", logName);
        if ([self.delegate respondsToSelector:@selector(goToPractice)]) {
            [self.delegate goToPractice];
        }
    } else if ([btn.titleLabel.text isEqualToString:NSLocalizableString(@"relatedRecommend", nil)]) { // 相关推荐
        DDLogDebug(@"%@ Go to Related", logName);
        if ([self.delegate respondsToSelector:@selector(goToRelated)]) {
            [self.delegate goToRelated];
        }
    } else {}
}

- (void)event:(UITapGestureRecognizer *)gesture {
    [self hideShareView];
}

- (void)hideShareView {
    [UIView animateWithDuration:0.3 animations:^{
        self.shareView.frame = CGRectMake(0, HIC_ScreenHeight, self.frame.size.width, self.shareView.frame.size.height);
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
    });
}

- (void)hasNote:(BOOL)hasNote {
    _hasNote = hasNote;
    _checkNoteLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha: (!_hasNote) ? 0.5 : 1/1.0];
}

@end
