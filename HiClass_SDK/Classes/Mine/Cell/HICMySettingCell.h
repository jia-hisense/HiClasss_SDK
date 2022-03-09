//
//  HICMySettingCell.h
//  HiClass
//
//  Created by WorkOffice on 2020/3/17.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol HICMysettingDelegate <NSObject>
@optional
- (void)switchTouched:(NSIndexPath *)indexPath andSwitchStatus:(BOOL)isOn;
- (void)changeHeader;
@end
@interface HICMySettingCell : UITableViewCell
- (void)haveDiscoureLabel:(BOOL)haveDiscoureLabel isSwitch:(BOOL)isSwitch haveRightLabel:(BOOL)haveRightLabel haveRightImage:(BOOL)haveRightImage isHeader:(BOOL)isHeader andLeftStr:(NSString *)left andRightStr:(NSString *)rightStr;
@property (nonatomic ,assign)NSIndexPath *indexPath;
@property (nonatomic ,assign)BOOL isOn;
@property (nonatomic ,strong)NSString *headerPic;
@property (nonatomic ,strong)UIImage *header;
@property (nonatomic ,assign)id <HICMysettingDelegate>delegate;
@property (nonatomic ,strong)NSString *name;
@property (nonatomic ,assign)BOOL isHeader;
@end

NS_ASSUME_NONNULL_END
