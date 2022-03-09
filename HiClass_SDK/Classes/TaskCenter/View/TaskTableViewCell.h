//
//  TaskTableViewCell.h
//  HiClass
//
//  Created by Eddie Ma on 2020/1/17.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HICTestModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TaskTableViewCell : UITableViewCell

@property (nonatomic, strong) UIView *taskContentView;

- (void)setDataWith:(HICTestModel *)model sectionName:(NSString *)sectionName isFirstModel:(BOOL)isFirstModel;

@end

NS_ASSUME_NONNULL_END
