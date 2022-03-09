//
//  PostRequireCerCell.m
//  HiClass
//
//  Created by 铁柱， on 2020/4/20.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "PostRequireCerCell.h"

#define PostRequireCerCellTag 546712121

@interface PostRequireCerCell ()

@property (nonatomic, strong) UIView *cerBackView;

@end

@implementation PostRequireCerCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createView];
    }
    return self;
}

-(void)createView {
    UILabel *conLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.backView addSubview:conLabel];

    [conLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backView.mas_left).offset(16);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(2);
        make.right.equalTo(self.backView.mas_right).offset(-16);
    }];

    conLabel.text = NSLocalizableString(@"issueCertificate", nil);
    conLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    conLabel.font = FONT_REGULAR_13;

    self.titleLabel.text = NSLocalizableString(@"completeReward", nil);

    UIView *backView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.backView addSubview:backView];

    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backView.mas_left).offset(16);
        make.top.equalTo(conLabel.mas_bottom).offset(16);
        make.bottom.equalTo(self.backView.mas_bottom).offset(0);
        make.right.equalTo(self.backView.mas_right).offset(-16);
    }];
    _cerBackView = backView;
}

-(void)setCerModels:(NSArray<HICPostMapCerModel *> *)cerModels {
    if (self.cerModels == cerModels) {
        return;
    }
    [super setCerModels:cerModels];

    // 需要创建子视图
    [self.cerBackView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    CGFloat imageWidth = (HIC_ScreenWidth - 13 - 56)/2.0;
    CGFloat space = 13;
    for (NSInteger index = 0; index < cerModels.count; index++) {
        HICPostMapCerModel *model = [cerModels objectAtIndex:index];
        NSInteger line = index % 2;
        NSInteger row = index / 2;
        CGRect frame = CGRectMake(line*(imageWidth+space), row*(111+16), imageWidth, 111);
        UIView *view = [self createCerViewWithFrame:frame andModel:model andIndex:index];
        [self.cerBackView addSubview:view];
    }
}

-(UIView *)createCerViewWithFrame:(CGRect)frame andModel:(HICPostMapCerModel *)model andIndex:(NSInteger)index {
    UIView *view = [[UIView alloc] initWithFrame:frame];
    UIButton *but = [[UIButton alloc] initWithFrame:view.bounds];
    but.tag = PostRequireCerCellTag + index;
    [view addSubview:but];
    [but addTarget:self action:@selector(clickBackBut:) forControlEvents:UIControlEventTouchUpInside];

    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 86)];
    iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    iconImageView.layer.masksToBounds = YES;
    iconImageView.layer.cornerRadius = 4.f;
    iconImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    if (model.url) {
        [iconImageView sd_setImageWithURL:[NSURL URLWithString:model.url]];
    }else {
        iconImageView.image = [UIImage imageNamed:@"证书默认图"];
    }
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, iconImageView.height+6, frame.size.width, 18.5)];
    label.text = model.name;
    label.font = FONT_REGULAR_13;
    label.textColor = [UIColor colorWithHexString:@"#333333"];

    if (model.acquired == 0) {
        UIView *numView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 13)];
        UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 13)];
        numLabel.textAlignment = NSTextAlignmentCenter;
        numLabel.textColor = UIColor.whiteColor;
        numLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 9];
        [iconImageView addSubview:numView];
        numView.backgroundColor = [UIColor colorWithHexString:@"#B9B9B9"];
        // 右下角半圆
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect: numLabel.bounds byRoundingCorners:UIRectCornerBottomRight cornerRadii:CGSizeMake(4,4)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = numLabel.bounds;
        maskLayer.path = maskPath.CGPath;
        numView.layer.mask = maskLayer;
        [numView addSubview:numLabel];
        numLabel.text = NSLocalizableString(@"didNotGet", nil);
    }
    [view addSubview:iconImageView];
    [view addSubview:label];

    return view;
}

-(void)clickBackBut:(UIButton *)but {

    NSInteger index = but.tag - PostRequireCerCellTag;

    if (index < self.cerModels.count) {
        HICPostMapCerModel *model = [self.cerModels objectAtIndex:index];
        if ([self.delegate respondsToSelector:@selector(requireCell:clickBut:isShow:andModel:other:)]) {
            [self.delegate requireCell:self clickBut:but isShow:YES andModel:model other:nil];
        }
    }
    DDLogDebug(@"当前点击 ==== %ld", (long)index);
}

@end
