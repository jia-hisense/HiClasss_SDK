//
//  JHKOfflineCourseScoreCell.h
//  JHKOffLineViewDemo
//
//  Created by wangggang on 2020/4/20.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
static NSString * _Nullable JHKOfflineCourseScoreCellIdentifier = @"JHKOfflineCourseScoreCell";
@interface JHKOfflineCourseScoreCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
-(void)setCellWithTitle:(NSString *)title score:(NSNumber *)score andMoreFlag:(BOOL)moreFlag;
+(instancetype)getScoreCell;
@end

NS_ASSUME_NONNULL_END
