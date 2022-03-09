//
//  CloudHubWhiteBoardViewConfig+shapeAdd.h
//  CloudHubWhiteBoardKit
//
//  Created by jiang deng on 2021/4/21.
//

#import "CloudHubWhiteBoardViewConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface CloudHubWhiteBoardViewConfig (shapeAdd)

/// 是否使用画笔数据解析方法 默认: NO，不能即时修改
/// 供小黑板使用
/// 此时不接收画笔信令，只接收画笔数据，每次切换时数据清空需要重新加载全部数据
@property (nonatomic, assign, readonly) BOOL useShapeAdd;

/// 当画笔被选中时是否显示绘制人昵称 默认: NO
@property (nonatomic, assign, readonly) BOOL showShapeUserNameWhenSeleted;
/// 是否显示绘制人昵称(收到新画笔数据显示3秒) 默认: NO
@property (nonatomic, assign, readonly) BOOL showShapeUserName;

- (instancetype)initWithCanvasRatio:(CGFloat)canvasRatio useShapeAdd:(BOOL)useShapeAdd;
- (instancetype)initWithCanvasRatio:(CGFloat)canvasRatio whiteBoardConfig:(nullable CloudHubWhiteBoardConfig *)whiteBoardConfig useShapeAdd:(BOOL)useShapeAdd;

@end

NS_ASSUME_NONNULL_END
