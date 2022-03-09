//
//  HICTrainingOtherInfoCell.m
//  HiClass
//
//  Created by hisense on 2020/4/16.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import "HICTrainingOtherInfoCell.h"

@interface HICTrainingOtherInfoCell()
@property (nonatomic, weak) UILabel *titleLbl;
@property (nonatomic, weak) UILabel *contentLbl;

@property (nonatomic, weak) UIView *separatorLineView;


@end


@implementation HICTrainingOtherInfoCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {

    static NSString *reusableIdentifier = @"HICTrainingOtherInfoCell";

    HICTrainingOtherInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:reusableIdentifier];

    if (cell == nil) {
        cell = [[HICTrainingOtherInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusableIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    UILabel *titleLbl = [[UILabel alloc] init];
    titleLbl.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    titleLbl.textColor = [UIColor colorWithHexString:@"#333333"];
    [self.contentView addSubview:titleLbl];
    self.titleLbl = titleLbl;


    UILabel *contentLbl = [[UILabel alloc] init];
    contentLbl.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    contentLbl.textColor = [UIColor colorWithHexString:@"#666666"];
    [self.contentView addSubview:contentLbl];
    self.contentLbl = contentLbl;
    contentLbl.numberOfLines = 0;

    UIView *separatorLineView = [[UIView alloc] init];
    self.separatorLineView = separatorLineView;
    [self.contentView addSubview:separatorLineView];
    separatorLineView.backgroundColor = [UIColor colorWithHexString:@"#E6E6E6"];

    return self;
}

- (void)setInfoFrame:(HICTrainingOtherInfoFrame *)infoFrame {
    _infoFrame = infoFrame;

    _titleLbl.text = infoFrame.title;
    _contentLbl.text = infoFrame.conent;

    [self.separatorLineView setHidden:infoFrame.isSeparatorHidden];

}


- (void)layoutSubviews {
    [super layoutSubviews];

    _titleLbl.frame = _infoFrame.titleF;
    _contentLbl.frame = _infoFrame.contentF;

    _separatorLineView.frame = _infoFrame.separatorLineViewF;
    

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
