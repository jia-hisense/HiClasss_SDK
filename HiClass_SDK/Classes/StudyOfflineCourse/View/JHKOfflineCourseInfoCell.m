//
//  JHKOfflineCourseInfoCell.m
//  JHKOffLineViewDemo
//
//  Created by wangggang on 2020/4/20.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "JHKOfflineCourseInfoCell.h"
#import "ExpandLabel.h"
@interface JHKOfflineCourseInfoCell()
@property (strong, nonatomic) UILabel * titleLabel;
@property (strong, nonatomic) UILabel * infoLabel;
@property (strong, nonatomic) ExpandLabel * detailLabel;
@property (strong, nonatomic) UIView * lineView;
@end
@implementation JHKOfflineCourseInfoCell
+(instancetype)getInfoCell{
    return [JHKOfflineCourseInfoCell new];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(instancetype)init{
    if (self = [super init]) {
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(16);
            make.height.mas_equalTo(20);
            make.right.mas_equalTo(-16);
        }];
        [self.contentView addSubview:self.infoLabel];
        [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(16);
            make.height.mas_equalTo(0);
            make.right.mas_equalTo(-16);
            make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(12);
        }];
        [self.contentView addSubview:self.detailLabel];
        [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(16);
            make.height.mas_equalTo(0);
            make.right.mas_equalTo(-16);
            make.top.mas_equalTo(self.infoLabel.mas_bottom).offset(5);
        }];
        [self.contentView addSubview:self.lineView];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo(1);
            make.left.mas_equalTo(16);
        }];
    }
    return self;
}
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textColor = HexRGB(0x333333);
    }
    return _titleLabel;
}
-(UILabel *)infoLabel{
    if (!_infoLabel) {
        _infoLabel = [UILabel new];
        _infoLabel.font = [UIFont systemFontOfSize:14];
        _infoLabel.numberOfLines = 0;
        _infoLabel.textColor = HexRGB(0x666666);
    }
    return _infoLabel;
}
-(ExpandLabel *)detailLabel{
    if (!_detailLabel) {
        _detailLabel = [ExpandLabel new];
        _detailLabel.font = [UIFont systemFontOfSize:14];
        _detailLabel.textColor = HexRGB(0x666666);
        __weak typeof(self) weakSelf = self;
        _detailLabel.block = ^(CGFloat height) {
            if (weakSelf.infoCellHeightBlock) {
                weakSelf.infoCellHeightBlock(height + 85);
            }
            [weakSelf.detailLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(height);
            }];
        };
    }
    return _detailLabel;
}
-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [UIView new];
        [_lineView setBackgroundColor:HexRGB(0xE6E6E6)];
    }
    return _lineView;
}

-(void)setCellWithTitle:(NSString *)title hours:(NSString *)hours detailInfo:(NSString *)detailInfo{
    self.titleLabel.text = title;
    self.infoLabel.text = [NSString stringWithFormat:@"%@：%@%@",NSLocalizableString(@"standardOfClass", nil),hours,NSLocalizableString(@"hours", nil)];
    CGSize infoSize = [self.infoLabel.text boundingRectWithSize:CGSizeMake(HIC_ScreenWidth-32, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:self.infoLabel.font} context:nil].size;
    [self.infoLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(infoSize.height);
    }];
    [self.detailLabel setExpandAtt:detailInfo YYLabelW:(HIC_ScreenWidth-32) MaxLineNum:3 font:[UIFont systemFontOfSize:14] color:HexRGB(0x666666) LineSpace:0];
    [self.detailLabel setHidden:NO];
}
-(void)setCellWithTitle:(NSString *)title score:(NSString *)score credit:(NSString *)credit hours:(NSString *)hours{
    self.titleLabel.text = title;
    NSString * infoStr = [NSString stringWithFormat:@"%@：%@\n%@：%@\n%@：%@%@",NSLocalizableString(@"integral", nil),score,NSLocalizableString(@"credits", nil),credit,NSLocalizableString(@"studyTime", nil),hours,NSLocalizableString(@"minutes", nil)];
    self.infoLabel.text = infoStr;
    CGSize infoSize = [infoStr boundingRectWithSize:CGSizeMake(HIC_ScreenWidth-32, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:self.infoLabel.font} context:nil].size;
    [self.infoLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(infoSize.height + 10 * HIC_Divisor);
    }];
    [self.detailLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0);
    }];
    [self.detailLabel setHidden:YES];
}
-(void)setCellWithTitle:(NSString *)title position:(NSString *)position{
    self.titleLabel.text = title;
    self.infoLabel.text = position;
    CGSize infoSize = [position boundingRectWithSize:CGSizeMake(HIC_ScreenWidth-32, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:self.infoLabel.font} context:nil].size;
    [self.infoLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(infoSize.height);
    }];
    [self.detailLabel setHidden:YES];
    [self.detailLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
