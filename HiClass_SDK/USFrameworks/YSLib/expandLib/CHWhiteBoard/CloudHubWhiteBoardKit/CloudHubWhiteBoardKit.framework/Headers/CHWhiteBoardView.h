//
//  CHWhiteBoardView.h
//  CloudHubWhiteBoardKit
//
//  Created by jiang deng on 2020/11/27.
//

#import <UIKit/UIKit.h>
#import "CHDocumentViewProtocol.h"
#import "CloudHubWhiteBoardViewConfig.h"

#import "CHBrushToolsConfigs.h"

NS_ASSUME_NONNULL_BEGIN

@protocol CHWhiteBoardViewDelegate;
@class CloudHubWhiteBoardKit, CHFileModel, CHWBDrawViewManager, CHWBWebViewManager;

@interface CHWhiteBoardView : UIView

@property (nonatomic, weak) id <CHWhiteBoardViewDelegate> delegate;

/// 白板配置
@property (nonatomic, copy, readonly) CloudHubWhiteBoardViewConfig *whiteBoardViewConfig;

/// 白板Id
@property (nonatomic, strong, readonly) NSString *whiteBoardId;
/// 课件Id
@property (nonatomic, strong, readonly) NSString *fileId;
/// 当前页码
@property (nonatomic, assign, readonly) NSUInteger currentPage;
/// 总页码
@property (nonatomic, assign, readonly) NSUInteger totalPage;

/// 白板背景容器
@property (nonatomic, strong, readonly) UIView *whiteBoardContentView;

/// web文档管理
@property (nonatomic, strong, readonly) CHWBWebViewManager *webViewManager;
/// 普通文档管理
@property (nonatomic, strong, readonly) CHWBDrawViewManager *drawViewManager;


- (void)destroy;

/// 清理数据
- (void)clearDataAfterClass;

- (instancetype)initWithFrame:(CGRect)frame whiteboardId:(nullable NSString *)whiteboardId;
- (instancetype)initWithFrame:(CGRect)frame whiteboardId:(nullable NSString *)whiteboardId whiteBoardViewConfig:(nullable CloudHubWhiteBoardViewConfig *)whiteBoardViewConfig;


#pragma mark - 白板属性设置

/// 是否有画笔权限
- (void)setCandraw:(BOOL)canDraw;
/// 是否有翻页权限
- (void)setCanpage:(BOOL)canPage;
/// 是否只能操作自己的画笔数据(undo redo clear select)
- (void)setIsOnlyOperationSelfShape:(BOOL)isOnlyOperationSelfShape;


#pragma mark - 白板H5课件参数设置

/// 变更H5播放视频还是回调原生
- (void)setIsAllowPptPubVideo:(BOOL)isAllowPptPubVideo;
/// 变更H5播放音频还是回调原生
- (void)setIsAllowPptPubAudio:(BOOL)isAllowPptPubAudio;

/// 变更H5课件地址参数，此方法会刷新当前H5课件以变更新参数
- (void)changeConnectH5CoursewareUrlParameters:(nullable NSDictionary *)parameters;


#pragma mark - 信令处理

/// 收到远端pubMsg消息通知
- (void)remotePubMsg:(NSDictionary *)message;
/// 收到远端delMsg消息的通知
- (void)remoteDelMsg:(NSDictionary *)message;


#pragma mark - 窗口操作

/// 变更白板窗口背景色
- (void)changeWhiteBoardBackgroudColor:(nullable UIColor *)color;
/// 变更白板画布背景色
- (void)changeCourseViewBackgroudColor:(nullable UIColor *)color;
/// 变更白板背景图
- (void)changeWhiteBoardBackImage:(nullable UIImage *)image;
- (void)changeWhiteBoardBackImageUrl:(nullable NSURL *)imageUrl;
/// 变更白板画布背景图
- (void)changeCourseViewBackImage:(nullable UIImage *)image;
- (void)changeCourseViewBackImageUrl:(nullable NSURL *)imageUrl;


#pragma mark - 刷新当前课件数据
/// 内部使用
/// 改变课件id
//- (void)changeFileId:(NSString *)fileId;
/// 改变课件页码
//- (void)changeCurrentPage:(NSUInteger)currentPage;
/// 改变课件总页码
//- (void)changeTotalPage:(NSUInteger)totalPage;


#pragma mark - 课件操作

/// 显示课件，不同步
- (void)showPageWithFile:(CHFileModel *)fileModel;
/// 显示课件
- (void)showPageWithFile:(CHFileModel *)fileModel sendSignal:(BOOL)send;

/// 刷新当前白板课件
- (void)freshCurrentCourse;

/// 多课件时关闭课件
//- (void)close;
//- (void)closeAndSendSignal:(BOOL)send;

#pragma mark 翻页

/// 课件 上一页
- (void)whiteBoardPrePage;
/// 课件 下一页
- (void)whiteBoardNextPage;
/// 课件 跳转页
- (void)whiteBoardTurnToPage:(NSUInteger)pageNum;

#pragma mark 缩放

/// 白板 放大
- (void)whiteBoardEnlarge;
/// 白板 缩小
- (void)whiteBoardNarrow;
/// 白板 缩放重置
- (void)whiteBoardResetEnlarge;

/// 获取当前窗口缩放比例
- (CGFloat)documentZoomScale;


#pragma mark - 画笔控制

/// 变更默认画笔颜色
- (void)changeDefaultPrimaryColor:(NSString *)defaultPrimaryColor;

/// 变更画笔工具
- (void)brushToolsChangeToolType:(CHBrushToolType)toolType;
/// 变更画笔图形类型
- (void)brushToolsChangeDrawType:(CHDrawType)drawType lineColorHex:(NSString *)colorHex lineWidthScale:(CGFloat)lineWidthScale;

/// 获取当前画笔工具类型
- (CHBrushToolType)getCurrentBrushToolType;
/// 获取当前画笔配置
- (CHBrushToolsConfigs *)getCurrentBrushToolConfig;

/// 恢复画笔默认配置
- (void)freshBrushToolConfigs;

/// 发送UndoRedo状态
- (void)sendUndoRedoState;

@end

//@protocol CHWhiteBoardViewDelegate <CHDocumentViewDelegate>
@protocol CHWhiteBoardViewDelegate <NSObject>

/// H5脚本文件加载初始化完成
- (void)onWhiteBoardViewInitFinished:(CHWhiteBoardView *)whiteBoardView;

/// 打开交互课件加载状态
- (void)onWhiteBoardViewLoadInterCourse:(CHWhiteBoardView *)whiteBoardView isSuccess:(BOOL)isSuccess;

/// 当前打开的课件列表只在kitDelegate返回，解决cacheMsgPool延时
- (void)onWhiteBoardChangedShowFileIdList:(NSArray *)fileIdList;

/// 课件窗口点击事件
- (void)onWhiteBoardViewClicked:(CHWhiteBoardView *)whiteBoardView;

/// 课件显示
- (void)onWhiteBoardViewShow:(CHWhiteBoardView *)whiteBoardView;

/// 课件加载结果
- (void)onWhiteBoardViewLoadFinished:(CHWhiteBoardView *)whiteBoardView withFileId:(NSString *)fileId currentPage:(NSUInteger)currentPage totalPage:(NSUInteger)totalPage canPrevPage:(BOOL)canPrevPage canNextPage:(BOOL)canNextPage canZoom:(BOOL)canZoom isSuccess:(BOOL)isSuccess;


/// 画笔刷新状态
- (void)onWhiteBoardView:(CHWhiteBoardView *)whiteBoardView changeUndoRedoState:(NSString *)fileId currentpage:(NSUInteger)currentPage canUndo:(BOOL)canUndo canRedo:(BOOL)canRedo canErase:(BOOL)canErase canClean:(BOOL)canClean canSelect:(BOOL)canSelect canDeleteSelect:(BOOL)canDeleteSelect;

/// 缩放比例改变
- (void)onWhiteBoardView:(CHWhiteBoardView *)whiteBoardView zoomScaleChanged:(CGFloat)zoomScale;

// 交互课件媒体操作

/// H5脚本播放流媒体（视频），只有播放
- (BOOL)onWhiteBoardView:(CHWhiteBoardView *)whiteBoardView
    startSharedMediaFile:(NSString *)mediaPath
                 isVideo:(BOOL)isVideo
                    toId:(nullable NSString *)toId
              attributes:(NSDictionary *)attributes;
/// H5脚本本地音视频 播放
- (BOOL)onWhiteBoardView:(CHWhiteBoardView *)whiteBoardView startPlayingMedia:(nullable NSString *)mediaPath cycle:(BOOL)cycle;
/// H5脚本本地音视频 停止
- (BOOL)onWhiteBoardView:(CHWhiteBoardView *)whiteBoardView stopPlayingMedia:(nullable NSString *)mediaPath;
//- (BOOL)pausePlayingMedia:(nullable NSString *)filepath;
//- (BOOL)resumePlayingMedia:(nullable NSString *)filepath;

/// H5脚本变更用户属性
- (BOOL)onWhiteBoardView:(CHWhiteBoardView *)whiteBoardView setPropertyOfUid:(NSString *)uid toId:(nullable NSString *)toId properties:(NSDictionary *)prop;

@end

NS_ASSUME_NONNULL_END
