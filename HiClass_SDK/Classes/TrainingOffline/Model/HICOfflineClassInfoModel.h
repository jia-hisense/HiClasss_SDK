//
//  HICOfflineClassInfoModel.h
//  HiClass
//
//  Created by hisense on 2020/4/23.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HICSubTask.h"

NS_ASSUME_NONNULL_BEGIN


typedef enum : NSUInteger {
    GroupNone = 0, // 无评级
    GroupUnqualified = 1, // 不合格
    GroupQualified = 2, // 合格
    GroupWell = 3, //良好
    GroupExcellent = 4 //优秀
} ScoreGroupType;

typedef enum : NSUInteger {
    Image = 0,
    Video,
    Voice,
    Document
} MaterialType;


@interface HICOfflineTransFile : NSObject

@property (nonatomic, strong) NSString *fileUrl; //":"string, required, 转码后文件地址",
@property (nonatomic, assign) NSInteger definition;// ":"int, required, 清晰度类型：11-标清，21高清，31超清，41-4K ,file_type=1有效",
@property (nonatomic, assign) NSInteger size; //":"long, required, 文件大小，单位：byte",
@property (nonatomic, assign) NSInteger length; //":"int, required, 音视频时长，单位：ms，其他类型时，该值为0",
@property (nonatomic, strong) NSString *hashStr; //":"string, required, 文件哈希值",
@property (nonatomic, strong) NSString *pageNum; //":"string, required, 图片当前页码",
@property (nonatomic, strong) NSString *fileFormat; //":"string, required, 图片格式：jpg、png、gif等

@end

@interface HICReferenceMaterial : NSObject
@property (nonatomic, strong) NSString *name; //": "string, required, 参考资料名称",
@property (nonatomic, assign) MaterialType type; //": "int, required, 0-图片，1-视频，2-音频，3-文档",
@property (nonatomic, assign) NSString *docType; //": "string, optional, 知识关联的文件的类型，保存文件后缀即可，例如，excel对应xls，word对应doc",
@property (nonatomic, strong) NSString *url; //": "string, required, 参考资料full url"
@property (nonatomic, strong) NSArray *transFiles; //

- (NSString *)iconOfMaterial;
@end

@interface HICClassPerformRating : NSObject

@property (nonatomic, strong) NSString *reason; //": "string, classPerformRating内必填, 课堂表现得分--原因",
@property (nonatomic, assign) CGFloat points; //": "float, classPerformRating内必填, 课堂表现得分--得分"

@end




@interface HICOfflineClassInfoModel : NSObject

@property (nonatomic, assign) NSInteger curTime;//":"long, required, 系统侧当前时间"
@property (nonatomic, strong) NSString *name; //: "string, required, 课程名称",
@property (nonatomic, assign) NSInteger startTime; //": "long, required, 课程开始时间",
@property (nonatomic, assign) NSInteger endTime; //": "long, required, 课程结束时间",
@property (nonatomic, strong) NSString *location; //": "string, optional, 上课地点",
@property (nonatomic, strong) NSString *comment; //": "string, optional, 课程描述信息",
@property (nonatomic, strong) NSNumber *rewardCredit; //": "float, optional, 奖励学分",
@property (nonatomic, strong) NSNumber *rewardCreditHours; //": "int, optional, 奖励学时",
@property (nonatomic, strong) NSNumber *rewardPoints; //": "int, optional, 奖励积分",
@property (nonatomic, assign) NSInteger lecturerId; //": "long , required", 讲师id
@property (nonatomic, strong) NSString *lecturerName; //": "string , required", 讲师name
@property (nonatomic, strong) NSString *lecturePicUrl; // "string, required, 讲师头像url"
@property (nonatomic, strong) NSString *lecturerPost; //": "string, required, 公司-部门-职位",
@property (nonatomic, strong) NSString *lecturerInfo; //": "string, optional, 讲师简介",
@property (nonatomic, strong) NSString *trainees; //": "string, optional, 培训对象",
@property (nonatomic, strong) NSNumber *temporarilyJoinFlag; //": "int,  是否允许临时加入，1-是，0-否",
@property (nonatomic, strong) NSNumber *hasJoin; //": "int, 当前用户是否是培训学员，1-是，0-否",
@property (nonatomic, strong) NSArray *referenceMaterials; //参考资料

@property (nonatomic, strong) NSNumber *score; //": "float, optional, 成绩",
@property (nonatomic, strong) NSNumber *scoreGroup; //": "int, optional, 评级，1：不合格，5：合格，10：良好，15：优秀",
@property (nonatomic, strong) NSArray *classPerformRating; //课堂表现
@property (nonatomic, strong) NSArray *subTasks;


// 仅课程资源详情接口定义此字段
@property (nonatomic, strong) NSNumber *classDuration; //":"int, optional, 标准课时，单位分钟"
@property (nonatomic, strong, readonly, getter=getClassDurationStr) NSString *classDurationStr;



@property (nonatomic, strong, readonly, getter=getLocationStr) NSString *locationStr;

/// 标准课时
@property (nonatomic, strong, readonly, getter=getCourseHourStr) NSString *courseHourStr;

@property (nonatomic, strong, readonly, getter=getCommentStr) NSString *commentStr;

@property (nonatomic, strong, readonly, getter=getRewardStr) NSString *rewardStr;

@end

NS_ASSUME_NONNULL_END
