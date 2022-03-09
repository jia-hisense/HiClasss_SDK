//
//  MainTabBarVC.m
//  HiClass
//
//  Created by 铁柱， on 2020/1/14.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "MainTabBarVC.h"
#import "HICLessonsVC.h"
#import "HICMineTableVC.h"
#import "HICOnlineTrainVC.h"
#import "HICTrainDetailVC.h"
#import "HICLectureDetailVC.h"
#import "HICMyFirstPageVC.h"
#import "HICMyInformationVC.h"
#import "HICMySettingVC.h"
#import "HICHomeStudyVC.h"
#import "HICHomeTaskCenterVC.h"
#import "HICTaskCneterVC.h"
#import "HICHomePostMapVC.h"
#import "HICLiveCenterVC.h"
static NSString *logName = @"[HIC][MTBVC]";

@interface MainTabBarVC ()

@end

@implementation MainTabBarVC

- (void)setVCs {
    UIView *bgView = [[UIView alloc] initWithFrame:self.tabBar.bounds];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.tabBar insertSubview:bgView atIndex:0];

    HICHomeStudyVC *studyVC = HICHomeStudyVC.new;
    [HICCommonUtils controller:studyVC Title:NSLocalizableString(@"study", nil) titleColor:@"#03B3CC" tabBarItemImage:@"学习-常态" tabBarItemSelectedImage:@"学习-选中"];

    HICHomeTaskCenterVC *taskVC = HICHomeTaskCenterVC.new;
    [HICCommonUtils controller:taskVC Title:NSLocalizableString(@"task", nil) titleColor:@"#03B3CC" tabBarItemImage:@"任务-常态" tabBarItemSelectedImage:@"任务-选中"];

    HICMyFirstPageVC *myVC = [HICMyFirstPageVC new];
    [HICCommonUtils controller:myVC Title:NSLocalizableString(@"mine", nil) titleColor:@"#03B3CC" tabBarItemImage:@"我的-常态" tabBarItemSelectedImage:@"我的-选中"];
    NSArray *controlles = @[studyVC, taskVC, myVC];
    NSMutableArray *ruleTabArrays = [NSMutableArray array];
    for (UIViewController *vc in controlles) {
        if (vc == taskVC) {
            [ruleTabArrays addObject:@"AppTaskCenterF"];
        }else if (vc == studyVC) {
            [ruleTabArrays addObject:@"AppHomePageF"];
        }else if (vc == myVC) {
            [ruleTabArrays addObject:@"AppMineF"];
        }
    }
    RoleManager.showTabBarMenus = [ruleTabArrays copy];

    [self setViewControllers:controlles];
    // 检查应用升级
    [SystemManager checkAppUpdate];
}

- (void)setRoleVCs {
    UIView *bgView = [[UIView alloc] initWithFrame:self.tabBar.bounds];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.tabBar insertSubview:bgView atIndex:0];

    HICHomeStudyVC *studyVC = [HICHomeStudyVC new];
    HICHomeTaskCenterVC *taskVC = [HICHomeTaskCenterVC new];
    HICMyFirstPageVC *myVC = [HICMyFirstPageVC new];
    HICHomePostMapVC *mapVC = [HICHomePostMapVC new];
    HICLiveCenterVC *liveVC = [HICLiveCenterVC new];
    liveVC.isTab = YES;

    NSMutableArray *views = [NSMutableArray array];
    if (RoleManager.tabBarMenus.count > 0) {
        for (HICTabMenuModel *model in RoleManager.tabBarMenus) {
            if ([model.navCode isEqualToString:@"SY"]) {
                [HICCommonUtils controller:studyVC Title:model.name titleColor:@"#03B3CC" tabBarItemImage:@"学习-常态" tabBarItemSelectedImage:@"学习-选中"];
                [views addObject:studyVC];
            }else if ([model.navCode isEqualToString:@"XX"]) {
                [HICCommonUtils controller:taskVC Title:model.name titleColor:@"#03B3CC" tabBarItemImage:@"任务-常态" tabBarItemSelectedImage:@"任务-选中"];
                [views addObject:taskVC];
            }else if ([model.navCode isEqualToString:@"LX"]) {
                [HICCommonUtils controller:mapVC Title:model.name titleColor:@"#03B3CC" tabBarItemImage:@"岗位地图-常态" tabBarItemSelectedImage:@"岗位地图-选中"];
                [views addObject:mapVC];
            }else if ([model.navCode isEqualToString:@"ZB"]) {
                [HICCommonUtils controller:liveVC Title:model.name titleColor:@"#03B3CC" tabBarItemImage:@"直播-常态" tabBarItemSelectedImage:@"直播-选中"];
                [views addObject:liveVC];
            }else if ([model.navCode isEqualToString:@"WD"]) {
                [HICCommonUtils controller:myVC Title:model.name titleColor:@"#03B3CC" tabBarItemImage:@"我的-常态" tabBarItemSelectedImage:@"我的-选中"];
                [views addObject:myVC];
            }
        }
    }
    NSMutableArray *menus = [NSMutableArray array];
    if (RoleManager.menuCodes.count > 0) {
        // 需要增加数组
        for (NSString *str in RoleManager.menuCodes) {
            if ([str isEqualToString:@"AppTaskCenterF"]) {
                [menus addObject:taskVC];
            }else if ([str isEqualToString:@"AppHomePageF"]) {
                [menus addObject:studyVC];
            }else if ([str isEqualToString:@"AppMineF"]) {
                [menus addObject:myVC];
            }else if ([str isEqualToString:@"AppJobMapF"]) {
                [menus addObject:mapVC];
            }else if ([str isEqualToString:@"AppVideoConferenceF"]) {
                // 视频会议的view
            }else if ([str isEqualToString:@"LiveF"]) {
                [menus addObject:liveVC];
            }
        }
    }
    NSMutableArray *controlles = [NSMutableArray array];
    for (UIViewController *vc in views) {
        if ([menus containsObject:vc]) {
            [controlles addObject:vc];
        }
    }

    NSMutableArray *ruleTabArrays = [NSMutableArray array];
    for (UIViewController *vc in controlles) {
        if (vc == taskVC) {
            [ruleTabArrays addObject:@"AppTaskCenterF"];
        }else if (vc == studyVC) {
            [ruleTabArrays addObject:@"AppHomePageF"];
        }else if (vc == myVC) {
            [ruleTabArrays addObject:@"AppMineF"];
        }else if (vc == mapVC) {
            [ruleTabArrays addObject:@"AppJobMapF"];
        }else if (vc == liveVC){
            [ruleTabArrays addObject:@"LiveF"];
        }
    }
    RoleManager.showTabBarMenus = [ruleTabArrays copy];
    [self setViewControllers:[controlles copy]];

    // 检查应用升级
    [SystemManager checkAppUpdate];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // 数据库所有表更新
    [self updateDB];
    [self getRoleData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBar.tintColor = [UIColor colorWithHexString:@"#03B3CC"];
    if (@available(iOS 13.0, *)) {
        self.tabBar.unselectedItemTintColor = [UIColor blackColor];
    }
    [HICAPI getSystemConfiguration];
}
- (void)getRoleData {
    [RoleManager loadDataUserDetailAndRoleChangeRootBlock:^(BOOL isSuccess) {
        if (isSuccess) {
            [self setRoleVCs];
        }else {
            [self setVCs];
        }
    }];
}
- (void)updateDB {
    if ([NSString isValidStr:HIC_DBVERSION] && [HIC_DBVERSION isEqualToString:DB_VERSION]) {
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [DBManager updataDB];
        [[NSUserDefaults standardUserDefaults] setValue:DB_VERSION forKey:@"HICDBVersion"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        DDLogDebug(@"%@ DB update all tables",logName);
    });
}

@end

