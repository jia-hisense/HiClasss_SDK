//
//  HICOfflineCourseEnrollCell.h
//  HiClass
//
//  Created by WorkOffice on 2020/6/10.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HICEnrollDetailModel.h"
NS_ASSUME_NONNULL_BEGIN
@protocol HICOfflineCourseEnrollDelegate <NSObject>

- (void)clickBtnWithTitle:(NSString *)title;
- (void)checkReviewStatus;
@end
@interface HICOfflineCourseEnrollCell : UITableViewCell
@property (nonatomic ,strong) HICEnrollDetailModel *model;
@property (nonatomic ,weak) id<HICOfflineCourseEnrollDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
