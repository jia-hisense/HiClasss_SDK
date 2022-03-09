//
//  HICNavgationBar.h
//  HiClass
//
//  Created by hisense on 2020/4/14.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    LeftTap,
    RightTap
} HICNavgationTapType;

typedef void(^ItemClick)(HICNavgationTapType);

@interface HICNavgationBar : UIView

@property (nonatomic, copy) ItemClick itemClicked;

@property (nonatomic, strong) NSString *title;

- (instancetype)initWithTitle:(NSString *)title bgImage:(NSString *)bgImg leftBtnImage:(NSString *)leftImg rightBtnImg:(nullable NSString *)rightImg;

- (instancetype)initWithTitle:(NSString *)title bgColor:(UIColor *)bgColor leftBtnImage:(NSString *)leftImg rightBtnImg:(nullable NSString *)rightImg;

- (void)updateBgImageHeight:(CGFloat)height;

@end

NS_ASSUME_NONNULL_END
