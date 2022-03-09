//
//  HICModifyPassView.h
//  HiClass
//
//  Created by Eddie Ma on 2019/12/31.
//  Copyright © 2019 jingxianglong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol HICModifyPassViewDelegate <NSObject>

- (void)confirmBtnClickedWithPass:(NSString *)pass confirmPass:(NSString *)confirmPass;

@end


@interface HICModifyPassView : UIView

@property (nonatomic, assign) id<HICModifyPassViewDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
