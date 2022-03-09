//
//  QRScanVC.m
//  HsShare3.5
//
//  Created by 尚轩瑕 on 2017/12/7.
//  Copyright © 2017年 com.hisense. All rights reserved.
//

#import "HICQRScanVC.h"
#import "CameraView.h"

#import "HICQRScanWebVC.h"

@interface HICQRScanVC ()<CameraViewScanInfoDelegate>

@property (strong, nonatomic) CameraView *cameraView;

@end

@implementation HICQRScanVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self initUI];
    [self.cameraView startQRCodeScan];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
    [self.cameraView stopQRCodeScan];
}

- (void)initUI {
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    [self initCameraView];
    [self initNavView];
}

- (void)initNavView {

    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, HIC_ScreenWidth, kNavBarHeight+kStatusBarHeight)];
    backView.backgroundColor = [UIColor colorWithRed:0x00/255.0 green:0x00/255.0 blue:0x00/255.0 alpha:0.6]; //蒙版背景颜色

    UIButton *backBut = [[UIButton alloc] initWithFrame:CGRectMake(16, kStatusBarHeight+7, 30, 30)];
    [backBut setImage:[UIImage imageNamed:@"头部-返回-白色"] forState:UIControlStateNormal];
    [backBut addTarget:self action:@selector(clickBackBut:) forControlEvents:UIControlEventTouchUpInside];

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, kStatusBarHeight+9.5, HIC_ScreenWidth - 100, 25)];
    titleLabel.text = NSLocalizableString(@"scan", nil);
    titleLabel.textColor = UIColor.whiteColor;
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
    titleLabel.textAlignment = NSTextAlignmentCenter;

    [backView addSubview:backBut];
    [backView addSubview:titleLabel];

    [self.view addSubview:backView];
}

- (void)initCameraView {
    self.cameraView = [[CameraView alloc] init];
    self.cameraView.cameraViewScanInfoDelegate = self;
    [self.view addSubview:self.cameraView];
}

#pragma mark - 顶部导航栏事件
/**
 点击返回按钮
 */
- (void)clickBackBut:(UIButton *)btn {
    if (_presentJump) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark - 相机扫描到二维码信息
- (void)scanInfo:(NSString *)info {
    DDLogDebug(@"sacn info  is %@",info);
    if ([info hasPrefix:@"http"]) {
        HICQRScanWebVC *vc = [HICQRScanWebVC new];
        vc.urlStr = info;
        vc.parentVC = self;
        if ([info containsString:@"hismarttv"]) {
            vc.isCompanyUrl = YES;
        }
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:vc animated:YES completion:nil];
    }else {
        [self.cameraView startQRCodeScan];
    }
}



- (NSData *)convertHexStrToData:(NSString *)str {
    if (!str || [str length] ==0) {
        return nil;
    }
    
    NSMutableData *hexData = [[NSMutableData alloc]initWithCapacity:[str length]*2];
    NSRange range;
    if ([str length] %2==0) {
        range = NSMakeRange(0,2);
    } else {
        range = NSMakeRange(0,1);
    }
    for (NSInteger i = range.location; i < [str length]; i +=2) {
        unsigned int anInt;
        NSString *hexCharStr = [str substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc]initWithString:hexCharStr];
        
        [scanner scanHexInt:&anInt];
        NSData *entity = [[NSData alloc]initWithBytes:&anInt length:1];
        [hexData appendData:entity];
        
        range.location+= range.length;
        range.length=2;
    }
    return hexData;
}


@end

