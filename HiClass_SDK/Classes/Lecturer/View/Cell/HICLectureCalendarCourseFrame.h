//
//  HICLectureCalendarCourseFrame.h
//  HiClass
//
//  Created by hisense on 2020/5/15.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HICLectureTrainModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HICLectureCalendarCourseFrame : NSObject

@property (nonatomic, strong) HICLectureTrainSubCourseModel *course;

@property (nonatomic, assign) BOOL isSeparatorHidden;

@property (nonatomic, assign, readonly) CGRect bgViewF;
@property (nonatomic, assign, readonly) CGRect titleLblF;
@property (nonatomic, assign, readonly) CGRect classDurationLblF;
@property (nonatomic, assign, readonly) CGRect timeLblF;
@property (nonatomic, assign, readonly) CGRect locationLblF;
@property (nonatomic, assign, readonly) CGFloat cellHeight;

@property (nonatomic, assign) CGRect separatorLineViewF;


- (instancetype)initWithCourse:(HICLectureTrainSubCourseModel *)course isSeparatorHidden:(BOOL)isSeparatorHidden;

@end

NS_ASSUME_NONNULL_END
