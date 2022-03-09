//
//  HICOfflineMaterialCell.m
//  HiClass
//
//  Created by hisense on 2020/4/24.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import "HICOfflineMaterialCell.h"


@implementation HICOfflineMaterialData


+(instancetype)initWithMaterial:(HICReferenceMaterial *)data isSeparatorHidden:(BOOL)isSeparatorHidden cellHeight:(CGFloat)cellHeight; {
    HICOfflineMaterialData *instance = [[HICOfflineMaterialData alloc] init];
    instance.data = data;
    instance.isSeparatorHidden = isSeparatorHidden;
    instance.cellHeight = cellHeight;
    return instance;
}

@end




@interface HICOfflineMaterialCell()

@property (nonatomic, weak) UIImageView *iconImgView;
@property (nonatomic, weak) UILabel *titleLbl;

@property (nonatomic, weak) UIView *separatorLineView;


@end




@implementation HICOfflineMaterialCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {

    static NSString *reusableIdentifier = @"HICOfflineMaterialCell";

    HICOfflineMaterialCell *cell = [tableView dequeueReusableCellWithIdentifier:reusableIdentifier];

    if (cell == nil) {
        cell = [[HICOfflineMaterialCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusableIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    UIImageView *iconImgView = [[UIImageView alloc] init];
    [self.contentView addSubview:iconImgView];
    self.iconImgView = iconImgView;

    UILabel *titleLbl = [[UILabel alloc] init];
    titleLbl.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    titleLbl.textColor = [UIColor colorWithHexString:@"#666666"];
    [self.contentView addSubview:titleLbl];
    self.titleLbl = titleLbl;


    UIView *separatorLineView = [[UIView alloc] init];
    self.separatorLineView = separatorLineView;
    [self.contentView addSubview:separatorLineView];
    separatorLineView.backgroundColor = [UIColor colorWithHexString:@"#E6E6E6"];
    return self;

}

- (void)setData:(HICOfflineMaterialData *)data {
    _data = data;

    _iconImgView.image = [UIImage imageNamed:[data.data iconOfMaterial]];

    _titleLbl.text =data.data.name;

    [_separatorLineView setHidden:data.isSeparatorHidden];

}


- (void)layoutSubviews {
    [super layoutSubviews];

    CGFloat leftPadding = 16;
    CGFloat rightPadding = 16;
    CGFloat cellW = HIC_ScreenWidth;

    _iconImgView.frame = CGRectMake(leftPadding, 0, 38, 38);

    CGFloat titleLblX = CGRectGetMaxX(_iconImgView.frame)+12;
    CGFloat titleLblW = cellW-titleLblX-rightPadding;
    _titleLbl.frame = CGRectMake(titleLblX, 0, titleLblW, 20);

    _iconImgView.center = CGPointMake(_iconImgView.center.x, _data.cellHeight/2.0);
    _titleLbl.center = CGPointMake(_titleLbl.center.x, _data.cellHeight/2.0);

    _separatorLineView.frame = CGRectMake(leftPadding, _data.cellHeight-0.5, cellW-leftPadding, 0.5);
    
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
