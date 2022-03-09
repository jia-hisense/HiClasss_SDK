//
//  HICTrainingBriefCell.h
//  HiClass
//
//  Created by hisense on 2020/4/16.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HICTrainingBriefFrame.h"
#import "HICOfflineLecturerCell.h"

NS_ASSUME_NONNULL_BEGIN

@class HICTrainingBriefCell;

typedef void(^ShowBriefBlock)(HICTrainingBriefCell *);

@interface HICTrainingBriefCell : UITableViewCell

@property (nonatomic, strong) HICTrainingBriefFrame *briefFrame;

@property (nonatomic, copy) ShowBriefBlock openOrShrinkBlock;


+ (instancetype)cellWithTableView:(UITableView *)tableView;


@end

NS_ASSUME_NONNULL_END
