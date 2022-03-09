//
//  HomeStudyListCell.m
//  iTest
//
//  Created by Sir_Jing on 2020/3/10.
//  Copyright © 2020 Sir_Jing. All rights reserved.
//

#import "HomeStudyListCell.h"

#import "HICCustomerLabel.h"

@interface HomeStudyListCell ()

/// 新知识的背景View
@property (nonatomic, strong) UIView *numView;

/// 课程的图片View
@property (nonatomic, strong) UIImageView *iconImageView;

/// 课程的标题
@property (nonatomic, strong) UILabel *titleLabel;

/// 课程的副标题
@property (nonatomic, strong) UILabel *comentLabel;

/// 背景but
@property (nonatomic, strong) UIButton *backBut;

/// 视频视图
@property (nonatomic, strong) UIView *playView;

@end

@implementation HomeStudyListCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createView];
    }
    return self;
}

-(void)createView {

    CGFloat screenWidth = UIScreen.mainScreen.bounds.size.width;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(16, 11, 130, 73)];
    imageView.layer.cornerRadius = 4.f;
    imageView.layer.masksToBounds = YES;
    imageView.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6"];
    UIView *playView = [self createClassBackView:imageView];
    [imageView addSubview:playView];
    playView.hidden = YES;
    self.playView = playView;

    UIView *numView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 25, 13)];
    UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 25, 13)];
    numLabel.textAlignment = NSTextAlignmentCenter;
    numLabel.textColor = UIColor.whiteColor;
    numLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 9];
    [imageView addSubview:numView];
    // 渐变色
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = numLabel.bounds;
    [numView.layer addSublayer:gradientLayer];
    gradientLayer.startPoint = CGPointMake(0, 1);
    gradientLayer.endPoint = CGPointMake(1, 1);
    gradientLayer.colors = @[(__bridge id)[UIColor colorWithRed:1.0 green:133/255.0 blue:36/255.0 alpha:1].CGColor,
                             (__bridge id)[UIColor colorWithRed:1.0 green:75/255.0 blue:75/255.0 alpha:1].CGColor];
    gradientLayer.locations = @[@(0.0f), @(1.0f)];
    // 右下角半圆
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect: numLabel.bounds byRoundingCorners:UIRectCornerBottomRight cornerRadii:CGSizeMake(10,10)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = numLabel.bounds;
    maskLayer.path = maskPath.CGPath;
    numView.layer.mask = maskLayer;
    self.numView = numView;
    self.numView.hidden = YES; // 默认隐藏
    [numView addSubview:numLabel];
    numLabel.text = @"NEW";

    HICCustomerLabel *titleLabel = [[HICCustomerLabel alloc] initWithFrame:CGRectMake(16+12+130, 11, screenWidth-16*2-12-130, 51)];
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    titleLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
    titleLabel.numberOfLines = 0;

    UILabel *contenLabel = [[UILabel alloc] initWithFrame:CGRectMake(16+12+130, 11+40+14, screenWidth-16*2-12-130, 19)];
    contenLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    contenLabel.textColor = [UIColor colorWithRed:133/255.0 green:133/255.0 blue:133/255.0 alpha:1];

    UIButton *but = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 90)];
    [self.contentView addSubview:but];
    self.backBut = but;
    [but addTarget:self action:@selector(clickBackBut:) forControlEvents:UIControlEventTouchUpInside];

    [self.contentView addSubview:imageView];
    [self.contentView addSubview:titleLabel];
    [self.contentView addSubview:contenLabel];
    self.iconImageView = imageView;
    self.titleLabel = titleLabel;
    self.comentLabel = contenLabel;
}


-(void)setCellIndexPath:(NSIndexPath *)cellIndexPath {
    [super setCellIndexPath:cellIndexPath];

//    if (cellIndexPath.row == 0 || cellIndexPath.row == 1) {
//        [self changeTopTimeStr:@"9个笔记"];
//    }else {
//        self.comentLabel.text = @"jfiefiaefjaoefja  jfiejf";
//    }
}

// 修改富文本
-(void)changeTopTimeStr:(NSString *)str {

    NSArray*number =@[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"];

    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:str];

    for(int i =0; i < str.length; i ++) {

    //这里的小技巧，每次只截取一个字符的范围
    NSString *a = [str substringWithRange:NSMakeRange(i,1)];

        //判断装有0-9的字符串的数字数组是否包含截取字符串出来的单个字符，从而筛选出符合要求的数字字符的范围NSMakeRange
        if([number containsObject:a]) {
            [attributeString setAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0 green:190/255.0 blue:215/255.0 alpha:1]}range:NSMakeRange(i,1)];
        }
    }
    self.comentLabel.attributedText = [attributeString copy];
}

// 针对Cell赋值
-(void)setStudyClassModel:(HICHomeStudyClassModel *)studyClassModel {
    if (self.studyClassModel == studyClassModel) {
        return;
    }
    [super setStudyClassModel:studyClassModel];
    if (studyClassModel.courseKLD.isNew == 1) {
        self.numView.hidden = NO; // 显示new
    }else {
        self.numView.hidden = YES;
    }
    self.titleLabel.text = studyClassModel.courseKLD.courseKLDName;
    self.comentLabel.text = [NSString stringWithFormat:@"%ld%@  %ld%@",(long)studyClassModel.courseKLD.score,NSLocalizableString(@"points", nil), (long)studyClassModel.courseKLD.learnersNum,NSLocalizableString(@"peopleHaveToLearn", nil)];
    if (studyClassModel.courseKLD.coverPic) {
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:studyClassModel.courseKLD.coverPic]];
    }
    if (studyClassModel.courseKLD.resourceType == 1|| studyClassModel.courseKLD.resourceType == 2) {
        self.playView.hidden = NO;
    }else {
        self.playView.hidden = YES;
    }
}

-(void)setItemModel:(ResourceListItem *)itemModel {
    if (itemModel == self.itemModel) {
        return;
    }
    [super setItemModel:itemModel];
    self.numView.hidden = YES;
    NSDictionary *listDic = itemModel.courseInfo;
    self.titleLabel.text = itemModel.name;
    if (listDic && [listDic isKindOfClass:NSDictionary.class]) {
        self.comentLabel.text = [NSString stringWithFormat:@"%@%@  %@%@", [listDic objectForKey:@"score"],NSLocalizableString(@"points", nil), [listDic objectForKey:@"studiedNum"],NSLocalizableString(@"peopleHaveToLearn", nil)];
        if (itemModel.picPath) {
            [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:itemModel.picPath]];
        }
    }
    self.backBut.hidden = YES;
    if (itemModel.courseInfo && [itemModel.courseInfo objectForKey:@"fileType"]) {
        NSNumber *type = [itemModel.courseInfo objectForKey:@"fileType"];
        if ([type integerValue] == 1 || [type integerValue] == 2) {
            self.playView.hidden = YES; // TODO: 首页加载的不显示播放图标 -- 暂时隐藏
        }
    }else {
        self.playView.hidden = YES;
    }
}

-(void)clickBackBut:(UIButton *)btn {

    if ([self.delegate respondsToSelector:@selector(studyCell:clickItem:other:)]) {
        [self.delegate studyCell:self clickItem:self.studyClassModel other:nil];
    }
    if ([self.delegate respondsToSelector:@selector(studyCell:knoledgeModel:other:)]) {
        [self.delegate studyCell:self knoledgeModel:self.companyKnoledgeModel other:nil];
    }
}

-(void)setCompanyKnoledgeModel:(HSCourseKLD *)companyKnoledgeModel {
    if (self.companyKnoledgeModel == companyKnoledgeModel) {
        return;
    }
    [super setCompanyKnoledgeModel:companyKnoledgeModel];

    if (companyKnoledgeModel.isNew == 1) {
        self.numView.hidden = NO; // 显示new
    }else {
        self.numView.hidden = YES;
    }
    self.titleLabel.text = companyKnoledgeModel.courseKLDName;
    self.comentLabel.text = [NSString stringWithFormat:@"%ld%@ %ld%@",(long)companyKnoledgeModel.score, NSLocalizableString(@"points", nil),(long)companyKnoledgeModel.learnersNum,NSLocalizableString(@"peopleHaveToLearn", nil)];
    if (companyKnoledgeModel.coverPic) {
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:companyKnoledgeModel.coverPic]];
    }
    if (companyKnoledgeModel.resourceType == 1|| companyKnoledgeModel.resourceType == 2) {
        self.playView.hidden = NO;
    }else {
        self.playView.hidden = YES;
    }
}

@end
