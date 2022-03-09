//
//  CHBrushToolView.h
//  CHWhiteBoard
//
//  Created by jiang deng on 2020/12/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class CHBrushToolView, CHDrawBoardView;

@protocol CHBrushToolViewDelegate <NSObject>

/// 工具类型回调
/// @param toolType 工具类型
- (void)brushToolView:(CHBrushToolView *)brushToolView changeToolType:(CHBrushToolType)toolType showDrawBoardView:(BOOL)showDrawBoardView;

@end

@interface CHBrushToolView : UIView

@property (nonatomic, weak) id <CHBrushToolViewDelegate>delegate;

@property (nonatomic, strong) NSString *whiteBoardId;

@property (nonatomic, assign) CGFloat leftGap;

@property (nonatomic, weak, readonly) UIButton *switchBtn;

@property (nonatomic, weak) CHDrawBoardView *drawBoardView;

@property (nonatomic, assign, readonly) CHBrushToolType currentType;

- (instancetype)initWithWhiteBoardId:(NSString *)whiteBoardId canOperate:(BOOL)canOperate isObjectLevel:(BOOL)isObjectLevel;

- (void)brushToolChangeToolType:(CHBrushToolType)toolType showDrawBoardView:(BOOL)showDrawBoardView;

- (void)freshBrushToolViewWithIsOnlyOperationSelfShape:(BOOL)isOnlyOperationSelfShape;

- (void)freshCanUndo:(BOOL)canUndo canRedo:(BOOL)canRedo;
- (void)freshClear:(BOOL)canClear;
- (void)freshErase:(BOOL)canErase;
- (void)freshSelect:(BOOL)canSelect;
- (void)freshDelSelect:(BOOL)canDelSelect;

- (void)changeCurrentType:(CHBrushToolType)currentType;

@end

NS_ASSUME_NONNULL_END
