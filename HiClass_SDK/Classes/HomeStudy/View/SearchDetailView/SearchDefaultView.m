//
//  SearchDefaultView.m
//  HiClass
//
//  Created by Sir_Jing on 2020/3/20.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "SearchDefaultView.h"

@implementation SearchDefaultView

-(instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        [self createView];
    }
    return self;
}

-(void)createView {

    CGFloat screenWidth = self.frame.size.width;
    CGFloat screenHeight = self.frame.size.height;
    CGFloat imageWidth = 110;
    CGFloat labelTotal = 31.f;

    CGFloat imageTop = screenHeight/2.0 - (imageWidth + labelTotal)/2.0;
    CGFloat imageLeft = screenWidth/2.0 - imageWidth/2.0;

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageLeft, imageTop, imageWidth, imageWidth)];
    imageView.image = [UIImage imageNamed:@"搜索无结果"];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, imageTop+imageWidth+8, screenWidth-100, 50)];
    label.numberOfLines = 2;
    label.text = NSLocalizableString(@"noContentPrompt", nil);
    label.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];

    [self addSubview:imageView];
    [self addSubview:label];
    self.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
}

@end
