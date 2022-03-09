//
//  HICMyInfoCell.h
//  HiClass
//
//  Created by WorkOffice on 2020/3/16.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HICMyInfoCell : UITableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andTitle:(NSString *)title andIcon:(NSString*)iconStr andLast:(BOOL)last;
@end

NS_ASSUME_NONNULL_END
