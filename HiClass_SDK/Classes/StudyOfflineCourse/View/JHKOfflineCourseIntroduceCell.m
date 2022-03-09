//
//  JHKOfflineCourseIntroduceCell.m
//  JHKOffLineViewDemo
//
//  Created by wangggang on 2020/4/21.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "JHKOfflineCourseIntroduceCell.h"

@implementation JHKOfflineCourseIntroduceCell
+(instancetype)getIntroduceCell{
    return [[[NSBundle mainBundle]loadNibNamed:@"JHKOfflineCourseView" owner:self options:nil]objectAtIndex:4];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    __weak typeof(self) weakSelf = self;
    self.introduceLabel.block = ^(CGFloat height) {
        if (weakSelf.introduceCellHeightBlock) {
            weakSelf.introduceLabelH.constant = height;
            weakSelf.introduceCellHeightBlock(height + 112);
        }
    };
}
-(void)setCellWithHeaderImage:(NSString *)headerImage andName:(NSString *)name andInfo:(NSString *)info andIntroduce:(NSString *)introduce{
    self.headImageV.image = [UIImage imageNamed:headerImage];
    self.nameLabel.text = name;
    self.infoLabel.text = info;
    [self.introduceLabel setExpandAtt:introduce YYLabelW:HIC_ScreenWidth-84 MaxLineNum:2 font:[UIFont systemFontOfSize:14] color:HexRGB(0x666666) LineSpace:0];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
