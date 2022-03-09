//
//  HICControlInfoModel.h
//  HiClass
//
//  Created by WorkOffice on 2020/2/17.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HICControlInfoModel : NSObject
/**
 "shareFlag": "integer,分享开关，0-否，1-是",
 "downloadFlag": "integer,下载开关，0-否，1-是",
 "hideFlag": "integer,知识隐藏开关，0-否，1-是",
 "jumpFlag": "integer,课程章节跳过开关，0-否，1-是",
 "notOperatedIntervel": "integer,n分钟没有操作给出确认提示，0表示不控制",
 "collectionFlag": "integer,是否已收藏，0-否 1-是",
 "likeFlag": "integer,是否已点赞，0-否 1-是",
 "watermarkFlag": "integer,是否添加水印，0-否  1-是",
 "watermarkText": "string,水印内容"
 "*/
@property (nonatomic ,assign)NSInteger shareFlag;//"integer,分享开关，0-否，1-是",
@property (nonatomic ,assign)NSInteger downloadFlag;//"integer,下载开关，0-否，1-是",
@property (nonatomic ,assign)NSInteger hideFlag;//"integer,知识隐藏开关，0-否，1-是",
@property (nonatomic ,assign)NSInteger jumpFlag;// "integer,课程章节跳过开关，0-否，1-是",
@property (nonatomic ,assign)NSInteger notOperatedIntervel;//"integer,n分钟没有操作给出确认提示，0表示不控制",
@property (nonatomic ,assign)NSInteger collectionFlag;//"integer,是否已收藏，0-否 1-是",
@property (nonatomic ,assign)NSInteger likeFlag;// "integer,是否已点赞，0-否 1-是",
@property (nonatomic ,assign)NSInteger watermarkFlag;//"integer,是否添加水印，0-否  1-是",
@property (nonatomic ,strong)NSString *watermarkText;//"string,水印内容"
@end

NS_ASSUME_NONNULL_END
