//
//  HICMyRecordCell.m
//  HiClass
//
//  Created by WorkOffice on 2020/2/21.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICMyRecordCell.h"
#import "HICCourseModel.h"
#import "HICMediaInfoModel.h"
@interface HICMyRecordCell()
@property (nonatomic, strong)UIProgressView *progressView;
@property (nonatomic ,strong)UIView *leftView;
@property (nonatomic ,strong)UIImageView *leftImageView;
@property (nonatomic, strong)UILabel *nameLabel;
@property (nonatomic, strong)UILabel *scoreLabel;
@property (nonatomic, strong)UILabel *timeLabel;
@property (nonatomic, strong)UILabel *percentLabel;
@property (nonatomic ,strong)UIView *line;
@property (nonatomic, strong)HICCourseModel *courseModel;
@property (nonatomic, strong)HICMyRecordModel *recordModel;

@end
@implementation HICMyRecordCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    [super awakeFromNib];
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
        [self updateConstraintsIfNeeded];
    }
    return self;
}

- (HICMyRecordModel *)recordModel{
    if (!_recordModel) {
        _recordModel = [[HICMyRecordModel alloc]init];
    }
    return _recordModel;
}
- (void)setModel:(HICMyRecordModel *)model{
    self.recordModel = model;
    self.courseModel = [HICCourseModel mj_objectWithKeyValues:self.recordModel.courseKLDInfo];
//    self.leftImageView.image = [UIImage imageNamed:self.courseModel.resourcePic];
//    [self.leftImageView sd_setImageWithURL:[NSURL URLWithString:self.courseModel.coverPic? self.courseModel.coverPic : @""]];
    if (self.courseModel.courseKLDType == 6) {
        self.leftImageView.image = [UIImage imageNamed:@"知识课程默认图标"];
    }else{
        if (self.courseModel.resourceType == HICAudioType) {
            self.leftImageView.image = [UIImage imageNamed:@"知识类型-音频"];
        }else if (self.courseModel.resourceType == HICHtmlType){
            self.leftImageView.image = [UIImage imageNamed:@"知识类型-文档-HTML"];
        }else if(self.courseModel.resourceType == HICScromType){
            self.leftImageView.image = [UIImage imageNamed:@"知识类型-文档-scorm"];
        }else if (self.courseModel.resourceType == HICZipType){
            self.leftImageView.image = [UIImage imageNamed:@"知识类型-压缩包"];
        }else if(self.courseModel.resourceType == HICVideoType ){
            self.leftImageView.image = [UIImage imageNamed:@"知识类型-视频"];
        }else if(self.courseModel.resourceType == HICPictureType ){
            self.leftImageView.image = [UIImage imageNamed:@"知识类型-图片"];
        } else if (self.courseModel.resourceType == HICWebVideoType) {
            self.leftImageView.image = [UIImage imageNamed:@"知识课程默认图标"];
        } else {//文档
            if ([self.courseModel.suffixName isEqualToString:@"xls"] || [self.courseModel.suffixName isEqualToString:@"xlsx"]) {
                self.leftImageView.image = [UIImage imageNamed:@"知识类型-文档-XLS"];
            }else if ([self.courseModel.suffixName isEqualToString:@"doc"] || [self.courseModel.suffixName isEqualToString:@"docx"]){
                self.leftImageView.image = [UIImage imageNamed:@"知识类型-文档-WORD"];
            }else if ([self.courseModel.suffixName isEqualToString:@"ppt"] || [self.courseModel.suffixName isEqualToString:@"pptx"]){
                self.leftImageView.image = [UIImage imageNamed:@"知识类型-文档-PPT"];
            }else if ([self.courseModel.suffixName isEqualToString:@"pdf"] || [self.courseModel.suffixName isEqualToString:@"PDF"]){
                self.leftImageView.image = [UIImage imageNamed:@"知识类型-文档-PDF"];
            }else{
                self.leftImageView.image = [UIImage imageNamed:@"知识类型-文档-PPS"];
            }
        }
    }
    self.nameLabel.text = self.courseModel.courseKLDName;
    self.scoreLabel.text = [NSString stringWithFormat:@"%@:%@",NSLocalizableString(@"credits", nil),self.courseModel.credit];
    self.timeLabel.text = [NSString stringWithFormat:@"%@:%ld/%ld%@",NSLocalizableString(@"studyTime", nil),(long)self.courseModel.creditHoursUsed,(long)self.courseModel.creditHours,NSLocalizableString(@"minutes", nil)];
    if ([[NSString stringWithFormat:@"%ld",(long)self.courseModel.creditHours] isEqualToString:@"<null>"]) {
        self.progressView.progress = 1;
        self.percentLabel.text = @"100%";
    }else{
        self.progressView.progress = [[HICCommonUtils formatFloatDivision:self.recordModel.learnningDuration andDenominator:self.recordModel.creditHours] floatValue] / 100;
           self.percentLabel.text = [NSString stringWithFormat:@"%@:%@", NSLocalizableString(@"haveToLearn", nil),[HICCommonUtils formatFloatDivision:self.recordModel.learnningDuration andDenominator:self.recordModel.creditHours]];
    }
}
- (void)createUI{
    self.leftView = [[UIView alloc]init];
    self.leftView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    [self.contentView addSubview:self.leftView];
    
    self.leftImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"知识类型-考试"]];
    [self.leftView addSubview:self.leftImageView];
    
    self.progressView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
    self.progressView.progress = 0.8f;
    self.progressView.progressTintColor = [UIColor colorWithHexString:@"#00BED7"];
    self.progressView.layer.cornerRadius  = 2.5;
    self.progressView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.progressView];
    
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.textColor = TEXT_COLOR_DARK;
    self.nameLabel.font = FONT_MEDIUM_15;
    self.nameLabel.numberOfLines = 1;
    //       self.nameLabel.text = self.courseModel.courseKLDName;
    self.nameLabel.text = NSLocalizableString(@"IndividualKnowledgeHeadings", nil);
    self.nameLabel.lineBreakMode = NSLineBreakByTruncatingTail |NSLineBreakByWordWrapping;
    [self.contentView addSubview:self.nameLabel];
    
    self.scoreLabel = [[UILabel alloc]init];
    self.scoreLabel.textColor = TEXT_COLOR_LIGHT;
    self.scoreLabel.font = FONT_REGULAR_13;
    self.scoreLabel.text = [NSString stringWithFormat:@"%@0/2.0",NSLocalizableString(@"credits", nil)];
    [self.contentView addSubview:self.scoreLabel];
    
    self.timeLabel = [[UILabel alloc]init];
    self.timeLabel.textColor = TEXT_COLOR_LIGHT;
    self.timeLabel.font = FONT_REGULAR_13;
    self.timeLabel.text = [NSString stringWithFormat:@"%@0/10%@",NSLocalizableString(@"studyTime", nil),NSLocalizableString(@"minutes", nil)];
    [self.contentView addSubview:self.timeLabel];
    
    self.percentLabel = [[UILabel alloc]init];
    self.percentLabel.textColor = TEXT_COLOR_LIGHTS;
    self.percentLabel.font = FONT_REGULAR_13;
    self.percentLabel.text = [NSString stringWithFormat:@"%@80%%",NSLocalizableString(@"haveToLearn", nil)];
    [self.contentView addSubview:self.percentLabel];
    self.line = [[UIView alloc]init];
    self.line.backgroundColor = [UIColor colorWithHexString:@"#E6E6E6"];
    [self.contentView addSubview:self.line];
}
- (void)updateConstraints {
    [super updateConstraints];
    [self.leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(16);
        make.top.equalTo(self.contentView).offset(16);
        make.width.offset(72);
        make.height.offset(72);
    }];
    [self.leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftView).offset(16);
        make.top.equalTo(self.leftView).offset(16);
        make.width.offset(40);
        make.height.offset(40);
    }];
   
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftView.mas_right).offset(12);
        make.top.equalTo(self.leftView);
        make.width.offset(259);
        make.height.offset(21);
    }];
    [self.scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(2);
        make.left.equalTo(self.nameLabel);
//        make.width.offset(110);
        make.height.offset(18);
    }];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
           make.top.equalTo(self.scoreLabel.mas_bottom).offset(20);
           make.left.equalTo(self.nameLabel);
           make.height.offset(5);
           make.width.offset(72);
       }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(2);
        make.left.equalTo(self.scoreLabel.mas_right).offset(12);
        make.height.offset(18);
    }];
    [self.percentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.progressView.mas_right).offset(5);
        make.top.equalTo(self.scoreLabel.mas_bottom).offset(12);
    }];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scoreLabel);
        make.bottom.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.height.offset(0.5);
    }];
}
@end
