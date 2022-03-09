//
//  HomeTaskCenterBaseCell.m
//  iTest
//
//  Created by Sir_Jing on 2020/3/16.
//  Copyright © 2020 Sir_Jing. All rights reserved.
//

#import "HomeTaskCenterBaseCell.h"

@implementation HomeTaskCenterBaseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createView];
        self.backgroundColor = UIColor.clearColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)createView {
    self.iconImageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.contentBackView = [[UIView alloc] initWithFrame:CGRectZero];
    self.iconImage = [[UIImageView alloc] initWithFrame:CGRectZero];

    [self.contentView addSubview:self.iconImageLabel];
    [self.contentView addSubview:self.contentBackView];
    [self.contentView addSubview:self.iconImage];

    [self.iconImageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.width.offset(24);
        make.height.offset(24);
    }];
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.width.offset(24);
        make.height.offset(24);
    }];

    [self.contentBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(12);
        make.left.equalTo(self.iconImageLabel.mas_right).offset(8);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(0);
        make.right.equalTo(self.contentView.mas_right).offset(-12);
    }];

    self.iconImageLabel.layer.cornerRadius = 12;
    self.iconImageLabel.layer.masksToBounds = YES;
    self.iconImageLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
    self.iconImage.layer.cornerRadius = 12;
    self.iconImage.layer.masksToBounds = YES;
    
    self.iconImageLabel.textAlignment = NSTextAlignmentCenter;
    self.iconImageLabel.textColor = UIColor.whiteColor;

    self.contentBackView.backgroundColor = UIColor.whiteColor;
    self.contentBackView.layer.cornerRadius = 4.f;
    self.contentBackView.layer.masksToBounds = YES;

    self.contentTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.leftTopLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.leftBottomLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.rightTopLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.rightBottomLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectZero];
    self.lineView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.contentView addSubview:self.contentTitleLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.leftTopLabel];
    [self.contentView addSubview:self.leftBottomLabel];
    [self.contentView addSubview:self.rightTopLabel];
    [self.contentView addSubview:self.rightBottomLabel];
    [self.contentView addSubview:self.progressView];
    [self.contentView addSubview:self.lineView];
    
    [self.contentTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentBackView.mas_top).offset(16.5);
        make.left.equalTo(self.contentBackView.mas_left).offset(16);
        make.right.equalTo(self.contentBackView.mas_right).offset(-16);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentTitleLabel.mas_bottom).offset(5);
        make.left.equalTo(self.contentBackView.mas_left).offset(16);
        make.right.equalTo(self.contentBackView.mas_right).offset(-16);
    }];
    [self.leftTopLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom).offset(8);
        make.left.equalTo(self.contentBackView.mas_left).offset(16);
        make.right.equalTo(self.contentBackView.mas_centerX);
    }];
    [self.leftBottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.leftTopLabel.mas_bottom).offset(3);
        make.left.equalTo(self.contentBackView.mas_left).offset(16);
        make.right.equalTo(self.contentBackView.mas_centerX);
        make.bottom.equalTo(self.contentBackView).inset(16);
    }];
    [self.rightTopLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom).offset(8);
        make.left.equalTo(self.contentBackView.mas_centerX).offset(5);
        make.right.equalTo(self.contentBackView.mas_right).offset(-16);
    }];
    [self.rightBottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.rightTopLabel.mas_bottom).offset(3);
        make.left.equalTo(self.contentBackView.mas_centerX).offset(5);
        make.right.equalTo(self.contentBackView.mas_right).offset(-16);
    }];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.rightTopLabel.mas_bottom).offset(12);
        make.left.equalTo(self.contentBackView.mas_centerX).offset(5);
        make.right.equalTo(self.contentBackView.mas_right).offset(-40);
        make.height.offset(5);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeLabel.mas_bottom).offset(8);
        make.left.equalTo(self.contentBackView.mas_left).offset(16);
        make.right.equalTo(self.contentBackView.mas_right).offset(-16);
        make.height.offset(0.5);
    }];

    // 设置各个视图的内容
    self.contentTitleLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
    self.contentTitleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    self.contentTitleLabel.numberOfLines = 2;

    self.timeLabel.textColor = [UIColor colorWithRed:133/255.0 green:133/255.0 blue:133/255.0 alpha:1];
    self.timeLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 14];

    self.leftTopLabel.textColor = [UIColor colorWithRed:133/255.0 green:133/255.0 blue:133/255.0 alpha:1];
    self.leftTopLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 14];

    self.leftBottomLabel.textColor = [UIColor colorWithRed:133/255.0 green:133/255.0 blue:133/255.0 alpha:1];
    self.leftBottomLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 14];

    self.rightTopLabel.textColor = [UIColor colorWithRed:133/255.0 green:133/255.0 blue:133/255.0 alpha:1];
    self.rightTopLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 14];

    self.rightBottomLabel.textColor = [UIColor colorWithRed:133/255.0 green:133/255.0 blue:133/255.0 alpha:1];
    self.rightBottomLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 14];

    self.progressView.progressTintColor = [UIColor colorWithRed:3/255.0 green:179/255.0 blue:204/255.0 alpha:1];
    self.progressView.tintColor = [UIColor colorWithRed:133/255.0 green:133/255.0 blue:133/255.0 alpha:1];
    self.progressView.progress = 0.5;
    self.progressView.layer.cornerRadius = 2.5;
    self.progressView.layer.masksToBounds = YES;

    self.lineView.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];

    self.majorImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 3.25, 30, 16)];
    self.majorImageView.image = [UIImage imageNamed:@"标签_重要"];
}

- (void)setModel:(HICHomeTaskCenterModel *)model {
    _model = model;
}


+(CGFloat)getTitleLabelHeightWith:(NSString *)str {

    NSDictionary *attribute = @{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size:16]};

    CGSize retSize = [str boundingRectWithSize:CGSizeMake(TaskCenterCellTitleWidth, 0)
                                       options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                    attributes:attribute
                                       context:nil].size;
    CGFloat height = retSize.height;
    if (height > 45) {
        return 45-22.5;
    }
    return retSize.height>22.5?retSize.height-22.5:0;
}

@end
