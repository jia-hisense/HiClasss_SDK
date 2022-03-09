//
//  HICOfflineClassHeaderFrame.m
//  HiClass
//
//  Created by hisense on 2020/4/23.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import "HICOfflineClassHeaderFrame.h"
#import "NSString+String.h"


@implementation HICOfflineClassHeaderFrame

- (instancetype)initWithData:(HICOfflineClassHeaderData *)data {
    self = [super init];
    if (self) {
        self.data = data;
    }
    return self;
}

- (void)setData:(HICOfflineClassHeaderData *)data {

    _data = data;

    CGFloat leftPadding = 16;
    CGFloat rightPadding = 16;
    CGFloat topPadding = HIC_NavBarAndStatusBarHeight+ 6;
    CGFloat bottomPadding = 16;
    CGFloat cellW = HIC_ScreenWidth;

    CGFloat contentW = cellW-leftPadding-rightPadding;
    CGSize titleSize = [[NSString realString:data.title] sizeWithFont:[UIFont fontWithName:@"PingFangSC-Regular" size:18] maxSize:CGSizeMake(contentW, 52)];

    _titleLblF = CGRectMake(leftPadding, topPadding, contentW, titleSize.height);

    if (data.pageType == TrainCourse) {
        _timeLblF = CGRectMake(leftPadding, CGRectGetMaxY(_titleLblF)+16, CGRectGetWidth(_titleLblF), 22);

        _placeLblF = CGRectMake(leftPadding, CGRectGetMaxY(_timeLblF), CGRectGetWidth(_titleLblF), 22);


        _headerHeight = CGRectGetMaxY(_placeLblF) + bottomPadding;

        _imgViewF = CGRectMake(cellW-(86+9), _headerHeight- (bottomPadding+86), 86, 86);
    } else if (data.pageType == LectureCourse) {
        _timeLblF = CGRectZero;
        _placeLblF = CGRectZero;
        _imgViewF = CGRectZero;
        _headerHeight = CGRectGetMaxY(_titleLblF) + bottomPadding;
    }

    _bgImgViewF = CGRectMake(0, 0, cellW, _headerHeight);

}

@end
