//
//  Camera.h
//  AVFoundationTest
//
//  Created by 尚轩瑕 on 2017/12/7.
//  Copyright © 2017年 DoubleWood. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


/**
 照相机闪光灯
 */
typedef NS_ENUM(char, CameraFlashStatus) {
    CameraFlashStatusOn,
    CameraFlashStatusOff,
};

@class AVCaptureVideoPreviewLayer;
@protocol CameraScanPhotoSuccessDelegate <NSObject>

/**
 成功扫描到二维码

 @param photoInfo 二维码内部信息
 */
- (void)camerScanPhotoInfo:(NSString *)photoInfo;

@end

@interface Camera : NSObject

@property (weak, nonatomic) NSObject<CameraScanPhotoSuccessDelegate> *cameraScanPhotoSuccessDelete;

@property (strong, nonatomic) AVCaptureVideoPreviewLayer *preview;//图层类，用来呈现摄像头实时获取的原始图像数据[self.view.layer insertSublayer:self.camera.preview atIndex:0 ];

/**
 摄像头图像frame大小
 */
@property (assign, nonatomic) CGRect cameraframe;


/**
 扫描到的二维码信息string
 */
@property (strong, nonatomic) NSString *photoInfo;

/**
 扫描范围
 */
@property (assign, nonatomic) CGRect rectOfInterst;


/**
 照相机闪光灯
 */
@property (assign, nonatomic) CameraFlashStatus cameraFlashStatus;

/**
 启动摄像头，开始识别二维码
 */
- (void)startCameraRunning;

/**
 摄像头停止运转
 */
- (void)stopCameraRunning;
@end
