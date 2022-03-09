//
//  CHDrawView.h
//  CloudHubWhiteBoardKit
//
//  Created by jiang deng on 2020/11/27.
//

#import <UIKit/UIKit.h>
#import "WBDrawViewProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@class WBDrawView;
@interface CHDrawView : UIView

@property (nonatomic, weak) id <WBDrawViewDelegate> delegate;

/// 课件id
@property (nonatomic, strong, readonly) NSString *fileId;
@property (nonatomic, assign, readonly) NSUInteger currentPage;

// 涂鸦显示层
@property (nonatomic, strong, readonly) WBDrawView *drawView;
// 实时绘制层
@property (nonatomic, strong, readonly) WBDrawView *rtDrawView;


- (instancetype)initWithWhiteBoardId:(NSString *)whiteBoardId whiteBoardViewConfig:(CloudHubWhiteBoardViewConfig *)whiteBoardViewConfig;

- (void)setWorkMode:(CHWorkMode)mode;

- (void)changeDrawType:(CHDrawType)drawType lineColorHex:(NSString *)colorHex lineWidthScale:(CGFloat)lineWidthScale;
- (void)changeDrawLineHexColor:(NSString *)colorHex lineWidthScale:(CGFloat)lineWidthScale;


/// 切换课件或翻页
- (void)switchToFileId:(NSString *)fileId
               pageNum:(NSUInteger)currentPage
     updateImmediately:(BOOL)update;

/// 添加，操作画笔数据
- (void)addDrawSharpData:(NSDictionary*)sharpData authorUserId:(NSString *)userId seq:(NSUInteger)seq isRedo:(BOOL)isRedo isFromMyself:(BOOL)isFromMyself isUpdate:(BOOL)isUpdate;


/// 收到清除信令 清空绘制
- (void)handleClearDrawWithClearId:(NSString *)clearId authorUserId:(NSString *)userId seq:(NSUInteger)seq toAuthorUserId:(nullable NSString *)toAuthorUserId isRedo:(BOOL)isRedo isFromMyself:(BOOL)isFromMyself;
/// 收到移动信令 移动绘制
- (void)handleMoveDrawWithMoveId:(NSString *)moveId authorUserId:(NSString *)userId seq:(NSUInteger)seq toAuthorUserId:(nullable NSString *)toAuthorUserId isRedo:(BOOL)isRedo moveShapesDic:(NSDictionary *)moveShapesDic isFromMyself:(BOOL)isFromMyself;
/// 收到删除信令 删除绘制
- (void)handleDeleteDrawWithDeleteId:(NSString *)deleteId authorUserId:(NSString *)userId seq:(NSUInteger)seq toAuthorUserId:(nullable NSString *)toAuthorUserId isRedo:(BOOL)isRedo deleteShapeIdsArray:(NSArray *)deleteShapeIdsArray isFromMyself:(BOOL)isFromMyself;

/// 收到undo撤回画笔
- (void)handleUndoDrawWithShapeId:(NSString *)shapeId;
/// 收到undo撤回clear清除
- (void)handleUndoDrawWithClearId:(NSString *)clearId;
/// 收到undo撤回移动画笔
- (void)handleUndoDrawWithMoveId:(NSString *)moveId;
/// 收到undo撤回删除选中画笔
- (void)handleUndoDrawWithDeleteId:(NSString *)deleteId;

/// 发送UndoRedo状态
- (void)sendUndoRedoState;

/// 变更画笔操作对象权限时清除选择数据
- (void)clearSelectedDraw;

/// 清理数据
- (void)clearDataAfterClass;

@end

NS_ASSUME_NONNULL_END
