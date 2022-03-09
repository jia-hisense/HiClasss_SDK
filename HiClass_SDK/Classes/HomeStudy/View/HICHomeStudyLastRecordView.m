//
//  HICHomeStudyLastRecordView.m
//  HiClass
//
//  Created by jiafujia on 2021/6/8.
//  Copyright © 2021 hisense. All rights reserved.
//

#import "HICHomeStudyLastRecordView.h"

@interface HICHomeStudyLastRecordView()

@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UIButton *closeBtn;
@property (nonatomic, strong)UIButton *continueLearnBtn;

@end

@implementation HICHomeStudyLastRecordView

- (instancetype)initWithFrame:(CGRect)frame recordTitle:(NSString *)title {
    if (self = [super initWithFrame:frame]) {
        [self addUI];
        self.titleLabel.text = title;
    }
    return self;
}

- (void)addUI {
    self.backgroundColor = [UIColor whiteColor];
    self.layer.shadowColor = [UIColor colorWithWhite:0 alpha:0.2].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 2);
    self.layer.shadowOpacity = 12;
    [self addSubview:self.titleLabel];
    [self addSubview:self.closeBtn];
    [self addSubview:self.continueLearnBtn];
    [self makeLayout];
}

- (void)makeLayout {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).inset(12);
        make.centerY.equalTo(self);
    }];
    [self.continueLearnBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right).offset(10);
        make.width.equalTo(@84);
        make.height.equalTo(@36);
        make.centerY.equalTo(self.titleLabel);
    }];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.continueLearnBtn);
        make.left.equalTo(self.continueLearnBtn.mas_right).offset(5);
        make.right.equalTo(self).inset(5);
        make.width.height.equalTo(@24);
    }];
}

- (void)closeAction {
    [self removeFromSuperview];
}

- (void)continueLearnAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(continueLearnLastRecord)]) {
        [self.delegate continueLearnLastRecord];
    }
    [self removeFromSuperview];
}

#pragma mark -- 懒加载
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc ] init];
        _titleLabel.numberOfLines = 2;
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    }
    return _titleLabel;
}
- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setImage:[UIImage imageNamed:@"homestudy_close" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}
- (UIButton *)continueLearnBtn {
    if (!_continueLearnBtn) {
        _continueLearnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _continueLearnBtn.frame = CGRectMake(0, 0, 84, 36);
        _continueLearnBtn.backgroundColor = [UIColor colorWithHexString:@"#00C5E0"];
        _continueLearnBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        [_continueLearnBtn setTitle:NSLocalizableString(@"continueReading", nil) forState:UIControlStateNormal];
        [_continueLearnBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _continueLearnBtn.layer.cornerRadius = 5.0;
        [_continueLearnBtn addTarget:self action:@selector(continueLearnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _continueLearnBtn;
}

@end
