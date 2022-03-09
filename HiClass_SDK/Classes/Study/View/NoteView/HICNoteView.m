//
//  HICNoteView.m
//  HiClass
//
//  Created by Eddie Ma on 2020/2/8.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICNoteView.h"
@interface HICNoteView()
@property (nonatomic, assign) BOOL hasNote;
@property (nonatomic, strong) UIButton *checkNoteView;
@end

@implementation HICNoteView

- (instancetype)initWithFrame:(CGRect)frame hasNote:(BOOL)hasNote {
    if (self = [super initWithFrame:frame]) {
        self.hasNote = hasNote;
        [self creatUI];
    }
    return self;
}

- (void)creatUI {
    self.hidden = YES;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 0.2;
    self.layer.shadowOffset = CGSizeZero;
    self.layer.shadowRadius = 2;
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 3;

    UIView *containerView = [[UIView alloc] init];
    [self addSubview:containerView];
    containerView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);

    // 添加笔记
    UIButton *addNoteView = [[UIButton alloc] init];
    [containerView addSubview: addNoteView];
    addNoteView.frame = CGRectMake(0, 0, containerView.frame.size.width, (containerView.frame.size.height - 0.5)/2);
    [addNoteView setTitle:NSLocalizableString(@"addNote", nil) forState:UIControlStateNormal];
    [addNoteView setTitleColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0] forState:UIControlStateNormal];
    [addNoteView setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [addNoteView setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#e6e6e6"]] forState:UIControlStateHighlighted];
    [HICCommonUtils setRoundingCornersWithView:addNoteView TopLeft:YES TopRight:YES bottomLeft:NO bottomRight:NO cornerRadius:3];
    addNoteView.titleLabel.font = FONT_REGULAR_16;
    addNoteView.tag = 10000;
    [addNoteView addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    // 中间分割线
    UIView *dividedLine = [[UIView alloc] init];
    [containerView addSubview: dividedLine];
    dividedLine.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1/1.0];
    dividedLine.frame = CGRectMake(0, addNoteView.frame.size.height, containerView.frame.size.width, 0.5);
    // 查阅笔记
    self.checkNoteView = [[UIButton alloc] init];
    [containerView addSubview:self.checkNoteView];
    self.checkNoteView.frame = CGRectMake(0, addNoteView.frame.size.height + 0.5, containerView.frame.size.width, (containerView.frame.size.height - 0.5)/2);
    [self.checkNoteView setTitle:NSLocalizableString(@"readNote", nil) forState:UIControlStateNormal];
    [self.checkNoteView setTitleColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:_hasNote ? 1/1.0 : 0.7] forState:UIControlStateNormal];
    [self.checkNoteView setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [self.checkNoteView setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#e6e6e6"]] forState:UIControlStateHighlighted];
    [HICCommonUtils setRoundingCornersWithView:self.checkNoteView TopLeft:NO TopRight:NO bottomLeft:YES bottomRight:YES cornerRadius:3];
    self.checkNoteView.titleLabel.font = FONT_REGULAR_16;
    self.checkNoteView.tag = 20000;
    [self.checkNoteView addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)show {
    self.hidden = NO;
}

- (void)hide {
    self.hidden = YES;
}

- (void)hasNote:(BOOL)hasNote {
    _hasNote = hasNote;
    [self.checkNoteView setTitleColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:_hasNote ? 1/1.0 : 0.7] forState:UIControlStateNormal];
}

- (void)btnClicked:(UIButton *)btn {
    if (btn.tag == 10000) {
        // 添加笔记被点击
        if ([self.delegate respondsToSelector:@selector(addNoteClicked)]) {
            [self.delegate addNoteClicked];
        }
    } else {
        // 查阅笔记被点击
        if ([self.delegate respondsToSelector:@selector(checkNoteClicked)] && _hasNote) {
            [self.delegate checkNoteClicked];
        }
    }
}

@end
