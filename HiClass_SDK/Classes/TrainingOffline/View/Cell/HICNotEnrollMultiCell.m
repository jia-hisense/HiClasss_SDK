//
//  HICNotEnrollMultiCell.m
//  HiClass
//
//  Created by WorkOffice on 2020/6/5.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import "HICNotEnrollMultiCell.h"
#define Width self.contentView.frame.size.width
#define Height self.contentView.frame.size.height
@interface HICNotEnrollMultiCell ()
@property (nonatomic, assign) BaseCellBorderStyle borderStyle;//边框类型
@property (nonatomic, strong) UIColor *contentBorderColor;//边框颜色
@property (nonatomic, strong) UIColor *contentBackgroundColor;//边框内部内容颜色
@property (nonatomic, assign) CGFloat contentBorderWidth;//边框的宽度，这个宽度的一半会延伸到外部，如果对宽度比较敏感的要注意下
@property (nonatomic, assign) CGFloat contentMargin;//左右距离父视图的边距
@property (nonatomic, assign) CGSize contentCornerRadius;//边框的圆角
@property (nonatomic ,strong) UILabel *nameLabel;
@property (nonatomic ,strong) UILabel *lectureLabel;
@property (nonatomic ,strong) UIView *devideLine;
@property (nonatomic ,strong) UILabel *titleLabel;
@property (nonatomic ,strong)UIView *courseTimeView;
@end
@implementation HICNotEnrollMultiCell
+ (instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    HICNotEnrollMultiCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[HICNotEnrollMultiCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.borderStyle = BaseCellBorderStyleAllRound;
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    [super awakeFromNib];
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentBorderColor = [UIColor clearColor];
        self.contentBackgroundColor = [UIColor whiteColor];
        self.contentBorderWidth = 1.0;
        self.contentMargin = 12.0;
        self.contentCornerRadius = CGSizeMake(8, 8);
        [self createUI];
        [self updateConstraintsIfNeeded];
    }
    return self;
}
- (void)setBorderStyleWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    self.borderStyle = BaseCellBorderStyleAllRound;
}
- (void)setFrame:(CGRect)frame{
    frame.origin.x += 12;
    frame.origin.y += 6;
    frame.size.height -= 12;
    frame.size.width -= 24;
    [super setFrame:frame];
}
- (void)createUI{
    self.backgroundColor = UIColor.whiteColor;
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.lectureLabel];
    [self.contentView addSubview:self.devideLine];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.courseTimeView];
}

- (void)setModel:(HICNotEnrollCourseArrangeModel *)model{
    NSString *forStr = NSLocalizableString(@"offlinePrograms", nil);
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@ %@",forStr,model.lecturerName]];
       [attr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#4A90E2"] range:NSMakeRange(0, 3)];
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#151515"] range:NSMakeRange(4, attr.length-4)];
    self.nameLabel.attributedText = attr;
    self.lectureLabel.text = [NSString stringWithFormat:@"%@: %@",NSLocalizableString(@"lecturer", nil),model.lecturerName?model.lecturerName:@"--"];
    if (model.classStages.count > 0) {
        self.courseTimeView.frame = CGRectMake(0, 143.5, self.contentView.width, model.classStages.count * 52);
        for (int i = 0; i < model.classStages.count; i++) {
            HICClassStageModel *stageModel = model.classStages[i];
            UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, i *52, self.courseTimeView.width - 32, 20)];
            timeLabel.text = [NSString stringWithFormat:@"%@: %@",NSLocalizableString(@"time", nil),[HICCommonUtils returnReadableTimeZoneWithStartTime:stageModel.startTime andEndTime:stageModel.endTime]];
            timeLabel.font = FONT_REGULAR_14;
            timeLabel.textColor = TEXT_COLOR_LIGHTM;
            [self.courseTimeView addSubview:timeLabel];
            UILabel *placeLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, i *52 + 20, self.courseTimeView.width - 32, 20)];
            placeLabel.text = [NSString stringWithFormat:@"%@: %@",NSLocalizableString(@"place", nil),stageModel.place?stageModel.place:@"--"];
            placeLabel.font = FONT_REGULAR_14;
            placeLabel.textColor = TEXT_COLOR_LIGHTM;
            [self.courseTimeView addSubview:placeLabel];
        }
    }
}
- (void)updateConstraints{
    [super updateConstraints];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(16);
        make.right.equalTo(self).offset(-16);
        make.top.equalTo(self).offset(16);
    }];
    [self.lectureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.right.equalTo(self.nameLabel);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
        make.height.offset(20);
    }];
    [self.devideLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.right.equalTo(self.nameLabel);
        make.top.equalTo(self.lectureLabel.mas_bottom).offset(12);
        make.height.offset(0.5);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.right.equalTo(self.nameLabel);
        make.top.equalTo(self.devideLine.mas_bottom);
        make.height.offset(44);
    }];
    
}
- (UILabel *)nameLabel{
    if (!_nameLabel ) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.font = FONT_REGULAR_16;
        _nameLabel.textColor = TEXT_COLOR_DARK;
        _nameLabel.numberOfLines = 2;
    }
    return _nameLabel;
}
-(UILabel *)lectureLabel{
    if (!_lectureLabel ) {
        _lectureLabel = [[UILabel alloc]init];
        _lectureLabel.font = FONT_REGULAR_14;
        _lectureLabel.textColor = TEXT_COLOR_LIGHTM;
    }
    return _lectureLabel;
}
-(UIView *)devideLine{
    if (!_devideLine) {
        _devideLine = [[UIView alloc]init];
        _devideLine.backgroundColor = DEVIDE_LINE_COLOR;
    }
    return _devideLine;
}
-(UILabel *)titleLabel{
    if (!_titleLabel ) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = FONT_REGULAR_14;
        _titleLabel.textColor = TEXT_COLOR_DARK;
        _titleLabel.text = NSLocalizableString(@"availableClassTime", nil);
    }
    return _titleLabel;
}
- (UIView *)courseTimeView{
    if (!_courseTimeView) {
        _courseTimeView = [[UIView alloc]init];
    }
    return _courseTimeView;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    //在这里设置才能获取到真正显示时候的宽度，而不是原始的
    [self setupBorder];
}
- (void)setupBorder
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.lineWidth = self.contentBorderWidth;
    layer.strokeColor = self.contentBorderColor.CGColor;
    layer.fillColor =  self.contentBackgroundColor.CGColor;
    
    UIView *view = [[UIView alloc] initWithFrame:self.contentView.bounds];
    [view.layer insertSublayer:layer atIndex:0];
    view.backgroundColor = [UIColor clearColor];
    //用自定义的view代替cell的backgroundView
    self.backgroundView = view;
    
    CGRect rect = CGRectMake(0,0, Width, Height);
    switch (self.borderStyle) {
        case BaseCellBorderStyleNoRound:
        {
            UIBezierPath *path = [UIBezierPath bezierPathWithRect:rect];
            layer.path = path.CGPath;
        }
            break;
        case BaseCellBorderStyleTopRound:
        {
            UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:self.contentCornerRadius];
            layer.path = path.CGPath;
        }
            break;
        case BaseCellBorderStyleBottomRound:
        {
            UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:self.contentCornerRadius];
            layer.path = path.CGPath;
        }
            break;
        case BaseCellBorderStyleAllRound:
        {
            UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerAllCorners cornerRadii:self.contentCornerRadius];
            layer.path = path.CGPath;
        }
            break;
        default:
            break;
    }
}

@end
