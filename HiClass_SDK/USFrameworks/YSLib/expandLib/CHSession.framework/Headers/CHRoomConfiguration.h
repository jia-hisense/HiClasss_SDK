//
//  CHRoomConfiguration.h
//  CHSession
//
//

#import <Foundation/Foundation.h>

#
#pragma mark - CHRoomConfiguration 房间设置的相关配置项
#

NS_ASSUME_NONNULL_BEGIN

@interface CHRoomConfiguration : NSObject

/// 配置项字符串
@property (nonatomic, strong) NSString *configurationString;


/// 课堂结束时自动退出房间 7
@property (nonatomic, assign) BOOL autoQuitClassWhenClassOverFlag;

/// 自动开启音视频 23
@property (nonatomic, assign) BOOL autoOpenAudioAndVideoFlag;

/// 自动上课 32
@property (nonatomic, assign) BOOL autoStartClassFlag;

/// 学生是否有翻页权限 38
@property (nonatomic, assign) BOOL canPageTurningFlag;

/// 课件预加载 102
@property (nonatomic, assign) BOOL preLoadFlag;

/// 课前是否全体禁言 119
@property (nonatomic, assign) BOOL isBeforeClassBanChat;

/// 画笔穿透 131
@property (nonatomic, assign) BOOL isPenCanPenetration;

/// 启动多摄像头 137
@property (nonatomic, assign) BOOL isChairManControl;

/// 护眼模式 141
@property (nonatomic, assign) BOOL isRemindEyeCare;

/// 是否同步镜像视频 148
@property (nonatomic, assign) BOOL isMirrorVideo;

/// 是否多课件 150
@property (nonatomic, assign) BOOL isMultiCourseware;

/// 是否有视频调整 151
@property (nonatomic, assign) BOOL hasVideoAdjustment;

/// 是否允许课前互动 201
@property (nonatomic, assign) BOOL isChatBeforeClass;

/// 是否禁止观众私聊 202
@property (nonatomic, assign) BOOL isDisablePrivateChat;

/// 是否有暖场视频 204
@property (nonatomic, assign) BOOL hasWarmVideo;

- (instancetype)initWithConfigurationString:(NSString *)configurationString;

@end

NS_ASSUME_NONNULL_END
