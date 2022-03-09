//
//  HICToast.h
//  swiftProject
//
//  Created by wangggang on 2020/1/10.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define HIC_Toast_Divisor ([UIScreen mainScreen].bounds.size.width/750.0)

@interface HICToast : NSObject

+ (void)showWithText:(NSString *)text;
+ (void)showWithText:(NSString *)text duration:(CGFloat)duration;

+ (void)showWithText:(NSString *)text topOffset:(CGFloat)topOffset;
+ (void)showWithText:(NSString *)text topOffset:(CGFloat)topOffset duration:(CGFloat)duration;

+ (void)showWithText:(NSString *)text bottomOffset:(CGFloat)bottomOffset;
+ (void)showWithText:(NSString *)text bottomOffset:(CGFloat)bottomOffset duration:(CGFloat)duration;

+ (void)showAtDefWithText:(NSString *)text;

@end

NS_ASSUME_NONNULL_END
