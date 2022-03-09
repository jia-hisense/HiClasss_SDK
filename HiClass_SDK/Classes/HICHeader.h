//
//  HICHeader.h
//  HiClass
//
//  Created by wangggang on 2019/12/31.
//  Copyright © 2019 jingxianglong. All rights reserved.
//

#ifndef HICHeader_h
#define HICHeader_h

// VersionCode，替换Build号作为应用升级检测时的依赖字段，每个新版本必须更新此值
#define HICAPPVersionCode @59

#define HIC_Class_Version [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
/*** 国际化 ***/
#define LocalizedString(key)               [[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"HiClass_SDK" ofType:@"bundle"]] localizedStringForKey:(key) value:@"" table:@"File"]
#define NSLocalizableString(key, comment)  [[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"HiClass_SDK" ofType:@"bundle"]] localizedStringForKey:(key) value:@"" table:nil]
// 带参数的国际化
#define HICLocalizedFormatString(fmt, ...) [NSString stringWithFormat:NSLocalizableString(fmt, nil), __VA_ARGS__]

#pragma mark - 系统信息
#define HIC_ScreenWidth         [UIScreen mainScreen].bounds.size.width
#define HIC_ScreenHeight        [UIScreen mainScreen].bounds.size.height

// 1. 状态栏的高度
#define HIC_StatusBar_Height    UIApplication.sharedApplication.statusBarFrame.size.height
// 2. 是否为iPhoneX
#define HIC_isIPhoneX                   (HIC_StatusBar_Height>20?YES:NO)
// 3. 距离底部的高度
#define HIC_BottomHeight                (HIC_isIPhoneX?34.0:0)
// 导航栏高度
#define HIC_NavBarHeight                (44)
// 状态栏和导航栏总高度
#define HIC_NavBarAndStatusBarHeight    (CGFloat)(HIC_isIPhoneX?(88.0):(64.0))
// TabBar高度
#define HIC_TabBarHeight                (CGFloat)(HIC_isIPhoneX?(49.0 + 34.0):(49.0))


#pragma mark - 统一颜色设置
// 修改密码
#define MODIFY_PASS_TITLE_COLOR         [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
#define PLACEHOLDER_COLOR               [UIColor colorWithRed:185/255.0 green:185/255.0 blue:185/255.0 alpha:1/1.0]
//oa登录
#define BOTTOM_NOACCOUNTLABEL_COLOR     [UIColor colorWithHexString:@"#858585" alpha:1.0]
#define BOTTOM_TELLOGIN_COLOR           [UIColor colorWithHexString:@"#00BED7" alpha:1.0]
#define GRAY_BACKGROUND                 [UIColor colorWithHexString:@"#F5F5F5" alpha:1.0]
#pragma mark - 统一frame设置

#pragma mark - 统一常量设置

// 阿里推送app key
#define ALI_APP_KEY     [HICCommonUtils appBundleIden] == HICAppBundleIdenZhiYu ? @"333555680" : @"29167270"
// 阿里推送app secret
#define ALI_APP_SECRET  [HICCommonUtils appBundleIden] == HICAppBundleIdenZhiYu ? @"5427730ec161435da283738568731fd0" : @"70b1a6399030a7f6100c8f684d49d79d"

// 应用在Itunes的appID
#define APP_ID          @"1069787121"
// 应用 app key
#define APP_KEY         [HICCommonUtils appBundleIden] == HICAppBundleIdenZhiYu ? @"1188868631" : @"1183345212"
// 应用 app secret
#define APP_SECRET      @"dfaeotflmukb690h2s5levntmjv9lqx3"
// 当前数据库版本号，每次数据库有变更，都需要【手动修改版本号】
#define DB_VERSION      @"1.0.0"
// 当前引导图，如果有变动，需要【手动修改版本号】
#define INTRO_VERSION   @"1.0.0"
// Public Key
#define DEFAULT_PUBLIC_KEY  @"MFwwDQYJKoZIhvcNAQEBBQADSwAwSAJBAK26F0+yIWMxpW4WW7vsrwLl8kp8isCarBGv54xOK468ZD6FbOMZAOSj8JBr0IpUzv5w+hURR6W4oINsI4o5CEMCAwEAAQ=="
// Salt
#define DEFAULT_SALT            @"AOSj8JBr0IpUzv5w+hURR6W4oINsI4o5"
// 修改密码文字
#define MODIFY_PASS_TITLE       NSLocalizableString(@"changePwd", nil)
#define MODIFY_PASS_HINT        NSLocalizableString(@"passwordRequired", nil)
//OA登录文字
#define OALOGIN_TITLE           NSLocalizableString(@"loginUsingOAAccount", nil)
#define OABOTTOM_NOACCOUNT      NSLocalizableString(@"noOAAccount", nil)
#define OATEL_LOGIN             NSLocalizableString(@"mobilePhoneLogin", nil)
// 手机号登录文字
#define PHONENUMLOGIN_TITLE     NSLocalizableString(@"mobilePhoneLogin", nil)
#define PHONEBOTTOM_OALOGIN     NSLocalizableString(@"loginUsingOAAccount", nil)
#define PHONEBOTTOM_FORGET      NSLocalizableString(@"forgetPwd", nil)
#define PHONELOGIN_INFO         NSLocalizableString(@"lastFourDigitsOfIdCard", nil)

#pragma mark - - - 默认域名 - - - start
// 默认账号域名
#define DEFAULT_ACC_DOMAIN          [HICCommonUtils appBundleIden] == HICAppBundleIdenZhiYu ? @"https://acc-zhiyu.hismarttv.com" : @"https://acc-hedu.hismarttv.com"
// 默认考试域名
#define DEFALUT_EXAM_DOMAIN         [HICCommonUtils appBundleIden] == HICAppBundleIdenZhiYu ? @"https://api-zhiyu-mobi.hismarttv.com" : @"https://api-mobile-hedu-mobi.hismarttv.com"
// 默认评论域名
#define DEFALUT_COMMENTS_DOMAIN     [HICCommonUtils appBundleIden] == HICAppBundleIdenZhiYu ?  @"https://api-zhiyu-mobi.hismarttv.com" : @"https://api-hedu-mobi.hismarttv.com"
// 应用升级域名
#define APP_UPGRADE_DOMAIN          [HICCommonUtils appBundleIden] == HICAppBundleIdenZhiYu ? @"https://upgrade-zhiyu-phone.hismarttv.com": @"https://upgrade-phone-hedu.hismarttv.com"
#define APP_Web_DOMAIN              [HICCommonUtils appBundleIden] == HICAppBundleIdenZhiYu ?  @"https://web-zhiyu.hismarttv.com" : @"https://web-hedu.hismarttv.com"
#define APP_UPLOAD_DOMAIN           [HICCommonUtils appBundleIden] == HICAppBundleIdenZhiYu ?   @"https://upload-zhiyu-mobi.hismarttv.com" : @"https://upload-hedu-mobi.hismarttv.com"
#define APP_DOC_CDN_DOMAIN          [HICCommonUtils appBundleIden] == HICAppBundleIdenZhiYu ?   @"https://doc-cdn-zhiyu.hismarttv.com" : @"https://doc-cdn-hedu.hismarttv.com"
#define APP_GPS_DOMAIN              [HICCommonUtils appBundleIden] == HICAppBundleIdenZhiYu ?   @"https://api-gps-zhiyu.hismarttv.com" : @"https://api-gps-hedu.hismarttv.com"
// 推送域名
#define PUSH_DOMAIN                 [HICCommonUtils appBundleIden] == HICAppBundleIdenZhiYu ? @"https://msg-zhiyu-mobi.hismarttv.com" : @"https://msg-hedu-mobi.hismarttv.com"




#pragma mark - - - 默认域名 - - - end
#define HIC_App_DownloadURL [HICCommonUtils appBundleIden] == HICAppBundleIdenZhiYu ? @"https://apps.apple.com/us/app/知渔/id1590964987" : @""
// 应用升级
#define APP_UPGRADE                 @"upgrade/check_app_version"
// 获取用户隐私协议
#define PRIVACY_AGREEMENT           @"heduapi/api/privacy_agreement"
// 修改密码（系统端）
#define CHANGE_PASS                 @"acc/int/acc/change_pwd"
// 修改密码（Token）
#define CHANGE_PASS_BYTOKEN         @"acc/int/acc/change_pwd_by_token"
// 登录
#define ACCOUNT_LOGIN               @"acc/int/acc/sign_in"
//退出登录
#define ACCOUNT_LOGOUT              @"acc/int/acc/sign_out"
//刷新Token登录
#define ACCOUNT_TOKEN_REFRESH       @"acc/int/acc/sign_in_refreshtoken"
//第三方账号登录
#define ACCOUNT_THIRD_LOGIN         @"acc/int/acc/third_sign_in"
//发送手机短信验证码
#define ACCOUNT_SEND_VERIFIYCODE    @"acc/int/acc/send_mobile_auth_code"
//客户信息查询
#define ACCOUNT_CUSTOMER_QUERY      @"acc/int/acc/get_customer_info"
//是否防录屏
#define ACCOUNT_SECURITY        @"heduapi/pub_api/v1.0/system/get_security_settings"
//查询密码
#define SYSTEM_PWD              @"acc/int/acc/query_params"
//查询考试中心列表
#define EXAM_CENTER_LIST        @"heduapi/app_api/v1.0/get_examination_list"
#define EXAM_STATUS_COUNT       @"heduapi/app_api/v1.0/get_examination_count"
//用户知识/课程列表查询
#define KNOWLEDGE_LIST          @"heduapi/app_api/v1.0/course_kld/get_course_kld_list"
//课程/知识详情
#define COURSE_LIST_DETAIL      @"heduapi/app_api/v1.0/course_kld/get_course_kld_detail"
//课程知识相关推荐列表查询
#define RECOMMEND_LIST          @"heduapi/app_api/v1.0/course_kld/get_recommend_list"
//课程知识-点赞
#define KLD_THUMBUP             @"heduapi/app_api/v1.0/course_kld/like_course_kld"
//课程知识-收藏
#define KLD_COLLECTION          @"heduapi/app_api/v1.0/course_kld/collect_course_kld"
//课程知识-添加笔记
#define KLD_ADD_NOTE            @"heduapi/app_api/v1.0/course_kld/create_learning_notes"
//练习题集列表查询GET
#define EXERCISES_LIST           @"heduapi/app_api/v1.0/course_kld/get_exercises_list"
///heduapi/app_api/v1.0/course_kld/get_exercise_questions_list练习题集中题目列表查询
#define EXERCISES_QUESTION_LIST     @"heduapi/app_api/v1.0/course_kld/get_exercise_questions_list"

#define REPORT_RECORD               @"heduapi/app_api/v1.0/course_kld/report_learning_record"

//我的-收藏列表
#define MY_COLLECT_LIST             @"heduapi/app_api/v1.0/course_kld/get_collection_list"
//我的-收藏删除
#define MY_COLLECT_DELETE           @"heduapi/app_api/v1.0/course_kld/delete_collections"
//我的-证书列表
#define MY_CERT_LIST                @"1.0/app/train/employee/cert/app/list"
//我的-证书详情
#define MY_CERT_DETAIL              @"1.0/app/train/employee/cert/detail"
//学习笔记-列表查询
#define MY_NOTE_OVERVIEW            @"heduapi/app_api/v1.0/course_kld/get_learning_notes_overview"
//学习笔记-详情
#define MY_NOTE_LIST                @"heduapi/app_api/v1.0/course_kld/get_learning_notes_list"
//学习笔记-管理（删除、设置/取消重要）
#define MY_NOTE_MANAGE              @"heduapi/app_api/v1.0/course_kld/manage_learning_notes"
//学习记录查询
#define MY_RECORD_LIST              @"heduapi/app_api/v1.0/course_kld/get_learning_record_list"
//下载记录上报
#define DOWNLOAD_RECORD             @"heduapi/app_api/v1.0/course_kld/report_download_record"
#define MY_COMMENT_LIST             @"heduapi/app_api/v1.0/comment/get_comments_list"
#define MY_FIRST_PAGE_INFO          @"heduapi/app_api/v1.0/my/get_home_page"
// 消息中心-查询消息状态（已读/未读）
#define MSG_CENTER_MSG_STATUS       @"heduapi/app_api/v1.0/course_kld/get_message_status_count"
// 消息中心-查询消息列表
#define MSG_CENTER_MSG_LIST         @"heduapi/app_api/v1.0/course_kld/get_message_list"
// 消息中心-查询消息详情
#define MSG_CENTER_MSG_DETAIL       @"heduapi/app_api/v1.0/course_kld/get_message_detail"
// 消息中心-消息管理(删除、已读/未读)
#define MSG_CENTER_MSG_MANAGE       @"heduapi/app_api/v1.0/course_kld/manage_message"

#define RANK_LIST                   @"heduapi/app_api/v1.0/leaderboard/get"
// 评论-获取评论列表
#define COMMENT_LIST                @"comment/api/getobjectcomments"
// 评论-获取用户评论
#define COMMENT_USER_COMMENT_LIST   @"comment/api/getusercomments"
// 评论-发表评论
#define COMMENT_POST_COMMENT        @"comment/api/usercomment"
// 评论-点赞、回复、删除评论
#define COMMENT_ACTION              @"comment/api/commentop"
// 评论-获取评论回复
#define COMMENT_REPLIES             @"comment/api/getcommentreplys"

// 任务中心-个人任务列表&首页今日待办
#define TASK_CENTER_LIST            @"1.0/app/train/taskCenter/list"
// 任务中心-培训管理任务数量统计
#define TASK_CENTER_LIST_NUM        @"1.0/app/train/taskCenter/trainNum"

//积分任务列表
#define Integral_TASK_LIST            @"heduapi/api/points_task_list"

//培训列表
#define TRAIN_LIST                  @"1.0/app/train/taskCenter/trainList"
#define TRAIN_DETAIL_BASE           @"1.0/app/train/online/detailInfo"
#define TRAIN_TASKNUM               @"1.0/app/train/taskCenter/trainNum"
#define TRAIN_DETAIL_LIST           @"1.0/app/train/online/detailList"
#define TRAIN_SYNC_PROGRESS         @"1.0/app/train/online/syncProgress"
#define TRAIN_TRAINEE_POSITION      @"1.0/app/train/online/traineePosition"
#define TRAIN_AWARD_CERTIFICATES    @"1.0/app/train/award/certificates"
#define TRAIN_OFFLINE_COURSELIST    @"1.0/app/train/offclass/detail"
#define TRAIN_MIX_NOTENROLL         @"1.0/app/train/taskCenter/register/detail/course"
#define TRAIN_OFFLINE_ATTENDANCE    @"1.0/app/train/attendance/save"
#define TRAIN_MIX_ARRANGE           @"1.0/app/train/mix/arrangements"
//头像上传
#define HEADER_UPLODE           @"heduapi/app_api/v1.0/my/manage_employee_info"

//讲师详情
#define LECTURE_DETAIL          @"1.0/app/train/lecturer/detail"

// 推送-注册
#define PUSH_REGISTER           @"api/message/alipush/device/register"

//报名列表数量
#define ENROLL_NUM              @"1.0/app/train/taskCenter/register/statistics"
//报名列表
#define ENROLL_LIST             @"1.0/app/train/taskCenter/register/list"
//报名详情
#define ENROLL_DETAIL           @"1.0/app/train/taskCenter/register/detail"
//报名详情课程安排
#define ENROLL_ARRANGE          @"1.0/app/train/taskCenter/register/detail/course"
//报名编辑
#define ENROLL_OPERATE          @"1.0/app/train/taskCenter/register/doRegister"
//报名催办
#define ENROLL_URGE             @"1.0/app/train/taskCenter/register/urge"
//审核模板详情
#define ENROLL_AUDIT_TEMPLATE   @"heduapi/v1.3/app_api/get_audit_template_detail"
//审核状态
#define ENROLL_AUDIT_STATUS     @"heduapi/v1.3/app_api/get_audit_template_status"
//审核人搜索
#define ENROLL_REVIEWER_LIST    @"heduapi/v1.3/app_api/get_auditor_list"
//问卷数量
#define QUESTION_NUM            @"1.0/app/train/taskCenter/question/statistics"
//问卷列表
#define QUESTION_LIST           @"1.0/app/train/taskCenter/question/list"
//直播列表
#define LIVE_LIST               @"hedulessonapi/app_api/v1.5/livelesson/get_live_lesson_list"
//直播状态数量
#define LIVE_STATUS_NUM         @"hedulessonapi/app_api/v1.5/livelesson/get_live_lesson_count"
//获取绑定直播间的信息
#define LIVE_DETAIL_INFO        @"hedulessonapi/app_api/v1.5/livelesson/get_live_room_detail"
//直播课行为上报
#define LIVE_BEHAVIOR_REPORT    @"hedulessonapi/app_api/v1.5/livelesson/report_behavior_record"

#define HANDON_APPLY            @"trainApi/web/1.6/train/practical_operation/apply"

#define WORK_SPACE_AUDIT_NUMS   @"heduapi/v1.7/app_api/get_audit_task_count"
//最新学习记录
#define LEARNING_RECORD_DETAIL  @"heduapi/app_api/v1.0/course_kld/learning_record_detail"
#define SYS_CONFIG_PARAMS       @"heduapi/app_api/v1.0/sys/getParam"

//积分明细列表
#define Integral_Subsidiary_List @"/heduapi/api/points_log_list"

#pragma mark -textcolorz设置
#define TEXT_COLOR_DARK     [UIColor colorWithHexString:@"#333333"]
#define TEXT_COLOR_LIGHT    [UIColor colorWithHexString:@"#666666"]
#define TEXT_COLOR_LIGHTM   [UIColor colorWithHexString:@"#858585"]
#define TEXT_COLOR_LIGHTS   [UIColor colorWithHexString:@"#999999"]
#define DEVIDE_LINE_COLOR   [UIColor colorWithHexString:@"#e6e6e6"]
#pragma mark --背景色
#define BACKGROUNG_COLOR    [UIColor colorWithHexString:@"#f5f5f5"]
#pragma mark - lessonVCTopViewHeight
#define lessonTopHeight         (211 - 20 + HIC_StatusBar_Height)
#define HIC_Status_Phase_Height (HIC_StatusBar_Height - 20)


#pragma mark --线下课程详情
#define FBStatusBarH ([UIApplication sharedApplication].statusBarFrame.size.height)

#define HexRGB(hexRGB) [UIColor colorWithRed:((float)((hexRGB & 0xFF0000) >> 16))/255.0 green:((float)((hexRGB & 0xFF00) >> 8))/255.0 blue:((float)(hexRGB & 0xFF))/255.0 alpha:1.0]  //0xFFFFFF
//根据十六进制颜色和不透明度设置颜色
#define HexRGBA(rgbValue, a) [UIColor colorWithRed:((float)(((rgbValue)&0xFF0000) >> 16)) / 255.0 green:((float)(((rgbValue)&0xFF00) >> 8)) / 255.0 blue:((float)((rgbValue)&0xFF)) / 255.0 alpha:(a)]

#pragma mark - 统一字体设置
// Regular
#define FONT_REGULAR_11                                         [UIFont fontWithName:@"PingFangSC-Regular" size:11];
#define FONT_REGULAR_12                                         [UIFont fontWithName:@"PingFangSC-Regular" size:12];
#define FONT_REGULAR_13                                         [UIFont fontWithName:@"PingFangSC-Regular" size:13];
#define FONT_REGULAR_14                                         [UIFont fontWithName:@"PingFangSC-Regular" size:14];
#define FONT_REGULAR_14_half                                    [UIFont fontWithName:@"PingFangSC-Regular" size:14.5];
#define FONT_REGULAR_15                                         [UIFont fontWithName:@"PingFangSC-Regular" size:15];
#define FONT_REGULAR_16                                         [UIFont fontWithName:@"PingFangSC-Regular" size:16];
#define FONT_REGULAR_17                                         [UIFont fontWithName:@"PingFangSC-Regular" size:17];
#define FONT_REGULAR_18                                         [UIFont fontWithName:@"PingFangSC-Regular" size:18];
#define FONT_REGULAR_19                                         [UIFont fontWithName:@"PingFangSC-Regular" size:19];
#define FONT_REGULAR_20                                         [UIFont fontWithName:@"PingFangSC-Regular" size:20];
#define FONT_REGULAR_21                                         [UIFont fontWithName:@"PingFangSC-Regular" size:21];
#define FONT_REGULAR_22                                         [UIFont fontWithName:@"PingFangSC-Regular" size:22];
#define FONT_REGULAR_23                                         [UIFont fontWithName:@"PingFangSC-Regular" size:23];
#define FONT_REGULAR_30                                         [UIFont fontWithName:@"PingFangSC-Regular" size:30];
#define FONT_REGULAR_50                                         [UIFont fontWithName:@"PingFangSC-Regular" size:50];
// Medium
#define  FONT_MEDIUM_9                                          [UIFont fontWithName:@"PingFangSC-Medium" size:9];
#define  FONT_MEDIUM_10                                         [UIFont fontWithName:@"PingFangSC-Medium" size:10];
#define  FONT_MEDIUM_11                                         [UIFont fontWithName:@"PingFangSC-Medium" size:11];
#define  FONT_MEDIUM_12                                         [UIFont fontWithName:@"PingFangSC-Medium" size:12];
#define  FONT_MEDIUM_13                                         [UIFont fontWithName:@"PingFangSC-Medium" size:13];
#define  FONT_MEDIUM_14                                         [UIFont fontWithName:@"PingFangSC-Medium" size:14];
#define  FONT_MEDIUM_15                                         [UIFont fontWithName:@"PingFangSC-Medium" size:15];
#define  FONT_MEDIUM_16                                         [UIFont fontWithName:@"PingFangSC-Medium" size:16];
#define  FONT_MEDIUM_17                                         [UIFont fontWithName:@"PingFangSC-Medium" size:17];
#define  FONT_MEDIUM_18                                         [UIFont fontWithName:@"PingFangSC-Medium" size:18];
#define  FONT_MEDIUM_19                                         [UIFont fontWithName:@"PingFangSC-Medium" size:19];
#define  FONT_MEDIUM_20                                         [UIFont fontWithName:@"PingFangSC-Medium" size:20];
#define  FONT_MEDIUM_21                                         [UIFont fontWithName:@"PingFangSC-Medium" size:21];
#define  FONT_MEDIUM_22                                         [UIFont fontWithName:@"PingFangSC-Medium" size:22];
#define  FONT_MEDIUM_23                                         [UIFont fontWithName:@"PingFangSC-Medium" size:23];

#pragma mark - UserDefault
//  用户token
#define USER_CID                                                      [[NSUserDefaults standardUserDefaults] stringForKey:@"userCID"]
#define USER_NAME                                                     [[NSUserDefaults standardUserDefaults] stringForKey:@"USER_NAME"]
#define USER_TOKEN                                                  [[NSUserDefaults standardUserDefaults] stringForKey:@"userToken"]
#define USER_TOKEN_CREATE_TIME                            [[NSUserDefaults standardUserDefaults] stringForKey:@"userTokenCreateTime"]
// token 过期的时间段
#define USER_TOKEN_EXPIRED_TIME                           [[NSUserDefaults standardUserDefaults] stringForKey:@"userTokenExpiredTime"]
#define USER_REFRESH_TOKEN                                   [[NSUserDefaults standardUserDefaults] stringForKey:@"userRefreshToken"]
// refresh token 过期的时间段
#define USER_REFRESH_TOKEN_EXPIRED_TIME            [[NSUserDefaults standardUserDefaults] stringForKey:@"userRefreshTokenExpiredTime"]
// App crash
#define APP_CRASH_NAME                                           [[NSUserDefaults standardUserDefaults] stringForKey:@"appCrashName"]
#define APP_CRASH_REASON                                       [[NSUserDefaults standardUserDefaults] stringForKey:@"appCrashReason"]
#define APP_CRASH_STACK                                          [[NSUserDefaults standardUserDefaults] stringForKey:@"appCrashStackArray"]
#define APP_CRASH_INFO                                            [[NSUserDefaults standardUserDefaults] stringForKey:@"appCrashInfo"]
// 记录内容存储数组 [0]-内容id, [1]-内容, [2]-几颗星, [3]-是否重要, [4]-给谁回复, [5]-内容类型
#define HIC_EDITED_INFO_BEFORE                              [[NSUserDefaults standardUserDefaults] objectForKey:@"HICEditedInfoBefore"]
// 记录是否弹过收集提示弹窗
#define HIC_COLLECTION_HINT_SHOWN                      [[NSUserDefaults standardUserDefaults] boolForKey:@"HICCollectionHintShown"]
// 存储最新数据库版本号
#define HIC_DBVERSION                                             [[NSUserDefaults standardUserDefaults] stringForKey:@"HICDBVersion"]
// 引导图是否已经显示
#define HIC_INTRO_VERSION                                      [[NSUserDefaults standardUserDefaults] stringForKey:@"HICIntroVersion"]

#pragma mark - - - 储存系统下发域名 - - - start
// 存储的系统端下发的登录域名
#define HIC_ACC_DOMAIN                                           [[NSUserDefaults standardUserDefaults] stringForKey:@"HICAccDomain"]
// 存储的系统端下发的评论域名
#define HIC_COMMENT_DOMAIN                                  [[NSUserDefaults standardUserDefaults] stringForKey:@"HICCommentDomain"]
// 存存储的系统端下发的考试域名
#define HIC_EXAM_DOMAIN                                         [[NSUserDefaults standardUserDefaults] stringForKey:@"HICExamDomain"]
// 阿里deviceID
#define ALI_DEVICE_ID                                               [[NSUserDefaults standardUserDefaults] stringForKey:@"HICAliDeviceID"]
#pragma mark - - - 储存系统下发域名 - - - end

#pragma mark - 单例
#define SystemManager       [HICSystemManager shared]
#define NetManager          [HICNetManager shared]
#define LoginManager        [HICLoginManager shared]
#define LogManager          [HICLogManager shared]
#define DLManager           [HICDownloadManager shared]
#define M3U8Manager         [HICM3U8Manager shared]
#define ExamManager         [HICExamManager shared]
#define DBManager           [HICDBManager shared]
#define TrainManager        [HICTrainManager shared]
#define EnrollManager       [HICEnrollManager shared]
#define QuestionManager     [HICQuestionManager shared]
#define LiveManager         [HICLiveManager shared]
#define RoleManager         [HICRoleManager shareInstance]
#pragma mark - 常用Sizes
//真机与切图尺寸的比例因数，切图上给出的尺寸乘以该因数即为真正的尺寸
#define HIC_Divisor         (HIC_ScreenWidth / 750.0)
#define HIC_DivisorH        (HIC_ScreenHeight/1334.0)
// 多少列
#define PH_COLLECTION_CELL_SECTION              4
// 列表间隔距离
#define PH_COLLECTION_CELL_INTER_ITEM_SAPCING   2
// photo collectionView cell 大小
#define PH_COLLECTION_CELL_HEIGHT   (HIC_ScreenWidth - (PH_COLLECTION_CELL_SECTION + 1)*PH_COLLECTION_CELL_INTER_ITEM_SAPCING) / PH_COLLECTION_CELL_SECTION
#define PH_TABLE_CELL_HEIGHT    61.5

// 任务中心
// 任务中心第一部分高度
#define TC_SECTION1_HEIGHT                  220

// 学习-课程下载cell高度
#define STUDY_DOWNLOAD_CELL_HEIGHT          50

// 我的-课程下载cell高度
#define MY_DOWNLOAD_CELL_HEIGHT             (16 + 73)

// 消息中心cell高度
#define MSG_CENTER_CELL_HEIGHT              (80)

// 消息中心-群消息cell高度
#define MSG_CENTER_GROUP_MSG_CELL_HEIGHT    (84)

// 作业列表-第一行cell高度
#define HOMEWORK_FIRST_CELL_HEIGHT          (87.5)

// 作业列表-其余
#define HOMEWORK_OTHER_CELL_HEIGHT          (125)

#pragma mark - 录音相关设置 - 聊天资源路径
#define kHMBMinRecordTime 1
#define kHMBMaxRecordTime 60
#pragma mark -
//Caches目录
#define CachesPatch NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0]
//语音WAV路径
#define kHMBPath_voice_wav [HICCommonUtils getCreateFilePath:[NSString stringWithFormat:@"%@/APPData/Chat/Voice/WAV",CachesPatch]]
//语音AMR路径
#define kHMBPath_voice_amr [HICCommonUtils getCreateFilePath:[NSString stringWithFormat:@"%@/APPData/Chat/Voice/AMR",CachesPatch]]
//图片路径
#define kHMBPath_image [HICCommonUtils getCreateFilePath:[NSString stringWithFormat:@"%@/APPData/Chat/Image",CachesPatch]]
//Gif路径
#define kHMBPath_gif [HICCommonUtils getCreateFilePath:[NSString stringWithFormat:@"%@/APPData/Chat/Gif",CachesPatch]]
//视频路径
#define kHMBPath_video [HICCommonUtils getCreateFilePath:[NSString stringWithFormat:@"%@/APPData/Chat/Video",CachesPatch]]
//视频第一帧图片路径
#define kHMBPath_video_image [HICCommonUtils getCreateFilePath:[NSString stringWithFormat:@"%@/APPData/Chat/VideoImage",CachesPatch]]

#endif /* HICHeader_h */


