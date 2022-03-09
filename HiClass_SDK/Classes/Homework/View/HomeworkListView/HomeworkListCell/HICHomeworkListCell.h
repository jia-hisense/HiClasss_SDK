//
//  HICHomeworkListCell.h
//  HiClass
//
//  Created by Eddie Ma on 2020/3/11.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HICHomeworkModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HICHomeworkListCell : UITableViewCell

- (void)setData:(HICHomeworkModel *)hModel index:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
