//
//  HICCustomerNetErrorView.h
//  HiClass
//
//  Created by 铁柱， on 2020/3/26.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ClickAgain)(NSInteger type);
@interface HICCustomerNetErrorView : UIView

+(instancetype)createNetErrorWith:(UIView *)parentView clickBut:(ClickAgain)block;

+(instancetype)createNetErrorWith:(UIView *)parentView frame:(CGRect)frame clickBut:(ClickAgain)block;

-(void)showError;
-(void)hiddenError;

@end

NS_ASSUME_NONNULL_END
