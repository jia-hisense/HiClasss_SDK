//
//  HICLiveReplayVC.m
//  HiClass
//
//  Created by hisense on 2020/8/18.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import "HICLiveReplayVC.h"
#import <JHKVideoPlayerSDK/JHKVideoPlayerSDK-Swift.h>
#import <HIClassSwift_SDK/HIClassSwift_SDK.h>
#import "HICStudyLogReportModel.h"
@interface HICLiveReplayVC ()<JHKVideoPlayerOCDelegate>{
    HICSDKVideoPlayer *playerHelper;
}
@property (nonatomic ,strong)JHKVideoPlayer *videoPlayer;
@property (nonatomic ,strong)UIView *playBackView;
@property (nonatomic ,assign)BOOL isHiddenStatus;
@property (nonatomic ,strong)HICStudyLogReportModel *reportModelU;
@property (nonatomic ,strong)HICStudyLogReportModel *reportModelE;
@property (nonatomic ,assign)NSTimeInterval startTime;
@property (nonatomic ,assign)NSTimeInterval totalTime;
@property (nonatomic ,assign)BOOL isStop;
@property (nonatomic ,assign)BOOL isUpdateStartTime;
@property (nonatomic ,assign)BOOL isChange;
@property (nonatomic ,strong)NSTimer *reportTimer;

@end

@implementation HICLiveReplayVC
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    self.isHiddenStatus = YES;
    [self setNeedsStatusBarAppearanceUpdate];
       if (@available(iOS 11.0, *)) {
           [self setNeedsUpdateOfHomeIndicatorAutoHidden];
       }
}
-(BOOL)prefersStatusBarHidden {
    if (self.isHiddenStatus) {
        return YES;
    }
    return NO;
}

- (BOOL)prefersHomeIndicatorAutoHidden {
    if (self.isHiddenStatus) {
        return YES;
    }
    return NO;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = NO;
    self.isHiddenStatus = NO;
       [self setNeedsStatusBarAppearanceUpdate];
          if (@available(iOS 11.0, *)) {
              [self setNeedsUpdateOfHomeIndicatorAutoHidden];
          }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.playBackView = [[UIView alloc]initWithFrame:CGRectMake(0, HIC_NavBarAndStatusBarHeight, HIC_ScreenWidth, HIC_ScreenHeight - HIC_NavBarAndStatusBarHeight)];
    [self.view addSubview:self.playBackView];
    playerHelper = [[HICSDKVideoPlayer alloc]init];
    [self initPlayer];
    self.isStop = NO;
}

- (void)initPlayer {
    self.videoPlayer = [self->playerHelper generateVedioPlayerWithContaninerView:self.playBackView videoArray:_videoArr controller:self type:1];
    [playerHelper setFullScreen];
    self.videoPlayer.ocDelegate = self;
}

- (void)videoPlayerWithVideoPlayer:(JHKVideoPlayer *)videoPlayer didEnterFullScreen:(BOOL)isFull {
    [self setNeedsStatusBarAppearanceUpdate];
    if (@available(iOS 11.0, *)) {
        [self setNeedsUpdateOfHomeIndicatorAutoHidden];
    }
}

- (void)reportPlayEnd {
    [HICLiveReplayVC cancelPreviousPerformRequestsWithTarget:self selector:@selector(reportPlayEnd) object:nil];
    
    if (self.startTime == 0) {
        return;
    }
    self.isUpdateStartTime = NO;
    self.isStop = YES;
    NSTimeInterval deltaTime = [[NSDate date] timeIntervalSince1970] - self.startTime;
    self.startTime = [[NSDate date] timeIntervalSince1970];
    self.reportModelE = [[HICStudyLogReportModel alloc]initWithType:HICPlayBackEnd];
    self.reportModelE.mediaid = _mediaId;
    self.reportModelE.duration = [NSNumber numberWithInteger:deltaTime];
    NSMutableDictionary *reportM = [NSMutableDictionary dictionaryWithDictionary:[self.reportModelE getParamDict]];
    [reportM setValuesForKeysWithDictionary:[LogManager getSerLogEventDictWithType:HICPlayBackEnd]];
    [LogManager reportSerLogWithDict:reportM];
}
- (void)startReportTimer {
    NSTimeInterval reportInteval = [[NSUserDefaults standardUserDefaults] integerForKey:@"reportInteval"];
    if (reportInteval <= 0) {
        reportInteval = 30;
    }
    self.reportTimer.fireDate = [NSDate dateWithTimeIntervalSinceNow:reportInteval];
}

- (void)videoPlayerWithVideoPlayer:(JHKVideoPlayer *)videoPlayer didPrepareToPlay:(NSTimeInterval)totalTime index:(NSInteger)index isAutoPlayed:(BOOL)isAutoPlayed {
    self.startTime = [[NSDate date] timeIntervalSince1970];
    self.totalTime = totalTime;
    self.isUpdateStartTime = YES;
    self.reportModelU = [[HICStudyLogReportModel alloc]initWithType:HICPlayBackUpload];
    self.reportModelU.mediaid = _mediaId;
    NSMutableDictionary *reportM = [NSMutableDictionary dictionaryWithDictionary:[self.reportModelU getParamDict]];
    [reportM setValuesForKeysWithDictionary:[LogManager getSerLogEventDictWithType:HICPlayBackUpload]];
    DDLogDebug(@"回看---起播上报：%@", reportM);
    [LogManager reportSerLogWithDict:reportM];
    [self startReportTimer];
}
- (void)videoPlayerWithVideoPlayer:(JHKVideoPlayer *)videoPlayer didAgainPlay:(NSTimeInterval)totalTime currentTime:(NSTimeInterval)currentTime index:(NSInteger)index{
    self.startTime = [[NSDate date] timeIntervalSince1970];
    self.isStop = NO;
    self.isUpdateStartTime = YES;
    [self startReportTimer];
}

- (void)videoPlayerWithVideoPlayer:(JHKVideoPlayer *)videoPlayer didStoppedPlay:(NSTimeInterval)totalTime playedTime:(NSTimeInterval)playedTime index:(NSInteger)index isAutoPlayed:(BOOL)isAutoPlayed {
    DDLogDebug(@"回看---结束上报");
    [self reportPlayEnd];
    self.reportTimer.fireDate = [NSDate distantFuture];
}
- (void)videoPlayerWithVideoPlayer:(JHKVideoPlayer *)videoPlayer didPauseToPlay:(NSTimeInterval)currentTime totalTime:(NSTimeInterval)totalTime index:(NSInteger)index {
    DDLogDebug(@"回看---暂停上报");
    [self reportPlayEnd];
    self.reportTimer.fireDate = [NSDate distantFuture];
    self.isChange = NO;
}

- (void)videoPlayerWithVideoPlayer:(JHKVideoPlayer *)videoPlayer changePlay:(NSTimeInterval)changeTime totalTime:(NSTimeInterval)totalTime index:(NSInteger)index{
    if(self.isStop){
        return;
    }
    self.isChange = YES;
}
- (void)goBackPageWithVideoPlayer:(JHKVideoPlayer *)videoPlayer{
    if (!self.isStop && self.isChange) {
        DDLogDebug(@"回看---返回上报");
        [self reportPlayEnd];
    }

    [self.videoPlayer enterFullScreenWithFullScreen:false animate:YES];
    [self.navigationController popViewControllerAnimated:NO];
}

- (NSTimer *)reportTimer {
    if (!_reportTimer) {
        NSTimeInterval reportInteval = [[NSUserDefaults standardUserDefaults] integerForKey:@"reportInteval"];
        if (reportInteval <= 0) {
            reportInteval = 30;
        }
        __weak typeof(self) weakSelf = self;
        _reportTimer = [NSTimer scheduledTimerWithTimeInterval:reportInteval target:weakSelf selector:@selector(reportPlayEnd) userInfo:nil repeats:YES];
        _reportTimer.fireDate = [NSDate distantFuture];
    }
    return _reportTimer;
}

@end

