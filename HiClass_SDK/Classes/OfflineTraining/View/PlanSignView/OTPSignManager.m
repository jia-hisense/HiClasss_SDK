//
//  OTPSignManager.m
//  HiClass
//
//  Created by 铁柱， on 2020/4/26.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "OTPSignManager.h"

@interface OTPSignManager ()<AMapLocationManagerDelegate>

@property (nonatomic, strong) AMapLocationManager *locationManager;

@end

@implementation OTPSignManager

#pragma mark - 单利实现
static OTPSignManager* _instance = nil;
+(instancetype)shareInstance {
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _instance = [[super allocWithZone:NULL] init] ;
        //不是使用alloc方法，而是调用[[super allocWithZone:NULL] init]
        //已经重载allocWithZone基本的对象分配方法，所以要借用父类（NSObject）的功能来帮助出处理底层内存分配的杂物
        [_instance configLocationManager];
        [_instance startSerialLocation]; // 开始定位
    }) ;
    return _instance ;
    }

 //用alloc返回也是唯一实例
+(id)allocWithZone:(struct _NSZone *)zone {
    return [OTPSignManager shareInstance] ;
}
//对对象使用copy也是返回唯一实例
-(id)copyWithZone:(NSZone *)zone {
    return [OTPSignManager shareInstance] ;//return _instance;
}
 //对对象使用mutablecopy也是返回唯一实例
-(id)mutableCopyWithZone:(NSZone *)zone {
    return [OTPSignManager shareInstance] ;
}

#pragma mark - 定位功能
// 对外开放的开启定位的接口 
-(void)updateLocationUserInfo {
    [self startSerialLocation]; // 开启定位
}

- (void)configLocationManager
{
    self.locationManager = [[AMapLocationManager alloc] init];

    [self.locationManager setDelegate:self];

    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
    [self.locationManager setAllowsBackgroundLocationUpdates:NO];
}

- (void)startSerialLocation
{
    //开始连续定位
    [self.locationManager startUpdatingLocation];
}

- (void)stopSerialLocation
{
    //停止连续定位
    [self.locationManager stopUpdatingLocation];
}
#pragma mark - 定位的协议方法
- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error
{
    //定位错误
    DDLogDebug(@"%s, amapLocationManager = %@, error = %@", __func__, [manager class], error);
}

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location
{
    //定位结果
    DDLogDebug(@"location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
    self.locationCoordinate = location.coordinate;
    [self stopSerialLocation]; // 定位成功后，需要关闭定位功能 位置信息的获取在启动APP时获取一次进入培训安排是获取一次。
}

#pragma mark - 判断签到范围
-(BOOL)isInClassLocationWithLat:(double)lat andLon:(double)lon radiu:(double)radiu {

    DDLogDebug(@"---- %f ===== %f", self.locationCoordinate.latitude, self.locationCoordinate.longitude);
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(lat, lon);
    // 半径单位为米
    BOOL isContains = MACircleContainsCoordinate(self.locationCoordinate, center, radiu);

    return isContains;
}

@end

