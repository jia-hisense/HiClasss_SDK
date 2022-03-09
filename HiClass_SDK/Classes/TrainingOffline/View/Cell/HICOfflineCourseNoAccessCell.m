//
//  HICOfflineCourseNoAccessCell.m
//  HiClass
//
//  Created by WorkOffice on 2020/7/29.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import "HICOfflineCourseNoAccessCell.h"
@interface HICOfflineCourseNoAccessCell()

@end
@implementation HICOfflineCourseNoAccessCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
        [self updateConstraintsIfNeeded];
    }
    return self;
}
- (void)createUI{
   UILabel *label  = [[UILabel alloc]initWithFrame:CGRectMake(0, 60, HIC_ScreenWidth, 40)];
    label.textColor = TEXT_COLOR_LIGHTM;
    label.font = FONT_MEDIUM_15;
    label.text = NSLocalizableString(@"noPermissionRegisterTraining", nil);
    label.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:label];
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 149.5, HIC_ScreenWidth, 0.5)];
    line.backgroundColor = DEVIDE_LINE_COLOR;
    [self.contentView addSubview:line];
}

@end
