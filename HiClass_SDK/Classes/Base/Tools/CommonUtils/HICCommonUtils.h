//
//  HICCommonUtils.h
//  HiClass
//
//  Created by Eddie Ma on 2019/12/31.
//  Copyright © 2019 jingxianglong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HICEnum.h"
NS_ASSUME_NONNULL_BEGIN

@interface HICCommonUtils : NSObject

/// 按钮渐变色
/// @param btn 按钮
/// @param from 第一种颜色
/// @param to 第二种颜色
+ (void)createGradientLayerWithBtn:(UIButton *)btn fromColor:(UIColor *)from toColor:(UIColor *)to;

/// 按钮渐变色
/// @param btn 按钮
/// @param gradientLayer gradientLayer
/// @param from 第一种颜色
/// @param to 第二种颜色
+ (void)createGradientLayerWithBtn:(UIButton *)btn gradientLayer:(CAGradientLayer *)gradientLayer fromColor:(UIColor *)from toColor:(UIColor *)to;

/// View渐变色
/// @param view UIView
/// @param from 第一种颜色
/// @param to 第二种颜色
+ (void)createGradientLayerWithLabel:(UIView *)view fromColor:(UIColor *)from toColor:(UIColor *)to;

+ (void)createGradientLayerWithLabel:(UIView *)view gradientLayer:(CAGradientLayer *)gradientLayer fromColor:(UIColor *)from toColor:(UIColor *)to;

/// Label几行和每行字数
/// @param label UILabel
+ (NSArray *)getLinesArrayOfStringInLabel:(UILabel *)label;

/// Phone的类型
+ (NSString *)iphoneType;
/// String的尺寸
/// @param string 传入的字符串
/// @param fontSize 字符串的字体大小
/// @param stringOnBtn 是否是按钮上的title
/// @param wBounding 用于计算固定宽度上的string的高度
/// @param isRegular 字体粗细是regular还是media
+ (CGSize)sizeOfString:(NSString *)string stringWidthBounding:(CGFloat)wBounding font:(NSInteger)fontSize stringOnBtn:(BOOL)stringOnBtn fontIsRegular:(BOOL)isRegular;

/// label旋转
/// @param radians 旋转角度 ,如逆时针旋转40度: 40/180
/// @param label label
+(void) setTransform:(float)radians forLable:(UILabel *)label;

/// timeStamp to readable date
/// @param timeStamp 时间戳
/// @param isSecs 单位是否是秒(s)
/// @param format 可读格式
+ (NSString *)timeStampToReadableDate:(NSNumber *)timeStamp isSecs:(BOOL)isSecs format:(NSString *)format;
/// 两个时间是否是同一天
/// @param time 第一个时间
/// @param beComparedTime 第二个时间
+ (BOOL)isSameDayWithTime:(NSNumber *)time isSecs:(BOOL)isSecs beComparedTime:(NSNumber *)beComparedTime;

/// 获取时分秒
/// @param totalTime 传入的总秒数
+ (NSString *)getHmsFromSecond:(NSNumber *)totalTime;

+ (UIViewController *)viewController:(UIView *)view;

+ (void)setRoundingCornersWithView:(UIView *)view TopLeft:(BOOL)topLeft TopRight:(BOOL)topRight bottomLeft:(BOOL)btmLeft bottomRight:(BOOL)btmRight cornerRadius:(CGFloat)radius;
///获取当前时间戳（秒级）
+(NSString *)getNowTimeTimestamp;

//获取当前毫秒级时间戳
+ (NSString *)getNowTimeTimestampSS;
// 返回登录页面
+ (void)setRootViewToLoginVC;
///// 默认rootView
//+ (void)setRootViewToMainTabVC;
+ (void)setRootViewToMainVC;

/// 根据角色来rootView
//+(void)setRootViewToRoleMainTabVC;

+ (BOOL)checkPassword:(NSString *)password from:(NSString *)from to:(NSString *)to;

+ (NSMutableAttributedString *)setupAttributeString:(NSString *)text rangeText:(NSString *)rangeText textColor:(UIColor *)color stringColor:(UIColor *)stringColor stringFont:(UIFont *)stringFont;

+ (NSString *)returnReadableTimeZoneWithStartTime:(NSNumber *)startTime andEndTime:(NSNumber *)endTime;
+(NSString *)returnReadableTimeZoneWithoutMinWithStartTime:(NSNumber *)startTime andEndTime:(NSNumber *)endTime;
+ (NSString *)returnReadabelTimeDayWithStartTime:(NSNumber *)startTime andEndTime:(NSNumber *)endTime;
/// 获取当前VC
+ (UIViewController *)getViewController;

/// 设置status bar颜色
/// @param dark 是否为深色
+ (void)setDarkStatusBar:(BOOL)dark;

+ (BOOL)isValidObject:(id)object;

/// 浮点数小数点后去末尾的0
/// @param f 传入的值
+ (NSString *)formatFloat:(float)f;

///相除取百分数
/// @param numerator numerator
/// @param denominator denominator
+ (NSString*)formatFloatDivision:(NSInteger)numerator andDenominator:(NSInteger)denominator;

/// 设置渐变的标签
/// @param title title
/// @param startColor 开始颜色
/// @param endColor 结束颜色
+(void)setLabel:(UIButton *)label andTitle:(NSString *)title andStartColor:(NSString *)startColor andEndColor:(NSString *)endColor;

// FIXME: html与富文本之间的转换
+(NSAttributedString *)changeHtmlStringToAttributedWith:(NSString *)string;

// FIXME: 语音相关的方法
/// - 获取文件夹（没有的话创建）
+ (NSString *)getCreateFilePath:(NSString *)path;
+ (NSString *)createLogPath:(NSString *)pathName;
/// 获取时区字符串
+(NSString *)getTimeWithZone;

// 录音设置
+ (NSDictionary *)getAudioRecorderSettingDict;

//获取名字
+(nullable NSString *)getNameWithUrl:(NSString *)url;

// 获取资源名字并且保存资源
+ (NSString *)getFileNameWithContent:(id)content type:(HMBMessageFileType)type;

//获取资源路径
+ (NSString *)getFilePathWithName:(NSString *)name type:(HMBMessageFileType)type;


/// 字典转json字符串方法
+ (NSString *)convertToJsonData:(NSDictionary *)dict;

+ (NSDictionary *)convertJsonStringToDictinary:(NSString *)jsonString;

+ (void)controller:(UIViewController *)controller Title:(NSString *)title titleColor:(NSString *)titleColor tabBarItemImage:(NSString *)image tabBarItemSelectedImage:(NSString *)selectedImage;
///创建默认头像label
+(UILabel *)setHeaderFrame:(CGRect)frame andText:(NSString *)str;
///创建默认头像label,我的页面专用
+(UILabel *)setHeaderFrameMineCenter:(CGRect)frame andText:(NSString *)str;
/**
 判断某个时间是否处于当天内
 
 @param date 某个时间
 */
+ (BOOL)validateWithDate:(NSNumber *)date;

///开始截屏
+ (void)handleSecurityScreen;
+ (void)startScreenShot;
///开启录屏
+ (void)startSecreenCapture;
+ (void)takeScreenTest;
+ (void)captureScreenTest;
+ (void)alertTakeScreenWithStr:(NSString *)str;

///返回label的高度
+ (CGFloat)returnLabelHeightWithStr:(NSString*)str font:(NSInteger)fontSize andWidth:(CGFloat)width andNumberOfLine:(NSInteger)lines fontIsRegular:(BOOL)isRegular;

///json字符串返回数组
/// @param jsonStr json字符串
+ (NSArray *)covertJSONStrToArray:(NSString *)jsonStr;

+ (NSString *)bundleIdentifier;
+ (HICAppBundleIden)appBundleIden;
@end




NS_ASSUME_NONNULL_END
 
