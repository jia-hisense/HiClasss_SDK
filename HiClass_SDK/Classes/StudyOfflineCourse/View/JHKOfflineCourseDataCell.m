//
//  JHKOfflineCourseDataCell.m
//  JHKOffLineViewDemo
//
//  Created by wangggang on 2020/4/21.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "JHKOfflineCourseDataCell.h"

@implementation JHKOfflineCourseDataCell
+(instancetype)getDataCell{
    return [[[NSBundle mainBundle]loadNibNamed:@"JHKOfflineCourseView" owner:self options:nil]objectAtIndex:1];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setModel:(HICOfflineCourseModel *)model{
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
