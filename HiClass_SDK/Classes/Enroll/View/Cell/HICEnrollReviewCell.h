//
//  HICEnrollReviewCell.h
//  HiClass
//
//  Created by WorkOffice on 2020/6/5.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HICEnrollReviewModel.h"
NS_ASSUME_NONNULL_BEGIN
@protocol HICEnrollReviewerSelectDelegate <NSObject>
@optional
- (void)jumpWithModelArr:(NSArray *)arr andIndexPath:(NSIndexPath *)indexPath;
- (void)jumpSearchWithIndexPath:(NSIndexPath *)indexPath;
@end
@interface HICEnrollReviewCell : UITableViewCell
@property (nonatomic ,strong)NSIndexPath *indexPath;
@property (nonatomic ,strong)HICEnrollReviewModel *reviewModel;
@property (nonatomic ,strong)HICEnrollReviewProcessModel *progressModel;
@property (nonatomic ,assign)NSInteger type;
@property (nonatomic ,weak)id<HICEnrollReviewerSelectDelegate>delegate;
@end
NS_ASSUME_NONNULL_END
