//
//  HMBVoiceRecordPerson.m
//  SHChatUI
//
//  Created by wangggang on 2019/10/15.
//  Copyright © 2019 CSH. All rights reserved.
//

#import "HMBVoiceRecordPerson.h"
#import <AVFoundation/AVFoundation.h>

@interface HMBVoiceRecordPerson ()<AVAudioRecorderDelegate>

@property (nonatomic, strong) AVAudioRecorder *recorder;
//录音文件名字
@property (nonatomic, copy) NSString *voicename;

@end

@implementation HMBVoiceRecordPerson

#pragma mark - 设置代理
- (id)initWithDelegate:(id<HMBVoiceRecordPersonDelegate>)delegate {
    if (self = [super init]) {
        _delegate = delegate;
    }
    return self;
}

#pragma mark - 开始录音
- (void)startRecord{

    // 录音文件名字
    self.voicename = [HICCommonUtils getTimeWithZone];
    //配置录音
    [self setRecorder];
    //开始录音
    [_recorder record];
}

#pragma mark - 停止录音
- (void)stopRecord {
    
    //录制时间
    int recorderTime = (int)roundf(_recorder.currentTime);
    
    //停止录音
    [_recorder stop];
    
    if (recorderTime >= kHMBMinRecordTime) {
        //在规定时长内
        
        //保存资源
        [HICCommonUtils getFileNameWithContent:self.voicename type:HMBMessageFileType_wav];
        
        //发送语音
        if ([_delegate respondsToSelector:@selector(voiceRecordFinishWithVoicename:duration:)]) {
            [_delegate voiceRecordFinishWithVoicename:self.voicename duration:[NSString stringWithFormat:@"%d",recorderTime]];
        }
        
    }else{
        
        //时间太短
        [_recorder deleteRecording];
        if ([_delegate respondsToSelector:@selector(voiceRecordTimeShort)]) {
            [_delegate voiceRecordTimeShort];
        }
        
    }
}

#pragma mark - 取消录音
- (void)cancelRecord {
    [_recorder stop];
    [_recorder deleteRecording];
}

#pragma mark - 录音配置
- (void)setRecorder{
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *setCategoryError = nil;
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&setCategoryError];
    
    
    NSDictionary *settingsDict = [HICCommonUtils getAudioRecorderSettingDict];
    NSURL *url = [NSURL fileURLWithPath:[HICCommonUtils getFilePathWithName:self.voicename type:HMBMessageFileType_wav]];

    _recorder = nil;
    _recorder =  [[AVAudioRecorder alloc] initWithURL:url settings:settingsDict error:nil];
    _recorder.delegate = self;
    
    //开启声波检测
    _recorder.meteringEnabled = YES;

    [_recorder prepareToRecord];
}

#pragma mark - 声音检测
- (int)peekRecorderVoiceMetersWithMax:(int)max {
    [_recorder updateMeters];
   
    float peakPower = pow(10, (0.05 * [_recorder peakPowerForChannel:0]));
    
    if (peakPower > 0.6) {
        peakPower = 0.6;
    }
    
    int power = max*peakPower/0.6;
    
    return power;
}


@end
