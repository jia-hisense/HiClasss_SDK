//
//  HICGroupMsgModel.h
//  HiClass
//
//  Created by Eddie Ma on 2020/2/27.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HICGroupMsgModel : NSObject

@property (nonatomic, strong) NSNumber *groupId;
@property (nonatomic, strong) NSString *groupName;
/// 消息总数量
@property (nonatomic, strong) NSNumber *count;
@property (nonatomic, strong) NSNumber *unreadNum;
@property (nonatomic, strong) NSArray *messageList;

@end

NS_ASSUME_NONNULL_END
