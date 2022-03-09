//
//  HICTrainingBriefFrame.m
//  HiClass
//
//  Created by hisense on 2020/4/16.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import "HICTrainingBriefFrame.h"
#import "NSString+String.h"

@implementation HICTrainingBriefData

- (instancetype)initWithTitle:(NSString *)title time:(NSString * _Nullable)time brief:(NSString *)brief {
    self = [super init];
    if (self) {
        self.title = title;
        self.time = time;
        self.brief = brief;
    }
    return self;
}

@end


@implementation HICTrainingBriefFrame


- (instancetype)initWithData:(HICTrainingBriefData *)data isOpened:(BOOL)isOpened
{
    self = [super init];
    if (self) {
        [self updateData:data isOpened:isOpened];
    }
    return self;
}



- (void)updateData:(HICTrainingBriefData *)data isOpened:(BOOL)isOpened {

    self.data = data;
    self.isOpened = isOpened;

}

- (void)setIsOpened:(BOOL)isOpened {

    _isOpened = isOpened;
    
    CGFloat topPadding = 16;
    CGFloat leftPadding = 16;
    CGFloat bottomPadding = 12;
    CGFloat rightPadding = 16;

    CGFloat cellW = HIC_ScreenWidth;

    _titleLblF = CGRectMake(leftPadding, topPadding, cellW-(leftPadding+rightPadding), 24);

    CGFloat briefLblFY = 0;
    if ([NSString isValidString:_data.time]) {
        _timeLblF = CGRectMake(CGRectGetMinX(_titleLblF), CGRectGetMaxY(_titleLblF)+12, CGRectGetWidth(_titleLblF), 20);
        briefLblFY = CGRectGetMaxY(_timeLblF) + 6;
    } else {
        _timeLblF = CGRectZero;
        briefLblFY = CGRectGetMaxY(_titleLblF) + 12;
    }


    CGSize size = [[NSString realString:_data.brief] sizeWithFont:[UIFont fontWithName:@"PingFangSC-Regular" size:14] maxSize:CGSizeMake(CGRectGetWidth(_titleLblF), MAXFLOAT)];
    if (size.height <= 60) {
        // 不需要展示更多
        _openBtnF = CGRectZero;
        _shrinkBtnF = CGRectZero;

        _briefLblF = CGRectMake(CGRectGetMinX(_titleLblF), briefLblFY, CGRectGetWidth(_titleLblF), size.height);

        _cellHeight = CGRectGetMaxY(_briefLblF) + bottomPadding;


        _separatorLineViewF = CGRectMake(leftPadding, _cellHeight-0.5, cellW-leftPadding, 0.5);

        return;

    }


    if (isOpened) {
        _openBtnF = CGRectZero;
        NSString *contentStr = [NSString realString:_data.brief];
        CGSize size = [contentStr sizeWithFont:[UIFont fontWithName:@"PingFangSC-Regular" size:14] maxSize:CGSizeMake(CGRectGetWidth(_titleLblF), MAXFLOAT)];
        _briefLblF = CGRectMake(CGRectGetMinX(_titleLblF), briefLblFY, CGRectGetWidth(_titleLblF), size.height);

        _shrinkBtnF = CGRectMake(CGRectGetMinX(_titleLblF), CGRectGetMaxY(_briefLblF) - 6, 120, 45);

        _cellHeight = CGRectGetMaxY(_shrinkBtnF);

    } else {
        _shrinkBtnF = CGRectZero;

        NSString *contentStr = [NSString realString:_data.brief];
        CGSize size = [contentStr sizeWithFont:[UIFont fontWithName:@"PingFangSC-Regular" size:14] maxSize:CGSizeMake(CGRectGetWidth(_titleLblF), 60)];
        _briefLblF = CGRectMake(CGRectGetMinX(_titleLblF), briefLblFY, CGRectGetWidth(_titleLblF), size.height);

        _openBtnF = CGRectMake(CGRectGetMinX(_titleLblF), CGRectGetMaxY(_briefLblF) - 6, 120, 45);

        _cellHeight = CGRectGetMaxY(_openBtnF);

    }

    _separatorLineViewF = CGRectMake(leftPadding, _cellHeight-0.5, cellW-leftPadding, 0.5);



}





@end
