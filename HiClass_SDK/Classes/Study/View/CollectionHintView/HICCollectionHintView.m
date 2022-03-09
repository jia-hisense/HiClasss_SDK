//
//  HICCollectionHintView.m
//  HiClass
//
//  Created by Eddie Ma on 2020/2/10.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICCollectionHintView.h"

@implementation HICCollectionHintView

- (instancetype)init {
    if (self = [super init]) {
        [self creatUI];
    }
    return self;
}

- (void)creatUI {
    self.frame = CGRectMake(0, 0, HIC_ScreenWidth, HIC_ScreenHeight);
    UIView *bgView = [[UIView alloc] initWithFrame:self.frame];
    bgView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.5];
    [self addSubview:bgView];

    UIView *hintContainer = [[UIView alloc] init];
    [bgView addSubview:hintContainer];
    CGFloat hintContainerX = [[HICCommonUtils iphoneType] isEqualToString:@"l-iPhone"] ? 0.17 * HIC_ScreenWidth : 0.14 * HIC_ScreenWidth;
    CGFloat hintContainerW = bgView.frame.size.width - 2 * hintContainerX;
    CGFloat hintContainerH = 295.6 * hintContainerW / 280;
    hintContainer.frame = CGRectMake(hintContainerX, (HIC_ScreenHeight - hintContainerH)/2, bgView.frame.size.width - 2 * hintContainerX, hintContainerH);
    hintContainer.backgroundColor = [UIColor whiteColor];
    hintContainer.layer.cornerRadius = 12;
    hintContainer.layer.masksToBounds = YES;

    UILabel *title = [[UILabel alloc] init];
    [hintContainer addSubview: title];
    title.frame = CGRectMake(20, 20, hintContainer.frame.size.width - 2 * 20, 19);
    title.font = FONT_MEDIUM_18;
    title.text = NSLocalizableString(@"checkOutMyCollection", nil);
    title.textColor = [UIColor colorWithRed:24/255.0 green:24/255.0 blue:24/255.0 alpha:1/1.0];
    title.textAlignment = NSTextAlignmentCenter;

    UIImageView *imv = [[UIImageView alloc] init];
    [hintContainer addSubview: imv];
    CGFloat imvW = hintContainer.frame.size.width - 20 * 2;
    imv.frame = CGRectMake(20, 51, imvW, imvW/2);
    imv.backgroundColor = [UIColor colorWithRed:216/255.0 green:216/255.0 blue:216/255.0 alpha:1/1.0];
    imv.image = [UIImage imageNamed:@"tabbar_collectionHint"];

    UILabel *collectionDesc = [[UILabel alloc] init];
    [hintContainer addSubview: collectionDesc];
    collectionDesc.frame = CGRectMake(17.5, hintContainer.frame.size.height - 70.6 - 42, hintContainer.frame.size.width - 17.5 * 2, 42);
    collectionDesc.font = FONT_REGULAR_15;
    collectionDesc.text = NSLocalizableString(@"clickLookAllCollection", nil);
    collectionDesc.numberOfLines = 2;
    collectionDesc.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1/1.0];
    collectionDesc.textAlignment = NSTextAlignmentCenter;

    UIView *dividedLine = [[UIView alloc] initWithFrame:CGRectMake(0, hintContainer.frame.size.height - 50.1 - 0.5, hintContainer.frame.size.width, 0.5)];
    [hintContainer addSubview:dividedLine];
    dividedLine.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1/1.0];

    UIButton *iKnowBtn = [[UIButton alloc] init];
    [hintContainer addSubview:iKnowBtn];
    iKnowBtn.frame = CGRectMake(0, hintContainer.frame.size.height - 50.1, hintContainer.frame.size.width, 50.1);
    [iKnowBtn setTitleColor:[UIColor colorWithRed:0/255.0 green:190/255.0 blue:215/255.0 alpha:1/1.0] forState:UIControlStateNormal];
    [iKnowBtn setTitle:NSLocalizableString(@"iKnow", nil) forState:UIControlStateNormal];
    iKnowBtn.titleLabel.font = FONT_MEDIUM_18;
    iKnowBtn.tag = 10000;
    [iKnowBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];

}

- (void)btnClick:(UIButton *)btn {
    if (btn.tag == 10000) {
        [self removeFromSuperview];
    }
}

@end
