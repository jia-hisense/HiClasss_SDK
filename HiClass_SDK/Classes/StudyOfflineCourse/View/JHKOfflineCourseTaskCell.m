//
//  JHKOfflineCourseTaskCell.m
//  JHKOffLineViewDemo
//
//  Created by wangggang on 2020/4/21.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "JHKOfflineCourseTaskCell.h"

@implementation JHKOfflineCourseTaskCell
+(instancetype)getTaskCell{
    return [[[NSBundle mainBundle]loadNibNamed:@"JHKOfflineCourseView" owner:self options:nil]objectAtIndex:6];
}
-(void)setCellWithState:(NSString *)state andTitle:(NSString *)title andStateType:(NSInteger)stateType andDateTitle:(NSString *)dateTitle andDate:(NSString *)date andPlaceTitle:(NSString *)placeTitle andPlace:(NSString *)place{
    self.statusLabel.text = state;
    self.titleLabel.text = title;
    NSString * infoStr = [NSString stringWithFormat:@"%@:%@",dateTitle,date];
    if (placeTitle && placeTitle.length >0) {
        infoStr = [infoStr stringByAppendingFormat:@"\n%@:%@",placeTitle,place];
    }
    self.infoLabel.text = infoStr;
    CGSize infoSize = [infoStr boundingRectWithSize:CGSizeMake(HIC_ScreenWidth-32, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:self.infoLabel.font} context:nil].size;
    self.infoLabelH.constant = infoSize.height + 10 * HIC_Divisor;
    [self setSignBtnWithType:stateType];
}
-(void)setSignBtnWithType:(NSInteger)type{
    switch (type) {
        case 1://签到
            [self.signBtn setTitle:NSLocalizableString(@"signInImmediately", nil) forState:UIControlStateNormal];
            [self.signBtn setTitleColor:HexRGB(0x00BED7) forState:UIControlStateNormal];
            break;
        case 2://未开始
            [self.signBtn setTitle:NSLocalizableString(@"notStarted", nil) forState:UIControlStateNormal];
            [self.signBtn setTitleColor:HexRGB(0xB9B9B9) forState:UIControlStateNormal];
            break;
        default:
            break;
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
