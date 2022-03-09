//
//  RankingListHeaderView.m
//  iTest
//
//  Created by Sir_Jing on 2020/3/12.
//  Copyright © 2020 Sir_Jing. All rights reserved.
//

#import "RankingListHeaderView.h"

@interface RankingListHeaderView ()

@property (nonatomic, strong) NSArray *scroColors;

@end

@implementation RankingListHeaderView

-(instancetype)initWithModel:(HICMyRankInfoModel *)model {
    _infoModel = model;
    CGFloat screenWidth = UIScreen.mainScreen.bounds.size.width;
    if (self = [super initWithFrame:CGRectMake(0, 0, screenWidth, 90)]) {
        [self createView];
        self.scroColors = @[[UIColor colorWithRed:1 green:75/255.0 blue:75/255.0 alpha:1],
                            [UIColor colorWithRed:1 green:133/255.0 blue:0 alpha:1],
                            [UIColor colorWithRed:245/255.0 green:166/255.0 blue:35/255.0 alpha:1],
                            [UIColor colorWithRed:133/255.0 green:133/255.0 blue:133/255.0 alpha:1]];
        self.backgroundColor = UIColor.whiteColor;
    }
    return self;
}

-(void)createView {
    if (![HICCommonUtils isValidObject:_infoModel]) {
        return;
    }
    CGFloat screenWidth = self.frame.size.width;
    CGFloat imageWidth = 50.f;
    CGFloat scroWidth = 150.f;
    CGFloat scroRight = 16.f;
    CGFloat scroLeft = 25;
    UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 16, 38, 50)];
    numLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
    numLabel.textAlignment = NSTextAlignmentCenter;
    numLabel.numberOfLines = 0;
    numLabel.textColor = [UIColor colorWithRed:133/255.0 green:133/255.0 blue:133/255.0 alpha:1];
    numLabel.text = _infoModel.orderNum == -1 ? @"--":[NSString stringWithFormat:@"%ld",(long)_infoModel.orderNum];
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(48, 16, imageWidth, imageWidth)];
    iconImageView.layer.cornerRadius = 4.f;
    iconImageView.layer.masksToBounds = YES;
    iconImageView.backgroundColor = [UIColor colorWithHexString:@"e6e6e6"];;
    if ([NSString isValidStr:_infoModel.pic]) {
        [iconImageView sd_setImageWithURL:[NSURL URLWithString:_infoModel.pic]];
    } else {
        if ([NSString isValidStr:_infoModel.name]) {
            UILabel *imageLabel = [HICCommonUtils setHeaderFrame:CGRectMake(0, 0, imageWidth, imageWidth) andText:_infoModel.name];
            imageLabel.hidden = NO;
            [iconImageView addSubview:imageLabel];
        }
    }
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(48 + imageWidth + 10, 18.5, screenWidth - (48 + imageWidth + 10 + scroLeft + scroRight + 60), 22.5)];
    nameLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    nameLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(48 + imageWidth + 10, 18.5 + 3 + 22.5, screenWidth - (48 + imageWidth + 10 + scroLeft + scroRight + 60), 20)];
    contentLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    contentLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
    if ([NSString isValidStr:_infoModel.name]) {
        nameLabel.text = _infoModel.name;
    }
    if ([NSString isValidStr:_infoModel.dept]) {
        contentLabel.text = _infoModel.dept;
    }
    UILabel *scroLabel = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth - scroWidth - scroRight, 18.5, scroWidth, 22.5)];
    scroLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
    scroLabel.textAlignment = NSTextAlignmentRight;
    scroLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    if ([NSString isValidStr:_infoModel.score] && ![_infoModel.score isEqualToString:@"-1"]) {
        scroLabel.text = _infoModel.score;
    } else {
        scroLabel.text  = [NSString stringWithFormat:@"0%@",NSLocalizableString(@"points", nil)];
    }
    
    [self addSubview:numLabel];
    [self addSubview:iconImageView];
    [self addSubview:nameLabel];
    [self addSubview:contentLabel];
    [self addSubview:scroLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-8, screenWidth, 8)];
    lineView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    [self addSubview:lineView];
    
}

@end
