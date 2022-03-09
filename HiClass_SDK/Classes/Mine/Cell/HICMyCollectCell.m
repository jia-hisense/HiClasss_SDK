//
//  HICMyCollectCell.m
//  HiClass
//
//  Created by WorkOffice on 2020/2/20.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICMyCollectCell.h"
#import "HICCourseModel.h"
@interface HICMyCollectCell()
@property (nonatomic ,strong)UIImageView *leftView;
@property (nonatomic ,strong)UILabel *nameLabel;
@property (nonatomic ,strong)UILabel *numLabel;
@property (nonatomic ,strong)UILabel *scoreLabel;
@property (nonatomic ,strong)UILabel *timeLabel;
@property (nonatomic ,strong)HICMyCollectModel *collectModel;
@property (nonatomic ,strong)HICCourseModel *courseModel;
@property (nonatomic ,assign)CGFloat mariginLeft;
@property (nonatomic, strong) UIButton *checkIV;
//@property (nonatomic, strong) UIImageView *checkIV;
@property (nonatomic ,strong)NSIndexPath *indexPath;
@property (nonatomic ,strong)UIView *line;
@end
@implementation HICMyCollectCell
-(HICMyCollectModel *)collectModel{
    if (!_collectModel) {
        _collectModel =  [[HICMyCollectModel alloc]init];
    }
    return _collectModel;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    [super awakeFromNib];
     if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
        [self updateConstraintsIfNeeded];
       }
    return self;
}

- (void)createUI{
    self.mariginLeft = 16.0;
//    self.checkIV = [[UIImageView alloc] init];
////    [self.checkBackView addSubview: _checkIV];
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapSelected)];
//    [self.checkIV addGestureRecognizer:tap];
//    _checkIV.image = [UIImage imageNamed:@"未选择"];
//    _checkIV.hidden = YES;
//    _checkIV.userInteractionEnabled = YES;
    self.checkIV = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.checkIV setImage:[UIImage imageNamed:@"未选择"] forState:UIControlStateNormal];
    [self.checkIV setImage:[UIImage imageNamed:@"勾选"] forState:UIControlStateSelected];
    [self.checkIV addTarget:self action:@selector(tapSelected) forControlEvents:UIControlEventTouchUpInside];
    [self.checkIV hicChangeButtonClickLength:35];
    [self.contentView addSubview:self.checkIV];
    
    self.timeLabel = [[UILabel alloc]init];
    self.timeLabel.textColor = TEXT_COLOR_LIGHTM;
    self.timeLabel.font = FONT_MEDIUM_13;
    self.timeLabel.text = @"2019-01-18  14:20";
    
    [self.contentView addSubview:self.timeLabel];
    self.leftView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@""]];
    self.leftView.backgroundColor = [UIColor colorWithHexString:@"e6e6e6"];
    [self.contentView addSubview:self.leftView];
    
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.textColor = TEXT_COLOR_DARK;
    self.nameLabel.font = FONT_MEDIUM_15;
    self.nameLabel.numberOfLines = 2;
    self.nameLabel.text = @"课程名称心理学培训课-普通气昂昂奥奥奥奥奥奥奥奥奥奥奥";
    [self.contentView addSubview:self.nameLabel];
    
    self.scoreLabel = [[UILabel alloc]init];
    self.scoreLabel.text = [NSString stringWithFormat:@"4.5%@",NSLocalizableString(@"points", nil)];
    self.scoreLabel.textColor = TEXT_COLOR_LIGHTM;
    self.scoreLabel.font = FONT_REGULAR_13;
    [self.contentView addSubview:self.scoreLabel];
    
    self.numLabel = [[UILabel alloc]init];
    self.numLabel.textColor = TEXT_COLOR_LIGHTM;
    self.numLabel.font = FONT_REGULAR_13;
    self.numLabel.text = [NSString stringWithFormat:@"120%@",NSLocalizableString(@"haveToLearn", nil)];
    [self.contentView addSubview:self.numLabel];
    self.line = [[UIView alloc]init];
    self.line.backgroundColor = [UIColor colorWithHexString:@"e6e6e6"];
    [self.contentView addSubview:self.line];
}
- (void)setModel:(HICMyCollectModel *)model andIndexPath:(NSIndexPath *)indexPath andIsEdit:(BOOL)isEdit andIsChecked:(BOOL)isChecked{
    self.collectModel = model;
      self.courseModel = [HICCourseModel mj_objectWithKeyValues:self.collectModel.courseKLDInfo];
      self.timeLabel.text = [HICCommonUtils timeStampToReadableDate:self.collectModel.updateTime isSecs:YES format:@"yyyy-MM-dd HH:mm"];
      [self.leftView sd_setImageWithURL:[NSURL URLWithString:self.courseModel.coverPic]];
      self.nameLabel.text = self.courseModel.courseKLDName;
    self.scoreLabel.text = [NSString stringWithFormat:@"%ld%@",(long)self.courseModel.score,NSLocalizableString(@"points", nil)];
    self.numLabel.text = [NSString stringWithFormat:@"%ld%@",(long)self.courseModel.learnersNum,NSLocalizableString(@"peopleHaveToLearn", nil)];
    
    if (isEdit) {
           self.mariginLeft = 48.0;
           self.checkIV.hidden = NO;
       }else{
           self.mariginLeft = 16.0;
           self.checkIV.hidden = YES;
       }
    self.indexPath = indexPath;
    self.checkIV.selected = isChecked;
//    if (isChecked) {
//        self.checkIV.image = [UIImage imageNamed:@"勾选"];
//    }else{
//        self.checkIV.image = [UIImage imageNamed:@"未选择"];
//    }
    [self updateConstraints];
}
- (void)tapSelected{
    if (self.collectDelegate && [self.collectDelegate respondsToSelector:@selector(checkIndex:)]) {
        [self.collectDelegate checkIndex:self.indexPath];
    }
}
- (void)updateConstraints {
    [super updateConstraints];
    [self.timeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(12);
        make.left.equalTo(self.contentView).offset(self.mariginLeft - 3.5);
    }];
    [self.leftView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(self.mariginLeft);
        make.top.equalTo(self.timeLabel.mas_bottom).offset(6);
        make.width.offset(130);
        make.height.offset(73);
    }];
    [self.checkIV mas_updateConstraints:^(MASConstraintMaker *make) {
              make.left.equalTo(self.contentView).offset(12);
              make.top.equalTo(self.leftView).offset(13);
              make.width.offset(24);
              make.height.offset(24);
    }];
    [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftView.mas_right).offset(12);
        make.top.equalTo(self.leftView);
        make.right.equalTo(self.contentView).offset(-16);
    }];
    [self.scoreLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.width.offset(32.5);
        make.bottom.equalTo(self.leftView.mas_bottom);
    }];
    [self.numLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scoreLabel.mas_right).offset(8);
        make.width.offset(100);
        make.bottom.equalTo(self.leftView.mas_bottom);
    }];
    [self.line mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(self.mariginLeft);
        make.right.equalTo(self.contentView);
        make.height.offset(0.5);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-0.5);
    }];
}

@end
