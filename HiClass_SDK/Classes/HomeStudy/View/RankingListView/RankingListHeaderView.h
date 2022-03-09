//
//  RankingListHeaderView.h
//  iTest
//
//  Created by Sir_Jing on 2020/3/12.
//  Copyright © 2020 Sir_Jing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HICMyRankInfoModel.h"
NS_ASSUME_NONNULL_BEGIN


/// 排行榜头部视图   -- 固定高度   90
@interface RankingListHeaderView : UIView

-(instancetype)initWithModel:(HICMyRankInfoModel *)model;
@property (nonatomic ,strong)HICMyRankInfoModel *infoModel;
@end

NS_ASSUME_NONNULL_END
