//
//  HICLectureCourseView.h
//  HiClass
//
//  Created by WorkOffice on 2020/4/1.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef  void(^RefreshDone)(BOOL isSuccess, NSInteger total);

typedef  void(^GotoCourseDetail)(NSInteger taskId);

typedef  void(^NetError)(void);

@interface HICLectureCourseView : UITableView
-(instancetype)initWithFrame:(CGRect)frame;

@property (nonatomic, assign) BOOL isDataOnceSuccess;

@property (nonatomic, assign) NSInteger lecturerId;

/// 刷新课程计数
@property (nonatomic, copy) RefreshDone refreshDoneBlock;

/// 跳转到课程详情页
@property (nonatomic, copy) GotoCourseDetail  gotoCourseDetailBlock;

@property (nonatomic, copy) NetError netErrorBlock;

- (void)topRefresh;
- (void)bottomRefresh;

@end

NS_ASSUME_NONNULL_END
