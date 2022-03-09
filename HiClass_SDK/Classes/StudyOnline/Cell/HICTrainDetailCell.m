//
//  HICTrainDetailCell.m
//  HiClass
//
//  Created by WorkOffice on 2020/3/5.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICTrainDetailCell.h"

@interface HICTrainDetailCell ()
@property (nonatomic, strong)NSArray *courseList;
@property (nonatomic, strong)UILabel *chapterNameLabel;
@property (nonatomic, strong)UILabel *deadLineLabel;
@property (nonatomic, strong)UIButton *extensionbutton;
@property (nonatomic, strong)UIView *cellContent;
@property (nonatomic, strong)HICTrainDetailStageActionsModel *stageModel;
@property (nonatomic, strong)UIProgressView *progressView;
@property (nonatomic, strong)UILabel *progressLabel;
@property (nonatomic ,strong)UIView *leftView;
@property (nonatomic ,strong)UIImageView *leftImageView;
@property (nonatomic, strong)UILabel *nameLabel;
@property (nonatomic, strong)UILabel *scoreLabel;
@property (nonatomic, strong)UILabel *timeLabel;
@property (nonatomic, strong)UILabel *percentLabel;
@property (nonatomic, strong)UILabel *eTimelabel;
@property (nonatomic, strong)UILabel *examTimeslabel;
@property (nonatomic ,strong)UILabel *waitScorLabel;
@property (nonatomic ,strong)UIButton *scoreBtn;
@property (nonatomic, strong)NSIndexPath *cellIndexPath;
@property (nonatomic, assign)CGFloat cellheight;
@property (nonatomic,strong)NSNumber *sectionId;
@property (nonatomic ,strong)UIView *tapView;
@property (nonatomic ,strong)UIView *maskView;
@property (nonatomic, strong) UIButton *onGoingLabel;
@property (nonatomic ,assign)NSInteger isEnd;
@property (nonatomic ,strong)NSNumber *curTime;
@property (nonatomic ,strong)UILabel *handScoreLabel;
@end

@implementation HICTrainDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    [super awakeFromNib];
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
        self.backgroundColor = UIColor.whiteColor;
        self.courseList = [NSArray new];
        [self updateConstraintsIfNeeded];
    }
    return self;
}
- (void)createUI{
    self.chapterNameLabel = [[UILabel alloc]init];
    self.chapterNameLabel.textColor = TEXT_COLOR_DARK;
    self.chapterNameLabel.font = FONT_REGULAR_16;
    self.chapterNameLabel.numberOfLines = 1;
    self.chapterNameLabel.lineBreakMode = NSLineBreakByTruncatingTail |NSLineBreakByWordWrapping;
    [self.contentView addSubview:self.chapterNameLabel];
    
    self.deadLineLabel = [[UILabel alloc]init];
    self.deadLineLabel.textColor = TEXT_COLOR_LIGHTM;
    self.deadLineLabel.font = FONT_REGULAR_14;
    [self.contentView addSubview:self.deadLineLabel];
    
    UIImage * btnImageup = [UIImage imageNamed:@"箭头-章节收起"];
    UIImage * btnImagedown = [UIImage imageNamed:@"箭头-章节展开"];
    self.extensionbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.extensionbutton setImage:btnImagedown forState:UIControlStateNormal];
    [self.extensionbutton setImage:btnImageup forState:UIControlStateSelected];
    [self.extensionbutton addTarget:self action:@selector(btnClickExtension) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.extensionbutton];
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 69.5, HIC_ScreenWidth, 0.5)];
    line.backgroundColor = BACKGROUNG_COLOR;
    [self.contentView addSubview:line];
    self.maskView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, HIC_ScreenWidth, 70)];
    self.maskView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(btnClickExtension)];
    //    self.maskView.backgroundColor = [UIColor redColor];
    [self.maskView addGestureRecognizer:tap];
    [self.contentView addSubview:self.maskView];
    self.cellContent = [[UIView alloc]init];
    [self.contentView addSubview:self.cellContent];
}

- (void)setModel:(HICTrainDetailListModel *)model {
    _model = model;
    self.chapterNameLabel.text = model.stageName;
    self.sectionId = model.stageId;
    self.isEnd = model.trainTerminated;
    self.curTime = model.curTime;
    if (!self.isPushMap) {
        if ([model.stageEndTime integerValue] < [model.curTime integerValue] && model.stageEndTime.integerValue != -1 && model.completedTaskNum < model.taskNum) {
            self.deadLineLabel.text = NSLocalizableString(@"timeoutWarning", nil);
            self.deadLineLabel.textColor = [UIColor colorWithHexString:@"#FF8500"];
        }else if (model.stageEndTime.integerValue == -1) {
            self.deadLineLabel.text = [NSString stringWithFormat:@"%@：%@",NSLocalizableString(@"dendline", nil),NSLocalizableString(@"unlimited", nil)];
            self.deadLineLabel.textColor = TEXT_COLOR_LIGHTM;
        } else{
            self.deadLineLabel.text = [NSString stringWithFormat:@"%@：%@", NSLocalizableString(@"dendline", nil),[HICCommonUtils timeStampToReadableDate:model.stageEndTime isSecs:YES format:@"MM-dd"]];
            self.deadLineLabel.textColor = TEXT_COLOR_LIGHTM;
        }
    }
    
    if (self.contentView.subviews.count > 0) {
        [self.cellContent.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    self.courseList = [NSArray arrayWithArray:model.stageActionList];
    [self addCellView];
}
- (void)setIsShowContent:(BOOL)isShowContent{
    self.cellContent.hidden = !isShowContent;
    self.extensionbutton.selected = isShowContent;
}
- (void)addCellView{
    self.cellContent.frame = CGRectMake(0, 70, HIC_ScreenWidth, self.courseList.count > 0 ?88 *self.courseList.count + 16:0);
    self.cellContent.hidden = YES;
    self.cellContent.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    for (int i = 0; i < self.courseList.count; i ++) {
        self.stageModel = [HICTrainDetailStageActionsModel mj_objectWithKeyValues:self.courseList[i]];
        //任务对应的类型, e.g. 1:考试, 2:课程, 3:知识, 4:问卷，5:作业",
        [self createCellView:i withModel:self.stageModel];
    }
}
- (void)createCellView:(NSInteger)index withModel:(HICTrainDetailStageActionsModel *)model{
    UIView * cellContentView = [[UIView alloc]initWithFrame:CGRectMake(0,88 *index, HIC_ScreenWidth, 88)];
    [self.cellContent addSubview:cellContentView];
    self.tapView = [[UIView alloc]initWithFrame:CGRectMake(0, 88 *index, HIC_ScreenWidth, 88)];
    self.tapView.tag = index;
    [self.cellContent addSubview:self.tapView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(contentViewClick:)];
    [self.tapView addGestureRecognizer:tap];
    
    self.leftView = [[UIView alloc]init];
    self.leftView.backgroundColor = [UIColor whiteColor];
    [cellContentView addSubview:self.leftView];
    [self.leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cellContentView).offset(16);
        make.top.equalTo(cellContentView).offset(16);
        make.width.offset(72);
        make.height.offset(72);
    }];
    self.leftImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:model.classPicUrl]];
    [self.leftView addSubview:self.leftImageView];
    [self.leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftView).offset(16);
        make.top.equalTo(self.leftView).offset(16);
        make.width.offset(40);
        make.height.offset(40);
    }];
    
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.textColor = TEXT_COLOR_DARK;
    self.nameLabel.font = FONT_REGULAR_15;
    self.nameLabel.numberOfLines = 1;
    self.nameLabel.text = model.taskName;
    self.nameLabel.lineBreakMode = NSLineBreakByTruncatingTail |NSLineBreakByWordWrapping;
    [cellContentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftView.mas_right).offset(12);
        make.top.equalTo(self.leftView);
        make.width.offset(259);
        make.height.offset(21);
    }];
    if (model.taskType == HICCourseType|| model.taskType == HICKonwledeType) {
        self.scoreLabel = [[UILabel alloc]init];
        self.scoreLabel.textColor = TEXT_COLOR_LIGHTM;
        self.scoreLabel.font = FONT_REGULAR_13;
        self.scoreLabel.text = [NSString stringWithFormat:@"%@:%@/%@",NSLocalizableString(@"credits", nil),[HICCommonUtils formatFloat:model.completedCredit],[HICCommonUtils formatFloat:model.totalCredit]];
        [cellContentView addSubview:self.scoreLabel];
        [self.scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nameLabel.mas_bottom).offset(4);
            make.left.equalTo(self.nameLabel);
//            make.width.offset(100);
            make.height.offset(18);
        }];
        self.timeLabel = [[UILabel alloc]init];
        self.timeLabel.textColor = TEXT_COLOR_LIGHTM;
        self.timeLabel.font = FONT_REGULAR_13;
        self.timeLabel.text = [NSString stringWithFormat:@"%@:%ld/%ld",NSLocalizableString(@"studyTime", nil),(long)model.completedCreditHours, (long)model.totalCreditHours];
        [cellContentView addSubview:self.timeLabel];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nameLabel.mas_bottom).offset(4);
            make.left.equalTo(self.scoreLabel.mas_right).offset(12);
            make.height.offset(18);
        }];
        self.progressView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
        self.progressView.progress = model.progress / 100;
        self.progressView.progressTintColor = [UIColor colorWithHexString:@"#00BED7"];
        [cellContentView addSubview:self.progressView];
        [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel);
            make.top.equalTo(self.scoreLabel.mas_bottom).offset(17.5);
            make.height.offset(5);
            make.width.offset(72);
        }];
        self.progressLabel = [[UILabel alloc]init];
        self.progressLabel.textColor = TEXT_COLOR_LIGHTM;
        self.progressLabel.font = FONT_REGULAR_13;
        self.progressView.layer.cornerRadius = 2.5;
        self.progressView.clipsToBounds = YES;
        [cellContentView addSubview:self.progressLabel];
        [self.progressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.progressView.mas_right).offset(6);
            make.top.equalTo(self.timeLabel.mas_bottom).offset(11.5);
            make.width.offset(100);
            make.height.offset(20);
        }];
        self.progressLabel.text = [NSString stringWithFormat:@"%@%@",[HICCommonUtils formatFloat:model.progress],@"%"];
        
    }else if (model.taskType == HICExamType){
        self.eTimelabel = [[UILabel alloc]init];
        self.eTimelabel.textColor = TEXT_COLOR_LIGHTM;
        self.eTimelabel.font = FONT_REGULAR_13;
        self.eTimelabel.text = [NSString stringWithFormat:@"%@: %@",NSLocalizableString(@"startTextTime", nil),[HICCommonUtils returnReadableTimeZoneWithStartTime:model.startTime andEndTime:model.endTime]];
        [cellContentView addSubview:self.eTimelabel];
        [self.eTimelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel);
            make.right.equalTo(cellContentView).offset(-16);
            make.top.equalTo(self.nameLabel.mas_bottom).offset(14);
        }];
        self.examTimeslabel = [[UILabel alloc]init];
        self.examTimeslabel.textColor = TEXT_COLOR_LIGHTM;
        self.examTimeslabel.font = FONT_REGULAR_13;
        if ([NSString isValidStr:[NSString stringWithFormat:@"%ld",(long)model.examAvaiNum]]) {
            self.examTimeslabel.text = [NSString stringWithFormat:@"%@: %ld",NSLocalizableString(@"numberOfTestsAvailable", nil),(long)model.examAvaiNum];
        }else{
            self.examTimeslabel.text = NSLocalizableString(@"notLimit", nil);
        }
        [cellContentView addSubview:self.examTimeslabel];
        [self.examTimeslabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.eTimelabel.mas_bottom);
            make.left.equalTo(self.eTimelabel);
        }];
    }else {
        self.eTimelabel = [[UILabel alloc]init];
        self.eTimelabel.textColor = TEXT_COLOR_LIGHTM;
        self.eTimelabel.font = FONT_REGULAR_13;
        [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.leftView).offset(10);
        }];
        if(model.taskType == HICHomeWorkType){
            self.eTimelabel.text = [NSString stringWithFormat:@"%@: %@",NSLocalizableString(@"homeworkTime", nil),[HICCommonUtils returnReadableTimeZoneWithStartTime:model.startTime andEndTime:model.endTime]];
        }else if(model.taskType == HICQuestionType){
            self.eTimelabel.text = [NSString stringWithFormat:@"%@: %@",NSLocalizableString(@"theQuestionnaireOfTime", nil),[HICCommonUtils returnReadableTimeZoneWithStartTime:model.startTime andEndTime:model.endTime]];
        }else if (model.taskType == HICOfflineGradeType){
            if (model.offResultStatus == 0) {
                self.eTimelabel.text = [NSString stringWithFormat:@"%@:--",NSLocalizableString(@"offlineResults", nil)];
            }else{
                UIImageView *scoreEvalView = [[UIImageView alloc]initWithFrame:CGRectMake(HIC_ScreenWidth - 88, 8, 72, 72)];
                [cellContentView addSubview:scoreEvalView];
                                   if (model.offResultPass == 0) {
                                       scoreEvalView.image = [UIImage imageNamed:@"印章-不合格"];
                                   }else{
                                       scoreEvalView.image = [UIImage imageNamed:@"分数印章"];
                                   }
                if (model.offResultEvalType == 2) {
                    self.eTimelabel.text = [NSString stringWithFormat:@"%@:--",NSLocalizableString(@"offlineResults", nil)];;
                }else{
                    self.eTimelabel.text = [NSString stringWithFormat:@"%@:%@",NSLocalizableString(@"offlineResults", nil),[HICCommonUtils formatFloat:model.offResultScore]];
                }
            }
        }else if(model.taskType == HICOfflineTaskAppraise){
            self.eTimelabel.text = [NSString stringWithFormat:@"%@: %@",NSLocalizableString(@"evaluationTime", nil),[HICCommonUtils returnReadableTimeZoneWithStartTime:model.startTime andEndTime:model.endTime]];
        }else if (model.taskType == HICHandsOn){
//            self.eTimelabel.text = [NSString stringWithFormat:@"得分: %@",[HICCommonUtils formatFloat:model.score]];
//            if (model.passFlag == 0) {//不合格
//                self.eTimelabel.textColor = [UIColor colorWithHexString:@"#FF4B4B"];
//            }else{
//                 self.eTimelabel.textColor = [UIColor colorWithHexString:@"#00BED7"];
//            }
        }
        
        [cellContentView addSubview:self.eTimelabel];
        [self.eTimelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel);
            make.right.equalTo(cellContentView).offset(-16);
            make.top.equalTo(self.nameLabel.mas_bottom).offset(6);
        }];
    }
    
    if(self.stageModel.taskType == HICKonwledeType){
        if (self.stageModel.resourceType == HICAudioType) {
            self.leftImageView.image = [UIImage imageNamed:@"知识类型-音频"];
        } else if (self.stageModel.resourceType == HICHtmlType) {
            self.leftImageView.image = [UIImage imageNamed:@"知识类型-文档-HTML"];
        } else if(self.stageModel.resourceType == HICScromType) {
            self.leftImageView.image = [UIImage imageNamed:@"知识类型-文档-scorm"];
        } else if (self.stageModel.resourceType == HICZipType) {
            self.leftImageView.image = [UIImage imageNamed:@"知识类型-压缩包"];
        } else if(self.stageModel.resourceType == HICVideoType) {
            self.leftImageView.image = [UIImage imageNamed:@"知识类型-视频"];
        } else if(self.stageModel.resourceType == HICPictureType) {
            self.leftImageView.image = [UIImage imageNamed:@"知识类型-图片"];
        } else if (self.stageModel.resourceType == HICWebVideoType) {
            self.leftImageView.image = [UIImage imageNamed:@"知识课程默认图标"];
        } else {//文档
            if ([self.stageModel.docType isEqualToString:@"xls"] || [self.stageModel.docType isEqualToString:@"xlsx"]) {
                self.leftImageView.image = [UIImage imageNamed:@"知识类型-文档-XLS"];
            }else if ([self.stageModel.docType isEqualToString:@"doc"] || [self.stageModel.docType isEqualToString:@"docx"]){
                self.leftImageView.image = [UIImage imageNamed:@"知识类型-文档-WORD"];
            }else if ([self.stageModel.docType isEqualToString:@"ppt"] || [self.stageModel.docType isEqualToString:@"pptx"]){
                self.leftImageView.image = [UIImage imageNamed:@"知识类型-文档-PPT"];
            } else if ([self.stageModel.docType isEqualToString:@"pdf"] ||[self.stageModel.docType isEqualToString:@"PDF"]){
                self.leftImageView.image = [UIImage imageNamed:@"知识类型-文档-PDF"];
            }else if ([self.stageModel.docType.lowercaseString isEqualToString:@"pps"]){
                self.leftImageView.image = [UIImage imageNamed:@"知识类型-文档-PPS"];
            } else {
                self.leftImageView.image = [UIImage imageNamed:@"知识课程默认图标"];
            }
        }
    }else if (self.stageModel.taskType == HICExamType){
        UIButton *onGoingLabel = [UIButton buttonWithType:UIButtonTypeCustom];
        [onGoingLabel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        onGoingLabel.titleLabel.font = FONT_MEDIUM_9;
        onGoingLabel.frame = CGRectMake(0, 0, 31, 12);
        [HICCommonUtils setRoundingCornersWithView:onGoingLabel TopLeft:NO TopRight:NO bottomLeft:NO bottomRight:YES cornerRadius:4];
        if (self.stageModel.examStatus == HICExamWait) {
            [self.leftView addSubview:onGoingLabel];
            [HICCommonUtils setLabel:onGoingLabel andTitle:NSLocalizableString(@"waitTest", nil) andStartColor:@"#FFC76C" andEndColor:@"#FFB843"];
        }else if(self.stageModel.examStatus == HICExamMark){
            [self.leftView addSubview:onGoingLabel];
            [HICCommonUtils setLabel:onGoingLabel andTitle:NSLocalizableString(@"reviewing", nil) andStartColor:@"#30CFFF" andEndColor:@"#2C87F2"];
        }else if(self.stageModel.examStatus == HICExamProgress){
            [self.leftView addSubview:onGoingLabel];
            [HICCommonUtils setLabel:onGoingLabel andTitle:NSLocalizableString(@"ongoing", nil) andStartColor:@"#FF6F00" andEndColor:@"#FF9624"];
        }else if(self.stageModel.examStatus == HICExamFinish){
            [self.leftView addSubview:onGoingLabel];
            [onGoingLabel setTitle:NSLocalizableString(@"hasBeenCompleted", nil) forState:UIControlStateNormal];
            onGoingLabel.backgroundColor = [UIColor colorWithHexString:@"#D0D0D0"];
        }else{//缺考
            [onGoingLabel removeFromSuperview];
        }
        self.leftImageView.image = [UIImage imageNamed:@"知识类型-考试"];
        
    }else if (self.stageModel.taskType == HICHomeWorkType){
         UIButton *onGoingLabel = [UIButton buttonWithType:UIButtonTypeCustom];
               [onGoingLabel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
               onGoingLabel.titleLabel.font = FONT_MEDIUM_9;
               onGoingLabel.frame = CGRectMake(0, 0, 31, 12);
        [HICCommonUtils setRoundingCornersWithView:onGoingLabel TopLeft:NO TopRight:NO bottomLeft:NO bottomRight:YES cornerRadius:4];
        self.leftImageView.image = [UIImage imageNamed:@"知识类型-作业"];
        //            if (self.stageModel.examStatus == ) {
        //                [self.leftView addSubview:self.onGoingLabel];
        //                  [HICCommonUtils setLabel:self.onGoingLabel andTitle:@"未开始" andStartColor:@"#FFC76C" andEndColor:@"#FFB843"];
        //              }else
        if( self.stageModel.workStatus == HICWorkWait){
            [self.leftView addSubview:onGoingLabel];
             [HICCommonUtils setLabel:onGoingLabel andTitle:NSLocalizableString(@"notStarted", nil) andStartColor:@"#FFC76C" andEndColor:@"#FFB843"];
        }else if( self.stageModel.workStatus == HICWorkMarking){
            [self.leftView addSubview:onGoingLabel];
            [HICCommonUtils setLabel:onGoingLabel andTitle:NSLocalizableString(@"reviewing", nil) andStartColor:@"#30CFFF" andEndColor:@"#2C87F2"];
        }else if(self.stageModel.workStatus == HICDoHomeWork){
            [self.leftView addSubview:onGoingLabel];
            [HICCommonUtils setLabel:onGoingLabel andTitle:NSLocalizableString(@"ongoing", nil) andStartColor:@"#FF6F00" andEndColor:@"#FF9624"];
        }else if(self.stageModel.workStatus == HICWorkFinish){
            [self.leftView addSubview:onGoingLabel];
            [onGoingLabel setTitle:NSLocalizableString(@"hasBeenCompleted", nil) forState:UIControlStateNormal];
            onGoingLabel.backgroundColor = [UIColor colorWithHexString:@"#D0D0D0"];
        }else if (self.stageModel.workStatus == HICWorkWaitMark){
            [self.leftView addSubview:onGoingLabel];
            [HICCommonUtils setLabel:onGoingLabel andTitle:NSLocalizableString(@"waitExamines", nil) andStartColor:@"#30CFFF" andEndColor:@"#00B5E5"];
        }else{
            [onGoingLabel removeFromSuperview];
        }
        
    }else if(self.stageModel.taskType == HICCourseType){
        self.leftImageView.image = [UIImage imageNamed:@"知识课程默认图标"];
    }else if(self.stageModel.taskType == HICOfflineGradeType){
        self.leftImageView.image = [UIImage imageNamed:@"成绩"];
        UIButton *onGoingLabel = [UIButton buttonWithType:UIButtonTypeCustom];
        [onGoingLabel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        onGoingLabel.titleLabel.font = FONT_MEDIUM_9;
        onGoingLabel.frame = CGRectMake(0, 0, 31, 12);
        [HICCommonUtils setRoundingCornersWithView:onGoingLabel TopLeft:NO TopRight:NO bottomLeft:NO bottomRight:YES cornerRadius:4];
        [self.leftView addSubview:onGoingLabel];
        if (model.offResultStatus == 0) {
            [HICCommonUtils setLabel:onGoingLabel andTitle:NSLocalizableString(@"notStarted", nil) andStartColor:@"#FFC76C" andEndColor:@"#FFB843"];
        }else{
            [onGoingLabel setTitle:NSLocalizableString(@"hasBeenCompleted", nil) forState:UIControlStateNormal];
            onGoingLabel.backgroundColor = [UIColor colorWithHexString:@"#D0D0D0"];
        }
    }
    else if (self.stageModel.taskType == HICQuestionType || self.stageModel.taskType == HICAppraiseType){//
        UIButton *onGoingLabel = [UIButton buttonWithType:UIButtonTypeCustom];
        [onGoingLabel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        onGoingLabel.titleLabel.font = FONT_MEDIUM_9;
        onGoingLabel.frame = CGRectMake(0, 0, 31, 12);
        [HICCommonUtils setRoundingCornersWithView:onGoingLabel TopLeft:NO TopRight:NO bottomLeft:NO bottomRight:YES cornerRadius:4];
        self.leftImageView.image = [UIImage imageNamed:@"知识类型-问卷"];
        if ([self.stageModel.commitTime isEqualToNumber:@0]) {
            if (self.curTime.integerValue < self.stageModel.startTime.integerValue) {
                [self.leftView addSubview:onGoingLabel];
                [HICCommonUtils setLabel:onGoingLabel andTitle:NSLocalizableString(@"notStarted", nil) andStartColor:@"#FFC76C" andEndColor:@"#FFB843"];
            }else if (self.curTime.integerValue > self.stageModel.endTime.integerValue && self.stageModel.endTime.integerValue != 0){
                [self.leftView addSubview:onGoingLabel];
                [onGoingLabel setTitle:NSLocalizableString(@"expired", nil) forState:UIControlStateNormal];
                onGoingLabel.backgroundColor = [UIColor colorWithHexString:@"#D0D0D0"];
            }else {
                [self.leftView addSubview:onGoingLabel];
                [HICCommonUtils setLabel:onGoingLabel andTitle:NSLocalizableString(@"ongoing", nil) andStartColor:@"#FF6F00" andEndColor:@"#FF9624"];
            }
        } else {
            [self.leftView addSubview:onGoingLabel];
            [onGoingLabel setTitle:NSLocalizableString(@"hasBeenCompleted", nil) forState:UIControlStateNormal];
            self.eTimelabel.text = [NSString stringWithFormat:@"%@:%@",NSLocalizableString(@"submitTime", nil),[HICCommonUtils timeStampToReadableDate:self.stageModel.commitTime isSecs:YES format:@"MM-dd HH:mm"]];
            onGoingLabel.backgroundColor = [UIColor colorWithHexString:@"#D0D0D0"];
        }
    } else if(self.stageModel.taskType == HICHandsOn) {//实操
            self.leftImageView.image = [UIImage imageNamed:@"实操"];
            self.scoreBtn = [[UIButton alloc]init];
            [cellContentView addSubview:self.scoreBtn];
            self.scoreBtn.titleLabel.font = FONT_REGULAR_15;
            [self.scoreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.nameLabel.mas_bottom).offset(10);
                make.width.offset(95);
                make.height.offset(32);
                make.left.equalTo(self.nameLabel);
            }];
            [self.scoreBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
            [self.scoreBtn addGradientLayer:CGPointZero endPoint:CGPointMake(1, 0) colors:@[(__bridge id)[UIColor colorWithHexString:@"#00E2D8"].CGColor, (__bridge id)[UIColor colorWithHexString:@"#00C5E0"].CGColor]];
                _scoreBtn.layer.cornerRadius = 4;
                _scoreBtn.layer.masksToBounds = YES;
            self.scoreBtn.tag = _tapView.tag;
            [_tapView removeFromSuperview];
            [self.scoreBtn addTarget:self action:@selector(handOnClick:) forControlEvents:UIControlEventTouchUpInside];
            if ([model.status isEqualToString:@"0"]) {//0-未申请 1-已申请  2-已提交",
                [self.scoreBtn setTitle:NSLocalizableString(@"toApplyGrade", nil) forState:UIControlStateNormal];
                [self.eTimelabel removeFromSuperview];
            }else if ([model.status isEqualToString:@"1"]){
                [self.scoreBtn removeFromSuperview];
                self.waitScorLabel = [[UILabel alloc]init];
                [cellContentView addSubview:self.waitScorLabel];
                [self.waitScorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.leftImageView).offset(10);
                    make.width.offset(45);
                    make.height.offset(21);
                    make.right.equalTo(cellContentView).offset(-41);
                }];
                self.waitScorLabel.font = FONT_MEDIUM_15;
                self.waitScorLabel.text = NSLocalizableString(@"waitApplyGrade", nil);
                self.waitScorLabel.textColor = TEXT_COLOR_LIGHTS;
                [self.eTimelabel removeFromSuperview];
            }else {
                [self.eTimelabel removeFromSuperview];
                [self.scoreBtn setTitle:NSLocalizableString(@"checkScoreSheet", nil) forState:UIControlStateNormal];
                self.handScoreLabel = [[UILabel alloc]init];
                self.handScoreLabel.text = [NSString stringWithFormat:@"%@: %@",NSLocalizableString(@"getScore", nil),[HICCommonUtils formatFloat:model.score]];
                if (model.passFlag == 0) {//不合格
                    self.handScoreLabel.textColor = [UIColor colorWithHexString:@"#FF4B4B"];
                }else{
                     self.handScoreLabel.textColor = [UIColor colorWithHexString:@"#00BED7"];
                }
                [cellContentView addSubview:self.handScoreLabel];
                self.handScoreLabel.font = FONT_REGULAR_15;
                [self.handScoreLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.offset(70);
                    make.top.equalTo(self.nameLabel.mas_bottom).offset(15);
                    make.right.equalTo(cellContentView).offset(-20);
                }];
            }

        }

}

- (void)updateConstraints {
    [super updateConstraints];
    [self.chapterNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(12);
        make.left.equalTo(self.contentView).offset(16);
        make.width.offset(272);
        make.height.offset(22.5);
    }];
    [self.deadLineLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.chapterNameLabel.mas_bottom).offset(4);
        make.left.equalTo(self.contentView).offset(16);
    }];
    
    [self.extensionbutton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(23);
        make.right.equalTo(self.contentView).offset(-20);
        make.width.offset(22);
        make.height.offset(22);
    }];
}
- (void)btnClickExtension{
    self.extensionbutton.selected = !self.extensionbutton.selected;
    self.cellContent.hidden = !self.extensionbutton.selected;
    if (self.extensionDelegate && [self.extensionDelegate respondsToSelector:@selector(clickExtension:andIndex:andIsShowContent:)]) {
        if (self.cellContent.hidden) {
            [self.extensionDelegate clickExtension:70 andIndex:_indexPath.row andIsShowContent:NO];
        }else{
            [self.extensionDelegate clickExtension:self.courseList.count > 0 ?88*self.courseList.count + 70 + 16:70 andIndex:_indexPath.row andIsShowContent:YES];
        }
    }
}
- (void)contentViewClick:(UITapGestureRecognizer *)tap{
    NSInteger index = tap.view.tag;
    if (_model.isOrder) {
        if (_model.completedTaskNum < index) {
            [HICToast showWithText:NSLocalizableString(@"learnInOrder", nil)];
            return;
        }
    }
    if (self.extensionDelegate && [self.extensionDelegate respondsToSelector:@selector(jumpKonwledge:andSectionId:andIsEnd:andIsStart:andIndx:)]) {
        HICTrainDetailStageActionsModel *model = [HICTrainDetailStageActionsModel mj_objectWithKeyValues:self.courseList[index]];
        [self.extensionDelegate jumpKonwledge:model andSectionId:self.sectionId andIsEnd:self.isEnd andIsStart:_model.curTime.integerValue andIndx:_indexPath.row];
    }
}
- (void)handOnClick:(UIButton *)btn{
    HICTrainDetailStageActionsModel *model = [HICTrainDetailStageActionsModel mj_objectWithKeyValues:self.courseList[btn.tag]];
    if ([btn.titleLabel.text isEqualToString:NSLocalizableString(@"toApplyGrade", nil)]) {
        if (self.extensionDelegate && [self.extensionDelegate respondsToSelector:@selector(clickScoreBtnWithType:andTaskId:)]) {
            [self.extensionDelegate clickScoreBtnWithType:1 andTaskId:model.taskId];
        }
    }else{
        if (self.extensionDelegate && [self.extensionDelegate respondsToSelector:@selector(clickScoreBtnWithType:andTaskId:)]) {
            [self.extensionDelegate clickScoreBtnWithType:2 andTaskId:model.taskId];
        }
    }
}
@end
