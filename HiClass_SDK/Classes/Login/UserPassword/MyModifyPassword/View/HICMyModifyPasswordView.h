//
//  HICMyModifyPasswordView.h
//  HiClass
//
//  Created by WorkOffice on 2020/3/25.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol HICMyModifyPasswordViewDelegate <NSObject>

- (void)confirmBtnClickedWithPass:(NSString *)pass oldPass:(NSString *)oldPass confirmPass:(NSString *)confirmPass;

@end
@interface HICMyModifyPasswordView : UIView
@property (nonatomic, assign) id<HICMyModifyPasswordViewDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
