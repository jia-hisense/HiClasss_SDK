//
//  HICTrainingOtherInfoCell.h
//  HiClass
//
//  Created by hisense on 2020/4/16.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HICTrainingOtherInfoFrame.h"

NS_ASSUME_NONNULL_BEGIN

@interface HICTrainingOtherInfoCell : UITableViewCell

@property (nonatomic, strong) HICTrainingOtherInfoFrame *infoFrame;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
