//
//  OTPSignMapViewVC.m
//  HiClass
//
//  Created by 铁柱， on 2020/4/26.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "OTPSignMapViewVC.h"

@interface OTPSignMapViewVC ()<MAMapViewDelegate>

@property (nonatomic, strong) MAMapView *mapView;

@end

@implementation OTPSignMapViewVC

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createNav];
    self.view.backgroundColor = UIColor.whiteColor;

    ///初始化地图
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, HIC_NavBarAndStatusBarHeight, HIC_ScreenWidth, HIC_ScreenHeight-HIC_NavBarAndStatusBarHeight)];
    _mapView.delegate = self;

    ///把地图添加至view
    [self.view addSubview:_mapView];

    ///进入地图就显示定位小蓝点，则需要下面两行代码
    _mapView.showsUserLocation = YES;
    _mapView.userTrackingMode = MAUserTrackingModeFollow; // 实时更新用户的位置信息
    [self setLocationView];

    // 增加地图标注
    [self addAnnotation];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 此时设置地图的中心点信息 -- 与画中心点的进行区分
    [self showSignMapCenter];
}

#pragma mark - 创建页面
-(void)createNav {

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, HIC_StatusBar_Height, HIC_ScreenWidth, 44)];
    [self.view addSubview:view];
    UIButton *but = [[UIButton alloc] initWithFrame:CGRectMake(5, 0, 44, 44)];
    [but setImage:[UIImage imageNamed:@"关闭弹窗"] forState:UIControlStateNormal];
    [but addTarget:self action:@selector(clickCloseView:) forControlEvents:UIControlEventTouchUpInside];

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(54, 0, HIC_ScreenWidth-54*2, 44)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor colorWithHexString:@"#181818"];
    titleLabel.font = FONT_MEDIUM_18;
    titleLabel.text = NSLocalizableString(@"attendance", nil);

    [view addSubview:but];
    [view addSubview:titleLabel];
}

#pragma mark - 定位钢圈的问题
-(void)setLocationView {

    MAUserLocationRepresentation *r = [[MAUserLocationRepresentation alloc] init];
    r.showsAccuracyRing = NO;///精度圈是否显示，默认YES
    r.showsHeadingIndicator = NO;///是否显示方向指示(MAUserTrackingModeFollowWithHeading模式开启)。默认为YES
//    r.fillColor = [UIColor redColor];///精度圈 填充颜色, 默认 kAccuracyCircleDefaultColor
//    r.strokeColor = [UIColor blueColor];///精度圈 边线颜色, 默认 kAccuracyCircleDefaultColor
    r.enablePulseAnnimation = NO;///内部蓝色圆点是否使用律动效果, 默认YES
    [self.mapView updateUserLocationRepresentation:r];
}

-(void)addAnnotation {
    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
    pointAnnotation.coordinate = self.center;

    [_mapView addAnnotation:pointAnnotation];

    // 增加标注时需要圈定范围
    //构造圆
    MACircle *circle = [MACircle circleWithCenterCoordinate:self.center radius:self.radius];

    //在地图上添加圆
    [_mapView addOverlay: circle];
}

// 显示签到地点到地图中心并且缩放等级
-(void)showSignMapCenter {
    // 判断当前的位置信息
    if (self.center.latitude != 0 && self.center.longitude != 0 ) {
        [_mapView setCenterCoordinate:self.center];
        if (self.radius > 1000) {
            // 此时存在圆圈范围
            [_mapView setZoomLevel:12];
        }else {
            [_mapView setZoomLevel:15];
        }
    }
}

#pragma mark - 地图协议方法
// 返回标注的协议方法
-(MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation {

    if ([annotation isKindOfClass:[MAUserLocation class]]) {
       return nil;
    }

    if ([annotation isKindOfClass:MAPointAnnotation.class]) {
        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
        MAAnnotationView *annotationView = (MAAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (annotationView == nil) {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation
        reuseIdentifier:reuseIndetifier];
        }
//        annotationView.image = [UIImage imageNamed:@"定位"];
        annotationView.width = 24;
        annotationView.height = 24;

        return annotationView;
    }

    return nil;
}
// 绘制图形的方法
- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MACircle class]]) {
        MACircleRenderer *circleRenderer = [[MACircleRenderer alloc] initWithCircle:(MACircle *)overlay];

        circleRenderer.lineWidth    = 2.f;
        circleRenderer.strokeColor  = [UIColor colorWithRed:0/255.0 green:190/255.0 blue:215/255.0 alpha:1.0];
        circleRenderer.fillColor    = [UIColor colorWithRed:0/255.0 green:190/255.0 blue:215/255.0 alpha:0.3];
        return circleRenderer;
    }
    return nil;
}
// 位置更新后的回调方法
-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation {
    [OTPSignManager shareInstance].locationCoordinate = userLocation.coordinate; // 更新单例对象的位置信息
}

#pragma mark - 点击事件
-(void)clickCloseView:(UIButton *)but {
    [self dismissViewControllerAnimated:YES completion:^{

    }];
}

@end
