//
//  HICQuestionLessonListVC.h
//  HiClass
//
//  Created by 聚好看 on 2021/11/26.
//  Copyright © 2021 hisense. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    HICQuestionLessonListAll = 0,
    HICQuestionLessonListWait = 2,
    HICQuestionLessonListFinish = 5,
    HICQuestionLessonListoverdue = 6
} HICQuestionLessonListType;

typedef void(^GetQuestionNumBlock)(void);
@interface HICQuestionLessonListVC : UIViewController

@property (nonatomic, copy) GetQuestionNumBlock getQuestionNumBlock;

- (instancetype)initWithType:(HICQuestionLessonListType)type;
- (void)getQuestionList;
@end

NS_ASSUME_NONNULL_END
