//
//  HICOfflineClassHeaderView.h
//  HiClass
//
//  Created by hisense on 2020/4/23.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HICOfflineClassHeaderFrame.h"

NS_ASSUME_NONNULL_BEGIN

@interface HICOfflineClassHeaderView : UIView

@property (nonatomic, strong) HICOfflineClassHeaderFrame *headerFrame;

- (instancetype)initWithHeaderFrame:(HICOfflineClassHeaderFrame *)headerframe;


@end

NS_ASSUME_NONNULL_END
