//
//  HICOpenCamera.m
//  HiClass
//
//  Created by Eddie Ma on 2020/1/15.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICOpenCamera.h"

#import <AVFoundation/AVFoundation.h>

static NSString *logName = @"[HIC][OC]";

@interface HICOpenCamera()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIImagePickerController *picker;
@property (nonatomic, strong) UIViewController *fromVC;
@property (nonatomic, strong) UIViewController *toVC;

@end

@implementation HICOpenCamera

- (UIImagePickerController *)picker {
    if (!_picker) {
        _picker = [[UIImagePickerController alloc] init];
    }
    return _picker;
}

- (instancetype)initFromVC:(UIViewController *)fromVC toVC:(UIViewController *_Nullable)toVC {
    if (self = [super init]) {
        self.fromVC = fromVC;
        self.toVC = toVC;
        [self initCamera];
    }
    return self;
}

- (void)initCamera {
    if (!self.fromVC) {
        DDLogDebug(@"%@ From VC is NOT valid, camera can not be opened", logName);
        return;
    }
    self.picker.delegate = self;
    self.picker.allowsEditing = NO;

    // 判断相机是否可用
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!granted) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.picker dismissViewControllerAnimated:YES completion:^{
                        [HICToast showWithText:NSLocalizableString(@"cameraPermissions", nil)];
                    }];
                });
            }
            BOOL isPicker = NO;
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                isPicker = YES;
            }
            if (isPicker) {
                [self.fromVC presentViewController:self.picker animated:YES completion:nil];
            }else {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizableString(@"error", nil) message:NSLocalizableString(@"cameraUnavailable", nil) preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizableString(@"determine", nil) style:UIAlertActionStyleCancel handler:nil];
                [alert addAction:action];
                [self.fromVC presentViewController:alert animated:YES completion:nil];
            }
        });
    }];

}

#pragma mark --- UIImagePickerControllerDelegate --- start
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    //  获取图片
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    NSMutableArray *photosArray = [[NSMutableArray alloc] initWithArray:@[image]];
    // 获取图片后返回
    [picker dismissViewControllerAnimated:YES completion:nil];

    if ([self.delegate respondsToSelector:@selector(takePhotoResult:)]) {
        [self.delegate takePhotoResult:photosArray];
    }
}

//按取消按钮时候的功能
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    // 返回
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    if ([self.delegate respondsToSelector:@selector(takePhotoResult:)]) {
        [self.delegate takePhotoResult:@[]];
    }
}
#pragma mark --- UIImagePickerControllerDelegate --- end

@end
