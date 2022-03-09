//
//  CHWhiteBoardEnum.h
//  CHWhiteBoard
//
//

#ifndef CHWhiteBoardEnum_h
#define CHWhiteBoardEnum_h


/// 白板文档媒体类型
typedef NS_ENUM(NSUInteger, CHWhiteBordMediaType)
{
    /// 视频
    CHWhiteBordMediaType_Video = 0,
    /// 音频
    CHWhiteBordMediaType_Audio
};

typedef NS_ENUM(NSUInteger, CHSmallBoardStageState)
{
    CHSmallBoardStage_none = 0, // 非小黑板状态
    CHSmallBoardStage_prepare,  // 准备阶段 (老师创建了白板还没有分发的时候)
    CHSmallBoardStage_answer,   // 答题阶段 （老师点了分发，学生在答题阶段）
    CHSmallBoardStage_comment   // 讲评阶段 （老师回收了画板，学生同步观看老师的状态）
    
    // 再次分发又回到2 状态 ，关闭回到 0状态
};


#endif /* CHWhiteBoardEnum_h */
