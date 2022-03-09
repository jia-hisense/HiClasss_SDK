//
//  MessageBoardVideoPlayer.h
//  SHChatUI
//
//  Created by wangggang on 2019/10/16.
//  Copyright © 2019 CSH. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface MessageBoardVideoPlayer : UIView

//视频url
@property (copy, nonatomic) NSURL *videoUrl;

//开始播放
- (void)play;
//结束播放
- (void)stop;

@end

NS_ASSUME_NONNULL_END
