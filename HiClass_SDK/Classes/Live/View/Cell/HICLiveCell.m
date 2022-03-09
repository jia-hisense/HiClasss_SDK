//
//  HICLiveCell.m
//  HiClass
//
//  Created by hisense on 2020/8/18.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import "HICLiveCell.h"
#import "UIView+Gradient.h"
#define Width self.contentView.frame.size.width
#define Height self.contentView.frame.size.height
@interface HICLiveCell ()
@property (nonatomic, strong)HICLiveLessonModel *lessonModel;
@property (nonatomic, strong)HICLiveTeacherModel *teacherModel;
@property (nonatomic ,strong)NSString *teacherName;

@property (nonatomic, assign) BaseCellBorderStyle borderStyle;//边框类型
@property (nonatomic, strong) UIColor *contentBorderColor;//边框颜色
@property (nonatomic, strong) UIColor *contentBackgroundColor;//边框内部内容颜色
@property (nonatomic, assign) CGFloat contentBorderWidth;//边框的宽度，这个宽度的一半会延伸到外部，如果对宽度比较敏感的要注意下
@property (nonatomic, assign) CGFloat contentMargin;//左右距离父视图的边距
@property (nonatomic, assign) CGSize contentCornerRadius;//边框的圆角
@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *teacherLabel;
@property (nonatomic, strong) UILabel *pointsLabel;
@property (nonatomic, strong) UIButton *checkReplayBtn;
@property (nonatomic, strong) UIButton *onGoingLabel;
@end

@implementation HICLiveCell

+ (instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    HICLiveCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[HICLiveCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.borderStyle = BaseCellBorderStyleAllRound;
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentBorderColor = [UIColor clearColor];
        self.contentBackgroundColor = [UIColor whiteColor];
        self.contentBorderWidth = 1.0;
        self.contentMargin = 12.0;
        self.contentCornerRadius = CGSizeMake(8, 8);
        [self makeAutoLayout];
    }
    return self;
}

- (void)setBorderStyleWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    self.borderStyle = BaseCellBorderStyleAllRound;
}

- (void)setFrame:(CGRect)frame{
    frame.origin.x += 12;
    frame.origin.y += 6;
    frame.size.height -= 12;
    frame.size.width -= 24;
    [super setFrame:frame];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self setupBorder];
}
#pragma mark -- Public Methods
- (void)loadData:(HICLiveListModel *)model {
    self.lessonModel = model.liveLesson;
    self.teacherName = model.teacherName;
    
    self.nameLabel.text = self.lessonModel.name;
 
    BOOL showPoints = self.lessonModel.points.integerValue > 0 && self.lessonModel.status < HICLiveEnd;
    self.pointsLabel.hidden = !showPoints;
    if (showPoints) {
        self.pointsLabel.text = HICLocalizedFormatString(@"liveRewardPoints", self.lessonModel.points.integerValue);
    }

    self.timeLabel.text = [NSMutableString stringWithFormat:@"%@：%@",NSLocalizableString(@"liveTime", nil),[HICCommonUtils returnReadabelTimeDayWithStartTime:self.lessonModel.startTime andEndTime:self.lessonModel.endTime]];
    self.teacherLabel.text = [NSString stringWithFormat:@"%@：%@",NSLocalizableString(@"liveInstructor", nil),self.teacherName];
    
    [self.leftImageView sd_setImageWithURL:[NSURL URLWithString:self.lessonModel.backgroundUrl] placeholderImage:[UIImage imageNamed:@"直播默认图"]];
    
    self.onGoingLabel.hidden = !self.isAll;
    if (self.isAll) {
        [self updateOngoingLabel];
    }
}

#pragma mark -- Private Methods
- (void)backBtnClicked {
    if (self.cellDelegate && [self.cellDelegate respondsToSelector:@selector(playBackWithParams:andMediaId:andMediaName:)]) {
        [self.cellDelegate playBackWithParams:_backModel.playbackParam andMediaId:_backModel.liveLessonId andMediaName:self.lessonModel.name];
    }
    DDLogDebug(@"点击回看按钮");
    [LogManager reportSerLogWithType:HICPlayBackBtn params:@{@"mediaid":self.backModel.liveLessonId, @"buttonname":@"回放"}];
}

- (void)setBackModel:(HICLivePlayBackInfo *)backModel {
    _backModel = backModel;
    if ([NSString isValidStr:backModel.playbackParam] && self.lessonModel.status == HICLiveEnd) {
        self.checkReplayBtn.hidden = NO;
    }else{
        self.checkReplayBtn.hidden = YES;
    }
}

- (void)makeAutoLayout {
    [self.leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(12);
        make.top.equalTo(self.contentView).offset(12);
        make.bottom.equalTo(self.contentView).inset(12);
        make.width.equalTo(@110);
        make.height.equalTo(@94).priority(MASLayoutPriorityDefaultHigh);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftImageView.mas_right).offset(12);
        make.top.equalTo(self.leftImageView);
        make.right.equalTo(self.contentView).inset(12);
    }];
    [self.pointsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.leftImageView);
        make.bottom.equalTo(self.leftImageView);
        make.height.equalTo(@18);
    }];
    [self.teacherLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftImageView.mas_right).offset(12);
        make.right.equalTo(self.contentView).inset(12);
        make.bottom.equalTo(self.leftImageView);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftImageView.mas_right).offset(12);
        make.right.equalTo(self.contentView).inset(12);
        make.bottom.equalTo(self.teacherLabel.mas_top);
    }];
    [self.checkReplayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftImageView).offset(3);
        make.bottom.equalTo(self.leftImageView).offset(-3);
        make.width.equalTo(@54);
        make.height.equalTo(@20);
    }];
}

- (void)setupBorder {
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

- (void)updateOngoingLabel {
    if (self.onGoingLabel.layer.sublayers.firstObject && [self.onGoingLabel.layer.sublayers.firstObject isKindOfClass:CAGradientLayer.class]) {
        [self.onGoingLabel.layer.sublayers.firstObject removeFromSuperlayer];
    }
    switch (self.lessonModel.status) {
        case HICLiveInProgress:
            [self.onGoingLabel setTitle:NSLocalizableString(@"ongoing", nil) forState:UIControlStateNormal];
            [HICCommonUtils createGradientLayerWithBtn:self.onGoingLabel fromColor:[UIColor colorWithHexString:@"#FF8500"] toColor:[UIColor colorWithHexString:@"#FF9624"]];
            break;
        case HICLiveWait:
            [self.onGoingLabel setTitle:NSLocalizableString(@"waitStart", nil) forState:UIControlStateNormal];
            [HICCommonUtils createGradientLayerWithBtn:self.onGoingLabel fromColor:[UIColor colorWithHexString:@"#FFC76C"] toColor:[UIColor colorWithHexString:@"#FFB843"]];
            break;
        default:
            [self.onGoingLabel setTitle:NSLocalizableString(@"hasEnded", nil) forState:UIControlStateNormal];
            [HICCommonUtils createGradientLayerWithBtn:self.onGoingLabel fromColor:[UIColor colorWithHexString:@"#D0D0D0"] toColor:[UIColor colorWithHexString:@"#D0D0D0"]];
            break;
    }
}

#pragma mark -- LazyLoad
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel  = [[UILabel alloc]init];
        _nameLabel.font = FONT_REGULAR_15;
        _nameLabel.textColor = TEXT_COLOR_DARK;
        [self.contentView addSubview:_nameLabel];
    }
    return _nameLabel;
}
- (UILabel *)pointsLabel {
    if (!_pointsLabel) {
        _pointsLabel = [[UILabel alloc]init];
        _pointsLabel.font = FONT_REGULAR_11;
        _pointsLabel.textColor = [UIColor whiteColor];
        _pointsLabel.textAlignment = NSTextAlignmentCenter;
        _pointsLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.35];
        [self.leftImageView addSubview:_pointsLabel];
    }
    return _pointsLabel;
}
- (UILabel *)teacherLabel  {
    if (!_teacherLabel) {
        _teacherLabel = [[UILabel alloc]init];
        _teacherLabel.font = FONT_REGULAR_12;
        _teacherLabel.textColor = TEXT_COLOR_LIGHTM;
        [self.contentView addSubview:_teacherLabel];
    }
    return _teacherLabel;
}
- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.font = FONT_REGULAR_12;
        _timeLabel.textColor = TEXT_COLOR_LIGHTM;
        [self.contentView addSubview:_timeLabel];
    }
    return _timeLabel;
}
- (UIImageView *)leftImageView {
    if (!_leftImageView) {
        _leftImageView = [[UIImageView alloc]init];
        _leftImageView.backgroundColor = BACKGROUNG_COLOR;
        _leftImageView.layer.cornerRadius = 4;
        _leftImageView.clipsToBounds = YES;
        _leftImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_leftImageView];
    }
    return _leftImageView;
}
- (UIButton *)checkReplayBtn {
    if (!_checkReplayBtn) {
        _checkReplayBtn = [[UIButton alloc]initWithFrame:CGRectMake(HIC_ScreenWidth - 115,100 , 80, 32)];
        [_checkReplayBtn setTitle:NSLocalizableString(@"backToSee", nil) forState:UIControlStateNormal];
        _checkReplayBtn.titleLabel.font = FONT_REGULAR_12;
        _checkReplayBtn.backgroundColor = [UIColor colorWithHexString:@"#00BED7"];
        _checkReplayBtn.layer.cornerRadius = 2;
        [_checkReplayBtn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        _checkReplayBtn.hidden = YES;
        [self.contentView addSubview:_checkReplayBtn];
    }
    return _checkReplayBtn;
}
- (UIButton *)onGoingLabel {
    if (!_onGoingLabel) {
        _onGoingLabel = [UIButton buttonWithType:UIButtonTypeCustom];
        [_onGoingLabel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _onGoingLabel.titleLabel.font = FONT_MEDIUM_9;
        _onGoingLabel.frame = CGRectMake(HIC_ScreenWidth - 56,0, 31, 12);
        [self.contentView addSubview:_onGoingLabel];
        [HICCommonUtils setRoundingCornersWithView:_onGoingLabel TopLeft:NO TopRight:YES bottomLeft:YES bottomRight:NO cornerRadius:4];
        _onGoingLabel.backgroundColor = UIColor.redColor;
    }
    return _onGoingLabel;
}

@end
