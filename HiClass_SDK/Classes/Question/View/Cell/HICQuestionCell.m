//
//  HICQuestionCell.m
//  HiClass
//
//  Created by WorkOffice on 2020/6/8.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import "HICQuestionCell.h"
#define Width self.contentView.frame.size.width
#define Height self.contentView.frame.size.height
@interface HICQuestionCell()
@property (nonatomic, assign) BaseCellBorderStyle borderStyle;//边框类型
@property (nonatomic, strong) UIColor *contentBorderColor;//边框颜色
@property (nonatomic, strong) UIColor *contentBackgroundColor;//边框内部内容颜色
@property (nonatomic, assign) CGFloat contentBorderWidth;//边框的宽度，这个宽度的一半会延伸到外部，如果对宽度比较敏感的要注意下
@property (nonatomic, assign) CGFloat contentMargin;//左右距离父视图的边距
@property (nonatomic, assign) CGSize contentCornerRadius;//边框的圆角
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic ,strong) UILabel *reasonLabel;
@property (nonatomic ,strong) UILabel *pointsLabel;
@property (nonatomic ,strong) UIImageView *statusIV;

@end

@implementation HICQuestionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)setModel:(HICQuestionListModel *)model {
    _model = model;
    self.nameLabel.text = _model.actionName;
    self.dateLabel.text = [NSString stringWithFormat:@"%@:%@",NSLocalizableString(@"theQuestionnaireOfTime", nil),[HICCommonUtils returnReadableTimeZoneWithStartTime:_model.startTime andEndTime:_model.endTime]];
    self.pointsLabel.hidden = model.points.integerValue <= 0;
    self.pointsLabel.text = HICLocalizedFormatString(@"questionRewardPoints", model.points.integerValue);
    
    self.reasonLabel.hidden = model.state != HICQuestionExpired; //|| model.isEnd != 1;
    
    // 过期问卷颜色减淡
    CGFloat textColorAlpha = model.state == HICQuestionExpired ? 0.5 : 1.0;
    self.nameLabel.textColor = [UIColor colorWithHexString:@"#333333" alpha:textColorAlpha];
    self.dateLabel.textColor = [UIColor colorWithHexString:@"#858585" alpha:textColorAlpha];
    self.reasonLabel.textColor = [UIColor colorWithHexString:@"#FF8500" alpha:textColorAlpha];
    self.pointsLabel.textColor = [UIColor colorWithHexString:@"#858585" alpha:textColorAlpha];
  
    self.statusIV.hidden = !self.isAll;
    if (_model.state == HICQuestionFinished) {
        self.statusIV.image = [UIImage imageNamed:@"已完成"];
    } else if (_model.state == HICQuestionExpired) {
        self.statusIV.image = [UIImage imageNamed:@"已过期"];
    } else {
        self.statusIV.hidden = YES;
    }

    [self updateLayout];
}


- (void)createUI {
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.backView];
    [self.backView addSubview:self.nameLabel];
    [self.backView addSubview:self.dateLabel];
    [self.backView addSubview:self.reasonLabel];
    [self.backView addSubview:self.pointsLabel];
    [self.backView addSubview:self.statusIV];
 
    [self makeAutoLayout];
}
- (void)makeAutoLayout {
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(6, 12, 6, 12));
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backView).offset(16);
        make.left.equalTo(self.backView).offset(16);
        make.right.equalTo(self.backView).offset(-16);
    }];
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(10);
        make.left.equalTo(self.nameLabel);
        make.right.equalTo(self.backView).offset(-16);
    }];
    [self.pointsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dateLabel.mas_bottom).offset(5);
        make.left.equalTo(self.nameLabel);
        make.right.equalTo(self.backView).offset(-16);
    }];
    [self.reasonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.right.equalTo(self.nameLabel);
        make.top.equalTo(self.pointsLabel.mas_bottom).offset(10);
        make.bottom.equalTo(self.backView).inset(16).priority(UILayoutPriorityDefaultHigh);
    }];
    [self.statusIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.backView);
        make.bottom.equalTo(self.backView);
        make.width.equalTo(@60);
        make.height.equalTo(@60);
    }];
}

- (void)updateLayout {
    [self.dateLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(10);
        make.left.equalTo(self.nameLabel);
        make.right.equalTo(self.backView).offset(-16);
        if (self.pointsLabel.isHidden && self.reasonLabel.hidden) {
            make.bottom.equalTo(self.backView).inset(16).priority(UILayoutPriorityDefaultHigh);
        }
    }];
    [self.pointsLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dateLabel.mas_bottom).offset(5);
        make.left.equalTo(self.nameLabel);
        make.right.equalTo(self.backView).offset(-16);
        if (self.reasonLabel.hidden && !self.pointsLabel.hidden) {
            make.bottom.equalTo(self.backView).inset(16).priority(UILayoutPriorityDefaultHigh);
        }
    }];
    [self.reasonLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.right.equalTo(self.nameLabel);
        make.top.equalTo(self.pointsLabel.hidden ? self.dateLabel.mas_bottom : self.pointsLabel.mas_bottom).offset(10);
        if (!self.reasonLabel.hidden) {
            make.bottom.equalTo(self.backView).inset(16);
        }
    }];
    [self layoutIfNeeded];
}

#pragma mark -- LazyLoads
- (UIView *)backView {
    if (!_backView) {
        _backView = [UIView new];
        _backView.backgroundColor = [UIColor whiteColor];
        _backView.layer.cornerRadius = 8;
    }
    return _backView;
}
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.font = FONT_REGULAR_16;
        _nameLabel.textColor = TEXT_COLOR_DARK;
        _nameLabel.numberOfLines = 2;
    }
    return _nameLabel;
}
- (UILabel *)dateLabel {
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc]init];
        _dateLabel.font = FONT_REGULAR_14;
        _dateLabel.textColor = [UIColor colorWithHexString:@"#858585"];
    }
    return _dateLabel;
}
- (UILabel *)reasonLabel {
    if (!_reasonLabel) {
        _reasonLabel = [[UILabel alloc]init];
        _reasonLabel.font = FONT_REGULAR_14;
        _reasonLabel.textColor = [UIColor colorWithHexString:@"#FF8500"];
        _reasonLabel.text = NSLocalizableString(@"hintsForEndingTheQuestionnaire", nil);
    }
    return _reasonLabel;
}
- (UILabel *)pointsLabel {
    if (!_pointsLabel) {
        _pointsLabel = [[UILabel alloc]init];
        _pointsLabel.font = FONT_REGULAR_14;
        _pointsLabel.textColor = TEXT_COLOR_LIGHTM;
    }
    return _pointsLabel;
}
- (UIImageView *)statusIV {
    if (!_statusIV) {
        _statusIV = [[UIImageView alloc] init];
        _statusIV.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _statusIV;
}

@end
