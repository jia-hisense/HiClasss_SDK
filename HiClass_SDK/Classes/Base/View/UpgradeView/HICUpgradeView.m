//
//  HICUpgradeView.m
//  HiClass
//
//  Created by Eddie Ma on 2020/3/5.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICUpgradeView.h"

@interface HICUpgradeView()
@property (nonatomic, strong) NSString *version;
@property (nonatomic, strong) NSString *size;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *downloadUrl;

@end

@implementation HICUpgradeView

- (instancetype)initWithVersion:(NSString *)version size:(NSString *)size time:(NSString *)time content:(NSString *)content downloadUrl:(NSString *)downloadUrl {
    if (self = [super init]) {
        self.version = version;
        self.size = size;
        self.time = time;
        self.content = content;
        self.downloadUrl = downloadUrl;
    }
    return self;
}

- (void)show {
    [self createUI];
}

- (void)hide{
    [self removeFromSuperview];
}

- (void)createUI {
    self.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.5];

    CGFloat containerViewW = [[HICCommonUtils iphoneType] isEqualToString:@"l-iPhone"] ? 320 * 1.2 : 320;
    CGFloat containerViewH = [[HICCommonUtils iphoneType] isEqualToString:@"l-iPhone"] ? 387 * 1.2 : 387;
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake((HIC_ScreenWidth - containerViewW)/2, (HIC_ScreenHeight - containerViewH)/2, containerViewW, containerViewH)];
    [self addSubview:containerView];
    containerView.backgroundColor = [UIColor whiteColor];
    containerView.layer.cornerRadius = 12;
    containerView.layer.masksToBounds = YES;

    CGFloat bgH = [[HICCommonUtils iphoneType] isEqualToString:@"l-iPhone"] ? 161 * 1.2 : 161;
    UIImageView *bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, containerViewW, bgH)];
    [containerView addSubview:bg];
    bg.image = [UIImage imageNamed:@"appUpgrade"];

    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(24, 24, bg.frame.size.width - 2 * 24, 31)];
    [bg addSubview:title];
    title.text = [NSString stringWithFormat:@"%@ V%@", NSLocalizableString(@"discoverNewVersion", nil),_version];
    title.textColor = [UIColor whiteColor];
    title.font = FONT_MEDIUM_22;

    UILabel *subtitle1 = [[UILabel alloc] initWithFrame:CGRectMake(24, title.frame.origin.y + title.frame.size.height + 9, bg.frame.size.width - 2 * 24, 20)];
    [bg addSubview:subtitle1];
    subtitle1.text = [NSString stringWithFormat:@"%@: %@", NSLocalizableString(@"bigOrSmall", nil),_size];
    subtitle1.textColor = [UIColor whiteColor];
    subtitle1.font = FONT_REGULAR_14;

    UILabel *subtitle2 = [[UILabel alloc] initWithFrame:CGRectMake(24, subtitle1.frame.origin.y + subtitle1.frame.size.height, bg.frame.size.width - 2 * 24, 20)];
    [bg addSubview:subtitle2];
    subtitle2.text = [NSString stringWithFormat:@"%@: %@", NSLocalizableString(@"time", nil),_time];
    subtitle2.textColor = [UIColor whiteColor];
    subtitle2.font = FONT_REGULAR_14;

    UILabel *contentTitle = [[UILabel alloc] initWithFrame:CGRectMake(24, bg.frame.size.height, containerView.frame.size.width - 2 * 24, 21)];
    [containerView addSubview:contentTitle];
    contentTitle.text = [NSString stringWithFormat:@"%@:",NSLocalizableString(@"updateContent", nil)];
    contentTitle.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1/1.0];
    contentTitle.font = FONT_MEDIUM_15;

    CGFloat contentH = [[HICCommonUtils iphoneType] isEqualToString:@"l-iPhone"] ? 110 * 1.2 : 110;
    UITextView *content = [[UITextView alloc] initWithFrame:CGRectMake(20, contentTitle.frame.origin.y + contentTitle.frame.size.height + 4, containerView.frame.size.width - 2 * 20, contentH)];
    [containerView addSubview: content];
    content.backgroundColor = [UIColor whiteColor];
    [content setEditable:NO];
    content.text = _content;
    content.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1/1.0];
    content.font = FONT_REGULAR_14;

    UIButton *nextTimeBtn = [[UIButton alloc] initWithFrame:CGRectMake(24, containerView.frame.size.height - 24 - 48, 130, 48)];
    [containerView addSubview: nextTimeBtn];
    [nextTimeBtn setTitle:NSLocalizableString(@"nextTimeRemind", nil) forState:UIControlStateNormal];
    nextTimeBtn.titleLabel.font = FONT_MEDIUM_18;
    [nextTimeBtn setTitleColor:[UIColor colorWithRed:0/255.0 green:190/255.0 blue:215/255.0 alpha:1/1.0] forState:UIControlStateNormal];
    nextTimeBtn.layer.cornerRadius = 4;
    nextTimeBtn.layer.masksToBounds = YES;
    nextTimeBtn.layer.borderColor = [UIColor colorWithRed:0/255.0 green:190/255.0 blue:215/255.0 alpha:1/1.0].CGColor;
    nextTimeBtn.layer.borderWidth = 0.6;
    nextTimeBtn.tag = 10000;
    [nextTimeBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];

    CGFloat btnInterval = containerView.frame.size.width - 2 * 24 - 2 * 130;
    UIButton *updateBtn = [[UIButton alloc] initWithFrame:CGRectMake(24 + nextTimeBtn.frame.size.width + btnInterval, containerView.frame.size.height - 24 - 48, 130, 48)];
    [containerView addSubview: updateBtn];
    [updateBtn setTitle:NSLocalizableString(@"updateNow", nil) forState:UIControlStateNormal];
    updateBtn.titleLabel.font = FONT_MEDIUM_18;
    [updateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    updateBtn.layer.cornerRadius = 4;
    updateBtn.layer.masksToBounds = YES;
    updateBtn.tag = 10001;
    [HICCommonUtils createGradientLayerWithBtn:updateBtn fromColor:[UIColor colorWithHexString:@"00E2D8" alpha:1.0f] toColor:[UIColor colorWithHexString:@"00C5E0" alpha:1.0f]];
    [updateBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *forceUpdateBtn = [[UIButton alloc] initWithFrame:CGRectMake(36, containerView.frame.size.height - 34 - 44, containerView.width - 72, 44)];
    [containerView addSubview: forceUpdateBtn];
    [forceUpdateBtn setTitle:NSLocalizableString(@"ipgradeImmediately", nil) forState:UIControlStateNormal];
    forceUpdateBtn.titleLabel.font = FONT_MEDIUM_18;
    [forceUpdateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    forceUpdateBtn.layer.cornerRadius = 24;
    forceUpdateBtn.layer.masksToBounds = YES;
    forceUpdateBtn.tag = 10002;
    [HICCommonUtils createGradientLayerWithBtn:forceUpdateBtn fromColor:[UIColor colorWithHexString:@"00E2D8" alpha:1.0f] toColor:[UIColor colorWithHexString:@"00C5E0" alpha:1.0f]];
    [forceUpdateBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [containerView addSubview:forceUpdateBtn];
    forceUpdateBtn.hidden = YES;
    UILabel *forceLabel = [[UILabel alloc]initWithFrame:CGRectMake(12,containerView.frame.size.height - 30 , containerView.width - 24, 20)];
    forceLabel.text = NSLocalizableString(@"useNextUpdata", nil);
    forceLabel.textColor = TEXT_COLOR_LIGHTS;
    forceLabel.font = FONT_REGULAR_14;
    forceLabel.textAlignment = NSTextAlignmentCenter;
    forceLabel.hidden = YES;
    [containerView addSubview:forceLabel];
    if ([SystemManager.updateFlag isEqual:@2]) {
        forceLabel.hidden = NO;
        forceUpdateBtn.hidden = NO;
        nextTimeBtn.hidden = YES;
        updateBtn.hidden = YES;
    }
}

- (void)clickBtn:(UIButton *)btn {
    if (btn.tag == 10000) { // 下次提醒
        [self hide];
        if ([SystemManager.updateFlag isEqual:@2]) {
            exit(0);
        }
    } else { // 立即更新
        if ([HICCommonUtils appBundleIden] == HICAppBundleIdenZhiYu) {
            [self openAppStoreToUpdate];
        } else {
            // 此段代码会引起App Store审核被拒，知渔上线版本务必注释掉
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"itms-services://?action=download-manifest&url=%@",self.downloadUrl]] options:@{} completionHandler:nil];
            [self hide];
        }
    }
}

// 知渔 需要跳转至App Store下载
- (void)openAppStoreToUpdate {
    NSString *trackUrlStr = [HIC_App_DownloadURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *trackUrl = [NSURL URLWithString:trackUrlStr];
    if ([[UIApplication sharedApplication] canOpenURL:trackUrl]) {
        [[UIApplication sharedApplication] openURL:trackUrl options:@{} completionHandler:^(BOOL success) {
            if (success) {
                [self hide];
            }
        }];
    }
}

@end
