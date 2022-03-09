//
//  PostMapSingleButView.h
//  iTest
//
//  Created by Sir_Jing on 2020/3/17.
//  Copyright © 2020 Sir_Jing. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HICPostMapLineModel.h"

NS_ASSUME_NONNULL_BEGIN

@class PostMapSingleButView;
@protocol PostMapSingleButViewDelegate <NSObject>

/// 点击按钮回调方法
/// @param view 当前的view
/// @param but 点击的but
/// @param type 跳转类型 1:表示更多 2:表示详情
/// @param infoModel 数据模型
/// @param data 扩展数据
-(void)singleButView:(PostMapSingleButView *)view clickBut:(UIButton *_Nullable)but type:(NSInteger)type itemModel:(MapLineInfoModel *_Nullable)infoModel other:(id _Nullable)data;

@end

@interface PostMapSingleButView : UIView

/// 节点的状态 -- 是前序当前还是后序 0:表示前序 1:表示当前 2:表示后续
@property (nonatomic, assign) NSInteger type;

/// 节点的数据模型
@property (nonatomic, strong) MapLineInfoModel * infoModel;

/// 是否可以点击当前节点
@property (nonatomic, assign) BOOL isClickDidNode;

/// 标点的but -- 跳动的动画需要
@property (nonatomic, strong) UIButton *titleBut;

@property (nonatomic, weak) id<PostMapSingleButViewDelegate> delegate;

-(instancetype)initWithPoint:(CGPoint)point;

@end

NS_ASSUME_NONNULL_END
