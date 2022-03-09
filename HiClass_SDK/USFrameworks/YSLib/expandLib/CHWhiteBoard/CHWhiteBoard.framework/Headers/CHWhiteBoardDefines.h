//
//  CHWhiteBoardDefines.h
//  CHWhiteBoard
//
//

#ifndef CHWhiteBoardDefines_h
#define CHWhiteBoardDefines_h


/// 默认小班课白板背景颜色
#define CHWhiteBoard_MainBackGroudColor             CHSkinWhiteDefineColor(@"Color10")
#define CHWhiteBoard_MainBackDrawBoardBgColor       CHSkinWhiteDefineColor(@"Color1")
#define CHWhiteBoard_BackGroudColor                 CHSkinWhiteDefineColor(@"Color9")

/// 默认直播白板背景颜色
#define CHWhiteBoard_LiveMainBackGroudColor         CHSkinWhiteDefineColor(@"Live_DefaultBgColor")
#define CHWhiteBoard_LiveMainBackDrawBoardBgColor   CHSkinWhiteDefineColor(@"Live_WhiteBoardDrawBoardBgColor")
#define CHWhiteBoard_LiveBackGroudColor             CHSkinWhiteDefineColor(@"Live_DefaultBgColor")

#define CHWhiteBoard_TopBarBackGroudColor           CHSkinWhiteDefineColor(@"PlaceholderColor")
#define CHWhiteBoard_BorderColor                    [CHSkinWhiteDefineColor(@"PlaceholderColor") changeAlpha:0.8f]



#define CHWhiteBoard_SelectTopBarBackGroudColor     CHSkinWhiteDefineColor(@"Color2")
#define CHWhiteBoard_NormalTopBarBackGroudColor     [CHSkinWhiteDefineColor(@"Color2") bm_changeAlpha:0.7f]


#pragma - mark Dictionary Key

/// api相关服务器设置
FOUNDATION_EXTERN NSString *const CHWhiteBoardWebProtocolKey;
/// host
FOUNDATION_EXTERN NSString *const CHWhiteBoardWebHostKey;
/// port
FOUNDATION_EXTERN NSString *const CHWhiteBoardWebPortKey;

/// 课件相关服务器设置
FOUNDATION_EXTERN NSString *const CHWhiteBoardDocProtocolKey;
FOUNDATION_EXTERN NSString *const CHWhiteBoardDocHostKey;
FOUNDATION_EXTERN NSString *const CHWhiteBoardDocPortKey;

/// 备份服务器设置
FOUNDATION_EXTERN NSString *const CHWhiteBoardBackupDocProtocolKey;
FOUNDATION_EXTERN NSString *const CHWhiteBoardBackupDocHostKey;
FOUNDATION_EXTERN NSString *const CHWhiteBoardBackupDocPortKey;

FOUNDATION_EXTERN NSString *const CHWhiteBoardBackupDocHostListKey ;

/// 是否后台播放
FOUNDATION_EXTERN NSString *const CHWhiteBoardPlayBackKey;
/// pdf解析精度
FOUNDATION_EXTERN NSString *const CHWhiteBoardPDFLevelsKey;
/// 实例化画笔数据
FOUNDATION_EXTERN NSString *const CHWhiteBoardIsObjectLevelKey;
/// H5课件cookie
FOUNDATION_EXTERN NSString *const CHWhiteBoardCookisKey;


#define CHDefaultBrushToolType CHBrushToolTypeLine

#pragma - mark 信令

/// 单窗口位置、大小、最小化、最大化数据
static  NSString *const sCHWBSignal_MoreWhiteboardState       = @"MoreWhiteboardState";
/// 窗口层级排序
static  NSString *const sCHWBSignal_MoreWhiteboardGlobalState = @"MoreWhiteboardGlobalState";


#pragma mark - 小黑板
/// 查看学生的小黑板信令
static  NSString *const sCHWBSignal_showUserSmallBlackBoard   = @"showUserSmallBlackBoard";

/// 小黑板学生上传图片信令
static  NSString *const sCHWBSignal_setSmallBlackBoardImage   = @"setSmallBlackBoardImage";

/// 小黑板阶段状态信令(准备，分发，收回，移除)
static  NSString *const sCHWBSignal_smallBlackBoardState     = @"smallBlackBoardState";

///小黑板,老师的固定whiteBoardId
static  NSString *const sCHWBTeachersmallWhiteBoardId        = @"smallBlackBoard-teacherId";
static  NSString *const sCHWBSmallFileId                     = @"smallFileId";

/// 小黑板答题阶段私聊
static  NSString *const sCHWBSignal_SmallRoomPrivate         = @"RoomPrivate";


#endif /* CHWhiteBoardDefines_h */
