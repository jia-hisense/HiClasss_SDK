//
//  HICOfflineLecturerCell.m
//  HiClass
//
//  Created by hisense on 2020/4/24.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import "HICOfflineLecturerCell.h"
#import <SDWebImage/SDWebImage.h>
#import "NSString+String.h"


@interface HICOfflineLecturerCell()

@property (nonatomic, weak) UILabel *titleLbl;
@property (nonatomic, weak) UIImageView *iconImgView;
@property (nonatomic, strong) UILabel *placeLbl;

@property (nonatomic, weak) UILabel *nameLbl;
@property (nonatomic, weak) UILabel *postLbl;
@property (nonatomic, weak) UILabel *briefLbl;
@property (nonatomic, weak) UIButton *openBtn;
@property (nonatomic, weak) UIButton *shrinkBtn;
@property (nonatomic, weak) UIView *separatorLineView;

@property (nonatomic, weak) UIButton *iconBtn;
@property (nonatomic, weak) UIButton *nameBtn;


@end

@implementation HICOfflineLecturerCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {

    static NSString *reusableIdentifier = @"HICOfflineLecturerCell";

    HICOfflineLecturerCell *cell = [tableView dequeueReusableCellWithIdentifier:reusableIdentifier];

    if (cell == nil) {
        cell = [[HICOfflineLecturerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusableIdentifier];
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

    UIImageView *iconImgView = [[UIImageView alloc] init];
    iconImgView.backgroundColor = [UIColor colorWithHexString:@"#161616"];
    [self.contentView addSubview:iconImgView];
    self.iconImgView = iconImgView;
    iconImgView.layer.cornerRadius = 4;
    iconImgView.clipsToBounds = YES;


    UILabel *nameLbl = [[UILabel alloc] init];
    nameLbl.font = [UIFont fontWithName:@"PingFangSC-Medium" size:17];
    nameLbl.textColor = [UIColor colorWithHexString:@"#333333"];
    [self.contentView  addSubview:nameLbl];
    self.nameLbl = nameLbl;

    UILabel *postLbl = [[UILabel alloc] init];
    postLbl.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    postLbl.textColor = [UIColor colorWithHexString:@"#666666"];
    [self.contentView  addSubview:postLbl];
    self.postLbl = postLbl;

    UILabel *briefLbl = [[UILabel alloc] init];
    briefLbl.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    briefLbl.textColor = [UIColor colorWithHexString:@"#666666"];
    [self.contentView  addSubview:briefLbl];
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
    [self.contentView  addSubview:shrinkBtn];
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
    [self.contentView  addSubview:separatorLineView];
    separatorLineView.backgroundColor = [UIColor colorWithHexString:@"#E6E6E6"];

    UIButton *iconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [iconBtn setBackgroundColor:[UIColor clearColor]];
    [self.contentView  addSubview:iconBtn];
    self.iconBtn = iconBtn;
    [iconBtn addTarget:self action:@selector(iconClickedAction:) forControlEvents:UIControlEventTouchUpInside];

    UIButton *nameBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [nameBtn setBackgroundColor:[UIColor clearColor]];
    [self.contentView  addSubview:nameBtn];
    self.nameBtn = nameBtn;
    [nameBtn addTarget:self action:@selector(iconClickedAction:) forControlEvents:UIControlEventTouchUpInside];


    return self;
}


- (void)openOrShrinkBriefAction:(UIButton *)btn {

    // update brief frame对象的info和open属性，然后把事件传递到外部VC，VC更新frame 和 cell

    if (self.openOrShrinkBlock) {
        self.openOrShrinkBlock(self);
    }

}
- (void)iconClickedAction:(UIButton *)btn {

    // update brief frame对象的info和open属性，然后把事件传递到外部VC，VC更新frame 和 cell

    if (self.iconClickedBlock) {
        self.iconClickedBlock(self);
    }

}



- (void)setLecturerFrame:(HICOfflineLecturerFrame *)lecturerFrame {
    _lecturerFrame = lecturerFrame;

    _titleLbl.text = lecturerFrame.data.title;

    [_placeLbl removeFromSuperview];
    if ([NSString isValidString:lecturerFrame.data.iconUrl]) {
        NSURL *imgUrl = [NSURL URLWithString:lecturerFrame.data.iconUrl];
        if (imgUrl) {
            [_iconImgView sd_setImageWithURL:imgUrl];
        }
    } else {
        if ([NSString isValidString:lecturerFrame.data.name]) {
            UILabel *placeLbl = [HICCommonUtils setHeaderFrame:CGRectMake(0, 0, lecturerFrame.iconImgViewF.size.width, lecturerFrame.iconImgViewF.size.height) andText:lecturerFrame.data.name];
            placeLbl.hidden = NO;
            [_iconImgView addSubview:placeLbl];
            self.placeLbl = placeLbl;
        }
    }

    _nameLbl.text = lecturerFrame.data.name;
    _postLbl.text = lecturerFrame.data.post;
    _briefLbl.text = lecturerFrame.data.brief;

    [self.separatorLineView setHidden:lecturerFrame.data.isSeparatorHidden];

    // UI Frame更新放到layoutSubviews再做

}

- (void)layoutSubviews {
    [super layoutSubviews];

    _titleLbl.frame = _lecturerFrame.titleLblF;
    _iconImgView.frame = _lecturerFrame.iconImgViewF;
    _nameLbl.frame = _lecturerFrame.nameLblF;
    _postLbl.frame = _lecturerFrame.postLblF;
    _briefLbl.frame = _lecturerFrame.briefLblF;
    _openBtn.frame = _lecturerFrame.openBtnF;
    _shrinkBtn.frame = _lecturerFrame.shrinkBtnF;
    _separatorLineView.frame = _lecturerFrame.separatorLineViewF;

    _nameBtn.frame = CGRectMake(CGRectGetMinX(_nameLbl.frame), 0, 100, 40);
    _nameBtn.center = CGPointMake(_nameBtn.center.x, _nameLbl.center.y);
    _iconBtn.frame = _iconImgView.frame;
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
