//
//  HICPostMapVC.h
//  iTest
//
//  Created by Sir_Jing on 2020/3/16.
//  Copyright © 2020 Sir_Jing. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HICPostMapLineModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HICPostMapVC : UIViewController

/// 线路模型 -- 包含各个节点
@property (nonatomic, strong) HICPostMapLineModel *model;

/// 增加显示当前进度的
@property (nonatomic, assign) BOOL isShowCurrentProgress;

/// 刷新线路模型
@property (nonatomic, strong) HICPostMapLineModel *refreshModel; // 用来刷新线路数据；

@end

NS_ASSUME_NONNULL_END
