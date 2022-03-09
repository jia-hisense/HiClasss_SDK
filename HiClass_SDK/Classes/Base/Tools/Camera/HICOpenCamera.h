//
//  HICOpenCamera.h
//  HiClass
//
//  Created by Eddie Ma on 2020/1/15.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HICOpenCameraDelegate <NSObject>
- (void)takePhotoResult:(NSArray *)photoArr;
@end

@interface HICOpenCamera : NSObject

@property (nonatomic, weak) id<HICOpenCameraDelegate>delegate;

/// 初始化相机
/// @param fromVC 在哪个VC基础上打开系统相机
/// @param toVC 相机关闭后去到哪个VC
- (instancetype)initFromVC:(UIViewController *)fromVC toVC:(UIViewController * _Nullable)toVC;

@end

NS_ASSUME_NONNULL_END
