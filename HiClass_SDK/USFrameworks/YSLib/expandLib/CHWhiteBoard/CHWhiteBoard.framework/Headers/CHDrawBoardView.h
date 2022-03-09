//
//  CHDrawBoardView.h
//  CHWhiteBoard
//
//  Created by jiang deng on 2020/12/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class CHDrawBoardView;
@protocol CHDrawBoardViewDelegate <NSObject>

/// 形状 颜色 大小 回调
/// @param drawType 画笔 形状类型
/// @param hexColor 颜色
/// @param progress 大小
- (void)brushSelectorView:(CHDrawBoardView *)drawBoardView
        didSelectDrawType:(CHDrawType)drawType
                    color:(NSString *)hexColor
            widthProgress:(CGFloat)progress;

@end

@interface CHDrawBoardView : UIView

@property (nonatomic, strong, readonly) NSString *whiteBoardId;

@property (nonatomic, weak) id<CHDrawBoardViewDelegate> delegate;

/// 工具类型 必传  为了判断哪种功能界面
@property(nonatomic, assign, readonly) CHBrushToolType brushToolType;

/// 画笔类型  边框类型 （记录上次选中的类型）
@property (nonatomic, assign, readonly) CHDrawType drawType;

/// 背景view
@property (nonatomic, strong, readonly) UIView *backContainerView;


- (instancetype)initWithWhiteBoardId:(NSString *)whiteBoardId brushToolType:(CHBrushToolType)brushToolType;

@end

NS_ASSUME_NONNULL_END
