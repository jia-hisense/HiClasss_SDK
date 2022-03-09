//
//  HICBaseInfoModel.h
//  HiClass
//
//  Created by WorkOffice on 2020/2/17.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HICContributorModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HICBaseInfoModel : NSObject
@property (nonatomic ,strong) NSNumber *courseID;//"long,知识课程ID"
@property (nonatomic ,assign) NSInteger type;//"integer,类型：6-课程，7-知识"
@property (nonatomic ,assign) NSInteger resourceType;//"string,知识类型：0-图片，1-视频，2-音频，3-文档，4-压缩包，5-scrom, 6-html"
@property (nonatomic ,copy) NSString *partnerCode;//"string,知识/课程名称"
@property (nonatomic ,strong) NSString *name;//"string,知识/课程名称"
@property (nonatomic ,strong) NSString *code;//"string,知识课程编码"
@property (nonatomic ,assign) NSInteger original;//"integer,是否原创：0-否，1-是"score
@property (nonatomic ,assign) NSInteger score;//"integer,评分，默认0"
@property (nonatomic ,assign) NSInteger learnersNum;//"integer,学习人数，默认0",userLikeNum
@property (nonatomic ,assign) NSInteger userLikeNum;//"integer,用户点赞数，默认0"
@property (nonatomic ,strong) NSDictionary *contributor;//
@property (nonatomic ,strong) NSString *desc;//内容简介
@property (nonatomic ,strong) NSString *credit;//学分
@property (nonatomic ,assign) NSInteger creditHoursUsed;//integer,已使用学时，单位分钟
@property (nonatomic ,assign) NSInteger creditHours;//学时
@property (nonatomic ,assign) CGFloat points;//积分
@property (nonatomic ,strong) NSDictionary *author;//
@property (nonatomic ,strong) NSString *applicableObject;//string,适用对象，通过course_kld_user表获取
@property (nonatomic ,strong) NSArray *mediaInfoList;
@property (nonatomic ,strong) NSString *playUrl;//string,html/scorm包首页播放地址
@property (nonatomic ,strong) NSString *coverPic;//string,封面图URL
@property (nonatomic ,strong) NSDictionary *masterLecturer;//
@property (nonatomic ,strong) NSDictionary *slaveLecturer;//
@property (nonatomic ,strong) NSArray *tagList;//
@end

NS_ASSUME_NONNULL_END
