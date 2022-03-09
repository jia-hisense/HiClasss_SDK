//
//  HTCSignUpCell.m
//  iTest
//
//  Created by Sir_Jing on 2020/3/16.
//  Copyright © 2020 Sir_Jing. All rights reserved.
//

#import "HTCSignUpCell.h"

@implementation HTCSignUpCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.iconImageLabel.text = @"报";
        self.iconImageLabel.backgroundColor = [UIColor colorWithHexString:@"#14BE6E"];
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
    self.timeLabel.text = [NSString stringWithFormat:@"%@: %@", NSLocalizableString(@"timeSigningUp", nil),[HICCommonUtils returnReadableTimeZoneWithStartTime:@(model.startTime) andEndTime:@(model.endTime)]];
    self.leftTopLabel.text = [NSString stringWithFormat:@"%@: %ld",NSLocalizableString(@"submittedPeopleNumber", nil),(long)model.registerApplyNum];
    self.rightTopLabel.text = [NSString stringWithFormat:@"%@: %@",NSLocalizableString(@"enrollment", nil),model.enrollmentNumber > 0?[NSNumber numberWithInteger:model.enrollmentNumber]:NSLocalizableString(@"noQuota", nil)];
    self.leftTopLabel.hidden = NO;
    self.rightTopLabel.hidden = NO;
    self.lineView.hidden = NO;
    if (model.isImportant == 1) {
        [self.contentTitleLabel addSubview:self.majorImageView];
    }else {
        [self.majorImageView removeFromSuperview];
    }

}
@end
