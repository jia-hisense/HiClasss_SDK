//
//  Camera.m
//  AVFoundationTest
//
//  Created by 尚轩瑕 on 2017/12/7.
//  Copyright © 2017年 DoubleWood. All rights reserved.
//

#import "Camera.h"
#import <AVFoundation/AVFoundation.h>

@interface Camera() <AVCaptureMetadataOutputObjectsDelegate>

@property (strong, nonatomic) AVCaptureDevice *device;
@property (strong, nonatomic) AVCaptureDeviceInput *input;//输入设备
@property (strong, nonatomic) AVCaptureMetadataOutput *outPut;//元数据输出：用于支持二维码图像数据的识别
@property (strong, nonatomic) AVCaptureSession *session;//会话对象，硬件设备获取数据


@end

@implementation Camera

- (Camera *)init {
    self = [super init];
    if (self) {
        self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
        // Output
        
        //        self.outPut = [[AVCaptureMetadataOutput alloc] init];
        if (!self.outPut) {
            self.outPut = [[AVCaptureMetadataOutput alloc] init];
        }
        [self.outPut setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        
        // Session
        if (!self.session) {
            self.session = [[AVCaptureSession alloc] init];
        }
        //self.session = [[AVCaptureSession alloc] init];
        [self.session setSessionPreset:AVCaptureSessionPresetHigh];//制定摄像头捕获图像质量
        if ([self.session canAddInput:self.input]) {
            [self.session addInput:self.input];
        }
        if ([self.session canAddOutput:self.outPut]) {
            [self.session addOutput:self.outPut];
        }
        self.outPut.metadataObjectTypes = [NSArray arrayWithObject:AVMetadataObjectTypeQRCode];//设置识别的图像类型为二维码
        
        self.preview = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
        self.preview.videoGravity = AVLayerVideoGravityResizeAspectFill;//设置摄像头图像怎样被显示在限定的边界中
        self.preview.frame = self.cameraframe;
        
    }
    return self;
}

- (void)setCameraframe:(CGRect)cameraframe {
    _cameraframe = cameraframe;
    self.preview.frame = cameraframe;
}

/**
 扫描到的二维码信息

 @param photoInfo 二维码信息
 */
- (void)setPhotoInfo:(NSString *)photoInfo {
    _photoInfo = photoInfo;
    [self.cameraScanPhotoSuccessDelete camerScanPhotoInfo:photoInfo];
}

- (void)setRectOfInterst:(CGRect)rectOfInterst {
    _rectOfInterst = rectOfInterst;
    //设置扫描范围：rectOfInterest的坐标为(y,x,height,width)，具体可参考https://juejin.im/entry/57cd38665bbb500074f9abb6，因此需要把原来的frame的x和y 以及height和width交换位置
    self.outPut.rectOfInterest = rectOfInterst;
}


/**
 闪光灯开关

 @param cameraFlashStatus 闪光灯开关状态
 */
- (void)setCameraFlashStatus:(CameraFlashStatus)cameraFlashStatus {
    if (!self.input.device.isTorchAvailable) {
        return;
    }
    _cameraFlashStatus = cameraFlashStatus;
    [self.session beginConfiguration];
    [self.input.device lockForConfiguration:nil];
    if (_cameraFlashStatus == CameraFlashStatusOn) {
        self.input.device.torchMode = AVCaptureTorchModeOn;
    } else {
        self.input.device.torchMode = AVCaptureTorchModeOff;
    }
    [self.input.device unlockForConfiguration];
    [self.session commitConfiguration];
}

/**
 启动摄像头，开始识别二维码
 */
- (void)startCameraRunning {
    [self.session startRunning];//启动摄像头
	// TODO: 教育加启动动画
//    int duration = 1.2; // duration in seconds
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC),
//                   dispatch_get_main_queue(), ^{
//                       [self.session startRunning];//启动摄像头
//                   });
}

/**
 摄像头停止运转
 */
- (void)stopCameraRunning {
    [self.session stopRunning];
}

#pragma mark - 摄像头捕获到指定的图像（二维码）

- (void)captureOutput:(AVCaptureOutput *)output didOutputMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    if ([metadataObjects count] > 0) {
        [self.session stopRunning];
        AVMetadataMachineReadableCodeObject *metadataObject = [metadataObjects objectAtIndex:0];
        self.photoInfo = metadataObject.stringValue;
    }
}

























@end
