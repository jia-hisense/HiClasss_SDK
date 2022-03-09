//
//  CameraView.m
//  HsShare3.5
//
//  Created by 尚轩瑕 on 2017/12/7.
//  Copyright © 2017年 com.hisense. All rights reserved.
//

#import "CameraView.h"
#import "Camera.h"
#import "GradientView.h"

#define GradientColorStart [UIColor colorWithRed:0xec/255.0 green:0x09/255.0 blue:0x28/255.0 alpha:0]//扫描条渐变色起始点颜色
#define GradientColorCenter [UIColor colorWithRed:0xec/255.0 green:0x09/255.0 blue:0x28/255.0 alpha:1]//扫描条渐变色中间点颜色
#define GradientColorEnd [UIColor colorWithRed:0xec/255.0 green:0x09/255.0 blue:0x28/255.0 alpha:0]//扫描条渐变色结束点颜色

CGFloat const scanFrameWith = 440.0;//二维码扫描框的宽度和长度

CGFloat const scanFrameTopMargin = 248.0;//二维码扫描框距离顶部导航栏距离

CGFloat const instructionTopMargin = 32.0;//说明文字上部距离扫描框距离

CGFloat const instructionHeight = 30.0;//说明文字高度

CGFloat const flashButtonWith = 64.0;//闪光灯按钮宽度和高度

CGFloat const flashButtonTopMargin = 96.0;//闪光灯按钮距离上部说明文字距离

CGFloat const flashButtonInstructionTopMargin = 16.0;//闪光灯说明文字距离上部闪光灯按钮距离

CGFloat const scanLineHeight = 8.0;//扫描条高度

NSTimeInterval const gradientLineTimeInterval = 0.005;//扫描条运动速度

//#define  statusBarHeight   ([GlobalUtils isPad]? 40.0:20.0)
//#define  navigationBarHeight ([GlobalUtils isPad]? 88.0:44.0)

@interface CameraView ()<CameraScanPhotoSuccessDelegate>

@property (strong, nonatomic) Camera *camera;

/**
 中间二维码扫描框
 */
@property (strong, nonatomic) UIImageView *scanFrame;

@property (strong, nonatomic) UIButton *flashButton;

/**
 闪光灯开
 */
@property (assign, nonatomic) BOOL isFlashOpen;

@property (strong, nonatomic) UILabel *flashLabel;

/**
 扫描条运动timer
 */
@property (strong, nonatomic) NSTimer *gradientLineTimer;

@end

@implementation CameraView

#pragma mark - 初始化
- (CameraView *)init {
    self = [super init];
    if (self) {

        self.frame = CGRectMake(0, kStatusBarHeight+kNavBarHeight, HIC_ScreenWidth, kScreenHeight-(kStatusBarHeight+kNavBarHeight));
        [self initCameraModel];
        [self addScanFrame];
        //此时，设置扫描区域为扫描框所在位置
        CGFloat scanFrameX = self.scanFrame.frame.origin.x;
        CGFloat scanFrameY = self.scanFrame.frame.origin.y;

        CGFloat scanFrameW = self.scanFrame.frame.size.width;
        CGFloat scanFrameH = self.scanFrame.frame.size.height;
        //设置扫描范围：rectOfInterest的坐标为(y,x,height,width)，具体可参考https://juejin.im/entry/57cd38665bbb500074f9abb6，因此需要把原来的frame的x和y 以及height和width交换位置
        self.camera.rectOfInterst = CGRectMake((scanFrameY+(kStatusBarHeight+kNavBarHeight))/kScreenHeight, scanFrameX/HIC_ScreenWidth, scanFrameH/kScreenHeight, scanFrameW/HIC_ScreenWidth);
        //添加蒙版
        float x = self.scanFrame.frame.origin.x;//扫描框原点x坐标
        float y = self.scanFrame.frame.origin.y;//扫描框原点y坐标
        float w = self.scanFrame.frame.size.width;
        float h = self.scanFrame.frame.size.height;
        
        [self addMaskWithRect:CGRectMake(0, 0, HIC_ScreenWidth, y)];//扫描框上方蒙版
        [self addMaskWithRect:CGRectMake(0, y, x, (self.frame.size.height-y))];//扫描框左边蒙版，高度是到屏幕下沿
        [self addMaskWithRect:CGRectMake(x+w, y, HIC_ScreenWidth-(x+w), (self.frame.size.height-y))];//扫描框右边蒙版，高度是道屏幕下沿
        [self addMaskWithRect:CGRectMake(x, y+h, w, (self.frame.size.height-y-h))];//扫描框正下方蒙版

        [self addScanRoundLine]; // 增加四角图片

        //添加说明文字
        UILabel *instructionLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, (y+h+instructionTopMargin*HIC_Divisor), w, instructionHeight*HIC_Divisor)];
        instructionLabel.textColor = UIColor.whiteColor;
        instructionLabel.textAlignment = NSTextAlignmentCenter;
        instructionLabel.adjustsFontSizeToFitWidth = YES;
        instructionLabel.text = NSLocalizableString(@"scanPrompt", nil);
        instructionLabel.font=[UIFont systemFontOfSize:14];
        [self addSubview:instructionLabel];
        
        //闪光灯按钮
        self.flashButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.flashButton.frame = CGRectMake((HIC_ScreenWidth-flashButtonWith*HIC_Divisor)/2.0, instructionLabel.frame.origin.y+instructionLabel.frame.size.height+flashButtonTopMargin*HIC_Divisor, flashButtonWith*HIC_Divisor, flashButtonWith*HIC_Divisor);
        [self.flashButton setImage:[UIImage imageNamed:@"扫描页 关灯"] forState:UIControlStateNormal];
        //[self.flashButton setImage:[UIImage imageNamed:@"扫描页 开灯"] forState:UIControlStateHighlight];
        [self.flashButton addTarget:self action:@selector(flashButtonTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:self.flashButton];
        
        self.isFlashOpen = NO;
        
        //闪光灯下方说明文字
        self.flashLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, (self.flashButton.frame.origin.y+self.flashButton.frame.size.height+flashButtonInstructionTopMargin*HIC_Divisor), w, instructionHeight*HIC_Divisor)];
        self.flashLabel.textColor = UIColor.whiteColor;
        self.flashLabel.textAlignment = NSTextAlignmentCenter;
        self.flashLabel.text = NSLocalizableString(@"clickToTurnOnFlash", nil);
        self.flashLabel.font=[UIFont systemFontOfSize:14];
//        [self addSubview:self.flashLabel];
        
        if([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0)  {
            //添加扫描横条
            /*
            GradientView *gradientLine = [[GradientView alloc] initWithFrame:CGRectMake(scanFrameX, scanFrameY, scanFrameW, scanLineHeight*HIC_Divisor)];
            gradientLine.gradientLayerColors = @[(__bridge id)GradientColorStart.CGColor, (__bridge id)GradientColorCenter.CGColor, (__bridge id)GradientColorEnd.CGColor];
            [self addSubview:gradientLine];*/

            GradientView *gradientLine = [[GradientView alloc] initWithImage:[UIImage imageNamed:@"扫描"] andFrame:CGRectMake(scanFrameX, scanFrameY, scanFrameW, scanLineHeight*HIC_Divisor)];
            gradientLine.gradientLayerColors = @[(__bridge id)GradientColorStart.CGColor, (__bridge id)GradientColorCenter.CGColor, (__bridge id)GradientColorEnd.CGColor];
            [self addSubview:gradientLine];

            CGFloat gradientLineX = gradientLine.frame.origin.x;
            CGFloat gradientLineY = gradientLine.frame.origin.y;
            CGFloat gradientLineW = gradientLine.frame.size.width;
            CGFloat gradientLineH = gradientLine.frame.size.height;

            __block CGFloat heightInterval = 0;

            self.gradientLineTimer = [NSTimer scheduledTimerWithTimeInterval:gradientLineTimeInterval repeats:YES block:^(NSTimer * _Nonnull timer) {
                heightInterval += 0.5;
                if (heightInterval > scanFrameH) {
                    heightInterval = 0;
                }
            dispatch_async(dispatch_get_main_queue(), ^{
                gradientLine.frame = CGRectMake(gradientLineX, gradientLineY+heightInterval, gradientLineW, gradientLineH);
            });
            }];
        }
        
    }
    return self;
}

- (void)initCameraModel {
    self.camera = [[Camera alloc] init];
    self.camera.cameraframe = CGRectMake(0, -(kStatusBarHeight+kNavBarHeight), HIC_ScreenWidth, kScreenHeight);
    
    self.camera.cameraScanPhotoSuccessDelete = self;
    [self.layer insertSublayer:self.camera.preview atIndex:0];
}

/**
 添加扫描框
 */
- (void)addScanFrame {
    // 原始固定 四边扫描框
    self.scanFrame = [[UIImageView alloc] initWithFrame:CGRectMake((HIC_ScreenWidth-scanFrameWith*HIC_Divisor)/2.0, scanFrameTopMargin*HIC_Divisor, scanFrameWith*HIC_Divisor, scanFrameWith*HIC_Divisor)];
    self.scanFrame.backgroundColor = [UIColor clearColor];
    [self addSubview:self.scanFrame];


}

-(void)addScanRoundLine {
    // 分别四框
    UIImageView *topLeft = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"扫一扫-左上"]];
    topLeft.frame = CGRectMake(self.scanFrame.frame.origin.x-8, self.scanFrame.frame.origin.y-8, 16, 16);

    UIImageView *topRight = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"扫一扫-右上"]];
    topRight.frame = CGRectMake(self.scanFrame.frame.origin.x+self.scanFrame.bounds.size.width-8, self.scanFrame.frame.origin.y-8, 16, 16);

    UIImageView *bottomLeft = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"扫一扫-左下"]];
    bottomLeft.frame = CGRectMake(self.scanFrame.frame.origin.x-8, self.scanFrame.frame.origin.y+self.scanFrame.bounds.size.height-8, 16, 16);

    UIImageView *bottomRight = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"扫一扫-右下"]];
    bottomRight.frame = CGRectMake(self.scanFrame.frame.origin.x+self.scanFrame.bounds.size.width-8, self.scanFrame.frame.origin.y+self.scanFrame.bounds.size.height-8, 16, 16);

    [self addSubview:topLeft];
    [self addSubview:topRight];
    [self addSubview:bottomLeft];
    [self addSubview:bottomRight];
}

/**
 添加模糊效果：蒙版

 @param rect 蒙版尺寸
 */
- (void)addMaskWithRect:(CGRect)rect {
    UIView *maskView = [[UIView alloc] initWithFrame:rect];
    maskView.backgroundColor = [UIColor colorWithRed:0x00/255.0 green:0x00/255.0 blue:0x00/255.0 alpha:0.6]; //蒙版背景颜色
    [self addSubview:maskView];
}

- (void)flashButtonTouchUpInside {
    if (self.isFlashOpen) {//如果闪光灯已开启，就关闭
        [self.flashButton setImage:[UIImage imageNamed:@"扫描页 关灯"] forState:UIControlStateNormal];
        self.flashLabel.hidden = NO;
        self.camera.cameraFlashStatus = CameraFlashStatusOff;
    } else {//如果闪光灯未开启，就开启闪光灯
        [self.flashButton setImage:[UIImage imageNamed:@"扫描页 开灯"] forState:UIControlStateNormal];
        self.flashLabel.hidden = YES;
        self.camera.cameraFlashStatus = CameraFlashStatusOn;
    }
    self.isFlashOpen = !self.isFlashOpen;
}

#pragma mark - 二维码扫描

/**
 开始扫描二维码
 */
- (void)startQRCodeScan {
	// TODO: 加启动动画
    [self.camera startCameraRunning];
    [self.gradientLineTimer fire];//开启扫描条定时器
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        [self.camera startCameraRunning];
//        [self.gradientLineTimer fire];//开启扫描条定时器
//    });
}


/**
 停止扫描二维码
 */
- (void)stopQRCodeScan {
	// TODO: 加启动动画
    [self.camera stopCameraRunning];
    self.camera.cameraFlashStatus = CameraFlashStatusOff;
    [self.gradientLineTimer setFireDate:[NSDate distantFuture]];//暂停定时器
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        [self.camera stopCameraRunning];
//        self.camera.cameraFlashStatus = CameraFlashStatusOff;
//        [self.gradientLineTimer setFireDate:[NSDate distantFuture]];//暂停定时器
//    });
}

#pragma mark - 摄像头扫描到二维码信息

- (void)camerScanPhotoInfo:(NSString *)photoInfo {
    [self.gradientLineTimer invalidate];//注销定时器
    self.gradientLineTimer = nil;
    [self.cameraViewScanInfoDelegate scanInfo:photoInfo];
}




























/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
