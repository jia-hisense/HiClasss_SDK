//
//  HICMySettingVC.m
//  HiClass
//
//  Created by WorkOffice on 2020/3/17.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICMySettingVC.h"
#import "HICCustomNaviView.h"
#import "HICMySettingCell.h"
#import "HICMyModiftPasswordVC.h"
#import "HICMyUpdateVC.h"
#import <UserNotifications/UserNotifications.h>
@interface HICMySettingVC ()<UITableViewDelegate,UITableViewDataSource,HICCustomNaviViewDelegate,HICMysettingDelegate>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)HICCustomNaviView *navi;
@property (nonatomic, strong)NSArray *titleArr;
@property (nonatomic ,strong)UIView *backView;
@end

@implementation HICMySettingVC

- (UITableView *)tableView {
    if (!_tableView) {
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isNumLogin"]) {
            _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 8, HIC_ScreenWidth, 200) style:UITableViewStylePlain];
        }else{
            _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 8, HIC_ScreenWidth, 250) style:UITableViewStylePlain];
        }
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0;
        }
    }
    return _tableView;
}
- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc]initWithFrame:CGRectMake(0, HIC_NavBarAndStatusBarHeight, HIC_ScreenWidth, HIC_ScreenHeight - HIC_NavBarAndStatusBarHeight)];
        _backView.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
        [self.view addSubview:_backView];
    }
    return _backView;
}
- (NSArray *)titleArr{
    if (!_titleArr) {
        _titleArr = @[NSLocalizableString(@"allowsVideoPlayAutomatically", nil),NSLocalizableString(@"allowsMessageNotificationPrompt", nil),NSLocalizableString(@"changePwd", nil),NSLocalizableString(@"detectionOfUpdate", nil),NSLocalizableString(@"about", nil)];
    }
    return _titleArr;
}
- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavi];
    [self createUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(listenInform) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)listenInform{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
//    if (@available(iOS 10.0, *)) {
        [[UNUserNotificationCenter currentNotificationCenter]getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            if (settings.authorizationStatus == UNAuthorizationStatusDenied) {
                // 用户未授权通知
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSUserDefaults standardUserDefaults] setObject:@"isOff" forKey:[NSNumber numberWithInteger:indexPath.row].stringValue];
                    [self.tableView reloadData];
                });
            }else if (settings.authorizationStatus == UNAuthorizationStatusAuthorized) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSUserDefaults standardUserDefaults] setObject:@"isOn" forKey:[NSNumber numberWithInteger:indexPath.row].stringValue];
                    [self.tableView reloadData];
                });
            }
        }];
//    }
}


- (void)createNavi {
    self.navi = [[HICCustomNaviView alloc] initWithTitle:NSLocalizableString(@"setUp", nil) rightBtnName:nil showBtnLine:NO];
    _navi.delegate = self;
    [self.view addSubview:_navi];
}

- (void)createUI{
    self.view.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
    self.tableView.delegate  = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = NO;
    [self.backView addSubview:self.tableView];
    UIButton *resignBtn;
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isNumLogin"]) {
            resignBtn= [[UIButton alloc]initWithFrame:CGRectMake(0, 200 + 16, HIC_ScreenWidth, 50)];
           }else{
             resignBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 250 + 16, HIC_ScreenWidth, 50)];
           }
    [resignBtn setTitle:NSLocalizableString(@"exitLogin", nil) forState:UIControlStateNormal];
    [resignBtn setTitleColor:[UIColor colorWithHexString:@"#FF553C"] forState:UIControlStateNormal];
    [resignBtn setBackgroundColor:[UIColor whiteColor]];
    [resignBtn addTarget:self action:@selector(logOutBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.backView addSubview:resignBtn];
    
}
- (void)logOutBtnClicked {
    [LoginManager logout];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isNumLogin"];
}

#pragma mark - - - HICCustomNaviViewDelegate  - - -
- (void)leftBtnClicked {
    if (self.presentingViewController && self.navigationController.viewControllers.count == 1) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma  mark -----uitableviewdelegate&&datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 2) {
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isNumLogin"]) {
            return 0;
        }else{
            return 50;
        }
    }else{
         return 50;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HICMySettingCell *cell = (HICMySettingCell *)[tableView dequeueReusableCellWithIdentifier:@"mySettingCell"];
    if (!cell) {
        cell = [[HICMySettingCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"mySettingCell"];
    }
    if (indexPath.row == 0 || indexPath.row == 1) {
        NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:[NSNumber numberWithInteger:indexPath.row].stringValue];
        if ([NSString isValidStr:str]) {
            if ([str isEqualToString:@"isOn"]) {
                cell.isOn = YES;
            }else{
                cell.isOn = NO;
            }
        }
         cell.indexPath = indexPath;
        [cell haveDiscoureLabel:NO isSwitch:YES haveRightLabel:NO haveRightImage:NO isHeader:NO andLeftStr:self.titleArr[indexPath.row] andRightStr:@""];
       
    }
    else if (indexPath.row == 2){
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isNumLogin"]) {
        }else{
            [cell haveDiscoureLabel:NO isSwitch:NO haveRightLabel:NO haveRightImage:NO isHeader:NO andLeftStr:self.titleArr[indexPath.row]
                        andRightStr:@""];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
    }else if (indexPath.row == 3){
        DDLogDebug(@"appbuildf%@", HICAPPVersionCode);
        if ([[NSUserDefaults standardUserDefaults] integerForKey:@"sysAppVersion"] > HICAPPVersionCode.integerValue) {
            [cell haveDiscoureLabel:NO isSwitch:NO haveRightLabel:NO haveRightImage:YES isHeader:NO andLeftStr:self.titleArr[indexPath.row]
                        andRightStr:@""];
        }else{
            [cell haveDiscoureLabel:NO isSwitch:NO haveRightLabel:NO haveRightImage:NO isHeader:NO andLeftStr:self.titleArr[indexPath.row]
                        andRightStr:@""];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else{
        [cell haveDiscoureLabel:NO isSwitch:NO haveRightLabel:YES haveRightImage:NO isHeader:NO andLeftStr:self.titleArr[indexPath.row]
                    andRightStr:SystemManager.appVersion];
    }
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 2) {
        HICMyModiftPasswordVC *vc = [HICMyModiftPasswordVC new];
        [self.navigationController pushViewController:vc animated:YES];
    }
    // 检测更新目前可以不跳转
    if (indexPath.row == 3) {
//        HICMyUpdateVC *vc = [HICMyUpdateVC new];
//        [self.navigationController pushViewController:vc animated:YES];
        SystemManager.isShowToast = YES;
        [SystemManager checkAppUpdate];
    }
}
#pragma mark ----HICMysettingDelegate
- (void)switchTouched:(NSIndexPath *)indexPath andSwitchStatus:(BOOL)isOn{
    if (isOn) {
        [[NSUserDefaults standardUserDefaults] setObject:@"isOn" forKey:[NSNumber numberWithInteger:indexPath.row].stringValue];
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:@"isOff" forKey:[NSNumber numberWithInteger:indexPath.row].stringValue];
    }
    if (indexPath.row == 1) {
        NSURL *url1 = [NSURL URLWithString:@"App-Prefs:root=NOTIFICATIONS_ID"];
        NSURL *url2 = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if (@available(iOS 11.0, *)) {
            if ([[UIApplication sharedApplication] canOpenURL:url2]){
                [[UIApplication sharedApplication] openURL:url2 options:@{} completionHandler:nil];
            }
        } else {
            if ([[UIApplication sharedApplication] canOpenURL:url1]){
                [[UIApplication sharedApplication] openURL:url1 options:@{} completionHandler:nil];
            }
        }
    }
}

@end
