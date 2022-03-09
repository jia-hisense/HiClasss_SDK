//
//  JHKOfflineCourseScoreSectionView.m
//  JHKOffLineViewDemo
//
//  Created by wangggang on 2020/4/20.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "JHKOfflineCourseScoreSectionView.h"

@implementation JHKOfflineCourseScoreSectionView
+(instancetype)getScoreSectionView{
    return [[[NSBundle mainBundle]loadNibNamed:@"JHKOfflineCourseView" owner:self options:nil] objectAtIndex:3];
}
-(void)setModel:(HICOfflineCourseModel *)model{
    _model = model;
    _resultScoreLabel.text = [NSString stringWithFormat:@"%f%@",model.score,NSLocalizableString(@"points", nil)];
    _scoreLabel.text = [NSString stringWithFormat:@"%f%@",model.score,NSLocalizableString(@"points", nil)];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
