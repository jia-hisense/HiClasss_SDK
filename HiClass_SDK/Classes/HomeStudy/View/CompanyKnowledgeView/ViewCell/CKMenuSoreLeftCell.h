//
//  CKMenuSoreLeftCell.h
//  iTest
//
//  Created by Sir_Jing on 2020/3/12.
//  Copyright © 2020 Sir_Jing. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HICCompanyMenuModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface CKMenuSoreLeftCell : UITableViewCell

@property (nonatomic, strong) HICCompanyMenuModel *model;

@property (nonatomic, assign) BOOL isRightView;

@end

NS_ASSUME_NONNULL_END
