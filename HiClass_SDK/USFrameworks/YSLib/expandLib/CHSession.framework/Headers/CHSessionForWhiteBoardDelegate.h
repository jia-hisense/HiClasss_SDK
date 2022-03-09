//
//  CHSessionForWhiteBoardDelegate.h
//  CHSession
//
//

#ifndef CHSessionForWhiteBoardDelegate_h
#define CHSessionForWhiteBoardDelegate_h

NS_ASSUME_NONNULL_BEGIN

@protocol CHSessionForWhiteBoardDelegate <CloudHubRtcEngineDelegate>

/// checkRoom获取房间信息
- (void)roomWhiteBoardOnCheckRoom:(NSDictionary *)roomDic cloudHubRtcEngineKit:(CloudHubRtcEngineKit *)cloudHubRtcEngineKit;

/// 获取服务器地址
- (void)roomWhiteBoardOnChangeServerAddrs:(NSDictionary *)serverDic;

/// 设置文件列表
- (void)roomWhiteBoardOnFileList:(nullable NSArray <NSDictionary *> *)fileList;


#if !CHSingle_WhiteBoard
/// 媒体流发布状态
- (void)roomWhiteBoardOnShareMediaFile:(CHSharedMediaFileModel *)mediaFileModel;
/// 更新媒体流的信息
- (void)roomWhiteBoardOnUpdateMediaFileStream:(CHSharedMediaFileModel *)mediaFileModel isSetPos:(BOOL)isSetPos;
/// 远端本地movie
//- (void)roomWhiteBoardOnLocalMovieStreamID:(NSString *)movieStreamID userID:(NSString *)userID isStart:(BOOL)isStart;

#endif

/// 音频播放完毕
- (void)roomWhiteBoardOnRoomAudioFinished:(NSInteger)soundId;



/// 用户属性改变
- (void)roomWhiteBoardOnRoomUserPropertyChanged:(NSString *)userId fromeUserId:(NSString *)fromeUserId properties:(NSDictionary *)properties;

/// 收到自定义发布信令
- (void)roomWhiteBoardOnRoomPubMsgWithMsgID:(NSString *)msgID
                                    msgName:(NSString *)msgName
                                    dataDic:(NSDictionary *)dataDic
                                     fromID:(NSString *)fromID
                              extensionData:(NSDictionary *)extensionData
                                  isHistory:(BOOL)isHistory
                                         ts:(long)ts
                                        seq:(NSInteger)seq;

/// 收到自定义删除信令
- (void)roomWhiteBoardOnRoomDelMsgWithMsgID:(NSString *)msgID
                                    msgName:(NSString *)msgName
                                    dataDic:(NSDictionary *)dataDic
                                     fromID:(NSString *)fromID
                                        seq:(NSInteger)seq;

/// 历史信令处理完毕
- (void)roomWhiteBoardOnRoomHistoryDataReady:(BOOL)isClassBegin;

@end

NS_ASSUME_NONNULL_END

#endif /* CHSessionForWhiteBoardDelegate_h */
