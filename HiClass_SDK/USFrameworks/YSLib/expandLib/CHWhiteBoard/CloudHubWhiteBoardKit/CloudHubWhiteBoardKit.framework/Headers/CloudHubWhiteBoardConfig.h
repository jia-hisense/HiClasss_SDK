//
//  CHWhiteBoardSDKConfig.h
//  YSWhiteBoardSDK
//
//

#import "CloudHubWhiteBoardViewConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface CloudHubWhiteBoardConfig : CloudHubWhiteBoardViewConfig

/// 是否同步 默认: YES
@property (nonatomic, assign) BOOL isSync;

/// 是否多课件 默认: NO，不能即时修改
@property (nonatomic, assign, readonly) BOOL isMultiCourseware;

/// PDF文件解析度 >1整数 默认: 2 越大越清晰
@property (nonatomic, assign) NSUInteger PDFLevel;

/// 默认画笔工具 默认: CHBrushToolTypeMouse，不能即时修改
@property (nonatomic, assign, readonly) CHBrushToolType defaultToolType;

/// 是否实例化画笔数据(可以删除移动画笔数据，取消橡皮擦功能) 默认: NO，不能即时修改
@property (nonatomic, assign, readonly) BOOL isObjectLevel;

/// 是否可以点击交互 默认: YES
/// 只对H5及动态ppt课件有效
@property (nonatomic, assign) BOOL isPenCanPenetration;

/// 是否可以手势缩放课件(动态ppt及H5课件不支持) 默认: YES，不能即时修改
/// 注意：只是限制手势缩放，关闭后仍然可以通过翻页工具条控制缩放
@property (nonatomic, assign, readonly) BOOL canGestureZoom;

/// 是否使用HttpDNS加载课件 默认: NO，不能即时修改
@property (nonatomic, assign, readonly) BOOL useHttpDNS;

/// 是否使用预加载课件 默认: NO，不能即时修改
@property (nonatomic, assign, readonly) BOOL isPreloading;

/// H5课件cookie 默认: nil，不能即时修改
@property (nonatomic, strong, readonly) NSArray <NSDictionary *> *connectH5CoursewareUrlCookies;

/// 初始化配置项
/// @param params @{CHWhiteBoardKitConfigMultiCoursewareKey : BOOL,
///                 CHWhiteBoardKitConfigDefaultToolTypeKey : CHBrushToolType,
///                 CHWhiteBoardKitConfigObjectLevelKey : BOOL,
///                 CHWhiteBoardKitConfigCanvasRatioKey : CGFloat,
///                 CHWhiteBoardKitConfigGestureZoomKey : BOOL,
///                 CHWhiteBoardKitConfigHttpDNSKey : BOOL,
///                 CHWhiteBoardKitConfigPreloadingKey : BOOL }
- (instancetype)initWithParams:(NSDictionary *)params;

- (instancetype)initWithMultiCourseware:(BOOL)isMultiCourseware defaultToolType:(CHBrushToolType)defaultToolType isObjectLevel:(BOOL)isObjectLevel canvasRatio:(CGFloat)canvasRatio canGestureZoom:(BOOL)canGestureZoom useHttpDNS:(BOOL)useHttpDNS cookies:(nullable NSArray <NSDictionary *> *)urlCookies;

- (CloudHubWhiteBoardViewConfig *)cloneToWhiteBoardViewConfig;

@end

NS_ASSUME_NONNULL_END
