//
//  HICCourseModel.h
//  HiClass
//
//  Created by WorkOffice on 2020/2/14.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/*
 "desc": "string,课程知识描述",
          "contributor": "string,课程知识描述"
 */
@interface HICCourseModel : NSObject
@property (nonatomic ,assign) NSInteger courseKLDType;///"integer,类型（6-课程，7-知识）"
@property (nonatomic ,strong) NSNumber *courseKLDId;///"long,课程知识ID"
@property (nonatomic ,strong) NSString *courseKLDName;///"string,课程知识名称"
@property (nonatomic ,strong) NSString *coverPic;///"string,封面图URL"
@property (nonatomic ,assign) NSInteger resourceType;///"string,资源类型（针对知识）"
@property (nonatomic ,copy)   NSString *partnerCode;///"string,资源类型（针对知识）"
@property (nonatomic ,strong) NSString *resourcePic;///"string,资源分类图片URL（针对知识）"
@property (nonatomic ,assign) NSInteger score;///"integer,评分"
@property (nonatomic ,assign) NSInteger learnersNum;///"integer,学习人数"
@property (nonatomic ,assign) NSInteger creditHours;///"integer,学时，单位分钟"
@property (nonatomic ,strong) NSString *credit;///"string,学分"
@property (nonatomic ,assign) NSInteger creditHoursUsed;///nteger,学时，单位分钟",
@property (nonatomic ,assign) NSInteger isNew;///是否最新发布
@property (nonatomic ,strong) NSString *desc;///"课程知识描述"
@property (nonatomic ,strong) NSString *contributor;///"课程知识描述"
@property (nonatomic ,strong) NSString *suffixName;///文档后缀名
@end

NS_ASSUME_NONNULL_END
