//
//  HomeworkDetailWriteCell.m
//  HiClass
//
//  Created by 铁柱， on 2020/3/26.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HomeworkDetailWriteCell.h"

#define HDWC_But_Tag 60000

@interface HomeworkDetailWriteCell ()

@property (nonatomic, strong) UIView *writeBackView;

@property (nonatomic, strong) UILabel *writeContentLabel;
@property (nonatomic, strong) UIView *writeContentBackImageView;

@end

@implementation HomeworkDetailWriteCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createView];
    }
    return self;
}

-(void)createView {

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:titleLabel];

    UIView *backView = [[UIView alloc] initWithFrame:CGRectZero];
    self.writeBackView = backView;
    [self.contentView addSubview:backView];

    UIView *lineView = [[UIView alloc] initWithFrame:CGRectZero];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6"];
    [self.contentView addSubview:lineView];

    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(16);
        make.left.equalTo(self.contentView.mas_left).offset(16);
        make.right.equalTo(self.contentView.mas_right).offset(-16);
    }];

    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(lineView.mas_top).offset(-24.5);
        make.left.equalTo(self.contentView.mas_left).offset(16);
        make.right.equalTo(self.contentView.mas_right).offset(-16);
        make.top.equalTo(titleLabel.mas_bottom).offset(10.5);
    }];

    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-0.5);
        make.left.equalTo(self.contentView.mas_left).offset(16);
        make.right.equalTo(self.contentView.mas_right);
        make.height.offset(0.5);
    }];

    titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    titleLabel.font = FONT_REGULAR_15;
    titleLabel.text = [NSString stringWithFormat:@"%@：",NSLocalizableString(@"jobContent", nil)];

    backView.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
    backView.layer.cornerRadius = 4.f;
    backView.layer.masksToBounds = YES;

    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    contentLabel.numberOfLines = 0;
    [backView addSubview:contentLabel];
    UIView *contenBackImageView = [[UIView alloc] initWithFrame:CGRectZero];
    [backView addSubview:contenBackImageView];
    self.writeContentBackImageView = contenBackImageView;

    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backView.mas_top).offset(16);
        make.left.equalTo(backView.mas_left).offset(16);
        make.right.equalTo(backView.mas_right).offset(-16);
    }];
    [contenBackImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentLabel.mas_bottom).offset(12);
        make.left.equalTo(backView.mas_left).offset(16);
        make.right.equalTo(backView.mas_right).offset(-16);
        make.bottom.equalTo(backView.mas_bottom).offset(-16);
    }];

    contentLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    contentLabel.font = FONT_REGULAR_14;
    self.writeContentLabel = contentLabel;

    // 测试
    contentLabel.text = @"测试测试 ----";
}

-(void)setCellIndexPath:(NSIndexPath *)cellIndexPath {
    [super setCellIndexPath:cellIndexPath];

}
-(void)setDetailModel:(HomeworkDetailModel *)detailModel {
    if (self.detailModel == detailModel) {
        return;
    }
    [super setDetailModel:detailModel];
    self.writeContentLabel.text = detailModel.textContent;
    if (self.writeContentBackImageView.subviews.count > 0) {
        [self.writeContentBackImageView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    if (detailModel.attachments.count != 0) {
        NSInteger index = 0;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, HWD_WriteContentImageWidth, HWD_WriteContentImageWidth)];
        [self.writeContentBackImageView addSubview:imageView];
        imageView.backgroundColor = UIColor.redColor;
        for (HomeworkDetailAttachmentModel *model in detailModel.attachments) {
            NSInteger line = index%4;
            NSInteger row = index/4;
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0+(7+HWD_WriteContentImageWidth)*line, 0+(HWD_WriteContentImageRowSepc+HWD_WriteContentImageWidth)*row, HWD_WriteContentImageWidth, HWD_WriteContentImageWidth)];
            UIButton *but = [[UIButton alloc] initWithFrame:imageView.frame];
            [self.writeContentBackImageView addSubview:but];
            but.tag = HDWC_But_Tag + index;
            [but addTarget:self action:@selector(clickImageBack:) forControlEvents:UIControlEventTouchUpInside];
            UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake((HWD_WriteContentImageWidth-35)/2, (HWD_WriteContentImageWidth-35)/2, 35, 35)];
            [imageView addSubview:iconImageView];
            iconImageView.hidden = YES;
            [self.writeContentBackImageView addSubview:imageView];
            imageView.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6"];
            if (model.type == 1) {
                iconImageView.hidden = NO;
                iconImageView.image = [UIImage imageNamed:@"知识类型-视频"];
            }else if (model.type == 2) {
                iconImageView.hidden = NO;
                iconImageView.image = [UIImage imageNamed:@"知识类型-音频"];
            }else if (model.type == 4) {
                if (model.url) {
                    [imageView sd_setImageWithURL:[NSURL URLWithString:model.url]];
                }
            }
            index ++;
        }
    }
}

+(CGFloat)getStringHeight:(NSString *)str {
    if (!str || [str isEqualToString:@""]) {
        return 0;
    }

    NSDictionary *attribute = @{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size:14]};

    CGSize retSize = [str boundingRectWithSize:CGSizeMake(HIC_ScreenWidth-32-32, 0)
                                       options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                    attributes:attribute
                                       context:nil].size;
    CGFloat height = retSize.height;
    return height;
}

-(void)clickImageBack:(UIButton *)but {

    NSInteger index = but.tag - HDWC_But_Tag;
    HomeworkDetailAttachmentModel *model = [self.detailModel.attachments objectAtIndex:index];
    if ([self.delegate respondsToSelector:@selector(detailBaseCell:didSelectIndex:withModel:)]) {
        [self.delegate detailBaseCell:self didSelectIndex:index withModel:model];
    }
}

@end
