//
//  HICExamCell.m
//  HiClass
//
//  Created by 铁柱， on 2020/1/15.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICExamCell.h"
#import "HICExamBaseInfoModel.h"
#import "HICExamControlModel.h"
#import "HICExamRecordModel.h"
#define Width self.contentView.frame.size.width
#define Height self.contentView.frame.size.height


@interface HICExamCell ()
@property (nonatomic, assign) BaseCellBorderStyle borderStyle;//边框类型
@property (nonatomic, strong) UIColor *contentBorderColor;//边框颜色
@property (nonatomic, strong) UIColor *contentBackgroundColor;//边框内部内容颜色
@property (nonatomic, assign) CGFloat contentBorderWidth;//边框的宽度，这个宽度的一半会延伸到外部，如果对宽度比较敏感的要注意下
@property (nonatomic, assign) CGFloat contentMargin;//左右距离父视图的边距
@property (nonatomic, assign) CGSize contentCornerRadius;//边框的圆角
@property (nonatomic, strong) UILabel *examNameLabel;
@property (nonatomic, strong) UILabel *examDateLabel;
@property (nonatomic, strong) UIView *separateLineU;
@property (nonatomic, strong) UIView *separateLineD;
@property (nonatomic, strong) UILabel *examTimeLabel;
@property (nonatomic, strong) UILabel *examAvailabelTimesLabel;
@property (nonatomic, strong) UILabel *examPassScore;
@property (nonatomic, strong) UILabel *examGradeTitle;
@property (nonatomic, strong) UILabel *examGradeDLabel;
@property (nonatomic, strong) UIImageView *examStatusView;
@property (nonatomic, assign) BOOL gradeShow;
@property (nonatomic, strong) NSString *imageName;
@property (nonatomic, strong) UILabel *examTimeLabelD;
@property (nonatomic, strong) UILabel *examGradelabelD;
@property (nonatomic, strong) NSString *strleaveStr;
@property (nonatomic, strong) HICExamControlModel *controlModel;
@property (nonatomic, strong) HICExamBaseInfoModel *baseInfoModel;
@property (nonatomic, strong) HICExamRecordModel *recordModel;
@property (nonatomic ,strong) HICExamModel *examModel;
@property (nonatomic, strong) UIImageView *onGoingView;
@property (nonatomic, strong) UIButton *onGoingLabel;
@property (nonatomic, strong) UIImageView *absentView;
@property (nonatomic, strong) UILabel *assignorLabel;
@end
@implementation HICExamCell

+ (instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    HICExamCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[HICExamCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.borderStyle = BaseCellBorderStyleAllRound;
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    [super awakeFromNib];
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentBorderColor = [UIColor clearColor];
        self.contentBackgroundColor = [UIColor whiteColor];
        self.contentBorderWidth = 1.0;
        self.contentMargin = 12.0;
        self.contentCornerRadius = CGSizeMake(5, 5);
        [self createUI];
        [self updateConstraintsIfNeeded];
    }
    return self;
}
- (void)setFrame:(CGRect)frame{
    frame.origin.x += 10;
    frame.origin.y += 6;
    frame.size.height -= 10;
    frame.size.width -= 20;
    [super setFrame:frame];
}
- (void)createUI{
    self.onGoingLabel = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.onGoingLabel setTitle:NSLocalizableString(@"ongoing", nil) forState:UIControlStateNormal];
    [self.onGoingLabel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.onGoingLabel.titleLabel.font = FONT_MEDIUM_9;
    self.onGoingLabel.frame = CGRectMake(0, 0, 31, 12);
    [HICCommonUtils createGradientLayerWithBtn:self.onGoingLabel fromColor:[UIColor colorWithHexString:@"#FF8500"] toColor:[UIColor colorWithHexString:@"#FF9624"]];
    [HICCommonUtils setRoundingCornersWithView:self.onGoingLabel TopLeft:YES TopRight:NO bottomLeft:NO bottomRight:YES cornerRadius:4];
    [self.contentView addSubview:self.onGoingLabel];
    self.onGoingLabel.hidden = YES;
    self.examNameLabel = [[UILabel alloc]init];
    self.examNameLabel.font = FONT_REGULAR_16;
    self.examNameLabel.textColor = TEXT_COLOR_DARK;
    self.examNameLabel.numberOfLines = 2;
    self.examNameLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.contentView addSubview:self.examNameLabel];
    
    self.examDateLabel = [[UILabel alloc]init];
    self.examDateLabel.font = FONT_REGULAR_14;
    self.examDateLabel.textColor = TEXT_COLOR_LIGHTM;
    self.examDateLabel.numberOfLines = 1;
    self.examDateLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.contentView addSubview:self.examDateLabel];
    
    self.separateLineU = [[UIView alloc]init];
    self.separateLineU.backgroundColor = [UIColor colorWithHexString:@"#E6E6E6"];
    [self.contentView addSubview:self.separateLineU];
    self.absentView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"缺考"]];
    self.absentView.hidden = YES;
    [self.contentView addSubview:self.absentView];
    self.examTimeLabel = [[UILabel alloc]init];
    self.examTimeLabel.font = FONT_REGULAR_14;
    self.examTimeLabel.textColor = TEXT_COLOR_LIGHTM;
    [self.contentView addSubview:self.examTimeLabel];
    self.examAvailabelTimesLabel = [[UILabel alloc]init];
    self.examAvailabelTimesLabel.font = FONT_REGULAR_15;
    self.examAvailabelTimesLabel.textColor = TEXT_COLOR_LIGHTM;
    [self.contentView addSubview:self.examAvailabelTimesLabel];
    self.examPassScore = [[UILabel alloc]init];
    self.examPassScore.font = FONT_REGULAR_14;
    self.examPassScore.textColor = TEXT_COLOR_LIGHTM;
    //    self.examPassScore.text = @"通过分数：60";
    
    [self.contentView addSubview:self.examPassScore];
    self.assignorLabel = [[UILabel alloc]init];
    self.assignorLabel.font = FONT_REGULAR_14;
    self.assignorLabel.textColor = TEXT_COLOR_LIGHTM;
    [self.contentView addSubview:self.assignorLabel];
    
    self.separateLineD = [[UIView alloc]init];
    self.separateLineD.backgroundColor = [UIColor colorWithHexString:@"#E6E6E6"];
    [self.contentView addSubview:self.separateLineD];
    self.examStatusView = [[UIImageView alloc]init];
    [self.contentView addSubview:self.examStatusView];
    self.examGradeTitle = [[UILabel alloc]init];
    self.examGradeTitle.text = NSLocalizableString(@"testScores", nil);
    self.examGradeTitle.font = FONT_MEDIUM_15;
    self.examGradeTitle.textColor = TEXT_COLOR_DARK;
    [self.contentView addSubview:self.examGradeTitle];
    self.examGradeDLabel = [[UILabel alloc]init];
    self.examGradeDLabel.backgroundColor = [UIColor colorWithHexString:@"#FFFAEC"];
    //    self.examGradeDLabel.text = @"80/100fen";
    [self.contentView addSubview:self.examGradeDLabel];
    self.examTimeLabelD = [[UILabel alloc]init];
    self.examTimeLabelD.font = FONT_REGULAR_14;
    self.examTimeLabelD.textColor = TEXT_COLOR_LIGHTM;
    [self.examGradeDLabel addSubview:self.examTimeLabelD];
    self.examGradelabelD = [[UILabel alloc]init];
    self.examGradelabelD.font = FONT_REGULAR_14;
    self.examGradelabelD.textColor = [UIColor colorWithHexString:@"#14BE6E"];
    [self.examGradeDLabel addSubview:self.examGradelabelD];
    [self layoutIfNeeded];
    
}
- (CGFloat)getContentHeight:(NSString *)str {
    UILabel *label = [[UILabel alloc] init];
    label.text = str;
    label.font = FONT_MEDIUM_17;
    label.numberOfLines = 2;
    CGFloat labelHeight = [HICCommonUtils sizeOfString:str stringWidthBounding:HIC_ScreenWidth - 56 font:17 stringOnBtn:NO fontIsRegular:NO].height;
    label.frame = CGRectMake(0, 0, HIC_ScreenWidth - 56, labelHeight);
    [label sizeToFit];
    return label.frame.size.height;
}
- (void)setModel:(HICExamModel *)model{
    self.examModel = model;
    self.baseInfoModel = [HICExamBaseInfoModel mj_objectWithKeyValues:self.examModel.baseInfo];
    if (!self.baseInfoModel.name) {
        return;
    }
    self.controlModel = [HICExamControlModel mj_objectWithKeyValues:self.examModel.controlParams];
    if ([HICCommonUtils isValidObject: self.examModel.examRecordInfoList] ) {
        if (self.examModel.examRecordInfoList.count) {
            if (self.examModel.examRecordInfoList.count == 1) {
                self.recordModel = [HICExamRecordModel mj_objectWithKeyValues:self.examModel.examRecordInfoList[0]];
            }else{
                NSArray *tempArr = [self.examModel.examRecordInfoList sortedArrayUsingComparator:^(id  _Nonnull obj1, id  _Nonnull obj2) {
                    if ([[obj1 valueForKey:@"score"] floatValue] < [[obj2 valueForKey:@"score"] floatValue]){
                        return NSOrderedDescending;
                    }else {
                        return NSOrderedAscending;
                    }
                }];
                self.recordModel = [HICExamRecordModel mj_objectWithKeyValues:tempArr[0]];
            }
            
        }
    }
    if([self.baseInfoModel.tags isEqualToString:@"makeUp"]){
        self.imageName = @"标签_补考";
        NSAttributedString *examNameStr = [NSAttributedString stringInsertImageWithImageName:self.imageName imageReact:CGRectMake(0, -2, 32, 16) content:self.baseInfoModel.name stringColor:[UIColor colorWithHexString:@"#333333"] stringFont:[UIFont fontWithName:@"PingFangSC-Regular" size:16]];
        self.examNameLabel.attributedText = examNameStr;
        CGFloat labelheight = [self getContentHeight:examNameStr.string];
        
        if (labelheight > 48) {
            labelheight = 48;
        }
        [self.examNameLabel setFrame:CGRectMake(16, 16, HIC_ScreenWidth - 60, labelheight)];
    }
     else{
         if (self.baseInfoModel.importantFlag == 1) {
             self.imageName = @"标签_重要";
             NSAttributedString *examNameStr = [NSAttributedString stringInsertImageWithImageName:self.imageName imageReact:CGRectMake(0, -2, 32, 16) content:self.baseInfoModel.name stringColor:[UIColor colorWithHexString:@"#333333"] stringFont:[UIFont fontWithName:@"PingFangSC-Regular" size:16]];
             self.examNameLabel.attributedText = examNameStr;
             CGFloat labelheight = [self getContentHeight:examNameStr.string];
             
             if (labelheight > 48) {
                 labelheight = 48;
             }
             [self.examNameLabel setFrame:CGRectMake(16, 16, HIC_ScreenWidth - 60, labelheight)];
         }else{
             self.examNameLabel.text = self.baseInfoModel.name;
             CGFloat labelheight = [self getContentHeight:self.baseInfoModel.name];
             if (labelheight > 48) {
                 labelheight = 48;
             }
             [self.examNameLabel setFrame:CGRectMake(16, 16, HIC_ScreenWidth - 60, labelheight)];
         }
    }
    
    
    [self.examNameLabel sizeToFit];
    NSDate *dateNow = [NSDate date];
    
    if ([self.controlModel.joinStartTime isEqual:@0] && [self.controlModel.joinEndTime isEqual:@0]) {
        self.examDateLabel.text = [NSString stringWithFormat:@"%@：%@",NSLocalizableString(@"startTextTime", nil),NSLocalizableString(@"unlimited", nil)];
        if (self.baseInfoModel.examStatus == HICExamArrangeProgress &&  (self.controlModel.allowTimes == 0 || self.baseInfoModel.times != 0 || (self.baseInfoModel.times !=0 && self.baseInfoModel.status == HICExamProgress))) {
          self.onGoingLabel.hidden = NO;
        }else{
            self.onGoingLabel.hidden = YES;
        }
    }else if([self.controlModel.joinStartTime isEqual:@0]){
        self.examDateLabel.text = [NSString stringWithFormat:@"%@：--%@ %@",NSLocalizableString(@"startTextTime", nil),NSLocalizableString(@"to", nil),[HICCommonUtils timeStampToReadableDate:self.controlModel.joinEndTime isSecs:YES format:@"yyyy-MM-dd HH:mm"]];
        if ([self.controlModel.joinEndTime integerValue] > [dateNow timeIntervalSince1970]) {
            if (self.baseInfoModel.examStatus == HICExamArrangeProgress &&  (self.controlModel.allowTimes == 0 || self.baseInfoModel.times != 0 || (self.baseInfoModel.times !=0 && self.baseInfoModel.status == HICExamProgress))) {
              self.onGoingLabel.hidden = NO;
            }else{
                self.onGoingLabel.hidden = YES;
            }
        }else{
            self.onGoingLabel.hidden = YES;
        }
        
    }else if([self.controlModel.joinEndTime isEqual:@0]){
        self.examDateLabel.text = [NSString stringWithFormat:@"%@：%@%@ %@",NSLocalizableString(@"startTextTime", nil),[HICCommonUtils timeStampToReadableDate:self.controlModel.joinStartTime isSecs:YES format:@"yyyy-MM-dd HH:mm"],NSLocalizableString(@"to", nil),NSLocalizableString(@"unlimited", nil)];
        if ([self.controlModel.joinStartTime integerValue] < [dateNow timeIntervalSince1970]) {
            if (self.baseInfoModel.examStatus == HICExamArrangeProgress &&  (self.controlModel.allowTimes == 0 || self.baseInfoModel.times != 0 || (self.baseInfoModel.times !=0 && self.baseInfoModel.status == HICExamProgress))) {
              self.onGoingLabel.hidden = NO;
            }else{
                self.onGoingLabel.hidden = YES;
            }
        }else{
            self.onGoingLabel.hidden = YES;
        }
    }
    else{
        NSString *format;
        NSString *timestr;
        if ([self.controlModel.joinEndTime integerValue] - [self.controlModel.joinStartTime integerValue] > 31622400) {
            format = @"yyyy-MM-dd HH:mm";
            timestr = [NSString stringWithFormat:@"%@：%@%@%@",NSLocalizableString(@"startTextTime", nil),[HICCommonUtils timeStampToReadableDate:self.controlModel.joinStartTime isSecs:YES format:@"MM-dd HH:mm"],NSLocalizableString(@"to", nil),[HICCommonUtils timeStampToReadableDate:self.controlModel.joinEndTime isSecs:YES format:format]];
        }else{
            format = @"MM-dd HH:mm";
            timestr = [NSString stringWithFormat:@"%@：%@%@%@",NSLocalizableString(@"startTextTime", nil),[HICCommonUtils timeStampToReadableDate:self.controlModel.joinStartTime isSecs:YES format:format],NSLocalizableString(@"to", nil),[HICCommonUtils timeStampToReadableDate:self.controlModel.joinEndTime isSecs:YES format:format]];
        }
        self.examDateLabel.text = timestr;
        if ([self.controlModel.joinStartTime integerValue] <=[dateNow timeIntervalSince1970] && [self.controlModel.joinEndTime integerValue] > [dateNow timeIntervalSince1970]) {
            if (self.baseInfoModel.examStatus == HICExamArrangeProgress &&  (self.controlModel.allowTimes == 0 || self.baseInfoModel.times != 0 || (self.baseInfoModel.times == 0 && self.baseInfoModel.status == HICExamProgress))) {
              self.onGoingLabel.hidden = NO;
            }else{
                self.onGoingLabel.hidden = YES;
            }
        }else{
            self.onGoingLabel.hidden = YES;
        }
    }
    
    if (self.controlModel.examDuration <= 0) {
        self.examTimeLabel.text = [NSString stringWithFormat:@"%@：%@",NSLocalizableString(@"testTime", nil),NSLocalizableString(@"unlimited", nil)];
    }else{
        self.examTimeLabel.text = [NSString stringWithFormat:@"%@：%ld%@",NSLocalizableString(@"testTime",nil),(long)self.controlModel.examDuration,NSLocalizableString(@"minutes", nil)];
    }
    if (self.controlModel.allowTimes <= 0) {
        self.examAvailabelTimesLabel.text = [NSString stringWithFormat:@"%@：%@",NSLocalizableString(@"numberOfTestsAvailable", nil),NSLocalizableString(@"unlimited", nil)];
    }else{
        NSString *examTimesText = [NSString stringWithFormat:@"%@：%ld",NSLocalizableString(@"numberOfTestsAvailable", nil),(long)self.baseInfoModel.times];
        self.examAvailabelTimesLabel.text = examTimesText;
    }
    NSString *passScoreText = [NSString stringWithFormat:@"%@：%@/%@%@",NSLocalizableString(@"passPoints", nil),[HICCommonUtils formatFloat:self.baseInfoModel.passScroe],[HICCommonUtils formatFloat:self.baseInfoModel.score],NSLocalizableString(@"points", nil)];
    self.examPassScore.text = passScoreText;
    self.assignorLabel.text = [NSString stringWithFormat:@"%@：%@",NSLocalizableString(@"designatedPerson", nil),self.baseInfoModel.assignor];
    if (self.baseInfoModel.status == 0 || self.baseInfoModel.status == 4){
        self.separateLineD.hidden = YES;
        self.examGradeTitle.hidden = YES;
        self.examGradeDLabel.hidden = YES;
        self.examStatusView.hidden = YES;
        self.absentView.hidden = YES;
        //        self.examNameLabel.textColor = TEXT_COLOR_DARK;
        if (self.baseInfoModel.status == 4) {
            self.examStatusView.hidden = YES;
            //            self.examNameLabel.textColor = [UIColor colorWithHexString:@"#FF583F"];
            self.absentView.hidden = NO;
        }
    }else if(self.baseInfoModel.status == 1){
        self.separateLineD.hidden = YES;
        self.examGradeTitle.hidden = YES;
        self.examGradeDLabel.hidden = YES;
        self.examStatusView.hidden = YES;
        self.absentView.hidden = YES;
    }else if(self.baseInfoModel.status == 3){
        self.separateLineD.hidden = NO;
        self.examGradeTitle.hidden = NO;
        self.examGradeDLabel.hidden = NO;
        //            self.examStatusView.hidden = NO;
        self.absentView.hidden = YES;
        //            self.examNameLabel.textColor = TEXT_COLOR_DARK;
        if (self.recordModel.score >= self.baseInfoModel.passScroe) {
            self.examGradelabelD.textColor = [UIColor colorWithHexString:@"#14BE6E"];
            self.examStatusView.image = [UIImage imageNamed:@"已通过"];
        }else {
            self.examStatusView.image = [UIImage imageNamed:@"未通过"];
            self.examGradelabelD.textColor = [UIColor colorWithHexString:@"#FF583F"];
        }
        self.examTimeLabelD.text = [HICCommonUtils timeStampToReadableDate:self.baseInfoModel.assignTime isSecs:YES format:@"yyyy-MM-dd HH:mm:ss"];
        if (self.controlModel.allowViewScore == 0) {
            self.examGradelabelD.text = [NSString stringWithFormat:@"*%@",NSLocalizableString(@"points", nil)];
            self.examStatusView.hidden = YES;
        }else if(self.controlModel.allowViewScore == 1){
            self.examTimeLabelD.text = [HICCommonUtils timeStampToReadableDate:self.recordModel.submitTime isSecs:YES format:@"yyyy-MM-dd HH:mm:ss"];
            self.examGradelabelD.text = [NSString stringWithFormat:@"%@/%@%@",[HICCommonUtils formatFloat:self.recordModel.score],[HICCommonUtils formatFloat:self.baseInfoModel.score],NSLocalizableString(@"points", nil)];
            self.examStatusView.hidden = YES;
        }else if(self.controlModel.allowViewScore == 2){
            self.examGradelabelD.text = [NSString stringWithFormat:@"*%@",NSLocalizableString(@"points", nil)];
            self.examStatusView.hidden = NO;
        }else{
            self.examTimeLabelD.text = [HICCommonUtils timeStampToReadableDate:self.recordModel.submitTime isSecs:YES format:@"yyyy-MM-dd HH:mm:ss"];
            self.examGradelabelD.text = [NSString stringWithFormat:@"%@/%@%@",[HICCommonUtils formatFloat:self.recordModel.score],[HICCommonUtils formatFloat:self.baseInfoModel.score],NSLocalizableString(@"points", nil)];
            self.examStatusView.hidden = NO;
        }
    }else if(self.baseInfoModel.status == 2){
        //            self.examNameLabel.textColor = TEXT_COLOR_DARK;
        self.separateLineD.hidden = NO;
        self.examGradeTitle.hidden = NO;
        self.examGradeDLabel.hidden = NO;
        self.examStatusView.hidden = YES;
        self.absentView.hidden = YES;
        if (self.examModel.examRecordInfoList.count > 0) {
            self.recordModel = [HICExamRecordModel mj_objectWithKeyValues:[self.examModel.examRecordInfoList lastObject]];
        }
        self.examTimeLabelD.text = [HICCommonUtils timeStampToReadableDate:self.recordModel.submitTime isSecs:YES format:@"yyyy-MM-dd HH:mm:ss"];
        self.examGradelabelD.text = NSLocalizableString(@"reviewing", nil);
        self.examGradelabelD.textColor = TEXT_COLOR_LIGHTM;
    }else{
        //            self.examNameLabel.textColor = TEXT_COLOR_DARK;
    }
    
    [self layoutIfNeeded];
}

- (void)setIsLabelHidden:(BOOL)isLabelHidden{
    self.onGoingLabel.hidden = isLabelHidden;
    [self layoutIfNeeded];
}
- (void)updateConstraints{
    [super updateConstraints];
    [self.examNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(16);
        make.left.equalTo(self).offset(16);
        make.width.offset(HIC_ScreenWidth - 56);
    }];
    [self.examDateLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.examNameLabel.mas_bottom).offset(4);
        make.left.equalTo(self.examNameLabel);
        make.right.equalTo(self.contentView).offset(-12);
        make.height.offset(20);
    }];
    [self.separateLineU mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.examDateLabel.mas_bottom).offset(8);
        make.left.equalTo(self).offset(16);
        make.right.equalTo(self).offset(-16);
        make.height.offset(0.5);
    }];
    [self.absentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(12);
        make.right.equalTo(self).offset(-12);
        
    }];
    [self.examTimeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.separateLineU).offset(8);
        make.left.equalTo(self.separateLineU);
        make.width.offset(HIC_ScreenWidth/2 - 28);
        make.height.offset(20);
    }];
    [self.examAvailabelTimesLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.examTimeLabel.mas_bottom);
        make.left.equalTo(self.examTimeLabel);
        make.width.offset(HIC_ScreenWidth/2 - 28);
        make.height.offset(20);
    }];
    [self.examPassScore mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.examTimeLabel);
        make.left.equalTo(self.examTimeLabel.mas_right);
        make.height.offset(20);
    }];
    [self.assignorLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.examAvailabelTimesLabel);
        make.left.equalTo(self.examPassScore);
        make.width.equalTo(self.examAvailabelTimesLabel);
        make.height.offset(20);
    }];
    [self.examStatusView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(11.5);
        make.right.equalTo(self).offset(-12);
    }];
    [self.separateLineD mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.examAvailabelTimesLabel.mas_bottom).offset(8);
        make.left.equalTo(self.examAvailabelTimesLabel);
        make.right.equalTo(self).offset(-20);
        make.height.offset(0.5);
    }];
    [self.examGradeTitle mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.separateLineD).offset(8);
        make.left.equalTo(self.separateLineD);
        make.height.offset(20);
        
    }];
    [self.examGradeDLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.examGradeTitle.mas_bottom).offset(8);
        make.left.equalTo(self.examGradeTitle);
        make.right.equalTo(self).offset(-12);
        make.height.offset(42);
    }];
    [self.examTimeLabelD mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.examGradeDLabel).offset(10);
        make.centerY.equalTo(self.examGradeDLabel);
    }];
    [self.examGradelabelD mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.examGradeDLabel);
        make.right.equalTo(self.examGradeDLabel).offset(-10);
    }];
}

- (void)setBorderStyleWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    self.borderStyle = BaseCellBorderStyleAllRound;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    //在这里设置才能获取到真正显示时候的宽度，而不是原始的
    [self setupBorder];
}
- (void)setupBorder
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.lineWidth = self.contentBorderWidth;
    layer.strokeColor = self.contentBorderColor.CGColor;
    layer.fillColor =  self.contentBackgroundColor.CGColor;
    
    UIView *view = [[UIView alloc] initWithFrame:self.contentView.bounds];
    [view.layer insertSublayer:layer atIndex:0];
    view.backgroundColor = [UIColor clearColor];
    //用自定义的view代替cell的backgroundView
    self.backgroundView = view;
    
    CGRect rect = CGRectMake(0,0, Width, Height);
    switch (self.borderStyle) {
        case BaseCellBorderStyleNoRound:
        {
            UIBezierPath *path = [UIBezierPath bezierPathWithRect:rect];
            layer.path = path.CGPath;
        }
            break;
        case BaseCellBorderStyleTopRound:
        {
            UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:self.contentCornerRadius];
            layer.path = path.CGPath;
        }
            break;
        case BaseCellBorderStyleBottomRound:
        {
            UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:self.contentCornerRadius];
            layer.path = path.CGPath;
        }
            break;
        case BaseCellBorderStyleAllRound:
        {
            UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerAllCorners cornerRadii:self.contentCornerRadius];
            layer.path = path.CGPath;
        }
            break;
        default:
            break;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


@end
