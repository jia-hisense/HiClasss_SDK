//
//  HICRoleManager.h
//  HiClass
//
//  Created by Sir_Jing on 2020/3/21.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HICUserDetailModel.h"
#import "HICUserRoleMenuModel.h"
#import "HICTabMenuModel.h"
#import "HICSecurityModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HICRoleManager : NSObject

/// 获取得到用户的数据信息 - 网络请求来的用户信息
@property (nonatomic, strong) HICUserDetailModel *userDetailModel;

/// 用户权限数组 - 网络请求得到的用户权限
@property (nonatomic, strong) NSArray *userMenuDatas;

/* 解析出来的 code码
 用户权限编码数组 一集菜单："AppTaskCenterF"-任务中心, "AppHomePageF"-首页, "AppMineF"-我的, "AppJobMapF"-岗位地图, "AppVideoConferenceF"-视频会议,AnswerGameF-答题游戏
  首页："AppVideoConferenceS"-视频会议, "AppTrainManageS"-培训管理, "AppQuestionnaireS"-问卷, "AppCourseKnowledgeCatalogS"-课程知识目录, "AppJobMapS"-岗位地图, "AppSignUpS"-报名, "AppExamCenterS"-考试中心,“APPLiveS”-直播，AnswerGameS-答题游戏,LiveF-直播
 我的："AppLearningRecordS"-学习记录,"AppNoteS"-笔记, "AppFavoriteS"-收藏, "AppDownloadS"-下载内容, "AppCertificateS"-证书, "AppCreditS"-学分榜, "AppSchoolHoursS"-学时榜, "AppCommentS"-评论]，MyFilesS-我的档案 , WorkTable工作台,Check批阅，Audit审核，ProjectManage项目管理，AccountManage，账号管理知识审核（KnowledgeAudit），试题审核（QuestionAudit），试卷审核（PaperAudit），报名审核（RegistrationAudit）,我的积分(AppPoints),积分榜(AppPointsTop)
 */
@property (nonatomic, strong) NSArray *menuCodes;

/// 底部导航栏 - 网络请求来的
@property (nonatomic, strong) NSArray *tabBarMenus;

/// 当前显示的底部栏数组 -- 真是的底部状态栏
@property (nonatomic, strong) NSArray *showTabBarMenus;

/// 是否获取用户权限
@property (nonatomic, assign) BOOL isSuccessMenu;
/// 安全隐私模型
@property (nonatomic, strong) HICSecurityModel *securityModel;

/// -- 单利 -- 
+(instancetype)shareInstance;

/// 获取用户信息 和 用户角色信息
-(void)loadDataUserDetailAndRoleChangeRootBlock:(void(^)(BOOL isSuccess))block;
/// 获取用户安全信息
- (void)getSecurityInfoBlock:(void(^)(BOOL isSuccess))block;
#pragma mark - 增加一个全局的loading页面放置到window上的
-(void)showWindowLoadingView;
-(void)hiddenWindowLoadingView;

-(void)showErrorViewWith:(UIView *)parentView blcok:(void(^)(NSInteger type))block;

-(void)showErrorViewWith:(UIView *)parentView frame:(CGRect)frame blcok:(void(^)(NSInteger type))block;

@end

NS_ASSUME_NONNULL_END
