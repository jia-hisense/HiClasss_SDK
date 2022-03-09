//
//  PostMapLineView.h
//  iTest
//
//  Created by Sir_Jing on 2020/3/16.
//  Copyright © 2020 Sir_Jing. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HICPostMapLineModel.h"

NS_ASSUME_NONNULL_BEGIN

@class PostMapLineView;
@protocol PostMapLineViewDelegate <NSObject>

/// 点击路线图节点
/// @param view 当前的线路视图
/// @param infoMode 节点的数据模型
/// @param type 展示类型 1:更多 2:详情
/// @param other 扩展数据
-(void)lineView:(PostMapLineView *)view didClickNode:(MapLineInfoModel *)infoMode type:(NSInteger)type other:(id _Nullable)other;

@end
@interface PostMapLineView : UIView

/// 路线数据模型， 用来标点的
@property (nonatomic, strong) HICPostMapLineModel *model;

@property (nonatomic, weak) id<PostMapLineViewDelegate> delegate;

@property (nonatomic, assign) BOOL isShowCurrentProgress;

/// 路线数据模型，用来刷新标点使用
@property (nonatomic, strong) HICPostMapLineModel *refreshModel;

@end

NS_ASSUME_NONNULL_END
