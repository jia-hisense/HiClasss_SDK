//
//  JHKOfflineCourseTopView.m
//  JHKOffLineViewDemo
//
//  Created by wangggang on 2020/4/20.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "JHKOfflineCourseTopView.h"

@implementation JHKOfflineCourseTopView
+(instancetype)getTopView{
    return [[[NSBundle mainBundle]loadNibNamed:@"JHKOfflineCourseView" owner:self options:nil]objectAtIndex:2];
}
-(void)awakeFromNib{
    [super awakeFromNib];
    self.navTop.constant = FBStatusBarH;
}
-(void)setModel:(HICOfflineCourseModel *)model{
    _model = model;
    _titleLabel.text = model.name;
    _locationLabel.text = [NSString stringWithFormat:@"%@: %@",NSLocalizableString(@"venue", nil),_model.location];
    if (model.scoreGroup == HICTrainGradeQualified) {
        _stateImageV.image = [UIImage imageNamed:@""];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
