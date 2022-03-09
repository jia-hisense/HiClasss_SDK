//
//  HICMyCollectCell.h
//  HiClass
//
//  Created by WorkOffice on 2020/2/20.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HICMyCollectModel.h"
NS_ASSUME_NONNULL_BEGIN

@protocol HICMyCollectDelegate <NSObject>
-(void)checkIndex:(NSIndexPath*)indexPath;
@end
@interface HICMyCollectCell : UITableViewCell
@property (nonatomic ,assign)id <HICMyCollectDelegate>collectDelegate;
- (void)setModel:(HICMyCollectModel *)model andIndexPath:(NSIndexPath *)indexPath andIsEdit:(BOOL)isEdit andIsChecked:(BOOL)isChecked;
@end

NS_ASSUME_NONNULL_END
