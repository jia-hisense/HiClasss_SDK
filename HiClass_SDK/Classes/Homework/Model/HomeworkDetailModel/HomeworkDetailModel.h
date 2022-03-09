//
//  HomeworkDetailModel.h
//  HiClass
//
//  Created by 铁柱， on 2020/3/28.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeworkDetailAttachmentModel : NSObject
/// 附件id
@property(nonatomic, assign) NSInteger attId;
/// 附件类型 1：视频，2：音频，3：文字，4：图片
@property(nonatomic, assign) NSInteger type;
/// 附件完整url
@property(nonatomic, copy) NSString *url;

@end

///
@interface HomeworkDetailModel : NSObject

/// 子任务执行结果id
@property(nonatomic, assign) NSInteger jobRetId;
/// 子任务id
@property(nonatomic, assign) NSInteger jobId;
/// 作业子任务要求
@property (nonatomic, copy) NSString *requires;
/// 奖励积分
@property(nonatomic, assign) NSInteger rewardPoints;
/// 单任务上传音频个数<=
@property(nonatomic, assign) NSInteger audioNumMax;
/// 单任务上传APP端音频时长<=，单位秒
@property(nonatomic, assign) NSInteger audioAppDurationMax;
/// 单任务上传Web端音频大小<=，单位M
@property(nonatomic, assign) NSInteger audioWebSizeMax;
/// 单任务上传视频个数<=
@property(nonatomic, assign) NSInteger videoNumMax;
/// 单任务上传视频大小<=，单位M
@property(nonatomic, assign) NSInteger videoSizeMax;
/// 单任务上传图片个数<=
@property(nonatomic, assign) NSInteger picNumMax;
/// 单任务上传图片大小<=，单位M
@property(nonatomic, assign) NSInteger picSizeMax;
/// 单任务字数限制>=
@property(nonatomic, assign) NSInteger wordsNumMin;
/// 子任务执行结果提交时间
@property(nonatomic, assign) NSInteger commitTime;
/// 老师查看时间
@property(nonatomic, assign) NSInteger viewTime;
/// 老师批阅时间
@property(nonatomic, assign) NSInteger reviewTime;
/// 批阅人
@property(nonatomic, copy) NSString *reviewerName;
/// 是否精华(1:是，0:否)
@property(nonatomic, assign) NSInteger essence;
/// 执行结果的分数
@property(nonatomic, assign) NSInteger score;
/// 是否合格
@property(nonatomic, assign) NSInteger pass;
/// 是否退回重写(1:是 0:否，2:学生撤回)
@property(nonatomic, assign) NSInteger rejected;
/// 老师评语
@property(nonatomic, copy) NSString *evaluation;
/// 文本答案(富文本)
@property(nonatomic, copy) NSString *textContent;
/// 任务类型，1：视频，2：音频，3：文字，4：图片，支持多选，多个值以逗号分隔
@property(nonatomic, copy) NSString *jobTypes;
/// 作业描述
@property(nonatomic, copy) NSString *jobComment;
/// 作业提示
@property(nonatomic, copy) NSString *jobReminder;
/// 是否需要批阅 1：是 0：否
@property(nonatomic, assign) NSInteger reviewFlag;
///"maxScore": "int,optional,总分",
@property (nonatomic ,assign) NSInteger maxScore;
///"passScore": "int,optional,合格分数",
@property (nonatomic ,assign) NSInteger passScore;
/// 附加数组
@property (nonatomic, strong) NSArray<HomeworkDetailAttachmentModel*> *attachments;


/// 模型转化方法
/// @param dic 服务器数据
+(instancetype)createModeWithDataSource:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
