//
//  HICEnrollReviewerCell.h
//  HiClass
//
//  Created by WorkOffice on 2020/6/9.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HICEnrollReviewModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HICEnrollReviewerCell : UITableViewCell
- (void)setModel:(HICEnrollReviewerModel *)model andIndexPath:(NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_END
