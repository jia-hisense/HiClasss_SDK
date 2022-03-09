//
//  HICOfflineAllScoreCell.h
//  HiClass
//
//  Created by hisense on 2020/4/24.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HICOfflineAllScoreCellData : NSObject
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIFont *textFont;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *lblBgColor;
@property (nonatomic, assign) CGFloat cellHeight;
+ (instancetype)initWithTitle:(NSString *)title textFont:(UIFont *)textFont textColor:(UIColor *)textColor lblBgColor:(UIColor *)lblBgColor cellHeight:(CGFloat)cellHeight;
@end



@interface HICOfflineAllScoreCell : UITableViewCell

@property (nonatomic, strong) HICOfflineAllScoreCellData *data;


+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
