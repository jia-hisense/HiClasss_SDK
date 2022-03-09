//
//  HICLectureCalendarTrainFrame.m
//  HiClass
//
//  Created by hisense on 2020/5/15.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import "HICLectureCalendarTrainFrame.h"
#import "NSString+String.h"

@implementation HICLectureCalendarTrainFrame
- (instancetype)initWithTrain:(HICLectureTrainSubModel *)train isSeparatorHidden:(BOOL)isSeparatorHidden {
    self = [super init];
    if (self) {
        self.isSeparatorHidden = isSeparatorHidden;
        self.train = train;
    }
    return self;
}

- (void)setTrain:(HICLectureTrainSubModel *)train {
    _train = train;

    CGFloat leftPadding = 28;
    CGFloat topPadding = 16;
    CGFloat bottomPadding = 8;
    CGFloat rightPadding = 28;
    CGFloat cellW = HIC_ScreenWidth;

    NSString *imageName;
    NSAttributedString *title;
    if(train.trainCategory == InsideTrain){
       imageName = @"标签_内训";
        title = [NSAttributedString stringInsertImageWithImageName:imageName imageReact:CGRectMake(0, -2, 32, 16) content:[NSString stringWithFormat:@" %@", [NSString realString:train.trainName]] stringColor:[UIColor colorWithHexString:@"#333333"] stringFont:[UIFont fontWithName:@"PingFangSC-Medium" size:17]];
    } else {
        if (train.trainCategory == OutsideTrain) {
            imageName = @"标签_外请";
        }else if (train.trainCategory == OutWardTrain){
            imageName = @"标签_外送培训";
        }
        if ([NSString isValidString:imageName]) {
            title = [NSAttributedString stringInsertImageWithImageName:imageName imageReact:CGRectMake(0, -2, 55, 16) content:[NSString stringWithFormat:@" %@", [NSString realString:train.trainName]] stringColor:[UIColor colorWithHexString:@"#333333"] stringFont:[UIFont fontWithName:@"PingFangSC-Medium" size:17]];
        } else {
            title = [[NSAttributedString alloc] initWithString:[NSString realString:train.trainName] attributes:@{NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#333333"], NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Medium" size:17]}];
        }
 
    }
    _titleAtt = title;
    CGSize titleSize = [title boundingRectWithSize:CGSizeMake(cellW-leftPadding-rightPadding, 48) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
    CGFloat titleHeight = MIN(titleSize.height, 48);
    titleHeight = MAX(titleHeight, 24);
    _titleLblF = CGRectMake(leftPadding, topPadding, cellW-leftPadding-rightPadding, titleHeight);

    _cellHeight = CGRectGetMaxY(_titleLblF) + bottomPadding;

    _bgViewlF = CGRectMake(12, 0, cellW-24, _cellHeight);

    if (self.isSeparatorHidden) {
        _separatorLineViewF = CGRectZero;
    } else {
        _separatorLineViewF = CGRectMake(28, _cellHeight-0.5, cellW-56, 0.5);
    }

}

- (void)setIsSeparatorHidden:(BOOL)isSeparatorHidden {
    _isSeparatorHidden = isSeparatorHidden;
    if (isSeparatorHidden) {
        _separatorLineViewF = CGRectZero;
    } else {
        CGFloat cellW = HIC_ScreenWidth;
        _separatorLineViewF = CGRectMake(28, _cellHeight-0.5, cellW-56, 0.5);
    }
}

@end
