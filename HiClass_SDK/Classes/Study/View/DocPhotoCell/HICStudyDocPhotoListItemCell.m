//
//  HICStudyDocPhotoListItemCell.m
//  HiClass
//
//  Created by Sir_Jing on 2020/2/10.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICStudyDocPhotoListItemCell.h"
#import "HICWaterView.h"
@interface HICStudyDocPhotoListItemCell ()
@property (nonatomic, strong) UIImageView *photoImageView;
@property (nonatomic, strong) HICWaterView *waterView;
@end
@implementation HICStudyDocPhotoListItemCell

- (void)setModel:(HICMediaInfoModel *)model {
    [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:model.url]];
}
- (void)setControlModel:(HICControlInfoModel *)controlModel{
    if (controlModel.watermarkFlag) {
        if ([self.photoImageView.subviews containsObject:self.waterView]) {
            [self.waterView removeFromSuperview];
        }
        self.waterView = [[HICWaterView alloc]initWithFrame:CGRectMake(6, 6, self.contentView.frame.size.width - 16,self.contentView.frame.size.height - 16) WithText:controlModel.watermarkText];
        [self.photoImageView addSubview:self.waterView];
        [self.waterView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.right.equalTo(self.photoImageView);
        }];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createView];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = UIColor.blackColor;
    }
    return self;
}

-(void)createView {
    self.photoImageView = [[UIImageView alloc]init];
    self.photoImageView.backgroundColor = UIColor.blackColor;
    self.photoImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:self.photoImageView];
    [self.photoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(8);
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
}

@end
