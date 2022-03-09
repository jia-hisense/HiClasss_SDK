//
//  BMkitMacros.h
//  BMBasekit
//
//  Created by DennisDeng on 15/8/17.
//  Copyright (c) 2015年 DennisDeng. All rights reserved.
//

#ifndef BMkitMacros_h
#define BMkitMacros_h

#pragma mark -
#pragma mark - Device macro

#define BMIS_IPHONE4  (CGSizeEqualToSize(CGSizeMake(320.0f, 480.0f), [[UIScreen mainScreen] bounds].size) || CGSizeEqualToSize(CGSizeMake(480.0f, 320.0f), [[UIScreen mainScreen] bounds].size) ? YES : NO)
#define BMIS_IPHONE5  (CGSizeEqualToSize(CGSizeMake(320.0f, 568.0f), [[UIScreen mainScreen] bounds].size) || CGSizeEqualToSize(CGSizeMake(568.0f, 320.0f), [[UIScreen mainScreen] bounds].size) ? YES : NO)
#define BMIS_IPHONE6  (CGSizeEqualToSize(CGSizeMake(375.0f, 667.0f), [[UIScreen mainScreen] bounds].size) || CGSizeEqualToSize(CGSizeMake(667.0f, 375.0f), [[UIScreen mainScreen] bounds].size) ? YES : NO)
#define BMIS_IPHONE6P (CGSizeEqualToSize(CGSizeMake(414.0f, 736.0f), [[UIScreen mainScreen] bounds].size) || CGSizeEqualToSize(CGSizeMake(736.0f, 414.0f), [[UIScreen mainScreen] bounds].size) ? YES : NO)
#define BMIS_IPHONEX  (CGSizeEqualToSize(CGSizeMake(375.0f, 812.0f), [[UIScreen mainScreen] bounds].size) || CGSizeEqualToSize(CGSizeMake(812.0f, 375.0f), [[UIScreen mainScreen] bounds].size) ?  YES : NO)
#define BMIS_IPHONEXP (CGSizeEqualToSize(CGSizeMake(414.0f, 896.0f), [[UIScreen mainScreen] bounds].size) || CGSizeEqualToSize(CGSizeMake(896.0f, 414.0f), [[UIScreen mainScreen] bounds].size) ? YES : NO)

#define BMIS_IPHONEXANDP (BMIS_IPHONEX || BMIS_IPHONEXP)

//iphone
#define BMIS_IPHONE         (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
//ipad
#define BMIS_PAD            (UI_USER_INTERFACE_IDIOM()== UIUserInterfaceIdiomPad)

// 获取系统版本
#define BMCURRENT_SYSTEMVERSION [[UIDevice currentDevice] systemVersion]
#ifndef BMIOS_VERSION
#define BMIOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#endif

/**
 *  Macros that returns if the iOS version is greater or equal to choosed one
 *
 *  @return Returns a BOOL
 */
#define BMIS_IOS_5_OR_LATER    (BMIOS_VERSION >= 5.0f)
#define BMIS_IOS_6_OR_LATER    (BMIOS_VERSION >= 6.0f)
#define BMIS_IOS_7_OR_LATER    (BMIOS_VERSION >= 7.0f)
#define BMIS_IOS_8_OR_LATER    (BMIOS_VERSION >= 8.0f)
#define BMIS_IOS_9_OR_LATER    (BMIOS_VERSION >= 9.0f)
#define BMIS_IOS_10_OR_LATER   (BMIOS_VERSION >= 10.0f)
#define BMIS_IOS_11_OR_LATER   (BMIOS_VERSION >= 11.0f)
#define BMIS_IOS_12_OR_LATER   (BMIOS_VERSION >= 12.0f)
#define BMIS_IOS_13_OR_LATER   (BMIOS_VERSION >= 13.0f)


/**
 *  Macros to compare system versions
 *
 *  @param v Version, like @"8.0"
 *
 *  @return Return a BOOL
 */
// 检查系统版本
#define BMSYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define BMSYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define BMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define BMSYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define BMSYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define BMAPP_VERSIONNO [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"]
#define BMAPP_BUILDNO [[NSBundle mainBundle] infoDictionary][@"CFBundleVersion"]

// 获取当前语言
#define BMCurrentLanguage [[NSLocale preferredLanguages] objectAtIndex:0]

// 字体
#define UI_BMFONT_MAKE(FontName, FontSize)  [UIFont bm_fontForFontName:FontName size:FontSize]
#define UI_BMNUMBER_FONT(fontSize)          UI_BMFONT_MAKE(FontNameHelveticaNeueBold, fontSize)
#define UI_BM_FONT(fontSize)                [UIFont systemFontOfSize:fontSize]
#define UI_BM_BOLDFONT(fontSize)            [UIFont boldSystemFontOfSize:fontSize]

// 颜色
#define BMRGBColor(r,g,b,a)   [UIColor colorWithRed:(r)/255. green:(g)/255. blue:(b)/255. alpha:a]

// 判断是否IPHONE
#if TARGET_OS_IPHONE
// iPhone Device
#endif

// 判断是真机还是模拟器
#if TARGET_IPHONE_SIMULATOR
// iPhone Simulator
#endif


#pragma mark -
#pragma mark - data change macro

// 由角度获取弧度 由弧度获取角度
#define BMDEGREES_TO_RADIANS(x)       ((x) * (M_PI / 180.0))
#define BMRADIANS_TO_DEGREES(x)       ((x) * (180.0 / M_PI))

//RGB color macro
#define BMUIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


#pragma mark -
#pragma mark - Func



#pragma mark -
#pragma mark - Log

#ifndef BMLog
#define BMLogF(format, ...) NSLog(@"%s:%i: %@", __FILE__, __LINE__, [NSString stringWithFormat:format, ##__VA_ARGS__]);

#ifdef DEBUG
#define BMLog(format, ...) BMLogF(format, ##__VA_ARGS__)
// 调试用
//#define BMLog(format, ...) while(0){}
//#define DebugLog(format, ...) BMLogF(format, ##__VA_ARGS__);
#else
#define BMLog(format, ...) while(0){}
//#define DebugLog(format, ...) while(0){}
#endif
#endif


// DEBUG开关
#ifndef __OPTIMIZE__
#define COMMON_DEBUG    1
#endif

#pragma mark - Text lenth macro



#pragma mark -
#pragma mark - UI macro

#define BMUI_NAVIGATION_BAR_FRIMGEHEIGHT  44.0f //刘海高度
#define BMUI_NAVIGATION_BAR_DEFAULTHEIGHT 44.0f
#define BMUI_NAVIGATION_BAR_HEIGHT        44.0f
#define BMUI_TOOL_BAR_HEIGHT              44.0f
#define BMUI_HOME_INDICATOR_HEIGHT        (BMIS_IPHONEXANDP ? 34.0f : 0.0f)
#define BMUI_TAB_BAR_HEIGHT               (BMIS_IPHONEXANDP ? (49.0f+BMUI_HOME_INDICATOR_HEIGHT) : 49.0f)
#define BMUI_STATUS_BAR_HEIGHT            (BMIS_IPHONEXANDP ? 44.0f : 20.0f)

#define BMUI_SCREEN_WIDTH                 ([[UIScreen mainScreen] bounds].size.width)
#define BMUI_SCREEN_HEIGHT                ([[UIScreen mainScreen] bounds].size.height)

//#define BMUI_SCREEN_WIDTH_ROTATE          ([[UIScreen mainScreen] bounds].size.height)
//#define BMUI_SCREEN_HEIGHT_ROTATE         ([[UIScreen mainScreen] bounds].size.width)
#define BMUI_SCREEN_WIDTH_ROTATE          ([UIScreen mainScreen].bounds.size.width > [UIScreen mainScreen].bounds.size.height ? [UIScreen mainScreen].bounds.size.width : [UIScreen mainScreen].bounds.size.height)


#define BMUI_SCREEN_HEIGHT_ROTATE         ([UIScreen mainScreen].bounds.size.width < [UIScreen mainScreen].bounds.size.height ? [UIScreen mainScreen].bounds.size.width : [UIScreen mainScreen].bounds.size.height)
//#define SCREEN_WIDTH ((([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) || ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)) ? [[UIScreen mainScreen] bounds].size.width : [[UIScreen mainScreen] bounds].size.height)
//#define SCREEN_HEIGHT ((([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) || ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)) ? [[UIScreen mainScreen] bounds].size.height : [[UIScreen mainScreen] bounds].size.width)
#define BMUI_SCREEN_SCALE                 ([UIScreen mainScreen].scale)
#define BMUI_MAINSCREEN_HEIGHT            (BMUI_SCREEN_HEIGHT - BMUI_STATUS_BAR_HEIGHT)
#define BMUI_MAINSCREEN_HEIGHT_ROTATE     (BMUI_SCREEN_WIDTH - BMUI_STATUS_BAR_HEIGHT)
#define BMUI_WHOLE_SCREEN_FRAME           CGRectMake(0, 0, BMUI_SCREEN_WIDTH, BMUI_SCREEN_HEIGHT)
#define BMUI_WHOLE_SCREEN_FRAME_ROTATE    CGRectMake(0, 0, BMUI_SCREEN_HEIGHT, BMUI_SCREEN_WIDTH)
#define BMUI_MAIN_VIEW_FRAME              CGRectMake(0, BMUI_STATUS_BAR_HEIGHT, BMUI_SCREEN_WIDTH, BMUI_MAINSCREEN_HEIGHT)
#define BMUI_MAIN_VIEW_FRAME_ROTATE       CGRectMake(0, BMUI_STATUS_BAR_HEIGHT, BMUI_SCREEN_HEIGHT, BMUI_MAINSCREEN_HEIGHT_ROTATE)

#define BMUI_IPHONE4_SCREEN_HEIGHT        480.0f
#define BMUI_IPHONE5_SCREEN_HEIGHT        568.0f
#define BMUI_IPHONE6_SCREEN_HEIGHT        667.0f
#define BMUI_IPHONE6P_SCREEN_HEIGHT       736.0f

//6为标准适配的,如果需要其他标准可以修改
#define kBMScale_W(w) ((BMUI_SCREEN_WIDTH)/375.0f) * (w)
#define kBMScale_H(h) ((BMUI_SCREEN_HEIGHT)/667.0f) * (h)

// 单像素
#define BMSINGLE_LINE_WIDTH           (1.0f / [UIScreen mainScreen].scale)
#define BMSINGLE_LINE_ADJUST_OFFSET   ((1.0f / [UIScreen mainScreen].scale) / 2.0f)
// UIView *view = [[UIView alloc] initWithFrame:CGrect(x - SINGLE_LINE_ADJUST_OFFSET, 0, SINGLE_LINE_WIDTH, 100)];


#pragma mark -
#pragma mark - Default define

// 动画默认时长
#define BMDEFAULT_DELAY_TIME              (0.25f)
// 等待默认时长
#define BMPROGRESSBOX_DEFAULT_HIDE_DELAY  (2.0f)

#define BMTABLE_CELL_HEIGHT   44.0f

#define BMUI_DEFAULT_LINECOLOR        [UIColor bm_colorWithHex:0xD8D8D8]

// Cell背景颜色
#define BMUI_CELL_BGCOLOR             [UIColor bm_colorWithHex:0xFFFFFF]

// Cell选中状态背景颜色
#define BMUI_CELL_SELECT_BGCOLOR      [UIColor bm_colorWithHex:0xCCCCCC]
#define BMUI_CELL_HIGHLIGHT_BGCOLOR   [UIColor bm_colorWithHex:0xE8373D]


// 弱引用/强引用 weakSelf
#define BMWeakSelf                  __weak __typeof(self) weakSelf = self;
#define BMStrongSelf                __strong __typeof(weakSelf) strongSelf = weakSelf;

// 弱引用/强引用 weakType
#define BMWeakType(type)            __weak __typeof(type) weak##type = type;
#define BMStrongType(type)          __strong __typeof(weak##type) strong##type = weak##type;

// 过期提醒
#define BM_DEPRECATED(instead)      NS_DEPRECATED(2_0, 2_0, 2_0, 2_0, instead)
#define BM_DEPRECATED_IOS(instead)  NS_DEPRECATED_IOS(2_0, 2_0, instead)

#define BM_BUNDLE_NAME                  @ "BMKitResources.bundle"
#define BMKit_Localized                 [NSBundle bundleWithPath:[[NSBundle bm_mainResourcePath] stringByAppendingPathComponent:BM_BUNDLE_NAME]]
#define BMKitLocalized(key, comment)    [BMKit_Localized localizedStringForKey:key value:@"" table:nil]

#endif
