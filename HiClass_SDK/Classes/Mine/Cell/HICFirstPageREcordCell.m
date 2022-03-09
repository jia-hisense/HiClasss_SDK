//
//  HICFirstPageREcordCell.m
//  HiClass
//
//  Created by WorkOffice on 2020/3/16.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICFirstPageREcordCell.h"
#import "HICCourseModel.h"
@interface HICFirstPageREcordCell()
@property (nonatomic ,strong)UIImageView *coverImage;
@property (nonatomic ,strong)UILabel *nameLabel;
@property (nonatomic ,strong)UIProgressView *progressView;
//@property (nonatomic ,strong)UILabel *progressLabel;
@end
@implementation HICFirstPageREcordCell
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}
-(void) createUI{
    self.contentView.backgroundColor = UIColor.whiteColor;
    self.coverImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 130, 73)];
    self.coverImage.layer.cornerRadius = 4;
    self.coverImage.clipsToBounds = YES;
    [self.contentView addSubview:self.coverImage];
    self.coverImage.backgroundColor = UIColor.lightGrayColor;
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 81, 130, 13)];
    self.nameLabel.font = FONT_REGULAR_13;
    self.nameLabel.textColor = TEXT_COLOR_DARK;
    [self.contentView addSubview:self.nameLabel];
    self.progressView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
    self.progressView.frame = CGRectMake(0, 70, 130, 3);
    self.progressView.layer.cornerRadius = 1.5;
    self.progressView.clipsToBounds = YES;
    self.progressView.progressTintColor = [UIColor colorWithHexString:@"#00BED7"];
    [self.contentView addSubview:self.progressView];
//    self.progressLabel = [[UILabel alloc]initWithFrame:CGRectMake(77, 102, 58, 17)];
//    self.progressLabel.textColor = TEXT_COLOR_LIGHTS;
//    self.progressLabel.font = FONT_REGULAR_12;
//    [self.contentView addSubview:self.progressLabel];
}
-(void)setModel:(HICMyRecordModel *)model{
    HICCourseModel *courseModel = [HICCourseModel mj_objectWithKeyValues:model.courseKLDInfo];
    self.nameLabel.text = courseModel.courseKLDName;
    if (courseModel.coverPic) {
        [self.coverImage sd_setImageWithURL:[NSURL URLWithString:courseModel.coverPic]];
    }else {
        self.coverImage.image = nil;
    }

        self.progressView.progress = [[HICCommonUtils formatFloatDivision:model.learnningDuration andDenominator:model.creditHours] floatValue]/100;
    [self.progressView mas_updateConstraints:^(MASConstraintMaker *make) {
          make.height.offset(5);
          make.width.offset(130);
          make.left.equalTo(self.contentView).offset(1);
          make.top.equalTo(self.contentView).offset(108);
      }];
//    self.progressLabel.text = [HICCommonUtils formatFloatDivision:model.learnningDuration andDenominator:model.creditHours];
}
@end
