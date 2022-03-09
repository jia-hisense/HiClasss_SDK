//
//  HICOfflineAllScoreCell.m
//  HiClass
//
//  Created by hisense on 2020/4/24.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import "HICOfflineAllScoreCell.h"

#define HICOfflineScoreCellLblHeight 40

@implementation HICOfflineAllScoreCellData
+ (instancetype)initWithTitle:(NSString *)title textFont:(UIFont *)textFont textColor:(UIColor *)textColor lblBgColor:(UIColor *)lblBgColor cellHeight:(CGFloat)cellHeight {
    HICOfflineAllScoreCellData *data = [[HICOfflineAllScoreCellData alloc] init];
    data.title = title;
    data.textFont = textFont;
    data.textColor = textColor;
    data.lblBgColor = lblBgColor;
    data.cellHeight = cellHeight;
    return data;
}
@end



@interface HICOfflineAllScoreCell()
@property (nonatomic, weak) UILabel *lbl;
@property (nonatomic, weak) UIView *lblBgView;

@end


@implementation HICOfflineAllScoreCell




+ (instancetype)cellWithTableView:(UITableView *)tableView {

    static NSString *reusableIdentifier = @"HICOfflineAllScoreCell";

    HICOfflineAllScoreCell *cell = [tableView dequeueReusableCellWithIdentifier:reusableIdentifier];

    if (cell == nil) {
        cell = [[HICOfflineAllScoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusableIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    UIView *lblBgView = [[UIView alloc] init];
    [self.contentView addSubview:lblBgView];
    self.lblBgView = lblBgView;

    UILabel *lbl = [[UILabel alloc] init];
    lbl.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:lbl];
    self.lbl = lbl;

    return self;
}


- (void)setData:(HICOfflineAllScoreCellData *)data {
    _data = data;

    _lbl.font = data.textFont;
    _lbl.textColor = data.textColor;
    _lbl.text = data.title;
    _lblBgView.backgroundColor = data.lblBgColor;


}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.lblBgView.frame = CGRectMake(12, 2, self.width-24, HICOfflineScoreCellLblHeight);

    self.lbl.frame = CGRectMake(16, 2, self.width-32, HICOfflineScoreCellLblHeight);

    self.lbl.center = self.lblBgView.center;
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
