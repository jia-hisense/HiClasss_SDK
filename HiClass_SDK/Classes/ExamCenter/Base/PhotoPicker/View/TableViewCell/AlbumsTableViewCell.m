//
//  AlbumsTableViewCell.m
//  HiClass
//
//  Created by Eddie Ma on 2020/1/14.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "AlbumsTableViewCell.h"

@interface AlbumsTableViewCell ()

@property (nonatomic, strong) UILabel *titleLable;
@property (nonatomic, strong) UILabel *amount;
@property (nonatomic, strong) UIImageView *photoIV;
@property (nonatomic, strong) UIImageView *picked;

@end

@implementation AlbumsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self creatUI];
        [self updateConstraintsIfNeeded];
    }
    return self;
}

- (void)creatUI {
    self.backgroundColor = [UIColor colorWithRed:40/255.0 green:40/255.0 blue:40/255.0 alpha:1/1.0];
    [self setHighlighted:YES];

    self.photoIV = [[UIImageView alloc] init];
    self.photoIV.contentMode = UIViewContentModeScaleAspectFill;
    self.photoIV.clipsToBounds = YES;
    [self.contentView addSubview:self.photoIV];

    self.titleLable = [[UILabel alloc] init];
    self.titleLable.font = FONT_REGULAR_16;
    self.titleLable.textColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1/1.0];
    [self.contentView addSubview: self.titleLable];

    self.amount = [[UILabel alloc] init];
    self.amount.font = FONT_REGULAR_16;
    self.amount.text = @"()";
    self.amount.textColor = [UIColor colorWithRed:133/255.0 green:133/255.0 blue:133/255.0 alpha:1/1.0];
    [self.contentView addSubview: self.amount];

    self.picked = [[UIImageView alloc] init];
    self.picked.image = [UIImage imageNamed:@"对勾"];
    self.picked.hidden = YES;
    [self.contentView addSubview: self.picked];
}

- (void)updateConstraints {
    [super updateConstraints];
    [self.photoIV mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(0);
        make.left.equalTo(self).offset(0);
        make.width.offset(PH_TABLE_CELL_HEIGHT);
        make.height.offset(PH_TABLE_CELL_HEIGHT);
    }];

    [self.titleLable mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.photoIV.mas_right).offset(12);
        make.centerY.equalTo(self);
    }];

    [self.amount mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLable.mas_right).offset(10);
        make.centerY.equalTo(self);
    }];

    [self.picked mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-16);
        make.centerY.equalTo(self);
        make.width.offset(15);
        make.height.offset(15);
    }];

}

- (void)setDataWith:(NSString *)title photo:(UIImage *)img amount:(NSUInteger)amount showPicked:(BOOL)show {
    self.titleLable.text = title;
    self.photoIV.image = img ? img : [UIImage imageNamed:@"bt-清空"];
    self.amount.text = [NSString stringWithFormat:@"(%lu)", (unsigned long)amount];
    self.picked.hidden = !show;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{//重写高亮函数
    if (highlighted) {
        self.backgroundColor =  [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.2/1.0];
    }else{
        self.backgroundColor = [UIColor clearColor];
    }
}

@end
