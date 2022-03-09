//
//  HICCommentModel.h
//  HiClass
//
//  Created by Eddie Ma on 2020/2/10.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HICCommentModel : NSObject

/// 评论id
@property (nonatomic, strong) NSNumber *commentid;

/// 评论内容
@property (nonatomic, strong) NSString *comment;

/// 父评论全部显示
@property (nonatomic, assign) BOOL showFullComment;

/// 评论时间，utc时间，单位ms
@property (nonatomic, strong) NSNumber *commenttime;

/// 评论状态
@property (nonatomic, strong) NSNumber *commentstatus;

/// 点赞人数
@property (nonatomic, strong) NSNumber *upnum;

/// 回复人数
@property (nonatomic, strong) NSNumber *replynum;

/// 用户头像url
@property (nonatomic, strong) NSString *userpictureurl;

/// 用户名称
@property (nonatomic, strong) NSString *username;

/// 用户评论时使用的设备信息
@property (nonatomic, strong) NSString *device;

/// 用户评论时的应用版本号
@property (nonatomic, strong) NSString *versionname;

/// 用户评论时的应用版本编码
@property (nonatomic, strong) NSNumber *versioncode;

/// 用户对应用的评分
@property (nonatomic, strong) NSNumber *userscore;

/// 用户对评论的点赞标识，0-未点赞，大于0-已点赞
@property (nonatomic, strong) NSNumber *upflag;

/// 资源类型：101-海信学堂课程
@property (nonatomic, strong) NSNumber *typeCode;

/// 9999-移动通信（海信学堂独立部署复用9999）
@property (nonatomic, strong) NSNumber *productCode;

/// 该评论者是否是当前登录用户
@property (nonatomic, assign) BOOL isCurrentUser;

/// 子评论数量
@property (nonatomic, strong) NSNumber *totalReplies;

/// 子评论数组
@property (nonatomic, strong) NSArray *replies;

@end

NS_ASSUME_NONNULL_END
