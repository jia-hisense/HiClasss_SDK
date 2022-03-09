//
//  HICCertificateModel.h
//  HiClass
//
//  Created by Eddie_Ma on 18/4/20.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HICCertificateModel : NSObject

/// 人员证书ID
@property (nonatomic, strong) NSNumber *employeeCertId;
/// 证书ID
@property (nonatomic, strong) NSNumber *certId;
/// 证书号
@property (nonatomic, strong) NSString *certNo;
/// 证书名称
@property (nonatomic, strong) NSString *name;
/// 人员姓名
@property (nonatomic, strong) NSString *employeeName;
/// 发证日期
@property (nonatomic, strong) NSNumber *createdTime;
/// 发证机构
@property (nonatomic, strong) NSString *authority;
/// 状态 1:正常  2:即将失效  3:已失效  4:已吊销
@property (nonatomic, assign) HICCertStatus status;
/// 证书生效时间
@property (nonatomic, strong) NSNumber *effectiveDate;
/// 证书失效时间
@property (nonatomic, strong) NSNumber *expireDate;
/// 证书图片
@property (nonatomic, copy) NSString *picUrl;
/// 证书图片
@property (nonatomic, copy) UIImage *picUrlImg;
/// 证书简介
@property (nonatomic, copy) NSString *desc;
/// 证书来源
@property (nonatomic, copy) NSString *certSource;
/// 证书如何获取
@property (nonatomic, copy) NSString *reason;
//  证书吊销原因
@property (nonatomic, copy) NSString *revokeReason;

@end

NS_ASSUME_NONNULL_END
