//
//  HICLessonModel.h
//  HiClass
//
//  Created by WorkOffice on 2020/2/4.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HICAuthorModel.h"
#import "HICCourseModel.h"
#import "HICContributorModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HICLessonModel : NSObject
//{
//       "id": "long,知识课程ID",
//       "courseKLD": {
//         "courseKLDType": "integer,类型（6-课程，7-知识）",
//         "courseKLDId": "long,课程知识ID",
//         "courseKLDName": "string,课程知识名称",
//         "coverPic": "string,封面图URL",
//         "resourceType": "string,资源类型（针对知识）",
//         "resourcePic": "string,资源分类图片URL（针对知识）",
//         "scroe": "integer,评分",
//         "learnersNum": "integer,学习人数"
//       },
//       "contributor": {
//         "customerId": "long,用户ID",
//         "name": "string,用户名称",
//         "picUrl": "string,用户头像URL",
//         "positions": "string,职级信息",
//         "synopsis": synopsis
//       },
//       "author": {
//         "id": "long,作者ID",
//         "type": "string,人员类型:1-系统内人员，2-外部人员",
//         "name": "string,用户名称（type=2适用）",
//         "customer": {
//           "customerId": "long,用户ID",
//           "name": "string,用户名称",
//           "picUrl": "string,用户头像URL",
//           "positions": "string,职级信息",
//           "synopsis": "string,简介信息"
//         }
//       },
@property (nonatomic ,strong) NSNumber *courseID;//"long,知识课程ID"
@property (nonatomic ,strong) NSDictionary *author;
@property (nonatomic ,strong) NSDictionary *courseKLD;
@property (nonatomic ,strong) NSDictionary *contributor;


@end

NS_ASSUME_NONNULL_END
