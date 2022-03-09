//
//  HICLectureCalendarCourseCell.m
//  HiClass
//
//  Created by hisense on 2020/5/15.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import "HICLectureCalendarCourseCell.h"
#import "NSString+String.h"


@interface HICLectureCalendarCourseCell()

@property (nonatomic, weak) UILabel *titleLbl;
@property (nonatomic, weak) UILabel *classDurationLbl;
@property (nonatomic, weak) UILabel *timeLbl;
@property (nonatomic, weak) UILabel *locationLbl;

@property (nonatomic, weak) UIView *separatorLineView;
@end



@implementation HICLectureCalendarCourseCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {

    static NSString *reusableIdentifier = @"HICLectureCalendarCourseCell";

    HICLectureCalendarCourseCell *cell = [tableView dequeueReusableCellWithIdentifier:reusableIdentifier];

    if (cell == nil) {
        cell = [[HICLectureCalendarCourseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusableIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    self.backgroundColor = [UIColor clearColor];

    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:bgView];
    self.bgView = bgView;

    UILabel *titleLbl = [[UILabel alloc] init];
    titleLbl.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    titleLbl.textColor = [UIColor colorWithHexString:@"#333333"];
    [self.contentView addSubview:titleLbl];
    self.titleLbl = titleLbl;

    UILabel *classDurationLbl = [[UILabel alloc] init];
    classDurationLbl.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    classDurationLbl.textColor = [UIColor colorWithHexString:@"#373737"];
    [self.contentView addSubview:classDurationLbl];
    self.classDurationLbl = classDurationLbl;

    UILabel *timeLbl = [[UILabel alloc] init];
    timeLbl.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    timeLbl.textColor = [UIColor colorWithHexString:@"#373737"];
    [self.contentView addSubview:timeLbl];
    self.timeLbl = timeLbl;

    UILabel *locationLbl = [[UILabel alloc] init];
    locationLbl.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    locationLbl.textColor = [UIColor colorWithHexString:@"#373737"];
    [self.contentView addSubview:locationLbl];
    self.locationLbl = locationLbl;

    UIView *separatorLineView = [[UIView alloc] init];
    self.separatorLineView = separatorLineView;
    [self.contentView addSubview:separatorLineView];
    separatorLineView.backgroundColor = [UIColor colorWithHexString:@"#E6E6E6"];
    return self;

}

- (void)setCourseFrame:(HICLectureCalendarCourseFrame *)courseFrame {
    _courseFrame = courseFrame;

    _titleLbl.text = courseFrame.course.resClassName;
    _classDurationLbl.text = [NSString stringWithFormat:@"%@：%@", NSLocalizableString(@"classHour", nil),courseFrame.course.courseHourStr];
    _timeLbl.text = [NSString stringWithFormat:@"%@：%@", NSLocalizableString(@"time", nil),[NSString getFullDateWithStartTime:courseFrame.course.classStartTime.integerValue endTime:courseFrame.course.classEndTime.integerValue]];
    _locationLbl.text = [NSString stringWithFormat:@"%@：%@", NSLocalizableString(@"place", nil),courseFrame.course.classPlace];

    _bgView.frame = courseFrame.bgViewF;
    _titleLbl.frame = courseFrame.titleLblF;
    _classDurationLbl.frame = courseFrame.classDurationLblF;
    _timeLbl.frame = courseFrame.timeLblF;
    _locationLbl.frame = courseFrame.locationLblF;

    _separatorLineView.frame = courseFrame.separatorLineViewF;
    _separatorLineView.hidden = courseFrame.isSeparatorHidden;


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
