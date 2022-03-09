//
//  HICMixTrainTaskBubbleView.h
//  HiClass
//
//  Created by WorkOffice on 2020/6/16.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol BubleViewDelegate <NSObject>

- (void)clickToJump;
@end
@interface HICMixTrainTaskBubbleView : UIView
@property (nonatomic ,strong)NSString *title;
-(void)setViewFrame:(CGRect)frame;
@property (nonatomic ,strong)UIColor *fillColor;
@property (nonatomic ,weak)id<BubleViewDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
