//
//  HICOfflineTitleCell.h
//  HiClass
//
//  Created by hisense on 2020/4/24.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HICOfflineTitleData : NSObject
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) CGFloat cellHeight;

+ (instancetype)initWithTitle:(NSString *)title cellHeight:(CGFloat)cellHeight;
@end

@interface HICOfflineTitleCell : UITableViewCell

@property (nonatomic, strong) HICOfflineTitleData *data;


+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
