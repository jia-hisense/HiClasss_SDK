//
//  HICCourseDetailVC.h
//  HiClass
//
//  Created by hisense on 2020/4/24.
//  Copyright © 2020 haoqian. All rights reserved.
//

typedef enum : NSUInteger {
    TrainCourse,
    LectureCourse,
} HICTrainPageType;


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HICOfflineCourseDetailVC : UIViewController

@property (nonatomic, assign) NSInteger trainId;
@property (nonatomic, assign) NSInteger taskId; //线下课任务的taskId

@property (nonatomic, assign) HICTrainPageType pageType;


@end

NS_ASSUME_NONNULL_END
