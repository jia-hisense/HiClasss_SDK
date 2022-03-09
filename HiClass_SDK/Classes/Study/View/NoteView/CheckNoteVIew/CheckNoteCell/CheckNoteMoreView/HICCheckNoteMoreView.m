//
//  HICCheckNoteMoreView.m
//  HiClass
//  每个笔记点击"更多操作"按钮后弹出的view
//  Created by Eddie Ma on 2020/2/11.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICCheckNoteMoreView.h"
@interface HICCheckNoteMoreView()

@end

@implementation HICCheckNoteMoreView

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)arr {
    if (self = [super initWithFrame:frame]) {
        self.viewTitles = arr;
    }
    return self;
}

- (void)setViewTitles:(NSArray *)arr {
    _viewTitles = arr;
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self creatUI];
}

- (void)creatUI {
//    self.hidden = YES;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 0.2;
    self.layer.shadowOffset = CGSizeZero;
    self.layer.shadowRadius = 2;
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 3;

    NSInteger count = _viewTitles.count;
    CGFloat itemHeight = (self.frame.size.height - 0.5 * (count - 1))/count;
    for (int i = 0; i < _viewTitles.count; i ++) {
        UIButton *addNoteView = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview: addNoteView];
        addNoteView.frame = CGRectMake(0, i * itemHeight + i * 0.5, self.frame.size.width, itemHeight);
        [addNoteView setTitle:_viewTitles[i] forState:UIControlStateNormal];
        [addNoteView setTitleColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0] forState:UIControlStateNormal];
        [addNoteView setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [addNoteView setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#e6e6e6"]] forState:UIControlStateHighlighted];
        if (i == 0) {
            [HICCommonUtils setRoundingCornersWithView:addNoteView TopLeft:YES TopRight:YES bottomLeft:NO bottomRight:NO cornerRadius:3];
        }
        if (i == count - 1) {
            [HICCommonUtils setRoundingCornersWithView:addNoteView TopLeft:NO TopRight:NO bottomLeft:YES bottomRight:YES cornerRadius:3];
        }
        addNoteView.layer.masksToBounds = YES;
        addNoteView.titleLabel.font = FONT_REGULAR_16;
        addNoteView.tag = 10000 + i;
        [addNoteView addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        // 中间分割线
        if (i != count - 1) {
            UIView *dividedLine = [[UIView alloc] init];
            [self addSubview: dividedLine];
            dividedLine.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1/1.0];
            dividedLine.frame = CGRectMake(0, (i + 1) * itemHeight + i * 0.5, self.frame.size.width, 0.5);
        }
    }

}

- (void)btnClicked:(UIButton *)btn {
    if (btn.tag == 10000) {
        if ([self.delegate respondsToSelector:@selector(copyClicked)]) {
            [self.delegate copyClicked];
        }
    } else if (btn.tag == 10001) {
        if ([self.delegate respondsToSelector:@selector(deleteClicked)]) {
            [self.delegate deleteClicked];
        }
    } else {
        if ([self.delegate respondsToSelector:@selector(setToImportantClicked)]) {
            [self.delegate setToImportantClicked];
        }
    }
}

@end
