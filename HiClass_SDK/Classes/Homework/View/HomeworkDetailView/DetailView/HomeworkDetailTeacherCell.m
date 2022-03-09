//
//  HomeworkDetailTeacherCell.m
//  HiClass
//
//  Created by 铁柱， on 2020/3/26.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HomeworkDetailTeacherCell.h"

@interface HomeworkDetailTeacherCell ()

@property (nonatomic, strong) UILabel *contentTeacher;
@property (nonatomic, strong) UILabel *contentTime;
@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation HomeworkDetailTeacherCell

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
    [self.contentView addSubview:backView];

    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(16);
        make.left.equalTo(self.contentView.mas_left).offset(16);
        make.right.equalTo(self.contentView.mas_right).offset(-16);
    }];

    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
        make.left.equalTo(self.contentView.mas_left).offset(16);
        make.right.equalTo(self.contentView.mas_right).offset(-16);
        make.top.equalTo(titleLabel.mas_bottom).offset(10);
    }];

    titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    titleLabel.font = FONT_REGULAR_15;
    titleLabel.text = [NSString stringWithFormat:@"%@：",NSLocalizableString(@"teacherEvaluation", nil)];

    backView.backgroundColor = [UIColor colorWithHexString:@"#fffaec"];
    backView.layer.cornerRadius = 4.f;
    backView.layer.masksToBounds = YES;

    UILabel *contentTeacher = [[UILabel alloc] initWithFrame:CGRectZero];
    [backView addSubview:contentTeacher];
    UILabel *contentTime = [[UILabel alloc] initWithFrame:CGRectZero];
    [backView addSubview:contentTime];
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    contentLabel.numberOfLines = 0;
    [backView addSubview:contentLabel];

    [contentTeacher mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backView.mas_top).offset(16);
        make.left.equalTo(backView.mas_left).offset(16);
    }];
    [contentTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(contentTeacher.mas_centerY);
        make.right.equalTo(backView.mas_right).offset(-16);
    }];
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentTeacher.mas_bottom).offset(8);
        make.right.equalTo(backView.mas_right).offset(-16);
        make.left.equalTo(backView.mas_left).offset(16);
    }];

    contentTeacher.textColor = [UIColor colorWithHexString:@"#666666"];
    contentTeacher.font = FONT_REGULAR_14;

    contentTime.textColor = [UIColor colorWithHexString:@"#999999"];
    contentTime.font = FONT_REGULAR_13;
    contentTime.textAlignment = NSTextAlignmentRight;

    contentLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    contentLabel.font = FONT_REGULAR_14;

    self.contentTeacher = contentTeacher;
    self.contentTime = contentTime;
    self.contentLabel = contentLabel;
//    // 测试
//    contentTeacher.text = @"马老师：";
//    contentTime.text = @"2019-98-87";
//    contentLabel.text = @"测试测试 ----";
}

-(void)setDetailModel:(HomeworkDetailModel *)detailModel {
    if (self.detailModel == detailModel) {
        return;
    }
    [super setDetailModel:detailModel];
    self.contentTeacher.text = detailModel.reviewerName;
    self.contentTime.text = [NSString stringWithFormat:@"%@", [HICCommonUtils timeStampToReadableDate:[NSNumber numberWithInteger:self.detailModel.reviewTime] isSecs:YES format:@"MM-dd HH:mm"]];
    self.contentLabel.text = detailModel.evaluation;
}

+(CGFloat)getStringHeight:(NSString *)str {
    if (!str || [str isEqualToString:@""]) {
        return 0;
    }

    NSDictionary *attribute = @{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size:14]};

    CGSize retSize = [str boundingRectWithSize:CGSizeMake(HIC_ScreenWidth-32, 0)
                                       options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                    attributes:attribute
                                       context:nil].size;
    CGFloat height = retSize.height;
    return height;
}

@end
