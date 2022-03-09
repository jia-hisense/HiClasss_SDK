//
//  HICEnrollReviewStatusCell.h
//  HiClass
//
//  Created by WorkOffice on 2020/6/19.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HICEnrollReviewModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HICEnrollReviewStatusCell : UITableViewCell
@property (nonatomic ,strong)NSIndexPath *indexPath;
@property (nonatomic ,strong)HICEnrollReviewProcessModel *processModel;
@end

NS_ASSUME_NONNULL_END
