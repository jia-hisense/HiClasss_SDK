//
//  HICPhoneNumLoginView.h
//  HiClass
//
//  Created by 铁柱， on 2020/1/2.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HICPhoneNumLoginViewDelegate <NSObject>
- (void)confirmBtnClickedWithPhoneNum:(NSString *)phoneNum password:(NSString *)password;
- (void)oaLogin;
- (void)forgetPassword;
@end

@interface HICPhoneNumLoginView : UIView
@property (nonatomic, assign) id<HICPhoneNumLoginViewDelegate>delegate;
@property (nonatomic ,strong)NSString *loginInfo;
- (void)clearPassField;

@end

NS_ASSUME_NONNULL_END
