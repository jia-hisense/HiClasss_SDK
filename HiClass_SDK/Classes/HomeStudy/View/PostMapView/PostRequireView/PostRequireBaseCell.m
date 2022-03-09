//
//  PostRequireBaseCell.m
//  iTest
//
//  Created by Sir_Jing on 2020/3/18.
//  Copyright © 2020 Sir_Jing. All rights reserved.
//

#import "PostRequireBaseCell.h"

@implementation PostRequireBaseCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createBaseView];
    }
    return self;
}

-(void)createBaseView {
    self.backView = [[UIView alloc] initWithFrame:CGRectZero];
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    [self.contentView addSubview:self.backView];
    [self.backView addSubview:self.titleLabel];

    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(12);
        make.left.equalTo(self.contentView.mas_left).offset(12);
        make.right.equalTo(self.contentView.mas_right).offset(-12);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-2);
    }];

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backView.mas_top).offset(16);
        make.left.equalTo(self.backView.mas_left).offset(16);
        make.right.equalTo(self.backView.mas_right).offset(-16);
    }];

    self.backView.backgroundColor = [UIColor whiteColor];
    self.backView.layer.cornerRadius = 4.f;
    self.backView.layer.masksToBounds = YES;

    self.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    self.titleLabel.text = NSLocalizableString(@"title", nil);
    self.titleLabel.textColor = [UIColor blackColor];
}

+(CGFloat)getContentLabelHeightWith:(NSString *)str {
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size:14]};

    CGSize retSize = [str boundingRectWithSize:CGSizeMake(PostRequireContentWidth, 0)
                                       options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                    attributes:attribute
                                       context:nil].size;

    return retSize.height;
}

@end
