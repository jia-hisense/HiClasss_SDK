//
//  HICMsgCenterCell.h
//  HiClass
//
//  Created by Eddie Ma on 2020/2/26.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HICMsgCenterCellModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HICMsgCenterCell : UITableViewCell

- (void)setData:(HICMsgCenterCellModel *)cellModel index:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
