//
//  HICEnrollListCell.m
//  HiClass
//
//  Created by WorkOffice on 2020/6/4.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import "HICEnrollListCell.h"
#define Width self.contentView.frame.size.width
#define Height self.contentView.frame.size.height
@interface HICEnrollListCell ()
@property (nonatomic, assign) BaseCellBorderStyle borderStyle;//边框类型
@property (nonatomic, strong) UIColor *contentBorderColor;//边框颜色
@property (nonatomic, strong) UIColor *contentBackgroundColor;//边框内部内容颜色
@property (nonatomic, assign) CGFloat contentBorderWidth;//边框的宽度，这个宽度的一半会延伸到外部，如果对宽度比较敏感的要注意下
@property (nonatomic, assign) CGFloat contentMargin;//左右距离父视图的边距
@property (nonatomic, assign) CGSize contentCornerRadius;//边框的圆角
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *applicationNumLabel;
@property (nonatomic, strong) UILabel *enrolledNumLabel;
@property (nonatomic, strong) UILabel *tagLabel;
@property (nonatomic, strong) UILabel *reasonLabel;
@end
@implementation HICEnrollListCell

+ (instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    HICEnrollListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[HICEnrollListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
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
    self.nameLabel  = [[UILabel alloc]init];
    self.nameLabel.font = FONT_REGULAR_16;
    self.nameLabel.textColor = TEXT_COLOR_DARK;
    self.nameLabel.numberOfLines = 1;
    [self.contentView addSubview:self.nameLabel];
    
    self.dateLabel = [[UILabel alloc]init];
    self.dateLabel.font = FONT_REGULAR_14;
    self.dateLabel.textColor = TEXT_COLOR_LIGHTM;
    [self.contentView addSubview:self.dateLabel];
    self.applicationNumLabel = [[UILabel alloc]init];
    self.applicationNumLabel.font = FONT_REGULAR_14;
    self.applicationNumLabel.textColor = TEXT_COLOR_LIGHTM;
    [self.contentView addSubview:self.applicationNumLabel];
    self.enrolledNumLabel = [[UILabel alloc]init];
    self.enrolledNumLabel.font = FONT_REGULAR_14;
    self.enrolledNumLabel.textColor = TEXT_COLOR_LIGHTM;
    [self.contentView addSubview:self.enrolledNumLabel];
    
    self.reasonLabel = [[UILabel alloc]init];
    self.reasonLabel.font = FONT_REGULAR_14;
    self.reasonLabel.numberOfLines = 1;
    self.reasonLabel.textColor = [UIColor colorWithHexString:@"#FF8500"];
    self.reasonLabel.hidden = YES;
    [self.contentView addSubview:self.reasonLabel];
    self.tagLabel = [[UILabel alloc]init];
    self.tagLabel.font = FONT_REGULAR_14;
    self.tagLabel.textColor = TEXT_COLOR_LIGHTS;
    self.tagLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.tagLabel];
}
-(void)setModel:(HICEnrollListModel *)model{
    if (model == _model) {
        return;
    }
    _model = model;
    self.nameLabel.text = _model.name;
    self.dateLabel.text = [NSString stringWithFormat:@"%@: %@",NSLocalizableString(@"timeSigningUp", nil),[HICCommonUtils returnReadableTimeZoneWithStartTime:_model.startTime andEndTime:_model.endTime]];
    self.applicationNumLabel.text = [NSString stringWithFormat:@"%@: %ld",NSLocalizableString(@"numberOfApplicants", nil),(long)_model.registerApplyNum];
    self.enrolledNumLabel.text = [NSString stringWithFormat:@"%@: %ld",NSLocalizableString(@"enrollment", nil),(long)_model.enrollmentNumber];
    if (_model.enrollmentNumber == -1) {
        self.enrolledNumLabel.text = [NSString stringWithFormat:@"%@: %@",NSLocalizableString(@"enrollment", nil),NSLocalizableString(@"noQuota", nil)];
    }
    self.applicationNumLabel.hidden = NO;
    self.reasonLabel.text = @"";
    if (_model.status == HICEnrolled) {
        self.dateLabel.textColor = TEXT_COLOR_LIGHTM;
        self.applicationNumLabel.hidden = NO;
        [self.enrolledNumLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.dateLabel.mas_bottom).offset(20);
        }];
        if (_model.userRegisterStatus == HICFormalStudent) {
            self.reasonLabel.hidden = YES;
            self.tagLabel.text = NSLocalizableString(@"signUpSuccess", nil);
            self.applicationNumLabel.hidden = YES;
            self.tagLabel.textColor = [UIColor colorWithHexString:@"#14BE6E"];
            [self.enrolledNumLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.dateLabel.mas_bottom);
            }];
        }else if (_model.userRegisterStatus == HICSubstituteStudent){
            self.tagLabel.text = NSLocalizableString(@"waiting", nil);
             self.tagLabel.textColor = TEXT_COLOR_LIGHTS;
            self.reasonLabel.text = NSLocalizableString(@"promptForFullQuota", nil);
            self.reasonLabel.hidden = NO;
        }else if(_model.userRegisterStatus == HICAuditing){
            self.tagLabel.text = NSLocalizableString(@"inTheReview", nil);
            self.tagLabel.textColor = TEXT_COLOR_LIGHTS;
             self.reasonLabel.hidden = YES;
        }else if (_model.userRegisterStatus == HICCancelQualification){
            self.tagLabel.text = NSLocalizableString(@"registrationCancelled", nil);
            self.tagLabel.textColor = [UIColor colorWithHexString:@"#FF4B4B"];
            self.reasonLabel.textColor = [UIColor colorWithHexString:@"#FF4B4B"];
            self.reasonLabel.hidden = NO;
            self.reasonLabel.text = [NSString stringWithFormat:@"%@: %@",NSLocalizableString(@"reason", nil),_model.expelReason];
        }else if (_model.userRegisterStatus == HICEnrollFaild){
            self.tagLabel.text = NSLocalizableString(@"registrationFailed", nil);
            self.reasonLabel.hidden = NO;
            self.tagLabel.textColor = [UIColor colorWithHexString:@"#FF4B4B"];
            self.reasonLabel.textColor = [UIColor colorWithHexString:@"#FF4B4B"];
//            self.reasonLabel.text = _model.noPassReason;
            if (_model.approvalStatus == -1) {//审批不通过
                self.reasonLabel.text = [NSString stringWithFormat:@"%@: %@%@",NSLocalizableString(@"reason", nil),_model.curApproverName,NSLocalizableString(@"approvalFailed", nil)];
            }else{
                 self.reasonLabel.text = NSLocalizableString(@"reasonsForPrompt", nil);
            }
        }else if (_model.userRegisterStatus == HICDisqualification){
            self.applicationNumLabel.hidden = NO;
            self.tagLabel.text = NSLocalizableString(@"registrationHasBeenAbandoned", nil);
            self.reasonLabel.hidden = YES;
            self.tagLabel.textColor = [UIColor colorWithHexString:@"#FF8500"];
            self.dateLabel.textColor = TEXT_COLOR_LIGHTM;
            
        }else{
            self.applicationNumLabel.hidden = NO;
             self.reasonLabel.hidden = YES;
        }
    }else if(_model.status == HICEnrollExpired){
         self.applicationNumLabel.hidden = NO;
               [self.enrolledNumLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                   make.top.equalTo(self.dateLabel.mas_bottom).offset(20);
               }];
        self.tagLabel.text = NSLocalizableString(@"expired", nil);
         self.tagLabel.textColor = TEXT_COLOR_LIGHTS;
         self.dateLabel.textColor = [UIColor colorWithHexString:@"#FF8500"];
        if (_model.registerStatus == HICEnrollHandEnd) {
            self.dateLabel.text = NSLocalizableString(@"administratorHasFinishedRegistering", nil);
        }else{
            self.dateLabel.text = NSLocalizableString(@"registrationTimeHasEnded", nil);
        }
    }else{
        self.applicationNumLabel.hidden = NO;
                [self.enrolledNumLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.dateLabel.mas_bottom).offset(20);
                }];
        self.dateLabel.textColor = TEXT_COLOR_LIGHTM;
        if (_model.registerStatus == HICEnrollPause) {
            self.tagLabel.text = NSLocalizableString(@"registrationHasBeenSuspended", nil);
            self.tagLabel.textColor = TEXT_COLOR_LIGHTS;
            return;
            }
        if (_model.curTime.integerValue < _model.startTime.integerValue) {
            self.tagLabel.text = NSLocalizableString(@"notStarted", nil);
             self.tagLabel.textColor = TEXT_COLOR_LIGHTS;
            self.applicationNumLabel.hidden = YES;
            [self.enrolledNumLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.dateLabel.mas_bottom);
            }];
        }else if(_model.curTime.integerValue > _model.endTime.integerValue){
//            self.tagLabel.text = @"已过期";
        }else{
            self.tagLabel.text = NSLocalizableString(@"registrationimg", nil);
            self.tagLabel.textColor = [UIColor colorWithHexString:@"#00BED7"];
            if (_model.applicationsNumber ==  _model.registerApplyNum) {
                self.tagLabel.text = NSLocalizableString(@"quotaisFull", nil);
                self.tagLabel.textColor = [UIColor colorWithHexString:@"#FF4B4B"];
            }
            
        }
    }
    [self layoutIfNeeded];
}
- (void)updateConstraints{
    [super updateConstraints];
    [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(16);
        make.left.equalTo(self).offset(16);
        make.right.equalTo(self).offset(-123.5);
    }];
    [self.dateLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(11);
        make.left.equalTo(self.nameLabel);
        make.right.equalTo(self).offset(-16);
        make.height.offset(20);
    }];
    [self.applicationNumLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dateLabel.mas_bottom);
        make.left.equalTo(self).offset(16);
        make.right.equalTo(self).offset(-16);
        make.height.offset(20);
    }];
     [self.enrolledNumLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.applicationNumLabel.mas_bottom);
            make.left.equalTo(self).offset(16);
            make.right.equalTo(self).offset(-16);
            make.height.offset(20);
        }];
    [self.reasonLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.enrolledNumLabel.mas_bottom).offset(10);
        make.left.equalTo(self).offset(16);
        make.right.equalTo(self).offset(-16);
        make.height.offset(20);
    }];
    [self.tagLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel);
        make.right.equalTo(self).offset(-16);
        make.left.equalTo(self.nameLabel.mas_right).offset(10);
        make.height.offset(20);
    }];
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
