//
//  HICScoreDetailTableViewCell.m
//  HiClass
//
//  Created by 聚好看 on 2021/11/11.
//  Copyright © 2021 hisense. All rights reserved.
//

#import "HICScoreDetailTableViewCell.h"
@interface HICScoreDetailTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *lbTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbTime;
@property (weak, nonatomic) IBOutlet UILabel *lbIntegral;

@end
@implementation HICScoreDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
// 针对Cell赋值

- (void)setCellModel:(IntegralSubsidiaryListModel *)cellModel{
    if (_cellModel == cellModel) {
        return;
    }
    _cellModel = cellModel;
 
    self.lbTitle.text = cellModel.taskCategory;
    self.lbTime.text = [HICCommonUtils timeStampToReadableDate:cellModel.operateTime isSecs:YES format:@"yyyy-MM-dd HH:mm"];
    if ([cellModel.points containsString:@"-"]) {
        self.lbIntegral.text = cellModel.points;
        self.lbIntegral.textColor = [UIColor colorWithHexString:@"#FF4B4B"];
    }else{
        self.lbIntegral.text = [NSString stringWithFormat:@"+%@",cellModel.points];
    }

    
}

@end
