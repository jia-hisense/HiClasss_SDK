//
//  HICMsgCenterCellModel.h
//  HiClass
//
//  Created by Eddie Ma on 2020/2/26.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HICMsgCenterCellModel : NSObject
@property (nonatomic, strong) NSString *msgCellImageName;
@property (nonatomic, strong) NSString *msgCellTitle;
@property (nonatomic, strong) NSString *msgCellSubTitle;
@property (nonatomic, strong) NSNumber *msgCellHintNum;
@property (nonatomic, strong) NSNumber *msgCellTime;
@end

NS_ASSUME_NONNULL_END
