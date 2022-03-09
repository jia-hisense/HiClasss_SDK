//
//  HomeworkImagePreviewCell.m
//  HiClass
//
//  Created by 铁柱， on 2020/4/1.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HomeworkImagePreviewCell.h"

#import "MessageBoardVideoPlayer.h"

@interface HomeworkImagePreviewCell ()

@property (nonatomic, strong) UIImageView *backImageView;

@property (nonatomic, strong) MessageBoardVideoPlayer *videoPlayer;

@end

@implementation HomeworkImagePreviewCell

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createView];
    }
    return self;
}

-(void)createView {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    [self.contentView addSubview:imageView];
    self.backImageView = imageView;
    imageView.contentMode = UIViewContentModeScaleAspectFit;

    MessageBoardVideoPlayer *player = [[MessageBoardVideoPlayer alloc] initWithFrame:self.bounds];
    [self.contentView addSubview:player];
    player.hidden = YES;
    self.videoPlayer = player;
}

-(void)setImageModel:(HomeworkImageModel *)imageModel {
    _imageModel = imageModel;

    self.videoPlayer.hidden = YES;
//    self.backImageView.hidden = YES;
    if (imageModel.isAgainWrite) {
        if (imageModel.againFileType == HICHomeworkAgainFileType_image) {
            if (imageModel.attachmentModel.url) {
                [self.backImageView sd_setImageWithURL:[NSURL URLWithString:imageModel.attachmentModel.url]];
            }
        }else if (imageModel.againFileType == HICHomeworkAgainFileType_video) {
            self.backImageView.image = [UIImage imageNamed:@"知识类型-视频"];
//            if (imageModel.attachmentModel.url) {
//                self.videoPlayer.hidden = NO;
//                self.videoPlayer.videoUrl = [NSURL URLWithString:imageModel.attachmentModel.url];
//            }
        }else if (imageModel.againFileType == HICHomeworkAgainFileType_voic) {
            self.backImageView.image = [UIImage imageNamed:@"知识类型-音频"];
        }
    }else {
        if (imageModel.type == HMBMessageFileType_image) {
            self.backImageView.image = imageModel.image;
        }else if (imageModel.type == HMBMessageFileType_video) {
//            self.videoPlayer.hidden = NO;
//            self.videoPlayer.videoUrl = [NSURL fileURLWithPath:imageModel.filePath];
            self.backImageView.image = [UIImage imageNamed:@"知识类型-视频"];
        }else if (imageModel.type == HMBMessageFileType_wav || imageModel.type == HMBMessageFileType_amr) {
            self.backImageView.image = [UIImage imageNamed:@"知识类型-音频"];
        }
    }
}

-(void)setAttModel:(HomeworkDetailAttachmentModel *)attModel {
    _attModel = attModel;

    self.videoPlayer.hidden = YES;
//    self.backImageView.hidden = YES;
    if (attModel.type == 4) {
        if (attModel.url) {
            self.backImageView.hidden = NO;
            [self.backImageView sd_setImageWithURL:[NSURL URLWithString:attModel.url]];
        }
    }else if (attModel.type == 1) {
//        if (attModel.url) {
//            self.videoPlayer.hidden = NO;
//            self.videoPlayer.videoUrl = [NSURL URLWithString:attModel.url];
//            [self.videoPlayer play];
//        } - 后续添加 视频和音频的播放
        self.backImageView.image = [UIImage imageNamed:@"知识类型-视频"];
    }else if (attModel.type == 2) {
        self.backImageView.image = [UIImage imageNamed:@"知识类型-音频"];
    }
}

-(void)setImagePath:(NSString *)imagePath {
    _imagePath = imagePath;
    self.videoPlayer.hidden = YES;
    if ([NSString isValidStr:imagePath]) {
        if ([imagePath containsString:@"http"]) {
            [self.backImageView sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:[UIImage imageNamed:@"证书默认图"]];
        } else {
            NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
            imagePath = [NSString stringWithFormat:@"%@/%@", caches, imagePath];
            [self.backImageView sd_setImageWithURL:[NSURL fileURLWithPath:imagePath]];
        }
    }
}

- (void)setImageName:(NSString *)imageName {
    if ([NSString isValidStr:imageName]) {
        self.backImageView.image = [UIImage imageNamed:imageName];
    }
}

@end
