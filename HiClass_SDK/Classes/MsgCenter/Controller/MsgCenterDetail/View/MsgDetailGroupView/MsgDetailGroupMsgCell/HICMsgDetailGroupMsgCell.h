//
//  HICMsgDetailGroupMsgCell.h
//  HiClass
//
//  Created by Eddie Ma on 2020/2/27.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HICGroupMsgModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HICMsgDetailGroupMsgCell : UITableViewCell

- (void)setData:(HICGroupMsgModel *)model index:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
