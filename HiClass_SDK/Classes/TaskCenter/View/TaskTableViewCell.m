//
//  TaskTableViewCell.m
//  HiClass
//
//  Created by Eddie Ma on 2020/1/17.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "TaskTableViewCell.h"

@interface TaskTableViewCell ()

@property (nonatomic, strong) UILabel *taskSectionLable;
@property (nonatomic, strong) UILabel *taskFinishStatusLabel; // 考试状态
@property (nonatomic, strong) UILabel *taskTitleLabel; // 考试题目
@property (nonatomic, strong) UILabel *taskTimeLabel; // 考试时间
@property (nonatomic, strong) UILabel *taskDurationLabel; // 考试时长
@property (nonatomic, strong) UILabel *taskPassScoreLabel; // 考试通过分数
@property (nonatomic, strong) UILabel *taskTimesLabel; // 考试次数
@property (nonatomic, strong) UILabel *taskAssignerLabel; // 考试指派人
@property (nonatomic, strong) UILabel *taskGradeTitleLabel; // 考试成绩

@property (nonatomic, strong) UIView *dividedLine1;
@property (nonatomic, strong) UIView *dividedLine2;
@property (nonatomic, strong) UIImageView *passIV;

@end

@implementation TaskTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self creatUI];
    }
    return self;
}

- (void)creatUI {
    self.backgroundColor = GRAY_BACKGROUND;

    self.taskSectionLable = [[UILabel alloc] initWithFrame:CGRectMake(42, 20, 0, 0)];
    self.taskSectionLable.textColor = [UIColor colorWithRed:133/255.0 green:133/255.0 blue:133/255.0 alpha:1/1.0];
    self.taskSectionLable.font = FONT_MEDIUM_14;
    [self.contentView addSubview:self.taskSectionLable];

    self.taskContentView = [[UIView alloc] init];
    self.taskContentView.backgroundColor = [UIColor whiteColor];
    self.taskContentView.layer.masksToBounds = YES;
    self.taskContentView.layer.cornerRadius = 4.0;
    [self.contentView addSubview:self.taskContentView];

    // 考试状态
    self.taskFinishStatusLabel = [[UILabel alloc] initWithFrame:CGRectMake(42, 20, 0, 0)];
    self.taskFinishStatusLabel.textColor =  [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1/1.0];
    self.taskFinishStatusLabel.font = FONT_MEDIUM_15;
    [self.taskContentView addSubview:self.taskFinishStatusLabel];

    // 考试题目
    self.taskTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(42, 20, 0, 0)];
    self.taskTitleLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    self.taskTitleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.taskTitleLabel.numberOfLines = 2;
    self.taskTitleLabel.font = FONT_MEDIUM_17;
    [self.taskContentView addSubview:self.taskTitleLabel];

    // 考试时间
    self.taskTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(42, 20, 0, 0)];
    self.taskTimeLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    self.taskTimeLabel.font = FONT_REGULAR_15;
    [self.taskContentView addSubview:self.taskTimeLabel];

    // 考试时长
    self.taskDurationLabel = [[UILabel alloc] initWithFrame:CGRectMake(42, 20, 0, 0)];
    self.taskDurationLabel.textColor = [UIColor colorWithRed:133/255.0 green:133/255.0 blue:133/255.0 alpha:1/1.0];
    self.taskDurationLabel.font = FONT_REGULAR_14;
    [self.taskContentView addSubview:self.taskDurationLabel];

    // 考试通过分数
    self.taskPassScoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(42, 20, 0, 0)];
    self.taskPassScoreLabel.textColor = [UIColor colorWithRed:133/255.0 green:133/255.0 blue:133/255.0 alpha:1/1.0];
    self.taskPassScoreLabel.font = FONT_REGULAR_14;
    [self.taskContentView addSubview:self.taskPassScoreLabel];

    // 考试次数
    self.taskTimesLabel = [[UILabel alloc] initWithFrame:CGRectMake(42, 20, 0, 0)];
    self.taskTimesLabel.textColor = [UIColor colorWithRed:133/255.0 green:133/255.0 blue:133/255.0 alpha:1/1.0];
    self.taskTimesLabel.font = FONT_REGULAR_14;
    [self.taskContentView addSubview:self.taskTimesLabel];

    // 考试指派人
    self.taskAssignerLabel = [[UILabel alloc] initWithFrame:CGRectMake(42, 20, 0, 0)];
    self.taskAssignerLabel.textColor = [UIColor colorWithRed:133/255.0 green:133/255.0 blue:133/255.0 alpha:1/1.0];
    self.taskAssignerLabel.font = FONT_REGULAR_14;
    [self.taskContentView addSubview:self.taskAssignerLabel];

    // 考试成绩
    self.taskGradeTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(42, 20, 0, 0)];
    self.taskGradeTitleLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    self.taskGradeTitleLabel.font = FONT_MEDIUM_16;
    self.taskGradeTitleLabel.hidden = YES;
    [self.taskContentView addSubview:self.taskGradeTitleLabel];

    // 考试是否通过
    self.passIV = [[UIImageView alloc] init];
    self.passIV.hidden = YES;
    [self.taskContentView addSubview:self.passIV];

    self.dividedLine1 = [[UIView alloc] init];
    self.dividedLine1.backgroundColor =  [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1/1.0];
    [self.taskContentView addSubview:self.dividedLine1];

    self.dividedLine2 = [[UIView alloc] init];
    self.dividedLine2.hidden = YES;
    self.dividedLine2.backgroundColor =  [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1/1.0];
    [self.taskContentView addSubview:self.dividedLine2];
}

- (void)setDataWith:(HICTestModel *)model sectionName:(NSString *)sectionName isFirstModel:(BOOL)isFirstModel {
    CGFloat taskSectionLableWidth = 0.0;
    CGFloat taskSectionLableHeight = -20.0;
    CGFloat contentViewWidh = HIC_ScreenWidth - 42 -12;
    if ([NSString isValidStr:sectionName]) {
        self.taskSectionLable.text = sectionName;
        taskSectionLableWidth = [HICCommonUtils sizeOfString:sectionName stringWidthBounding:HIC_ScreenWidth font:14 stringOnBtn:NO fontIsRegular:NO].width;
        taskSectionLableHeight = [HICCommonUtils sizeOfString:sectionName stringWidthBounding:HIC_ScreenWidth font:14 stringOnBtn:NO fontIsRegular:NO].height;
    } else {
        self.taskSectionLable.text = @"";
    }
    if ([NSString isValidStr:sectionName] && [sectionName containsString:NSLocalizableString(@"todayDay", nil)]) {
        self.taskSectionLable.textColor = [UIColor colorWithRed:255/255.0 green:133/255.0 blue:0/255.0 alpha:1/1.0];
    } else {
        self.taskSectionLable.textColor = [UIColor colorWithRed:133/255.0 green:133/255.0 blue:133/255.0 alpha:1/1.0];
    }
    self.taskSectionLable.frame = CGRectMake(42, 20, taskSectionLableWidth, taskSectionLableHeight);
    [self.taskSectionLable sizeToFit];

    self.taskFinishStatusLabel.text = model.start;
    CGFloat y = 12;
    CGFloat taskFinishStatusLabelWidth = [HICCommonUtils sizeOfString:self.taskFinishStatusLabel.text stringWidthBounding:HIC_ScreenWidth font:15 stringOnBtn:NO fontIsRegular:NO].width;
    CGFloat taskFinishStatusLabelHeight = [HICCommonUtils sizeOfString:self.taskFinishStatusLabel.text stringWidthBounding:HIC_ScreenWidth font:15 stringOnBtn:NO fontIsRegular:NO].height;
    self.taskFinishStatusLabel.frame = CGRectMake(16, y, taskFinishStatusLabelWidth, taskFinishStatusLabelHeight);

    // 考试tag设置
    UILabel *taskTagLabel = [[UILabel alloc] init];
    taskTagLabel.font = FONT_MEDIUM_12;
    taskTagLabel.textAlignment = NSTextAlignmentCenter;
    CGFloat taskTagLabelHeight = [HICCommonUtils sizeOfString:model.tag stringWidthBounding:HIC_ScreenWidth font:12 stringOnBtn:NO fontIsRegular:NO].height;
    CGFloat taskTagLabelWidth = [HICCommonUtils sizeOfString:model.tag stringWidthBounding:HIC_ScreenWidth font:12 stringOnBtn:NO fontIsRegular:NO].width;

    // 考试题目设置
    self.taskTitleLabel.text = [NSString stringWithFormat:@"%@", model.name];
    y = y + self.taskFinishStatusLabel.frame.size.height + 8;
    CGFloat taskTitleLabelHeight = [HICCommonUtils sizeOfString:self.taskTitleLabel.text stringWidthBounding:HIC_ScreenWidth - 58 - 28 font:17 stringOnBtn:NO fontIsRegular:NO].height;
    self.taskTitleLabel.frame = CGRectMake(16, y, HIC_ScreenWidth - 58 - 28, taskTitleLabelHeight);
    NSMutableParagraphStyle*style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.alignment = NSTextAlignmentLeft;
    style.firstLineHeadIndent = taskTagLabelWidth + 12;
    NSAttributedString*attrText = [[NSAttributedString alloc] initWithString:self.taskTitleLabel.text attributes:@{NSParagraphStyleAttributeName: style}];
    self.taskTitleLabel.attributedText = attrText;
    [self.taskTitleLabel sizeToFit];
    NSArray *arr = [HICCommonUtils getLinesArrayOfStringInLabel:self.taskTitleLabel];

     // 考试tag设置
    CGFloat taskTagLabelY = arr.count > 1 ? y + (self.taskTitleLabel.frame.size.height/4 - taskTagLabelHeight/2) : y + (self.taskTitleLabel.frame.size.height/2 - taskTagLabelHeight/2);
    UIView *gradientLabelView = [[UIView alloc] init];
    gradientLabelView.frame = CGRectMake(16, taskTagLabelY, taskTagLabelWidth + 6, taskTagLabelHeight);
    gradientLabelView.layer.masksToBounds = YES;
    gradientLabelView.layer.cornerRadius = 2;
    gradientLabelView.tag = 1000;
    [HICCommonUtils createGradientLayerWithLabel:gradientLabelView fromColor:[UIColor colorWithHexString:@"FF8E6F" alpha:1.0f] toColor:[UIColor colorWithHexString:@"FF553C" alpha:1.0f]];
    [self.taskContentView addSubview:gradientLabelView];
    
    taskTagLabel.frame = CGRectMake(0, 0, gradientLabelView.frame.size.width, gradientLabelView.frame.size.height);
    taskTagLabel.backgroundColor = [UIColor clearColor];
    taskTagLabel.layer.masksToBounds = YES;
    taskTagLabel.layer.cornerRadius = 2;
    taskTagLabel.tag = 1000;
    taskTagLabel.text = model.tag;
    taskTagLabel.textColor = [UIColor whiteColor];
    [gradientLabelView addSubview:taskTagLabel];

    // 考试时间设置
    self.taskTimeLabel.text = [NSString stringWithFormat:@"%@: %@",NSLocalizableString(@"testTime", nil) ,model.examTime];
    y = y + self.taskTitleLabel.frame.size.height + 4;
    CGFloat taskTimeLabelWidth = [HICCommonUtils sizeOfString:self.taskTimeLabel.text stringWidthBounding:HIC_ScreenWidth font:15 stringOnBtn:NO fontIsRegular:YES].width;
    CGFloat taskTimeLabelHeight = [HICCommonUtils sizeOfString:self.taskTimeLabel.text stringWidthBounding:HIC_ScreenWidth font:15 stringOnBtn:NO fontIsRegular:YES].height;
    self.taskTimeLabel.frame = CGRectMake(16, y, taskTimeLabelWidth, taskTimeLabelHeight);

    y = y + self.taskTimeLabel.frame.size.height + 8;
    self.dividedLine1.frame = CGRectMake(16, y, contentViewWidh - 16 * 2, 0.5);

    y = y + 0.5 + 8;

    self.taskDurationLabel.text = [NSString stringWithFormat:@"%@: %@%@",NSLocalizableString(@"testTime", nil), model.examDuration,NSLocalizableString(@"minutes", nil)];
    CGFloat taskDurationLabelHeight = [HICCommonUtils sizeOfString:self.taskDurationLabel.text stringWidthBounding:HIC_ScreenWidth font:14 stringOnBtn:NO fontIsRegular:YES].height;
    CGFloat taskDurationLabelWidth = [HICCommonUtils sizeOfString:self.taskDurationLabel.text stringWidthBounding:HIC_ScreenWidth font:14 stringOnBtn:NO fontIsRegular:YES].width;

    self.taskTimesLabel.text = [NSString stringWithFormat:@"%@: %@", NSLocalizableString(@"numberOfTestsAvailable", nil),model.examTimes];
    CGFloat taskTimesLabelHeight = [HICCommonUtils sizeOfString:self.taskTimesLabel.text stringWidthBounding:HIC_ScreenWidth font:14 stringOnBtn:NO fontIsRegular:YES].height;
    CGFloat taskTimesLabelWidth = [HICCommonUtils sizeOfString:self.taskTimesLabel.text stringWidthBounding:HIC_ScreenWidth font:14 stringOnBtn:NO fontIsRegular:YES].width;

    self.taskPassScoreLabel.text = [NSString stringWithFormat:@"%@: %@/%@分",NSLocalizableString(@"passPoints", nil), model.passScore, model.score];
    CGFloat taskPassScoreLabelHeight = [HICCommonUtils sizeOfString:self.taskPassScoreLabel.text stringWidthBounding:HIC_ScreenWidth font:14 stringOnBtn:NO fontIsRegular:YES].height;
    CGFloat taskPassScoreLabelWidth = [HICCommonUtils sizeOfString:self.taskPassScoreLabel.text stringWidthBounding:HIC_ScreenWidth font:14 stringOnBtn:NO fontIsRegular:YES].width;

    self.taskAssignerLabel.text = [NSString stringWithFormat:@"%@: %@", NSLocalizableString(@"designatedPerson", nil),model.examer];
    CGFloat taskAssignerLabelHeight = [HICCommonUtils sizeOfString:self.taskAssignerLabel.text stringWidthBounding:HIC_ScreenWidth font:14 stringOnBtn:NO fontIsRegular:YES].height;
    CGFloat taskAssignerLabelWidth = [HICCommonUtils sizeOfString:self.taskAssignerLabel.text stringWidthBounding:HIC_ScreenWidth font:14 stringOnBtn:NO fontIsRegular:YES].width;


    CGFloat leftBlockWidth = taskDurationLabelWidth;
    if (taskDurationLabelWidth < taskTimesLabelWidth) {
        leftBlockWidth = taskTimesLabelWidth;
    }

    CGFloat rightBlockWidth = taskPassScoreLabelWidth;
    if (taskPassScoreLabelWidth < taskAssignerLabelWidth) {
        rightBlockWidth = taskAssignerLabelWidth;
    }

    self.taskDurationLabel.frame = CGRectMake(16, y, leftBlockWidth, taskDurationLabelHeight);
    self.taskPassScoreLabel.frame = CGRectMake(contentViewWidh - rightBlockWidth - 16.5, y, rightBlockWidth, taskPassScoreLabelHeight);

    y = y + self.taskDurationLabel.frame.size.height;

    self.taskTimesLabel.frame = CGRectMake(16, y, leftBlockWidth, taskTimesLabelHeight);
    self.taskAssignerLabel.frame = CGRectMake(contentViewWidh - rightBlockWidth - 16.5, y, rightBlockWidth, taskAssignerLabelHeight);

    y = y + self.taskTimesLabel.frame.size.height;

    CGFloat scoreV = 16;
    if (model.grade.count > 0) {
        self.dividedLine2.hidden = NO;
        y = y + 8;
        self.dividedLine2.frame = CGRectMake(16, y, contentViewWidh - 16 * 2, 0.5);
        y = y + 12 + 0.5;
        self.taskGradeTitleLabel.hidden = NO;
        self.taskGradeTitleLabel.text = NSLocalizableString(@"testScores", nil);
        CGFloat taskGradeTitleLabelHeight = [HICCommonUtils sizeOfString:self.taskGradeTitleLabel.text stringWidthBounding:HIC_ScreenWidth font:16 stringOnBtn:NO fontIsRegular:NO].height;
        CGFloat taskGradeTitleLabelWidth = [HICCommonUtils sizeOfString:self.taskGradeTitleLabel.text stringWidthBounding:HIC_ScreenWidth font:16 stringOnBtn:NO fontIsRegular:NO].width;
        self.taskGradeTitleLabel.frame = CGRectMake(16, y, taskGradeTitleLabelWidth, taskGradeTitleLabelHeight);
        y = y + self.taskGradeTitleLabel.frame.size.height + 8;
        CGFloat temScore = -1;
        for (int i = 0; i < model.grade.count; i++) {
            UIView *gradeContentView = [[UIView alloc] initWithFrame:CGRectMake(16, y + (5 + 42) * i, contentViewWidh - 16 * 2, 42)];
            gradeContentView.backgroundColor = [UIColor colorWithRed:255/255.0 green:250/255.0 blue:236/255.0 alpha:1/1.0];
            gradeContentView.tag = 1000;
            [self.taskContentView addSubview:gradeContentView];

            // 考试成绩时间
            UILabel *taskGradeTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(42, 20, 0, 0)];
            taskGradeTimeLabel.textColor = [UIColor colorWithRed:133/255.0 green:133/255.0 blue:133/255.0 alpha:1/1.0];
            taskGradeTimeLabel.font = FONT_REGULAR_14;
            taskGradeTimeLabel.text = model.grade[i][@"examTime"];
            CGFloat taskGradeTimeLabelHeight = [HICCommonUtils sizeOfString:taskGradeTimeLabel.text stringWidthBounding:HIC_ScreenWidth font:14 stringOnBtn:NO fontIsRegular:YES].height;
            CGFloat taskGradeTimeLabelWidth = [HICCommonUtils sizeOfString:taskGradeTimeLabel.text stringWidthBounding:HIC_ScreenWidth font:14 stringOnBtn:NO fontIsRegular:YES].width;
            taskGradeTimeLabel.frame = CGRectMake(12, (42 - taskGradeTimeLabelHeight)/2, taskGradeTimeLabelWidth, taskGradeTimeLabelHeight);
            taskGradeTimeLabel.tag = 1000;
            [gradeContentView addSubview:taskGradeTimeLabel];

            // 考试分数
            UILabel *taskGradeScoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(42, 20, 0, 0)];
            taskGradeScoreLabel.textColor = [UIColor colorWithRed:20/255.0 green:190/255.0 blue:110/255.0 alpha:1/1.0];
            taskGradeScoreLabel.font = FONT_MEDIUM_14;
            taskGradeScoreLabel.text = [NSString stringWithFormat:@"%@/%@%@", model.grade[i][@"passScore"], model.grade[i][@"score"],NSLocalizableString(@"points", nil)];
            CGFloat taskGradeScoreLabelHeight = [HICCommonUtils sizeOfString:taskGradeScoreLabel.text stringWidthBounding:HIC_ScreenWidth font:14 stringOnBtn:NO fontIsRegular:NO].height;
            CGFloat taskGradeScoreLabelWidth = [HICCommonUtils sizeOfString:taskGradeScoreLabel.text stringWidthBounding:HIC_ScreenWidth font:14 stringOnBtn:NO fontIsRegular:NO].width;
            taskGradeScoreLabel.frame = CGRectMake(gradeContentView.frame.size.width - taskGradeScoreLabelWidth - 12, (42 - taskGradeScoreLabelHeight)/2, taskGradeScoreLabelWidth, taskGradeScoreLabelHeight);
            taskGradeScoreLabel.tag = 1000;
            [gradeContentView addSubview:taskGradeScoreLabel];

            if (temScore == -1 || temScore < [model.grade[i][@"passScore"] floatValue]) { // 获取考试几次的最高分数
                temScore = [model.grade[i][@"passScore"] floatValue];
            }
        }
        self.passIV.hidden = NO;
        self.passIV.frame = CGRectMake(contentViewWidh - 80 -12, 40, 80, 80);
        self.passIV.image = [UIImage imageNamed:temScore < [model.passScore floatValue] ? @"未通过" : @"已通过"];
        y = y + 5 * (model.grade.count - 1) + model.grade.count * 42;
    } else {
        self.dividedLine2.hidden = YES;
        self.taskGradeTitleLabel.hidden = YES;
        self.passIV.hidden = YES;
    }

    self.taskContentView.frame = CGRectMake(42, 20 + taskSectionLableHeight + 8, contentViewWidh, y + scoreV);

    UIView *timelineV = [[UIView alloc] init];
    timelineV.backgroundColor = [UIColor colorWithRed:222/255.0 green:222/255.0 blue:222/255.0 alpha:1/1.0];
    CGFloat isFirstModelHeight = isFirstModel ? 35 : 0;
    timelineV.frame = CGRectMake(22, isFirstModelHeight, 0.5, (20 + self.taskSectionLable.frame.size.height + 8 + y + scoreV) - isFirstModelHeight);
    timelineV.tag = 1000;
    [self.contentView addSubview:timelineV];

    UIImageView *timelineIV = [[UIImageView alloc] init];
    if ([NSString isValidStr:sectionName] && [sectionName containsString:NSLocalizableString(@"todayDay", nil)]) {
        timelineIV.image = [UIImage imageNamed:@"时间圆点2"];
    } else if ([NSString isValidStr:sectionName] && ![sectionName containsString:NSLocalizableString(@"todayDay", nil)]) {
        timelineIV.image = [UIImage imageNamed:@"时间圆点"];
    }
    timelineIV.frame =CGRectMake(17, 25, 10, 10);
    timelineIV.tag = 1000;
    [self.contentView addSubview:timelineIV];

    UILabel *timeLineHintLabel = [[UILabel alloc] init];
    CGFloat timelineHintIVHeight = [NSString isValidStr:sectionName] ? 59 : 19;
    timeLineHintLabel.frame = CGRectMake(22 - 12, timelineHintIVHeight, 24, 24);
    timeLineHintLabel.text = NSLocalizableString(@"kao", nil);
    timeLineHintLabel.font = FONT_MEDIUM_15;
    timeLineHintLabel.textColor = [UIColor whiteColor];
    timeLineHintLabel.textAlignment = NSTextAlignmentCenter;
    timeLineHintLabel.layer.masksToBounds = YES;
    timeLineHintLabel.layer.cornerRadius = 12;
    timeLineHintLabel.backgroundColor = [UIColor colorWithRed:0/255.0 green:190/255.0 blue:215/255.0 alpha:1/1.0];
    timeLineHintLabel.tag = 1000;
    [self.contentView addSubview:timeLineHintLabel];

}

@end
