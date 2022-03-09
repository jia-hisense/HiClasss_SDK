//
//  RankingListShareView.h
//  iTest
//
//  Created by Sir_Jing on 2020/3/12.
//  Copyright © 2020 Sir_Jing. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HICMyRankInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@class RankingListShareView;
@protocol RankingListShareViewDelegate <NSObject>

-(void)clickShareView:(RankingListShareView *)view shareImage:(UIImage *)image;

@end

@interface RankingListShareView : UIView

@property (nonatomic, strong) NSArray *rankInfoModels;

@property (nonatomic, weak) id <RankingListShareViewDelegate>delegate;

@property (nonatomic ,assign)HICMyRankType rankType;
@property (nonatomic ,assign)NSInteger rankIndex;

-(instancetype)initWithDefault;
-(void)showShare;
-(void)hiddenShare;
-(void)createView;
@end

NS_ASSUME_NONNULL_END
