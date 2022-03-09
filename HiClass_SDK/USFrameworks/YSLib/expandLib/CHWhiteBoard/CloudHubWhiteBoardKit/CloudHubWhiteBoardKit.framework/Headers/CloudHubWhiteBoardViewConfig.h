//
//  CloudHubWhiteBoardViewConfig.h
//  CloudHubWhiteBoardKit
//
//  Created by jiang deng on 2021/4/21.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class CloudHubWhiteBoardConfig;
@interface CloudHubWhiteBoardViewConfig : NSObject

/// 画板背景色 默认透明
@property (nonatomic, strong) UIColor *canvasBGColor;
/// 画布背景色 默认白色
@property (nonatomic, strong) UIColor *canvasColor;

/// 画布比例  默认: 16.0f / 9.0f，不能即时修改
@property (nonatomic, assign, readonly) CGFloat canvasRatio;

/// 是否有画笔权限 默认: YES
@property (nonatomic, assign) BOOL isCandraw;
/// 是否有翻页权限 默认: YES
@property (nonatomic, assign) BOOL isCanpage;
/// 是否只能操作自己的画笔数据(undo redo clear) 默认: NO
@property (nonatomic, assign) BOOL isOnlyOperationSelfShape;

/// 是否H5播放视频还是回调原生 默认: NO  H5播放视频
/// 只对动态ppt课件有效
@property (nonatomic, assign) BOOL isAllowPptPubVideo;
/// 是否H5播放音频还是回调原生 默认: NO  H5播放音频
/// 只对动态ppt课件有效
@property (nonatomic, assign) BOOL isAllowPptPubAudio;

- (instancetype)initWithCanvasRatio:(CGFloat)canvasRatio;
- (instancetype)initWithWhiteBoardConfig:(CloudHubWhiteBoardConfig *)whiteBoardConfig;
- (instancetype)initWithCanvasRatio:(CGFloat)canvasRatio whiteBoardConfig:(nullable CloudHubWhiteBoardConfig *)whiteBoardConfig;

@end

NS_ASSUME_NONNULL_END
