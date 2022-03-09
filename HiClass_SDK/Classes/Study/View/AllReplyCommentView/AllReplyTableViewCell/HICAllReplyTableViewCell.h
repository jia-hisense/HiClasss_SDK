//
//  HICAllReplyTableViewCell.h
//  HiClass
//
//  Created by Eddie Ma on 2020/2/10.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HICCommentModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol HICAllReplyTableViewCellDelegate <NSObject>
@optional

/// 评论交互按钮
/// @param action 点赞，回复，删除
- (void)commentActionBtnClicked:(HICCommentActions)action index:(NSInteger)index cancelThumbupBtn:(BOOL)cancelThumbupBtn;

@end

@interface HICAllReplyTableViewCell : UITableViewCell

@property (nonatomic, weak) id<HICAllReplyTableViewCellDelegate>delegate;

- (void)setData:(HICCommentModel *)model index:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
