//
//  JHKOfflineCourseDataCell.h
//  JHKOffLineViewDemo
//
//  Created by wangggang on 2020/4/21.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HICOfflineCourseModel.h"
NS_ASSUME_NONNULL_BEGIN
static NSString * _Nullable JHKOfflineCourseDataCellIdentifier = @"JHKOfflineCourseDataCell";
@interface JHKOfflineCourseDataCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *mainImageV;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
+(instancetype)getDataCell;
@property (nonatomic, strong) HICOfflineCourseModel *model;
@end

NS_ASSUME_NONNULL_END
