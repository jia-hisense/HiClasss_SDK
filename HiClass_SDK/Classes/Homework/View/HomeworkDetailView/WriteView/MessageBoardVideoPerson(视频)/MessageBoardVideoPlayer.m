//
//  MessageBoardVideoPlayer.m
//  SHChatUI
//
//  Created by wangggang on 2019/10/16.
//  Copyright © 2019 CSH. All rights reserved.
//

#import "MessageBoardVideoPlayer.h"

#import <AVFoundation/AVFoundation.h>

@interface MessageBoardVideoPlayer ()

@property (nonatomic, strong) AVPlayer *player;

@end

@implementation MessageBoardVideoPlayer

- (void)dealloc {
    
    [self stop];
}

#pragma mark 播放完成
- (void)playFinished {
    [self.player seekToTime:kCMTimeZero];
    [self.player play];
}

#pragma mark - 公共方法
#pragma mark 开始播放
- (void)play{
    
    //初始化
    self.player = [AVPlayer playerWithPlayerItem:[AVPlayerItem playerItemWithURL:self.videoUrl]];
    if (self.player.rate == 0) {
        [self.player play];
    }
    
    //创建播放器层
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    playerLayer.frame = CGRectMake(0, 0, HIC_ScreenWidth, HIC_ScreenHeight);//self.frame;
    [self.layer addSublayer:playerLayer];
    
    //播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playFinished) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
}

#pragma mark 结束播放
- (void)stop{
    if (self.player.rate == 1) {
        [self.player pause];//如果在播放状态就停止
    }
    self.player = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
