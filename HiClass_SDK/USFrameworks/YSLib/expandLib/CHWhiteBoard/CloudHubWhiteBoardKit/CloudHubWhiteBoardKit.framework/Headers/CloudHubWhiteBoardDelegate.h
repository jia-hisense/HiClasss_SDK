//
//  CloudHubWhiteBoardDelegate.h
//  CloudHubWhiteBoardKit
//
//  Created by jiang deng on 2020/11/3.
//

#ifndef CloudHubWhiteBoardDelegate_h
#define CloudHubWhiteBoardDelegate_h

NS_ASSUME_NONNULL_BEGIN

@class CHWhiteBoardView;
@protocol CloudHubWhiteBoardDelegate <NSObject>

@optional

/// 白板管理准备完毕
- (void)onWhiteBroadCheckRoomFinish:(BOOL)finished;

/// 白板管理进入房间完毕，SAAS使用
- (void)onWhiteBroadEnterRoomFinish:(BOOL)finished;

#pragma mark - 以下是在 onWhiteBroadCheckRoomFinish 回调之后触发

/// 获取文件列表回调
/// @param fileList 文件列表
- (void)onWhiteBroadFileList:(NSArray <NSDictionary *> *)fileList;

/// 添加课件
- (void)onWhiteBroadAddFile:(NSString *)fileId;
/// 删除课件
- (void)onWhiteBroadDeleteFile:(NSString *)fileId;

/// 当前打开的课件列表
- (void)onWhiteBoardChangedShowFileIdList:(NSArray *)fileIdList;

#pragma mark - 课件窗口事件

/// 创建白板
- (void)onAddWhiteBroadView:(CHWhiteBoardView *)whiteBoardView;

/// 关闭白板
- (void)onBeforeCloseWhiteBoardView:(nullable CHWhiteBoardView *)whiteBoardView;

#pragma mark - 课件加载事件

/// H5脚本文件加载初始化完成
- (void)onWhiteBoardViewInitFinished:(CHWhiteBoardView *)whiteBoardView;

/// 打开H5交互课件加载状态
- (void)onWhiteBoardViewLoadInterCourse:(CHWhiteBoardView *)whiteBoardView isSuccess:(BOOL)isSuccess;

/// 收到课件加载(与信令同步)
/// 与onWhiteBoardViewLoadFinished:withFileId:currentPage:totalPageisSuccess:
/// 会同时触发，但无先后顺序
- (void)onWhiteBoardViewShow:(CHWhiteBoardView *)whiteBoardView;

/// 课件加载结果(与信令异步)
- (void)onWhiteBoardViewLoadFinished:(CHWhiteBoardView *)whiteBoardView withFileId:(NSString *)fileId currentPage:(NSUInteger)currentPage totalPage:(NSUInteger)totalPage canPrevPage:(BOOL)canPrevPage canNextPage:(BOOL)canNextPage canZoom:(BOOL)canZoom isSuccess:(BOOL)isSuccess;

/// 课件点击
- (void)onWhiteBoardViewClicked:(CHWhiteBoardView *)whiteBoardView;

/// 刷新画笔工具状态
- (void)onWhiteBoardView:(CHWhiteBoardView *)whiteBoardView changeUndoRedoState:(NSString *)fileId currentpage:(NSUInteger)currentPage canUndo:(BOOL)canUndo canRedo:(BOOL)canRedo canErase:(BOOL)canErase canClean:(BOOL)canClean canSelect:(BOOL)canSelect canDeleteSelect:(BOOL)canDeleteSelect;

/// 缩放比例改变
- (void)onWhiteBoardView:(CHWhiteBoardView *)whiteBoardView zoomScaleChanged:(CGFloat)zoomScale;

#pragma mark - 交互课件媒体操作

/// 播放流媒体（视频），只有播放(H5脚本或音视频课件) whiteBoardView为nil时播放媒体课件
- (BOOL)onWhiteBoardView:(nullable CHWhiteBoardView *)whiteBoardView
    startSharedMediaFile:(NSString *)mediaPath
                 isVideo:(BOOL)isVideo
                    toId:(nullable NSString *)toId
              attributes:(NSDictionary *)attributes
                  isInH5:(BOOL)isInH5;

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

#endif /* CloudHubWhiteBoardDelegate_h */
