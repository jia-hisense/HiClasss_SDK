//
//  HICBaseMaskView.h
//  HiClass
//
//  Created by WorkOffice on 2020/3/31.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol HICBaseMaskViewDelegate <NSObject>
- (void)closeMaskView;
@end
@interface HICBaseMaskView : UIView
-(instancetype)initWithTitle:(NSString *)title;

@property (nonatomic ,weak)id<HICBaseMaskViewDelegate>maskDelegate;
@end

NS_ASSUME_NONNULL_END
