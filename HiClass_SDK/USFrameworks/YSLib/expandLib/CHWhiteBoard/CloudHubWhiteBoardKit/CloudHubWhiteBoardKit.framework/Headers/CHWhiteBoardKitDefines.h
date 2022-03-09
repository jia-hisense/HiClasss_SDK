//
//  CHWhiteBoardKitDefines.h
//  CloudHubWhiteBoardKit
//
//  Created by jiang deng on 2020/11/3.
//

#ifndef CHWhiteBoardKitDefines_h
#define CHWhiteBoardKitDefines_h

/// 白板创建完成
typedef void(^wbLoadFinishedBlock)(void);
/// webview崩溃回调
typedef void(^wbWebViewTerminateBlock)(void);

typedef void(^WBPDFLoadFinishBlock)(CGFloat ratio, BOOL isSuccess, BOOL retry);
typedef void(^WBImageLoadFinishBlock)(CGFloat ratio, BOOL isSuccess, BOOL retry);

#pragma - mark resources

#define CHWBKITBUNDLE_NAME          @"CHWhiteBoardKitResources.bundle"
#define CHWBKITBUNDLE_SHORTNAME     @"CHWhiteBoardKitResources"
#define CHWBKITBUNDLE               [NSBundle bundleWithPath: [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:CHWBKITBUNDLE_NAME]]

/// 线宽、字体基准值
#define CHWHITEBOARDKIT_SHAPESCALEBASE  (30.0f)
/// 文本框输入工具的text控件tag
#define CHWHITEBOARDKIT_TEXTVIEWTAG     20190109

#define CHWHITEBOARDKIT_DEFAULTLINECOLOR    UIColor.redColor

/// 课件缩放范围
#define CHWHITEBOARDKIT_MAXZOOMSCALE    (3.0f)
#define CHWHITEBOARDKIT_MINZOOMSCALE    (1.0f)

#pragma mark - 1.读取本地资源包index  0.读取指定ip   ssssssssss
#define IS_LOAD_LOCAL_INDEX 1

#if IS_LOAD_LOCAL_INDEX
/// 读取本地时通常为发布版本需要设置成https端口443
    #define CHWBKIT_HTTPS           @"https"
    #define CHWBKIT_Port            @"443"

#else

    #define CHWBKIT_HTTPS           @"http"
    #define CHWBKIT_Port            @"80"
    #define CHWBKIT_PointToHost     @"192.168.1.118:9251"

#endif

#pragma - mark HttpDNS

#define CHWHITEBOARD_USEHTTPDNS 1
#define CHWHITEBOARD_NORMALUSEHTTPDNS 1
// 网宿
#define CHWHITEBOARD_USEHTTPDNS_ADDWS 1
// 金山
#define CHWHITEBOARD_USEHTTPDNS_ADDKS 1
// 阿里
#if CHUSEHTTPDNS_ADDALI
#define CHWHITEBOARD_USEHTTPDNS_ADDALI 1
#else
#define CHWHITEBOARD_USEHTTPDNS_ADDALI 0
#endif

#define CHWhiteBoard_HttpDnsService_AccountID   131798

#if CHWHITEBOARD_USEHTTPDNS_ADDWS
/// 网宿host头
static NSString *const CHWhiteBoard_domain_ws_header = @"rddoccdnws.roadofcloud";
static NSString *const CHWhiteBoard_domain_demows_header = @"rddoccdndemows.roadofcloud";
/// 网宿host
static NSString *const CHWhiteBoard_domain_ws = @"rddoccdnws.roadofcloud.net";
static NSString *const CHWhiteBoard_domain_demows = @"rddoccdndemows.roadofcloud.net";

/// 网宿dns解析
static NSString *const CHWhiteBoard_wshttpdnsurl = @"http://edge.wshttpdns.com/v1/httpdns/clouddns";
#endif

#if CHWHITEBOARD_USEHTTPDNS_ADDALI
/// 阿里host头
static NSString *const CHWhiteBoard_domain_ali_header = @"rddoccdn.roadofcloud";
static NSString *const CHWhiteBoard_domain_demoali_header = @"rddocdemo.roadofcloud";
/// 阿里host
static NSString *const CHWhiteBoard_domain_ali = @"rddoccdn.roadofcloud.net";
static NSString *const CHWhiteBoard_domain_demoali = @"rddocdemo.roadofcloud.net";
#endif

#if CHWHITEBOARD_USEHTTPDNS_ADDKS
/// 金山host头
static NSString *const CHWhiteBoard_domain_ks_header = @"ks-cn-doc-cdn.roadofcloud";
static NSString *const CHWhiteBoard_domain_demoks_header = @"ks-cn-recorddemo-cdn.roadofcloud";
/// 金山host
static NSString *const CHWhiteBoard_domain_ks = @"ks-cn-doc-cdn.roadofcloud.net";
static NSString *const CHWhiteBoard_domain_demoks = @"ks-cn-recorddemo-cdn.roadofcloud.net";

/// 金山dns解析
static NSString *const CHWhiteBoard_kshttpdnsurl = @"http://120.92.215.64/d";
#endif


#pragma - mark Dictionary Key

/// 白板web地址
extern NSString *const CHWhiteBoardKitWebProtocolKey;
extern NSString *const CHWhiteBoardKitWebHostKey;
extern NSString *const CHWhiteBoardKitWebPortKey;

/// 白板课件服务器地址
extern NSString *const CHWhiteBoardKitDocProtocolKey;
extern NSString *const CHWhiteBoardKitDocHostKey;
extern NSString *const CHWhiteBoardKitDocPortKey;

/// 白板课件备份地址
extern NSString *const CHWhiteBoardKitBackupDocProtocolKey;
extern NSString *const CHWhiteBoardKitBackupDocHostKey;
extern NSString *const CHWhiteBoardKitBackupDocPortKey;

extern NSString *const CHWhiteBoardKitBackupDocHostListKey;

/// 白板配置项

/// 是否多课件
extern NSString *const CHWhiteBoardKitConfigMultiCoursewareKey;
/// 画布比例
extern NSString *const CHWhiteBoardKitConfigCanvasRatioKey;
/// 画板背景色RGBA 格式支持 #RRGGBBAA 及 RGBA(r,b,g,a)，RGBA(r,b,g)
extern NSString *const CHWhiteBoardKitConfigCanvasBGColor;
/// 画布背景色RGBA 格式支持 #RRGGBBAA 及 RGBA(r,b,g,a)，RGBA(r,b,g)
extern NSString *const CHWhiteBoardKitConfigCanvasColor;
/// 默认画笔工具
extern NSString *const CHWhiteBoardKitConfigDefaultToolTypeKey;
/// 是否实例化画笔数据
extern NSString *const CHWhiteBoardKitConfigObjectLevelKey;
/// 是否可以手势缩放课件
extern NSString *const CHWhiteBoardKitConfigGestureZoomKey;
/// 是否使用HttpDNS加载课件
extern NSString *const CHWhiteBoardKitConfigHttpDNSKey;
/// 是否使用预加载课件
extern NSString *const CHWhiteBoardKitConfigPreloadingKey;

/// 缓存数据key
static NSString *const kCHWhiteBoardKitMethodNameKey        = @"CHCacheMsg_MethodName";
static NSString *const kCHWhiteBoardKitParameterKey         = @"CHCacheMsg_Parameter";

#pragma - mark 信令发送对象

/// 发送信息给频道中的所有人
static NSString *const CHWBPubMsgTellAll                    = @"__all";

/// 发送信息给除自己以外的频道中所有人
static NSString *const CHWBPubMsgTellAllExceptSender        = @"__allExceptSender";
/// 除旁听用户以外的所有人
static NSString *const CHWBPubMsgTellAllExceptAuditor       = @"__allExceptAuditor";
/// 只发给特殊身份(助教和老师)
static NSString *const CHWBPubMsgTellAllSuperUsers          = @"__allSuperUsers";

/// 只发送信息到服务器，不发给任何人
static NSString *const CHWBPubMsgTellNone                   = @"__none";


/// 发送给指定房间【房间关系必须是父子关系/兄弟关系】，如: __room:roomidA
static NSString *const CHWBPubMsgTellRoom                   = @"__room";
/// 发送给指定房间但是不发送给自己，房间id不能包含冒号【房间关系必须是父子关系】，如: __roomExceptSender:roomidA
static NSString *const CHWBPubMsgTellRoomExceptSender       = @"__roomExceptSender";
/// 发送给指定房间的助教和老师，房间id不能包含冒号【房间关系必须是父子关系】，如: __roomSuperUsers:roomidA
static NSString *const CHWBPubMsgTellRoomSuperUsers         = @"__roomSuperUsers";
/// 发送给指定房间的用户，房间id不能包含冒号【房间关系必须是父子关系】，如: __room2uid:roomidA:touserid
static NSString *const CHWBPubMsgTellRoomUid                = @"__room2uid";


#pragma - mark 配置属性

static  NSString *const sCHWB_CanDraw                           = @"CanDraw";
static  NSString *const sCHWB_IsAllowPptPubVideo                = @"isAllowPptPubVideo";
static  NSString *const sCHWB_IsAllowPptPubAudio                = @"isAllowPptPubAudio";


#pragma - mark 信令

/// 白板Id
#define CHWhiteBoardId_Header                                   @"docModule_"
static  NSString *const sWhiteboardID                           = @"whiteboardID";
#define CHDefaultWhiteBoardId                                   @"default"
#define CHSmallWhiteBoardId                                     @"small-black-board"

/// 上课
static NSString *const sCHWBSignal_ClassBegin                   = @"ClassBegin";

/// 助教切换课件Host
static NSString *const sCHWBSignal_UseCdnLine                   = @"UseCdnLine";
/// 助教强制刷新课件
static NSString *const sCHWBSignal_RemoteControlCourseware      = @"RemoteControlCourseware";


/// 显示课件
/// 单课件
static  NSString *const sCHWBSignal_ShowPage                    = @"ShowPage";
/// 多课件
#define CHCreateMoreWB_Header                                   @"CreateMoreWB_"
static  NSString *const sCHWBSignal_CreateMoreWB                = @"CreateMoreWB";
static  NSString *const sCHWBSignal_ExtendShowPage              = @"ExtendShowPage";
static  NSString *const sCHWBSignal_DocumentChange              = @"DocumentChange";

static  NSString *const sCHWBSignal_DocumentFilePage_ShowPage   = @"DocumentFilePage_ShowPage";
static  NSString *const sCHWBSignal_DocumentFilePage_ExtendShowPage = @"DocumentFilePage_ExtendShowPage_";

/// 白板增加页数
static  NSString *const sCHWBSignal_WBPageCount                 = @"WBPageCount";

/// 更换画笔工具
static  NSString *const sCHWBSignal_SharpsChange                = @"SharpsChange";
#define CHWBVideoWhiteboard_SharpsChange_Header                 @"videoDrawBoard_"

static  NSString *const sCHWBSignal_H5DocumentAction            = @"H5DocumentAction";
static  NSString *const sCHWBSignal_ExtendH5DocumentAction      = @"ExtendH5DocumentAction";

static  NSString *const sCHWBSignal_NewPptTriggerActionClick    = @"NewPptTriggerActionClick";
static  NSString *const sCHWBSignal_ExtendNewPptTriggerActionClick = @"ExtendNewPptTriggerActionClick";

/// ShowPage ID
static  NSString *const sCHWBSignal_ActionShow                  = @"show";

/// 清除所有消息
static NSString *const sCHWBSignal_DeleteAll                    = @"__AllAll";

#pragma - mark js命令

/// 发送消息
static NSString *const sCHWBJSSignalPubMsg                      = @"pubMsg";
/// 删除消息
static NSString *const sCHWBJSSignalDelMsg                      = @"delMsg";

/// 白板加载完成回调
static NSString *const sCHWBJSSignal_OnPageFinished             = @"onPageFinished";

/// 打印h5日志
static NSString *const sCHWBJSSignal_PrintLogMessage            = @"printLogMessage";
/// 上传监听事件
static NSString *const sCHWBJSSignal_SendBuriedPointEvent       = @"sendBuriedPointEvent";

/// 发布网络文件流的方法
static NSString *const sCHWBJSSignal_PublishNetworkMedia        = @"publishNetworkMedia";
/// 取消发布网络文件流
static NSString *const sCHWBJSSignal_UnpublishNetworkMedia      = @"unpublishNetworkMedia";
/// 设置用户属性
static NSString *const sCHWBJSSignal_SetProperty                = @"setProperty";

/// 白板放大事件
static NSString *const sCHWBJSSignal_ChangeWebPageFullScreen    = @"changeWebPageFullScreen";
/// 接收动作指令
static NSString *const sCHWBJSSignal_ReceiveActionCommand       = @"receiveActionCommand";
/// 发送动作指令
static NSString *const sCHWBJSSignal_SendActionCommand          = @"sendActionCommand";

/// 本地持久化当前文档服务器的地址信息
static NSString *const sCHWBJSSignal_SaveValueByKey             = @"saveValueByKey";
static NSString *const sCHWBJSSignal_GetValueByKey              = @"getValueByKey";

/// 播放ppt内部MP3
static NSString *const sCHWBJSSignal_OnJsPlay                   = @"isPlayAudio";


#pragma - mark js命令

#define WBJSPubMsg                                              @"pubMsg"
#define WBJSDelMsg                                              @"delMsg"

/// 更新文档服务地址信令
#define WBJSUpdateWebAddressInfo                                @"updateWebAddressInfo"
/// 断开连接
#define WBJSDisconnect                                          @"disconnect"

#define WBJSSetProperty                                         @"setProperty"

/// 交互权限
#define WBJSUpdatePermission                                    @"updatePermission"

/// 是否允许H5播放音视频
#define WBJSSetIsAllowPptPubVideo                               @"setIsAllowPptPubVideo"
#define WBJSSetIsAllowPptPubAudio                               @"setIsAllowPptPubAudio"

/// 视图更新
#define WBJSViewStateUpdate                                     @"viewStateUpdate"
#define WBJSDocumentLoadSuccessOrFailure                        @"documentLoadSuccessOrFailure"
#define WBJSDocumentSlideLoadTimeout                            @"slideLoadTimeout"

/// 刷新Web显示课件
#define WBJSReloadCurrentCourse                                 @"reloadCurrentCourse"

/// 添加页
#define WBJSAddPage                                             @"whiteboardSDK_addPage"
/// 翻页 下一页、上一页、下一步上一步
#define WBJSSlideOrStep                                         @"slideOrStep"
/// 下一页
#define WBJSNextPage                                            @"whiteboardSDK_nextPage"
/// 上一页
#define WBJSPrevPage                                            @"whiteboardSDK_prevPage"
/// 下一步
#define WBJSNextStep                                            @"whiteboardSDK_nextStep"
/// 上一步
#define WBJSPrevStep                                            @"whiteboardSDK_prevStep"


/// enlarge 放大 narrow 缩小 fullScreen 全屏 exitFullScreen 退出全屏
#define WBJSDocResize                                           @"docResize"


#endif /* CHWhiteBoardKitDefines_h */
