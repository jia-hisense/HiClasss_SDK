//
//  HICCustomLoadingView.h
//  HiClass
//
//  Created by 铁柱， on 2020/3/26.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HICCustomLoadingView : UIView

+(instancetype)createLoadingViewWith:(CGRect)frame onView:(UIView *)parentView;


-(void)showLoadingView;

-(void)hidenLoadingView;

@end

NS_ASSUME_NONNULL_END
