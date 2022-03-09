//
//  CHWhiteBoardKitEnum.h
//  CloudHubWhiteBoardKit
//
//  Created by jiang deng on 2020/11/4.
//

#ifndef CHWhiteBoardKitEnum_h
#define CHWhiteBoardKitEnum_h

/// 自定义白板课件类型
typedef NS_ENUM(NSUInteger, CHWhiteBordFileProp)
{
    /// 普通
    CHWhiteBordFileProp_GeneralFile = 0,
    /// 动态Ppt
    CHWhiteBordFileProp_DynamicPPT,
    CHWhiteBordFileProp_NewDynamicPPT,
    /// H5
    CHWhiteBordFileProp_H5Document = 3
};

/// 操作模式
typedef NS_ENUM(NSUInteger, CHWorkMode)
{
    CHWorkModeViewer        = 0,    // 查看模式 只能观看不能标记 隐藏工具条
    CHWorkModeControllor    = 1,    // 操作模式
    CHWorkModeSelect        = 10    // 选择模式
};

/// 画笔信令事件
typedef NS_ENUM(NSInteger, CHDrawEvent)
{
    CHDrawEventUnknown          = 0,    // 切换文档
    CHDrawEventShowPage         = 1,    // 切换文档
    CHDrawEventShapeAdd         = 2,    // 增加画笔
    CHDrawEventShapeClean       = 5,    // 清屏
    CHDrawEventShapeUndo        = 6,    // 撤回
    CHDrawEventShapeRedo        = 7,    // 重做
    CHDrawEventShapeMove        = 8,    // 移动
    CHDrawEventShapeDelete      = 9,    // 删除
    CHDrawEventShowUserPage     = 10    // 切换小黑板数据
};

/// 画笔工具类型
typedef NS_ENUM(NSInteger, CHBrushToolType)
{
    CHBrushToolTypeMouse    = 100,  // 箭头
    CHBrushToolTypeLine     = 10,   // 划线类型
    CHBrushToolTypeText     = 20,   // 文字类型
    CHBrushToolTypeShape    = 30,   // 框类型
    CHBrushToolTypeEraser   = 50,   // 橡皮擦
    
    // 操作工具
    CHBrushToolTypeClear    = 60,   // 清除
    CHBrushToolTypeUndo     = 70,   // 撤销
    CHBrushToolTypeRedo     = 80,   // 重做
    CHBrushToolTypeSelect   = 90,   // 选取
    CHBrushToolTypeDeleteSelected = 91  // 删除选取
};

/// 画笔绘图类型
typedef NS_ENUM(NSInteger, CHDrawType)
{
    CHDrawTypePen               = 10,   // 钢笔
    CHDrawTypeMarkPen           = 11,   // 记号笔
    CHDrawTypeLine              = 12,   // 直线
    CHDrawTypeArrowLine         = 13,   // 带箭头直线
    
    CHDrawTypeText              = 20,   // 文本
    
    CHDrawTypeEmptyRectangle    = 30,   // 空心矩形
    CHDrawTypeFilledRectangle   = 31,   // 实心矩形
    CHDrawTypeEmptyEllipse      = 32,   // 空心圆
    CHDrawTypeFilledEllipse     = 33,   // 实心圆
    
    CHDrawTypeEraser            = 50,   // 橡皮擦
    
    CHDrawTypeClear             = 60,   // 清除画板内容
    
    CHDrawTypeUndo              = 70,   // 撤销
    CHDrawTypeRedo              = 80,   // 重做
    
    CHDrawTypeSelect            = 90,   // 选取
    CHDrawTypeDeleteSelected    = 91    // 删除选取
};


#endif /* CHWhiteBoardKitEnum_h */
