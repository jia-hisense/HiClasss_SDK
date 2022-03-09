//
//  JHKOfflineCourseScoreCell.m
//  JHKOffLineViewDemo
//
//  Created by wangggang on 2020/4/20.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "JHKOfflineCourseScoreCell.h"

@implementation JHKOfflineCourseScoreCell
+(instancetype)getScoreCell{
    return [[[NSBundle mainBundle]loadNibNamed:@"JHKOfflineCourseView" owner:self options:nil] firstObject];
}

-(void)setCellWithTitle:(NSString *)title score:(NSNumber *)score andMoreFlag:(BOOL)moreFlag{
    if (moreFlag) {
        [self.moreBtn setHidden:NO];
        [self.titleLabel setHidden:YES];
        [self.scoreLabel setHidden:YES];
        [self.moreBtn setTitle:title forState:UIControlStateNormal];
    }else{
        [self.moreBtn setHidden:YES];
        [self.titleLabel setHidden:NO];
        [self.scoreLabel setHidden:NO];
        self.titleLabel.text = title;
        self.scoreLabel.text = [NSString stringWithFormat:@"%@%@",score,NSLocalizableString(@"points", nil)];
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
