//
//  HICCommentView.h
//  HiClass
//
//  Created by Eddie Ma on 2020/2/5.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol HICCommentViewDelegate <NSObject>
@optional
/// 实时更新评论view的frame
/// @param frame 评论View的frame
- (void)currentCommentViewFrame:(CGRect)frame;

/// 评论删除
/// @param commentInfo 评论的信息
- (void)commentDelete:(NSDictionary *)commentInfo;

/// 评论回复
/// @param commentInfo 评论的信息
- (void)commentReply:(NSDictionary *)commentInfo;

/// 评论点赞
/// @param commentInfo 评论的信息
- (void)commentThumbUp:(NSDictionary *)commentInfo;

/// 查看所有父评论下面的子评论
/// @param commentInfo 评论的信息
- (void)seeAllComments:(NSDictionary *)commentInfo;

@end

@interface HICCommentView : UIView

@property (nonatomic, weak) id<HICCommentViewDelegate>delegate;

/// 嵌入式l评论(放在单独一个cell里面)
/// @param comments 评论的整个内容
- (instancetype)initWithData:(NSArray *)comments;

/// 由于评论数据的增删改后，更新评论view
/// @param comments 变动后的评论数据
- (void)updateViewFrame:(NSArray *)comments;

@end

NS_ASSUME_NONNULL_END
