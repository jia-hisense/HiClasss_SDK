//
//  HICSecurityModel.h
//  HiClass
//
//  Created by WorkOffice on 2020/5/28.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HICSecurityModel : NSObject
/**
 
 "validType": "integer,在场验证模式：0不启用，1-开启App人像采集，2-开启在线学习检查用户是否还在，3-都开启",
    "interval": "integer,在线学习检查间隔时长，单位分钟；当validType=2或者3是有效",
    "preventRecordScreen": "integer,防录屏模式：0-不启用，1-启用防录屏模式（黑屏处理）,2-启用防截屏模式（黑屏处理）,3.都启用",
    "selfDefineWatermark": "string,自定义水印（此处不带个人信息，谨慎使用）",
    "securityAgreementSwitch": "integer,保密协议开关，0-关闭，1-开启",
    "hidePhoneNumber": "integer,隐藏手机号信息开关：0-不隐藏，1-隐藏",
    "hideDeptInfo": "integer,隐藏部门信息，0-不隐藏，1-隐藏",
    "hidePostInfo": "integer,隐藏个人信息中的岗位信息，0-不隐藏，1-隐藏"
 */
@property (nonatomic ,assign)NSInteger validType;
@property (nonatomic ,assign)NSInteger interval;
@property (nonatomic ,assign)NSInteger preventRecordScreen;
@property (nonatomic ,strong)NSString *selfDefineWatermark;
@property (nonatomic ,assign)NSInteger securityAgreementSwitch;
@property (nonatomic ,assign)NSInteger hidePhoneNumber;
@property (nonatomic ,assign)NSInteger hideDeptInfo;
@property (nonatomic ,assign)NSInteger hidePostInfo;

@end

NS_ASSUME_NONNULL_END
