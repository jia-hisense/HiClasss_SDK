//
//  HICCommonUtils.m
//  HiClass
//
//  Created by Eddie Ma on 2019/12/31.
//  Copyright © 2019 jingxianglong. All rights reserved.
//

#import "HICCommonUtils.h"
#import <sys/utsname.h>
#import <CoreText/CoreText.h>
#import "HICUserLoginVC.h"
#import "HICBaseNavigationViewController.h"
#import "MainTabBarVC.h"
#import <AVFoundation/AVFoundation.h>
@implementation HICCommonUtils

+ (void)createGradientLayerWithBtn:(UIButton *)btn fromColor:(UIColor *)from toColor:(UIColor *)to{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)from.CGColor, (__bridge id)to.CGColor];
    gradientLayer.locations = @[@0.0, @1.0];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1.0, 0);
    gradientLayer.frame = CGRectMake(0, 0, btn.frame.size.width, btn.frame.size.height);
    [btn.layer insertSublayer:gradientLayer atIndex:0];
}

+ (void)createGradientLayerWithBtn:(UIButton *)btn gradientLayer:(CAGradientLayer *)gradientLayer fromColor:(UIColor *)from toColor:(UIColor *)to {
    gradientLayer.colors = @[(__bridge id)from.CGColor, (__bridge id)to.CGColor];
    gradientLayer.locations = @[@0.0, @1.0];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1.0, 0);
    gradientLayer.frame = CGRectMake(0, 0, btn.frame.size.width, btn.frame.size.height);
    [btn.layer insertSublayer:gradientLayer atIndex:0];
}

+ (void)createGradientLayerWithLabel:(UIView *)view fromColor:(UIColor *)from toColor:(UIColor *)to {
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)from.CGColor, (__bridge id)to.CGColor];
    gradientLayer.locations = @[@0.0, @1.0];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1.0, 0);
    gradientLayer.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
    [view.layer insertSublayer:gradientLayer atIndex:0];
}

+ (void)createGradientLayerWithLabel:(UIView *)view gradientLayer:(CAGradientLayer *)gradientLayer fromColor:(UIColor *)from toColor:(UIColor *)to {
    gradientLayer.colors = @[(__bridge id)from.CGColor, (__bridge id)to.CGColor];
    gradientLayer.locations = @[@0.0, @1.0];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1.0, 0);
    gradientLayer.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
    [view.layer insertSublayer:gradientLayer atIndex:0];
}

+ (NSArray *)getLinesArrayOfStringInLabel:(UILabel *)label {
    NSString *text = [label text];
    UIFont *font = [label font];
    CGRect rect = [label frame];

    CTFontRef myFont = CTFontCreateWithName(( CFStringRef)([font fontName]), [font pointSize], NULL);
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text];
    [attStr addAttribute:(NSString *)kCTFontAttributeName value:(__bridge  id)myFont range:NSMakeRange(0, attStr.length)];
    CFRelease(myFont);
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString(( CFAttributedStringRef)attStr);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0,0,rect.size.width,100000));
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
    NSArray *lines = ( NSArray *)CTFrameGetLines(frame);
    NSMutableArray *linesArray = [[NSMutableArray alloc]init];
    for (id line in lines) {
        CTLineRef lineRef = (__bridge  CTLineRef )line;
        CFRange lineRange = CTLineGetStringRange(lineRef);
        NSRange range = NSMakeRange(lineRange.location, lineRange.length);
        NSString *lineString = [text substringWithRange:range];
        CFAttributedStringSetAttribute((CFMutableAttributedStringRef)attStr, lineRange, kCTKernAttributeName, (CFTypeRef)([NSNumber numberWithFloat:0.0]));
        CFAttributedStringSetAttribute((CFMutableAttributedStringRef)attStr, lineRange, kCTKernAttributeName, (CFTypeRef)([NSNumber numberWithInt:0.0]));
        //DDLogDebug(@"''''''''''''''''''%@",lineString);
        [linesArray addObject:lineString];
    }

    CGPathRelease(path);
    CFRelease( frame );
    CFRelease(frameSetter);
    return (NSArray *)linesArray;
}

+(void) setTransform:(float)radians forLable:(UILabel *)label {
    label.transform = CGAffineTransformMakeRotation(M_PI*radians);
}

+ (NSString *)iphoneType {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *phoneModel = [NSString stringWithCString: systemInfo.machine encoding:NSASCIIStringEncoding];
    // 像素小于等于1136×640（例如：iPhone 5）
    if ([phoneModel isEqualToString:@"iPhone3,1"] ||
        [phoneModel isEqualToString:@"iPhone3,2"])   return @"s-iPhone";
    if ([phoneModel isEqualToString:@"iPhone4,1"])   return @"s-iPhone";
    if ([phoneModel isEqualToString:@"iPhone5,1"] ||
        [phoneModel isEqualToString:@"iPhone5,2"])   return @"s-iPhone";
    if ([phoneModel isEqualToString:@"iPhone5,3"] ||
        [phoneModel isEqualToString:@"iPhone5,4"])   return @"s-iPhone";
    if ([phoneModel isEqualToString:@"iPhone6,1"] ||
        [phoneModel isEqualToString:@"iPhone6,2"])   return @"s-iPhone";
    // 像素1920×1080（例如：iPhone 6s plus）
    if ([phoneModel isEqualToString:@"iPhone7,1"]) return @"l-iPhone";
    if ([phoneModel isEqualToString:@"iPhone8,2"]) return @"l-iPhone";
    if ([phoneModel isEqualToString:@"iPhone9,2"]) return @"l-iPhone";
    if ([phoneModel isEqualToString:@"iPhone10,2"] ||
        [phoneModel isEqualToString:@"iPhone10,5"]) return @"l-iPhone";
    // 像素1334×750 （例如：iPhone 7）
    if ([phoneModel isEqualToString:@"iPhone7,2"]) return @"m-iPhone";
    if ([phoneModel isEqualToString:@"iPhone8,1"]) return @"m-iPhone";
    if ([phoneModel isEqualToString:@"iPhone8,4"]) return @"m-iPhone";
    if ([phoneModel isEqualToString:@"iPhone9,1"]) return @"m-iPhone";
    if ([phoneModel isEqualToString:@"iPhone10,1"] ||
        [phoneModel isEqualToString:@"iPhone10,4"]) return @"m-iPhone";
    // 像素2436×1125（例如：iPhone X）
    if ([phoneModel isEqualToString:@"iPhone10,3"] ||
        [phoneModel isEqualToString:@"iPhone10,6"]) return @"xl-iPhone";
    if ([phoneModel isEqualToString:@"iPhone11,8"]) return @"xl-iPhone";
    if ([phoneModel isEqualToString:@"iPhone11,2"]) return @"xl-iPhone";
    // 像素2688×1242（例如：iPhone XS Max）
    if ([phoneModel isEqualToString:@"iPhone11,4"] ||
        [phoneModel isEqualToString:@"iPhone11,6"]) return @"xxl-iPhone";

    if ([phoneModel isEqualToString:@"iPad1,1"]) return @"iPad";
    if ([phoneModel isEqualToString:@"iPad2,1"] ||
        [phoneModel isEqualToString:@"iPad2,2"] ||
        [phoneModel isEqualToString:@"iPad2,3"] ||
        [phoneModel isEqualToString:@"iPad2,4"]) return @"iPad 2";
    if ([phoneModel isEqualToString:@"iPad3,1"] ||
        [phoneModel isEqualToString:@"iPad3,2"] ||
        [phoneModel isEqualToString:@"iPad3,3"]) return @"iPad 3";
    if ([phoneModel isEqualToString:@"iPad3,4"] ||
        [phoneModel isEqualToString:@"iPad3,5"] ||
        [phoneModel isEqualToString:@"iPad3,6"]) return @"iPad 4";
    if ([phoneModel isEqualToString:@"iPad4,1"] ||
        [phoneModel isEqualToString:@"iPad4,2"] ||
        [phoneModel isEqualToString:@"iPad4,3"]) return @"iPad Air";
    if ([phoneModel isEqualToString:@"iPad5,3"] ||
        [phoneModel isEqualToString:@"iPad5,4"]) return @"iPad Air 2";
    if ([phoneModel isEqualToString:@"iPad6,3"] ||
        [phoneModel isEqualToString:@"iPad6,4"]) return @"iPad Pro 9.7-inch";
    if ([phoneModel isEqualToString:@"iPad6,7"] ||
        [phoneModel isEqualToString:@"iPad6,8"]) return @"iPad Pro 12.9-inch";
    if ([phoneModel isEqualToString:@"iPad6,11"] ||
        [phoneModel isEqualToString:@"iPad6,12"]) return @"iPad 5";
    if ([phoneModel isEqualToString:@"iPad7,1"] ||
        [phoneModel isEqualToString:@"iPad7,2"]) return @"iPad Pro 12.9-inch 2";
    if ([phoneModel isEqualToString:@"iPad7,3"] ||
        [phoneModel isEqualToString:@"iPad7,4"]) return @"iPad Pro 10.5-inch";
    if ([phoneModel isEqualToString:@"iPad2,5"] ||
        [phoneModel isEqualToString:@"iPad2,6"] ||
        [phoneModel isEqualToString:@"iPad2,7"]) return @"iPad mini";
    if ([phoneModel isEqualToString:@"iPad4,4"] ||
        [phoneModel isEqualToString:@"iPad4,5"] ||
        [phoneModel isEqualToString:@"iPad4,6"]) return @"iPad mini 2";
    if ([phoneModel isEqualToString:@"iPad4,7"] ||
        [phoneModel isEqualToString:@"iPad4,8"] ||
        [phoneModel isEqualToString:@"iPad4,9"]) return @"iPad mini 3";
    if ([phoneModel isEqualToString:@"iPad5,1"] ||
        [phoneModel isEqualToString:@"iPad5,2"]) return @"iPad mini 4";
    if ([phoneModel isEqualToString:@"iPod1,1"]) return @"iTouch";
    if ([phoneModel isEqualToString:@"iPod2,1"]) return @"iTouch2";
    if ([phoneModel isEqualToString:@"iPod3,1"]) return @"iTouch3";
    if ([phoneModel isEqualToString:@"iPod4,1"]) return @"iTouch4";
    if ([phoneModel isEqualToString:@"iPod5,1"]) return @"iTouch5";
    if ([phoneModel isEqualToString:@"iPod7,1"]) return @"iTouch6";

    if ([phoneModel isEqualToString:@"i386"] || [phoneModel isEqualToString:@"x86_64"]) return @"iPhone Simulator";

    return @"Unknown";
}

+ (CGSize)sizeOfString:(NSString *)string stringWidthBounding:(CGFloat)wBounding font:(NSInteger)fontSize stringOnBtn:(BOOL)stringOnBtn fontIsRegular:(BOOL)isRegular {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;

    NSDictionary *attributes = @{NSFontAttributeName:[UIFont fontWithName:isRegular ? @"PingFangSC-Regular" : @"PingFangSC-Medium" size:stringOnBtn ? fontSize + 1 : fontSize], NSParagraphStyleAttributeName:paragraphStyle.copy};

    CGSize labelSize = [string boundingRectWithSize:CGSizeMake(wBounding, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    return labelSize;
}

+ (NSString *)timeStampToReadableDate:(NSNumber *)timeStamp isSecs:(BOOL)isSecs format:(NSString *)format {
    if (timeStamp) {
        NSDateFormatter *fm = [[NSDateFormatter alloc] init];
        [fm setDateFormat: format ? format : @"MM-dd HH:mm"];
        double secsTime = isSecs ? [timeStamp doubleValue] : [timeStamp doubleValue]/1000.0;
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:secsTime];
        NSString *dateStr = [fm stringFromDate:date];
        return dateStr;
    } else {
        return @"";
    }
}

+ (BOOL)isSameDayWithTime:(NSNumber *)time isSecs:(BOOL)isSecs beComparedTime:(NSNumber *)beComparedTime {
    NSString *timeStr = [self timeStampToReadableDate:time isSecs:isSecs format:@"yyyyMMdd"];
    NSString *beComparedTimeStr = [self timeStampToReadableDate:beComparedTime isSecs:isSecs format:@"yyyyMMdd"];
    if ([timeStr isEqualToString:beComparedTimeStr]) {
        return YES;
    }
    return NO;
}

+ (NSString *)getHmsFromSecond:(NSNumber *)totalTime {

    NSInteger seconds = [totalTime integerValue];
    //format of hour
    NSString *str_hour = [NSString stringWithFormat:@"%ld%@",(long)seconds/3600,NSLocalizableString(@"hours", nil)];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%ld%@",(long)(seconds%3600)/60,NSLocalizableString(@"fenTime", nil)];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%ld%@",seconds%60l,NSLocalizableString(@"seconds", nil)];
    //format of time
    if (![NSString isValidStr:str_hour] || [str_hour isEqualToString:[NSString stringWithFormat:@"0%@",NSLocalizableString(@"hours", nil)]]) {
        str_hour = @"";
    }
    if (![NSString isValidStr:str_minute] || [str_minute isEqualToString:[NSString stringWithFormat:@"0%@",NSLocalizableString(@"fenTime", nil)]]) {
        str_minute = @"";
    }
    if (![NSString isValidStr:str_second] || [str_second isEqualToString:[NSString stringWithFormat:@"0%@",NSLocalizableString(@"seconds", nil)]]) {
        str_second = @"";
    }
    NSString *format_time = [NSString stringWithFormat:@"%@%@%@",str_hour,str_minute,str_second];

    return format_time;

}

+ (UIViewController *)viewController:(UIView *)view {
    UIResponder *next = [view nextResponder];
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = [next nextResponder];
    } while (next !=nil);
    return nil;
}

+ (void)setRoundingCornersWithView:(UIView *)view TopLeft:(BOOL)topLeft TopRight:(BOOL)topRight bottomLeft:(BOOL)btmLeft bottomRight:(BOOL)btmRight cornerRadius:(CGFloat)radius {
    UIBezierPath * maskPath;
    if (topLeft && topRight) {
      maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(radius, radius)];
    } else if (btmLeft && btmRight) {
        maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadii:CGSizeMake(radius, radius)];
    } else if (topLeft && topRight && btmLeft && btmRight) {
        maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight|UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(radius, radius)];
    } else if (topLeft && !topRight && !btmLeft && btmRight) {
        maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:UIRectCornerBottomRight|UIRectCornerTopLeft cornerRadii:CGSizeMake(radius, radius)];
    } else if (!topLeft && !btmRight && btmLeft && topRight){
        maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(radius, radius)];
    }
    else if (btmRight) {
        maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:UIRectCornerBottomRight cornerRadii:CGSizeMake(radius, radius)];
    }
    CAShapeLayer * maskLayer = [[CAShapeLayer alloc]init];
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
}

+(NSString *)getNowTimeTimestamp{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;

    [formatter setDateStyle:NSDateFormatterMediumStyle];

    [formatter setTimeStyle:NSDateFormatterShortStyle];

    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制

    //设置时区,这个对于时间的处理有时很重要

    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];

    [formatter setTimeZone:timeZone];

    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式

    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];

    return timeSp;

}
+(NSString *)getNowTimeTimestampSS{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss SSS"]; // 设置想要的格式，hh与HH的区别:分别表示12小时制,24小时制
    //设置时区,这一点对时间的处理有时很重要
   NSTimeZone*timeZone=[NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    NSDate *datenow = [NSDate date];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]*1000];
    return timeSp;
}
+ (void)setRootViewToLoginVC {
    UIWindow * window = [[UIApplication sharedApplication].delegate window];
    if ([window.rootViewController isKindOfClass:UINavigationController.class]) {
        HICBaseNavigationViewController *nav = (HICBaseNavigationViewController *)window.rootViewController;
        UIViewController *vc = nav.childViewControllers.firstObject;
        if ([vc isKindOfClass:HICUserLoginVC.class]) {
            return;
        }
    }
    HICBaseNavigationViewController *nav = [[HICBaseNavigationViewController alloc] initWithRootViewController: HICUserLoginVC.new];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    window.rootViewController = nav;
}

+ (void)setRootViewToMainVC {
    MainTabBarVC *mainVC = [MainTabBarVC new];
    HICBaseNavigationViewController *nav = [[HICBaseNavigationViewController alloc] initWithRootViewController:mainVC];
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    window.rootViewController = nav;
}

+ (BOOL)checkPassword:(NSString *)password from:(NSString *)from to:(NSString *)to {
    NSString *pattern = [NSString stringWithFormat:@"^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{%@,%@}", from, to];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",pattern];
    BOOL isMatch = [pred evaluateWithObject:password];
    return isMatch;
}

+ (NSMutableAttributedString *)setupAttributeString:(NSString *)text rangeText:(NSString *)rangeText textColor:(UIColor *)color stringColor:(UIColor *)stringColor stringFont:(UIFont *)stringFont {
    NSRange hightlightTextRange = [text rangeOfString:rangeText];
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:text];
    NSRange greyRange = [text rangeOfString:NSLocalizableString(@"aNote", nil)];
    if (hightlightTextRange.length > 0) {
        [attributeStr addAttribute:NSForegroundColorAttributeName value:color range:hightlightTextRange];
        [attributeStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:13.0f] range:hightlightTextRange];
         [attributeStr addAttributes:@{NSForegroundColorAttributeName:stringColor,NSFontAttributeName:stringFont} range:greyRange];
        return attributeStr;
        
        }else {
            return [rangeText copy];
        }
}
///返回可读的时间段
+(NSString *)returnReadableTimeZoneWithStartTime:(NSNumber *)startTime andEndTime:(NSNumber *)endTime{
//andCurTime:(NSNumber *)curTime{
    if ([startTime isEqualToNumber:@0] && [endTime isEqualToNumber:@0]) {
        return NSLocalizableString(@"unlimited", nil);
    }else if([startTime isEqualToNumber:@0]){
        return [NSString stringWithFormat:@"--%@ %@",NSLocalizableString(@"to", nil),[HICCommonUtils timeStampToReadableDate:endTime isSecs:YES format:@"yyyy-MM-dd HH:mm"]];
    }else if([endTime isEqualToNumber:@0]){
        return  [NSString stringWithFormat:@"%@%@ %@",[HICCommonUtils timeStampToReadableDate:startTime isSecs:YES format:@"yyyy-MM-dd HH:mm"],NSLocalizableString(@"to", nil),NSLocalizableString(@"unlimited", nil)];
    }else{
        NSString *format;
               NSString *timestr;
               if ([endTime integerValue] - [startTime integerValue] > 31622400) {
                   format = @"yyyy-MM-dd HH:mm";
                  timestr = [NSString stringWithFormat:@"%@%@%@",[HICCommonUtils timeStampToReadableDate:startTime isSecs:YES format:format],NSLocalizableString(@"to", nil),[HICCommonUtils timeStampToReadableDate:endTime isSecs:YES format:format]];
               }else{
                   format = @"MM-dd HH:mm";
                   timestr = [NSString stringWithFormat:@"%@%@%@",[HICCommonUtils timeStampToReadableDate:startTime isSecs:YES format:format],NSLocalizableString(@"to", nil),[HICCommonUtils timeStampToReadableDate:endTime isSecs:YES format:format]];
               }
        return timestr;
        
    }
}
+(NSString *)returnReadableTimeZoneWithoutMinWithStartTime:(NSNumber *)startTime andEndTime:(NSNumber *)endTime{
//andCurTime:(NSNumber *)curTime{
    if ([startTime isEqualToNumber:@0] && [endTime isEqualToNumber:@0]) {
        return NSLocalizableString(@"unlimited", nil);
    }else if([startTime isEqualToNumber:@0]){
        return [NSString stringWithFormat:@"--%@ %@",NSLocalizableString(@"to", nil),[HICCommonUtils timeStampToReadableDate:endTime isSecs:YES format:@"yyyy-MM-dd"]];
    }else if([endTime isEqualToNumber:@0]){
        return  [NSString stringWithFormat:@"%@%@ %@",[HICCommonUtils timeStampToReadableDate:startTime isSecs:YES format:@"yyyy-MM-dd"],NSLocalizableString(@"to", nil),NSLocalizableString(@"unlimited", nil)];
    }else{
        NSString *format;
               NSString *timestr;
               if ([endTime integerValue] - [startTime integerValue] > 31622400) {
                   format = @"yyyy-MM-dd";
                  timestr = [NSString stringWithFormat:@"%@%@%@",[HICCommonUtils timeStampToReadableDate:startTime isSecs:YES format:format],NSLocalizableString(@"to", nil),[HICCommonUtils timeStampToReadableDate:endTime isSecs:YES format:format]];
               }else{
                   format = @"MM-dd";
                   timestr = [NSString stringWithFormat:@"%@%@%@",[HICCommonUtils timeStampToReadableDate:startTime isSecs:YES format:format],NSLocalizableString(@"to", nil),[HICCommonUtils timeStampToReadableDate:endTime isSecs:YES format:format]];
               }
        return timestr;
        
    }
}

+(NSString *)returnReadabelTimeDayWithStartTime:(NSNumber *)startTime andEndTime:(NSNumber *)endTime{
    NSString *format = @"MM-dd HH:mm";
    NSString *timeStr;
    //传入时间毫秒数
    
    if (![HICCommonUtils isSameDayWithTime:startTime isSecs:YES beComparedTime:endTime]) {
        timeStr = [NSString stringWithFormat:@"%@%@%@",[HICCommonUtils timeStampToReadableDate:startTime isSecs:YES format:format],NSLocalizableString(@"to", nil),[HICCommonUtils timeStampToReadableDate:endTime isSecs:YES format:format]];
    }else{
        timeStr = [NSString stringWithFormat:@"%@ %@%@%@",[HICCommonUtils timeStampToReadableDate:startTime isSecs:YES format:@"MM-dd"],[HICCommonUtils timeStampToReadableDate:startTime isSecs:YES format:@"HH:mm"],NSLocalizableString(@"to", nil),[HICCommonUtils timeStampToReadableDate:endTime isSecs:YES format:@"HH:mm"]];
    }
    return timeStr;
}
+ (UIViewController *)getViewController {
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    if (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}

+ (void)setDarkStatusBar:(BOOL)dark {
    if (dark) {
        if (@available(iOS 13.0, *)) {
            UIApplication.sharedApplication.statusBarStyle = UIStatusBarStyleDarkContent;
        } else {
            // Fallback on earlier versions
            UIApplication.sharedApplication.statusBarStyle = UIStatusBarStyleDefault;
        }
    } else {
        if (@available(iOS 13.0, *)) {
            UIApplication.sharedApplication.statusBarStyle = UIStatusBarStyleLightContent;
        } else {
            // Fallback on earlier versions
            UIApplication.sharedApplication.statusBarStyle = UIStatusBarStyleLightContent;
        }
    }
}

+ (BOOL)isValidObject:(id)object {
    if (object == nil || [object isEqual:[NSNull null]] || [object isEqual:@"(null)"] || [object isEqual:@"（null）"] || [object isEqual:@"(Null)"] || [object isEqual:@"（Null）"]) {
        return NO;
    }
    return YES;
}

+ (NSString *)formatFloat:(float)f{
    if(!f && f != 0){
        return @"";
    }
    if (fmodf(f, 1)==0) { //无有效小数位
        return [NSString stringWithFormat:@"%.0f",f];
    } else if (fmodf(f*10, 1)==0) {//如果有一位小数点
        return [NSString stringWithFormat:@"%.1f",f];
    }
    else {//如果有两位或以上小数点
//        return [NSString stringWithFormat:@"%.2f",f];
         return [NSString stringWithFormat:@"%.1f",f];
    }
}
+ (NSString*)formatFloatDivision:(NSInteger)numerator andDenominator:(NSInteger)denominator{
    if (denominator == 0) {
        return [NSString stringWithFormat:@"100%@",@"%"];
    }
    CGFloat re = numerator *10000 / denominator /100;
    return [NSString stringWithFormat:@"%@%@",[HICCommonUtils formatFloat:re > 100 ?100:re],@"%"];
}

+ (void)setLabel:(UIButton *)label andTitle:(NSString *)title andStartColor:(NSString *)startColor andEndColor:(NSString *)endColor{
    [label setTitle:title forState:UIControlStateNormal];
    [HICCommonUtils createGradientLayerWithBtn:label fromColor:[UIColor colorWithHexString:startColor] toColor:[UIColor colorWithHexString:endColor]];
}

// FIXME: html转换富文本
+(NSAttributedString *)changeHtmlStringToAttributedWith:(NSString *)string {
    NSAttributedString *attStr = [[NSAttributedString alloc] initWithData:[string dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    return attStr;
}

+(NSString *)changeAttributedToHtmlStringWith:(NSAttributedString *)string {
    //富文本转换为html(最后相当于整个网页代码，会有css等)
    NSDictionary *dic = @{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,NSCharacterEncodingDocumentAttribute:@(NSUnicodeStringEncoding)};
    NSData *data = [string dataFromRange:NSMakeRange(0, string.length) documentAttributes:dic error:nil];
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUnicodeStringEncoding];
    return str;
}

// FIXME: 获取时区字符串
+(NSString *)getTimeWithZone {
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"yyyy-MM-dd-HH-mm-ss-SSS"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    return [dateFormatter stringFromDate:[NSDate date]];
}

#pragma mark - 获取文件夹（没有的话创建）
+ (NSString *)getCreateFilePath:(NSString *)path {
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return path;
}

+ (NSString *)createLogPath:(NSString *)pathName {
    NSString *logPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSFileManager *mgr = [NSFileManager defaultManager];
    logPath = [NSString stringWithFormat:@"%@/%@",logPath, pathName];
    if (![mgr fileExistsAtPath:logPath]) {
        [mgr createDirectoryAtPath:logPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return logPath;
}


// 录音设置
+ (NSDictionary *)getAudioRecorderSettingDict {
    NSDictionary *recordSetting = [[NSDictionary alloc] initWithObjectsAndKeys:
                                   [NSNumber numberWithFloat: 8000.0],AVSampleRateKey, //采样率
                                   [NSNumber numberWithInt: kAudioFormatLinearPCM],AVFormatIDKey,
                                   [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,//采样位数 默认 16
                                   [NSNumber numberWithInt: 1], AVNumberOfChannelsKey,//通道的数目
                                   [NSNumber numberWithBool:NO],AVLinearPCMIsBigEndianKey,//大端还是小端 是内存的组织方式
                                   [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,//采样信号是整数还是浮点数
                                   [NSNumber numberWithInt: AVAudioQualityMedium],AVEncoderAudioQualityKey,//音频编码质量
                                   nil];
    return recordSetting;
}

// 获取资源名字并且保存资源
+ (NSString *)getFileNameWithContent:(id)content type:(HMBMessageFileType)type {

    if (!content) {
        return @"";
    }

    NSString *filePath;
    NSData *data;

    switch (type) {
        case HMBMessageFileType_image://image
        {
            filePath = [NSString stringWithFormat:@"%@/%@.jpg",kHMBPath_image,[self getTimeWithZone]];
            data = [self getDataWithImage:content num:1];
        }
            break;
        case HMBMessageFileType_wav:case HMBMessageFileType_amr://语音
        {
            //转格式 WAV-->AMR
            [EMVoiceConverter wavToAmr:[NSString stringWithFormat:@"%@/%@.wav",kHMBPath_voice_wav,content] amrSavePath:[NSString stringWithFormat:@"%@/%@.amr",kHMBPath_voice_amr,content]];
        }
            break;
        case HMBMessageFileType_gif://gif
        {
            filePath = [NSString stringWithFormat:@"%@/%@.gif",kHMBPath_gif,[self getTimeWithZone]];
        }
            break;
        case HMBMessageFileType_video://video
        {
            filePath = [NSString stringWithFormat:@"%@/%@.mp4",kHMBPath_video,[self getTimeWithZone]];
//            if ([content isKindOfClass:NSString.class]) {
//                NSString *path = (NSString *)content;
//                if ([path containsString:@".MOV"]) {
//                    NSError *error;
//                    data = [NSData dataWithContentsOfFile:[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error]];
//                    DDLogDebug(@"-----视频h转换：%@", error);
//                }else {
//                    data = [NSData dataWithContentsOfFile:content];
//                }
//            }
            data = [NSData dataWithContentsOfFile:content];
        }
            break;
        case HMBMessageFileType_video_image://视频图片
        {
            UIImage *image = [self getVideoImageWithVideoPath:content];
            data = [self getDataWithImage:image num:1];
            filePath = [NSString stringWithFormat:@"%@/%@.jpg",kHMBPath_video_image,[self getNameWithUrl:content]];
        }
            break;
        default:
            break;
    }

    if (data) {
        [data writeToFile:filePath atomically:NO];
    }

    return filePath.length?filePath.lastPathComponent:@"";
}

//获取名字
+ (nullable NSString *)getNameWithUrl:(NSString *)url{

    if (!url.length) {
        return nil;
    }
    NSArray *arr = [url.lastPathComponent componentsSeparatedByString:@"."];
    if (arr.count) {
        return arr.firstObject;
    }
    return url;
}

//获取资源路径
+ (NSString *)getFilePathWithName:(NSString *)name type:(HMBMessageFileType)type{

    switch (type) {
        case HMBMessageFileType_image://image
        {
            return [NSString stringWithFormat:@"%@/%@.jpg",kHMBPath_image,name];
        }
            break;
        case HMBMessageFileType_wav://语音wav
        {
            return [NSString stringWithFormat:@"%@/%@.wav",kHMBPath_voice_wav,name];
        }
            break;
        case HMBMessageFileType_amr://语音amr
        {
            return [NSString stringWithFormat:@"%@/%@.amr",kHMBPath_voice_amr,name];
        }
            break;
        case HMBMessageFileType_gif://gif
        {
            return [NSString stringWithFormat:@"%@/%@.gif",kHMBPath_gif,name];
        }
            break;
        case HMBMessageFileType_video://video
        {
            return [NSString stringWithFormat:@"%@/%@.mp4",kHMBPath_video,[self getNameWithUrl:name]];
        }
            break;
        case HMBMessageFileType_video_image://视频图片
        {
            return [NSString stringWithFormat:@"%@/%@.jpg",kHMBPath_video_image,[self getNameWithUrl:name]];
        }
            break;
        default:
            break;
    }
    return name;
}

// TODO: 图片转数据
+ (NSData *)getDataWithImage:(UIImage *)image num:(CGFloat)num {

    image = [self fixOrientation:image];
    NSData *data = UIImageJPEGRepresentation(image, num);
    if (!data) {
        data = UIImagePNGRepresentation(image);
    }
    return data;
}

+ (UIImage *)fixOrientation:(UIImage *)aImage {

    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;

    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;

    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;

        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;

        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }

    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;

        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }

    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;

        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }

    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}
// FIXME: 获取视频第一帧图片
+ (UIImage *)getVideoImageWithVideoPath:(NSString *)videoPath {

    if (!videoPath.length){
        return nil;
    }

    AVURLAsset *asset;
    if ([videoPath hasPrefix:@"http"]) {//网络

        asset = [[AVURLAsset alloc] initWithURL:[NSURL URLWithString:videoPath] options:nil];
    }else{//本地

        asset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:videoPath] options:nil];
    }

    NSParameterAssert(asset);
    AVAssetImageGenerator *assetImageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;

    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = 1;
    NSError *thumbnailImageGenerationError = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60) actualTime:NULL error:&thumbnailImageGenerationError];

    if (!thumbnailImageRef)
        DDLogDebug(@"thumbnailImageGenerationError ==== %@", thumbnailImageGenerationError);

    UIImage *thumbnailImage = thumbnailImageRef ? [[UIImage alloc] initWithCGImage:thumbnailImageRef] : nil;

    CGImageRelease(thumbnailImageRef);

    return thumbnailImage;
}


#pragma mark - JSON

+(NSString *)convertToJsonData:(NSDictionary *)dict
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    if (!jsonData) {
        DDLogDebug(@"%@",error);
    }else{
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    NSRange range = {0,jsonString.length};
    //去掉字符串中的空格
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    NSRange range2 = {0,mutStr.length};
    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    return mutStr;
}

// JSON字符串转化为字典
+ (NSDictionary *)convertJsonStringToDictinary:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if(err) {
        DDLogDebug(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

+ (void)controller:(UIViewController *)controller Title:(NSString *)title titleColor:(NSString *)titleColor tabBarItemImage:(NSString *)image tabBarItemSelectedImage:(NSString *)selectedImage {
    controller.tabBarItem.title = title;
    UIImage *imageHomeNore = [UIImage imageNamed:image];
    imageHomeNore = [imageHomeNore imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    controller.tabBarItem.image = imageHomeNore;
    NSDictionary *dictHomeNore = [NSDictionary dictionaryWithObject:[UIColor blackColor] forKey:NSForegroundColorAttributeName];
    [controller.tabBarItem setTitleTextAttributes:dictHomeNore forState:UIControlStateNormal];
    // 设置 tabbarItem 选中状态的图片(不被系统默认渲染,显示图像原始颜色)
    UIImage *imageHome = [UIImage imageNamed:selectedImage];
    imageHome = [imageHome imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [controller.tabBarItem setSelectedImage:imageHome];
    // 设置 tabbarItem 选中状态下的文字颜色(不被系统默认渲染,显示文字自定义颜色)
    NSDictionary *dictHome = [NSDictionary dictionaryWithObject:[UIColor colorWithHexString:titleColor] forKey:NSForegroundColorAttributeName];
    [controller.tabBarItem setTitleTextAttributes:dictHome forState:UIControlStateSelected];
}
+ (UILabel *)setHeaderFrame:(CGRect)frame andText:(NSString *)str{
    UILabel *headerLabel = [[UILabel alloc]initWithFrame:frame];
    headerLabel.textColor = UIColor.whiteColor;
    headerLabel.font = FONT_REGULAR_30;
    headerLabel.hidden = YES;
    headerLabel.textAlignment = NSTextAlignmentCenter;
    headerLabel.backgroundColor = [UIColor colorWithHexString:@"#14D7EB"];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:frame];
    imageView.image = [UIImage imageNamed:@"默认头像"];
    if ([NSString isValidStr:str]) {
        NSString *nameStr;
        int a = [str characterAtIndex:0];
        if (a <= 0x9fff && a >= 0x4e00){//首字母为中文，展示最后一个中文字符
            for (int i=0; i<[str length]; i++) {
                int s = [str characterAtIndex:i];
                if (s <= 0x9fff && s >= 0x4e00) {
                }else{
                    NSRange range = NSMakeRange(i - 1, 1);
                    nameStr = [str substringWithRange:range];
                    headerLabel.text = nameStr;
                    return headerLabel;
                }
            }
            if (![NSString isValidStr:nameStr]) {
                NSRange range = NSMakeRange(str.length - 1, 1);
                nameStr = [str substringWithRange:range];
                headerLabel.text = nameStr;
                return headerLabel;
            }
        }else if((a >= 'A' && a <='Z') || (a>='a' && a <= 'z')){//首字母为英文,展示首字母
           NSRange range = NSMakeRange(0, 1);
            nameStr = [str substringWithRange:range];
            headerLabel.text = nameStr;
            return headerLabel;
        }else{//特殊字符
            [headerLabel addSubview:imageView];
            return headerLabel;
        }
    }
    [headerLabel addSubview:imageView];
    return headerLabel;
}
+ (UILabel *)setHeaderFrameMineCenter:(CGRect)frame andText:(NSString *)str{
    UILabel *headerLabel = [[UILabel alloc]initWithFrame:frame];
    headerLabel.textColor =[UIColor colorWithHexString:@"#14D7EB"];
    headerLabel.font = FONT_REGULAR_30;
    headerLabel.hidden = YES;
    headerLabel.textAlignment = NSTextAlignmentCenter;
    headerLabel.backgroundColor = [UIColor colorWithHexString:@"#DFFBFF"];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:frame];
    imageView.image = [UIImage imageNamed:@"默认头像"];
    if ([NSString isValidStr:str]) {
        NSString *nameStr;
        int a = [str characterAtIndex:0];
        if (a <= 0x9fff && a >= 0x4e00){//首字母为中文，展示最后一个中文字符
            for (int i=0; i<[str length]; i++) {
                int s = [str characterAtIndex:i];
                if (s <= 0x9fff && s >= 0x4e00) {
                }else{
                    NSRange range = NSMakeRange(i - 1, 1);
                    nameStr = [str substringWithRange:range];
                    headerLabel.text = nameStr;
                    return headerLabel;
                }
            }
            if (![NSString isValidStr:nameStr]) {
                NSRange range = NSMakeRange(str.length - 1, 1);
                nameStr = [str substringWithRange:range];
                headerLabel.text = nameStr;
                return headerLabel;
            }
        }else if((a >= 'A' && a <='Z') || (a>='a' && a <= 'z')){//首字母为英文,展示首字母
           NSRange range = NSMakeRange(0, 1);
            nameStr = [str substringWithRange:range];
            headerLabel.text = nameStr;
            return headerLabel;
        }else{//特殊字符
            [headerLabel addSubview:imageView];
            return headerLabel;
        }
    }
    [headerLabel addSubview:imageView];
    return headerLabel;
}

+ (BOOL)validateWithDate:(NSNumber *)date
{
    NSDate *aDate = [NSDate dateWithTimeIntervalSince1970:[date doubleValue]];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *now = [NSDate date];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:now];
//    components.hour = 8;
    // 当天起始时间
    NSDate *startDate = [calendar dateFromComponents:components];
    // 当天结束时间
    NSDate *expireDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:startDate options:0];
    
    if ([aDate compare:startDate] == NSOrderedDescending && [aDate compare:expireDate] == NSOrderedAscending) {
        return YES;
    } else {
        return NO;
    }
}
#pragma mark ---录屏截屏问题
+(void)handleSecurityScreen {
    if ([HICCommonUtils isValidObject:RoleManager.securityModel]) {
        if (RoleManager.securityModel.preventRecordScreen == 1) {//截屏
            [HICCommonUtils startScreenShot];
        }else if (RoleManager.securityModel.preventRecordScreen == 2){//录屏
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, HIC_ScreenWidth, HIC_ScreenHeight)];
            view.backgroundColor = UIColor.blackColor;
            [HICCommonUtils startSecreenCapture];
        }else if (RoleManager.securityModel.preventRecordScreen == 3){//截屏和录屏
            [HICCommonUtils startScreenShot];
            [HICCommonUtils startSecreenCapture];
        }else{}
    }
}
+ (void)startScreenShot{
    // 截屏
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(takeScreenTest) name:UIApplicationUserDidTakeScreenshotNotification object:nil];
}
+ (void)startSecreenCapture{
    
    // iOS11后中新增了录屏功能
    if (@available(iOS 11.0, *)) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(captureScreenTest) name:UIScreenCapturedDidChangeNotification object:nil];
    }
}
+(void)takeScreenTest{
    [self alertTakeScreenWithStr:NSLocalizableString(@"screenshotsPrompt", nil)];
}
+(void)captureScreenTest{
    if (@available(iOS 11.0, *)) {
        // 开始录屏时有弹框提示，结束录屏时就不弹框了。
        if (![UIScreen mainScreen].isCaptured) {
//            [self alertTakeScreenWithStr:@"结束录屏"];
//            [self.maskView removeFromSuperview];
            UIWindow *window = [[UIApplication sharedApplication].delegate window];
            if (window.subviews) {
                for (int i = 0; i < window.subviews.count; i ++) {
                    UIView *view = window.subviews[i];
                    if (view.tag == 20001 ) {
                        [view removeFromSuperview];
                        return;
                    }
                }
            }
        }else{
//            [self alertTakeScreenWithStr:@"您在录屏，请注意保护个人隐私"];
            UIWindow *window = [[UIApplication sharedApplication].delegate window];
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, HIC_ScreenWidth, HIC_ScreenHeight)];
            view.tag = 20001;
            view.backgroundColor = UIColor.blackColor;
            [window addSubview:view];
        }
    }
}
+(void)alertTakeScreenWithStr:(NSString *)str{
    DDLogDebug(@"监听到截屏或录屏");
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizableString(@"warmPrompt", nil) message:str preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizableString(@"determine", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        DDLogDebug(@"点击了确定");
    }];
    [alertController addAction:okAction];
    // 如果是页面，用self；如果在appdelegate中，用self.window.rootViewController
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    [window.rootViewController presentViewController:alertController animated:YES completion:nil];
}
+(CGFloat)returnLabelHeightWithStr:(NSString*)str font:(NSInteger)fontSize andWidth:(CGFloat)width andNumberOfLine:(NSInteger)lines fontIsRegular:(BOOL)isRegular{
    UILabel *label = [[UILabel alloc] init];
    label.text = str;
    label.numberOfLines = lines;
    CGFloat labelHeight = [HICCommonUtils sizeOfString:str stringWidthBounding:width font:fontSize stringOnBtn:NO fontIsRegular:isRegular].height;
    label.frame = CGRectMake(0, 0, width, labelHeight);
    [label sizeToFit];
    return label.frame.size.height;
}
+ (NSArray *)covertJSONStrToArray:(NSString *)jsonStr{
    if ([jsonStr isKindOfClass:[NSString class]]) {
        NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
        NSArray *arr = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:NULL];
        return  arr;
    }else{
        return @[];
    }
}

+ (NSString *)bundleIdentifier {
    return [[NSBundle mainBundle] bundleIdentifier];
}
+ (HICAppBundleIden)appBundleIden {
    NSString *bundleIdentifier = [self bundleIdentifier];
    if ([bundleIdentifier isEqualToString:@"com.hisense.hiclass"]) {
        return HICAppBundleIdenHiClass;
    } else if ([bundleIdentifier isEqualToString:@"com.hisense.zhiyu"]) {
        return HICAppBundleIdenZhiYu;
    } else {
        return HICAppBundleIdenSDK;
    }
}

@end
