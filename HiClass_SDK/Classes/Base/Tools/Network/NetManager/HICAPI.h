//
//  HICAPI.h
//  HiClass
//
//  Created by jiafujia on 2021/10/28.
//  Copyright © 2021 hisense. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HICKnowledgeDownloadModel.h"
NS_ASSUME_NONNULL_BEGIN
/// 请求成功的block
typedef void(^Success)( NSDictionary * responseObject);
/// 请求失败的block
typedef void(^Failure)( NSError *error);

@interface HICAPI : NSObject

/// 绑定阿里id和账号（SDK内部完成，当前业务无需调用此方法）
+ (void)requestToBindAliIdAndAccount;

/// 查询直播课各状态总数
+ (void)getLiveStateNum:(Success)success;
///直播列表
+ (void)getLiveList:(NSInteger)status success:(Success)success failure:(Failure)failure;
///进入直播间
+ (void)getRoomNumWithID:(NSNumber *)lessonId success:(Success)success failure:(Failure)failure;
///查询问卷各状态数量
+ (void)getQuestionnaireStateNum:(Success)success;
///问卷列表
+ (void)getQuestionnaireList:(NSInteger)status success:(Success)success failure:(Failure)failure;
///查询报名各状态数量
+ (void)getRegistrationStateNum:(Success)success;
///报名列表
+ (void)getRegistrationList:(NSInteger)status success:(Success)success failure:(Failure)failure;
/////报名详情
//+ (void)registrationDetail:(NSNumber *)registerID trainId:(NSNumber *)trainId success:(Success)success failure:(Failure)failure;
///报名编辑
+ (void)doRegisterWithType:(NSDictionary *)dic success:(Success)success;
///报名催办
+ (void)forceReview:(NSNumber *)auditInstanceId;
///报名编辑
+ (void)doRegisterWithString:(NSMutableDictionary *)dic success:(Success)success;
///审核模板详情
+ (void)getDataReviewTemplate:(NSNumber *)auditTemplateID success:(Success)success;
///获取审核状态
+ (void)getDataReviewProgressStatus:(NSNumber *)auditTemplateID success:(Success)success;
///审核人搜索
+ (void)searchReviewer:(NSMutableDictionary *)dic success:(Success)success failure:(Failure)failure;
///培训安排
+ (void)trainingArrangement:(NSInteger)trainId success:(Success)success failure:(Failure)failure;
///考勤签到签退
+ (void)checkInAndSignOut:(NSDictionary *)dic success:(Success)success failure:(Failure)failure;
///学员线下课详情
+ (void)lineClassDetails:(NSDictionary *)dic success:(Success)success;
///课程安排
+ (void)curriculum:(NSNumber *)trainId  success:(Success)success;
///线下培训详情
+ (void)offlineTrainingDetail:(NSInteger)trainId success:(Success)success failure:(Failure)failure;
///报名详情
+ (void)registrationDetail:(NSDictionary *)dic success:(Success)success failure:(Failure)failure;
///讲师线下课程详情
+ (void)instructorOfflineCourseDetails:(HICNetModel *)netModel   success:(Success)success failure:(Failure)failure;
/// 任务列表
+ (void)taskList:(NSDictionary *)dic success:(Success)success failure:(Failure)failure;
///首页详情
+ (void)homePageDetail:(Success)success failure:(Failure)failure;
///最新学习记录
+ (void)getLastLearningRecord:(Success)success;
///查询课程知识内容
+ (void)queryCourseKnowledgeContent:(NSDictionary *)dic success:(Success)success failure:(Failure)failure;
///目录查询
+(void)directoryQuery:(NSString *)dir success:(Success)success failure:(Failure)failure;
///搜索讲师和课程
+ (void)searchTeacherAndCourse:(NSDictionary *)dic success:(Success)success failure:(Failure)failure;
///岗位地图-路线
+(void)postMapRoute:(Success)success failure:(Failure)failure;
///岗位要求
+(void)postRequirement:(NSInteger)ID success:(Success)success failure:(Failure)failure;
///培训详情-统计信息
+ (void)getRightAlertLoadData:(NSNumber *)trainId success:(Success)success;
///同步进度
+ (void)syncProgress:(NSNumber *)trainId success:(Success)success failure:(Failure)failure;
///更多岗位
+(void)morePost:(NSNumber *)nodeId success:(Success)success;
///证书列表
+(void)loadDataCer:(NSNumber *)trainId success:(Success)success failure:(Failure)failure;
///排行榜列表
+ (void)getRankList:(NSDictionary *)dic success:(Success)success failure:(Failure)failure;
///查询消息状态
+(void)loadDataMessageNum:(NSDictionary *)dic success:(Success)success failure:(Failure)failure;
///课程/知识列表
+(void)loadDataSever:(NSDictionary *)dic success:(Success)success failure:(Failure)failure;

+(void)loadDataUserDetailAndRoleChangeRoot:(Success)success failure:(Failure)failure;

/// 获取系统配置信息
+ (void)getSystemConfiguration;
///讲师线下课程列表
+ (void)lecturerOfflineCourses:(NSDictionary *)dic success:(Success)success failure:(Failure)failure;
///讲师授课日历安排
+ (void)lecturerScheduleLectures:(NSDictionary *)dic success:(Success)success failure:(Failure)failure;
///讲师详情
+ (void)getLectureDetail:(NSDictionary *)dic success:(Success)success;
///用户知识/课程列表查询
+ (void)knowledgeAndCourseEnquiries:(NSDictionary *)dic success:(Success)success;
///作业详情
+ (void)homeWorkDetail:(NSDictionary *)dic success:(Success)success failure:(Failure)failure;
///作业子任务详情
+(void)homeworkSubtaskDetails:(NSDictionary *)dic success:(Success)success;
///作业子任务撤回
+(void)homeworkSubtaskWithdraw:(NSDictionary *)dic success:(Success)success;
///作业子任务提交
+(void)homeworkSubtaskSubmit:(NSDictionary *)dic url:(NSString *)url success:(Success)success failure:(Failure)failure;
///培训管理数量
+ (void)getTrainingManagementNum:(Success)success;
///培训管理列表
+ (void)getTrainingManagementList:(NSInteger)status success:(Success)success failure:(Failure)failure;
///培训学员排名
+ (void)traineesRanking:(NSNumber *)trainId success:(Success)success;
///培训任务列表
+ (void)trainingTaskList:(NSNumber *)trainId success:(Success)success failure:(Failure)failure;
///学员申请实操
+ (void)clickScoreBtnWithType:(NSDictionary *)dic success:(Success)success;
///首页数据查询
+ (void)homePageDataQuery:(Success)success failure:(Failure)failure;
///混合培训安排
+ (void)mixedTrainingArrangement:(NSNumber *)trainId success:(Success)success;
///查询消息列表
+ (void)queryingMessageList:(HICMsgType )msgType success:(Success)success;
///消息管理
+ (void)changeUnreadMsgStatusWithArr:(NSArray *)arr success:(Success)success failure:(Failure)failure;
///我的评论
+ (void)myComment:(NSInteger)pageIndex success:(Success)success failure:(Failure)failure;
///点赞、回复、删除评论\回复
+ (void)LikeReplyDeleteCommentReply:(NSDictionary *)dic success:(Success)success failure:(Failure)failure;
///删除收藏
+(void)deleteCollection:(NSDictionary *)dic url:(NSString *)url success:(Success)success;
///积分任务列表
+ (void)integralTaskList:(Success)success;
///积分明细列表
+(void)IntegralSubsidiaryList:(NSInteger)pageIndex success:(Success)success failure:(Failure)failure;
///证书详情
+ (void)certificateDetails:(NSString *)employeeCertId success:(Success)success;
///证书列表
+ (void)certificateList:(NSDictionary *)dic success:(Success)success;
///待审核任务数量
+ (void)auditedTasksNum:(Success)success failure:(Failure)failure;
///上传头像
+ (void)uploadHeaderWith:(NSString *)picUrl success:(Success)success failure:(Failure)failure;
///学习笔记列表
+ (void)studyNoteList:(Success)success failure:(Failure)failure;
///我的收藏列表
+ (void)myCollectionList:(Success)success failure:(Failure)failure;
///学习记录列表
+ (void)studyRecordList:(Success)success failure:(Failure)failure;
///下载记录上报
+ (void)uploadDownloadRecordWithModel:(HICKnowledgeDownloadModel *)model;
///学习笔记详情
+ (void)studyNoteDetail:(NSDictionary *)dic success:(Success)success failure:(Failure)failure;
///评论列表
+ (void)commentList:(NSDictionary *)dic success:(Success)success failure:(Failure)failure;
///课程、知识详情
+ (void)knowledgeAndCourseDetails:(NSDictionary *)dic success:(Success)success failure:(Failure)failure;
///评论相关接口
+ (void)publishBtnClickedWithContent:(NSString *)content type:(HICCommentType)type starNum:(NSInteger)stars isImportant:(BOOL)important toAnybody:(NSString *)name objectID:(NSNumber *)objectID typeCode:(HICReportType)typeCode success:(Success)success failure:(Failure)failure;
///上报知识课程学习记录
+(void)reportLearningRecords:(NSDictionary *)dic success:(Success)success failure:(Failure)failure;
///练习题列表
+ (void)exercisesList:(NSDictionary *)dic success:(Success)success;
///课程知识相关推荐
+ (void)courseRelatedRecommendation:(NSDictionary *)dic success:(Success)succes;
///获取评论回复
+ (void)commentBack:(NSDictionary *)dic success:(Success)succes;
/// 笔记管理
+ (void)setToImportantClicked:(NSDictionary *)dic url:(NSString *)url success:(Success)success failure:(Failure)failure;
///收藏课程
+ (void)collectionCourse:(NSNumber *)action dic:(NSDictionary *)dic success:(Success)succes failure:(Failure)failure;
///点赞课程
+ (void)thumbupCourse:(NSNumber *)action dic:(NSDictionary *)dic success:(Success)succes failure:(Failure)failure;
//查询考试中心列表
+ (void)examCenterList:(NSDictionary *)dic success:(Success)success failure:(Failure)failure;
//查询考试状态数量
+ (void)examStatesNum:(Success)success;
///检查app更新
+ (void)checkAppUpdate:(Success)success failure:(Failure)failure;
///刷新token
+ (void)refreshToken:(Success)success failure:(Failure)failure;
///登出
+ (void)logout:(Success)success failure:(Failure)failure;
///修改密码
+ (void)confirmBtnClickedWithPass:(NSDictionary *)dic success:(Success)success failure:(Failure)failure;
///修改密码（系统端）
+(void)changePwd:(NSDictionary *)dic success:(Success)success;
///发送手机验证码
+(void)getMsgFromSever:(NSString *)phone success:(Success)success failure:(Failure)failure;
///登录
+ (void)confirmBtnClickedWithAccount:(NSDictionary *)dic success:(Success)success failure:(Failure)failure;
///查询密码
+ (void)getPWDSystem:(Success)success failure:(Failure)failure;
///获取用户隐私协议
+ (void)requestAgreement:(Success)success;
///获取菜单
+(void)loadDataUserRoleChangeRoot:(NSDictionary *)dic success:(Success)success failure:(Failure)failure;
///底部导航查询
+(void)loadDataTabMenuChangeRoot:(Success)success failure:(Failure)failure;
///是否防录屏
+ (void)getSecurityInfo:(Success)success failure:(Failure)failure;
@end

NS_ASSUME_NONNULL_END
