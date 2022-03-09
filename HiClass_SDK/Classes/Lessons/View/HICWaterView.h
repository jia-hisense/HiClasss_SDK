//
//  HICWaterView.h
//  HiClass
//
//  Created by WorkOffice on 2020/3/3.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HICWaterView : UIView
/**
 设置水印
 
 @param frame 水印大小
 @param markText 水印显示的文字
 */
- (instancetype)initWithFrame:(CGRect)frame WithText:(NSString *)markText;
@end

NS_ASSUME_NONNULL_END
