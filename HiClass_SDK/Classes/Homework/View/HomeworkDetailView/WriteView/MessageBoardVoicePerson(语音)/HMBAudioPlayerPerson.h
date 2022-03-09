//
//  HMBAudioPlayerPerson.h
//  SHChatUI
//
//  Created by wangggang on 2019/10/15.
//  Copyright © 2019 CSH. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HMBAudioPlayerPersonDelegate <NSObject>

@optional
//开始播放
- (void)didAudioPlayerBeginPlay:(NSString *)playMark;
//结束播放
- (void)didAudioPlayerStopPlay:(NSString *)playMark error:(NSString *)error;
//暂停播放
- (void)didAudioPlayerPausePlay:(NSString *)playMark;

@end

@interface HMBAudioPlayerPerson : NSObject

//播放代理
@property (nonatomic, strong) id <HMBAudioPlayerPersonDelegate> delegate;
//当前播放的标示
@property (nonatomic, copy, nullable) NSString *playMark;

/**
 *  实例化
 */
+ (id)shareInstance;

/**
 *  播放语音
 *
 *  @param fileArr 语音数组
 *  @param isClear 是否清除之前的播放列表
 */
- (void)managerAudioWithFileArr:(NSArray *)fileArr isClear:(BOOL)isClear;

/**
 *  前后台控制
 *
 *  @param isBackground 是否是后台
 */
- (void)backgroundPlayAudio:(BOOL)isBackground;

//暂停播放
- (void)pauseAudio;
//停止播放
- (void)stopAudio;
//开始播放
- (void)preparePlayAudio;

//是否正在播放
- (BOOL)isPlaying;

//销毁音频
- (void)deallocAudio;

@end

NS_ASSUME_NONNULL_END
