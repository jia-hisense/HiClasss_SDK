//
//  JHKOfflineCourseTaskCell.h
//  JHKOffLineViewDemo
//
//  Created by wangggang on 2020/4/21.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
static NSString * _Nullable JHKOfflineCourseTaskCellIdentifier = @"JHKOfflineCourseTaskCell";
@interface JHKOfflineCourseTaskCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *signBtn;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *infoLabelH;
+(instancetype)getTaskCell;
-(void)setCellWithState:(NSString *)state andTitle:(NSString *)title andStateType:(NSInteger)stateType andDateTitle:(NSString *)dateTitle andDate:(NSString *)date andPlaceTitle:(NSString *)placeTitle andPlace:(NSString *)place;
@end

NS_ASSUME_NONNULL_END
