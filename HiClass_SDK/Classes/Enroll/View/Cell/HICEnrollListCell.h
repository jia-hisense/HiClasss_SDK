//
//  HICEnrollListCell.h
//  HiClass
//
//  Created by WorkOffice on 2020/6/4.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HICEnrollListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HICEnrollListCell : UITableViewCell
@property (nonatomic ,strong)HICEnrollListModel *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;
- (void)setBorderStyleWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_END
