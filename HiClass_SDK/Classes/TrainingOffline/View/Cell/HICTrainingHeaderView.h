//
//  HICTrainingHeaderView.h
//  HiClass
//
//  Created by hisense on 2020/4/16.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HICTrainingHeaderFrame.h"

NS_ASSUME_NONNULL_BEGIN

@interface HICTrainingHeaderView : UIView

@property (nonatomic, strong) HICTrainingHeaderFrame *headerFrame;

- (instancetype)initWithHeaderFrame:(HICTrainingHeaderFrame *)headerframe;

@end

NS_ASSUME_NONNULL_END
