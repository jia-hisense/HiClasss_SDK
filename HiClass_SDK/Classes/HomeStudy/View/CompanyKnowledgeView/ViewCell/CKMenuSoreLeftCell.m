//
//  CKMenuSoreLeftCell.m
//  iTest
//
//  Created by Sir_Jing on 2020/3/12.
//  Copyright © 2020 Sir_Jing. All rights reserved.
//

#import "CKMenuSoreLeftCell.h"

@interface CKMenuSoreLeftCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation CKMenuSoreLeftCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createView];
    }
    return self;
}

-(void)createView {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, 93, 60)];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    label.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
    label.numberOfLines = 0;
    self.titleLabel = label;
    label.text = @"000000";

    [self.contentView addSubview:label];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    if (selected) {
        self.contentView.backgroundColor = UIColor.whiteColor;
        self.titleLabel.textColor = [UIColor colorWithRed:3/255.0 green:179/255.0 blue:204/255.0 alpha:1];
    }else {
        self.contentView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
        self.titleLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
    }
    if (self.isRightView) {
        self.contentView.backgroundColor = UIColor.whiteColor;
    }
}

// 页面赋值
-(void)setModel:(HICCompanyMenuModel *)model {
    _model = model;
    self.titleLabel.text = model.catalogName;
}

@end
