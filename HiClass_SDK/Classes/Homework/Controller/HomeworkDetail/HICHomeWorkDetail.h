//
//  HICHomeWorkDetail.h
//  HiClass
//
//  Created by 铁柱， on 2020/3/26.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HICHomeWorkDetail : UIViewController

@property (nonatomic, assign) HICHomeworkStatus status;

@property (nonatomic, assign) NSInteger jobId;

@property (nonatomic, copy) NSString *trainId;

@property (nonatomic, assign) NSInteger workId;

@property (nonatomic, copy) NSString *jobName;

@property (nonatomic, strong) NSNumber *endTime;

/// 是否显示分数  -- 默认为不显示
@property (nonatomic, assign) BOOL isShowScore;

@end

NS_ASSUME_NONNULL_END
