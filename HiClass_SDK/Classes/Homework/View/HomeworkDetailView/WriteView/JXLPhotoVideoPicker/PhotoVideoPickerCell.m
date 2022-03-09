//
//  PhotoVideoPickerCell.m
//  HsShare3.5
//
//  Created by wangggang on 2019/10/26.
//  Copyright © 2019 com.hisense. All rights reserved.
//

#import "PhotoVideoPickerCell.h"

#import "PhotoVideoGetImage.h"

#import <AVKit/AVKit.h>

@interface PhotoVideoPickerCell ()

@property (nonatomic, strong) UIImageView *backImageView;

@property (nonatomic, strong) UIButton *selectBut;

@property (nonatomic, strong) UIImageView *playImageView;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, copy) NSString *videoPatch;

@property (nonatomic, assign) NSInteger second;

@property (nonatomic, assign) CGFloat ratio;

@property (nonatomic, strong) NSURL *videoURL;

@end

@implementation PhotoVideoPickerCell

-(instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self createUI];

    }
    return self;
}


-(void)createUI {
    
    // 背景图
    _backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, phCollectionCellHeight, phCollectionCellHeight)];
    _backImageView.contentMode = UIViewContentModeScaleAspectFill;
    _backImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:_backImageView];
    
    _selectBut = [[UIButton alloc] initWithFrame:CGRectMake(phCollectionCellHeight - 30, 0, 30, 30)];
    [_selectBut setImage:[UIImage imageNamed:@"photo_unpick"] forState:UIControlStateNormal];
    [_selectBut setImage:[UIImage imageNamed:@"photo_picked"] forState:UIControlStateSelected];
    [_selectBut addTarget:self action:@selector(clickSelectBut:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_selectBut];
    
    _playImageView = [[UIImageView alloc] initWithFrame:CGRectMake(phCollectionCellHeight/2-20, phCollectionCellHeight/2-20, 40, 40)];
    _playImageView.image = [UIImage imageNamed:@"ic_video"];
    [self.contentView addSubview:_playImageView];
    
    UIView *timeBackView = [[UIView alloc] initWithFrame:CGRectMake(0, phCollectionCellHeight - 25, phCollectionCellHeight, 25)];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = timeBackView.bounds;
    gradient.colors = [NSArray arrayWithObjects:
                       (id)[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.2].CGColor,
                       (id)[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.4].CGColor,
                       (id)[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.6].CGColor, nil];
    [timeBackView.layer addSublayer:gradient];
    [self.contentView addSubview:timeBackView];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, phCollectionCellHeight - 10, 25)];
    _timeLabel.textAlignment = NSTextAlignmentRight;
    _timeLabel.textColor = [UIColor whiteColor];
    [timeBackView addSubview:_timeLabel];
    
}


-(void)clickSelectBut:(UIButton *)but {
    
    if(!self.videoURL || [self.videoURL.absoluteString isEqualToString:@""]) {
        
        [HICToast showAtDefWithText:NSLocalizableString(@"systemNotSupportedPrompt", nil)];
        
        return;
    }
    
    
    BOOL isSelect = but.selected;
    
    but.selected = !isSelect;
    
    // 通知 前端告知 点击选择视频，再次点击为取消
    self.videoPatch = self.videoURL.absoluteString;
    if (self.clickSelectBut) {
        self.clickSelectBut(!isSelect, self.cellIndexPath, self.videoPatch, self.second, self.ratio);
    }
}

-(void)setIsSelectBut:(BOOL)isSelectBut {
    
    _isSelectBut = isSelectBut;
    
    _selectBut.selected = isSelectBut;
    
}

- (void)setAsset:(PHAsset *)asset {
    _asset = asset;
    self.videoURL = nil;
    self.backImageView.image = nil;
    // 获取图片、 路径、 时间
    PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
    options.version = PHVideoRequestOptionsVersionCurrent;
    options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
    options.networkAccessAllowed = YES;
    
    [[PHImageManager defaultManager] requestAVAssetForVideo:asset options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
        
        if ([asset isKindOfClass:AVURLAsset.class]) {
            AVURLAsset *urlAsset = (AVURLAsset *)asset;
            self.videoURL = urlAsset.URL;
        }
      
        CMTime time = [asset duration];
        
        int seconds = round(CMTimeGetSeconds(time));
        //format of minute
        NSString *str_minute = [NSString stringWithFormat:@"%0.2d",seconds/60];
        //format of second
        NSString *str_second = [NSString stringWithFormat:@"%0.2d",seconds%60];
        //format of time
        NSString *format_time = [NSString stringWithFormat:@"%@:%@",str_minute,str_second];
        
        // 得到高宽比
        NSArray *tracks = [asset tracksWithMediaType:AVMediaTypeVideo];
        CGFloat ratio = 2; // 默认竖屏
        if (tracks.count > 0) {
            AVAssetTrack *track = tracks.firstObject;
            ratio = track.naturalSize.height/track.naturalSize.width;
        }
        
        self.second = seconds;
        self.ratio = ratio;
        dispatch_async(dispatch_get_main_queue(), ^{
            self.timeLabel.text = format_time;
        });
    }];
    
    [[PhotoVideoGetImage new] getPhotoImageWithAsset:asset handel:^(PHAsset * _Nonnull asset, UIImage * _Nonnull image) {
        if (asset == self.asset) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.backImageView.image = image;
            });
        }
    }];
    
    
//    [[PHImageManager defaultManager] requestImageDataForAsset:asset options:option1 resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
//        UIImage *image = [UIImage imageWithData:imageData];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            self.backImageView.image = image;
//        });
//    }];
    
}

// 点击整cell需要播放视频
-(void)clickCellPlayVideo:(UIViewController *)vc {
    
    if (self.videoURL && ![self.videoURL.absoluteString isEqualToString:@""]) {
        AVPlayer *player = [AVPlayer playerWithURL:self.videoURL];
        AVPlayerViewController *playerViewController = [AVPlayerViewController new];
        playerViewController.player = player;
        [vc presentViewController:playerViewController animated:YES completion:nil];
        [playerViewController.player play];
    }else {
        
        DDLogDebug(@"暂时不支持慢视频播放！");
        [HICToast showAtDefWithText:NSLocalizableString(@"systemNotSupportedPrompt", nil)];
    }
    
}
@end
