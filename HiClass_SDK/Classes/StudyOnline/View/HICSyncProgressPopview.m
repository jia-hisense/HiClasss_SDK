//
//  HICSyncProgressPopview.m
//  HiClass
//
//  Created by jiafujia on 2021/6/8.
//  Copyright © 2021 hisense. All rights reserved.
//

#import "HICSyncProgressPopview.h"

@interface HICSyncProgressPopview ()

@property (nonatomic, strong)UIImageView *backgroundView;
@property (nonatomic, strong)UILabel *contentLabel;
@property (nonatomic, strong)UIButton *gotItBtn;
@property (nonatomic, strong)UIView *line;
@property (nonatomic, assign)HICSyncProgressPage fromPage;

@end

@implementation HICSyncProgressPopview

- (instancetype)initWithFrame:(CGRect)frame from:(HICSyncProgressPage)fromPage {
    self = [super initWithFrame:frame];
    if (self) {
        self.fromPage = fromPage;
        [self addUI];
    }
    return self;
}

- (void)addUI {
    [self addSubview:self.backgroundView];
    [self addSubview:self.contentLabel];
    [self addSubview:self.line];
    [self addSubview:self.gotItBtn];
    [self makeLayout];
}
- (void)makeLayout {
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(HIC_NavBarAndStatusBarHeight - 5);
        make.right.equalTo(self).inset(16);
        make.width.equalTo(@220);
        make.height.equalTo(@150);
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backgroundView).offset(30);
        make.left.right.equalTo(self.backgroundView).inset(24);
    }];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@0.5);
        make.left.right.equalTo(self.backgroundView).inset(8);
        make.bottom.equalTo(self.gotItBtn.mas_top).offset(-6);
    }];
    [self.gotItBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.backgroundView);
        make.height.equalTo(@30);
        make.left.right.equalTo(self.backgroundView).inset(8);
        make.bottom.equalTo(self.backgroundView).inset(15);
    }];
}

- (void)gotItAction {
    [self removeFromSuperview];
    NSString *notifycationKey;
    if (self.fromPage == HICSyncProgressPageTrainDetail) {
        notifycationKey = hadShowTrainSyncProgressToastKey;
    } else if (self.fromPage == HICSyncProgressPagePostDetail) {
        notifycationKey = hadShowPostSyncProgressToastKey;
    } else if (self.fromPage == HICSyncProgressPageMixTrain) {
        notifycationKey = hadShowMixTrainyncProgressToastKey;
    }
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:notifycationKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark -懒加载
- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = [UIFont systemFontOfSize:14];
        _contentLabel.numberOfLines = 0;
        _contentLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        NSString *content = NSLocalizableString(@"synchronousProgressPrompt", nil);
        NSMutableAttributedString *contenAttributedStr = [[NSMutableAttributedString alloc] initWithString:content];
        NSDictionary *attributes = @{
            NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Medium" size:14],
            NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#0C0C0C"]
        };
        [contenAttributedStr addAttributes:attributes
                                     range:[content rangeOfString:[NSString stringWithFormat:@"“%@”",NSLocalizableString(@"synchronousProgress", nil)]]
         ];
        _contentLabel.attributedText = contenAttributedStr;
        
    }
    return _contentLabel;
}

- (UIButton *)gotItBtn {
    if (!_gotItBtn) {
        _gotItBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_gotItBtn setTitle:NSLocalizableString(@"iKnow", nil) forState:UIControlStateNormal];
        [_gotItBtn setTitleColor:[UIColor colorWithHexString:@"#00BED7"] forState:UIControlStateNormal];
        _gotItBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
        [_gotItBtn addTarget:self action:@selector(gotItAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _gotItBtn;
}

- (UIImageView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"syncprogress_backgorund" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil]];
        _backgroundView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _backgroundView;
}

- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6"];
    }
    return _line;
}

@end
