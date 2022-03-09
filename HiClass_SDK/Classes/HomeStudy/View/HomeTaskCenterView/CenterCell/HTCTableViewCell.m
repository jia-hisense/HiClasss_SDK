//
//  HTCTableViewCell.m
//  HiClass
//
//  Created by 聚好看 on 2021/11/8.
//  Copyright © 2021 hisense. All rights reserved.
//

#import "HTCTableViewCell.h"

@implementation HTCTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.iconImageLabel.text = @"标签小图标";
        self.iconImageLabel.backgroundColor = [UIColor colorWithHexString:@"#14BE6E"];
        self.progressView.hidden = YES;
        self.leftTopLabel.hidden = YES;
        self.leftBottomLabel.hidden = YES;
        self.iconImage.image = [UIImage imageNamed:@"直播小图标"];
        self.iconImageLabel.hidden = YES;
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
    self.timeLabel.text = [NSString stringWithFormat:@"%@: %@", NSLocalizableString(@"liveTime", nil),[HICCommonUtils returnReadableTimeZoneWithStartTime:@(model.startTime) andEndTime:@(model.endTime)]];
    NSString *strTeacher = @"";
    for (int i = 0; i < model.liveTeacherList.count; i++) {
        if ([strTeacher isEqualToString:@""]) {
            strTeacher = model.liveTeacherList[0][@"teacherName"];
        }else{
            strTeacher = [NSString stringWithFormat:@"%@,%@",strTeacher,model.liveTeacherList[0][@"teacherName"]];
        }
    }
    self.leftTopLabel.text = [NSString stringWithFormat:@"%@: %@",NSLocalizableString(@"liveInstructor", nil),strTeacher];
    self.leftTopLabel.hidden = NO;
    if (model.points.integerValue > 0) {
        self.leftBottomLabel.text =  HICLocalizedFormatString(@"watchLiveRewardPoints", model.points.integerValue);
        self.leftBottomLabel.hidden = NO;
    }
    
    self.lineView.hidden = NO;
    if (model.isImportant == 1) {
        [self.contentTitleLabel addSubview:self.majorImageView];
    }else {
        [self.majorImageView removeFromSuperview];
    }

}
@end
