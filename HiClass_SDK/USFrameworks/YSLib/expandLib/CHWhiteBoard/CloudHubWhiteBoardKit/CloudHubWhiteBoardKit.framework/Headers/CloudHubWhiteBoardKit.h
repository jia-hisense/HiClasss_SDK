//
//  CloudHubWhiteBoardKit.h
//  CloudHubWhiteBoardKit
//
//  Created by jiang deng on 2020/11/3.
//

#import <Foundation/Foundation.h>

#import "CloudHubWhiteBoardDelegate.h"
#import "CloudHubWhiteBoardConfig.h"

#import "CHBrushToolsConfigs.h"

#import "CHFileModel.h"

#import "CHWhiteBoardView.h"

#define CHWhiteBoardConfig [CloudHubWhiteBoardKit sharedInstance].cloudHubWhiteBoardConfig

NS_ASSUME_NONNULL_BEGIN

typedef void(^GetFileListComplete)(NSArray <CHFileModel *> * _Nullable fileList);

@interface CloudHubWhiteBoardKit : NSObject
<
    CHWhiteBoardViewDelegate
>

/// 回调
@property (nonatomic, weak) id <CloudHubWhiteBoardDelegate> delegate;

/// 白板配置
@property (nonatomic, strong, readonly) CloudHubWhiteBoardConfig *cloudHubWhiteBoardConfig;

/// 音视频管理
@property (nonatomic, weak) CloudHubRtcEngineKit *cloudHubRtcEngineKit;

/// 用户Id
@property (nonatomic, strong, readonly) NSString *userId;
/// 用户昵称
@property (nonatomic, strong, readonly) NSString *userNickName;

/// 白板配置项 参照CHWhiteBoardKitWebProtocolKey等
@property (nonatomic, strong, readonly) NSDictionary *serverAddressInfoDic;

#pragma mark - 课件数据相关

/// 课件列表
@property (nullable, nonatomic, strong, readonly) NSMutableArray <CHFileModel *> *fileList;

/// 默认课件Id
@property (nonatomic, strong, readonly) NSString *defaultFileId;

/// 白板窗口列表
@property (nullable, nonatomic, strong, readonly) NSMutableDictionary <NSString *, CHWhiteBoardView *> *whiteBoardList;
/// 默认白板窗口
@property (nonatomic, strong, readonly) CHWhiteBoardView *defaultWhiteBoardView;

/// 白板创建默认尺寸
@property (nonatomic, assign, readonly) CGSize whiteBoardViewDefaultSize;

/// 默认画笔颜色
@property (nonatomic, strong, readonly) NSString *defaultPrimaryColor;


/// 单例
+ (instancetype)sharedInstance;
/// 管理销毁
+ (void)destroy;

/// 服务器log
- (void)serverLog:(NSString *)log;
- (void)eventReportEvent:(NSString *)event description:(NSString *)description isSuccess:(BOOL)isSuccess;
- (void)eventReportEvent:(NSString *)event description:(NSString *)description extra_data:(nullable NSString *)extra_data isSuccess:(BOOL)isSuccess;

/// SDK版本
+ (NSString *)whiteBoardSDKVersion;

/// 初始化白板相关数据
- (void)initializeWhiteBoardWithConfigration:(nullable CloudHubWhiteBoardConfig *)config userId:(nullable NSString *)userId nickName:(nullable NSString *)nickName cloudHubRtcEngineKit:(CloudHubRtcEngineKit *)cloudHubRtcEngineKit;

- (void)initializeWhiteBoardWithConfigration:(nullable CloudHubWhiteBoardConfig *)config host:(NSString *)host port:(NSUInteger)port userId:(nullable NSString *)userId nickName:(nullable NSString *)nickName cloudHubRtcEngineKit:(CloudHubRtcEngineKit *)cloudHubRtcEngineKit;


#pragma mark -
#pragma mark 配置相关

/// 是否同步数据
- (void)setSyncCourse:(BOOL)sync;

/// 设置所有白板背景色
- (void)setWhiteBoardBackgroudColor:(nullable UIColor *)color;
/// 设置whiteBoardId的白板背景色
- (void)setWhiteBoardBackgroudColor:(nullable UIColor *)color withWhiteBoardId:(nullable NSString *)whiteBoardId;
/// 设置所有白板画布背景色
- (void)setCourseViewBackgroudColor:(nullable UIColor *)color;
/// 设置whiteBoardId的白板画布背景色
- (void)setCourseViewBackgroudColor:(nullable UIColor *)color withWhiteBoardId:(nullable NSString *)whiteBoardId;

/// 设置whiteBoardId的白板背景图(层级同画板背景色)
- (void)setWhiteBoardBackImage:(nullable UIImage *)image withWhiteBoardId:(nullable NSString *)whiteBoardId;
/// 白板画布背景图
- (void)setCourseViewBackImage:(nullable UIImage *)image withWhiteBoardId:(nullable NSString *)whiteBoardId;


/// 设置所有画板PDF文件解析度，不主动课件刷新需要在下一次刷新时生效
- (void)setPDFLevel:(NSUInteger)level;

/// 设置所有画板是否有画笔权限
- (void)setCandraw:(BOOL)canDraw;
/// 设置所有画板是否有课件翻页权限
- (void)setCanpage:(BOOL)canPage;

/// 设置所有画板是否只能操作自己的画笔数据(undo redo clear)
- (void)setIsOnlyOperationSelfShape:(BOOL)isOnlyOperationSelfShape;

/// 设置所有画板是否可以点击交互 只对H5及动态ppt课件有效
- (void)setIsPenCanPenetration:(BOOL)isPenCanPenetration;

/// 设置所有画板是否H5播放视频还是回调原生 只对动态ppt课件有效
- (void)setIsAllowPptPubVideo:(BOOL)isAllowPptPubVideo;
/// 设置所有画板是否H5播放音频还是回调原生 只对动态ppt课件有效
- (void)setIsAllowPptPubAudio:(BOOL)isAllowPptPubAudio;

/// 设置所有画板变更H5课件地址参数，此方法会刷新当前H5课件以变更新参数
- (void)changeConnectH5CoursewareUrlParameters:(nullable NSDictionary *)parameters;
/// 设置whiteBoardId的画板变更H5课件地址参数，此方法会刷新当前H5课件以变更新参数
- (void)changeConnectH5CoursewareUrlParameters:(nullable NSDictionary *)parameters withWhiteBoardId:(nullable NSString *)whiteBoardId;

#pragma mark -
#pragma mark 课件列表管理

/// 获取房间课件列表
- (void)getFileListWithRoomId:(NSString *)roomId complete:(GetFileListComplete)complete;

/// 获取课件
- (nullable CHFileModel *)getFileWithFileId:(NSString *)fileId;
/// 删除课件
- (void)deleteFileWithFileId:(NSString *)fileId;

///上传图片课件
- (void)uploadImageFileWithImage:(UIImage *)image success:(void(^)(NSDictionary *imageDict))success failure:(void(^)(NSInteger errorCode))failure;

/// 自定义课件
/// @param fileId 自定义fileid，fileid<0。Note: 为了防止和频道中文档的fileid冲突，规定自定义文件的fileid必须<0的数字
/// @param fileprop 文档属性，0：普通文档 2：动态ppt 3：h5文档
/// @param filetype 文档类型 jpg,txt,pptx……
/// @param filename 文档名称
/// @param pagesAddr 注意地址列表里的链接文档类型要一致 自定义课件文档地址数组，如果课件为动态ppt(或h5文档)，pagesAddr的个数必须为1，并且存放动态ppt或者h5课件的绝对地址。
/// @see customFileDateWithFileId:fileProp:fileType:fileName:pageNum:currentPage:pagesAddr:
- (void)addCustomFileWithFileId:(NSString *)fileId fileProp:(CHWhiteBordFileProp)fileprop fileType:(NSString *)filetype fileName:(NSString *)filename pagesAddr:(NSArray *)pagesAddr;


#pragma mark -
#pragma mark 白板视图

/// 创建白板视图
- (nullable CHWhiteBoardView *)createWhiteBoardViewWithFrame:(CGRect)frame whiteBoardId:(nullable NSString *)whiteBoardId;
- (nullable CHWhiteBoardView *)createWhiteBoardViewWithFrame:(CGRect)frame whiteBoardId:(nullable NSString *)whiteBoardId whiteBoardViewConfig:(nullable CloudHubWhiteBoardViewConfig *)whiteBoardViewConfig;
/// 获取白板视图
- (CHWhiteBoardView *)getWhiteBoardViewWithWhiteBoardId:(nullable NSString *)whiteBoardId;

/// 关闭白板视图
//- (void)closeWhiteBoardViewWithWhiteBoardView:(CHWhiteBoardView *)whiteBoardView;
/// 关闭白板视图
//- (void)closeWhiteBoardViewWithWhiteBoardId:(nullable NSString *)whiteBoardId;

/// 删除白板视图
- (void)removeWhiteBoardView:(CHWhiteBoardView *)whiteBoardView;
- (void)removeWhiteBoardViewWithwhiteBoardId:(nullable NSString *)whiteBoardId;


#pragma mark -
#pragma mark SendSignaling

- (BOOL)pubMsg:(NSString *)msgName
         msgId:(NSString *)msgId
            to:(nullable NSString *)whom
      withData:(nullable NSDictionary *)data
          save:(BOOL)save;

- (BOOL)pubMsg:(NSString *)msgName
        msgId:(NSString *)msgId
           to:(NSString *)whom
     withData:(NSDictionary *)data
extensionData:(NSDictionary *)extensionData
         save:(BOOL)save;

- (BOOL)pubMsg:(NSString *)msgName
         msgId:(NSString *)msgId
            to:(nullable NSString *)whom
      withData:(nullable NSDictionary *)data
associatedWithUser:(nullable NSString *)uid
associatedWithMsg:(nullable NSString *)assMsgID
          save:(BOOL)save;

- (BOOL)pubMsg:(NSString *)msgName
         msgId:(NSString *)msgId
            to:(nullable NSString *)whom
      withData:(nullable NSDictionary *)data
 extensionData:(nullable NSDictionary *)extensionData
associatedWithUser:(nullable NSString *)uid
associatedWithMsg:(nullable NSString *)assMsgID
          save:(BOOL)save;


- (BOOL)delMsg:(NSString *)msgName
         msgId:(NSString *)msgId
            to:(nullable NSString *)whom;

- (BOOL)delMsg:(NSString *)msgName
         msgId:(NSString *)msgId
            to:(nullable NSString *)whom
      withData:(nullable NSDictionary *)data;


#pragma mark -
#pragma mark 课件操作

/// 本地切换课件(不发送信令)
- (void)showLocalCourseWithFileId:(NSString *)fileId onWhiteBoardViewWithWhiteBoardId:(nullable NSString *)whiteBoardId;

/// 切换显示课件
- (void)showCourseWithFileId:(NSString *)fileId onWhiteBoardViewWithWhiteBoardId:(nullable NSString *)whiteBoardId;
- (void)showCourseWithFileId:(NSString *)fileId onWhiteBoardView:(CHWhiteBoardView *)whiteBoardView;

/// 刷新白板课件
- (void)freshCourseWithWhiteBoardId:(nullable NSString *)whiteBoardId;

#pragma mark - 画笔控制

/// 修改默认画笔颜色，请在画笔工具初始化前调用
- (void)changeDefaultPrimaryColor:(NSString *)defaultPrimaryColor;

/// 全体变更所有白板画笔工具，不执行操作工具
- (void)brushToolsChangeToolType:(CHBrushToolType)toolType;
/// 全体变更所有白板画笔图形类型，不执行操作工具
- (void)brushToolsChangeDrawType:(CHDrawType)drawType lineColorHex:(NSString *)colorHex lineWidthScale:(CGFloat)lineWidthScale;

/// 设置白板画笔工具
- (void)brushToolsChangeToolType:(CHBrushToolType)toolType withWhiteBoardId:(nullable NSString *)whiteBoardId;

/// 设置白板画笔图形类型及参数
- (void)brushToolsChangeDrawType:(CHDrawType)drawType lineColorHex:(NSString *)colorHex lineWidthScale:(CGFloat)lineWidthScale withWhiteBoardId:(nullable NSString *)whiteBoardId;


/// 获取当前画笔工具类型
- (CHBrushToolType)getDefaultCurrentBrushToolType;
- (CHBrushToolType)getCurrentBrushToolTypeWithWhiteBoardId:(nullable NSString *)whiteBoardId;

/// 获取默认白板当前工具配置设置 drawType: YSBrushToolType类型  colorHex: RGB颜色  lineWidthScale: 线宽比例值
- (nullable CHBrushToolsConfigs *)getDefaultWhiteBoardCurrentBrushToolConfig;
/// 获取白板当前工具配置设置 drawType: YSBrushToolType类型  colorHex: RGB颜色  lineWidthScale: 线宽比例值
- (nullable CHBrushToolsConfigs *)getCurrentBrushToolConfigWithWhiteBoardId:(nullable NSString *)whiteBoardId;

/// 恢复画笔默认配置
- (void)freshDefaultBrushToolConfigs;
- (void)freshBrushToolConfigsWhiteBoardId:(nullable NSString *)whiteBoardId;

/// 发送UndoRedo状态
- (void)sendUndoRedoStateWhiteBoardId:(nullable NSString *)whiteBoardId;

#pragma mark 翻页

/// 课件 上一页
- (void)whiteBoardPrePageWithWhiteBoardId:(nullable NSString *)whiteBoardId;
/// 课件 下一页
- (void)whiteBoardNextPageWithWhiteBoardId:(nullable NSString *)whiteBoardId;
/// 课件 跳转页
- (void)whiteBoardTurnToPage:(NSUInteger)pageNum withWhiteBoardId:(nullable NSString *)whiteBoardId;

#pragma mark 缩放

/// 白板 放大
- (void)whiteBoardEnlargeWithWhiteBoardId:(nullable NSString *)whiteBoardId;
/// 白板 缩小
- (void)whiteBoardNarrowWithWhiteBoardId:(nullable NSString *)whiteBoardId;
/// 白板 缩放重置
- (void)whiteBoardResetEnlargeWithWhiteBoardId:(nullable NSString *)whiteBoardId;

/// 获取当前窗口缩放比例
- (CGFloat)documentZoomScaleWithWhiteBoardId:(nullable NSString *)whiteBoardId;

@end

NS_ASSUME_NONNULL_END
