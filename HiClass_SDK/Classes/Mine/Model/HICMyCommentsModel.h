//
//  HICMyCommentsModel.h
//  HiClass
//
//  Created by WorkOffice on 2020/5/21.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/**
 "id":"long,评论ID",
 "time":"long,评论时间，13位毫秒级时间戳",
 "auditStatus":"integer,审核状态：0 审核不通过 1 审核通过 2 待审核",
 "content":"string,评论内容",
 "objectType":"string,评论对象类型：6-课程  7-知识",
 "objectInfo":Object{...},
 "reviewer":Object{...},
 "score":"string,评分",
 "likeFlag":"integer,是否已点赞，0-否  1-是",
 "likeNum":"string,点赞数",
 "replyList":Array[1]
 */
@interface HICMyCommentsModel : NSObject
@property (nonatomic ,strong)NSNumber *commentId;
@property (nonatomic ,strong)NSNumber *time;
@property (nonatomic ,assign)NSInteger auditStatus;
@property (nonatomic ,strong)NSString *content;
@property (nonatomic ,strong)NSString *objectType;
@property (nonatomic ,strong)NSDictionary *objectInfo;
@property (nonatomic ,strong)NSDictionary *reviewer;
@property (nonatomic ,strong)NSString *score;
@property (nonatomic ,assign)NSInteger likeFlag;
@property (nonatomic ,strong)NSString *likeNum;
@property (nonatomic ,strong)NSArray *replyList;
@end
/**
 "id":"long,评论对象ID",
                    "type":"integer,评论对象：6-课程  7-知识",
                    "name":"string,评论对象名称",
                    "coverPic":"string,封面图",
                    "resourceType":"integer,资源类型：（针对知识）  0-图片，1-视频，2-音频，3-文档，4-压缩包，5-scrom,6-html"
 
 */
@interface HICMyCommentsObjectModel : NSObject
@property (nonatomic ,strong)NSNumber *commentObjectId;
@property (nonatomic ,assign)NSInteger type;
@property (nonatomic ,strong)NSString *name;
@property (nonatomic ,strong)NSString *coverPic;
@property (nonatomic ,assign)NSInteger resourceType;
@property (nonatomic ,copy)NSString *partnerCode;
@end

NS_ASSUME_NONNULL_END
