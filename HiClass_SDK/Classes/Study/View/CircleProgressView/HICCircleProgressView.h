//
//  HICCircleProgressView.h
//  HiClass
//
//  Created by Eddie Ma on 2020/2/4.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HICCircleProgressView : UIView

@property (nonatomic, assign) CGFloat circleRadius;

- (void)resetProgressStatus;
- (void)updateProgressStatus:(CGFloat)percent;

@end

NS_ASSUME_NONNULL_END
