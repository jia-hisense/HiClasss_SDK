//
//  HICNotEnrollSingleCell.m
//  HiClass
//
//  Created by WorkOffice on 2020/6/5.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import "HICNotEnrollSingleCell.h"
#define Width self.contentView.frame.size.width
#define Height self.contentView.frame.size.height
@interface HICNotEnrollSingleCell ()
@property (nonatomic, assign) BaseCellBorderStyle borderStyle;//边框类型
@property (nonatomic, strong) UIColor *contentBorderColor;//边框颜色
@property (nonatomic, strong) UIColor *contentBackgroundColor;//边框内部内容颜色
@property (nonatomic, assign) CGFloat contentBorderWidth;//边框的宽度，这个宽度的一半会延伸到外部，如果对宽度比较敏感的要注意下
@property (nonatomic, assign) CGFloat contentMargin;//左右距离父视图的边距
@property (nonatomic, assign) CGSize contentCornerRadius;//边框的圆角
@property (nonatomic ,strong)UILabel *nameLabel;
@property (nonatomic ,strong)UILabel *timeLabel;
@property (nonatomic ,strong)UILabel *locationLabel;
@property (nonatomic ,strong)UILabel *lectureLabel;
@end
@implementation HICNotEnrollSingleCell
+ (instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    HICNotEnrollSingleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[HICNotEnrollSingleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
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
- (void)setModel:(HICNotEnrollCourseArrangeModel *)model{
    NSString *forStr;
    if (_model == model) {
        return;
    }
    _model = model;
    HICClassStageModel *stageModel;
    if (_model.classStages.count > 0) {
        stageModel = _model.classStages[0];
    }
    if (_model.taskType == 1 || _model.taskType == 2) {
        forStr = NSLocalizableString(@"onlineCourses", nil);
        self.locationLabel.hidden = YES;
        self.lectureLabel.hidden = YES;
    }else{
        forStr = NSLocalizableString(@"offlinePrograms", nil);
        self.lectureLabel.text = [NSString stringWithFormat:@"%@: %@",NSLocalizableString(@"lecturer", nil),_model.lecturerName?_model.lecturerName:@"--"];
          self.locationLabel.text = [NSString stringWithFormat:@"%@: %@",NSLocalizableString(@"place", nil),stageModel.place?stageModel.place:@"--"];;
    }
    self.timeLabel.text = [NSString stringWithFormat:@"%@: %@",NSLocalizableString(@"time", nil),[HICCommonUtils returnReadableTimeZoneWithStartTime:stageModel.startTime andEndTime:stageModel.endTime]];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@ %@",forStr,_model.resClassName]];
    [attr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#4A90E2"] range:NSMakeRange(0, 4)];
     [attr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#151515"] range:NSMakeRange(5, attr.length-5)];
    self.nameLabel.attributedText = attr;
    
}
- (void)setFrame:(CGRect)frame{
    frame.origin.x += 12;
    frame.origin.y += 6;
    frame.size.height -= 12;
    frame.size.width -= 24;
    [super setFrame:frame];
}
- (void)createUI{
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.locationLabel];
    [self.contentView addSubview:self.lectureLabel];
}
- (void)updateConstraints{
    [super updateConstraints];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(16);
        make.right.equalTo(self).offset(-16);
        make.top.equalTo(self).offset(16);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(10);
        make.left.equalTo(self.nameLabel);
        make.right.equalTo(self.nameLabel);
        make.height.offset(20);
    }];
    [self.locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeLabel.mas_bottom);
        make.left.equalTo(self.timeLabel);
        make.right.equalTo(self.timeLabel);
        make.height.offset(20);
    }];
    [self.lectureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.locationLabel.mas_bottom);
        make.left.equalTo(self.locationLabel);
        make.right.equalTo(self.locationLabel);
        make.height.offset(20);
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
-(UILabel *)timeLabel{
    if (!_timeLabel ) {
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.font = FONT_REGULAR_14;
        _timeLabel.textColor = TEXT_COLOR_LIGHTM;
    }
    return _timeLabel;
}
-(UILabel *)locationLabel{
    if (!_locationLabel ) {
        _locationLabel = [[UILabel alloc]init];
        _locationLabel.font = FONT_REGULAR_14;
        _locationLabel.textColor = TEXT_COLOR_LIGHTM;
    }
    return _locationLabel;
}
-(UILabel *)lectureLabel{
    if (!_lectureLabel ) {
        _lectureLabel = [[UILabel alloc]init];
        _lectureLabel.font = FONT_REGULAR_14;
        _lectureLabel.textColor = TEXT_COLOR_LIGHTM;
    }
    return _lectureLabel;
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
