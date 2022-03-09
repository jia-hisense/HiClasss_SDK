//
//  HomeTaskCenterBaseCell.h
//  iTest
//
//  Created by Sir_Jing on 2020/3/16.
//  Copyright © 2020 Sir_Jing. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Masonry.h"
#import "HICHomeTaskCenterModel.h"

NS_ASSUME_NONNULL_BEGIN

// 定义title的宽度  --  方便以后计算高度使用
#define TaskCenterCellTitleWidth UIScreen.mainScreen.bounds.size.width-58-28

/// 基本的任务中心cell高度  --  单行高度Cell的总高度 149.5
@interface HomeTaskCenterBaseCell : UITableViewCell

/// 标题图片
@property (nonatomic, strong) UILabel *iconImageLabel;

/// 内容背景视图  ---
@property (nonatomic, strong) UIView *contentBackView;

// 内容视图
/// 标题
@property (nonatomic, strong) UILabel *contentTitleLabel;

/// 时间
@property (nonatomic, strong) UILabel *timeLabel;

/// 分割线
@property (nonatomic, strong) UIView *lineView;

/// 具体内容的左上
@property (nonatomic, strong) UILabel *leftTopLabel;


/// 具体内容的左下
@property (nonatomic, strong) UILabel *leftBottomLabel;

/// 具体内容的右上
@property (nonatomic, strong) UILabel *rightTopLabel;

/// 具体内容的右下
@property (nonatomic, strong) UILabel *rightBottomLabel;

/// 进度条 -- 培训时用
@property (nonatomic, strong) UIProgressView *progressView;

/// 重要标签
@property (nonatomic, strong) UIImageView *majorImageView;


/// 赋值的模型
@property (nonatomic, strong) HICHomeTaskCenterModel *model;

/// 是否时将要进行的
@property (nonatomic, assign) BOOL isWillDo;
/// 图
@property (nonatomic, strong) UIImageView *iconImage;


/// 获取标题的高度
/// @param str 标题文字
+(CGFloat)getTitleLabelHeightWith:(NSString *)str;

@end

NS_ASSUME_NONNULL_END
