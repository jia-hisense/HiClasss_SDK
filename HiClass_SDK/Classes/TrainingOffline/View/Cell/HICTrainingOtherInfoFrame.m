//
//  HICTrainingOtherInfoFrame.m
//  HiClass
//
//  Created by hisense on 2020/4/17.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import "HICTrainingOtherInfoFrame.h"

@implementation HICTrainingOtherInfoFrame

-(instancetype)initWithTitle:(NSString *)title content:(NSString *)content isSeparatorHidden:(BOOL)isSeparatorHidden {
    self = [super init];
    if (self) {
        _title = title;
        _conent = content;
        _isSeparatorHidden = isSeparatorHidden;
        [self generateFrame];
    }
    return self;
}

- (void)generateFrame {
    CGFloat topPadding = 16;
    CGFloat bottomPadding = 16;
    CGFloat leftPadding = 16;
    CGFloat rightPadding = 16;
    CGFloat cellW = HIC_ScreenWidth;

    _titleF = CGRectMake(leftPadding, topPadding, cellW-(leftPadding+rightPadding), 24);

    CGSize size = [_conent sizeWithFont:[UIFont fontWithName:@"PingFangSC-Regular" size:14] maxSize:CGSizeMake(CGRectGetWidth(_titleF), MAXFLOAT)];

    _contentF = CGRectMake(leftPadding, CGRectGetMaxY(_titleF)+12, CGRectGetWidth(_titleF), size.height);

    _cellHeight = CGRectGetMaxY(_contentF) + bottomPadding;

    if (_isSeparatorHidden) {
        _separatorLineViewF = CGRectZero;
    } else {
        _separatorLineViewF = CGRectMake(leftPadding, _cellHeight-0.5, cellW-leftPadding, 0.5);
    }

}



@end
