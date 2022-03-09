//
//  HICOfflineTrainInfoVC.h
//  HiClass
//
//  Created by hisense on 2020/4/14.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HICOfflineTrainInfoVC : UIViewController

@property (nonatomic, assign) NSInteger trainId; //培训id
@property (nonatomic, strong) NSNumber *registerActionId; //根据是否有此值来判断是否需要返回报名相关信息，报名表ID
// 培训是否开始，未开始时显示底部培训安排
@property (nonatomic, assign) BOOL isStarted;
//报名页面跳转
@property (nonatomic, assign) NSInteger isRegisterJump;
///混合培训安排页面是否已打开
@property (nonatomic ,assign) BOOL isShowArrange;
//@property (nonatomic ,strong) NSNumber *registerId;//报名id

@end

NS_ASSUME_NONNULL_END
