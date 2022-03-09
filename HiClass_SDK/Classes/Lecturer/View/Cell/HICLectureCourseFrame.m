//
//  HICLectureCourseFrame.m
//  HiClass
//
//  Created by hisense on 2020/5/14.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import "HICLectureCourseFrame.h"

@implementation HICLectureCourseFrame

- (instancetype)initWithCourse:(HICLectureCourseSubModel *)course  isSeparatorHidden:(BOOL)isSeparatorHidden{
    self = [super init];
    if (self) {
        self.isSeparatorHidden = isSeparatorHidden;
        self.course = course;
    }
    return self;
}

- (void)setCourse:(HICLectureCourseSubModel *)course {
    _course = course;

    CGFloat leftPadding = 16;
    CGFloat rightPadding = 16;
    CGFloat topPadding = 20;
    CGFloat bottomPadding = 16;
    CGFloat cellW = HIC_ScreenWidth;

    CGSize titleSize = [course.resClassName sizeWithFont:[UIFont fontWithName:@"PingFangSC-Medium" size:15] maxSize:CGSizeMake(cellW-leftPadding-rightPadding, MAXFLOAT)];
    CGFloat titleLblFH;
    if (titleSize.height > 22) {
        titleLblFH = 44;
    } else {
        titleLblFH = 22;
    }
    _titleLblF = CGRectMake(leftPadding, topPadding, cellW-leftPadding-rightPadding, titleLblFH);

    if (course.isAuth) {
        _typeImgViewF = CGRectMake(CGRectGetMinX(_titleLblF), CGRectGetMaxY(_titleLblF) + 4, 54, 16);
    } else {
        _typeImgViewF = CGRectZero;
    }

    CGFloat joinNumLblFX = MAX(leftPadding, CGRectGetMaxX(_typeImgViewF));
    _joinNumLblF = CGRectMake(joinNumLblFX, 2.5+CGRectGetMaxY(_titleLblF), cellW-rightPadding-joinNumLblFX, 19);

    _typeImgViewF = CGRectMake(_typeImgViewF.origin.x, CGRectGetMidY(_joinNumLblF)-CGRectGetHeight(_typeImgViewF)/2.0, CGRectGetWidth(_typeImgViewF), CGRectGetHeight(_typeImgViewF));

    _cellHeight = CGRectGetMaxY(_joinNumLblF)+bottomPadding;

    if (self.isSeparatorHidden) {
        _separatorLineViewF = CGRectZero;
    } else {
        _separatorLineViewF = CGRectMake(leftPadding, _cellHeight-0.5, cellW-leftPadding, 0.5);
    }




}

- (void)setIsSeparatorHidden:(BOOL)isSeparatorHidden {
    _isSeparatorHidden = isSeparatorHidden;
    if (isSeparatorHidden) {
        _separatorLineViewF = CGRectZero;
    } else {
        CGFloat leftPadding = 28;
        CGFloat cellW = HIC_ScreenWidth;
        _separatorLineViewF = CGRectMake(leftPadding, _cellHeight-0.5, cellW-leftPadding, 0.5);
    }
}

@end
