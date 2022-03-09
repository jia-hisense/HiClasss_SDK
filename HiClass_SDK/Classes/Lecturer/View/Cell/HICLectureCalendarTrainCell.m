//
//  HICLectureCalendarTrainCell.m
//  HiClass
//
//  Created by hisense on 2020/5/15.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import "HICLectureCalendarTrainCell.h"
#import "UIView+Gradient.h"

@interface HICLectureCalendarTrainCell()

@property (nonatomic, weak) UILabel *titleLbl;

@property (nonatomic, weak) UIView *separatorLineView;

@property (nonatomic, weak) CAShapeLayer *maskLayer;

@end

@implementation HICLectureCalendarTrainCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {

    static NSString *reusableIdentifier = @"HICLectureCalendarTrainCell";

    HICLectureCalendarTrainCell *cell = [tableView dequeueReusableCellWithIdentifier:reusableIdentifier];

    if (cell == nil) {
        cell = [[HICLectureCalendarTrainCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusableIdentifier];
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
    titleLbl.numberOfLines = 0;
    [self.contentView addSubview:titleLbl];
    self.titleLbl = titleLbl;

    UIView *separatorLineView = [[UIView alloc] init];
    self.separatorLineView = separatorLineView;
    [self.contentView addSubview:separatorLineView];
    separatorLineView.backgroundColor = [UIColor colorWithHexString:@"#E6E6E6"];
    
    return self;

}

- (void)setTrainFrame:(HICLectureCalendarTrainFrame *)trainFrame {
    _trainFrame = trainFrame;

    _titleLbl.attributedText = trainFrame.titleAtt;
    _titleLbl.frame = trainFrame.titleLblF;

    _bgView.frame = trainFrame.bgViewlF;

    _separatorLineView.frame = trainFrame.separatorLineViewF;
    _separatorLineView.hidden = trainFrame.isSeparatorHidden;


    [_bgView removeCorner];
    [_bgView addCornerWithRadius:4 cornerType:CornerTop];

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
