//
//  HICPostRequireVCView.h
//  iTest
//
//  Created by Sir_Jing on 2020/3/18.
//  Copyright © 2020 Sir_Jing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HICPostMapDetailReqModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HICPostRequireVCView : UIViewController

/// 岗位ID -- 用来请求 要求数据
@property (nonatomic, assign) NSInteger  postId;

@property (nonatomic, strong) HICPostMapDetailReqModel *model;

@end

NS_ASSUME_NONNULL_END
