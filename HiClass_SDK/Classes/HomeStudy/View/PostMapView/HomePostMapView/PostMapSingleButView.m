//
//  PostMapSingleButView.m
//  iTest
//
//  Created by Sir_Jing on 2020/3/17.
//  Copyright © 2020 Sir_Jing. All rights reserved.
//

#import "PostMapSingleButView.h"

#import "Masonry.h"
#import "HICCustomerLabel.h"

@interface PostMapSingleButView (){
    NSArray<UIImage *> *_titleImages;
}

@property (nonatomic, strong) UILabel *postName;

@property (nonatomic, strong) UILabel *numLabel;

@end

@implementation PostMapSingleButView

-(instancetype)initWithPoint:(CGPoint)point {

    if (self = [super initWithFrame:CGRectMake(point.x-60, point.y-9, 120, 71)]) {
        _titleImages = @[[UIImage imageNamed:@"前序"], [UIImage imageNamed:@"当前"], [UIImage imageNamed:@"晋升"]];
        [self createView];
        self.backgroundColor = UIColor.clearColor;
    }
    return self;
}

-(void)createView {

    CGFloat viewWidth = self.frame.size.width;
    CGFloat center = viewWidth/2.0;
    UIButton *but = [[UIButton alloc] initWithFrame:CGRectMake(center-9, 0, 18, 18)];
    [but setBackgroundImage:_titleImages.firstObject forState:UIControlStateNormal];
    self.titleBut = but;

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 18+4, 120, 21)];
    titleLabel.textColor = UIColor.blackColor;
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    self.postName = titleLabel;
    titleLabel.text = [NSString stringWithFormat:@"XX%@",NSLocalizableString(@"jobs", nil)];

    UIButton *contentBut = [[UIButton alloc] initWithFrame:CGRectMake(0, 18+4+21+2, 120, 20)];
    [contentBut addTarget:self action:@selector(clickMoreBut:) forControlEvents:UIControlEventTouchUpInside];
    
    HICCustomerLabel *contentLabel = [[HICCustomerLabel alloc] initWithFrame:CGRectZero];
    contentLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
    contentLabel.textColor = UIColor.whiteColor;
    contentLabel.textAlignment = NSTextAlignmentCenter;
    contentLabel.layer.cornerRadius = 10;
    contentLabel.layer.masksToBounds = YES;
    contentLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    contentLabel.contentInset = UIEdgeInsetsMake(5, 10, 2, 10);
    self.numLabel = contentLabel;
    [contentBut addSubview:contentLabel];

    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(contentBut.mas_centerX);
        make.centerY.equalTo(contentBut.mas_centerY);
        make.height.offset(20);
    }];

    [self addSubview:but];
    [self addSubview:titleLabel];
    [self addSubview:contentBut];

    //测试
    contentLabel.text = [NSString stringWithFormat:@"01 | %@",NSLocalizableString(@"dogon", nil)];
}

// 页面赋值
-(void)setType:(NSInteger)type {
    _type = type;
    NSInteger index = type%3;
    [self.titleBut setBackgroundImage:_titleImages[index] forState:UIControlStateNormal];
}

-(void)setInfoModel:(MapLineInfoModel *)infoModel {
    _infoModel = infoModel;

    self.postName.text = infoModel.postName;
    if (infoModel.hasMore == 1) {
        // 显示更多
        self.numLabel.text = [NSString stringWithFormat:@"%@ | %@", infoModel.levelName,NSLocalizableString(@"dogon", nil)];
    }else {
        self.numLabel.text = infoModel.levelName;
    }
}

// 页面事件处理
-(void)clickMoreBut:(UIButton *)btn {

    if (self.isClickDidNode == NO) {
        DDLogDebug(@"当前前序节点和后续初第一个外不可点击");
        return;
    }

    if (self.infoModel.hasMore == 1) {
        if ([self.delegate respondsToSelector:@selector(singleButView:clickBut:type:itemModel:other:)]) {
            [self.delegate singleButView:self clickBut:btn type:1 itemModel:self.infoModel other:nil];
        }
    }else {
        if ([self.delegate respondsToSelector:@selector(singleButView:clickBut:type:itemModel:other:)]) {
            [self.delegate singleButView:self clickBut:btn type:2 itemModel:self.infoModel other:nil];
        }
    }
}

-(void)setIsClickDidNode:(BOOL)isClickDidNode {
    _isClickDidNode = isClickDidNode;

    // 不可点击的需要
    if (isClickDidNode) {
        NSInteger index = self.type%3;
        [self.titleBut setBackgroundImage:_titleImages[index] forState:UIControlStateNormal];
    }else {
        [self.titleBut setBackgroundImage:[UIImage imageNamed:@"岗位-置灰"] forState:UIControlStateNormal];
    }
}

@end
