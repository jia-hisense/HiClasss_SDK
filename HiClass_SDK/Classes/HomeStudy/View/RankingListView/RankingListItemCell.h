//
//  RankingListItemCell.h
//  iTest
//
//  Created by Sir_Jing on 2020/3/12.
//  Copyright © 2020 Sir_Jing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HICMyRankInfoModel.h"
NS_ASSUME_NONNULL_BEGIN


/// 排行榜Cell  ---- 固定高度   82
@interface RankingListItemCell : UITableViewCell

@property (nonatomic, strong) NSIndexPath *cellIndexPath;
@property (nonatomic, strong)HICMyRankInfoModel *model;
@end

NS_ASSUME_NONNULL_END
