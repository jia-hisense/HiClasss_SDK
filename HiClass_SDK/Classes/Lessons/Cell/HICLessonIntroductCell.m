//
//  HICLessonIntroductCell.m
//  HiClass
//
//  Created by WorkOffice on 2020/2/4.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICLessonIntroductCell.h"
#import "HICContributorListVC.h"
#import "HICContributorModel.h"
#import "HICAuthorModel.h"
#import "HICAuthorCustomerModel.h"
@interface HICLessonIntroductCell ()
@property (nonatomic ,strong)UILabel *titleLabel;
@property (nonatomic ,strong)UIView *actionView;
@property (nonatomic ,strong)UIView *lineView;
@property (nonatomic ,strong)UILabel *contributeLabel;
@property (nonatomic ,strong)UIImageView *headerView;
@property (nonatomic ,strong)UILabel *nameLabel;
@property (nonatomic ,strong)UILabel *companyLabel;
@property (nonatomic ,strong)UIButton *arrowButton;
@property (nonatomic ,strong)UIImageView *starView;
@property (nonatomic ,strong)UILabel *starLabel;
@property (nonatomic ,strong)UIImageView *peopleView;
@property (nonatomic ,strong)UILabel *peopleLabel;
@property (nonatomic ,strong)UIImageView *thubView;
@property (nonatomic ,strong)UILabel *thubLabel;
@property (nonatomic ,strong)UIView *footView;
@property (nonatomic, strong) HICContributorModel *contributeModel;
@property (nonatomic ,strong) HICBaseInfoModel *bModel;

@end
@implementation HICLessonIntroductCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    [super awakeFromNib];
     if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
         self.backgroundColor = UIColor.whiteColor;
        [self updateConstraintsIfNeeded];
       }
    return self;
}
-(void)setBaseModel:(HICBaseInfoModel *)baseModel{
    if (!baseModel) {
        return;
    }
    _baseModel = baseModel;
    self.titleLabel.text = baseModel.name;
    [self.titleLabel sizeToFit];
    self.starLabel.text = [NSString stringWithFormat:@"%ld%@",(long)baseModel.score,NSLocalizableString(@"points", nil)];
    self.peopleLabel.text = [self sampleNumWatch:baseModel.learnersNum];
    self.thubLabel.text = [self sampleNum:baseModel.userLikeNum];
    if (![baseModel.contributor isEqual:[NSNull null]]) {
        self.contributeModel = [HICContributorModel mj_objectWithKeyValues:baseModel.contributor];
        self.nameLabel.text = self.contributeModel.name;
        if ([NSString isValidStr: self.contributeModel.positions]) {
            self.companyLabel.text = self.contributeModel.positions;
        }
        if ([NSString isValidStr:self.contributeModel.picUrl]){
           [self.headerView sd_setImageWithURL:[NSURL URLWithString:self.contributeModel.picUrl]];
        }else{
            UILabel *label = [HICCommonUtils setHeaderFrame:CGRectMake(0, 0, 44, 44) andText:self.contributeModel.name];
            label.hidden = NO;
            [self.headerView addSubview:label];
        }
        
    }
    [self layoutIfNeeded];
}
- (void)createUI {
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = FONT_MEDIUM_18;
    self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping |NSLineBreakByTruncatingTail;
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    self.titleLabel.numberOfLines = 2;
//    self.titleLabel.backgroundColor = UIColor.redColor;
    [self.contentView addSubview:self.titleLabel];
    
    self.actionView = [[UIView alloc]init];
    [self.contentView addSubview:self.actionView];
  
    self.starView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon-课程分值"]];
    self.starView.contentMode = UIViewContentModeScaleAspectFit;
    [self.actionView addSubview:self.starView];
    self.starLabel = [[UILabel alloc]init];
    
//    self.starLabel.text = @"4.5fen";
    self.starLabel.font = FONT_REGULAR_14;
    self.starLabel.textColor = TEXT_COLOR_LIGHTM;
    [self.actionView addSubview:self.starLabel];
    self.peopleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon-学习人数"]];
    [self.actionView addSubview:self.peopleView];
    self.peopleLabel = [[UILabel alloc]init];
  
//    self.peopleLabel.text = @"120ren";
    self.peopleLabel.font = FONT_REGULAR_14;
    self.peopleLabel.textColor = TEXT_COLOR_LIGHTM;
    [self.actionView addSubview:self.peopleLabel];
    self.thubView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon-点赞总数"]];
    [self.actionView addSubview:self.thubView];
    self.thubLabel = [[UILabel alloc]init];
    
//    self.thubLabel.text = @"1.2w";
    self.thubLabel.font = FONT_REGULAR_14;
    self.thubLabel.textColor = TEXT_COLOR_LIGHTM;
    [self.actionView addSubview:self.thubLabel];
    self.lineView = [[UIView alloc]init];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"#E6E6E6"];
    [self.contentView addSubview:self.lineView];
    
    self.contributeLabel = [[UILabel alloc]init];
    self.contributeLabel.font = FONT_REGULAR_13;
    self.contributeLabel.textColor = TEXT_COLOR_LIGHTM;
    self.contributeLabel.text = NSLocalizableString(@"contributors", nil);
    [self.contentView addSubview:self.contributeLabel];
    
    self.headerView = [[UIImageView alloc]init];
    self.headerView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.headerView];
    _headerView.layer.cornerRadius = 4;
    _headerView.layer.masksToBounds = YES;
    
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.font = FONT_MEDIUM_17;
    
//    self.nameLabel.text = @"徐志敏";
    self.nameLabel.textColor = TEXT_COLOR_DARK;
    [self.contentView addSubview:self.nameLabel];
    
    self.companyLabel = [[UILabel alloc]init];
    self.companyLabel.font = FONT_REGULAR_14;
    
//    self.companyLabel.text = @"海信集团-聚好看公司-产品中心";
    self.companyLabel.textColor = TEXT_COLOR_LIGHT;
    self.companyLabel.lineBreakMode = NSLineBreakByTruncatingHead;
    [self.contentView addSubview:self.companyLabel];
    
    self.arrowButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.arrowButton setImage:[UIImage imageNamed:@"跳转箭头"] forState:UIControlStateNormal];
    [self.arrowButton addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    [self.arrowButton hicChangeButtonClickLength:30];
    [self.contentView addSubview:self.arrowButton];
    self.footView = [[UIView alloc]init];
    self.footView.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
    [self.contentView addSubview:self.footView];
    [self layoutIfNeeded];
    
}
- (NSString *)sampleNum:(NSInteger)num{
    NSString *str;
    if (num > 1000) {
        if (num < 10000) {
            float n = (double)num *10 /1000;
            str = [HICCommonUtils formatFloat:n];
            str = [NSString stringWithFormat:@"%@k",str];
        }else{
            float n = (double)num *100/10000;
            str = [HICCommonUtils formatFloat:n];
            str = [NSString stringWithFormat:@"%@w",str];
        }
    } else{
        str = [NSString stringWithFormat:@"%ld",(long)num];
    }
    return str;
}
- (NSString *)sampleNumWatch:(NSInteger)num{
    NSString *str;
    if (num > 1000) {
        if (num < 10000) {
            float n = (double)num *10 /10000;
            str = [HICCommonUtils formatFloat:n];
            str = [NSString stringWithFormat:@"%@k%@",str,NSLocalizableString(@"peopleHaveToLearn", nil)];
        }else{
            float n = (double)num *100/1000000;
            str = [HICCommonUtils formatFloat:n];
            str = [NSString stringWithFormat:@"%@w%@",str,NSLocalizableString(@"peopleHaveToLearn", nil)];
        }
    } else{
        str = [NSString stringWithFormat:@"%ld%@",(long)num,NSLocalizableString(@"peopleHaveToLearn", nil)];
    }
    return str;
}

//- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
//// 创建一个bitmap的context
//// 并把它设置成为当前正在使用的context
//UIGraphicsBeginImageContext(size);
//// 绘制改变大小的图片
//[img drawInRect:CGRectMake(0, 0, size.width, size.height)];
//// 从当前context中创建一个改变大小后的图片
//UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
//// 使当前的context出堆栈
//UIGraphicsEndImageContext();
//// 返回新的改变大小后的图片
//return scaledImage;
//}
- (void)click{
    if ([self.lessonDelegate respondsToSelector:@selector(jumpContributorList:)]) {
        [self.lessonDelegate jumpContributorList:self.contributeModel];
    }
}
- (void)updateConstraints{
    [super updateConstraints];
    [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(16);
        make.left.equalTo(self).offset(16);
        make.right.equalTo(self).offset(-20);
    }];
    [self.actionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.left.equalTo(self.contentView).offset(17);
        make.right.equalTo(self.contentView).offset(-17);
        make.height.offset(50);
    }];
    [self.starView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(16);
        make.top.equalTo(self.actionView).offset(17);
    }];
    [self.starLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.starView.mas_right).offset(5);
        make.height.offset(20);
        make.top.equalTo(self.actionView).offset(15);
    }];
    [self.peopleView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.starLabel.mas_right).offset(29);
        make.top.equalTo(self.actionView).offset(17);
    }];
    [self.peopleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.peopleView.mas_right).offset(5);
        make.height.offset(20);
        make.top.equalTo(self.actionView).offset(15);
    }];
    [self.thubView mas_updateConstraints:^(MASConstraintMaker *make) {
           make.left.equalTo(self.peopleLabel.mas_right).offset(29);
           make.top.equalTo(self.actionView).offset(17);
       }];
    [self.thubLabel mas_updateConstraints:^(MASConstraintMaker *make) {
           make.left.equalTo(self.thubView.mas_right).offset(5);
           make.height.offset(20);
           make.top.equalTo(self.actionView).offset(15);
       }];
    [self.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.actionView.mas_bottom);
        make.left.equalTo(self.contentView).offset(17);
        make.right.equalTo(self.contentView).offset(-17);
        make.height.offset(0.5);
    }];
    [self.contributeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView).offset(9.5);
        make.left.equalTo(self.contentView).offset(17);
        make.height.offset(18);
    }];
    [self.headerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contributeLabel.mas_bottom).offset(8);
        make.left.equalTo(self.contentView).offset(17);
        make.height.offset(44);
        make.width.offset(44);
    }];
    [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView);
        make.left.equalTo(self.headerView.mas_right).offset(8);
    }];
    [self.companyLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(1);
        make.left.equalTo(self.headerView.mas_right).offset(8);
        make.right.equalTo(self.contentView).offset(-35);
    }];
    [self.arrowButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contributeLabel.mas_bottom).offset(26);
        make.right.equalTo(self.contentView).offset(-17);
        make.width.offset(7);
        make.height.offset(12);
    }];
    [self.footView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.width.equalTo(self.contentView);
        make.height.offset(8);
    }];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
