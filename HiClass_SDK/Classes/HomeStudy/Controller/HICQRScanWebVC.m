//
//  HICQRScanWebVC.m
//  HiClass
//
//  Created by 铁柱， on 2020/3/29.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICQRScanWebVC.h"

#import "HICPhotoPickerVC.h"
#import "HICOpenCamera.h"

#import "OfflineTrainPlanListVC.h"
#import "HICEnrollDetailVC.h"
#import "HICOfflineTrainInfoVC.h"
@implementation ScanWebModel



@end

@interface HICQRScanWebVC ()<HomeWebViewVCDelegate, HICOpenCameraDelegate, HICPhotoPickerVCDelegate>

@property (nonatomic, strong) HomeWebViewVC *vc;
@property (nonatomic, strong) HICOpenCamera *camera; // 相机

// 接H5返回的值
@property (nonatomic, copy) void(^photoBlock)(id _Nonnull data, id _Nonnull param) ;
@property (nonatomic, strong) NSDictionary *param;

@end

@implementation HICQRScanWebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *url = self.urlStr;
    if (!url) {
        url = @"http://www.baidu.com";
    }
    
    if (_isCompanyUrl) {
        [HiWebViewManager addParentVC:self urlStr:url isDelegate:YES isPush:NO hideCusNavi:YES hideCusTabBar:YES];
    }else {
        [HiWebViewManager addParentVC:self urlStr:url isDelegate:YES isPush:NO hideCusNavi:YES isThirdUrl:YES hideCusTabBar:YES ];
    }
}

-(void)homeWebView:(HomeWebViewVC *)webVC clickH5SaveImageWith:(NSDictionary *)dic block:(void (^)(id _Nonnull, id _Nonnull))block {
    
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
        if (model.type == 2) {
            // 需要跳转到相应的页面
            PushViewControllerModel *pushModel = [[PushViewControllerModel alloc] initWithPushType:model.objectType urlStr:nil detailId:model.objectId studyResourceType:model.kldType pushType:0];
            [HICPushViewManager parentVC:self.parentVC pushVCWithModel:pushModel];            
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
        }else if (model.type == 6) {
            // 此时需要跳转到培训安排页面
            OfflineTrainPlanListVC *vc = [[OfflineTrainPlanListVC alloc] init];
            vc.trainId = model.trainId;
            vc.webSelectIndex = model.tabId;
            [self.parentVC.navigationController pushViewController:vc animated:YES];
            [self dismissViewControllerAnimated:NO completion:^{
                
            }];
        }else if (model.type == 4){
            if (model.trainId == 0) {
                HICEnrollDetailVC *vc = [HICEnrollDetailVC new];
                vc.registerID = [NSNumber numberWithInteger:model.registerId];
                vc.trainId = [NSNumber numberWithInteger:model.trainId];
                [self.parentVC.navigationController pushViewController:vc animated:YES];
                [self dismissViewControllerAnimated:NO completion:^{
                    
                }];
            }else{
                HICOfflineTrainInfoVC *vc = [HICOfflineTrainInfoVC new];
                vc.trainId = model.trainId;
                vc.registerActionId = [NSNumber numberWithInteger:model.registerId];
                [self.parentVC.navigationController pushViewController:vc animated:YES];
                [self dismissViewControllerAnimated:NO completion:^{
                    
                }];
            }

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
