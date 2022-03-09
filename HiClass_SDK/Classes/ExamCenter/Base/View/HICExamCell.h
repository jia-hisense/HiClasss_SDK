//
//  HICExamCell.h
//  HiClass
//
//  Created by 铁柱， on 2020/1/15.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HICExamModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HICExamCell : UITableViewCell
@property (nonatomic,strong)HICExamModel *model;
@property (nonatomic,assign)BOOL isLabelHidden;
+ (instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;
- (void)setBorderStyleWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;
@end
NS_ASSUME_NONNULL_END
