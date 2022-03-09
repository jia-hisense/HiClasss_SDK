//
//  HICMsgDetailCardCell.h
//  HiClass
//
//  Created by Eddie Ma on 2020/2/26.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HICMsgModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HICMsgDetailCardCell : UITableViewCell

- (void)setData:(HICMsgModel *)model index:(NSInteger)index type:(HICMsgType)type;

@end

NS_ASSUME_NONNULL_END
