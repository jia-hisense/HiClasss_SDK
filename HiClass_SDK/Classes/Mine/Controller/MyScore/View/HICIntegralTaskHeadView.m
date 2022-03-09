//
//  HICIntegralTaskHeadView.m
//  HiClass
//
//  Created by 聚好看 on 2021/11/24.
//  Copyright © 2021 hisense. All rights reserved.
//

#import "HICIntegralTaskHeadView.h"

@implementation HICIntegralTaskHeadView

- (instancetype)init {
    NSArray *objs = [[NSBundle mainBundle] loadNibNamed:@"HICIntegralTaskHeadView" owner:nil options:nil];
    HICIntegralTaskHeadView *view = objs.firstObject;
    view.lbIntegralSubsidiary.text = NSLocalizableString(@"scoreDetail", nil);
    view.lbScoreRank.text = NSLocalizableString(@"integralRank", nil);

    return view;
}

- (IBAction)btnScoreRankAction:(id)sender {
    _integralRankPushBlock();
    
}
- (IBAction)btnScoreDetailsAction:(id)sender {
    _integralSubsidiaryPushBlock();
    
}
@end
