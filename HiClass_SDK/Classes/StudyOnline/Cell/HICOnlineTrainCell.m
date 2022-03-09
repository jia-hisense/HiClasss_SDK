//
//  HICOnlineTrainCell.m
//  HiClass
//
//  Created by WorkOffice on 2020/3/3.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICOnlineTrainCell.h"
#define Width self.contentView.frame.size.width
#define Height self.contentView.frame.size.height
@interface HICOnlineTrainCell()
@property (nonatomic, assign) BaseCellBorderStyle borderStyle;//边框类型
@property (nonatomic, strong) UIColor *contentBorderColor;//边框颜色
@property (nonatomic, strong) UIColor *contentBackgroundColor;//边框内部内容颜色
@property (nonatomic, assign) CGFloat contentBorderWidth;//边框的宽度，这个宽度的一半会延伸到外部，如果对宽度比较敏感的要注意下
@property (nonatomic, assign) CGFloat contentMargin;//左右距离父视图的边距
@property (nonatomic, assign) CGSize contentCornerRadius;//边框的圆角
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *methodLabel;
@property (nonatomic, strong) UILabel *assigorLabel;
@property (nonatomic, strong) UILabel *progressLabel;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) UIButton *onGoingLabel;
@property (nonatomic, strong) NSString *imageName;
@property (nonatomic, strong) UILabel *levelLabel;
@property (nonatomic, strong) UILabel *gradeLabel;
@end
@implementation HICOnlineTrainCell

+ (instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    HICOnlineTrainCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[HICOnlineTrainCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.borderStyle = BaseCellBorderStyleAllRound;
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    [super awakeFromNib];
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentBorderColor = [UIColor clearColor];
        self.contentBackgroundColor = [UIColor whiteColor];
        self.contentBorderWidth = 1.0;
        self.contentMargin = 12.0;
        self.contentCornerRadius = CGSizeMake(8, 8);
        [self createUI];
        [self updateConstraintsIfNeeded];
    }
    return self;
}
- (void)setBorderStyleWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    self.borderStyle = BaseCellBorderStyleAllRound;
}
- (void)setFrame:(CGRect)frame{
    frame.origin.x += 12;
    frame.origin.y += 6;
    frame.size.height -= 12;
    frame.size.width -= 24;
    [super setFrame:frame];
}
- (void)createUI{
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.font = FONT_REGULAR_16;
    self.nameLabel.textColor = TEXT_COLOR_DARK;
    self.nameLabel.numberOfLines = 2;
    [self.contentView addSubview:self.nameLabel];
    self.dateLabel = [[UILabel alloc]init];
    self.dateLabel.font = FONT_REGULAR_14;
    self.dateLabel.textColor = TEXT_COLOR_LIGHTM;
    [self.contentView addSubview:self.dateLabel];
    self.lineView = [[UIView alloc]init];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"#E6E6E6"];
    [self.contentView addSubview:self.lineView];
    
    self.methodLabel = [[UILabel alloc]init];
    self.methodLabel.font = FONT_REGULAR_14;
    self.methodLabel.textColor = TEXT_COLOR_LIGHTM;
    [self.contentView addSubview:self.methodLabel];
    self.assigorLabel = [[UILabel alloc]init];
    self.assigorLabel.font = FONT_REGULAR_14;
    self.assigorLabel.textColor = TEXT_COLOR_LIGHTM;
    [self.contentView addSubview:self.assigorLabel];
    self.progressLabel = [[UILabel alloc]init];
    self.progressLabel.font = FONT_REGULAR_14;
    self.progressLabel.textColor = TEXT_COLOR_LIGHTM;
    [self.contentView addSubview:self.progressLabel];
    self.progressLabel.textAlignment = NSTextAlignmentRight;
    self.progressLabel.hidden = YES;
    self.progressView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
    self.progressView.progressTintColor = [UIColor colorWithHexString:@"#00BED7"];
    self.progressView.tintColor = TEXT_COLOR_LIGHTM;
    self.progressView.layer.cornerRadius = 2.5;
    self.progressView.clipsToBounds = YES;
    self.progressView.hidden = YES;
    [self.contentView addSubview:self.progressView];
    self.levelLabel = [[UILabel alloc]init];
    self.levelLabel.font = FONT_REGULAR_14;
    self.levelLabel.textColor = TEXT_COLOR_LIGHTM;
    self.levelLabel.hidden = YES;
    [self.contentView addSubview:self.levelLabel];
    self.gradeLabel = [[UILabel alloc]init];
    self.gradeLabel.font = FONT_REGULAR_14;
    self.gradeLabel.hidden = YES;
    [self.contentView addSubview:self.gradeLabel];
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
    //    if (labelHeight > 47) {
    //        labelHeight = 47;
    //    }
    //    return labelHeight;
    return label.frame.size.height;
}
-(void)setModel:(HICOnlineTrainListModel *)model{
    self.nameLabel.text = model.trainName;
    NSString *timestr = [NSString stringWithFormat:@"%@: %@",NSLocalizableString(@"trainingTime", nil),[HICCommonUtils returnReadableTimeZoneWithStartTime:model.startTime andEndTime:model.endTime]];
    if (model.status == HICTrainFinished) {
        if (model.trainTerminated == 10) {
            self.dateLabel.textColor = [UIColor colorWithHexString:@"#FF8500"];
            self.dateLabel.text = NSLocalizableString(@"trainingHasBeenCompleted", nil);
        } else{
            self.dateLabel.textColor = TEXT_COLOR_LIGHTM;
            self.dateLabel.text = timestr;
        }
    }else{
        if ([model.curTime integerValue] > [model.endTime integerValue] && model.trainType == 1 && model.trainTerminated !=10 && model.trainProgress < 100) {
            self.dateLabel.text = [NSString stringWithFormat:@"%@！",NSLocalizableString(@"timeoutWarning", nil)];
            self.dateLabel.textColor = [UIColor colorWithHexString:@"#FF8500"];
        }else{
            self.dateLabel.text = timestr;
            self.dateLabel.textColor = TEXT_COLOR_LIGHTM;
        }
    }
    //    "trainType": "int, optional, 1:线上培训，2：线下培训，3：混合培训",
    self.assigorLabel.text = [NSString stringWithFormat:@"%@: %@", NSLocalizableString(@"designatedPerson", nil),[NSString isValidStr:model.trainAssigner] ? model.trainAssigner : @"--"];
    if (model.trainType == 1) {
        self.assigorLabel.textColor = TEXT_COLOR_LIGHTM;
        self.methodLabel.text = [NSString stringWithFormat:@"%@: %@",NSLocalizableString(@"trainingMethods", nil),NSLocalizableString(@"onlineLearning", nil)];
        if(model.isImportant == 0){
            self.nameLabel.text = model.trainName;
            CGFloat height = [self getContentHeight:model.trainName];;
            [self.nameLabel setFrame:CGRectMake(16, 16, HIC_ScreenWidth - 60, height)];
        } else {
            if (model.isImportant == 1) {
                self.imageName = @"标签_重要";
            }
            NSAttributedString *examNameStr = [NSAttributedString stringInsertImageWithImageName:self.imageName imageReact:CGRectMake(0, -2, 32, 16) content:[NSString stringWithFormat:@" %@", model.trainName] stringColor:[UIColor colorWithHexString:@"#333333"] stringFont:[UIFont fontWithName:@"PingFangSC-Regular" size:16]];
            self.nameLabel.attributedText = examNameStr;
            CGFloat height = [self getContentHeight:examNameStr.string];
            [self.nameLabel setFrame:CGRectMake(16, 16, HIC_ScreenWidth - 60, height)];
        }
        NSString *str = @"%";
        self.progressLabel.text = [NSString stringWithFormat:@"%@:%@%@",NSLocalizableString(@"learningProcess", nil),[HICCommonUtils formatFloat:model.trainProgress],str];
        self.progressView.progress = model.trainProgress/100;
        self.levelLabel.hidden = YES;
        self.gradeLabel.hidden = YES;
      
        self.progressLabel.hidden = NO;
        self.progressView.hidden = NO;
        
        self.userInteractionEnabled = YES;
    }else if(model.trainType == 2){
        self.methodLabel.text = [NSString stringWithFormat:@"%@: %@",NSLocalizableString(@"trainingMethods", nil),NSLocalizableString(@"offlineTraining", nil)];
        self.userInteractionEnabled = YES;
        self.progressLabel.hidden = YES;
        self.progressView.hidden = YES;
        self.levelLabel.hidden = NO;
        self.gradeLabel.hidden = NO;
        if ( model.registChannel == 2) {//指派
            self.assigorLabel.text = [NSString stringWithFormat:@"%@: %@", NSLocalizableString(@"designatedPerson", nil),[NSString isValidStr:model.trainAssigner] ? model.trainAssigner : @"--"];
            self.assigorLabel.textColor = TEXT_COLOR_LIGHTM;
        }else{
          if (model.registerId.integerValue > 0) {
                self.assigorLabel.text = NSLocalizableString(@"haveToSignUp", nil);
            }else{
                self.assigorLabel.text = NSLocalizableString(@"didNotSignUp", nil);
            }
        }
//        NSAttributedString *examNameStr;
//        if(model.trainCat == HICTrainInsidePlan){
//            self.imageName = @"标签_内训";
//            examNameStr = [NSAttributedString stringInsertImageWithImageName:self.imageName imageReact:CGRectMake(0, -2, 32, 16) content:[NSString stringWithFormat:@" %@", model.trainName] stringColor:[UIColor colorWithHexString:@"#333333"] stringFont:[UIFont fontWithName:@"PingFangSC-Regular" size:16]];
//        } else if(model.trainCat == HICtrainOutsidePlan || model.trainCat == HICtrainOutwardPlan){//
//            if (model.trainCat == HICtrainOutsidePlan) {
//                self.imageName = @"标签_外请";
//            }else{
//                self.imageName = @"标签_外送培训";
//            }
//            examNameStr = [NSAttributedString stringInsertImageWithImageName:self.imageName imageReact:CGRectMake(0, -2, 55, 16) content:[NSString stringWithFormat:@" %@", model.trainName] stringColor:[UIColor colorWithHexString:@"#333333"] stringFont:[UIFont fontWithName:@"PingFangSC-Regular" size:16]];
//        }else{
//            examNameStr = [[NSAttributedString alloc]initWithString:model.trainName];
//        }
        self.nameLabel.attributedText = [self returnNameWithModel:model];
        CGFloat height = [self getContentHeight:self.nameLabel.attributedText.string];;
        [self.nameLabel setFrame:CGRectMake(16, 16, HIC_ScreenWidth - 56, height)];
        if (model.trainLevel == HICTrainGroupLevel) {
            self.levelLabel.text = [NSString stringWithFormat:@"%@: %@",NSLocalizableString(@"trainingLevel", nil),NSLocalizableString(@"groupLevel", nil)];
        }else if (model.trainLevel == HICTrainCompanyLevel){
            self.levelLabel.text = [NSString stringWithFormat:@"%@: %@",NSLocalizableString(@"trainingLevel", nil),NSLocalizableString(@"corporateLevel", nil)];
        }else{
            self.levelLabel.text = [NSString stringWithFormat:@"%@: %@",NSLocalizableString(@"trainingLevel", nil),NSLocalizableString(@"departmentalLevel", nil)];
        }
        self.gradeLabel.textColor = TEXT_COLOR_LIGHTM;
        if (model.trainResult >= 0) {
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@: %@%@",NSLocalizableString(@"projectPerformance", nil),[HICCommonUtils formatFloat:model.trainResult],NSLocalizableString(@"points", nil)]];
            if (model.trainConclusion == HICTrainGradeQualified) {
                //            self.gradeLabel.textColor = [UIColor colorWithHexString:@"#14BE6E"];
                [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#14BE6E"] range:NSMakeRange(5,str.length - 5)];
                self.gradeLabel.attributedText = str;
            }else if (model.trainConclusion == HICTrainGradeNoQualified){
                //            self.gradeLabel.textColor = [UIColor colorWithHexString:@"#FF583F"];
                [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#FF583F"] range:NSMakeRange(5,str.length - 5)];
                self.gradeLabel.attributedText = str;
            }else{
                self.gradeLabel.textColor = TEXT_COLOR_LIGHTM;
                self.gradeLabel.text = [NSString stringWithFormat:@"%@: %@",NSLocalizableString(@"projectPerformance", nil),NSLocalizableString(@"studyInSchoolstudy", nil)];
            }
            
        }else {
            self.gradeLabel.text = [NSString stringWithFormat:@"%@: --",NSLocalizableString(@"projectPerformance", nil)];
        }
        
    }else{
        self.methodLabel.text = [NSString stringWithFormat:@"%@: %@",NSLocalizableString(@"trainingMethods", nil),NSLocalizableString(@"online+offline", nil)];
        self.nameLabel.attributedText = [self returnNameWithModel:model];
        self.progressView.hidden = YES;
        self.progressLabel.hidden = YES;
        self.levelLabel.hidden = NO;
        self.gradeLabel.hidden = YES;
        if ( model.registChannel == 2) {//指派
            self.assigorLabel.text = [NSString stringWithFormat:@"%@: %@", NSLocalizableString(@"designatedPerson", nil),[NSString isValidStr:model.trainAssigner] ? model.trainAssigner : @"--"];
            self.assigorLabel.textColor = TEXT_COLOR_LIGHTM;
        }else{
            if (model.registerId.integerValue > 0) {
                self.assigorLabel.text = NSLocalizableString(@"haveToSignUp", nil);
            }else{
                self.assigorLabel.text = NSLocalizableString(@"didNotSignUp", nil);
            }
        }
        if (model.trainResult >= 0) {
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@: %@%@",NSLocalizableString(@"projectPerformance", nil),[HICCommonUtils formatFloat:model.trainResult],NSLocalizableString(@"points", nil)]];
            if (model.trainConclusion == HICTrainGradeQualified) {
                [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#14BE6E"] range:NSMakeRange(5,str.length - 5)];
                self.levelLabel.attributedText = str;
            }else if (model.trainConclusion == HICTrainGradeNoQualified){
                [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#FF583F"] range:NSMakeRange(5,str.length - 5)];
                self.levelLabel.attributedText = str;
            }else{
                self.levelLabel.textColor = TEXT_COLOR_LIGHTM;
                self.levelLabel.text = [NSString stringWithFormat:@"%@: %@",NSLocalizableString(@"projectPerformance", nil),NSLocalizableString(@"studyInSchoolstudy", nil)];;
            }
            
        }else {
            self.levelLabel.text = [NSString stringWithFormat:@"%@: --",NSLocalizableString(@"projectPerformance", nil)];
        }
        
    }
    
    //    "progressStatus": "int, required, 1:进行中,  2:已开始, 3:已结束 ",
    
    if (_isAll) {
        [self.onGoingLabel removeFromSuperview];
        self.onGoingLabel = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.onGoingLabel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.onGoingLabel.titleLabel.font = FONT_MEDIUM_9;
        self.onGoingLabel.frame = CGRectMake(0, 0, 31, 12);
        [HICCommonUtils setRoundingCornersWithView:self.onGoingLabel TopLeft:YES TopRight:NO bottomLeft:NO bottomRight:YES cornerRadius:4];
        [self.contentView addSubview:self.onGoingLabel];
        if (model.status == HICTrainInProgress) {
            [self.onGoingLabel setTitle:NSLocalizableString(@"ongoing", nil) forState:UIControlStateNormal];
            [HICCommonUtils createGradientLayerWithBtn:self.onGoingLabel fromColor:[UIColor colorWithHexString:@"#FF8500"] toColor:[UIColor colorWithHexString:@"#FF9624"]];
        }else{
            self.progressLabel.hidden = YES;
            self.progressView.hidden = YES;
            if (model.status == HICTrainWait) {
                [self.onGoingLabel setTitle:NSLocalizableString(@"waitStart", nil) forState:UIControlStateNormal];
                [HICCommonUtils createGradientLayerWithBtn:self.onGoingLabel fromColor:[UIColor colorWithHexString:@"#FFC76C"] toColor:[UIColor colorWithHexString:@"#FFB843"]];
            }else{
                if (model.trainTerminated == 10) {
                    [self.onGoingLabel setTitle:NSLocalizableString(@"hasEnded", nil) forState:UIControlStateNormal];
                }else{
                    [self.onGoingLabel setTitle:NSLocalizableString(@"hasBeenCompleted", nil) forState:UIControlStateNormal];
                }
                [HICCommonUtils createGradientLayerWithBtn:self.onGoingLabel fromColor:[UIColor colorWithHexString:@"#D0D0D0"] toColor:[UIColor colorWithHexString:@"#D0D0D0"]];
            }
        }
    }else{
        [self.onGoingLabel removeFromSuperview];
    }
    [self updateConstraints];
}
- (NSAttributedString *)returnNameWithModel:(HICOnlineTrainListModel *)model{
    NSAttributedString *examNameStr;
    if(model.trainCat == HICTrainInsidePlan){
        self.imageName = @"标签_内训";
        examNameStr = [NSAttributedString stringInsertImageWithImageName:self.imageName imageReact:CGRectMake(0, -2, 32, 16) content:[NSString stringWithFormat:@" %@", model.trainName] stringColor:[UIColor colorWithHexString:@"#333333"] stringFont:[UIFont fontWithName:@"PingFangSC-Regular" size:16]];
    } else if(model.trainCat == HICtrainOutsidePlan || model.trainCat == HICtrainOutwardPlan){//
        if (model.trainCat == HICtrainOutsidePlan) {
            self.imageName = @"标签_外请";
        }else{
            self.imageName = @"标签_外送培训";
        }
        examNameStr = [NSAttributedString stringInsertImageWithImageName:self.imageName imageReact:CGRectMake(0, -2, 55, 16) content:[NSString stringWithFormat:@" %@", model.trainName] stringColor:[UIColor colorWithHexString:@"#333333"] stringFont:[UIFont fontWithName:@"PingFangSC-Regular" size:16]];
    }else{
        examNameStr = [[NSAttributedString alloc]initWithString:model.trainName];
    }
    return examNameStr;
}
- (void)updateConstraints{
    [super updateConstraints];
    [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(16);
        make.left.equalTo(self).offset(16);
        make.width.offset(HIC_ScreenWidth - 56);
    }];
    [self.dateLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(4);
        make.left.equalTo(self.nameLabel);
        make.right.equalTo(self.contentView).offset(-56);
        make.height.offset(20);
    }];
    [self.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dateLabel.mas_bottom).offset(12);
        make.left.equalTo(self).offset(16);
        make.right.equalTo(self).offset(-16);
        make.height.offset(1);
    }];
    
    [self.methodLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView).offset(8);
        make.left.equalTo(self.lineView);
        make.width.offset(HIC_ScreenWidth/2 - 28);
        make.height.offset(20);
    }];
    [self.assigorLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.methodLabel.mas_bottom);
        make.left.equalTo(self.methodLabel);
        make.width.offset(HIC_ScreenWidth/2 - 28);
        make.height.offset(20);
    }];
    [self.progressLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.methodLabel);
        make.right.equalTo(self.contentView).offset(-16);
        make.width.offset(110);
        make.height.offset(20);
    }];
    [self.levelLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.methodLabel);
        make.right.equalTo(self.contentView).offset(-16);
        make.width.offset(110);
        make.height.offset(20);
    }];
    [self.gradeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.progressLabel.mas_bottom);
        make.right.equalTo(self.contentView).offset(-16);
        make.width.offset(110);
        make.height.offset(20);
    }];
    [self.progressView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.progressLabel.mas_bottom).offset(8);
        make.right.equalTo(self.contentView).offset(-16);
        make.width.offset(100);
        make.height.offset(5);
    }];
    
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

@end
