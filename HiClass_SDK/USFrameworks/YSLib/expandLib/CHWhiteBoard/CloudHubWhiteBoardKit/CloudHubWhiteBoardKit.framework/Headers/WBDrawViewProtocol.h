//
//  WBDrawViewProtocol.h
//  CloudHubWhiteBoardKit
//
//  Created by jiang deng on 2020/11/27.
//

#ifndef WBDrawViewProtocol_h
#define WBDrawViewProtocol_h

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol WBDrawViewDelegate <NSObject>

/// 绘制，redo发送信令
- (void)addSharpWithFileId:(NSString *)fileId shapeId:(NSString *)shapeId shapeDic:(NSDictionary *)shapeDic;
/// undo发送信令
- (void)deleteSharpWithFileId:(NSString *)fileId shapeId:(NSString *)shapeId shapeDic:(NSDictionary *)shapeDic;

/// 清除操作，clear发送信令
- (void)clearActionWithFileId:(NSString *)fileId shapeId:(NSString *)shapeId shapeDic:(NSDictionary *)shapeDic;

/// 移动操作，move发送信令
- (void)moveActionWithFileId:(NSString *)fileId shapeId:(NSString *)shapeId shapeDic:(NSDictionary *)shapeDic;

/// 删除操作，del发送信令
- (void)delActionWithFileId:(NSString *)fileId shapeId:(NSString *)shapeId shapeDic:(NSDictionary *)shapeDic;

/// 刷新状态
- (void)changeUndoRedoState:(NSString *)fileId currentpage:(NSUInteger)currentPage canUndo:(BOOL)canUndo canRedo:(BOOL)canRedo canErase:(BOOL)canErase canClean:(BOOL)canClean canSelect:(BOOL)canSelect canDeleteSelect:(BOOL)canDeleteSelect;

@end

NS_ASSUME_NONNULL_END

#endif /* WBDrawViewProtocol_h */
