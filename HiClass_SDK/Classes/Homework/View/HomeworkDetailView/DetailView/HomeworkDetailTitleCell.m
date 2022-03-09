//
//  HomeworkDetailTitleCell.m
//  HiClass
//
//  Created by 铁柱， on 2020/3/26.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HomeworkDetailTitleCell.h"

@interface HomeworkDetailTitleCell ()
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@end

@implementation HomeworkDetailTitleCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createView];
    }
    return self;
}

-(void)createView {

    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    iconImageView.hidden = NO;
    [self.contentView addSubview:iconImageView];

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.numberOfLines = 0;
    [self.contentView addSubview:titleLabel];

    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:timeLabel];

    UIView *lineView = [[UIView alloc] initWithFrame:CGRectZero];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6"];
    [self.contentView addSubview:lineView];

    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(16);
        make.left.equalTo(self.contentView.mas_left).offset(16);
        make.right.equalTo(self.contentView.mas_right).offset(-16);
    }];

    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(lineView.mas_top).offset(-16);
        make.left.equalTo(self.contentView.mas_left).offset(16);
        make.right.equalTo(self.contentView.mas_right).offset(-16);
    }];

    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(24);
        make.right.equalTo(self.contentView.mas_right).offset(-8);
        make.width.offset(72);
        make.height.offset(72);
    }];

    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-0.1);
        make.left.equalTo(self.contentView.mas_left).offset(16);
        make.right.equalTo(self.contentView.mas_right);
        make.height.offset(0.5);
    }];

    titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    titleLabel.font = FONT_REGULAR_16;

    timeLabel.textColor = [UIColor colorWithHexString:@"#858585"];
    timeLabel.font = FONT_REGULAR_14;

    self.iconImageView = iconImageView;
    self.titleLabel = titleLabel;
    self.timeLabel = timeLabel;

    // 测试数据

    titleLabel.text = @"作业组组赴俄法戒";
    timeLabel.text = @"提交时间： 12-09 09:30";
}
/// 设置值的时候需要在setCellPass后
-(void)setDetailModel:(HomeworkDetailModel *)detailModel {
//    if (self.detailModel == detailModel) {
//        return;
//    }
    // 上述方法在此应用场景中不适应
    [super setDetailModel:detailModel];
    if (detailModel.essence == 1) {
        if (_iconImageView.subviews.count > 0) {
            [_iconImageView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        }
        _iconImageView.image = [UIImage imageNamed:@"印章-精华"];
    }

}

-(void)setTitleName:(NSString *)titleName {
    [super setTitleName:titleName];
    self.titleLabel.text = titleName;
}

-(void)setEndTime:(NSString *)endTime {
    [super setEndTime:endTime];
    self.timeLabel.text = endTime;
}
// 子类实现父类的方法
-(void)setCellPassImage:(BOOL)isPass score:(NSInteger)score isShowScore:(BOOL)isShowScore {
    [super setCellPassImage:isPass score:score isShowScore:isShowScore]; // 可以不写，为了完整性添加此方法

    if (isPass) {
        _iconImageView.image = [UIImage imageNamed:@"分数印章"];
        if (isShowScore) {
            if (self.totalScore && self.totalScore  == score) {
                _iconImageView.image = [UIImage imageNamed:@"印章-满分"];
            }else{
                CGSize gradeSize = [HICCommonUtils sizeOfString:[NSString stringWithFormat:@"%ld", (long)score] stringWidthBounding:72 font:22 stringOnBtn:NO fontIsRegular:NO];
                UILabel *grade = [[UILabel alloc] initWithFrame:CGRectMake((72 - gradeSize.width)/2, (72 - gradeSize.height)/2, gradeSize.width, gradeSize.height)];
                [_iconImageView addSubview:grade];
                grade.text = [NSString stringWithFormat:@"%ld", (long)score];
                grade.font = FONT_MEDIUM_22;
                grade.textColor = [UIColor colorWithHexString:@"#14BE6E" alpha:0.5];
                [HICCommonUtils setTransform:-30.0/180 forLable:grade];
            }
        }
    }else {
        _iconImageView.image = [UIImage imageNamed:@"印章-不合格"];
    }
}

+(CGFloat)getStringHeight:(NSString *)str {
    if (!str || [str isEqualToString:@""]) {
        return 0;
    }

    NSDictionary *attribute = @{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size:16]};

    CGSize retSize = [str boundingRectWithSize:CGSizeMake(HIC_ScreenWidth-32, 0)
                                       options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                    attributes:attribute
                                       context:nil].size;
    CGFloat height = retSize.height;
    if (height > 45) {
        return height - 45;
    }
    return 0;
}

@end
