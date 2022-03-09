//
//  HICLectureCalendarTrainFrame.h
//  HiClass
//
//  Created by hisense on 2020/5/15.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HICLectureTrainModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HICLectureCalendarTrainFrame : NSObject

@property (nonatomic, assign, readonly) CGRect bgViewlF;
@property (nonatomic, assign, readonly) CGRect titleLblF;
@property (nonatomic, assign, readonly) CGRect separatorLineViewF;
@property (nonatomic, assign, readonly) CGFloat cellHeight;

@property (nonatomic, strong) HICLectureTrainSubModel *train;
@property (nonatomic, strong, readonly) NSAttributedString *titleAtt;

@property (nonatomic, assign) BOOL isSeparatorHidden;


- (instancetype)initWithTrain:(HICLectureTrainSubModel *)train isSeparatorHidden:(BOOL)isSeparatorHidden;

@end

NS_ASSUME_NONNULL_END
