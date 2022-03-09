//
//  HICOfflineLecturerCell.h
//  HiClass
//
//  Created by hisense on 2020/4/24.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HICOfflineLecturerFrame.h"

NS_ASSUME_NONNULL_BEGIN


@class HICOfflineLecturerCell;

typedef void(^OpenOrShrinkBlock)(HICOfflineLecturerCell *);

typedef void(^IconClickedBlock)(HICOfflineLecturerCell *);

@interface HICOfflineLecturerCell : UITableViewCell

@property (nonatomic, strong) HICOfflineLecturerFrame *lecturerFrame;

@property (nonatomic, copy) OpenOrShrinkBlock openOrShrinkBlock;

@property (nonatomic, copy) IconClickedBlock iconClickedBlock;


+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
