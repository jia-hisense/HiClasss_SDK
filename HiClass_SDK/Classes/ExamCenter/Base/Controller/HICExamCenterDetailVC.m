//
//  HICExamCenterDetailVC.m
//  HiClass
//
//  Created by 铁柱， on 2020/1/15.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICExamCenterDetailVC.h"

#import "HICPhotoPickerVC.h"
#import "HICOpenCamera.h"

#import "HICQRScanWebVC.h"

@interface HICExamCenterDetailVC ()<HomeWebViewVCDelegate, HICOpenCameraDelegate, HICPhotoPickerVCDelegate>

@property (nonatomic, strong) HomeWebViewVC *vc;
@property (nonatomic, strong) HICOpenCamera *camera; // 相机

// 接H5返回的值
@property (nonatomic, copy) void(^photoBlock)(id _Nonnull data, id _Nonnull param) ;
@property (nonatomic, strong) NSDictionary *param;

@end

@implementation HICExamCenterDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSString *urlStr;
    NSString *examId = [HICCommonUtils isValidObject:self.examId]?self.examId:@"0";
    NSString *trainId = [HICCommonUtils isValidObject:self.trainId]?self.trainId:@"0";
    NSString *courseId = [HICCommonUtils isValidObject:self.courseId]?self.courseId:@"0";

    if ([examId hasPrefix:@"http"]) {
        urlStr = self.examId;
        
    }else {
        urlStr = [NSString stringWithFormat:@"%@/mweb/index.html?examId=%@&trainId=%@&courseId=%@#/exam-summary", APP_Web_DOMAIN, examId, trainId, courseId];
    }
    DDLogDebug(@"[HIC][ECDVC] Exam URL is: %@", urlStr);

    [HiWebViewManager addParentVC:self urlStr:urlStr isDelegate:YES isPush:YES hideCusNavi:YES hideCusTabBar:YES];
}

- (void)homeWebView:(HomeWebViewVC *)webVC clickH5SaveImageWith:(NSDictionary *)dic block:(void (^)(id _Nonnull, id _Nonnull))block {
    // 此时需要调用相册或者相机的功能
    DDLogDebug(@"[HIC][HiWebSDK] -- 调用主工程的 选取相册的方法");

    self.photoBlock = block;
    self.param = dic;
    NSInteger openType = [[dic objectForKey:@"type"] integerValue];
    NSInteger imageCount = [[dic objectForKey:@"imgCurrentCount"] integerValue];
    NSInteger allImageCount = [[dic objectForKey:@"imgLimitCount"] integerValue] - 1;
    if (openType == 1) {
        self.camera = [[HICOpenCamera alloc] initFromVC:self toVC:nil];
        self.camera.delegate = self;
    }else if (openType == 2) {
        HICPhotoPickerVC *vc = [[HICPhotoPickerVC alloc] init];
        vc.delegate = self;
        // TODO: 需要解析当前存在几张图片
        vc.maximumPhoto = [NSString stringWithFormat:@"%ld", (long) allImageCount];
        vc.selectedPhotosBefore = imageCount;

        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:vc animated:YES completion:nil];
    }

}

-(void)homeWebView:(HomeWebViewVC *)webVC type:(WebGetUserInfoType)type getUserInfoWith:(NSDictionary *)dic block:(void (^)(id _Nonnull, id _Nonnull, WebGetUserInfoType))block {

    if (type == WebScanUrlJumpToOhterVC) {
        ScanWebModel *model = [ScanWebModel mj_objectWithKeyValues:dic];
        if (model.type == 7) {
            // 需要跳转到相应的页面
            PushViewControllerModel *pushModel = [[PushViewControllerModel alloc] initWithPushType:model.objectType urlStr:nil detailId:model.objectId studyResourceType:model.kldType pushType:0];
            [HICPushViewManager parentVC:self pushVCWithModel:pushModel];
        }
    }
}

#pragma mark - 相机的协议方法 相册的协议方法
-(void)takePhotoResult:(NSArray *)photoArr {
    // 1. 获取相机信息
    self.photoBlock(photoArr, self.param);
}

-(void)photoSelecedDone:(NSArray *)arr {
    // 1. 获取相册信息
    self.photoBlock(arr, self.param);
}

@end
