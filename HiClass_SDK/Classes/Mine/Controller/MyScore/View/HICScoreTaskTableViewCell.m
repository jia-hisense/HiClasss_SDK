//
//  HICScoreTaskTableViewCell.m
//  HiClass
//
//  Created by 聚好看 on 2021/11/11.
//  Copyright © 2021 hisense. All rights reserved.
//

#import "HICScoreTaskTableViewCell.h"

@interface HICScoreTaskTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *lbTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbContent;
@property (weak, nonatomic) IBOutlet UIImageView *imgComplete;

@end


@implementation HICScoreTaskTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

// 针对Cell赋值
-(void)setCellModel:(IntegralTaskListModel *)cellModel {
    if (_cellModel == cellModel) {
        return;
    }
    _cellModel = cellModel;
    if ([cellModel.maxNum isEqualToString:@"0"]) {
        self.lbTitle.text = cellModel.taskCategory;
    }else{
        self.lbTitle.text = [NSString stringWithFormat:@"%@（%@/%@）",cellModel.taskCategory,cellModel.completeNum,cellModel.maxNum];
    }
    self.lbContent.text = cellModel.taskDesc;
    if ([cellModel.isCompleted isEqualToString:@"1"]) {
        self.imgComplete.hidden = NO;
        self.lbTitle.alpha = 0.4;
        self.lbContent.alpha = 0.4;
    }
   
    
}

@end
