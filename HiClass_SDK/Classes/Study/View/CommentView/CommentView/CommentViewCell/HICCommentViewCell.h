//
//  HICCommentViewCell.h
//  HiClass
//
//  Created by Eddie_Ma on 17/2/20.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HICCommentModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol HICCommentViewCellDelegate <NSObject>
@optional
/// 查看父评论全文
/// @param index 评论的索引
- (void)seeFullComments:(NSInteger)index;

/// 评论删除
/// @param index 评论的索引
- (void)commentDelete:(NSInteger)index;

/// 评论(回复)删除
/// @param index 评论的索引
/// @param subIndex 子评论的索引
- (void)commentDelete:(NSInteger)index subIndex:(NSInteger)subIndex;

/// 评论回复
/// @param index 评论的索引
- (void)commentReply:(NSInteger)index;

/// 评论点赞
/// @param index 评论的索引
- (void)commentThumbUp:(NSInteger)index;

/// 查看所有父评论下面的子评论
/// @param index 评论的索引
- (void)seeAllSubComments:(NSInteger)index;

@end

@interface HICCommentViewCell : UITableViewCell

@property (nonatomic, weak) id<HICCommentViewCellDelegate>delegate;

- (void)setData:(HICCommentModel *)model index:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
