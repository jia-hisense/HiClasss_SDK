//
//  HICStudyBtmView.m
//  HiClass
//
//  Created by Eddie Ma on 2020/2/3.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICNetModel.h"
#import "HICStudyBtmView.h"

static NSString *logName = @"[HIC][CBTMV]";
#define CBTMV_label_width 33

@interface HICStudyBtmView()
@property (nonatomic, assign) NSString *count;
@property (nonatomic, assign) BOOL isCollected;
@property (nonatomic, assign) BOOL isThumbup;

@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) UIImageView *collectionIV;
@property (nonatomic, strong) UILabel *collectionLabel;

@property (nonatomic, strong) UIImageView *thumbupIV;
@property (nonatomic, strong) UILabel *thumbupLabel;

@property (nonatomic, strong) NSArray *leftBtnArr;
@property (nonatomic, strong) NSArray *rightBtnArr;


@end

@implementation HICStudyBtmView

- (instancetype)initWithFrame:(CGRect)frame numberOfComments:(NSString *)count {
    if (self = [super init]) {
        self.count = count;
        self.frame = frame;
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOpacity = 0.2;
        self.layer.shadowOffset = CGSizeZero;
        self.layer.shadowRadius = 2;

        self.backgroundColor = [UIColor whiteColor];
        [self initData];
        [self createUI];
    }
    return self;
}

- (void)initData {
    self.leftBtnArr = @[@{NSLocalizableString(@"comments", nil): @"BT-滑到评论"}];
    self.rightBtnArr = @[@{NSLocalizableString(@"writeComment", nil):@"BT-写评论"}, @{NSLocalizableString(@"collection", nil):@"BT-收藏"}, @{NSLocalizableString(@"note", nil):@"BT-笔记"}, @{NSLocalizableString(@"more", nil):@"更多操作"}];
}

- (void)customLeftBtns:(NSArray *)leftArr rightBtns:(NSArray *)rightArr {
    if (leftArr.count > 0) {
        self.leftBtnArr = leftArr;
    }

    if (rightArr.count > 0) {
        self.rightBtnArr = rightArr;
    }
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self createUI];
}

- (void)createUI {
    [self leftItems:self.leftBtnArr];
    [self rightItems:self.rightBtnArr];
}

- (void)leftItems:(NSArray *)items {
    for (int i = 0; i < items.count; i++) {
        NSDictionary *dic = items[i];
        NSArray *dickeys = dic.allKeys;
        NSArray *dicValues = dic.allValues;
        NSString *labelText = dickeys.firstObject;
        NSString *imgText = dicValues.firstObject;

        CGFloat intervalBetweenImgAndLabel = 2;
        CGFloat imgWidth = 24;
        CGFloat intervalBetweenContainerV = 0;

        UIButton *containerV = [[UIButton alloc] init];
        [self addSubview:containerV];

        UIImageView *imgV = [[UIImageView alloc] init];
        imgV.image = [UIImage imageNamed:imgText];
        [containerV addSubview:imgV];
        imgV.frame = CGRectMake(0, 0, imgWidth, imgWidth);

        UILabel *label = [[UILabel alloc] init];
        label.font = FONT_REGULAR_11
        label.textColor = [UIColor colorWithRed:133/255.0 green:133/255.0 blue:133/255.0 alpha:1/1.0];
        [containerV addSubview:label];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = labelText;
        CGFloat labelTextWidth = [HICCommonUtils sizeOfString:@"评论" stringWidthBounding:HIC_ScreenWidth font:11 stringOnBtn:NO fontIsRegular:YES].width;
        CGFloat labelTextHeight = [HICCommonUtils sizeOfString:labelText stringWidthBounding:HIC_ScreenWidth font:11 stringOnBtn:NO fontIsRegular:YES].height;
        if (labelTextWidth > imgWidth) {
            imgV.frame = CGRectMake(labelTextWidth/2 - imgWidth/2 + 10, 0, imgWidth, imgWidth);
            containerV.frame = CGRectMake(10 + i * intervalBetweenContainerV + i * imgWidth, 8, labelTextWidth + 20, imgWidth + intervalBetweenImgAndLabel + labelTextHeight);
        } else {
            imgV.frame = CGRectMake(10, 0, imgWidth, imgWidth);
            containerV.frame = CGRectMake(10 + i * intervalBetweenContainerV + i * imgWidth, 8, imgWidth + 20, imgWidth + intervalBetweenImgAndLabel + labelTextHeight);
        }
        label.frame = CGRectMake(0, imgWidth + intervalBetweenImgAndLabel, containerV.frame.size.width, labelTextHeight);

        if ([labelText isEqualToString:NSLocalizableString(@"comments", nil)]) {
            UILabel *numberLabel = [[UILabel alloc] init];
            CGFloat numberLabelWidth = [HICCommonUtils sizeOfString:self.count stringWidthBounding:HIC_ScreenWidth font:11 stringOnBtn:NO fontIsRegular:NO].width;
            CGFloat numberLabelHeight = [HICCommonUtils sizeOfString:self.count stringWidthBounding:HIC_ScreenWidth font:11 stringOnBtn:NO fontIsRegular:NO].height;
            numberLabel.text = self.count;
            numberLabel.font = FONT_MEDIUM_11;
            numberLabel.textColor = [UIColor colorWithRed:255/255.0 green:133/255.0 blue:0/255.0 alpha:1/1.0];
            numberLabel.frame = CGRectMake(28, -3, numberLabelWidth, numberLabelHeight);
            self.countLabel = numberLabel;
            [containerV addSubview:self.countLabel];
        }
        containerV.tag = 1000 + i;
        [containerV addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)rightItems:(NSArray *)items {
    for (int i = 0; i < items.count; i++) {
        NSDictionary *dic = items[i];
        NSArray *dickeys = dic.allKeys;
        NSArray *dicValues = dic.allValues;
        NSString *labelText = dickeys.firstObject;
        NSString *imgText = dicValues.firstObject;

        CGFloat intervalBetweenImgAndLabel = 2;
        CGFloat imgWidth = 24;
        CGFloat intervalBetweenContainerV = 36;
        CGFloat rightMargin = 20;

        UIButton *containerV = [[UIButton alloc] init];
        [self addSubview:containerV];

        UIImageView *imgV = [[UIImageView alloc] init];
        imgV.image = [UIImage imageNamed:imgText];
        imgV.frame = CGRectMake(0, 0, imgWidth, imgWidth);

        UILabel *label = [[UILabel alloc] init];
        label.font = FONT_REGULAR_11
        label.textColor = [UIColor colorWithRed:133/255.0 green:133/255.0 blue:133/255.0 alpha:1/1.0];
        [containerV addSubview:label];
        label.text = labelText;
        label.textAlignment = NSTextAlignmentCenter;
        CGFloat labelTextHeight = [HICCommonUtils sizeOfString:labelText stringWidthBounding:HIC_ScreenWidth font:11 stringOnBtn:NO fontIsRegular:YES].height;
        CGFloat containerX = self.frame.size.width - (rightMargin + (items.count - (i + 1)) * intervalBetweenContainerV + (items.count - i) * imgWidth);
        imgV.frame = CGRectMake(CBTMV_label_width/2 - imgWidth/2, 0, imgWidth, imgWidth);
        containerV.frame = CGRectMake(containerX, 8, CBTMV_label_width, imgWidth + intervalBetweenImgAndLabel + CBTMV_label_width);

        label.frame = CGRectMake(0, imgWidth + intervalBetweenImgAndLabel, containerV.frame.size.width, labelTextHeight);
        if ([labelText isEqualToString:NSLocalizableString(@"collection", nil)] || [labelText isEqualToString:NSLocalizableString(@"collected", nil)]) {
            self.collectionIV = imgV;
            self.collectionLabel = label;
            containerV.selected = NO;
            [containerV addSubview:self.collectionIV];
        } else if ([labelText isEqualToString:NSLocalizableString(@"giveLike", nil)] || [labelText isEqualToString:NSLocalizableString(@"hasBeenPraised", nil)]) {
            self.thumbupIV = imgV;
            self.thumbupLabel = label;
            containerV.selected = NO;
            [containerV addSubview:self.thumbupIV];
        } else {
            [containerV addSubview:imgV];
        }
        if (i == 0) {
            UIView *dividedLine = [[UIView alloc] initWithFrame:CGRectMake(containerX - 26, (self.frame.size.height - 36 - HIC_BottomHeight)/2, 0.5, 36)];
            dividedLine.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1/1.0];
            [self addSubview:dividedLine];
        }
        containerV.tag = 2000 + i;
        [containerV addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];

    }
}

- (void)updateCommentsCount:(NSString *)count {
    CGFloat numberLabelWidth = [HICCommonUtils sizeOfString:count stringWidthBounding:HIC_ScreenWidth font:11 stringOnBtn:NO fontIsRegular:NO].width;
    CGFloat numberLabelHeight = [HICCommonUtils sizeOfString:count stringWidthBounding:HIC_ScreenWidth font:11 stringOnBtn:NO fontIsRegular:NO].height;
    self.countLabel.frame = CGRectMake(28, -3, numberLabelWidth, numberLabelHeight);
    self.countLabel.text = count;
}

- (void)isAlreadyCollected {
    self.isCollected = YES;
    self.collectionIV.image = [UIImage imageNamed:@"BT-已收藏"];
    self.collectionLabel.text = NSLocalizableString(@"collected", nil);
}

- (void)isAlreadyThumbup {
    self.isThumbup = YES;
    self.thumbupIV.image = [UIImage imageNamed:@"BT-已赞"];
    self.thumbupLabel.text = NSLocalizableString(@"hasBeenPraised", nil);
}

- (void)btnClicked:(UIButton *)btn {
    if (btn.tag < 2000) { // 左边按钮集合
        NSInteger index = btn.tag - 1000;
        if (index == 0) { // 评论
            DDLogDebug(@"%@ Comment section Btn clicked", logName);
            if ([self.delegate respondsToSelector:@selector(commentSectionBtnClick)]) {
                [self.delegate commentSectionBtnClick];
            }
            ///日志上报
            HICStudyLogReportModel *reportModel = [[HICStudyLogReportModel alloc]initWithType:HICCourseDetailClick];
            reportModel.mediaid = _kldId;
            reportModel.knowtype = _knowType;
            if (_btmType == 6) {
                reportModel.mediatype = [NSNumber numberWithInteger:HICReportCourseType];
            }else{
                reportModel.mediatype = [NSNumber numberWithInteger:HICReportKnowledgeType];
            }
            reportModel.buttonname = NSLocalizableString(@"comments", nil);
            NSMutableDictionary *report = [NSMutableDictionary dictionaryWithDictionary:[reportModel getParamDict]];
            [report setValuesForKeysWithDictionary:[LogManager getSerLogEventDictWithType:HICCourseDetailClick]];
            [LogManager reportSerLogWithDict:report];
        }
    } else { // 右边按钮集合
        NSInteger index = btn.tag - 2000;
        if (index == 0) { // 写评论
            ///日志上报
            HICStudyLogReportModel *reportModel = [[HICStudyLogReportModel alloc]initWithType:HICCourseDetailClick];
            reportModel.mediaid = _kldId;
            reportModel.knowtype = _knowType;
            if (_btmType == 6) {
                reportModel.mediatype = [NSNumber numberWithInteger:HICReportCourseType];
            }else{
                reportModel.mediatype = [NSNumber numberWithInteger:HICReportKnowledgeType];
            }
            reportModel.buttonname = NSLocalizableString(@"writeComment", nil);
            NSMutableDictionary *report = [NSMutableDictionary dictionaryWithDictionary:[reportModel getParamDict]];
            [report setValuesForKeysWithDictionary:[LogManager getSerLogEventDictWithType:HICCourseDetailClick]];
            [LogManager reportSerLogWithDict:report];
            DDLogDebug(@"%@ Write comment Btn clicked", logName);
            if ([self.delegate respondsToSelector:@selector(commentBtnClick)]) {
                [self.delegate commentBtnClick];
            }
        } else if (index == 1) { // 收藏
            
            if (btn.selected) {
                // 取消收藏
                btn.selected = NO;
                ///日志上报
                HICStudyLogReportModel *reportModel = [[HICStudyLogReportModel alloc]initWithType:HICCourseDetailClick];
                reportModel.mediaid = _kldId;
                reportModel.knowtype = _knowType;
                if (_btmType == 6) {
                    reportModel.mediatype = [NSNumber numberWithInteger:HICReportCourseType];
                }else{
                    reportModel.mediatype = [NSNumber numberWithInteger:HICReportKnowledgeType];
                }
                reportModel.buttonname = NSLocalizableString(@"cancelCollection", nil);
                NSMutableDictionary *report = [NSMutableDictionary dictionaryWithDictionary:[reportModel getParamDict]];
                [report setValuesForKeysWithDictionary:[LogManager getSerLogEventDictWithType:HICCourseDetailClick]];
                [LogManager reportSerLogWithDict:report];
            } else {
                // 收藏
                btn.selected = YES;
                ///日志上报
                HICStudyLogReportModel *reportModel = [[HICStudyLogReportModel alloc]initWithType:HICCourseDetailClick];
                reportModel.mediaid = _kldId;
                reportModel.knowtype = _knowType;
                if (_btmType == 6) {
                    reportModel.mediatype = [NSNumber numberWithInteger:HICReportCourseType];
                }else{
                    reportModel.mediatype = [NSNumber numberWithInteger:HICReportKnowledgeType];
                }
                reportModel.buttonname = NSLocalizableString(@"collection", nil);
                NSMutableDictionary *report = [NSMutableDictionary dictionaryWithDictionary:[reportModel getParamDict]];
                [report setValuesForKeysWithDictionary:[LogManager getSerLogEventDictWithType:HICCourseDetailClick]];
                [LogManager reportSerLogWithDict:report];
            }
            BOOL isCollectedAlready = NO;
            if (_isCollected) {
                self.isCollected = NO;
                btn.selected = NO;
                isCollectedAlready = YES;
            } else {
                self.isCollected = YES;
                isCollectedAlready = !btn.selected;
            }
            DDLogDebug(@"%@ %@Collection Btn clicked", logName, isCollectedAlready ? @"Cancel " : @"");
            [self collectionBtnClicked:isCollectedAlready];
        } else if (index == 2) { // 点赞
            btn.enabled = NO;
            if (btn.selected) {
                // 取消点赞
                btn.selected = NO;
                ///日志上报
                HICStudyLogReportModel *reportModel = [[HICStudyLogReportModel alloc]initWithType:HICCourseDetailClick];
                reportModel.mediaid = _kldId;
                reportModel.knowtype = _knowType;
                if (_btmType == 6) {
                    reportModel.mediatype = [NSNumber numberWithInteger:HICReportCourseType];
                }else{
                    reportModel.mediatype = [NSNumber numberWithInteger:HICReportKnowledgeType];
                }
                reportModel.buttonname = NSLocalizableString(@"cancelThumbUp", nil);
                NSMutableDictionary *report = [NSMutableDictionary dictionaryWithDictionary:[reportModel getParamDict]];
                [report setValuesForKeysWithDictionary:[LogManager getSerLogEventDictWithType:HICCourseDetailClick]];
                [LogManager reportSerLogWithDict:report];
            } else {
                // 点赞
                btn.selected = YES;
                ///日志上报
                HICStudyLogReportModel *reportModel = [[HICStudyLogReportModel alloc]initWithType:HICCourseDetailClick];
                reportModel.mediaid = _kldId;
                reportModel.knowtype = _knowType;
                if (_btmType == 6) {
                    reportModel.mediatype = [NSNumber numberWithInteger:HICReportCourseType];
                }else{
                    reportModel.mediatype = [NSNumber numberWithInteger:HICReportKnowledgeType];
                }
                reportModel.buttonname = NSLocalizableString(@"giveLike", nil);
                NSMutableDictionary *report = [NSMutableDictionary dictionaryWithDictionary:[reportModel getParamDict]];
                [report setValuesForKeysWithDictionary:[LogManager getSerLogEventDictWithType:HICCourseDetailClick]];
                [LogManager reportSerLogWithDict:report];
            }
            BOOL isThumbupAlready = NO;
            if (_isThumbup) {
                self.isThumbup = NO;
                btn.selected = NO;
                isThumbupAlready = YES;
            } else {
                self.isThumbup = YES;
                isThumbupAlready = !btn.selected;
            }
            DDLogDebug(@"%@ %@Thumbup Btn clicked", logName, isThumbupAlready ? @"Cancel " : @"");
            [self thumbupBtnClicked:isThumbupAlready button:btn];
        } else if (index == 3){ // 翻页or更多
            if (self.rightBtnArr.count > 4) {
                DDLogDebug(@"%@ Page Btn clicked", logName);
                if ([self.delegate respondsToSelector:@selector(pageBtnClick)]) {
                    [self.delegate pageBtnClick];
                }
                ///日志上报
                HICStudyLogReportModel *reportModel = [[HICStudyLogReportModel alloc]initWithType:HICCourseDetailClick];
                reportModel.mediaid = _kldId;
                reportModel.knowtype = _knowType;
                if (_btmType == 6) {
                    reportModel.mediatype = [NSNumber numberWithInteger:HICReportCourseType];
                }else{
                    reportModel.mediatype = [NSNumber numberWithInteger:HICReportKnowledgeType];
                }
                reportModel.buttonname = NSLocalizableString(@"turnPage", nil);
                NSMutableDictionary *report = [NSMutableDictionary dictionaryWithDictionary:[reportModel getParamDict]];
                [report setValuesForKeysWithDictionary:[LogManager getSerLogEventDictWithType:HICCourseDetailClick]];
                [LogManager reportSerLogWithDict:report];
            } else {
                DDLogDebug(@"%@ More Btn clicked", logName);
                if ([self.delegate respondsToSelector:@selector(moreBtnClick)]) {
                    [self.delegate moreBtnClick];
                }
                ///日志上报
                HICStudyLogReportModel *reportModel = [[HICStudyLogReportModel alloc]initWithType:HICCourseDetailClick];
                reportModel.mediaid = _kldId;
                reportModel.knowtype = _knowType;
                if (_btmType == 6) {
                    reportModel.mediatype = [NSNumber numberWithInteger:HICReportCourseType];
                }else{
                    reportModel.mediatype = [NSNumber numberWithInteger:HICReportKnowledgeType];
                }
                reportModel.buttonname = NSLocalizableString(@"more", nil);
                NSMutableDictionary *report = [NSMutableDictionary dictionaryWithDictionary:[reportModel getParamDict]];
                [report setValuesForKeysWithDictionary:[LogManager getSerLogEventDictWithType:HICCourseDetailClick]];
                [LogManager reportSerLogWithDict:report];
            }
            
        } else { // 更多
            DDLogDebug(@"%@ More Btn clicked", logName);
            if ([self.delegate respondsToSelector:@selector(moreBtnClick)]) {
                [self.delegate moreBtnClick];
            }
            ///日志上报
            HICStudyLogReportModel *reportModel = [[HICStudyLogReportModel alloc]initWithType:HICCourseDetailClick];
            reportModel.mediaid = _kldId;
            reportModel.knowtype = _knowType;
            if (_btmType == 6) {
                reportModel.mediatype = [NSNumber numberWithInteger:HICReportCourseType];
            }else{
                reportModel.mediatype = [NSNumber numberWithInteger:HICReportKnowledgeType];
            }
            reportModel.buttonname = NSLocalizableString(@"more", nil);
            NSMutableDictionary *report = [NSMutableDictionary dictionaryWithDictionary:[reportModel getParamDict]];
            [report setValuesForKeysWithDictionary:[LogManager getSerLogEventDictWithType:HICCourseDetailClick]];
            [LogManager reportSerLogWithDict:report];
        }
    }
}

- (void)collectionBtnClicked:(BOOL)selected {
    // 收藏
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    NSNumber *objectType = @(6);
    if (_btmType == HICStudyBtmViewKnowledge) {
        objectType = @(7);
    }
    [dic setValue:objectType forKey:@"objectType"];
    [dic setValue:_kldId ? _kldId : @(-1) forKey:@"objectId"];
    [dic setValue:@(1) forKey:@"terminalType"];
    NSNumber *action = @(1);
    if (selected) {
        action = @(2);
    }
    //    [dic setValue:action forKey:@"action"];
    [HICAPI collectionCourse:action dic:dic success:^(NSDictionary * _Nonnull responseObject) {
        if (selected) {
            self.collectionIV.image = [UIImage imageNamed:@"BT-收藏"];
            self.collectionLabel.text = NSLocalizableString(@"collection", nil);
            [HICToast showWithText:NSLocalizableString(@"cancelCollection", nil)];
        } else {
            self.collectionIV.image = [UIImage imageNamed:@"BT-已收藏"];
            self.collectionLabel.text = NSLocalizableString(@"collected", nil);
            [HICToast showWithText:NSLocalizableString(@"collectionSuccess", nil)];
        }
        if ([self.delegate respondsToSelector:@selector(collectionSuccess:)]) {
            [self.delegate collectionSuccess:YES];
        }
    } failure:^(NSError * _Nonnull error) {
        NSString *showText = NSLocalizableString(@"cancelCollectionFailed", nil);
        if (self.isCollected) {
            self.isCollected = NO;
            showText = NSLocalizableString(@"collectionFailed", nil);
        } else {
            self.isCollected = YES;
        }
        [HICToast showWithText:showText];
    }];
}

- (void)thumbupBtnClicked:(BOOL)selected button:(UIButton *)btn{
    // 点赞
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    NSNumber *objectType = @(6);
    if (_btmType == HICStudyBtmViewKnowledge) {
        objectType = @(7);
    }
    [dic setValue:objectType forKey:@"objectType"];
    [dic setValue:_kldId ? _kldId : @(-1) forKey:@"objectId"];
    [dic setValue:@(1) forKey:@"terminalType"];
    NSNumber *action = @(1);
    if (selected) {
        action = @(2);
    }

    [HICAPI thumbupCourse:action dic:dic success:^(NSDictionary * _Nonnull responseObject) {
        btn.enabled = YES;
        if (selected) {
            self.thumbupIV.image = [UIImage imageNamed:@"BT-点赞"];
            self.thumbupLabel.text = NSLocalizableString(@"giveLike", nil);
            [HICToast showWithText:NSLocalizableString(@"cancelThumbUp", nil)];
        } else {
            self.thumbupIV.image = [UIImage imageNamed:@"BT-已赞"];
            self.thumbupLabel.text = NSLocalizableString(@"hasBeenPraised", nil);
            NSString *toastStr = NSLocalizableString(@"thumbUpSuccess", nil);
            if (responseObject[@"data"] && [responseObject[@"data"] isKindOfClass:NSDictionary.class]) {
                NSNumber *points = responseObject[@"data"][@"points"];
                if (points && points.integerValue > 0) {
                    toastStr = [NSString stringWithFormat:@"%@，%@", toastStr, HICLocalizedFormatString(@"rewardPointsToast", points.integerValue)];
                }
            }
            [HICToast showWithText:toastStr];
        }
        if ([self.delegate respondsToSelector:@selector(thumbup:)]) {
            [self.delegate thumbup:!selected];
        }
    } failure:^(NSError * _Nonnull error) {
        btn.enabled = YES;
        NSString *showText = NSLocalizableString(@"cancelThumbUpFailed", nil);
        if (self.isThumbup) {
            self.isThumbup = NO;
            showText = NSLocalizableString(@"thumbUpFailure", nil);
        } else {
            self.isThumbup = YES;
        }
        [HICToast showWithText:showText];
    }];
}

@end
