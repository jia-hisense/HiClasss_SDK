//
//  SearchClassStudyCell.m
//  iTest
//
//  Created by Sir_Jing on 2020/3/18.
//  Copyright © 2020 Sir_Jing. All rights reserved.
//

#import "SearchClassStudyCell.h"
#import "HICCustomerLabel.h"

@interface SearchClassStudyCell ()

/// 新知识的背景View
@property (nonatomic, strong) UIView *numView;

@property (nonatomic, strong) UIView *classView;

/// 课程的图片View
@property (nonatomic, strong) UIImageView *iconImageView;

/// 课程的标题
@property (nonatomic, strong) UILabel *titleLabel;

/// 课程的副标题
@property (nonatomic, strong) UILabel *comentLabel;
/// 视频背景图
@property (nonatomic, strong) UIView *playView;
@end

@implementation SearchClassStudyCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = UIColor.whiteColor;
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

    UIView *numView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 36, 16)];
    UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 36, 16)];
    numLabel.textAlignment = NSTextAlignmentCenter;
    numLabel.textColor = UIColor.whiteColor;
    numLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 11];
    [imageView addSubview:numView];
    // 渐变色
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = numLabel.bounds;
    [numView.layer addSublayer:gradientLayer];
    gradientLayer.startPoint = CGPointMake(0, 1);
    gradientLayer.endPoint = CGPointMake(1, 1);
    gradientLayer.colors = @[(__bridge id)[UIColor colorWithRed:0.0 green:226/255.0 blue:216/255.0 alpha:1].CGColor,
                             (__bridge id)[UIColor colorWithRed:0.0 green:190/255.0 blue:215/255.0 alpha:1].CGColor];
    gradientLayer.locations = @[@(0.0f), @(1.0f)];
    // 右下角半圆
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect: numLabel.bounds byRoundingCorners:UIRectCornerBottomRight cornerRadii:CGSizeMake(3,3)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = numLabel.bounds;
    maskLayer.path = maskPath.CGPath;
    numView.layer.mask = maskLayer;
    self.classView = numView;
    self.classView.hidden = YES; // 默认隐藏
    [numView addSubview:numLabel];
    numLabel.text = NSLocalizableString(@"coursePackage", nil);

    HICCustomerLabel *titleLabel = [[HICCustomerLabel alloc] initWithFrame:CGRectMake(16+12+130, 11, screenWidth-16*2-12-130, 51)];
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    titleLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
    titleLabel.numberOfLines = 0;
    titleLabel.text = @"iiifiefeaiiif";

    UILabel *contenLabel = [[UILabel alloc] initWithFrame:CGRectMake(16+12+130, 11+40+14, screenWidth-16*2-12-130, 19)];
    contenLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    contenLabel.textColor = [UIColor colorWithRed:133/255.0 green:133/255.0 blue:133/255.0 alpha:1];
    contenLabel.text = @"3faefaf   yixuan jiifeiaf";

    [self.contentView addSubview:imageView];
    [self.contentView addSubview:titleLabel];
    [self.contentView addSubview:contenLabel];
    self.iconImageView = imageView;
    self.titleLabel = titleLabel;
    self.comentLabel = contenLabel;

    [self createNewView];
}

-(void)createNewView {
    UIView *numView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 25, 13)];
    UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 25, 13)];
    numLabel.textAlignment = NSTextAlignmentCenter;
    numLabel.textColor = UIColor.whiteColor;
    numLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 9];
    [_iconImageView addSubview:numView];
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
}


-(void)setCellIndexPath:(NSIndexPath *)cellIndexPath {
    _cellIndexPath = cellIndexPath;

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
-(void)setInfoModel:(SearchDetailInfoModel *)infoModel {
    if (_infoModel == infoModel) {
        return;
    }
    _infoModel = infoModel;
    if (infoModel.kldType == 6) {
        self.classView.hidden = NO;
    }else {
        self.classView.hidden = YES;
    }
    if (infoModel.isNew == 1) {
        self.numView.hidden = NO; // 显示new
        self.classView.hidden = YES;
    }else {
        self.numView.hidden = YES;
    }
    self.titleLabel.text = infoModel.title;
    self.comentLabel.text = [NSString stringWithFormat:@"%@%@  %ld%@", [HICCommonUtils formatFloat:infoModel.score], NSLocalizableString(@"points", nil),(long)infoModel.learnersNum,NSLocalizableString(@"peopleHaveToLearn", nil)];
    if (infoModel.coverPic) {
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:infoModel.coverPic]];
    }
    if (infoModel.resourceType == 1|| infoModel.resourceType == 2) {
        self.playView.hidden = NO;
    }else {
        self.playView.hidden = YES;
    }
}

/// 创建一个视频背景
-(UIView *)createClassBackView:(UIView *)backView {

    UIView *view = [[UIView alloc] initWithFrame:backView.bounds];

    UIImageView *palyImage = [[UIImageView alloc] initWithFrame:CGRectMake(view.bounds.size.width-15-5.5, view.bounds.size.height-15-5.5, 15, 15)];
    palyImage.image = [UIImage imageNamed:@"icon-播放"];
    [view addSubview:palyImage];

    view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];

    return view;
}


@end
