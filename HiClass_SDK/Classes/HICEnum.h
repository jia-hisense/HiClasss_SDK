//
//  HICEnum.h
//  HiClass
//
//  Created by Eddie Ma on 2020/1/15.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#ifndef HICEnum_h
#define HICEnum_h

typedef NS_ENUM(NSInteger, HICCertStatus) {
    // 证书正常
    HICCertNormal = 1,
    // 已经失效
    HICCertInvalided,
    // 已经吊销
    HICCertRevoke,
    // 即将失效
    HICCertWillInvalid,
};

typedef NS_ENUM(NSInteger, HICNetStatus) {
    // 未知网络
    HICNetUnknown= 0,
    // 未能联网
    HICNetNotReachable,
    // 蜂窝数据
    HICNetWWAN,
    // wifi
    HICNetWiFi,
};

/// 作业完成状态
typedef NS_ENUM(NSInteger, HICTaskType) {
    HICTaskTypeUnknown = 0,
    /// 考试
    HICTaskTypeExam,
    /// 培训
    HICTaskTypeTrain,
    /// 问卷
    HICTaskTypeQuestionnaire,
    /// 报名
    HICTaskTypeEnroll,
    //直播
    HICTaskTypeLive = 6,
};

/// 作业完成状态
typedef NS_ENUM(NSInteger, HICHomeworkStatus) {
    /// 未知
    HICHomeworkUnknown = 0,
    /// 未开始
    HICHomeworkNotStart = 1,
    /// 待完成
    HICHomeworkWaitForCompleting = 2,
    /// 待批阅
    HICHomeworkWaitForGrading = 3,
    /// 批阅中
    HICHomeworkGrading = 4,
    /// 已完成
    HICHomeworkCompleted = 5,
};

/// 账号接口返回错误
typedef NS_ENUM(NSInteger, HICVideoDefinition) {
    /// 标清
    HICDefinitionNormal = 11,
    /// 高清
    HICDefinitionHigh = 21,
    /// 超清
    HICDefinitionSuper = 31,
    /// 4K
    HICDefinition4K = 41,
};

/// 账号接口返回错误
typedef NS_ENUM(NSInteger, HICMsgType) {
    /// 未知类型
    HICMsgTypeUnknown = 0,
    /// 任务
    HICMsgTypeTask = 1,
    /// 待办
    HICMsgTypeToDo = 2,
    /// 内容互动
    HICMsgTypeInteract = 3,
    /// 群消息
    HICMsgTypeGroupMsg = 4,
    /// 评论
    HICMsgTypeComment = 5
};

/// 账号接口返回错误
typedef NS_ENUM(NSInteger, HICAccErrorCode) {
    /// 系统错误
    HICAccSysError = 100001,
    /// 查询的数据(账号)不存在
    HICAccNoAccount = 201019,
    /// Invalid parameter
    HICAccInvalidParam = 201923,
    /// Too frequent request
    HICAccTooFreq = 601014,
    /// 验证码错误
    HICAccAuthCodeWrong = 601013,
    /// 密码错误
    HICAccPassWrong = 202012,
    /// 请使用OA账号登录
    HICAccUseOA = 202061,
    /// 强制用户修改密码
    HICAccModifyPass = 202062,
    /// 账号被锁定
    HICAccAccountLocked = 202063,
    /// 账号被禁用
    HICAccAccountBanned = 202064,
    /// 身份证号已存在
    HICAccIDExisted = 202065,
    /// 要添加的数据已存在
    HICAccDataExisted = 202066,
    /// 短信验证码：校验次数错误超过5次。
    HICAccAuthCodeMoreThan5Times = 201078,
    /// 验证码不一致
    HICAccAuthCodeNotEqual = 201079,
};

typedef NS_ENUM(NSInteger, HICUrlType) {
    /// 账号类型
    DefaultAccURLType = 0,
    /// 考试类型
    DefaultExamURLType,
    // 评论类型
    DefaultCommentURLType,
    /// 系统配置请求
    DefaultSystemConfigType,
    /// 应用升级
    DefaultAppUpgrade,
    /// 推送
    DefaultAppPush,
    
};

typedef NS_ENUM(NSInteger, HICCommentType) {
    /// 发表评论
    HICCommentWrite = 0,
    /// 回复评论
    HICCommentReply = 1,
    /// 添加笔记
    HICCommentNote = 2,
};

typedef NS_ENUM(NSInteger, HICStudyBtmViewType) {
    /// 课程
    HICStudyBtmViewCourse = 0,
    /// 知识
    HICStudyBtmViewKnowledge = 1,
};

typedef NS_ENUM(NSInteger, HICCommentActions) {
    /// 发表评论
    HICThumbupAction = 0,
    /// 回复评论
    HICReplyAction = 1,
    /// 添加笔记
    HICDeleteAction = 2,
};

typedef NS_ENUM(NSInteger, HICDownloadStatus) {
    /// 空闲，无下载
    HICDownloadIdle = 0,
    /// 从0下载中
    HICDownloading = 1,
    /// 下载暂停
    HICDownloadStop = 2,
    /// 继续下载中
    HICDownloadResume = 3,
    /// 下载完成
    HICDownloadFinish = 4,
};

typedef NS_ENUM(NSInteger, HICMineType) {
    /// 我的笔记
    HICMyNote = 0,
    /// 我的收藏
    HICMyCollect = 1,
    /// 我的学习记录
    HICMyStudyRecord = 2,
};
typedef NS_ENUM(NSInteger, HICMineWorkSpaceType) {
    /// 试卷审核
    HICExamAudit = 1,
    ///试题审核
    HICQuestionAudit = 2,
    /// 报名审核
    HICMyRegisterAudit = 8,
    /// 知识审核
    HICKnowledgeAudit = 5,
    ///实操成绩审核
    HICGradeAudit = 100
};
typedef NS_ENUM(NSInteger, HICStudyResourceType) {
    /// 图片
    HICPictureType = 0,
    /// 视频
    HICVideoType = 1,
    /// 音频
    HICAudioType = 2,
    ///文档
    HICFileType = 3,
    ///压缩包
    HICZipType = 4,
    ///scrom
    HICScromType = 5,
    ///html
    HICHtmlType = 6,
    ///嵌入第三方播放器
    HICWebVideoType = 7
};
typedef NS_ENUM(NSInteger, HICTrainTaskType) {
    /// 课程
    HICCourseType = 1,
    /// 知识
    HICKonwledeType = 2,
    ///考试
    HICExamType = 3,
    ///作业
    HICHomeWorkType = 4,
    ///问卷
    HICQuestionType = 6,
    ///评价
    HICAppraiseType = 7,
    ///线下成绩
    HICOfflineGradeType = 11,
    ///实操
    HICHandsOn = 12
};
typedef NS_ENUM(NSInteger, HICExamStatusType) {
    /// 待考
    HICExamWait = 0,
    /// 进行中
    HICExamProgress = 1,
    /// 批阅
    HICExamMark = 2,
    ///已完成
    HICExamFinish = 3,
    ///缺考
    HICExamAbsent = 4,
};
///0-未发布、1-进行中、2-已结束、3-已归档"
typedef NS_ENUM(NSInteger, HICExamStatusArrangeType) {
    /// 未发布、
    HICExamArrangeUnrelessed = 0,
    /// 进行中
    HICExamArrangeProgress = 1,
    /// 已结束
    HICExamArrangeEnd = 2,
    ///已归档
    HICExamArrangeArchive = 3,
  
};
typedef NS_ENUM(NSInteger, HICWorkStatusType) {
    ///待开始
    HICWorkWait = 0,
    /// 进行中
    HICDoHomeWork = 1,
    /// 待批阅
    HICWorkWaitMark = 3,
    ///批阅中
    HICWorkMarking = 4,
    ///已完成
    HICWorkFinish = 5,
};
typedef NS_ENUM(NSInteger, HICMyInfoTitle) {
    /// 评论
    HICMyInfoComment = 0,
    /// 收藏
    HICMyInfoCollect = 1,
    /// 笔记
    HICMyInfoNote = 2,
    ///下载内容
    HICMyInfoDownload = 3,
    ///证书
    HICMyInfoCertificate = 4,
};
typedef NS_ENUM(NSUInteger, HICMyRankType) {
    HICMyRankScore = 3,
    HICMyRankPoints = 4,
    HICMyRankTime = 5
    
};
typedef NS_ENUM(NSUInteger, HICTrainProgressStatus) {
    HICTrainInProgress = 1,
    HICTrainWait = 2,
    HICTrainFinished = 3,
    HICTrainAll = 0
};
typedef NS_ENUM(NSUInteger, HICTrainLevel) {
    HICTrainGroupLevel = 1,
    HICTrainCompanyLevel = 2,
    HICTrainDepartmentLevel = 3,
};
///1-默认计划，2-学习计划，线下培训、混合培训：11-分内部培训，12-外请内训，13-外送培训",
typedef NS_ENUM(NSUInteger, HICTrainCat) {
    HICTrainDefaultPlan = 1,
    HICTrainStudyPlan = 2,
    HICTrainInsidePlan = 11,
    HICtrainOutsidePlan = 12,
    HICtrainOutwardPlan = 13
};
typedef NS_ENUM(NSUInteger, HICTrainGrade) {
    HICTrainGradeQualified = 1,
    HICTrainGradeNoQualified = 2,
    HICTrainGradeUndergraduate = 0,
};
typedef NS_ENUM(NSUInteger, HICAttendanceError) {
    ///错误的签到口令
    HICAttError = 10019,
    ///尚未到可以签到时间
    HICAttNotTime = 500802,
    ///已过签到时间
    HICAttOveredTime= 500803,
    ///尚未到可以签退时间
    HICSignOffNotime = 500804,
    ///已过签退时间
    HICSignOffOveredTime = 500805
};
typedef NS_ENUM(NSUInteger, HICOfflineTaskType) {
    ///课程
    HICOnLineTaskCourse = 1,
    ///知识
    HICOfflineTaskKnowledge = 2,
    ///考试
    HICOfflineTaskExam = 3,
    ///作业
    HICOfflineTaskHomework = 4,
    ///问卷
    HICOfflineTaskQuestion = 6,
    ///评价
    HICOfflineTaskAppraise = 7,
    ///线下课
     HICOfflineCourse = 8,
    ///-签到
    HICOfflineTaskSignOn = 9,
    ///签退
    HICOfflineTaskSignOff = 10,
    ///线下成绩
    HICOfflineCourseGrade = 11
};
typedef NS_ENUM(NSUInteger, HICOfflineGrade) {
    ///合格
    HICOfflineGradeQualified = 5,
    ///不合格
    HICOfflineGradeNoQualified = 1,
    ///良好
    HICOfflineGradeGood = 10,
    ///优秀
    HICOfflineGradeGrate = 15
};
typedef NS_ENUM(NSUInteger, HICReportType) {
    HICReportCourseType = 6,
    HICReportKnowledgeType = 7,
};
typedef NS_ENUM(NSUInteger, HICReportTaskType) {
    ///作业
    HICReportHomeWorkType = 1,
    ///问卷
    HICReportQuestionType = 2,
    ///考试
    HICReportExamType = 4,
    /// 报名
    HICReportEnrollType = 8,
    /// 培训
    HICReportTrainType = 12,
    ///评价
    HICReportAppraiseType = 13,
    ///岗位地图
    HICReportMapType = 20
};
typedef NS_ENUM(NSUInteger, BaseCellBorderStyle) {
    BaseCellBorderStyleNoRound = 0,
    BaseCellBorderStyleTopRound,
    BaseCellBorderStyleBottomRound,
    BaseCellBorderStyleAllRound,
};
typedef NS_ENUM(NSUInteger, HICEnrollUserRegisterStatus) {
    ///未报名
    HICNotRegister = 0,
    ///审核中
    HICAuditing = 116,
    ///正式学员
    HICFormalStudent = 121,
    ///替补学员
    HICSubstituteStudent = 126,
    ///放弃资格
    HICDisqualification = 131,
    ///取消资格
    HICCancelQualification = 136,
    ///报名失败
    HICEnrollFaild = 141
};
typedef NS_ENUM(NSUInteger, HICEnrollRegisterStatus) {
    ///进行中
    HICEnrollInProgress = 5,
    ///暂停
    HICEnrollPause = 7,
    ///管理员手动结束
    HICEnrollHandEnd = 10,
};
typedef NS_ENUM(NSUInteger, HICEnrollStatus) {
    ///未报名
    HICEnrollNotRegister = 1,
    ///已报名
    HICEnrolled = 2,
    ///已过期
    HICEnrollExpired = 3,
};
typedef NS_ENUM(NSUInteger, HICQuestionStatus) {
    ///待参与
    HICQuestionWait = 2,
    ///已完成
    HICQuestionFinished = 5,
    ///已过期
    HICQuestionExpired = 6,
};
typedef NS_ENUM(NSUInteger, HICEnrollAuditStatus) {
    ///待审核
    HICEnrollAuditWait = 0,
    ///审核通过
    HICEnrollAuditInprogress = 2,
    ///审核拒绝
    HICEnrollAuditReject = 3
};
typedef NS_ENUM(NSUInteger, HICLiveStatus) {
    HICLiveInProgress = 2,
    HICLiveWait = 1,
    HICLiveEnd = 3,
};
/// 网络错误类型
typedef NS_ENUM(NSInteger, HICNetErrorType) {
    /// 网络请求成功，但是系统端返回错误码
    HIC_NET_ERROR_FROM_SERVER,
    /// 网络请求失败，并接口无法调通
    HIC_NET_ERROR_FROM_LOCAL
};

/// Ser日志类型 根据此枚举区分event
typedef NS_ENUM(NSInteger, HICSerLogEventType) {
    ///课程知识详情上报日志类型
    /// start
    HICStudyLogTypeStart,
    /// end
    HICStudyLogTypeEnd,
    ///30s
    HICStudyLogTypeTiming,
    ///课程知识详情上报日志类型
    /// 首页- search
    HICFirstSearch,
    ///  首页-scan
    HICFirstScan,
    /// 首页-具体知识和课程点击
    HICFirstKnowledgeClick,
    /// 首页-具体任务点击
    HICFirstOtherTaskClick,
    /// 首页-讲师点击
    HICFirstLectureClick,
    /// 首页-任务类型点击
    HICFirstTaskTypeClick,
    /// 首页-全部知识入口
    HICFirstAllKnowledge,
    /// 首页-点击到排行榜
    HICFirstRankClick,
    ///任务中心任务类型点击
    HICTaskCenterTaskType,
    ///任务中心具体任务点击
    HICTaskClick,
    ///任务中心不同任务类型各tab点击
    HICTaskTabClick,
    ///扫码跳转到知识
    HICScanJumpClick,
    ///培训-在线学习详情页点击课程和知识
    HICTrainOnlineKnowledgeClick,
    ///培训-在线学习详情页点击任务
    HICTrainOnlineTaskClick,
    ///课程和知识详情页按钮点击
    HICCourseDetailClick,
    ///课程详情页目录点击知识
    HICCourseIndexClickKnowledge,
    ///课程详情页目录点击任务
    HICCourseIndexClickTask,
    ///  相关推荐点击到知识和课程
    HICRecommendClick,
    ///练习题点击
    HICExamClick,
    /// 练习题完成一题
    HICExamFinishedOne,
    ///讲师详情页知识tab下点击到课程和知识
    HICLectureClick,
    ///讲师详情页线下课程参考资料点击
    HICLectureOfflineCourseClick,
    ///岗位学习详情页点击知识和课程
    HICPosKnowledgeClick,
    ///岗位学习详情页点击任务
    HICPosTaskClick,
    ///全部知识详情页-点击知识和课程
    HICAllKnowledgeClick,
    /// 通知-任务通知点击
    HICNotiClick,
    ///通知-评论点击到知识课程
    HICNotiCommentClickToKnowledge,
    /// 我的-学习记录点击到知识课程详情页
    HICMyRecordClickToKnowledge,
    /// 我的-评论点击到知识课程详情页
    HICMyCommentToKnowledge,
    /// 我的-收藏点击到知识课程详情页
    HICMyCollectToKnowledge,
    /// 我的-笔记点击到知识课程详情页
    HICMyNoteToKnowledge,
    ///我的-下载内容点击到知识课程详情页
    HICMyDownloadToKnowledge,
    ///课程知识详情页曝光日志上报
    HICStudyExplosion,
    //回看上传
    HICPlayBackUpload,
    //直播回看结束
    HICPlayBackEnd,
    //直播列表上报
    HICLiveCenter,
    //点击回看按钮上报
    HICPlayBackBtn
};

typedef NS_ENUM(NSInteger, HICAppLogEventType) {
    ///应用启动
    HIC_APP_START,
};

/// Dot日志类型 根据此枚举区分event
typedef NS_ENUM(NSInteger, HICDotLogEventType) {
    HIC_DOTLOG_UNKNOWN,
};

/// Exc日志类型 根据此枚举区分event
typedef NS_ENUM(NSInteger, HICExcLogEventType) {
    /// 应用异常退出 099199
    HIC_EXCLOG_APP_TERMINATION,
    /// 应用接口异常 099198
    HIC_EXCLOG_API_FAILED
};

/**
 *  资源类型
 */
typedef enum {
    HMBMessageFileType_image = 1,    //image类型
    HMBMessageFileType_wav,          //wav类型
    HMBMessageFileType_amr,          //amr类型
    HMBMessageFileType_gif,          //gif类型
    HMBMessageFileType_video,        //video类型
    HMBMessageFileType_video_image,  //video图片类型
}HMBMessageFileType;

/**
 *  资源类型
 */
typedef enum {
    HICHomeworkAgainFileType_unknow = 0,   //不是任何类型
    HICHomeworkAgainFileType_video = 1,    //video类型
    HICHomeworkAgainFileType_voic,         //音频类型
    HICHomeworkAgainFileType_string,       //文字类型
    HICHomeworkAgainFileType_image,        //图片类型
}HICHomeworkAgainFileType;

/**
 *  资源类型
 */
typedef enum {
    HICAppBundleIdenHiClass = 0,  // 海信学堂
    HICAppBundleIdenZhiYu = 1,    //知渔
    HICAppBundleIdenSDK = 99,     //其他App调用了HiSDK
} HICAppBundleIden;

#endif /* HICEnum_h */
