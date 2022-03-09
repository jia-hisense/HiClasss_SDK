//
//  CameraView.h
//  HsShare3.5
//
//  Created by 尚轩瑕 on 2017/12/7.
//  Copyright © 2017年 com.hisense. All rights reserved.
//

#import <UIKit/UIKit.h>

#define HIC_ScreenWidth                            [UIScreen mainScreen].bounds.size.width
#define kScreenHeight                           [UIScreen mainScreen].bounds.size.height

#define kColor                                  [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1]
// 海信蓝
#define HiMainColor                             [UIColor colorWithRed:0.14 green:0.75 blue:0.71 alpha:1.0]

#define kIs_iphone                              (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define kIs_iphoneX                             (UIApplication.sharedApplication.statusBarFrame.size.height>20?YES:NO)
// 状态栏高度
#define kStatusBarHeight                        (CGFloat)(UIApplication.sharedApplication.statusBarFrame.size.height)
// 导航栏高度
#define kNavBarHeight                           (44.0)
// 状态栏和导航栏总高度
#define kNavBarAndStatusBarHeight               (CGFloat)(kStatusBarHeight+kNavBarHeight)

@protocol CameraViewScanInfoDelegate <NSObject>


/**
 相机扫描到二维码信息

 @param info 二维码中的信息
 */
- (void)scanInfo:(NSString *)info;

@end

@interface CameraView : UIView

/**
 相机扫描到二维码信息
 */
@property (weak, nonatomic) NSObject<CameraViewScanInfoDelegate> *cameraViewScanInfoDelegate;

/**
 开始扫描二维码
 */
- (void)startQRCodeScan;

/**
 停止扫描二维码
 */
- (void)stopQRCodeScan;

@end
