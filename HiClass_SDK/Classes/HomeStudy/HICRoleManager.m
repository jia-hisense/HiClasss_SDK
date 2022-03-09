//
//  HICRoleManager.m
//  HiClass
//
//  Created by Sir_Jing on 2020/3/21.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICRoleManager.h"

@interface HICRoleManager ()

@property (nonatomic, strong) NSMutableArray *loadingViews;

@end

@implementation HICRoleManager

#pragma mark - 单例实现
static HICRoleManager* _instance = nil;
+(instancetype)shareInstance {
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _instance = [[super allocWithZone:NULL] init] ;
        _instance.loadingViews = [NSMutableArray array];
    }) ;
    return _instance ;
    }
 
 //用alloc返回也是唯一实例
+(id)allocWithZone:(struct _NSZone *)zone {
    return [HICRoleManager shareInstance] ; 
}
//对对象使用copy也是返回唯一实例
-(id)copyWithZone:(NSZone *)zone {
    return [HICRoleManager shareInstance] ;//return _instance;
}
 //对对象使用mutablecopy也是返回唯一实例
-(id)mutableCopyWithZone:(NSZone *)zone {
    return [HICRoleManager shareInstance] ;
}

-(void)loadDataUserDetailAndRoleChangeRootBlock:(void (^)(BOOL))block {
    [HICAPI loadDataUserDetailAndRoleChangeRoot:^(NSDictionary * _Nonnull responseObject) {
        self.userDetailModel = [HICUserDetailModel createModelWithSourceData:responseObject];
        [self loadDataUserRoleChangeRootBlock:block];
    } failure:^(NSError * _Nonnull error) {
        DDLogDebug(@"[HIC]-[RoleManager] --- 网络数据请求失败！");
        block(NO);
    }];
}

-(void)loadDataUserRoleChangeRootBlock:(void (^)(BOOL))block {

    NSString *roleStr = [self.userDetailModel getRoleIdStr];
    NSString *autStr = self.userDetailModel.autonomousOrgCode;
    NSString *userStr = self.userDetailModel.deptNumber;

    if (roleStr && autStr && userStr) {
        // 角色网络请求
        NSDictionary *dic = @{@"type":@3, @"accessToken":USER_TOKEN, @"roleCodes":roleStr, @"autonomousOrgCode":autStr, @"userDeptNumber":userStr };
        [HICAPI loadDataUserRoleChangeRoot:dic success:^(NSDictionary * _Nonnull responseObject) {
            NSArray *array = [HICUserRoleMenuModel createModelWithSourceData:responseObject];
            self.userMenuDatas = array;
            if (array.count > 0) {
                [self loadDataTabMenuChangeRootBlock:block];
                [self getRoleMenuCode];
            }else {                 block(NO);
            }
        } failure:^(NSError * _Nonnull error) {
            block(NO);
        }];
    }else {
        block(NO);
    }
}

-(void)loadDataTabMenuChangeRootBlock:(void (^)(BOOL))block {
    [HICAPI loadDataTabMenuChangeRoot:^(NSDictionary * _Nonnull responseObject) {
        NSArray *array = [HICTabMenuModel createModelWithSourceData:responseObject];
        self.tabBarMenus = array;
        if (array.count > 0) {
            block(YES);
        }else {
            block(NO);
        }
    } failure:^(NSError * _Nonnull error) {
        block(NO);
    }];
}

-(BOOL)isSuccessMenu {
    if (self.menuCodes.count == 0 || !self.userDetailModel || self.tabBarMenus.count == 0) {
        return NO;
    }
    return YES;
}

-(void)getRoleMenuCode {
    NSMutableArray *array = [NSMutableArray array];
    [self getRoleMenuCodeStrWith:self.userMenuDatas codes:array];
    self.menuCodes = [array copy];
}
-(void)getRoleMenuCodeStrWith:(NSArray *)models codes:(NSMutableArray *)codes {
    for (HICUserRoleMenuModel *model in models) {
        if (model.menuCode) {
            [codes addObject:model.menuCode];
        }
        if (model.children.count != 0) {
            [self getRoleMenuCodeStrWith:model.children codes:codes];
        }else {
            continue;
        }
    }
}

#pragma mark - 增加一个全局的loading页面放置到window上的
-(void)showWindowLoadingView {
    UIWindow *keyWindow = UIApplication.sharedApplication.keyWindow;
    HICCustomLoadingView *loadView = [HICCustomLoadingView createLoadingViewWith:keyWindow.bounds onView:keyWindow];
    [loadView showLoadingView];
    [self.loadingViews addObject:loadView];
}
-(void)hiddenWindowLoadingView {
    for (HICCustomLoadingView *view in self.loadingViews) {
        [view hidenLoadingView];
    }
    [self.loadingViews removeAllObjects];
}

-(void)showErrorViewWith:(UIView *)parentView blcok:(void (^)(NSInteger))block {
    HICCustomerNetErrorView *errorView = [HICCustomerNetErrorView createNetErrorWith:parentView clickBut:block];
    [errorView showError];
}

-(void)showErrorViewWith:(UIView *)parentView frame:(CGRect)frame blcok:(void(^)(NSInteger type))block {
    HICCustomerNetErrorView *errorView = [HICCustomerNetErrorView createNetErrorWith:parentView frame:frame clickBut:block];
    [errorView showError];
}
#pragma mark ---获取安全权限
- (void)getSecurityInfoBlock:(void (^)(BOOL))block{
    [HICAPI getSecurityInfo:^(NSDictionary * _Nonnull responseObject) {
        if ([HICCommonUtils isValidObject:[responseObject valueForKey:@"data"]]) {
            self.securityModel = [HICSecurityModel mj_objectWithKeyValues:[responseObject valueForKey:@"data"]];
            block(YES);
        }else{
            block(NO);
        }
    } failure:^(NSError * _Nonnull error) {
        block(NO);
    }];
}
@end
