//
//  VCHPermissionAlertView.m
//  HsShare3.5
//
//  Created by keep on 2018/8/11.
//  Copyright © 2018年 com.hisense. All rights reserved.
//
#import <Masonry/Masonry.h>
#import "VCHPermissionAlertView.h"
#import <WebKit/WebKit.h>

@interface VCHPermissionAlertView ()<UITextViewDelegate, WKUIDelegate>

@property (nonatomic, strong) UIView *maskView;

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIView *topView;

@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) UITextView *titleView;

@property (nonatomic, strong) UIButton *startBtn;

@property (nonatomic, strong) UIButton *cancelBtn;

@property (nonatomic, strong) UIView *lineView1;

@property (nonatomic, strong) UIView *lineView2;

@property (nonatomic, copy) NSString *tilteText;

@property (nonatomic, copy) NSString *cancelTitle;

@property (nonatomic, copy) NSString *startTitle;

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) NSString *contentStr;
@end

@implementation VCHPermissionAlertView

- (instancetype)initWithFrame:(CGRect)frame Title:(NSString *)title startBtnTitle:(NSString *)startBtnTitle cancelBtnTitle:(NSString *)cancelBtnTitle andStr:(NSString *)contentStr {
    if (self = [super initWithFrame:frame]) {
        self.tilteText = title;
        self.cancelTitle = cancelBtnTitle;
        self.startTitle = startBtnTitle;
        self.contentStr = contentStr;
        [self createUI];
        [self updateConstraintsIfNeeded];
    }
    return self;
}

- (void)createUI {
    self.backgroundColor = [UIColor whiteColor];
    
    self.maskView = [[UIView alloc] init];
    self.maskView.backgroundColor = [UIColor blackColor];
    self.maskView.alpha = 0.4f;
    [self addSubview:self.maskView];
    
    self.bgView = [[UIView alloc] init];
    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.cornerRadius = 10.0f;
    self.bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.bgView];
   
    self.titleView = [[UITextView alloc] init];
    self.titleView.text = self.tilteText;
    self.titleView.editable = NO;
    self.titleView.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
    self.titleView.backgroundColor = [UIColor clearColor];
    self.titleView.textAlignment = NSTextAlignmentCenter;
    self.titleView.textColor = [UIColor colorWithHexString:@"181818" alpha:1.0f];
    [self.bgView addSubview:self.titleView];

    self.webView = [[WKWebView alloc]initWithFrame:self.bgView.bounds configuration:[self javaScriptConfig]];
    [self.bgView addSubview:self.webView];
    _webView.backgroundColor = [UIColor whiteColor];
    // Mark: 这个地方可能以后会需要检查下传来的html文本是否还有body标签
    _contentStr = [NSString stringWithFormat:@"<body style='word-break: break-all;'>%@</body>", _contentStr];
    [_webView loadHTMLString:_contentStr baseURL:nil];
    _webView.UIDelegate = self;
    
    self.lineView1 = [[UIView alloc] init];
    self.lineView1.backgroundColor = [UIColor colorWithHexString:@"E6E6E6" alpha:1.0f];
    [self.bgView addSubview:self.lineView1];
    
    self.lineView2 = [[UIView alloc] init];
    self.lineView2.backgroundColor = [UIColor colorWithHexString:@"E6E6E6" alpha:1.0f];
    [self.bgView addSubview:self.lineView2];
    
    self.cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cancelBtn setTitle:self.cancelTitle forState:UIControlStateNormal];
    [self.cancelBtn setBackgroundColor:[UIColor clearColor]];
    [self.cancelBtn setTitleColor:[UIColor colorWithHexString:@"999999" alpha:1.0f] forState:UIControlStateNormal];
    [self.cancelBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:self.cancelBtn];
    
    self.startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.startBtn setTitle:self.startTitle forState:UIControlStateNormal];
    [self.startBtn setBackgroundColor:[UIColor clearColor]];
    self.startBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:18];
    [self.startBtn setTitleColor:[UIColor colorWithHexString:@"00BED7" alpha:1.0f] forState:UIControlStateNormal];
    [self.startBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:self.startBtn];
}

- (void)show {
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    [window addSubview:self];
    [window bringSubviewToFront:self];
}

- (void)updateConstraints {
    [super updateConstraints];
    
    [self.maskView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.bgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(352.5);
        make.center.equalTo(self);
        make.left.equalTo(self).offset([[HICCommonUtils iphoneType] isEqualToString:@"l-iPhone"] ? 0.17 * HIC_ScreenWidth : 0.14 * HIC_ScreenWidth);
        make.right.equalTo(self).offset([[HICCommonUtils iphoneType] isEqualToString:@"l-iPhone"] ? -0.17 * HIC_ScreenWidth : -0.14 * HIC_ScreenWidth);
    }];
    
    [self.titleView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(30);
        make.top.equalTo(self.bgView).offset(12);
        make.left.equalTo(self.bgView).offset(12);   
        make.right.equalTo(self.bgView).offset(-12);
    }];

    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleView.mas_bottom).offset(10);
               make.left.equalTo(self.bgView).offset(20);
               make.right.equalTo(self.bgView).offset(-20);
               make.height.offset(229);
    }];
    [self.lineView1 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(0.5);
        make.left.equalTo(self.bgView).offset(0);
        make.right.equalTo(self.bgView).offset(0);
        make.top.equalTo(self.webView.mas_bottom).offset(15);
    }];
    
    [self.lineView2 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView.mas_centerX);
        make.top.equalTo(self.lineView1.mas_bottom);
        make.bottom.equalTo(self.bgView.mas_bottom);
        make.width.offset(0.5);
    }];
    
    [self.cancelBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView1.mas_bottom);
        make.bottom.equalTo(self.bgView.mas_bottom);
        make.right.equalTo(self.lineView2.mas_left);
        make.left.equalTo(self.bgView.mas_left);
    }];
    
    [self.startBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView1.mas_bottom);
        make.bottom.equalTo(self.bgView.mas_bottom);
        make.left.equalTo(self.lineView2.mas_right);
        make.right.equalTo(self.bgView.mas_right);
    }];
}

- (void)clickBtn:(id)sender {
    [self removeFromSuperview];
    if (sender == self.cancelBtn) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(clickPermissionAlertVieWithBtnIndex:)]) {
            [self.delegate clickPermissionAlertVieWithBtnIndex:0];
        }
    } else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(clickPermissionAlertVieWithBtnIndex:)]) {
            [self.delegate clickPermissionAlertVieWithBtnIndex:1];
        }
    }
}

- (WKWebViewConfiguration *)javaScriptConfig {
    NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";

    WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    WKUserContentController *wkUController = [[WKUserContentController alloc] init];
    [wkUController addUserScript:wkUScript];

    WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
    wkWebConfig.userContentController = wkUController;
    return wkWebConfig;
}
#pragma mark -UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction{
    if([URL.scheme isEqualToString:@"service"]){
        DDLogDebug(@"serviceprotocol");
        return NO;
    }else{
        DDLogDebug(@"privacyprotocol");
        return NO;
    }
    return YES;
}

@end
