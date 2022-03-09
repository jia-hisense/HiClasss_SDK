//
//  HMBVoiceRecordPerson.h
//  SHChatUI
//
//  Created by wangggang on 2019/10/15.
//  Copyright © 2019 CSH. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HMBVoiceRecordPersonDelegate <NSObject>

@optional
/**
 *  结束录音
 *
 *  @param voiceName    录音文件名字
 *  @param duration     音频长度
 */
- (void)voiceRecordFinishWithVoicename:(NSString *)voiceName duration:(NSString *)duration;

/**
 *  没在规定时间内
 */
- (void)voiceRecordTimeShort;

@end

@interface HMBVoiceRecordPerson : NSObject

//代理
@property (nonatomic, weak) id<HMBVoiceRecordPersonDelegate> delegate;

//出售啊
- (id)initWithDelegate:(id<HMBVoiceRecordPersonDelegate>)delegate;

//开始录音
- (void)startRecord;

//停止录音
- (void)stopRecord;

//取消录音
- (void)cancelRecord;

//声音检测
- (int)peekRecorderVoiceMetersWithMax:(int)max;


@end

NS_ASSUME_NONNULL_END
