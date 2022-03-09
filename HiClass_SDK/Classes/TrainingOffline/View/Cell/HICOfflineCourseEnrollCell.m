//
//  HICOfflineCourseEnrollCell.m
//  HiClass
//
//  Created by WorkOffice on 2020/6/10.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import "HICOfflineCourseEnrollCell.h"
#import "UIView+Gradient.h"
@interface HICOfflineCourseEnrollCell()
@property (nonatomic ,strong)UILabel *topReasonLabel;
@property (nonatomic ,strong)UILabel *timeLabel;
@property (nonatomic ,strong)UILabel *applicationNumLabel;
@property (nonatomic ,strong)UILabel *enrolledNumLabel;
@property (nonatomic ,strong)UILabel *applicationRequestLabel;
@property (nonatomic ,strong)UILabel *bottomReasonLabel;
@property (nonatomic ,strong)UIButton *bottomBtn;
@property (nonatomic ,strong)UIView *middleView;
@property (nonatomic ,strong)UILabel *line;
@property (nonatomic ,strong)UILabel *bottomLine;
@end
@implementation HICOfflineCourseEnrollCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
        [self updateConstraintsIfNeeded];
    }
    return self;
}
- (void)createUI{
    self.topReasonLabel = [[UILabel alloc]init];
    self.topReasonLabel.textColor = [UIColor colorWithHexString:@"#FF8500"];
    self.topReasonLabel.font = FONT_MEDIUM_15;
    [self.contentView addSubview:self.topReasonLabel];
    [self.topReasonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(16);
        make.right.equalTo(self.contentView).offset(-16);
        make.top.equalTo(self.contentView).offset(16);
        make.height.offset(21);
    }];
    self.topReasonLabel.hidden = YES;
    self.middleView = [[UIView alloc]init];
    [self.contentView addSubview:self.middleView];
    [self.middleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.top.equalTo(self.topReasonLabel.mas_bottom).offset(12);
        make.height.offset(80);
    }];
    self.timeLabel = [[UILabel alloc]init];
    self.timeLabel.textColor = TEXT_COLOR_LIGHT;
    self.timeLabel.font = FONT_REGULAR_14;
    [self.middleView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.middleView).offset(16);
        make.right.equalTo(self.middleView).offset(-16);
        make.top.equalTo(self.middleView);
        make.height.offset(20);
    }];
    self.applicationNumLabel = [[UILabel alloc]init];
    self.applicationNumLabel.textColor = TEXT_COLOR_LIGHT;
    self.applicationNumLabel.font = FONT_REGULAR_14;
    [self.middleView addSubview:self.applicationNumLabel];
    [self.applicationNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.middleView).offset(16);
        make.right.equalTo(self.middleView).offset(-16);
        make.top.equalTo(self.timeLabel.mas_bottom);
        make.height.offset(20);
    }];
    self.enrolledNumLabel = [[UILabel alloc]init];
    self.enrolledNumLabel.textColor = TEXT_COLOR_LIGHT;
    self.enrolledNumLabel.font = FONT_REGULAR_14;
    [self.middleView addSubview:self.enrolledNumLabel];
    [self.enrolledNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.middleView).offset(16);
        make.right.equalTo(self.middleView).offset(-16);
        make.top.equalTo(self.applicationNumLabel.mas_bottom);
        make.height.offset(20);
    }];
    self.applicationRequestLabel = [[UILabel alloc]init];
    self.applicationRequestLabel.textColor = TEXT_COLOR_LIGHT;
    self.applicationRequestLabel.font = FONT_REGULAR_14;
    self.applicationRequestLabel.numberOfLines = 0;
    [self.middleView addSubview:self.applicationRequestLabel];
    [self.applicationRequestLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.middleView).offset(16);
        make.right.equalTo(self.middleView).offset(-16);
        make.top.equalTo(self.enrolledNumLabel.mas_bottom);
    }];
    self.bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:self.bottomBtn];
    self.bottomBtn.titleLabel.font = FONT_MEDIUM_15;
    _bottomBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    [self.bottomBtn addTarget: self action:@selector(clickRegisterBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.middleView.mas_bottom).offset(8);
        make.left.equalTo(self.contentView).offset(16);
        make.width.offset(80);
        make.height.offset(32);
    }];
 
    self.bottomReasonLabel = [[UILabel alloc]init];
    self.bottomReasonLabel.textColor = [UIColor colorWithHexString:@"#FF4B4B"];
    self.bottomReasonLabel.font = FONT_MEDIUM_14;
    [self.contentView addSubview:self.bottomReasonLabel];
    [self.bottomReasonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.middleView.mas_bottom).offset(16);
        make.left.equalTo(self.contentView).offset(16);
        make.right.equalTo(self.contentView).offset(-16);
        make.height.offset(20);
    }];
    self.bottomReasonLabel.hidden = YES;
    self.line = [[UILabel alloc]init];
    self.line.backgroundColor = DEVIDE_LINE_COLOR;
    self.line.hidden = YES;
    [self.contentView addSubview:self.line];
    self.bottomLine = [[UILabel alloc]init];
    self.bottomLine.backgroundColor = BACKGROUNG_COLOR;
    [self.contentView addSubview:self.bottomLine];
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView);
        make.width.offset(HIC_ScreenWidth);
        make.height.offset(8);
    }];
}
-(void)setModel:(HICEnrollDetailModel *)model{
    _model = model;
    self.timeLabel.text = [NSString stringWithFormat:@"%@: %@",NSLocalizableString(@"timeSigningUp", nil),[HICCommonUtils returnReadableTimeZoneWithStartTime:_model.registerStartTime andEndTime:_model.registerEndTime]];
     self.applicationNumLabel.text = [NSString stringWithFormat:@"%@ :%ld",NSLocalizableString(@"numberOfApplicants", nil),(long)_model.registerApplyNum];
     self.enrolledNumLabel.text = _model.enrollmentNumber == -1?[NSString stringWithFormat:@"%@: %@",NSLocalizableString(@"enrollment", nil),NSLocalizableString(@"noQuota", nil)]: [NSString stringWithFormat:@"%@ :%ld",NSLocalizableString(@"enrollment", nil),(long)_model.enrollmentNumber];
     self.applicationRequestLabel.text = [NSString stringWithFormat:@"%@: %@",NSLocalizableString(@"signUpRequirements", nil),[NSString isValidStr:_model.limit] ? _model.limit :@"--"];
    CGFloat labelHeight = [HICCommonUtils sizeOfString:self.applicationRequestLabel.text stringWidthBounding:HIC_ScreenWidth - 32 font:14 stringOnBtn:NO fontIsRegular:YES].height;
    if (_model.isPassFlag < 0) {
            self.topReasonLabel.text = _model.noPassReason;
            self.topReasonLabel.hidden = NO;
            self.topReasonLabel.textColor = [UIColor colorWithHexString:@"#FF8500"];
            return;
       }
    if(_model.status == HICEnrollNotRegister){//未报名
        if (_model.curTime.integerValue < _model.registerStartTime.integerValue) {
            [self.bottomBtn setTitle:NSLocalizableString(@"notStarted", nil) forState:UIControlStateNormal];
            self.bottomBtn.backgroundColor = [UIColor colorWithHexString:@"#D8D8D8"];
            self.bottomBtn.userInteractionEnabled = NO;
            self.topReasonLabel.hidden = YES;
            self.bottomReasonLabel.hidden = YES;
            self.enrolledNumLabel.hidden = YES;
            [self.applicationRequestLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.applicationNumLabel.mas_bottom);
            }];
            [self.middleView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.contentView).offset(16);
                make.height.offset(40 + labelHeight);
            }];
            [self.bottomBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.middleView.mas_bottom).offset(16);
            }];
        }else if(_model.curTime.integerValue > _model.registerEndTime.integerValue){
//            [self.bottomBtn setTitle:@"已过期" forState:UIControlStateNormal];
//            self.bottomBtn.backgroundColor = [UIColor colorWithHexString:@"#D8D8D8"];
            self.topReasonLabel.hidden = NO;
            self.topReasonLabel.textColor = [UIColor colorWithHexString:@"#FF8500"];
            self.timeLabel.hidden = YES;
            if (_model.registerStatus == HICEnrollHandEnd) {
                self.topReasonLabel.text = NSLocalizableString(@"administratorCosedTheRegistration", nil);
            }else{
                self.topReasonLabel.text = NSLocalizableString(@"registrationClosed", nil);
            }
            [self.applicationNumLabel mas_updateConstraints:^(MASConstraintMaker *make) {
               make.top.equalTo(self.middleView).offset(16);
            }];
        }else{
            
            if (_model.applicationsNumber ==  _model.registerApplyNum) {
                self.bottomBtn.hidden = YES;
                self.topReasonLabel.hidden = YES;
                self.bottomReasonLabel.hidden = NO;
                self.bottomReasonLabel.text = [NSString stringWithFormat:@"%@！",NSLocalizableString(@"nnableToRegisterPrompt", nil)];
                [self.middleView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.contentView).offset(16);
                }];
                return;
            }
            if (_model.registerStatus == HICEnrollPause) {
                [self.bottomBtn setTitle:NSLocalizableString(@"registrationHasBeenSuspended", nil) forState:UIControlStateNormal];
                self.bottomBtn.backgroundColor = [UIColor colorWithHexString:@"#D8D8D8"];
                return;
            }
            self.topReasonLabel.hidden = YES;
            self.bottomReasonLabel.hidden = YES;
            [self.middleView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.offset(60 + labelHeight);
                make.top.equalTo(self.contentView).offset(16);
            }];
            [self.bottomBtn setTitle:NSLocalizableString(@"signUpImmediately", nil) forState:UIControlStateNormal];
               [self.bottomBtn addGradientLayer:CGPointZero endPoint:CGPointMake(1, 0) colors:@[(__bridge id)[UIColor colorWithHexString:@"#00E2D8"].CGColor, (__bridge id)[UIColor colorWithHexString:@"#00C5E0"].CGColor]];
             _bottomBtn.layer.cornerRadius = 4;
              _bottomBtn.layer.masksToBounds = YES;
            [self.bottomBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.middleView.mas_bottom).offset(16);
            }];
        }
    }else if (_model.status == HICEnrolled){//已报名
        if (_model.userRegisterStatus == HICDisqualification ){
            self.bottomBtn.hidden = YES;
            self.bottomReasonLabel.hidden = YES;
            self.applicationRequestLabel.hidden = YES;
            self.topReasonLabel.hidden = NO;
            self.timeLabel.text = [NSString stringWithFormat:@"%@:%@",NSLocalizableString(@"giveUpTime", nil),[HICCommonUtils timeStampToReadableDate:model.giveUpTime isSecs:YES format:@"yyyy-MM-dd HH:mm"]];
            [self.middleView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.offset(60);
            }];
            if (_model.userRegisterStatus == HICDisqualification) {
                self.topReasonLabel.text = [NSString stringWithFormat:@"%@！",NSLocalizableString(@"registrationHasBeenAbandoned", nil)];
                 self.applicationNumLabel.text =  [NSString stringWithFormat:@"%@ :%ld",NSLocalizableString(@"numberOfApplicants", nil),(long)_model.registerApplyNum];
            }
        }else if (_model.userRegisterStatus == HICSubstituteStudent){
            [self.bottomBtn setTitle:NSLocalizableString(@"waiting", nil) forState:UIControlStateNormal];
            self.bottomBtn.userInteractionEnabled = NO;
            self.bottomBtn.backgroundColor = [UIColor colorWithHexString:@"#D8D8D8"];
            self.bottomReasonLabel.hidden = YES;
            self.topReasonLabel.text = [NSString stringWithFormat:@"%@！",NSLocalizableString(@"promptForFullQuota", nil)];
            self.topReasonLabel.hidden = NO;
            [self.middleView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.offset(60 + labelHeight);
            }];
            [self.bottomBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.middleView.mas_bottom).offset(16);
            }];
        }else if(_model.userRegisterStatus == HICAuditing){
            self.bottomBtn.hidden = YES;
            self.bottomReasonLabel.text = [NSString stringWithFormat:@"%@，%@>",NSLocalizableString(@"haveToSignUp", nil),NSLocalizableString(@"viewAuditProgress", nil)];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(checkReview)];
            [self.bottomReasonLabel addGestureRecognizer:tap];
            self.bottomReasonLabel.userInteractionEnabled = YES;
            [self.timeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.middleView);
            }];
            self.bottomReasonLabel.textColor = [UIColor colorWithHexString:@"#00BED7"];
            self.topReasonLabel.hidden = YES;
            self.bottomReasonLabel.hidden = NO;
            [self.middleView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.offset(60 + labelHeight);
                make.top.equalTo(self.contentView).offset(16);
            }];
            [self.bottomReasonLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.middleView.mas_bottom).offset(16);
            }];
        }else if(_model.userRegisterStatus == HICEnrollFaild || _model.userRegisterStatus == HICCancelQualification){
            if (_model.userRegisterStatus == HICEnrollFaild) {
                if (_model.approvalStatus == -1) {//审核不通过
                    self.bottomReasonLabel.text = [NSString stringWithFormat:@"%@%@",_model.curApproverName,[NSString isValidStr:_model.approvalOpinion] ? _model.approvalOpinion:NSLocalizableString(@"auditFailed", nil)];
                }else{
                    self.bottomReasonLabel.text = NSLocalizableString(@"registrationClosed", nil);
                }
            }else{
                 self.bottomReasonLabel.text = _model.expelReason;
            }
            self.bottomReasonLabel.hidden = NO;
             self.topReasonLabel.hidden = YES;
            [self.middleView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.offset(60 + labelHeight);
                make.top.equalTo(self.contentView).offset(16);
            }];
            [self.bottomReasonLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.middleView.mas_bottom).offset(16);
            }];
        }else if (_model.userRegisterStatus == HICFormalStudent){
            self.timeLabel.text = [NSString stringWithFormat:@"%@: %@",NSLocalizableString(@"submissionTime", nil),[HICCommonUtils timeStampToReadableDate:_model.createdTime isSecs:YES format:@"yyyy-MM-dd HH:mm"]];
               self.applicationNumLabel.text =  [NSString stringWithFormat:@"%@ :%ld",NSLocalizableString(@"numberOfApplicants", nil),(long)_model.registerApplyNum];
                self.topReasonLabel.attributedText =[NSAttributedString stringInsertImageWithImageName:@"对勾成功" imageReact:CGRectMake(0, -2, 16, 16) content:[NSString stringWithFormat:@" %@！",NSLocalizableString(@"signUpSuccess", nil)] stringColor:[UIColor colorWithHexString:@"#14BE6E"] stringFont:[UIFont fontWithName:@"PingFangSC-Medium" size:15]];
            self.bottomBtn.hidden = YES;
            self.bottomReasonLabel.hidden = YES;
            self.applicationRequestLabel.hidden = YES;
            self.topReasonLabel.hidden = NO;
            [self.middleView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.topReasonLabel.mas_bottom).offset(12);
                make.height.offset(60);
            }];
            if (_model.abandonEndTime.integerValue > _model.curTime.integerValue && model.abandonFlag == 1){
                self.line.hidden = NO;
                [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.contentView).offset(118.5);
                    make.left.equalTo(self.contentView).offset(16);
                    make.right.equalTo(self.contentView);
                    make.height.offset(0.5);
                }];
             
                [self.bottomBtn setTitle:NSLocalizableString(@"giveUpTheRegistration", nil) forState:UIControlStateNormal];
                self.bottomBtn.hidden = NO;
                  [self.bottomBtn addGradientLayer:CGPointZero endPoint:CGPointMake(1, 0) colors:@[(__bridge id)[UIColor colorWithHexString:@"#00E2D8"].CGColor, (__bridge id)[UIColor colorWithHexString:@"#00C5E0"].CGColor]];
                 _bottomBtn.layer.cornerRadius = 4;
                  _bottomBtn.layer.masksToBounds = YES;
                [self.bottomBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.line).offset(10);
                }];
                self.bottomReasonLabel.hidden = NO;
                self.bottomReasonLabel.textColor = TEXT_COLOR_LIGHT;
                self.bottomReasonLabel.font = FONT_REGULAR_14;
                self.bottomReasonLabel.text = [NSString stringWithFormat:@"%@: %@",NSLocalizableString(@"dendline", nil),[HICCommonUtils timeStampToReadableDate:_model.abandonEndTime isSecs:YES format:@"yyyy-MM-dd HH:mm"]];
                [self.bottomReasonLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.bottomBtn.mas_bottom).offset(10);
                }];
            }
        }else{
            
        }
    }else{//已过期
        self.topReasonLabel.hidden = NO;
        self.topReasonLabel.textColor = [UIColor colorWithHexString:@"#FF8500"];
        self.timeLabel.hidden = YES;
        if (_model.registerStatus == HICEnrollHandEnd) {
            self.topReasonLabel.text = NSLocalizableString(@"administratorCosedTheRegistration", nil);
        }else{
            self.topReasonLabel.text = NSLocalizableString(@"registrationClosed", nil);
        }
        [self.applicationNumLabel mas_updateConstraints:^(MASConstraintMaker *make) {
           make.top.equalTo(self.middleView);
        }];
        [self.middleView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(60);
        }];
    }
    
}
- (void)clickRegisterBtn:(UIButton *)btn{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickBtnWithTitle:)]) {
        [self.delegate clickBtnWithTitle:btn.titleLabel.text];
    }
}
- (void)checkReview{
    if (self.delegate && [self.delegate respondsToSelector:@selector(checkReviewStatus)]) {
        [self.delegate checkReviewStatus];
    }
}
@end
