//
//  HICLectureCourseCell.h
//  HiClass
//
//  Created by hisense on 2020/5/14.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HICLectureCourseFrame.h"

NS_ASSUME_NONNULL_BEGIN

@interface HICLectureCourseCell : UITableViewCell

@property (nonatomic, strong) HICLectureCourseFrame *courseFrame;


+(instancetype)cellWithTableView:(UITableView *)tableView;




@end

NS_ASSUME_NONNULL_END
