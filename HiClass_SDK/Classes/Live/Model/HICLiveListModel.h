//
//  HICLiveListModel.h
//  HiClass
//
//  Created by hisense on 2020/8/18.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/*
 "liveLesson":{
                    "id":"long,直播课ID",
                    "name":"string,直播课主题",
                    "startTime":"long,直播开始时间，秒级时间戳",
                    "endTime":"long,直播结束时间，秒级时间戳",
                    "roomNum":"string,直播间编号，空代表直播间未被创建",
                    "imGroupId":"long,IM群组ID，0代表IM群组未创建",
                    "status":"integer,直播课状态， 1-未开始，2-进行中，3-已结束",
                    "backgroundUrl":"string,直播课封面图",
                    "description":"string,直播课描述"
                },
 */
@interface HICLiveLessonModel:NSObject
@property (nonatomic ,strong)NSNumber *lessonId;
@property (nonatomic ,strong)NSString *name;
@property (nonatomic ,strong)NSNumber *startTime;
@property (nonatomic ,strong)NSNumber *endTime;
@property (nonatomic ,strong)NSString *roomNum;
///"imGroupId":"long,IM群组ID，0代表IM群组未创建",
@property (nonatomic ,strong)NSNumber *imGroupId;
/// "status":"integer,直播课状态， 1-未开始，2-进行中，3-已结束",
@property (nonatomic ,assign)NSInteger status;
@property (nonatomic ,strong)NSString *backgroundUrl;
@property (nonatomic ,strong)NSString *lessonDes;
@property (nonatomic, strong)NSNumber *points;
@end


@interface HICLiveListModel : NSObject
@property (nonatomic ,strong)HICLiveLessonModel *liveLesson;
@property (nonatomic ,strong)NSDictionary *playBackInfo;
@property (nonatomic ,strong)NSArray *lessonTeacherList;
@property (nonatomic ,strong)NSArray *lessonAttachmentList;
@property (nonatomic ,strong)NSArray *lessonQuestionList;
@property (nonatomic ,strong)NSArray *lessonGroupList;
@property (nonatomic ,strong)NSString *teacherName;
@end

/**
 {
                   "liveLessonId": "long,直播课ID",
                        "serial": "string,第三方房间号",
                        "playbackFlag": "integer,是否录制回看标识，0-否 1-是，默认1",
                        "playbackParam": "string,回看录制件列表，json字符串"
                    }
 */
@interface HICLivePlayBackInfo :NSObject
@property (nonatomic ,strong)NSNumber *liveLessonId;
@property (nonatomic ,strong)NSString *serial;
@property (nonatomic ,assign)NSInteger playbackFlag;
@property (nonatomic ,strong)NSString *playbackParam;
@end
/**
 {
     "liveLessonId":"long,直播课ID",
     "url":"string,回看URL",
     "size":"string,回看大小，单位：byte",
     "duration":"string,回看时长，秒值"
 }
 */
@interface HICLiveTeacherModel :NSObject
@property (nonatomic ,strong)NSNumber *customerId;
@property (nonatomic ,strong)NSString *name;
@property (nonatomic ,strong)NSString *picUrl;
@property (nonatomic ,strong)NSString *positions;
@property (nonatomic ,strong)NSString *synopsis;
@end
/**
 {
                        "id":"long,附件ID",
                        "name":"string,附件名称",
                        "type":"integer,附件类型，1-视频，2-pdf，3-ppt，默认1",
                        "size":"long,附件大小，单位；byte，默认0",
                        "uniqueId":"string,附件ess关联ID"
                    }

 */
@interface HICLiveAttachmentModel :NSObject
@property (nonatomic ,strong)NSNumber *attachtemtId;
@property (nonatomic ,strong)NSString *name;
@property (nonatomic ,assign)NSInteger type;
@property (nonatomic ,strong)NSNumber *size;
@property (nonatomic ,strong)NSString *uniqueId;
@end
/**
 {
 "id":"long,练习题ID",
 "type":"integer,题型，1-单选，2-多选，3-判断，默认1",
 "options":"string,选项，多个选项逗号隔开",
 "answer":"string,正确答案，多个选项逗号隔开",
 "useFlag":"integer,出题标识：0-未出题 1-已出题，默认0",
 "displayOrder":"integer,展示顺序号，默认0",
 "topicRemark":"string,题干备注"
 }
 */
@interface HICLiveLessonQuestionModel : NSObject
@property (nonatomic ,strong)NSNumber *exciseId;
@property (nonatomic ,assign)NSInteger type;
@property (nonatomic ,strong)NSString *options;
@property (nonatomic ,strong)NSString *answer;
@property (nonatomic ,assign)NSInteger useFlag;
@property (nonatomic ,assign)NSInteger displayOrder;
@property (nonatomic ,strong)NSString *topicRemark;
@end
/**
 {
                       "id":"long,战队明细ID",
                       "groupId":"long,战队ID",
                       "name":"string,战队名称",
                       "points":"integer,战队积分，默认0"
                   }
 */
@interface HICLiveGroupModel:NSObject
@property (nonatomic ,strong)NSNumber *groupDetailId;
@property (nonatomic ,strong)NSNumber *groupId;
@property (nonatomic ,strong)NSNumber *points;
@property (nonatomic ,strong)NSString *name;
@end
@interface HICLiveStatusModel : NSObject
@property (nonatomic ,assign)NSInteger status;
@property (nonatomic ,assign)NSInteger count;
@end
/**
 "liveRoom": {
   "roomNum": "string,直播间编码，空字符串代表直播间未创建",
   "name": "string,直播间名称",
   "imGroupId": "long,IM群组编号，0代表IM群组未创建"
 }
 
 */
@interface HICLiveRoomModel : NSObject
@property (nonatomic, strong)NSString *roomNum;
@property (nonatomic, strong)NSString *name;
@property (nonatomic, strong)NSNumber *imGroupId;
@property (nonatomic, strong)NSNumber *status;
@end
NS_ASSUME_NONNULL_END
