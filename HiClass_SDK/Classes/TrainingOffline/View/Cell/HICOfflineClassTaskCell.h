//
//  HICOfflineClassTaskCell.h
//  HiClass
//
//  Created by hisense on 2020/4/24.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HICOfflineClassTaskFrame.h"

NS_ASSUME_NONNULL_BEGIN


@class HICOfflineClassTaskCell;

typedef void(^ClickedTaskBlock)(HICOfflineClassTaskCell*);
typedef void(^ClickedMapBlock)(HICOfflineClassTaskCell*);
typedef void(^ClickedRefreshBlock)(HICOfflineClassTaskCell*);

@interface HICOfflineClassTaskCell : UITableViewCell

@property (nonatomic, strong) HICOfflineClassTaskFrame *taskFrame;



@property (nonatomic, copy) ClickedTaskBlock clickedTaskBlock;

@property (nonatomic, copy) ClickedMapBlock clickedMapBlock;

@property (nonatomic, copy) ClickedRefreshBlock clickedRefreshBlock;

+(instancetype)cellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
