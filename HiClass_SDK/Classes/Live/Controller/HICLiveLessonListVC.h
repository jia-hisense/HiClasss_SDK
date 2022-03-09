//
//  HICLiveLessonListVC.h
//  HiClass
//
//  Created by jiafujia on 2021/11/19.
//  Copyright © 2021 hisense. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    HICLiveLessonListAll = 0,
    HICLiveLessonListWait = 1,
    HICLiveLessonListInProgress = 2,
    HICLiveLessonListEnded = 3
} HICLiveLessonListType;

@protocol HICLiveLessonListDelegate <NSObject>
- (void)initLiveSDKWithRoomNumber:(NSString *)roomNum;
@end

typedef void(^GetLiveNumBlock)(void);
@interface HICLiveLessonListVC : UIViewController

@property (nonatomic, weak) id<HICLiveLessonListDelegate> delegate;
@property (nonatomic, copy) GetLiveNumBlock getLiveNumBlock;

- (instancetype)initWithType:(HICLiveLessonListType)type;
- (void)getLessonList;

@end

NS_ASSUME_NONNULL_END
