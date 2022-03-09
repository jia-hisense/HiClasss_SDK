//
//  HTCExaminationCell.m
//  iTest
//
//  Created by Sir_Jing on 2020/3/16.
//  Copyright © 2020 Sir_Jing. All rights reserved.
//

#import "HTCExaminationCell.h"
#import "HICHomeTaskCenterModel.h"

@implementation HTCExaminationCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.iconImageLabel.text = @"考";
        self.iconImageLabel.backgroundColor = [UIColor colorWithRed:0 green:190/255.0 blue:215/255.0 alpha:1];
        self.progressView.hidden = YES;
    }
    return self;
}

-(void)setModel:(HICHomeTaskCenterModel *)model {
    if (self.model == model) {
        return;
    }
    [super setModel:model];

    self.contentTitleLabel.text = model.isImportant == 1?[NSString stringWithFormat:@"       %@", model.taskName]:model.taskName;
    self.timeLabel.text = [NSString stringWithFormat:@"%@: %@", NSLocalizableString(@"startTextTime", nil),[HICCommonUtils returnReadableTimeZoneWithStartTime:@(model.startTime) andEndTime:@(model.endTime)]];
    self.leftTopLabel.text = model.examDuration == 0 ? [NSString stringWithFormat:@"%@: %@",NSLocalizableString(@"testTime", nil),NSLocalizableString(@"unlimited", nil)] : [NSString stringWithFormat:@"%@: %ld%@",NSLocalizableString(@"testTime", nil), (long)model.examDuration,NSLocalizableString(@"minutes", nil)];
    self.leftBottomLabel.text = model.examAllowNum == 0 ? [NSString stringWithFormat:@"%@: %@",NSLocalizableString(@"numberOfTestsAvailable", nil),NSLocalizableString(@"unlimited", nil)] :  [NSString stringWithFormat:@"%@: %ld/%ld", NSLocalizableString(@"numberOfTestsAvailable", nil),(long)model.examAvaiNum, (long)model.examAllowNum];
    self.rightTopLabel.text = [NSString stringWithFormat:@"%@: %@/%@%@",NSLocalizableString(@"passPoints", nil), [HICCommonUtils formatFloat:model.examPassScore], [HICCommonUtils formatFloat:model.examTotalScore],NSLocalizableString(@"points", nil)];
    self.rightBottomLabel.text = [NSString stringWithFormat:@"%@: %@", NSLocalizableString(@"designatedPerson", nil),[NSString isValidStr:model.assigner] ? model.assigner : @"-"];
    if (model.isImportant == 1) {
        [self.contentTitleLabel addSubview:self.majorImageView];
    }else {
        [self.majorImageView removeFromSuperview];
    }

}

@end
