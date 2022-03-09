//
//  CHWhiteBoardManager.h
//  CHWhiteBoard
//
//

#import <Foundation/Foundation.h>
#import "CHWhiteBoardManagerDelegate.h"
#import "CHWBMediaControlviewDelegate.h"

@class CHWhiteBoardWindow;

NS_ASSUME_NONNULL_BEGIN

@class CHWhiteBoardView;
@interface CHWhiteBoardManager : NSObject
<
    CHWBMediaControlviewDelegate,
    CHSessionForWhiteBoardDelegate
>

/// 音视频SDK管理
@property (nonatomic, weak, readonly) CloudHubRtcEngineKit *cloudHubRtcEngineKit;

@property (nonatomic, weak, readonly) id <CHWhiteBoardManagerDelegate> wbDelegate;

@property (nonatomic, weak, readonly) CloudHubWhiteBoardKit *cloudHubWhiteBoardKit;

/// 课件列表
@property (nonatomic, strong, readonly) NSMutableArray <CHFileModel *> *docmentList;

/// 暖场视频
@property (nonatomic, weak, readonly) CHFileModel *warmFileModel;


/// 主白板，在onWhiteBroadFileList回调回来后才有值
@property (nonatomic, strong, readonly) CHWhiteBoardView *mainWhiteBoardView;
/// 当前激活文档id
@property (nonatomic, strong, readonly) NSString *currentFileId;
/// 当前激活窗口id
@property (nonatomic, strong, readonly) NSString *currentWhiteBoardId;

/// 白板创建默认尺寸
@property (nonatomic, assign, readonly) CGSize whiteBoardViewDefaultSize;

/// 最小化时的收藏夹按钮
@property (nonatomic, strong, readonly) UIButton *collectBtn;
/// 视频窗口
@property (nonatomic, strong, readonly) CHWhiteBoardWindow *mp4WhiteBoardWindow;
/// 音频窗口
@property (nonatomic, strong, readonly) CHWhiteBoardWindow *mp3WhiteBoardWindow;

#if WBHaveSmallBalckBoard
/// 小黑板
@property (nonatomic, strong, readonly) CHWhiteBoardWindow *smallBoardWindow;

/// 小黑板阶段状态
@property (nonatomic, assign) CHSmallBoardStageState smallBoardStageState;

#endif

/// 暖场视频
@property (nonatomic, assign, readonly) BOOL isBeginClass;

+ (void)destroy;

+ (instancetype)sharedInstance;

- (void)registerDelegate:(id<CHWhiteBoardManagerDelegate>)delegate configration:(NSDictionary *)config;

- (void)registerDelegate:(id <CHWhiteBoardManagerDelegate>)delegate configration:(NSDictionary *)config useHttpDNS:(BOOL)useHttpDNS;

+ (NSString *)whiteBoardVersion;
+ (NSString *)whiteBoardShortVersion;
+ (NSString *)whiteBoardBuildVersion;

- (void)serverLog:(NSString *)log;


#pragma -
#pragma mark 课件设置

/// 变更白板窗口背景色
- (void)changeMainWhiteBoardBackgroudColor:(UIColor *)color;
/// 变更白板画板背景色
- (void)changeMainCourseViewBackgroudColor:(UIColor *)color;
/// 变更白板背景图
- (void)changeMainWhiteBoardBackImage:(nullable UIImage *)image;
/// 变更白板背景图
- (void)changeMainWhiteBoardBackImageUrl:(NSURL *)imageUrl;
/// 变更白板画板背景图
- (void)changeMainCourseViewBackImage:(nullable UIImage *)image;
/// 变更白板画板背景图
- (void)changeMainCourseViewBackImageUrl:(NSURL *)imageUrl;


/// 变更白板窗口背景配置颜色
- (void)changeConfigWhiteBoardBackgroudColor:(UIColor *)color;
/// 变更白板窗口画布配置颜色
- (void)changeConfigWhiteBoardCanvasColor:(UIColor *)color;

/// 变更H5课件地址参数，此方法会刷新当前H5课件以变更新参数
- (void)changeConnectH5CoursewareUrlParameters:(nullable NSDictionary *)parameters;

/// 设置H5课件Cookies
- (void)setConnectH5CoursewareUrlCookies:(nullable NSArray <NSDictionary *> *)cookies;
/// 隐藏主白板翻页工具
- (void)hideMainwhiteBoardCoursewareControl:(BOOL)hide;
#pragma -
#pragma mark 课件数据

- (CHFileModel *)getDocumentWithFileId:(NSString *)fileId;

/// 是否多课件窗口
- (BOOL)isOneWhiteBoardView;
/// 是否能控制窗口
- (BOOL)isCanControlWhiteBoardView;

/// 尺寸变化时需要刷新工具位置
- (void)refreshMainWhiteBoard;

/// 默认可选颜色
+ (NSArray *)colorSelectArray;
/// 改变默认画笔颜色
- (void)changeDefaultPrimaryColor:(NSString *)defaultPrimaryColor;

/// 切换课件
- (void)changeCourseWithFileId:(NSString *)fileId;

/// 设置当前课件
- (void)setTheCurrentWindowWhiteBoardId:(NSString *)whiteBoardId;
- (void)setTheCurrentWindowWhiteBoardId:(NSString *)whiteBoardId sendArrange:(BOOL)sendArrange;

/// 上传图片
- (void)uploadImageWithImage:(UIImage *)image addInClass:(BOOL)addInClass success:(void(^)(NSDictionary *dict))success failure:(void(^)(NSInteger errorCode))failure;


/// 获取主白板 画笔工具
- (UIView *)getMainBrushToolView;

/// 刷新还原全屏课件
- (void)resetFullScreen;

/// 获取窗口缩放比例
- (CGFloat)currentWhiteBoardZoomScale;
- (CGFloat)zoomScaleWithWhiteBoardId:(NSString *)whiteBoardId;


#if WBHaveSmallBalckBoard

/// 上传小黑板图片
- (void)uploadSmallBalckBoardImageWithImage:(UIImage *)image success:(nullable void(^)(NSDictionary *dict))success failure:(nullable void(^)(NSInteger errorCode))failure;

/// 删除小白板图片
- (void)deleteSmallBoardImage;

#endif

@end

NS_ASSUME_NONNULL_END
