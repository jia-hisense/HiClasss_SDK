//
//  HICRankingListView.h
//  iTest
//
//  Created by Sir_Jing on 2020/3/12.
//  Copyright © 2020 Sir_Jing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HICRankingListView : UIViewController
@property (nonatomic ,assign)HICMyRankType rankType;
@property (nonatomic ,assign)NSInteger rankIndex;

// 给分享使用的数组
@property (nonatomic, strong) NSArray *dataArr;
@end

NS_ASSUME_NONNULL_END
