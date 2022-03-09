//
//  VCHPermissionAlertView.h
//  HsShare3.5
//
//  Created by keep on 2018/8/11.
//  Copyright © 2018年 com.hisense. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VCHPermissionAlertViewDelegate <NSObject>

/**
 * 点击button
 * @param btnIndex 0:点击取消  1:点击确定
 */
- (void)clickPermissionAlertVieWithBtnIndex:(NSInteger)btnIndex;

@end

@interface VCHPermissionAlertView : UIView

@property (nonatomic, assign) id<VCHPermissionAlertViewDelegate>delegate;

- (instancetype)initWithFrame:(CGRect)frame Title:(NSString *)title startBtnTitle:(NSString *)startBtnTitle cancelBtnTitle:(NSString *)cancelBtnTitle andStr:(NSString *)contentStr;

- (void)show;

@end
