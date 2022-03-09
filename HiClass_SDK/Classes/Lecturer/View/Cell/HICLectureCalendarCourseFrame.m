//
//  HICLectureCalendarCourseFrame.m
//  HiClass
//
//  Created by hisense on 2020/5/15.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import "HICLectureCalendarCourseFrame.h"

@implementation HICLectureCalendarCourseFrame

- (instancetype)initWithCourse:(HICLectureTrainSubCourseModel *)course isSeparatorHidden:(BOOL)isSeparatorHidden {
    self = [super init];
    if (self) {
        self.isSeparatorHidden = isSeparatorHidden;
        self.course = course;
    }
    return self;
}

- (void)setCourse:(HICLectureTrainSubCourseModel *)course {
    _course = course;

    CGFloat leftPadding = 28;
    CGFloat rightPadding = 28;
    CGFloat topPadding = 12;
    CGFloat cellW = HIC_ScreenWidth;

    _bgViewF = CGRectMake(12, 0, cellW-24, 112);
    _titleLblF = CGRectMake(leftPadding, topPadding, cellW-leftPadding-rightPadding, 22);
    _classDurationLblF = CGRectMake(leftPadding, CGRectGetMaxY(_titleLblF), CGRectGetWidth(_titleLblF), CGRectGetHeight(_titleLblF));
    _timeLblF= CGRectMake(leftPadding, CGRectGetMaxY(_classDurationLblF), CGRectGetWidth(_titleLblF), CGRectGetHeight(_titleLblF));
    _locationLblF = CGRectMake(leftPadding, CGRectGetMaxY(_timeLblF), CGRectGetWidth(_titleLblF), CGRectGetHeight(_titleLblF));

    _cellHeight = CGRectGetMaxY(_bgViewF);


    if (self.isSeparatorHidden) {
        _separatorLineViewF = CGRectZero;
    } else {
        _separatorLineViewF = CGRectMake(leftPadding, CGRectGetMaxY(_bgViewF)-0.5, CGRectGetWidth(_titleLblF), 0.5);
    }
    
}

- (void)setIsSeparatorHidden:(BOOL)isSeparatorHidden {
    _isSeparatorHidden = isSeparatorHidden;
    if (isSeparatorHidden) {
        _separatorLineViewF = CGRectZero;
    } else {
        CGFloat leftPadding = 28;
        _separatorLineViewF = CGRectMake(leftPadding, CGRectGetMaxY(_bgViewF)-0.5, CGRectGetWidth(_titleLblF), 0.5);
    }
}

@end
