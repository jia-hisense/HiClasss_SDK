//
//  HICSyncProgressPopview.h
//  HiClass
//
//  Created by jiafujia on 2021/6/8.
//  Copyright © 2021 hisense. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define hadShowTrainSyncProgressToastKey  @"HadShowTrainSyncProgressToastKey"
#define hadShowPostSyncProgressToastKey   @"HadShowPostSyncProgressToastKey"
#define hadShowMixTrainyncProgressToastKey   @"hadShowMixTrainyncProgressToastKey"
typedef enum : NSUInteger {
    HICSyncProgressPageTrainDetail,
    HICSyncProgressPagePostDetail,
    HICSyncProgressPageMixTrain
} HICSyncProgressPage;

@interface HICSyncProgressPopview : UIView

- (instancetype)initWithFrame:(CGRect)frame from:(HICSyncProgressPage)fromPage;

@end

NS_ASSUME_NONNULL_END
