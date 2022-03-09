//
//  PostRequireBaseCell.h
//  iTest
//
//  Created by Sir_Jing on 2020/3/18.
//  Copyright © 2020 Sir_Jing. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Masonry.h"

#import "HICPostMapDetailReqModel.h"

NS_ASSUME_NONNULL_BEGIN

#define PostRequireContentWidth UIScreen.mainScreen.bounds.size.width - 28*2
@class PostRequireBaseCell;
@protocol PostRequireBaseCellDelegate <NSObject>

/// 点击展开按钮的开关
/// @param cell 当前cell
/// @param but 点击的but
/// @param isShow 是否显示更多
/// @param data 扩展数据
-(void)requireCell:(PostRequireBaseCell *)cell showMoreBut:(UIButton * _Nullable)but isShow:(BOOL)isShow other:(id _Nullable)data;

/// 点击证书显示页面
/// @param cell 当前cell
/// @param but 点击的but
/// @param isShow 是否显示证书详情
/// @param model 证书的模型数据
/// @param data 扩展数据
-(void)requireCell:(PostRequireBaseCell *)cell clickBut:(UIButton * _Nullable)but isShow:(BOOL)isShow andModel:(HICPostMapCerModel *)model other:(id _Nullable)data;

@end

@interface PostRequireBaseCell : UITableViewCell

@property (nonatomic, weak) id<PostRequireBaseCellDelegate>delegate;

/// 全局的白色背景 --
@property (nonatomic, strong) UIView *backView;

/// 标题Label -- cell 通用的  -- 其他的视图子Cell自己添加
@property (nonatomic, strong) UILabel *titleLabel;

/// 普通的岗位信息数据模型
@property (nonatomic, strong) HICPostMapDetailReqModel *model;

/// 证书数据模型
@property (nonatomic, strong) NSArray <HICPostMapCerModel *> *cerModels;

+(CGFloat)getContentLabelHeightWith:(NSString *)str;

@end

NS_ASSUME_NONNULL_END
