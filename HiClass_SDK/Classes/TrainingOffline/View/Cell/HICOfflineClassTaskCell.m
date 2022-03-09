//
//  HICOfflineClassTaskCell.m
//  HiClass
//
//  Created by hisense on 2020/4/24.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import "HICOfflineClassTaskCell.h"


@interface HICOfflineClassTaskCell()

@property (nonatomic, weak) UILabel *typeLbl;
@property (nonatomic, weak) UILabel *titleLbl;
@property (nonatomic, weak) UIButton *operateBtn;

@property (nonatomic, weak) UILabel *timeLbl;
@property (nonatomic, weak) UILabel *locationLbl;
@property (nonatomic, weak) UIButton *bottomMapBtn;
@property (nonatomic, weak) UIButton *bottomTimeBtn;


@property (nonatomic, weak) UIView *separatorLineView;


@end



@implementation HICOfflineClassTaskCell


+(instancetype)cellWithTableView:(UITableView *)tableView {

    static NSString *reusableIdentifier = @"HICOfflineClassTaskCell";

    HICOfflineClassTaskCell *cell = [tableView dequeueReusableCellWithIdentifier:reusableIdentifier];

    if (cell == nil) {
        cell = [[HICOfflineClassTaskCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusableIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];


    UILabel *typeLbl = [[UILabel alloc] init];
    [self.contentView addSubview:typeLbl];
    self.typeLbl = typeLbl;


    UILabel *titleLbl = [[UILabel alloc] init];
    [self.contentView addSubview:titleLbl];
    self.titleLbl = titleLbl;

    UIButton *operateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:operateBtn];
    self.operateBtn = operateBtn;
    [operateBtn addTarget:self action:@selector(clickTask:) forControlEvents:UIControlEventTouchUpInside];
    if (@available(iOS 11.0, *)) {
        [operateBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentTrailing];
    } else {
        [operateBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    }

    UILabel *timeLbl = [[UILabel alloc] init];
    [self.contentView addSubview:timeLbl];
    self.timeLbl = timeLbl;

    UILabel *locationLbl = [[UILabel alloc] init];
    [self.contentView addSubview:locationLbl];
    self.locationLbl = locationLbl;


    UIButton *bottomMapBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:bottomMapBtn];
    self.bottomMapBtn = bottomMapBtn;
    [bottomMapBtn addTarget:self action:@selector(clickMap:) forControlEvents:UIControlEventTouchUpInside];
    [bottomMapBtn setContentVerticalAlignment:UIControlContentVerticalAlignmentBottom];

    UIButton *bottomTimeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:bottomTimeBtn];
    self.bottomTimeBtn = bottomTimeBtn;
    [bottomTimeBtn addTarget:self action:@selector(clickRefresh:) forControlEvents:UIControlEventTouchUpInside];
    if (@available(iOS 11.0, *)) {
        [bottomTimeBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentTrailing];
    } else {
        [bottomTimeBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    }

    UIView *separatorLineView = [[UIView alloc] init];
    self.separatorLineView = separatorLineView;
    [self.contentView addSubview:separatorLineView];
    separatorLineView.backgroundColor = [UIColor colorWithHexString:@"#E6E6E6"];

    return self;
}

- (void)setTaskFrame:(HICOfflineClassTaskFrame *)taskFrame {
    _taskFrame = taskFrame;

    _titleLbl.alpha = taskFrame.alpha;
    _operateBtn.alpha = taskFrame.alpha;
    _timeLbl.alpha = taskFrame.alpha;
    _locationLbl.alpha = taskFrame.alpha;
    _bottomMapBtn.alpha = taskFrame.alpha;
    _bottomTimeBtn.alpha = taskFrame.alpha;

    _typeLbl.text = taskFrame.typeLblAtt.value;
    _typeLbl.textColor = taskFrame.typeLblAtt.textColor;
    _typeLbl.font = taskFrame.typeLblAtt.textFont;

    _titleLbl.text = taskFrame.titleLblAtt.value;
    _titleLbl.textColor = taskFrame.titleLblAtt.textColor;
    _titleLbl.font = taskFrame.titleLblAtt.textFont;

    [_operateBtn setTitle:taskFrame.operateBtnAtt.value forState:UIControlStateNormal];
    [_operateBtn setTitleColor:taskFrame.operateBtnAtt.textColor forState:UIControlStateNormal];
    [_operateBtn.titleLabel setFont:taskFrame.operateBtnAtt.textFont];
    [_operateBtn setUserInteractionEnabled:taskFrame.operateBtnAtt.isBtnEnable];

    _timeLbl.text = taskFrame.timeLblAtt.value;
    _timeLbl.textColor = taskFrame.timeLblAtt.textColor;
    _timeLbl.font = taskFrame.timeLblAtt.textFont;


    if (taskFrame.locationLblAtt) {
        _locationLbl.hidden = NO;

        _locationLbl.text = taskFrame.locationLblAtt.value;
        _locationLbl.textColor = taskFrame.locationLblAtt.textColor;
        _locationLbl.font = taskFrame.locationLblAtt.textFont;

    } else {
        _locationLbl.hidden = YES;
    }

    if (taskFrame.bottomMapBtnAtt) {
        _bottomMapBtn.hidden = NO;

        [_bottomMapBtn setTitle:taskFrame.bottomMapBtnAtt.value forState:UIControlStateNormal];
        [_bottomMapBtn setTitleColor:taskFrame.bottomMapBtnAtt.textColor forState:UIControlStateNormal];
        [_bottomMapBtn.titleLabel setFont:taskFrame.bottomMapBtnAtt.textFont];
        [_bottomMapBtn setUserInteractionEnabled:taskFrame.bottomMapBtnAtt.isBtnEnable];

    } else {
        _bottomMapBtn.hidden = YES;
    }

    if (taskFrame.bottomTimeBtnAtt) {
        _bottomTimeBtn.hidden = NO;

        [_bottomTimeBtn setTitle:taskFrame.bottomTimeBtnAtt.value forState:UIControlStateNormal];
        [_bottomTimeBtn setTitleColor:taskFrame.bottomTimeBtnAtt.textColor forState:UIControlStateNormal];
        [_bottomTimeBtn.titleLabel setFont:taskFrame.bottomTimeBtnAtt.textFont];
        [_bottomTimeBtn setUserInteractionEnabled:taskFrame.bottomTimeBtnAtt.isBtnEnable];
    } else {
        _bottomTimeBtn.hidden = YES;
    }

    _separatorLineView.hidden = taskFrame.isSeparatorHidden;

}

- (void)clickTask:(UIButton *)button {
    // 传出去subtask
    if (self.clickedTaskBlock) {
        self.clickedTaskBlock(self);
    }
}

- (void)clickMap:(UIButton *)button {
    // 传出去subtask
    if (self.clickedMapBlock) {
        self.clickedMapBlock(self);
    }
}

- (void)clickRefresh:(UIButton *)button {
    // 传出去subtask
    if (self.clickedRefreshBlock) {
        self.clickedRefreshBlock(self);
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];

    _typeLbl.frame = _taskFrame.typeLblF;
    _titleLbl.frame = _taskFrame.titleLblF;
    _operateBtn.frame = _taskFrame.operateBtnF;
    _timeLbl.frame = _taskFrame.timeLblF;
    _locationLbl.frame = _taskFrame.locationLblF;
    _bottomMapBtn.frame = _taskFrame.bottomMapBtnF;
    _bottomTimeBtn.frame = _taskFrame.bottomTimeBtnF;

    _separatorLineView.frame = _taskFrame.separatorLineViewF;

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
