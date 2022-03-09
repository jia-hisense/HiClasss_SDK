//
//  SearchClassStudyCell.h
//  iTest
//
//  Created by Sir_Jing on 2020/3/18.
//  Copyright © 2020 Sir_Jing. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HICSearchDetailModel.h"

NS_ASSUME_NONNULL_BEGIN


/// 搜素的知识cell  --  固定高度  
@interface SearchClassStudyCell : UITableViewCell

@property (nonatomic, strong) NSIndexPath *cellIndexPath;

@property (nonatomic, strong) SearchDetailInfoModel *infoModel;

@end

NS_ASSUME_NONNULL_END
