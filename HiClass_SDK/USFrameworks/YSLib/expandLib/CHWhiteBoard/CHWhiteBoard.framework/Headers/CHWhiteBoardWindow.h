//
//  CHWhiteBoardWindow.h
//  CHWhiteBoard
//
//  Created by jiang deng on 2020/12/30.
//

#import <UIKit/UIKit.h>

@class CHSmallBoardTopBar,CHSmallBoardBottomBar;

NS_ASSUME_NONNULL_BEGIN

@class CHCoursewareControlView, CHWhiteBoardTopBar;
@protocol CHWhiteBoardWindowDelegate;

@interface CHWhiteBoardWindow : UIView

@property (nonatomic, weak) id <CHWhiteBoardWindowDelegate> delegate;

@property (nonatomic, strong, readonly) NSString *whiteBoardId;
@property (nonatomic, strong, readonly) CHWhiteBoardView *whiteBoardView;

/// 白板背景容器
@property (nonatomic, strong, readonly) UIView *whiteBoardContentView;

/// 媒体数据
@property (nonatomic, strong) CHSharedMediaFileModel *mediaFileModel;
/// 媒体课件窗口
@property (nonatomic, assign, readonly) BOOL isMediaView;
@property (nonatomic, assign, readonly) CHWhiteBordMediaType mediaType;

/// H5脚本推流视频
@property (nonatomic, assign) BOOL isH5LoadMedia;

/// 课件Id
@property (nonatomic, strong, readonly) NSString *fileId;
/// 当前页码
@property (nonatomic, assign, readonly) NSUInteger currentPage;
/// 总页码
@property (nonatomic, assign, readonly) NSUInteger totalPage;

/// 翻页工具条
@property (nonatomic, strong, readonly) CHCoursewareControlView *pageControlView;

/// 小白板的topBar
@property (nonatomic, strong, readonly) CHWhiteBoardTopBar *topBar;

/// 是否当前激活课件
@property (nonatomic, assign) BOOL isCurrent;

/// 当前的位置信令的值
@property (nonatomic, strong, readonly) NSMutableDictionary *positionData;

#if WBHaveSmallBalckBoard
#pragma mark - 小黑板

/// 是否是小黑板
@property (nonatomic, assign, readonly) BOOL isSmallBoard;

/// 小黑板的bottomBar
@property (nonatomic, strong, readonly) CHSmallBoardBottomBar *bottomBar;

/// 小黑板的topBar
@property (nonatomic, strong, readonly) CHSmallBoardTopBar *smallTopBar;

/// 上传图片后返回的数据
@property (nonatomic, strong) NSDictionary *imageDict;
#endif


- (instancetype)initWithFrame:(CGRect)frame whiteBoardId:(nullable NSString *)whiteBoardId isSmallBoard:(BOOL)isSmallBoard;
- (instancetype)initWithFrame:(CGRect)frame whiteBoardId:(NSString *)whiteBoardId isMedia:(BOOL)isMedia mediaType:(CHWhiteBordMediaType)mediaType isSmallBoard:(BOOL)isSmallBoard;

/// 页面刷新尺寸
- (void)refreshWhiteBoard;
//- (void)refreshWhiteBoardWithFrame:(CGRect)frame;

/// 窗口位置尺寸数据
- (void)changePositionData:(NSDictionary *)positionData;
- (void)changePositionData:(NSDictionary *)positionData type:(NSString *)type isSmall:(BOOL)isSmall isFull:(BOOL)isFull;

/// 发送当前位置信息，用于上课同步位置
- (void)sendWhiteboardPosition;

#pragma mark 音视频控制

- (void)setMediaStream:(NSTimeInterval)duration pos:(NSTimeInterval)pos fileName:(nonnull NSString *)fileName;
- (void)setMediaStreamIsPlay:(BOOL)isPlay;

#pragma -
#pragma mark 白板视频标注

/// 显示白板视频标注
- (void)showVideoWhiteboardWithData:(NSDictionary *)data;
/// 绘制白板视频标注
- (void)drawVideoWhiteboardWithData:(NSDictionary *)data;
/// 隐藏白板视频标注
- (void)hideVideoWhiteboardMark;

@end

@protocol CHWhiteBoardWindowDelegate <NSObject>
/// 拖拽顶栏手势事件
- (void)topBarMoveWhiteBoardWindow:(CHWhiteBoardWindow *)whiteBoardWindow withGestureRecognizer:(UIPanGestureRecognizer *)panGesture;
/// 点击手势事件
- (void)topBarClickWhiteBoardWindow:(CHWhiteBoardWindow *)whiteBoardWindow;
/// 点击关闭
- (void)topBarClickCloseWhiteBoardWindow:(CHWhiteBoardWindow *)whiteBoardWindow;
/// 点击最大化
- (void)topBarClickMaximumWhiteBoardWindow:(CHWhiteBoardWindow *)whiteBoardWindow;
/// 点击最小化
- (void)topBarClickMinimizeWhiteBoardWindow:(CHWhiteBoardWindow *)whiteBoardWindow;


/// 拖拽手势事件  拖拽右下角缩放View
- (void)panToZoomWhiteBoardWindow:(CHWhiteBoardWindow *)whiteBoardWindow withGestureRecognizer:(UIPanGestureRecognizer *)pan;

//- (void)whiteBoardWindowClosedWithWhiteBoardId:(NSString *)whiteBoardId;

/// 拖拽Mp3手势事件
- (void)moveMp3ViewWithGestureRecognizer:(UIPanGestureRecognizer *)panGesture;
/// 全屏 复原 回调
- (void)windowCoursewarefullScreen:(BOOL)isFullScreen withWhiteBoardId:(NSString *)whiteBoardId;
/// 由全屏还原的按钮
- (void)windowWhiteBoardMaxScreenReturnWithWhiteBoardId:(NSString *)whiteBoardId;
/// 删除按钮
- (void)windowDeleteWhiteBoardViewWithWhiteBoardId:(NSString *)whiteBoardId;

#if WBHaveSmallBalckBoard
/// 点击上传图片
- (void)bottomBarClickUploadImageWhiteBoardWindow:(CHWhiteBoardWindow *)whiteBoardWindow;
/// 点击删除图片
- (void)bottomBarClickDeleteImageWhiteBoardWindow:(CHWhiteBoardWindow *)whiteBoardWindow;
#endif
@end

NS_ASSUME_NONNULL_END
