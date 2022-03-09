//
//  HICOnlineTrainCell.h
//  HiClass
//
//  Created by WorkOffice on 2020/3/3.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HICOnlineTrainListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HICOnlineTrainCell : UITableViewCell
@property (nonatomic, strong) HICOnlineTrainListModel *model;
@property (nonatomic ,assign) BOOL isAll;
+ (instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;
- (void)setBorderStyleWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_END
