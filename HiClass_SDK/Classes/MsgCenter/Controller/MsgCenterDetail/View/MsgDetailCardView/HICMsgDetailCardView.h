//
//  HICMsgDetailCardView.h
//  HiClass
//
//  Created by Eddie Ma on 2020/2/26.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HICMsgDetailCardView;
@protocol HICMsgDetailCardViewDelegate <NSObject>

-(void)msgCardView:(HICMsgDetailCardView *)view selectIndex:(NSIndexPath *)indexPath mode:(id)model;

@end

@interface HICMsgDetailCardView : UIView

@property (nonatomic, strong) NSArray *data;
@property (nonatomic, weak) id <HICMsgDetailCardViewDelegate>delegate;

- (instancetype)initWithFrame:(CGRect)frame type:(HICMsgType)type ;

@end

NS_ASSUME_NONNULL_END
