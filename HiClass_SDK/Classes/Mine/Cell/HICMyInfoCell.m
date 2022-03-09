//
//  HICMyInfoCell.m
//  HiClass
//
//  Created by WorkOffice on 2020/3/16.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICMyInfoCell.h"
@interface HICMyInfoCell()
@property (nonatomic, strong)NSString *title;
@property (nonatomic ,strong)NSString *iconStr;
@property (nonatomic ,assign)BOOL isLast;
@end
@implementation HICMyInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andTitle:(NSString *)title andIcon:(NSString*)iconStr andLast:(BOOL)last {
     if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
         self.title = title;
         self.iconStr = iconStr;
         self.isLast = last;
         [self createUI];
         
        [self updateConstraintsIfNeeded];
       }
    return self;
}
- (void)createUI {
    self.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(16, 16, 24, 24)];
    icon.image = [UIImage imageNamed:self.iconStr];
    [self.contentView addSubview:icon];
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(58, 14, 200, 22.5)];
    title.font = FONT_REGULAR_16;
    title.text = self.title;
    title.textColor = TEXT_COLOR_DARK;
    [self.contentView addSubview:title];
    if (!self.isLast) {
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(58, 50, HIC_ScreenWidth - 58, 0.5)];
        line.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6"];
        [self.contentView addSubview:line];
    }
}

@end
