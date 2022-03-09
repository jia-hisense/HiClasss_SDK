//
//  HomeWebLoadingView.h
//  HiClass
//
//  Created by WorkOffice on 2020/1/20.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeWebLoadingView : UIView

+(instancetype)createLoadingViewWith:(CGRect)frame onView:(UIView *)parentView;


-(void)showLoadingView;

-(void)hidenLoadingView;

@end

NS_ASSUME_NONNULL_END
