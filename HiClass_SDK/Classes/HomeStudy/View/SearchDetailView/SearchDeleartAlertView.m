//
//  SearchDeleartAlertView.m
//  iTest
//
//  Created by Sir_Jing on 2020/3/18.
//  Copyright © 2020 Sir_Jing. All rights reserved.
//

#import "SearchDeleartAlertView.h"

@implementation SearchDeleartAlertView

-(instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        [self createView];
    }
    return self;
}

-(void)createView {

    CGFloat viewWidth = 280.f;
    CGFloat viewHeight = 151.6f;

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake((self.bounds.size.width-viewWidth)/2.0, (self.bounds.size.height-viewHeight)/2.0, viewWidth, viewHeight)];
    view.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    view.layer.cornerRadius = 12.f;
    view.layer.masksToBounds = YES;

    UILabel *alertLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 101)];
    alertLabel.textAlignment = NSTextAlignmentCenter;
    alertLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
    alertLabel.text = NSLocalizableString(@"deleteSearchPrompt", nil);
    alertLabel.backgroundColor = UIColor.whiteColor;

    UIButton *cancelBut = [[UIButton alloc] initWithFrame:CGRectMake(0, 101.5, 140, 50)];
    [cancelBut setTitle:NSLocalizableString(@"cancel", nil) forState:UIControlStateNormal];
    cancelBut.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:18];
    [cancelBut setTitleColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1] forState:UIControlStateNormal];
    [cancelBut setBackgroundColor:UIColor.whiteColor];
    [cancelBut addTarget:self action:@selector(clickCancelBut:) forControlEvents:UIControlEventTouchUpInside];

    UIButton *sureBut = [[UIButton alloc] initWithFrame:CGRectMake(140.5, 101.5, 139.5, 50)];
    [sureBut setTitleColor:[UIColor colorWithRed:3/255.0 green:179/255.0 blue:204/255.0 alpha:1] forState:UIControlStateNormal];
    [sureBut setTitle:NSLocalizableString(@"determine", nil) forState:UIControlStateNormal];
    sureBut.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
    [sureBut setBackgroundColor:UIColor.whiteColor];
    [sureBut addTarget:self action:@selector(clickSureBut:) forControlEvents:UIControlEventTouchUpInside];

    [view addSubview:alertLabel];
    [view addSubview:cancelBut];
    [view addSubview:sureBut];

    [self addSubview:view];
}

-(void)clickCancelBut:(UIButton *)but {
    [self removeFromSuperview];
}

-(void)clickSureBut:(UIButton *)but {
    if (self.clickSureBlock) {
        self.clickSureBlock();
    }
    [self removeFromSuperview];
}

@end
