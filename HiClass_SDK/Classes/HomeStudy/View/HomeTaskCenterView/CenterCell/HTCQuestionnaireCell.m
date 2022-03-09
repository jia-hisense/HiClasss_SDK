//
//  HTCQuestionnaireCell.m
//  iTest
//
//  Created by Sir_Jing on 2020/3/16.
//  Copyright © 2020 Sir_Jing. All rights reserved.
//

#import "HTCQuestionnaireCell.h"

@implementation HTCQuestionnaireCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.iconImageLabel.text = @"卷";
        self.iconImageLabel.backgroundColor = [UIColor colorWithRed:245/255.0 green:153/255.0 blue:0.0 alpha:1];
        self.progressView.hidden = YES;
        self.leftTopLabel.hidden = YES;
        self.leftBottomLabel.hidden = YES;
        self.rightTopLabel.hidden = YES;
        self.rightBottomLabel.hidden = YES;
        self.lineView.hidden = YES;
    }
    return self;
}

-(void)setModel:(HICHomeTaskCenterModel *)model {
    if (self.model == model) {
        return;
    }
    [super setModel:model];
    
    self.contentTitleLabel.text = model.isImportant == 1?[NSString stringWithFormat:@"       %@", model.taskName]:model.taskName;
    self.timeLabel.text = [NSString stringWithFormat:@"%@: %@", NSLocalizableString(@"theQuestionnaireOfTime", nil),[HICCommonUtils returnReadableTimeZoneWithStartTime:@(model.startTime) andEndTime:@(model.endTime)]];
    self.timeLabel.textColor = UIColor.redColor;
    if (model.isImportant == 1) {
        [self.contentTitleLabel addSubview:self.majorImageView];
    } else {
        [self.majorImageView removeFromSuperview];
    }
    if (model.points > 0) {
        self.leftTopLabel.hidden = NO;
        self.leftTopLabel.text = HICLocalizedFormatString(@"questionRewardPoints", model.points.integerValue);
        [self.leftTopLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.timeLabel.mas_bottom).offset(5);
        }];
    } else {
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentBackView).inset(16);
        }];
    }
}

@end
