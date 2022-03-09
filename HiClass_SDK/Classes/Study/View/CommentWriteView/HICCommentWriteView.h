//
//  HICCommentWriteView.h
//  HiClass
//
//  Created by Eddie Ma on 2020/2/6.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HICCommentWriteViewDelegate <NSObject>
@optional

/// 发布按钮点击
/// @param content 发布内容
/// @param type 哪种类型：写评论，写回复，写笔记
/// @param stars 星数量（仅在写评论时才用）
/// @param important 是否标记为重要（仅在写笔记时才用）
/// @param name 回复给谁（仅在写回复时才用）
- (void)publishBtnClickedWithContent:(NSString *)content type:(HICCommentType)type starNum:(NSInteger)stars isImportant:(BOOL)important toAnybody:(NSString *)name;

- (void)finishedBtnClick;

@end

@interface HICCommentWriteView : UIView

@property (nonatomic, weak) id<HICCommentWriteViewDelegate>delegate;

/// 创建写内容view
/// @param commentType 写内容类型
/// @param name 回复给谁（仅在写回复时候用）
/// @param identifer 浏览具体内容的唯一标识
- (instancetype)initWithType:(HICCommentType)commentType commentTo:(NSString *)name identifer:(NSString *)identifer;

- (void)hide;

@end

NS_ASSUME_NONNULL_END
