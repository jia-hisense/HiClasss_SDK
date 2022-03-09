//
//  JHKOfflineCourseInfoCell.h
//  JHKOffLineViewDemo
//
//  Created by wangggang on 2020/4/20.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^GetInfoCellBlock)(CGFloat height);
static NSString * _Nullable JHKOfflineCourseInfoCellIdentifier = @"JHKOfflineCourseInfoCell";
@interface JHKOfflineCourseInfoCell : UITableViewCell
@property (copy, nonatomic) GetInfoCellBlock infoCellHeightBlock;
+(instancetype)getInfoCell;
-(void)setCellWithTitle:(NSString *)title hours:(NSString *)hours detailInfo:(NSString *)detailInfo;
-(void)setCellWithTitle:(NSString *)title score:(NSString *)score credit:(NSString *)credit hours:(NSString *)hours;
-(void)setCellWithTitle:(NSString *)title position:(NSString *)position;

@end

NS_ASSUME_NONNULL_END
