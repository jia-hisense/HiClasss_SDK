//
//  HICContributeKnowledgeCell.m
//  HiClass
//
//  Created by WorkOffice on 2020/2/5.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICContributeKnowledgeCell.h"
#import "HICCourseModel.h"
@interface HICContributeKnowledgeCell()
@property(nonatomic, strong)UIImageView *knowledgeView;
@property(nonatomic, strong)UILabel *nameLabel;
@property(nonatomic, strong)UILabel *scoreLabel;
@property(nonatomic, strong)UILabel *personNumLabel;
@property(nonatomic, strong)HICCourseModel *courseDetailModel;
@end
@implementation HICContributeKnowledgeCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    [super awakeFromNib];
     if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
          self.backgroundColor = UIColor.whiteColor;
        [self updateConstraintsIfNeeded];
       }
    return self;
}
-(void)setCourseModel:(HICCourseModel *)courseModel{
    if ([NSString isValidStr:courseModel.coverPic]) {
        [self.knowledgeView sd_setImageWithURL:[NSURL URLWithString:courseModel.coverPic]];
    }
    if ([NSString isValidStr:courseModel.courseKLDName]) {
        self.nameLabel.text = courseModel.courseKLDName;
    }
    if ([NSString isValidStr:[NSString stringWithFormat:@"%ld",(long)courseModel.learnersNum]]) {
        self.personNumLabel.text = [NSString stringWithFormat:@"%ld%@", (long)courseModel.learnersNum,NSLocalizableString(@"peopleHaveToLearn", nil)];
    }
    if ([NSString isValidStr:[NSString stringWithFormat:@"%ld",(long)courseModel.score]]) {
        self.scoreLabel.text  = [NSString stringWithFormat:@"%ld%@",(long)courseModel.score,NSLocalizableString(@"points", nil)];
    }
}
- (void) createUI{
    self.knowledgeView = [[UIImageView alloc]init];
    self.knowledgeView.backgroundColor = [UIColor colorWithHexString:@"e6e6e6"];
    self.knowledgeView.layer.cornerRadius = 4;
    self.knowledgeView.clipsToBounds = YES;
    [self.contentView addSubview:self.knowledgeView];
    
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.font = FONT_MEDIUM_15;
    self.nameLabel.textColor = TEXT_COLOR_DARK;
    self.nameLabel.numberOfLines = 2;
    [self.contentView addSubview:self.nameLabel];
    
    self.scoreLabel = [[UILabel alloc]init];
    self.scoreLabel.font = FONT_REGULAR_13;
    self.scoreLabel.textColor = [UIColor colorWithHexString:@"#858585"];
    [self.contentView addSubview:self.scoreLabel];
    
    self.personNumLabel = [[UILabel alloc]init];
    self.personNumLabel.font = FONT_REGULAR_13;
    self.personNumLabel.textColor = [UIColor colorWithHexString:@"#858585"];
    [self.contentView addSubview:self.personNumLabel];
}
- (void)updateConstraints {
    [super updateConstraints];
    [self.knowledgeView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(16);
        make.top.equalTo(self.contentView).offset(10);
        make.width.offset(130);
        make.height.offset(73);
    }];
    [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(158);
        make.top.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(-16);
    }];
    [self.scoreLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
//        make.width.offset(50);
        make.bottom.equalTo(self.knowledgeView.mas_bottom);
    }];
    [self.personNumLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scoreLabel.mas_right).offset(8);
        make.top.equalTo(self.scoreLabel);
    }];
}

@end
