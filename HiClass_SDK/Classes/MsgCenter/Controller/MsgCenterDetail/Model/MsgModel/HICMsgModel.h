//
//  HICMsgModel.h
//  HiClass
//
//  Created by Eddie Ma on 2020/2/26.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HICMsgModel : NSObject

@property (nonatomic, strong) NSNumber *msgId;
@property (nonatomic, strong) NSNumber *msgType;
@property (nonatomic, strong) NSString *msgTitle;
@property (nonatomic, strong) NSString *msgContent;
/// 0-未读，1-已读
@property (nonatomic, strong) NSNumber *msgStatus;
@property (nonatomic, strong) NSNumber *msgTime;
@property (nonatomic, copy) NSString *msgUrl;

@end

NS_ASSUME_NONNULL_END
