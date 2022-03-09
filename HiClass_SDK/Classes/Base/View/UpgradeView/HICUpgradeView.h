//
//  HICUpgradeView.h
//  HiClass
//
//  Created by Eddie Ma on 2020/3/5.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HICUpgradeView : UIView

- (instancetype)initWithVersion:(NSString *)version size:(NSString *)size time:(NSString *)time content:(NSString *)content downloadUrl:(NSString *)downloadUrl;

- (void)show;
- (void)hide;

@end

NS_ASSUME_NONNULL_END
