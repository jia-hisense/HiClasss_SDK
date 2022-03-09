//
//  CKMenuTypeCell.m
//  iTest
//
//  Created by Sir_Jing on 2020/3/12.
//  Copyright © 2020 Sir_Jing. All rights reserved.
//

#import "CKMenuTypeCell.h"

@interface CKMenuTypeCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIImageView *checkView;

@end

@implementation CKMenuTypeCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createView];
    }
    return self;
}

-(void)createView {

    CGFloat screenWidth = UIScreen.mainScreen.bounds.size.width;
    UIButton *backBut = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 44)];
    [backBut setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1]] forState:UIControlStateHighlighted];
//    [self.contentView addSubview:backBut];

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 11.5, screenWidth - 16*2 - 15*2, 21)];
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    titleLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
    self.titleLabel = titleLabel;

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(screenWidth - 16-15, 14.5, 15, 15)];
    imageView.image = [UIImage imageNamed:@"选择-对勾"];
    self.checkView = imageView;
    imageView.hidden = YES;

    [self.contentView addSubview:titleLabel];
    [self.contentView addSubview:imageView];

}

-(void)setCellIndexPath:(NSIndexPath *)cellIndexPath {

    _cellIndexPath = cellIndexPath;
//    if (cellIndexPath.row == 0) {
//        self.titleLabel.textColor = [UIColor colorWithRed:3/255.0 green:179/255.0 blue:204/255.0 alpha:1];
//    }else {
//        self.titleLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
//    }
}

- (UIImage*)imageWithColor:(UIColor*)color {

    CGRect rect = CGRectMake(0.0f,0.0f,1.0f,1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;

}

-(void)setIsSelect:(BOOL)isSelect {
    _isSelect = isSelect;
    if (isSelect) {
        self.titleLabel.textColor = [UIColor colorWithRed:3/255.0 green:179/255.0 blue:204/255.0 alpha:1];
        self.checkView.hidden = NO;
    }else {
        self.titleLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
        self.checkView.hidden = YES;
    }
}

-(void)setTitleStr:(NSString *)titleStr {
    _titleStr = titleStr;
    self.titleLabel.text = titleStr;
}

@end
