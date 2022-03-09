//
//  HICLectureCourseCell.m
//  HiClass
//
//  Created by hisense on 2020/5/14.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import "HICLectureCourseCell.h"

@interface  HICLectureCourseCell()

@property (nonatomic, weak) UILabel *titleLbl;
@property (nonatomic, weak) UIImageView *typeImgView;
@property (nonatomic, weak) UILabel *joinNumLbl;

@property (nonatomic, weak) UIView *separatorLineView;
@end


@implementation HICLectureCourseCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {

    static NSString *reusableIdentifier = @"HICLectureCourseCell";

    HICLectureCourseCell *cell = [tableView dequeueReusableCellWithIdentifier:reusableIdentifier];

    if (cell == nil) {
        cell = [[HICLectureCourseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusableIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    UILabel *titleLbl = [[UILabel alloc] init];
    titleLbl.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
    titleLbl.textColor = [UIColor colorWithHexString:@"#333333"];
    titleLbl.numberOfLines = 0;
    [self.contentView addSubview:titleLbl];
    self.titleLbl = titleLbl;

    UIImageView *typeImgView = [[UIImageView alloc] init];
    [typeImgView setImage:[UIImage imageNamed:@"标签_认证课程"]];
    typeImgView.contentMode = UIViewContentModeScaleToFill;
    [self.contentView addSubview:typeImgView];
    self.typeImgView = typeImgView;


    UILabel *joinNumLbl = [[UILabel alloc] init];
    joinNumLbl.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    joinNumLbl.textColor = [UIColor colorWithHexString:@"#858585"];
    [self.contentView addSubview:joinNumLbl];
    self.joinNumLbl = joinNumLbl;

    UIView *separatorLineView = [[UIView alloc] init];
    self.separatorLineView = separatorLineView;
    [self.contentView addSubview:separatorLineView];
    separatorLineView.backgroundColor = [UIColor colorWithHexString:@"#E6E6E6"];
    return self;

}

- (void)setCourseFrame:(HICLectureCourseFrame *)courseFrame {
    _courseFrame = courseFrame;

    _titleLbl.text = courseFrame.course.resClassName;
    _titleLbl.frame = courseFrame.titleLblF;

    _typeImgView.frame = courseFrame.typeImgViewF;

    if (courseFrame.course.isAuth) {
        _joinNumLbl.text = [NSString stringWithFormat:@"  %ld%@", (long)courseFrame.course.joinNum,NSLocalizableString(@"peopleInvolved", nil)];
    } else {
        _joinNumLbl.text = [NSString stringWithFormat:@"%ld%@", (long)courseFrame.course.joinNum,NSLocalizableString(@"peopleInvolved", nil)];
    }
    _joinNumLbl.frame = courseFrame.joinNumLblF;

    _separatorLineView.frame = courseFrame.separatorLineViewF;
    _separatorLineView.hidden = courseFrame.isSeparatorHidden;


}

@end
