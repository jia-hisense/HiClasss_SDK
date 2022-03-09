//
//  CHBrushToolsConfigs.h
//  CloudHubWhiteBoardKit
//
//  Created by jiang deng on 2020/12/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CHBrushToolsConfigs : NSObject

/// 画笔类型
@property (nonatomic, assign) CHDrawType drawType;
/// 颜色
@property (nonatomic, strong) NSString *colorHex;
/// 线宽比例 <1，比例基准 CHWHITEBOARDKIT_SHAPESCALEBASE
@property (nonatomic, assign) CGFloat lineWidthScale;

@end

NS_ASSUME_NONNULL_END
