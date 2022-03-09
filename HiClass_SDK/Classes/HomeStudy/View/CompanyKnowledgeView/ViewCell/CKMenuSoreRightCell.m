//
//  CKMenuSoreRightCell.m
//  iTest
//
//  Created by Sir_Jing on 2020/3/12.
//  Copyright © 2020 Sir_Jing. All rights reserved.
//

#import "CKMenuSoreRightCell.h"

@interface CKMenuSoreRightCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation CKMenuSoreRightCell

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, frame.size.width-10, frame.size.height)];
        _titleLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 0;
        _titleLabel.text = NSLocalizableString(@"all", nil);
        [self.contentView addSubview:_titleLabel];
    }
    return self;
}

-(void)setSelected:(BOOL)selected {
    if (selected) {
        self.titleLabel.textColor = [UIColor colorWithRed:3/255.0 green:179/255.0 blue:204/255.0 alpha:1];
    }else {
        self.titleLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
    }
}

-(void)setModel:(HICCompanyMenuModel *)model {
    _model = model;
    self.titleLabel.text = model.catalogName;
}

@end
