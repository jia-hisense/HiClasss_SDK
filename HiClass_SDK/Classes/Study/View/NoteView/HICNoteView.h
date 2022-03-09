//
//  HICNoteView.h
//  HiClass
//
//  Created by Eddie Ma on 2020/2/8.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol HICNoteViewDelegate <NSObject>
@optional

/// 添加笔记按钮点击
- (void)addNoteClicked;

/// 查阅笔记按钮点击
- (void)checkNoteClicked;
@end

@interface HICNoteView : UIView

@property (nonatomic, weak) id<HICNoteViewDelegate>delegate;
@property (nonatomic, assign) BOOL isShown;
/// 初始化
/// @param frame frame
/// @param hasNote 对该知识是否留过笔记，YES-有；NO-没有
- (instancetype)initWithFrame:(CGRect)frame hasNote:(BOOL)hasNote;
- (void)show;
- (void)hide;
- (void)hasNote:(BOOL)hasNote;

@end

NS_ASSUME_NONNULL_END
