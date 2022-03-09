//
//  HomeStudyModelFourCollectionCell.m
//  iTest
//
//  Created by Sir_Jing on 2020/3/10.
//  Copyright © 2020 Sir_Jing. All rights reserved.
//

#import "HomeStudyModelFourCollectionCell.h"

//#import "UIImageView+WebCache.h"

@interface HomeStudyModelFourCollectionCell ()

@property (nonatomic, strong) UILabel *numLabel;

@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic, strong) UILabel *nameLabel;

@end

@implementation HomeStudyModelFourCollectionCell

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createView];
    }
    return self;
}

-(void)createView {

    UIImageView *teacherImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    teacherImageView.layer.cornerRadius = 4.f;
    teacherImageView.layer.masksToBounds = YES;
    teacherImageView.backgroundColor = UIColor.grayColor;

    UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 13, 13)];
    numLabel.backgroundColor = UIColor.redColor;
    numLabel.textAlignment = NSTextAlignmentCenter;
    numLabel.textColor = UIColor.whiteColor;
    numLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 10];
    [teacherImageView addSubview:numLabel];
    // 右下角半圆
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect: numLabel.bounds byRoundingCorners:UIRectCornerBottomRight cornerRadii:CGSizeMake(10,10)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = numLabel.bounds;
    maskLayer.path = maskPath.CGPath;
    numLabel.layer.mask = maskLayer;
    self.numLabel = numLabel;
    self.numLabel.hidden = YES; // 默认隐藏

    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 61, 60, 88-62)];
    nameLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.text = @"赵老师找";

    [self.contentView addSubview:nameLabel];
    [self.contentView addSubview:teacherImageView];

    self.iconImageView = teacherImageView;
    self.nameLabel = nameLabel;
}


-(void)setItemIndexPath:(NSIndexPath *)itemIndexPath {

    _itemIndexPath = itemIndexPath;

    if (itemIndexPath.row == 0) {
        self.numLabel.text = @"1";
        self.numLabel.backgroundColor = [UIColor colorWithRed:1.0 green:75/255.0 blue:75/255.0 alpha:1];
        self.numLabel.hidden = NO;
    }else if (itemIndexPath.row == 1) {
        self.numLabel.text = @"2";
        self.numLabel.backgroundColor = [UIColor colorWithRed:1.0 green:133/255.0 blue:0 alpha:1];
        self.numLabel.hidden = NO;
    }else if (itemIndexPath.row == 2) {
        self.numLabel.text = @"3";
        self.numLabel.backgroundColor = [UIColor colorWithRed:1.0 green:190/255.0 blue:83/255.0 alpha:1];
        self.numLabel.hidden = NO;
    }else {
        self.numLabel.text = @"";
        self.numLabel.hidden = YES;
    }
}

// 页面赋值
-(void)setModel:(ResourceListItem *)model {
    if (_model == model) {
        return;
    }
    _model = model;
    // 没有图片的情况下使用默认图片
    if (self.iconImageView.subviews.count > 0) {
        [self.iconImageView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    self.iconImageView.image = nil;
    if ([NSString isValidStr:model.picPath]) {
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.picPath]];
        [self.iconImageView addSubview:self.numLabel];
    }else {
        NSString *name = model.name;
//        if (name.length == 0) {
//            name = @"无";
//        }
//        NSArray *names = [name componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@",.<>/?;'\"|，。/？‘“、()（）"]];
//        name = names.firstObject;
//        if (name.length == 0) {
//            name = @"无";
//        }
//        name = [name substringWithRange:NSMakeRange(name.length-1, 1)];
        UILabel *label = [HICCommonUtils setHeaderFrame:self.iconImageView.bounds andText:name];
        label.hidden = NO;
        [self.iconImageView addSubview:label];
        [self.iconImageView addSubview:self.numLabel];
    }
    self.nameLabel.text = model.name;
}

@end
