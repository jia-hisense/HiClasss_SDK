//
//  HICOfflineMaterialCell.h
//  HiClass
//
//  Created by hisense on 2020/4/24.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HICOfflineClassInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HICOfflineMaterialData : NSObject
@property (nonatomic, strong) HICReferenceMaterial *data;

@property (nonatomic, assign) BOOL isSeparatorHidden;

@property (nonatomic, assign) CGFloat cellHeight;


+(instancetype)initWithMaterial:(HICReferenceMaterial*)data isSeparatorHidden:(BOOL)isSeparatorHidden cellHeight:(CGFloat)cellHeight;

@end



@interface HICOfflineMaterialCell : UITableViewCell

@property (nonatomic, strong) HICOfflineMaterialData *data;


+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
