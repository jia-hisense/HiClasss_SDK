//
//  PostRequireDutyCell.m
//  iTest
//
//  Created by Sir_Jing on 2020/3/18.
//  Copyright © 2020 Sir_Jing. All rights reserved.
//

#import "PostRequireDutyCell.h"

@interface PostRequireDutyCell ()

@property (nonatomic, strong) UILabel *contentLabel;

@property (nonatomic, strong) UIButton *moreBut;

@end

@implementation PostRequireDutyCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createView];
    }
    return self;
}

-(void)createView {
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.backView addSubview:contentLabel];

    [contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backView.mas_left).offset(16);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(12);
        make.right.equalTo(self.backView.mas_right).offset(-16);
    }];

    UIButton *but = [[UIButton alloc]initWithFrame:CGRectZero];
    [but setHidden:YES];
    [self.backView addSubview:but];
    self.moreBut = but;

    [but mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backView.mas_left).offset(14);
        make.top.equalTo(contentLabel.mas_bottom).offset(5);
        make.width.offset(35);
        make.height.offset(20);
    }];

    self.titleLabel.text = NSLocalizableString(@"jobResponsibility", nil);

    contentLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    contentLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
    contentLabel.numberOfLines = 3;
    self.contentLabel = contentLabel;

    [but setTitle:NSLocalizableString(@"develop", nil) forState:UIControlStateNormal];
    [but setTitle:NSLocalizableString(@"packUp", nil) forState:UIControlStateSelected];
    but.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    [but setTitleColor:[UIColor colorWithRed:3/255.0 green:179/255.0 blue:204/255.0 alpha:1] forState:UIControlStateNormal];
    [but addTarget:self action:@selector(clickMoreBut:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)clickMoreBut:(UIButton *)but {

    BOOL select = but.selected;
    but.selected = !select;
    if (!select) {
        self.contentLabel.numberOfLines = 0;
    }else {
        self.contentLabel.numberOfLines = 3;
    }


    if ([self.delegate respondsToSelector:@selector(requireCell:showMoreBut:isShow:other:)]) {
        [self.delegate requireCell:self showMoreBut:but isShow:!select other:@1];
    }
}

-(void)setModel:(HICPostMapDetailReqModel *)model {

    if (self.model == model) {
        return;
    }
    [super setModel:model];

    CGFloat height = [PostRequireBaseCell getContentLabelHeightWith:model.duty];
    if (height>60) {
        self.moreBut.hidden = NO;
    }
    if (model.duty && ![model.duty isEqualToString:@""]) {
        self.contentLabel.text = model.duty;
    }else {
        self.contentLabel.text = NSLocalizableString(@"noNow", nil);
    }

}

@end
