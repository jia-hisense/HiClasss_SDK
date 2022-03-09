//
//  HICIndexViewCell.m
//  HiClass
//
//  Created by WorkOffice on 2020/2/4.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICIndexViewCell.h"
#import "HICCourseListModel.h"
#import "HICExamBaseInfoModel.h"
#import "HICCourseExamInfoModel.h"
#import "HICCourseModel.h"
#import "HICMediaInfoModel.h"
#import "HICExamControlModel.h"
@interface HICIndexViewCell()
@property (nonatomic, strong)UILabel *chapterNameLabel;
@property (nonatomic, strong)UILabel *progressLabel;
@property (nonatomic, strong)UIButton *extensionbutton;
@property (nonatomic, strong)UIView *lineView;
@property (nonatomic, strong)UIView *chapterView;
@property (nonatomic, strong)UIView *cellContent;
@property (nonatomic, strong)UIView *cellExtensionView;
@property (nonatomic, strong)UIProgressView *progressView;
@property (nonatomic ,strong)UIView *leftView;
@property (nonatomic ,strong)UIImageView *leftImageView;
@property (nonatomic, strong)UILabel *nameLabel;
@property (nonatomic, strong)UILabel *scoreLabel;
@property (nonatomic, strong)UILabel *timeLabel;
@property (nonatomic, strong)UILabel *percentLabel;
@property (nonatomic ,strong)UIView *leftDView;
@property (nonatomic ,strong)UIImageView *leftDImageView;
@property (nonatomic, strong)UILabel *nameDLabel;
@property (nonatomic, strong)UILabel *examTimelabel;
@property (nonatomic, strong)UILabel *examTimeslabel;
@property (nonatomic, strong)NSIndexPath *cellIndexPath;
@property (nonatomic, strong)NSArray *courseList;
@property (nonatomic,strong)HICCourseExamInfoModel *examModel;
@property (nonatomic, strong)HICCourseModel *courseModel;
@property (nonatomic, strong)HICBaseInfoModel *baseModel;
@property (nonatomic, strong)UIView *konwladgeView;
@property (nonatomic, strong)UIView *examView;
//@property (nonatomic, strong)UIView * cellContentView;
@property (nonatomic, assign)CGFloat cellheight;
@property (nonatomic,strong)NSNumber *sectionId;
@property (nonatomic ,strong)HICExamControlModel *controlModel;
@end
@implementation HICIndexViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    [super awakeFromNib];
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
        self.courseList = [NSArray new];
        self.backgroundColor = UIColor.whiteColor;
        [self updateConstraintsIfNeeded];
    }
    return self;
}
- (void)createUI{
    self.chapterNameLabel = [[UILabel alloc]init];
    self.chapterNameLabel.textColor = TEXT_COLOR_DARK;
    self.chapterNameLabel.font = FONT_MEDIUM_16;
    self.chapterNameLabel.lineBreakMode = NSLineBreakByTruncatingTail |NSLineBreakByWordWrapping;
    self.lineView = [[UIView alloc]init];
    self.lineView.backgroundColor = DEVIDE_LINE_COLOR;
    //    [self.contentView addSubview:self.chapterNameLabel];
    self.progressLabel = [[UILabel alloc]init];
    self.progressLabel.textColor = TEXT_COLOR_LIGHTM;
    self.progressLabel.font = FONT_REGULAR_14;
    //    [self.contentView addSubview:self.progressLabel];
    //    CGFloat space = 5;// 图片和文字的间距
    UIImage * btnImageup = [UIImage imageNamed:@"箭头-章节收起"];
    UIImage * btnImagedown = [UIImage imageNamed:@"箭头-章节展开"];
    //    NSString *titleString = NSLocalizableString(@"develop", nil);
    //    CGFloat titleWidth = [titleString sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}].width;
    //    CGFloat imageWidth = btnImageup.size.width;
    //    CGFloat btnWidth = 50;// 按钮的宽度
    //    if (titleWidth > btnWidth - imageWidth - space) {
    //        titleWidth = btnWidth- imageWidth - space;
    //    }
    self.extensionbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.extensionbutton setImage:btnImagedown forState:UIControlStateNormal];
    [self.extensionbutton setImage:btnImageup forState:UIControlStateSelected];
    [self.extensionbutton setTitleColor:TEXT_COLOR_LIGHTM forState:UIControlStateNormal];
    //    [self.extensionbutton setTitle:NSLocalizableString(@"develop", nil) forState:UIControlStateNormal];
    //    [self.extensionbutton setTitle:@"收起" forState:UIControlStateSelected];
    //    [self.extensionbutton hicChangeButtonClickLength:30];
    [self.extensionbutton addTarget:self action:@selector(btnClickExtension) forControlEvents:UIControlEventTouchUpInside];
    //    self.extensionbutton.titleLabel.font = FONT_REGULAR_14;
    //    [self.extensionbutton setTitleEdgeInsets:UIEdgeInsetsMake(0, -(imageWidth+space*0.5), 0,(imageWidth+space*0.5))];
    //    [self.extensionbutton setImageEdgeInsets:UIEdgeInsetsMake(0, (titleWidth + space*0.5), 0, -(titleWidth + space*0.5))];
    //    [self.contentView addSubview:self.extensionbutton];
    UIView *maskView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, HIC_ScreenWidth, 66)];
    maskView.backgroundColor = UIColor.clearColor;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(btnClickExtension)];
    [maskView addGestureRecognizer:tap];
    maskView.userInteractionEnabled = YES;
    [maskView addSubview:self.extensionbutton];
    [maskView addSubview:self.progressLabel];
    [maskView addSubview:self.chapterNameLabel];
    [maskView addSubview:self.lineView];
    [self.contentView addSubview:maskView];
    maskView.tag = 10000;
    self.cellContent = [[UIView alloc]init];
    [self.contentView addSubview:self.cellContent];
}
- (void)setIsfirst:(BOOL)isFirst andCellIndex:(NSIndexPath *)indexPath andModel:(HICKldSectionLIstModel *)kldModel andShowContent:(BOOL)isShowContent{
    self.cellIndexPath = indexPath;
    self.chapterNameLabel.text = kldModel.name;
    self.sectionId = kldModel.chapterId;
    NSArray *arr = [kldModel.learningRate componentsSeparatedByString:@"/"];
    if (arr.count  == 2) {
        if (![arr[1] isEqualToString:@"0"]) {
            NSInteger rate = [arr[0] integerValue] * 100 / [arr[1] integerValue];
            self.progressLabel.text = [NSString stringWithFormat:@"%@: %ld%@",NSLocalizableString(@"learningProcess", nil),(long)rate,@"%"];
        }else{
            self.progressLabel.text = [NSString stringWithFormat:@"%@: 0%@",NSLocalizableString(@"learningProcess", nil),@"%"];
        }
    }
   
    self.courseList = kldModel.courseList;
    if (self.cellContent.subviews.count > 0) {
        [self.cellContent removeFromSuperview];
        self.cellContent = [UIView new];
        [self.contentView addSubview:self.cellContent];
    }
    self.cellContent.hidden = !isShowContent;
    self.extensionbutton.selected = isShowContent;
    if (isShowContent) {
        [self addCellView];
    }else {
        for (UIView *view in self.cellContent.subviews) {
            [view removeFromSuperview];
        }
    }
}

- (void)addCellView{
    self.cellContent.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    
    self.cellheight = 0;
    CGFloat startHeight = 0;
    CGFloat courseY = 0;
    CGFloat examY = 0;
    for (int i = 0; i < self.courseList.count; i ++) {
        startHeight = self.cellheight;
        if ([HICCommonUtils isValidObject:self.courseList[i][@"courseInfo"]]) {
            self.baseModel = [HICBaseInfoModel mj_objectWithKeyValues:self.courseList[i][@"courseInfo"]];
            courseY = self.cellheight;
            if (i == 0 && i == self.courseList.count - 1) {
                self.cellheight += 96 + 8;
            }else if(i == 0 || i == self.courseList.count - 1){
               self.cellheight += 96;
            }else{
                self.cellheight += 88;
            }
        }else{
            self.baseModel = nil;
        }
        if ([HICCommonUtils isValidObject:self.courseList[i][@"examInfo"]]) {
            self.examModel = [HICCourseExamInfoModel mj_objectWithKeyValues:self.courseList[i][@"examInfo"][@"baseInfo"]];
            self.controlModel = [HICExamControlModel mj_objectWithKeyValues:self.courseList[i][@"examInfo"][@"controlParams"]];
            examY = self.cellheight;
            if (i == 0 && i == self.courseList.count - 1) {
                self.cellheight += 96 + 8;
            }else if(i == 0 || i == self.courseList.count - 1){
               self.cellheight += 96;
            }else{
                self.cellheight += 88;
            }
        }else{
            self.examModel = nil;
        }
        NSString *rateStr;
        if ([NSString isValidStr: self.courseList[i][@"learningRate"]]) {
            rateStr = self.courseList[i][@"learningRate"];
        }
        [self createCellView:i andCourseExamModel:self.examModel andCourseModel:self.baseModel andRate:(NSString *)rateStr andCourseY:(CGFloat)courseY andExamY:(CGFloat)examY andCellHeight:(CGFloat)self.cellheight];
    }
    [self.cellContent setFrame:CGRectMake(0, 66, HIC_ScreenWidth, self.cellheight)];
    
}
- (void)createCellView:(NSInteger)index andCourseExamModel:(HICCourseExamInfoModel *)examModel andCourseModel:(HICBaseInfoModel *)courseModel andRate:(NSString *)rateStr andCourseY:(CGFloat)courseY andExamY:(CGFloat)examY andCellHeight:(CGFloat)cellheight{
    CGFloat marginTop;
    CGFloat viewHeight;
    if (index == 0) {
        marginTop = 16.0;
    }else{
        marginTop = 8.0;
    }
    if (index == 0 || index + 1== self.courseList.count) {
        viewHeight = 88 + 8;
    }else{
        viewHeight = 88;
    }
    
    if ([HICCommonUtils isValidObject:courseModel]) {
        UIView *cellContentView = [[UIView alloc]initWithFrame:CGRectMake(0,courseY, HIC_ScreenWidth, cellheight - courseY)];
        [self.cellContent addSubview:cellContentView];
        [cellContentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        self.konwladgeView = [[UIView alloc]initWithFrame:CGRectMake(0, courseY, HIC_ScreenWidth, viewHeight)];
        self.konwladgeView.tag = index;
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(contentViewClick:)];
        [self.konwladgeView addGestureRecognizer:tap1];
        [self.cellContent addSubview:self.konwladgeView];
        self.leftView = [[UIView alloc]init];
        self.leftView.backgroundColor = [UIColor whiteColor];
        [cellContentView addSubview:self.leftView];
        
        [self.leftView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cellContentView).offset(16);
            make.top.equalTo(cellContentView).offset(marginTop);
            make.width.offset(72);
            make.height.offset(72);
        }];
        self.leftImageView = [[UIImageView alloc]init];
        [self.leftView addSubview:self.leftImageView];
        [self.leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.leftView).offset(16);
            make.top.equalTo(self.leftView).offset(16);
            make.width.offset(40);
            make.height.offset(40);
        }];
        self.nameLabel = [[UILabel alloc]init];
        self.nameLabel.textColor = TEXT_COLOR_DARK;
        self.nameLabel.font = FONT_MEDIUM_15;
        self.nameLabel.numberOfLines = 1;
        self.nameLabel.lineBreakMode = NSLineBreakByTruncatingTail |NSLineBreakByWordWrapping;
        [cellContentView addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.leftView.mas_right).offset(12);
            make.top.equalTo(self.leftView);
            make.width.offset(259);
            make.height.offset(21);
        }];
        self.scoreLabel = [[UILabel alloc]init];
        self.scoreLabel.textColor = TEXT_COLOR_LIGHT;
        self.scoreLabel.font = FONT_REGULAR_13;
        [cellContentView addSubview:self.scoreLabel];
        [self.scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nameLabel.mas_bottom);
            make.left.equalTo(self.nameLabel);
//            make.width.offset(100);
            make.height.offset(18);
        }];
        self.timeLabel = [[UILabel alloc]init];
        self.timeLabel.textColor = TEXT_COLOR_LIGHT;
        self.timeLabel.font = FONT_REGULAR_13;
        [cellContentView addSubview:self.timeLabel];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nameLabel.mas_bottom);
            make.left.equalTo(self.scoreLabel.mas_right).offset(12);
            make.height.offset(18);
        }];
        self.progressView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
        self.progressView.progressTintColor = [UIColor colorWithHexString:@"#00BED7"];
        self.progressView.backgroundColor = [UIColor colorWithHexString:@"#e9e9e9"];
        self.progressView.layer.cornerRadius = 2.5;
        self.progressView.clipsToBounds = YES;
        
        [cellContentView addSubview:self.progressView];
        [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel);
            make.top.equalTo(self.scoreLabel.mas_bottom).offset(17.5);
            make.height.offset(5);
            make.width.offset(72);
        }];
        self.percentLabel = [[UILabel alloc]init];
        self.percentLabel.textColor = TEXT_COLOR_LIGHTS;
        self.percentLabel.font = FONT_REGULAR_13;
        [cellContentView addSubview:self.percentLabel];
        [self.percentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.progressView.mas_right).offset(2);
            make.top.equalTo(self.scoreLabel.mas_bottom).offset(12);
            make.width.offset(100);
            make.height.offset(17);
        }];
        if (courseModel.resourceType == HICAudioType) {
            self.leftImageView.image = [UIImage imageNamed:@"知识类型-音频"];
        }else if (courseModel.resourceType == HICHtmlType){
            self.leftImageView.image = [UIImage imageNamed:@"知识类型-文档-HTML"];
        }else if(courseModel.resourceType == HICScromType){
            self.leftImageView.image = [UIImage imageNamed:@"知识类型-文档-scorm"];
        }else if (courseModel.resourceType == HICZipType){
            self.leftImageView.image = [UIImage imageNamed:@"知识类型-压缩包"];
        }else if(courseModel.resourceType == HICVideoType){
            self.leftImageView.image = [UIImage imageNamed:@"知识类型-视频"];
        }else if(courseModel.resourceType == HICPictureType){
            self.leftImageView.image = [UIImage imageNamed:@"知识类型-图片"];
        } else if(courseModel.resourceType == HICWebVideoType) {
            self.leftImageView.image = [UIImage imageNamed:@"知识课程默认图标"];
        } else {//文档
            HICMediaInfoModel *mediaModel = [HICMediaInfoModel mj_objectWithKeyValues:courseModel.mediaInfoList[0]];
            if (mediaModel.type == 3) {
                if ([mediaModel.suffixName isEqualToString:@"xls"] || [mediaModel.suffixName isEqualToString:@"xlsx"]) {
                    self.leftImageView.image = [UIImage imageNamed:@"知识类型-文档-XLS"];
                }else if ([mediaModel.suffixName isEqualToString:@"doc"] || [mediaModel.suffixName isEqualToString:@"docx"]){
                    self.leftImageView.image = [UIImage imageNamed:@"知识类型-文档-WORD"];
                }else if ([mediaModel.suffixName isEqualToString:@"ppt"] || [mediaModel.suffixName isEqualToString:@"pptx"]){
                    self.leftImageView.image = [UIImage imageNamed:@"知识类型-文档-PPT"];
                }else if ([mediaModel.suffixName isEqualToString:@"pdf"] || [mediaModel.suffixName isEqualToString:@"PDF"]){
                    self.leftImageView.image = [UIImage imageNamed:@"知识类型-文档-PDF"];
                }else{
                    self.leftImageView.image = [UIImage imageNamed:@"知识类型-文档-PPS"];
                }
            }else{
                self.leftImageView.image = [UIImage imageNamed:@"知识课程默认图标"];
            }
        }
        self.nameLabel.text = courseModel.name;
        self.scoreLabel.text = [NSString stringWithFormat:@"%@: %@",NSLocalizableString(@"credits", nil),courseModel.credit];
        self.timeLabel.text = [NSString stringWithFormat:@"%@: %ld/%ld",NSLocalizableString(@"studyTime", nil),(long)courseModel.creditHoursUsed,(long)courseModel.creditHours];
        if ([NSString isValidStr:rateStr]) {
            NSString *temp = [rateStr substringToIndex:rateStr.length - 1];
            self.progressView.progress = temp.floatValue / 100;
            self.percentLabel.text = rateStr;
        }else{
            self.progressView.progress = 0;
            self.percentLabel.text = [NSString stringWithFormat:@"0%@",@"%"];
        }
        
    }
    if ([HICCommonUtils isValidObject:examModel]) {
        UIView *cellContentView = [[UIView alloc]initWithFrame:CGRectMake(0,examY, HIC_ScreenWidth, cellheight - examY)];
        [self.cellContent addSubview:cellContentView];
        [cellContentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        self.examView = [[UIView alloc]initWithFrame:CGRectMake(0, examY, HIC_ScreenWidth, viewHeight)];
        self.examView.backgroundColor = UIColor.clearColor;
        self.examView.tag = index + 1909090;
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(examViewClick:)];
        [self.examView addGestureRecognizer:tap2];
        [self.cellContent addSubview:self.examView];
        self.leftDView = [[UIView alloc]init];
        self.leftDView.backgroundColor = [UIColor whiteColor];
        [cellContentView addSubview:self.leftDView];
        [self.leftDView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cellContentView).offset(16);
            make.top.equalTo(cellContentView).offset(marginTop);
            make.width.offset(72);
            make.height.offset(72);
        }];
        self.leftDImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"知识类型-考试"]];
        [self.leftDView addSubview:self.leftDImageView];
        [self.leftDImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.leftDView).offset(16);
            make.top.equalTo(self.leftDView).offset(16);
            make.width.offset(40);
            make.height.offset(40);
        }];
        self.nameDLabel = [[UILabel alloc]init];
        self.nameDLabel.textColor = TEXT_COLOR_DARK;
        self.nameDLabel.font = FONT_MEDIUM_15;
        self.nameDLabel.numberOfLines = 1;
        
        //       self.nameDLabel.text = @"单个知识标题";
        self.nameDLabel.lineBreakMode = NSLineBreakByTruncatingTail |NSLineBreakByWordWrapping;
        [cellContentView addSubview:self.nameDLabel];
        [self.nameDLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.leftDView.mas_right).offset(12);
            make.top.equalTo(self.leftDView);
            make.width.offset(259);
            make.height.offset(21);
        }];
        self.examTimelabel = [[UILabel alloc]init];
        self.examTimelabel.textColor = TEXT_COLOR_LIGHT;
        self.examTimelabel.font = FONT_REGULAR_13;
        
        [cellContentView addSubview:self.examTimelabel];
        [self.examTimelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nameDLabel.mas_bottom).offset(14);
            make.left.equalTo(self.nameDLabel);
        }];
        self.examTimeslabel = [[UILabel alloc]init];
        self.examTimeslabel.textColor = TEXT_COLOR_LIGHT;
        self.examTimeslabel.font = FONT_REGULAR_13;
        
        [cellContentView addSubview:self.examTimeslabel];
        [self.examTimeslabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.examTimelabel);
            make.top.equalTo(self.examTimelabel.mas_bottom);
        }];
        self.nameDLabel.text = examModel.name;
        self.examTimeslabel.text = [NSString stringWithFormat:@"%@: %@",NSLocalizableString(@"numberOfTestsAvailable", nil),self.controlModel.allowTimes > 0 ? [NSString stringWithFormat:@"%ld",(long)self.examModel.times]:NSLocalizableString(@"unlimited", nil)];
        self.examTimelabel.text = [NSString stringWithFormat:@"%@: %@",NSLocalizableString(@"startTextTime", nil),[HICCommonUtils returnReadableTimeZoneWithStartTime:self.controlModel.joinStartTime andEndTime:self.controlModel.joinEndTime]];
    }
    [self.chapterView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
    
}
- (void)examViewClick:(UITapGestureRecognizer *)tap{
    NSInteger index = tap.view.tag - 1909090;
     HICExamBaseInfoModel *model = [HICExamBaseInfoModel mj_objectWithKeyValues:self.courseList[index][@"examInfo"][@"baseInfo"]];
    if (self.extensionDelegate && [self.extensionDelegate respondsToSelector:@selector(jumpExam:andStatus:andIndexPath:andIndex:)]) {
        [self.extensionDelegate jumpExam:model.examID andStatus:model.status andIndexPath:self.cellIndexPath andIndex:index];
    }
    
}
- (void)contentViewClick:(UITapGestureRecognizer *)tap{
    NSInteger index = tap.view.tag;
    if (self.extensionDelegate && [self.extensionDelegate respondsToSelector:@selector(jumpKnowledge:andSectionId:andIndexPath:andIndex:)]) {
        HICBaseInfoModel *model = [HICBaseInfoModel mj_objectWithKeyValues:self.courseList[index][@"courseInfo"]];
        [self.extensionDelegate jumpKnowledge:model andSectionId:self.sectionId andIndexPath:self.cellIndexPath andIndex:index];
    }
}
- (void)btnClickExtension{
    self.extensionbutton.selected = !self.extensionbutton.selected;
    self.cellContent.hidden = !self.extensionbutton.selected;
    CGFloat startHeight = 66;
    for (int i = 0; i < self.courseList.count; i ++) {
        if ([HICCommonUtils isValidObject:self.courseList[i][@"courseInfo"]]) {
            self.baseModel = [HICBaseInfoModel mj_objectWithKeyValues:self.courseList[i][@"courseInfo"]];
            startHeight += 88;
        }
        if ([HICCommonUtils isValidObject:self.courseList[i][@"examInfo"]]) {
            self.examModel = [HICCourseExamInfoModel mj_objectWithKeyValues:self.courseList[i][@"examInfo"][@"baseInfo"]];
            startHeight += 88;
        }
    }
    if (self.extensionDelegate && [self.extensionDelegate respondsToSelector:@selector(clickExtension:andIndex:andShowContent:)]) {
        if (self.cellContent.hidden) {
            [self.extensionDelegate clickExtension:66 andIndex:self.cellIndexPath andShowContent:NO];
            //            [self.cellContent removeFromSuperview];
        }else{
            [self.extensionDelegate clickExtension:self.courseList.count > 0?startHeight + 16:66  andIndex:self.cellIndexPath andShowContent:YES];
        }
    }
}

- (void)updateConstraints {
    [super updateConstraints];
    [self.chapterNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(12);
        make.left.equalTo(self.contentView).offset(16);
        make.width.offset(272);
    }];
    [self.progressLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.chapterNameLabel.mas_bottom);
        make.left.equalTo(self.contentView).offset(16);
    }];
    
    [self.extensionbutton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(23);
        make.right.equalTo(self.contentView).offset(-20);
        make.height.offset(22);
        make.width.offset(22);
    }];
    [self.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.offset(HIC_ScreenWidth);
        make.height.offset(0.5);
        make.top.equalTo(self.contentView).offset(65.5);
    }];
    [self.chapterView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.offset(HIC_ScreenWidth);
        make.top.equalTo(self.progressLabel.mas_bottom).offset(12);
    }];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
