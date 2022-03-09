//
//  HomeworkDetailReqCell.m
//  HiClass
//
//  Created by 铁柱， on 2020/3/26.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HomeworkDetailReqCell.h"

@interface HomeworkDetailReqCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *titleConLabel;
@property (nonatomic, strong) UILabel *titleReqConLabel;
@end

@implementation HomeworkDetailReqCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createView];
    }
    return self;
}

-(void)createView {

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:titleLabel];

    UILabel *titleConLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleConLabel.numberOfLines = 0;
    [self.contentView addSubview:titleConLabel];

    UILabel *titleReqLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:titleReqLabel];

    UILabel *titleReqConLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleReqConLabel.numberOfLines = 0;
    [self.contentView addSubview:titleReqConLabel];

    UIView *lineView = [[UIView alloc] initWithFrame:CGRectZero];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
    [self.contentView addSubview:lineView];

    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(12);
        make.left.equalTo(self.contentView.mas_left).offset(16);
        make.right.equalTo(self.contentView.mas_right).offset(-16);
    }];

    [titleConLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(8);
        make.left.equalTo(self.contentView.mas_left).offset(16);
        make.right.equalTo(self.contentView.mas_right).offset(-16);
    }];

    [titleReqLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleConLabel.mas_bottom).offset(16);
        make.left.equalTo(self.contentView.mas_left).offset(16);
        make.right.equalTo(self.contentView.mas_right).offset(-16);
    }];

    [titleReqConLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleReqLabel.mas_bottom).offset(8);
        make.left.equalTo(self.contentView.mas_left).offset(16);
        make.right.equalTo(self.contentView.mas_right).offset(-16);
    }];

    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_bottom).offset(-8);
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.height.offset(8);
    }];

    titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    titleLabel.font = FONT_REGULAR_15;
    titleLabel.text = [NSString stringWithFormat:@"%@：",NSLocalizableString(@"reward", nil)];
    self.titleLabel = titleLabel;

    titleConLabel.textColor = [UIColor colorWithHexString:@"#858585"];
    titleConLabel.font = FONT_REGULAR_14;
    self.titleConLabel = titleConLabel;

    titleReqLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    titleReqLabel.font = FONT_REGULAR_15;
    titleReqLabel.text = [NSString stringWithFormat:@"%@：",NSLocalizableString(@"jobRequirements", nil)];

    titleReqConLabel.textColor = [UIColor colorWithHexString:@"#858585"];
    titleReqConLabel.font = FONT_REGULAR_14;
    self.titleReqConLabel = titleReqConLabel;

    // 测试
//    titleConLabel.text = @"提交时间： 12-09 09:30";
//    titleReqConLabel.text = @"提交时间： 12-09 09:30";
}

-(void)setDetailModel:(HomeworkDetailModel *)detailModel {
    if (self.detailModel == detailModel) {
        return;
    }
    [super setDetailModel:detailModel];

    self.titleConLabel.text = detailModel.rewardPoints == 0? @"":[NSString stringWithFormat:@"%@%ld%@", NSLocalizableString(@"youCanGet", nil),(long)detailModel.rewardPoints,NSLocalizableString(@"reward", nil)];
    self.titleLabel.text = detailModel.rewardPoints == 0? @"":NSLocalizableString(@"reward", nil);
    self.titleReqConLabel.text = detailModel.requires;
}

+(CGFloat)getStringHeight:(NSString *)str{
    if (!str || [str isEqualToString:@""]) {
        return 0;
    }

    NSDictionary *attribute = @{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size:14]};

    CGSize retSize = [str boundingRectWithSize:CGSizeMake(HIC_ScreenWidth-32, 0)
                                       options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                    attributes:attribute
                                       context:nil].size;
    CGFloat height = retSize.height;

    return height ;
}
@end
