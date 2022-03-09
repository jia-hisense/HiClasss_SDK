//
//  HICLessonContentCell.m
//  HiClass
//
//  Created by WorkOffice on 2020/2/4.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICLessonContentCell.h"
#import "HICAuthorCustomerModel.h"
@interface HICLessonContentCell()
@property(nonatomic ,strong)UILabel *titleLabel;
@property(nonatomic ,strong)UILabel *scoreLabel;
@property(nonatomic ,strong)UILabel *timeLabel;
@property(nonatomic ,strong)UILabel *targetLabel;
@property(nonatomic ,strong)UIView *lineView;
@property(nonatomic ,strong)UILabel *authorTitleLabel;
@property(nonatomic ,strong)UILabel *authorLabel;
@property(nonatomic ,strong)UILabel *positionLabel;
@property(nonatomic ,strong)UIButton *arrowBtn;
@property(nonatomic ,strong)UILabel *contentLabel;
@property(nonatomic ,strong)UIButton *extensionBtn;
@property(nonatomic ,strong)HICAuthorCustomerModel *customerModel;
@property(nonatomic ,strong)HICAuthorModel *authorModel;
@property(nonatomic ,strong)UIView *footView;
@property(nonatomic ,strong)UILabel *contentLabelLong;
@property(nonatomic ,strong)UILabel *nilLabel;
@end
@implementation HICLessonContentCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    [super awakeFromNib];
     if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
          self.backgroundColor = UIColor.whiteColor;
        [self updateConstraintsIfNeeded];
       }
    return self;
}
- (void)setBaseModel:(HICBaseInfoModel *)baseModel{
    if ([HICCommonUtils isValidObject:baseModel.author]) {
        self.authorModel = [HICAuthorModel mj_objectWithKeyValues:baseModel.author];
        self.customerModel = [HICAuthorCustomerModel mj_objectWithKeyValues:self.authorModel.customer];
    }
//    else{
//        [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
//        [self.authorTitleLabel removeFromSuperview];
//        [self.authorLabel removeFromSuperview];
//        [self.arrowBtn removeFromSuperview];
//        [self.contentLabel removeFromSuperview];
//        [self.contentLabelLong removeFromSuperview];
//        self.nilLabel = [[UILabel alloc]initWithFrame:CGRectMake(16 , 124,HIC_ScreenWidth - 32 , 48)];
//        self.nilLabel.font = FONT_REGULAR_14;
//        self.nilLabel.textColor = TEXT_COLOR_DARK;
//        self.nilLabel.text = NSLocalizableString(@"noIntroduction", nil);
//        [self.contentView addSubview:self.nilLabel];
//        self.footView = [[UIView alloc]initWithFrame:CGRectMake(0, 172.5, HIC_ScreenWidth, 8)];
//        self.footView.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
//        [self.contentView addSubview:self.footView];
//        return;
//    }
    if ([NSString isValidStr:baseModel.credit]) {
        self.scoreLabel.text = [NSString stringWithFormat:@"%@: %@",NSLocalizableString(@"credits", nil),baseModel.credit];
    }else{
        self.scoreLabel.text = [NSString stringWithFormat:@"%@: -",NSLocalizableString(@"credits", nil)];
    }
    if ([NSString isValidStr:[NSString stringWithFormat:@"%ld",(long)baseModel.creditHours]]) {
       self.timeLabel.text = [NSString stringWithFormat:@"%@: %ld/%ld%@",NSLocalizableString(@"studyTime", nil),(long)baseModel.creditHoursUsed,(long)baseModel.creditHours,NSLocalizableString(@"minutes", nil)];
    }else{
        self.timeLabel.text = [NSString stringWithFormat:@"%@: -",NSLocalizableString(@"studyTime", nil)];
    }
//    if ([NSString isValidStr:[NSString stringWithFormat:@"%@",baseModel.applicableObject]]) {
//        self.targetLabel.text = [NSString stringWithFormat:@"适用对象: %@",baseModel.applicableObject];
//    }else{
//        self.targetLabel.text = @"适用对象: -";
//    }

    if ([NSString isValidStr:baseModel.desc]) {
        self.contentLabel.text = baseModel.desc;
        self.contentLabelLong.text = baseModel.desc;
    }else{
        self.contentLabel.text = NSLocalizableString(@"noIntroduction", nil);
    }
    
    if ([self.authorModel.type isEqual:@2]) {
     self.authorLabel.text = self.authorModel.name;
//         self.positionLabel.text = @"外部人员";
    }else{
        self.authorLabel.text = self.customerModel.name;
//        self.positionLabel.text = self.customerModel.positions;
    }
    if ( [HICCommonUtils sizeOfString:baseModel.desc stringWidthBounding:HIC_ScreenWidth - 32 font:14 stringOnBtn:NO fontIsRegular:YES].height > 60) {
        self.extensionBtn.hidden = NO;
    }else{
        self.extensionBtn.hidden = YES;
    }
    
}

- (void)createUI{
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.text = NSLocalizableString(@"contentAbstract", nil);
    self.titleLabel.font = FONT_MEDIUM_17;
    self.titleLabel.textColor = TEXT_COLOR_DARK;
    [self.contentView addSubview:self.titleLabel];
    
    self.scoreLabel = [[UILabel alloc]init];
    self.scoreLabel.font = FONT_REGULAR_14;
    self.scoreLabel.textColor = TEXT_COLOR_DARK;
    [self.contentView addSubview:self.scoreLabel];
    
    self.timeLabel = [[UILabel alloc]init];
    self.timeLabel.font = FONT_REGULAR_14;
    self.timeLabel.textColor = TEXT_COLOR_DARK;
    [self.contentView addSubview:self.timeLabel];
//    self.targetLabel = [[UILabel alloc]init];
//    self.targetLabel.font = FONT_REGULAR_14;
//    self.targetLabel.textColor = TEXT_COLOR_DARK;
//    self.targetLabel.numberOfLines = 1;
//    self.targetLabel.lineBreakMode = NSLineBreakByTruncatingTail;
//    [self.contentView addSubview:self.targetLabel];
    self.lineView = [[UIView alloc]init];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"#E6E6E6"];
    [self.contentView addSubview:self.lineView];
    self.authorTitleLabel = [[UILabel alloc]init];
    self.authorTitleLabel.font = FONT_REGULAR_14;
    self.authorTitleLabel.textColor = TEXT_COLOR_DARK;
    self.authorTitleLabel.text = [NSString stringWithFormat:@"%@: ",NSLocalizableString(@"author", nil)];
    [self.contentView addSubview:self.authorTitleLabel];
    
    self.authorLabel = [[UILabel alloc]init];
    self.authorLabel.font = FONT_MEDIUM_14;
    self.authorLabel.textColor = [UIColor colorWithHexString:@"#151515"];
    [self.contentView addSubview:self.authorLabel];
    
    self.arrowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.arrowBtn setImage:[UIImage imageNamed:@"跳转箭头"] forState:UIControlStateNormal];
    [self.arrowBtn addTarget:self action:@selector(jumpContributor) forControlEvents:UIControlEventTouchUpInside];
    [self.arrowBtn hicChangeButtonClickLength:30];
    [self.contentView addSubview:self.arrowBtn];
    
//    self.positionLabel = [[UILabel alloc]init];
//    self.positionLabel.font = FONT_REGULAR_14;
//    self.positionLabel.textColor = TEXT_COLOR_LIGHT;
//    [self.contentView addSubview:self.positionLabel];
    
    self.contentLabel = [[UILabel alloc]init];
    self.contentLabel.numberOfLines = 3;
    self.contentLabel.font = FONT_REGULAR_14;
    self.contentLabel.textColor = TEXT_COLOR_LIGHT;
    [self.contentView addSubview:self.contentLabel];
    self.contentLabel.hidden = NO;
    self.contentLabelLong = [[UILabel alloc]init];
    self.contentLabelLong.numberOfLines = 0;
    self.contentLabelLong.font = FONT_REGULAR_14;
    self.contentLabelLong.textColor = TEXT_COLOR_LIGHT;
    [self.contentView addSubview:self.contentLabelLong];
    self.contentLabelLong.hidden = YES;
    
    self.extensionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.extensionBtn.titleLabel.font = FONT_REGULAR_14;
    [self.extensionBtn setTitle:NSLocalizableString(@"develop", nil) forState:UIControlStateNormal];
    [self.extensionBtn setTitleColor:[UIColor colorWithHexString:@"#00BED7"] forState:UIControlStateNormal];
    [self.extensionBtn addTarget:self action:@selector(extensionBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.extensionBtn];
     self.extensionBtn.hidden = YES;
    
    self.footView = [[UIView alloc]init];
    self.footView.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
//    self.footView.backgroundColor = UIColor.redColor;
       [self.contentView addSubview:self.footView];
    self.contentView.layer.masksToBounds = YES;
}
- (void)updateConstraints {
    [super updateConstraints];
    [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(16);
        make.top.equalTo(self.contentView).offset(16);
    }];
    
    [self.scoreLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(16);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(12);
    }];
    
    [self.timeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(16);
        make.top.equalTo(self.scoreLabel.mas_bottom);
    }];
    
//    [self.targetLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.contentView).offset(16);
//        make.top.equalTo(self.timeLabel.mas_bottom);
//        make.width.offset(HIC_ScreenWidth - 32);
//    }];
    
    [self.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(16);
        make.right.equalTo(self.contentView).offset(-16);
        make.top.equalTo(self.timeLabel.mas_bottom).offset(12);
        make.height.offset(0.5);
    }];
    
    [self.authorTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(16);
        make.top.equalTo(self.lineView.mas_bottom).offset(12);
        make.width.offset(42);
    }];
    
    [self.authorLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(58);
        make.top.equalTo(self.lineView).offset(13);
        make.height.offset(20);
    }];
    
    [self.arrowBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-16);
        make.top.equalTo(self.lineView).offset(17);
        make.width.offset(7);
        make.height.offset(12);
    }];
    
//    [self.positionLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.authorLabel);
//        make.top.equalTo(self.authorLabel.mas_bottom).offset(1);
//        make.height.offset(20);
//    }];
    
    [self.contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(16);
        make.top.equalTo(self.authorLabel.mas_bottom).offset(10);
        make.right.equalTo(self.contentView).offset(-16);
    }];
    
    [self.contentLabelLong mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(16);
        make.top.equalTo(self.authorLabel.mas_bottom).offset(10);
        make.right.equalTo(self.contentView).offset(-16);
    }];
    [self.extensionBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(16);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
    }];
    [self.footView mas_updateConstraints:^(MASConstraintMaker *make) {
           make.bottom.equalTo(self.contentView.mas_bottom);
           make.width.equalTo(self.contentView);
           make.height.offset(8);
       }];
    
}
- (void)jumpContributor{
    if (self.extensionDelegate && [self.extensionDelegate respondsToSelector:@selector(jumpToContributor:)]) {
        [self.extensionDelegate jumpToContributor:self.authorModel];
    }
}
- (void)extensionBtnClick{
    if ([self.extensionBtn.titleLabel.text isEqualToString:NSLocalizableString(@"develop", nil)]) {
        [self.extensionBtn setTitle:NSLocalizableString(@"packUp", nil) forState:UIControlStateNormal];
        self.contentLabelLong.hidden = NO;
        self.contentLabel.hidden = YES;
        if (self.extensionDelegate && [self.extensionDelegate respondsToSelector:@selector(extensionClicked:)]) {
            [self.extensionDelegate extensionClicked:NSLocalizableString(@"develop", nil) ];
        }
    }else{
        [self.extensionBtn setTitle:NSLocalizableString(@"develop", nil) forState:UIControlStateNormal];
        self.contentLabel.hidden = NO;
        self.contentLabelLong.hidden = YES;
        if (self.extensionDelegate && [self.extensionDelegate respondsToSelector:@selector(extensionClicked:)]) {
            [self.extensionDelegate extensionClicked:NSLocalizableString(@"packUp", nil) ];
        }
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
