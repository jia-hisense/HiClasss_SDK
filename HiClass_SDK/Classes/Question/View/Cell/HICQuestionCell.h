//
//  HICQuestionCell.h
//  HiClass
//
//  Created by WorkOffice on 2020/6/8.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HICQuestionListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HICQuestionCell : UITableViewCell

@property (nonatomic ,strong)HICQuestionListModel *model;
@property (nonatomic ,assign)BOOL isAll;

@end

NS_ASSUME_NONNULL_END
