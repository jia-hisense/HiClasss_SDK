//
//  HICMsgDetailGroupMsgView.h
//  HiClass
//
//  Created by Eddie Ma on 2020/2/26.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class HICMsgDetailGroupMsgView;
@protocol HICMsgDetailGroupMsgViewDelegate <NSObject>

-(void)msgView:(HICMsgDetailGroupMsgView *)view selectIndex:(NSIndexPath *)indexPath mode:(id)model;

@end

@interface HICMsgDetailGroupMsgView : UIView

@property (nonatomic, strong) NSArray *data;

@property (nonatomic, weak) id <HICMsgDetailGroupMsgViewDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
