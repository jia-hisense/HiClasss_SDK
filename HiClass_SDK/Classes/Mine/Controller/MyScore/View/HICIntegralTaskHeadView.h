//
//  HICIntegralTaskHeadView.h
//  HiClass
//
//  Created by 聚好看 on 2021/11/24.
//  Copyright © 2021 hisense. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^IntegralRankPushBlock)(void);
typedef void(^IntegralSubsidiaryPushBlock)(void);

@interface HICIntegralTaskHeadView : UIView
///排行榜按钮
- (IBAction)btnScoreRankAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lbScoreRank;
///积分label
@property (weak, nonatomic) IBOutlet UILabel *lbAllScore;
///积分明细
- (IBAction)btnScoreDetailsAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lbIntegralSubsidiary;

@property (copy, nonatomic) IntegralRankPushBlock integralRankPushBlock;
@property (copy, nonatomic) IntegralSubsidiaryPushBlock integralSubsidiaryPushBlock;
@property (weak, nonatomic) IBOutlet UIButton *btnScoreRank;
@property (weak, nonatomic) IBOutlet UIView *line;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftDistence;

@end

NS_ASSUME_NONNULL_END
