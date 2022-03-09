//
//  HICAllReplyCommentView.h
//  HiClass
//
//  Created by Eddie Ma on 2020/2/10.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HICCommentModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol HICAllReplyCommentViewDelegate <NSObject>
@optional

- (void)showReplyInput:(HICCommentModel *)model;

@end

@interface HICAllReplyCommentView : UIView

@property (nonatomic, weak) id<HICAllReplyCommentViewDelegate>delegate;

- (instancetype)initWithFrame:(CGRect)frame fCommentModel:(HICCommentModel *)fModel totalChComments:(NSInteger)totalCount isFromCourse:(BOOL)isFromCourse needRoundCorner:(BOOL)needRoundCorner;

- (void)refreshData;

@end

NS_ASSUME_NONNULL_END
