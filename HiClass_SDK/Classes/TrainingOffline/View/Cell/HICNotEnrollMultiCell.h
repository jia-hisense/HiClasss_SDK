//
//  HICNotEnrollMultiCell.h
//  HiClass
//
//  Created by WorkOffice on 2020/6/5.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HICNotEnrollCourseArrangeModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HICNotEnrollMultiCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;
- (void)setBorderStyleWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;
@property (nonatomic ,strong)HICNotEnrollCourseArrangeModel *model;
@end

NS_ASSUME_NONNULL_END
