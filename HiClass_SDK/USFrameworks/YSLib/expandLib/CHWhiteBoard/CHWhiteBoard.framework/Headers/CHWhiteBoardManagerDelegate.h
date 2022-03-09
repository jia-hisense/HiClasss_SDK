//
//  CHWhiteBoardManagerDelegate.h
//  CHWhiteBoard
//
//

#ifndef CHWhiteBoardManagerDelegate_h
#define CHWhiteBoardManagerDelegate_h


#import <Foundation/Foundation.h>
#import "CHWhiteBoardEnum.h"
@class CHWhiteBoardWindow;


@protocol CHWhiteBoardManagerDelegate <CloudHubWhiteBoardDelegate>

@optional

/// 课件窗口最大化事件
- (void)onWhiteBoardMaximizeView;

/// 课件全屏
- (void)onWhiteBoardFullScreen:(BOOL)isFullScreen;

/// 媒体课件播放状态
- (void)onWhiteBoardChangedMediaFileStateWithFileId:(NSString *)fileId state:(CHMediaState)state;


#if WBHaveSmallBalckBoard
/// 小黑板状态变化（更改画笔）
- (void)onSetSmallBoardStageState:(CHSmallBoardStageState)smallBoardStageState;

/// 小黑板bottomBar的代理
///上传图片
- (void)onSmallBoardBottomBarClickToUploadImage;
///删除图片
- (void)onSmallBoardBottomBarClickToDeleteImage;

/// 小黑板答题阶段私聊
- (void)onSmallBoardStartPrivateChatWithPrivateIdArray:(NSArray *)privateIdArray;
- (void)onSmallBoardStopPrivateChat;

/// 多课件删除课件窗口
- (void)onDeleteWhiteBoardWindow:(CHWhiteBoardWindow *)whiteBoardWindow;

#endif

@end

#endif /* CHWhiteBoardManagerDelegate_h */
