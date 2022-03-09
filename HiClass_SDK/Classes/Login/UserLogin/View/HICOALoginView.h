//
//  HICOALoginView.h
//  HiClass
//
//  Created by 铁柱， on 2020/1/2.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HICOALoginViewDelegate <NSObject>
- (void)confirmBtnClickedWithAccount:(NSString *)account password:(NSString *)password;
- (void)phoneNumLogin;
@end

@interface HICOALoginView : UIView
@property (nonatomic, assign) id<HICOALoginViewDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
