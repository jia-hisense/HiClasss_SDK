//
//  HICCheckNoteMoreView.h
//  HiClass
//
//  Created by Eddie Ma on 2020/2/11.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HICCheckNoteMoreViewDelegate <NSObject>
@optional

/// 笔记复制按钮点击
- (void)copyClicked;

/// 笔记删除按钮点击
- (void)deleteClicked;

/// 笔记设置重要按钮点击
- (void)setToImportantClicked;
@end

@interface HICCheckNoteMoreView : UIView

@property (nonatomic, weak) id<HICCheckNoteMoreViewDelegate>delegate;

@property(nonatomic, strong) NSArray *viewTitles;

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)arr;

@end

NS_ASSUME_NONNULL_END
