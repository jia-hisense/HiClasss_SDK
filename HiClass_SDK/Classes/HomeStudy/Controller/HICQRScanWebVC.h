//
//  HICQRScanWebVC.h
//  HiClass
//
//  Created by 铁柱， on 2020/3/29.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ScanWebModel:NSObject

/// 跳转类型
@property(nonatomic, assign) NSInteger  type;
@property(nonatomic, assign) NSInteger  objectType;
@property(nonatomic, assign) NSInteger  kldType;
@property(nonatomic, assign) NSInteger  objectId;

/// 跳转培训详的参数解析
@property(nonatomic, assign) NSInteger trainId;
@property(nonatomic, assign) NSInteger tabId;
/// 跳转报名的参数
@property (nonatomic ,assign)NSInteger registerId;
@end

@interface HICQRScanWebVC : UIViewController

@property (nonatomic, assign) BOOL isCompanyUrl;

@property (nonatomic, copy) NSString *urlStr;

@property (nonatomic, weak) UIViewController *parentVC;

@end

NS_ASSUME_NONNULL_END
