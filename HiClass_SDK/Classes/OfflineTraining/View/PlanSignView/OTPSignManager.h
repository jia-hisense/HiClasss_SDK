//
//  OTPSignManager.h
//  HiClass
//
//  Created by 铁柱， on 2020/4/26.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OTPSignManager : NSObject

/// 单例
+(instancetype)shareInstance;

/// 坐标点位置 --
@property (nonatomic, assign) CLLocationCoordinate2D locationCoordinate;

// 对外开放的开启定位的接口 -- 不需要停止，定位成功后自动停止定位
-(void)updateLocationUserInfo;

/// 当前的坐标位置是否在签到范围内
-(BOOL)isInClassLocationWithLat:(double)lat andLon:(double)lon radiu:(double)radiu;

@end

NS_ASSUME_NONNULL_END

