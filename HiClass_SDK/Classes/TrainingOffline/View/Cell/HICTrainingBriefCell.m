//
//  HICTrainingBriefCell.m
//  HiClass
//
//  Created by hisense on 2020/4/16.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import "HICTrainingBriefCell.h"
#import "NSString+String.h"

@interface HICTrainingBriefCell()

@property (nonatomic, weak) UILabel *titleLbl;
@property (nonatomic, weak) UILabel *timeLbl;
@property (nonatomic, weak) UILabel *briefLbl;

@property (nonatomic, weak) UIButton *openBtn;
@property (nonatomic, weak) UIButton *shrinkBtn;

@property (nonatomic, weak) UIView *separatorLineView;

@end


@implementation HICTrainingBriefCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {

    static NSString *reusableIdentifier = @"HICTrainingBriefCell";

    HICTrainingBriefCell *cell = [tableView dequeueReusableCellWithIdentifier:reusableIdentifier];

    if (cell == nil) {
        cell = [[HICTrainingBriefCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusableIdentifier];
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


    UILabel *timeLbl = [[UILabel alloc] init];
    timeLbl.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    timeLbl.textColor = [UIColor colorWithHexString:@"#666666"];
    [self.contentView addSubview:timeLbl];
    self.timeLbl = timeLbl;

    UILabel *briefLbl = [[UILabel alloc] init];
    briefLbl.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    briefLbl.textColor = [UIColor colorWithHexString:@"#666666"];
    [self.contentView addSubview:briefLbl];
    self.briefLbl = briefLbl;
    briefLbl.numberOfLines = 0;

    UIButton *openBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [openBtn.titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:14]];
    [openBtn setTitle:NSLocalizableString(@"develop", nil) forState:UIControlStateNormal];
    [openBtn setTitleColor:[UIColor colorWithHexString:@"#00BED7"] forState:UIControlStateNormal];
    openBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:openBtn];
    self.openBtn = openBtn;
    openBtn.tag = 101;
    [openBtn addTarget:self action:@selector(openOrShrinkBriefAction:) forControlEvents:UIControlEventTouchUpInside];
    if (@available(iOS 11.0, *)) {
        [openBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeading];
    } else {
        [openBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    }

    UIButton *shrinkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shrinkBtn.titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:14]];
    [shrinkBtn setTitle:NSLocalizableString(@"packUp", nil) forState:UIControlStateNormal];
    [shrinkBtn setTitleColor:[UIColor colorWithHexString:@"#00BED7"] forState:UIControlStateNormal];
    openBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:shrinkBtn];
    self.shrinkBtn = shrinkBtn;
    shrinkBtn.tag = 102;
    [shrinkBtn addTarget:self action:@selector(openOrShrinkBriefAction:) forControlEvents:UIControlEventTouchUpInside];
    if (@available(iOS 11.0, *)) {
        [shrinkBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeading];
    } else {
        [shrinkBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    }

    UIView *separatorLineView = [[UIView alloc] init];
    self.separatorLineView = separatorLineView;
    [self.contentView addSubview:separatorLineView];
    separatorLineView.backgroundColor = [UIColor colorWithHexString:@"#E6E6E6"];


    return self;
}


- (void)openOrShrinkBriefAction:(UIButton *)btn {

    // update brief frame对象的info和open属性，然后把事件传递到外部VC，VC更新frame 和 cell

    if (self.openOrShrinkBlock) {
        self.openOrShrinkBlock(self);
    }


}

- (void)setBriefFrame:(HICTrainingBriefFrame *)briefFrame {
    _briefFrame = briefFrame;

    _titleLbl.text = briefFrame.data.title;
    _timeLbl.text = briefFrame.data.time;
    _briefLbl.text = briefFrame.data.brief;

    // UI Frame更新放到layoutSubviews再做

}

- (void)layoutSubviews {
    [super layoutSubviews];

    _titleLbl.frame = _briefFrame.titleLblF;
    _timeLbl.frame = _briefFrame.timeLblF;
    _briefLbl.frame = _briefFrame.briefLblF;
    _openBtn.frame = _briefFrame.openBtnF;
    _shrinkBtn.frame = _briefFrame.shrinkBtnF;
    _separatorLineView.frame = _briefFrame.separatorLineViewF;

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
