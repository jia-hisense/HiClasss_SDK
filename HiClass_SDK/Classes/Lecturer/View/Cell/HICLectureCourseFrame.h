//
//  HICLectureCourseFrame.h
//  HiClass
//
//  Created by hisense on 2020/5/14.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HICLectureCourseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HICLectureCourseFrame : NSObject


@property (nonatomic, assign, readonly) CGRect titleLblF;
@property (nonatomic, assign, readonly) CGRect typeImgViewF;
@property (nonatomic, assign, readonly) CGRect joinNumLblF;
@property (nonatomic, assign, readonly) CGRect separatorLineViewF;
@property (nonatomic, assign, readonly) CGFloat cellHeight;

@property (nonatomic, strong) HICLectureCourseSubModel *course;

@property (nonatomic, assign) BOOL isSeparatorHidden;


- (instancetype)initWithCourse:(HICLectureCourseSubModel *)course isSeparatorHidden:(BOOL)isSeparatorHidden;


@end

NS_ASSUME_NONNULL_END
