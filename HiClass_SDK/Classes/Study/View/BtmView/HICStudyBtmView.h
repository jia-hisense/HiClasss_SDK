//
//  HICStudyBtmView.h
//  HiClass
//
//  Created by Eddie Ma on 2020/2/3.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HICStudyBtmViewDelegate <NSObject>
@optional
/// 点击后弹出评论
- (void)commentSectionBtnClick;

/// 写评论按钮被点击
- (void)commentBtnClick;

/// 收藏操作
/// @param success 是否收藏成功
- (void)collectionSuccess:(BOOL)success;

/// 点赞操作
/// @param isThumbup YES-点赞, NO-取消点赞
- (void)thumbup:(BOOL)isThumbup;

/// 翻页按钮被点击
- (void)pageBtnClick;

/// 更多按钮被点击
- (void)moreBtnClick;

@end

@interface HICStudyBtmView : UIView

/// 是课程还是知识
@property (nonatomic, assign) HICStudyBtmViewType btmType;

/// 知识/课程的ID
@property (nonatomic, strong) NSNumber *kldId;
///知识/课程的type
@property (nonatomic, strong) NSNumber *knowType;
@property (nonatomic, weak) id<HICStudyBtmViewDelegate>delegate;

/// 学习底部按钮初始化
/// @param frame frame
/// @param count 评论的数量
- (instancetype)initWithFrame:(CGRect)frame numberOfComments:(NSString *)count;

/// 更新评论
/// @param count 评论数
- (void)updateCommentsCount:(NSString *)count;

/// 设置成收藏状态
- (void)isAlreadyCollected;

/// 设置成已赞状态
- (void)isAlreadyThumbup;

/// 自定义底部栏按钮
/// @param leftArr 底部左侧按钮集合，无变化填@[]
/// @param rightArr 底部右侧按钮集合，无变化填@[]
- (void)customLeftBtns:(NSArray *)leftArr rightBtns:(NSArray *)rightArr;

@end

NS_ASSUME_NONNULL_END
