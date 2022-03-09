//
//  HICOfflineScoreCell.h
//  HiClass
//
//  Created by hisense on 2020/4/24.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HICOfflineScoreCellData : NSObject
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *score;
@property (nonatomic, assign) BOOL isSeparatorHidden;

@property (nonatomic, strong) NSString *maxFormatScore;// 用于计算分数lbl宽度

@property (nonatomic, strong) UIFont *textFont;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *lblBgColor;

@property (nonatomic, assign) CGFloat topPadding;

@property (nonatomic, assign) CGFloat cellHeight;


+ (instancetype)dataWithTitle:(NSString *)title score:(NSString *)score isSeparatorHidden:(BOOL )isSeparatorHidden maxFormatScore:(NSString *)maxFormatScore textFont:( UIFont *)textFont textColor:(UIColor *)textColor lblBgColor:(UIColor *)lblBgColor topPadding:(CGFloat)topPadding cellHeight:(CGFloat)cellHeight;

@end



@interface HICOfflineScoreCell : UITableViewCell

@property (nonatomic, strong) HICOfflineScoreCellData *data;

+ (instancetype)cellWithTableView:(UITableView *)tableView;


@end

NS_ASSUME_NONNULL_END
