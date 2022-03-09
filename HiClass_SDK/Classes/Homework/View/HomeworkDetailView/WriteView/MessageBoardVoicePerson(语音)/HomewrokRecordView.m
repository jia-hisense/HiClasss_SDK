//
//  HomewrokRecordView.m
//  HiClass
//
//  Created by 铁柱， on 2020/3/27.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HomewrokRecordView.h"

#import "HMBVoiceRecordPerson.h"
#import "HMBAudioPlayerPerson.h"
#import <AVFoundation/AVFoundation.h>

#import "RecordAnimationView.h"

@interface HomewrokRecordView()<HMBVoiceRecordPersonDelegate, CAAnimationDelegate, HMBAudioPlayerPersonDelegate>

@property (nonatomic, strong) HMBVoiceRecordPerson *voiceRecord;

@property (nonatomic, strong) UIView *recordBackView; // 整体的背景
@property (nonatomic, strong) UIButton *recordBut;
@property (nonatomic, strong) UIView *voiceBackView; // 底部录音按钮的背景
@property (nonatomic, strong) UILabel *tipLabel;

@property (nonatomic, strong) NSTimer *playTimer;
@property (nonatomic, assign) NSInteger playTime;

@property (nonatomic, strong) HMBAudioPlayerPerson *audio;
@property (nonatomic, copy) NSString *audioUrlStr;
@property (nonatomic, copy) NSString *audioNameStr;

//进度
@property (nonatomic, strong) CAShapeLayer *progressLayer;
@property (nonatomic, strong) RecordAnimationView *recordView;
@property (nonatomic, strong) UIButton *voicePlayBut; // 语音预览按钮
@property (nonatomic, strong) UIImageView *voiceImages; // 语音播放动画图片
@property (nonatomic, strong) UILabel *voiceTimeLabel; // 语音时间label

@end

@implementation HomewrokRecordView

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createView];
        [self reloadView];
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        _maxSeconds = 60; // 默认设置 60s
        _audio = [HMBAudioPlayerPerson shareInstance];
        [_audio setDelegate:self];
    }
    return self;
}

-(void)createView {

    UIView *phoneX = [[UIView alloc] initWithFrame:CGRectMake(0, HIC_ScreenHeight-HIC_BottomHeight, HIC_ScreenWidth, HIC_BottomHeight)];
    phoneX.backgroundColor = UIColor.whiteColor;
    [self addSubview:phoneX];

    _recordBackView = [[UIView alloc] initWithFrame:CGRectMake(0, HIC_ScreenHeight-274-HIC_BottomHeight, HIC_ScreenWidth, 274)];
    _recordBackView.backgroundColor = UIColor.whiteColor;

    UIButton *closeBut = [[UIButton alloc] initWithFrame:CGRectMake(16, 12, 100, 27.5)];
    [closeBut setTitle:NSLocalizableString(@"shutDown", nil) forState:UIControlStateNormal];
    closeBut.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [closeBut setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    [closeBut addTarget:self action:@selector(clickCloseBut:) forControlEvents:UIControlEventTouchUpInside];

    UIButton *updateBut = [[UIButton alloc] initWithFrame:CGRectMake(HIC_ScreenWidth-16-150, 12, 150, 27.5)];
    updateBut.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [updateBut setTitle:NSLocalizableString(@"upload", nil) forState:UIControlStateNormal];
    [updateBut setTitleColor:[UIColor colorWithHexString:@"#03b3cc"] forState:UIControlStateNormal];
    [updateBut addTarget:self action:@selector(clickUpdateBut:) forControlEvents:UIControlEventTouchUpInside];

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16+40+16, 13.5, HIC_ScreenWidth-(16+40+16)*2, 24)];
    titleLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    titleLabel.font = FONT_MEDIUM_17;
    titleLabel.text = NSLocalizableString(@"audioRecording", nil);
    titleLabel.textAlignment = NSTextAlignmentCenter;

    [_recordBackView addSubview:closeBut];
    [_recordBackView addSubview:updateBut];
    [_recordBackView addSubview:titleLabel];

    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, HIC_ScreenWidth, 274-50)];
    [backView setBackgroundColor:[UIColor colorWithHexString:@"#f8f8f8"]];
    self.voiceBackView = backView;

    UIButton *recordBut = [[UIButton alloc] initWithFrame:CGRectMake((HIC_ScreenWidth-80)/2, 93, 80, 80)];
    [recordBut setBackgroundImage:[UIImage imageNamed:@"录音按钮"] forState:UIControlStateNormal];
    [recordBut setBackgroundImage:[UIImage imageNamed:@"录音按下"] forState:UIControlStateHighlighted];
    [recordBut addTarget:self action:@selector(startBut:) forControlEvents:UIControlEventTouchDown];
    [recordBut addTarget:self action:@selector(endBut:) forControlEvents:UIControlEventTouchUpInside];
    [recordBut addTarget:self action:@selector(cancelRecordVoice:) forControlEvents:UIControlEventTouchUpOutside | UIControlEventTouchCancel];
    [recordBut addTarget:self action:@selector(remindDragExit:) forControlEvents:UIControlEventTouchDragExit];
    self.recordBut = recordBut;

    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, backView.height-16-21, HIC_ScreenWidth-32, 21)];
    tipLabel.textColor = [UIColor colorWithHexString:@"#858585"];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.font = FONT_REGULAR_15;
    tipLabel.text = NSLocalizableString(@"holdTape", nil);
    self.tipLabel = tipLabel;

    [backView addSubview:recordBut];
    [backView addSubview:tipLabel];

    [_recordBackView addSubview:backView];
    [self addSubview:_recordBackView];

    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect: _recordBackView.bounds byRoundingCorners:UIRectCornerTopRight|UIRectCornerTopLeft cornerRadii:CGSizeMake(10,10)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = _recordBackView.bounds;
    maskLayer.path = maskPath.CGPath;
    _recordBackView.layer.mask = maskLayer;

    // 创建预览but
    _voicePlayBut = [[UIButton alloc] initWithFrame:CGRectMake((HIC_ScreenWidth-200)/2.0, 27, 200, 48.5)];
    [_voicePlayBut setBackgroundImage:[UIImage imageNamed:@"语音条"] forState:UIControlStateNormal];
    UIImageView *voiceImages = [[UIImageView alloc] initWithFrame:CGRectMake(16, 12.5, 12, 17)];
    voiceImages.animationImages = @[ [UIImage imageNamed:@"音量-动1"], [UIImage imageNamed:@"音量-动2"],[UIImage imageNamed:@"音量-动3"],[UIImage imageNamed:@"音量-动4"], [UIImage imageNamed:@"音量-动3"],  [UIImage imageNamed:@"音量-动2"], [UIImage imageNamed:@"音量-动1"]];
    voiceImages.image = [UIImage imageNamed:@"音量"];
    self.voiceImages = voiceImages;
    [self.voiceImages setAnimationDuration:2];
    UILabel *voiceTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(34, 10, 200-34-10, 22.5)];
    voiceTimeLabel.textColor = [UIColor whiteColor];
    voiceTimeLabel.font = FONT_MEDIUM_16;
    self.voiceTimeLabel = voiceTimeLabel;
    [_voicePlayBut addSubview:voiceImages];
    [_voicePlayBut addSubview:voiceTimeLabel];
    [_voicePlayBut addTarget:self action:@selector(clickPlayVoice:) forControlEvents:UIControlEventTouchUpInside];
    _voicePlayBut.hidden = YES;

    [_voiceBackView addSubview:_voicePlayBut];
}

-(void)reloadView {
    self.voiceRecord = [[HMBVoiceRecordPerson alloc] initWithDelegate:self];
}

#pragma mark - 页面事件
-(void)startBut:(UIButton *)but {
    [self.audio stopAudio];
    _voicePlayBut.hidden = YES;
    //检查权限
    [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {

        if (granted) {//获取权限

            //开始录音
            [self.voiceRecord startRecord];

            if (self.playTimer) {
                [self.playTimer invalidate];
                self.playTimer = nil;
            }
            self.playTime = 0;
            self.playTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(countVoiceTest) userInfo:nil repeats:YES];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self voiceAnimation];
                self.tipLabel.text = NSLocalizableString(@"loosenEnd", nil);
                [self.voiceBackView addSubview:self.recordView];
            });
            
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [HICToast showAtDefWithText:NSLocalizableString(@"noRecordingPermission", nil)];
            });
            
        }
    }];
}

-(void)endBut:(UIButton *)but {

    [self.voiceRecord stopRecord];

    if (self.playTimer) {
        [self.playTimer invalidate];
        self.playTimer = nil;
        self.playTime = 0;
    }
    [self.progressLayer removeFromSuperlayer];
    self.tipLabel.text = NSLocalizableString(@"pressRerrecord", nil);
    [self.recordView removeFromSuperview];
}
-(void)cancelRecordVoice:(UIButton *)but {

    [self.voiceRecord cancelRecord];

    if (self.playTimer) {
        [self.voiceRecord cancelRecord];

        [self.playTimer invalidate];
        self.playTimer = nil;
        self.playTime = 0;
    }
    [self.progressLayer removeFromSuperlayer];
    self.tipLabel.text = NSLocalizableString(@"pressRerrecord", nil);
    [self.recordView removeFromSuperview];
}
-(void)remindDragExit:(UIButton *)but {
    DDLogDebug(@"========EXIT=========");
}

-(void)clickPlayVoice:(UIButton *)but {
    if (self.audioNameStr) {
        [self.audio managerAudioWithFileArr:@[self.audioNameStr] isClear:YES];
        [self.voiceImages startAnimating];
    }
}

-(void)clickCloseBut:(UIButton *)but {

    [self hiddenView];
}
-(void)clickUpdateBut:(UIButton *)but {
    if ([NSString isValidStr:self.audioNameStr]) {
        if ([self.delegate respondsToSelector:@selector(recordView:sendVoiceName:voicePath:other:)]) {
            [self.delegate recordView:self sendVoiceName:self.audioNameStr voicePath:self.audioUrlStr other:nil];
        }
        [self hiddenView];
    }else {
        [HICToast showWithText:NSLocalizableString(@"uploadAfterRecording", nil)];
    }

}

-(void)hiddenView {
    if (self.audio.isPlaying) {
        [self.audio stopAudio];
    }
    [self removeFromSuperview];
}

#pragma mark - 页面动画
-(void)voiceAnimation {
    CABasicAnimation *animation = [[CABasicAnimation alloc]init];
    animation.keyPath = @"strokeEnd";
    animation.fromValue = @(0);
    animation.toValue = @(1);
    animation.duration = self.maxSeconds;
    animation.delegate = self;

    CGFloat width = 90;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake((HIC_ScreenWidth-90)/2, 88, width, width) cornerRadius:width/2];
    self.progressLayer.path = path.CGPath;
    [self.progressLayer addAnimation:animation forKey:nil];
    [self.voiceBackView.layer addSublayer:self.progressLayer];
}

#pragma mark 声音检测和最大时间检测
- (void)countVoiceTest {

    self.playTime += 0.05;


    if (self.playTime >= kHMBMaxRecordTime) {//超过最大时间停止

        self.playTime = 0;
        [self.playTimer invalidate];

    }

}
#pragma mark - HMBVoiceRecordPersonDelegate
- (void)voiceRecordFinishWithVoicename:(NSString *)voiceName duration:(NSString *)duration{

    //发送语音
    _voicePlayBut.hidden = NO;
    self.voiceTimeLabel.text = [NSString stringWithFormat:@"%@''",duration];
    DDLogDebug(@"--- %@  -- %@", voiceName, duration);
    self.audioNameStr = voiceName;
    NSString *path = [HICCommonUtils getFilePathWithName:voiceName type:HMBMessageFileType_wav];
    self.audioUrlStr = path;

}

#pragma mark - 播放录音的回调方法
-(void)didAudioPlayerBeginPlay:(NSString *)playMark {
    // 开始播放l语音的回调
}
- (void)didAudioPlayerStopPlay:(NSString *)playMark error:(NSString *)error {
    // 播放结束
    [self.voiceImages stopAnimating];
}

#pragma mark - 结束动画回调
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{

    [self.voiceRecord stopRecord];

    if (self.playTimer) {
        [self.playTimer invalidate];
        self.playTimer = nil;
        self.playTime = 0;
    }
    [self.progressLayer removeFromSuperlayer];
    self.tipLabel.text = NSLocalizableString(@"pressRerrecord", nil);
    [self.recordView removeFromSuperview];
}

#pragma mark - 懒加载
-(CAShapeLayer *)progressLayer {
    if (!_progressLayer) {
       _progressLayer = [CAShapeLayer layer];
       _progressLayer.strokeColor = [UIColor colorWithHexString:@"#03b3cc"].CGColor;
       _progressLayer.fillColor = [UIColor clearColor].CGColor;
       _progressLayer.lineWidth = 3;
    }
    return _progressLayer;
}

-(RecordAnimationView *)recordView {
    if (!_recordView) {
        _recordView = [[RecordAnimationView alloc] initWithFrame:CGRectMake((HIC_ScreenWidth-84)/2.0, 34, 84, 24)];
    }
    return _recordView;
}

@end
