//
//  HICEnrollDetailVC.m
//  HiClass
//
//  Created by WorkOffice on 2020/6/4.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import "HICEnrollDetailVC.h"
#import "HICEnrollDetailModel.h"
#import "HICOfflineTrainInfoVC.h"
#import "HICEnrollReviewVC.h"
#import "HomeTaskCenterDefaultView.h"
@interface HICEnrollDetailVC ()<HICCustomNaviViewDelegate>
@property (nonatomic ,strong)UIButton *bottomBtn;
@property (nonatomic ,strong)HICNetModel *netModel;
@property (nonatomic ,strong)UILabel *bottomLabel;
@property (nonatomic ,strong)HICEnrollDetailModel *detailModel;
@property (nonatomic ,strong)UIScrollView *scrollView;
@property (nonatomic ,strong)UIView *devideLine;
@property (nonatomic ,strong)UILabel *nameLabel;
@property (nonatomic ,strong)UILabel *charityLabel;
@property (nonatomic ,strong)UIView *devideLine1;
@property (nonatomic ,strong)UILabel *descLabel;
@property (nonatomic ,strong)UILabel *descContentLabel;
@property (nonatomic ,strong)UIView *devideLine2;
@property (nonatomic ,strong)UILabel *timeLabel;
@property (nonatomic ,strong)UILabel *applicationNumLabel;
@property (nonatomic ,strong)UILabel *enrolledNumLabel;
@property (nonatomic ,strong)UILabel *enrolledRequestLabel;
@property (nonatomic ,strong)UILabel *reasonLabel;
@property (nonatomic ,strong)UIView *bottomView;
@property (nonatomic ,strong)HomeTaskCenterDefaultView *defaultView;
@property (nonatomic ,strong)UIButton *defalutBtn;
@end

@implementation HICEnrollDetailVC
#pragma mark --lazyload

-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, HIC_NavBarAndStatusBarHeight + 1, HIC_ScreenWidth, HIC_ScreenHeight - HIC_NavBarAndStatusBarHeight - HIC_BottomHeight)];
        _scrollView.backgroundColor = UIColor.whiteColor;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}
- (UILabel *)bottomLabel{
    if (!_bottomLabel) {
        _bottomLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, HIC_ScreenHeight -45 - HIC_BottomHeight, HIC_ScreenWidth, 45)];
        _bottomLabel.text = [NSString stringWithFormat:@"%@>",NSLocalizableString(@"viewAuditProgress", nil)];
        _bottomLabel.textAlignment = NSTextAlignmentCenter;
        _bottomLabel.textColor = [UIColor colorWithHexString:@"#00BED7"];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(checkReview)];
        _bottomLabel.userInteractionEnabled = YES;
        _bottomLabel.hidden = YES;
        [self.view addSubview:_bottomLabel];
        [_bottomLabel addGestureRecognizer:tap];
    }
    return _bottomLabel;
}
- (UIButton *)bottomBtn{
    if (!_bottomBtn) {
        _bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _bottomBtn.frame = CGRectMake(16, HIC_ScreenHeight - HIC_BottomHeight - 16 - 48, HIC_ScreenWidth - 32, 48);
        [_bottomBtn setTitle:NSLocalizableString(@"signUpImmediately", nil) forState: UIControlStateNormal];
        self.bottomBtn.userInteractionEnabled = NO;
        _bottomBtn.titleLabel.font = FONT_MEDIUM_17;
        [_bottomBtn setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
        _bottomBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _bottomBtn.layer.masksToBounds = YES;
        _bottomBtn.layer.cornerRadius = 4;
        [_bottomBtn addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomBtn;
}
- (UIButton *)defalutBtn{
    if (!_defalutBtn) {
        _defalutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _defalutBtn.frame = CGRectMake(16, HIC_ScreenHeight - HIC_BottomHeight - 16 - 48, HIC_ScreenWidth - 32, 48);
        [_defalutBtn setTitle:NSLocalizableString(@"inTheReview", nil) forState: UIControlStateNormal];
       _defalutBtn.userInteractionEnabled = NO;
        _defalutBtn.titleLabel.font = FONT_MEDIUM_17;
        [_defalutBtn setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
        _defalutBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _defalutBtn.layer.masksToBounds = YES;
        _defalutBtn.layer.cornerRadius = 4;
        [_defalutBtn addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        _defalutBtn.hidden = YES;
    }
    return _defalutBtn;
}
-(HomeTaskCenterDefaultView *)defaultView{
    if (!_defaultView) {
        _defaultView = [[HomeTaskCenterDefaultView alloc]initWithFrame:CGRectMake(0, HIC_NavBarAndStatusBarHeight, HIC_ScreenWidth, HIC_ScreenHeight - HIC_NavBarAndStatusBarHeight)];
        _defaultView.titleStr = NSLocalizableString(@"noReadingPermissionPrompt", nil);
        _defaultView.imageName = @"无权限";
        _defaultView.number = 2;
    }
    return _defaultView;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    if (self.detailModel.registerId) {
        [self loadData];
    }
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    [self createNavi];
    
    self.devideLine = [[UIView alloc]initWithFrame:CGRectMake(0, HIC_NavBarAndStatusBarHeight, HIC_ScreenWidth, 0.5)];
    self.devideLine.backgroundColor = DEVIDE_LINE_COLOR;
    [self.view addSubview:self.devideLine];
    [self createUI];
    [self loadData];
}
- (void)createNavi {
    HICCustomNaviView *navi = [[HICCustomNaviView alloc] initWithTitle:NSLocalizableString(@"registrationDetails", nil) rightBtnName:nil showBtnLine:NO];
    navi.delegate = self;
    [self.view addSubview:navi];
    
}
- (void)createUI{
    [self.view addSubview:self.scrollView];
    //    [self.view addSubview:self.tableView];
    //    self.tableView.delegate = self;
    //    self.tableView.dataSource = self;
    [self.view addSubview:self.bottomBtn];
    [self.bottomBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.textColor = TEXT_COLOR_DARK;
    self.nameLabel.font = FONT_MEDIUM_17;
    self.nameLabel.numberOfLines = 2;
    [self.scrollView addSubview:self.nameLabel];
    
    self.charityLabel = [[UILabel alloc]init];
    self.charityLabel.textColor = TEXT_COLOR_LIGHT;
    self.charityLabel.font = FONT_REGULAR_15;
    self.charityLabel.numberOfLines = 0;
    [self.scrollView addSubview:self.charityLabel];
    
    self.devideLine1 = [[UIView alloc]init];
    self.devideLine1.backgroundColor = DEVIDE_LINE_COLOR;
    [self.scrollView addSubview:_devideLine1];
    
    self.descLabel = [[UILabel alloc]init];
    self.descLabel.textColor = TEXT_COLOR_DARK;
    self.descLabel.font = FONT_MEDIUM_15;
    self.descLabel.text = NSLocalizableString(@"projectIntroduction", nil);
    [self.scrollView addSubview:self.descLabel];
    
    self.descContentLabel = [[UILabel alloc]init];
    self.descContentLabel.textColor = TEXT_COLOR_LIGHT;
    self.descContentLabel.font = FONT_REGULAR_14;
    self.descContentLabel.numberOfLines = 0;
    [self.scrollView addSubview:self.descContentLabel];
    
    self.devideLine2 = [[UIView alloc]init];
    self.devideLine2.backgroundColor = DEVIDE_LINE_COLOR;
    [self.scrollView addSubview:self.devideLine2];
    
    self.reasonLabel = [[UILabel alloc]init];
    self.reasonLabel.font = FONT_MEDIUM_15;
    self.reasonLabel.hidden = YES;
    self.reasonLabel.numberOfLines = 0;
    [self.scrollView addSubview:self.reasonLabel];
    
    self.bottomView = [[UIView alloc]init];
    //    self.bottomView.backgroundColor = UIColor.redColor;
    [self.scrollView addSubview:self.bottomView];
    
    self.timeLabel = [[UILabel alloc]init];
    self.timeLabel.textColor = TEXT_COLOR_LIGHT;
    self.timeLabel.font = FONT_REGULAR_14;
    [self.bottomView addSubview:self.timeLabel];
    
    self.applicationNumLabel = [[UILabel alloc]init];
    self.applicationNumLabel.textColor = TEXT_COLOR_LIGHT;
    self.applicationNumLabel.font = FONT_REGULAR_14;
    [self.bottomView addSubview:self.applicationNumLabel];
    
    self.enrolledNumLabel = [[UILabel alloc]init];
    self.enrolledNumLabel.textColor = TEXT_COLOR_LIGHT;
    self.enrolledNumLabel.font = FONT_REGULAR_14;
    [self.bottomView addSubview:self.enrolledNumLabel];
    
    self.enrolledRequestLabel = [[UILabel alloc]init];
    self.enrolledRequestLabel.textColor = TEXT_COLOR_LIGHT;
    self.enrolledRequestLabel.font = FONT_REGULAR_14;
    self.enrolledRequestLabel.numberOfLines = 0;
    [self.bottomView addSubview:self.enrolledRequestLabel];
    [self.view addSubview:self.defaultView];
    self.defaultView.hidden = YES;
    [self updateConstraints];
}
- (void)loadData {
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setValue:USER_CID forKey:@"customerId"];
    [dic setValue:_registerID.integerValue  ? _registerID :@-1 forKey:@"registerId"];
    [dic setValue:_trainId ? _trainId : @0 forKey:@"trainId"];
    [HICAPI registrationDetail:dic success:^(NSDictionary * _Nonnull responseObject) {
        self.detailModel = [HICEnrollDetailModel mj_objectWithKeyValues:responseObject[@"data"]];
        [self configScrollView];
        [self configBottomBtn];
    } failure:^(NSError * _Nonnull error) {
        self.defaultView.hidden = NO;
    }];
}
- (void)configScrollView{
    self.nameLabel.text = self.detailModel.registerName;
    self.charityLabel.text = [NSString stringWithFormat:@"%@: %@",NSLocalizableString(@"leadingCadre", nil),[NSString isValidStr:self.detailModel.personInCharge] ? self.detailModel.personInCharge : @"--"];
//    [self.charityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.nameLabel.mas_bottom).offset(6);
//        make.left.equalTo(self.scrollView).offset(16);
//        make.width.offset(HIC_ScreenWidth - 32);
//        make.height.offset(20);
//    }];
    self.descContentLabel.text = [NSString isValidStr:self.detailModel.registerDescription] ? self.detailModel.registerDescription : NSLocalizableString(@"noNow", nil);
    self.timeLabel.text = [NSString stringWithFormat:@"%@: %@",NSLocalizableString(@"timeSigningUp", nil),[HICCommonUtils returnReadableTimeZoneWithStartTime:self.detailModel.registerStartTime andEndTime:self.detailModel.registerEndTime]];
    self.applicationNumLabel.text = [NSString stringWithFormat:@"%@: %ld",NSLocalizableString(@"numberOfApplicants", nil),(long)self.detailModel.registerApplyNum];
    self.enrolledNumLabel.text = self.detailModel.enrollmentNumber == -1?[NSString stringWithFormat:@"%@: %@",NSLocalizableString(@"enrollment", nil),NSLocalizableString(@"noQuota", nil)]: [NSString stringWithFormat:@"%@ :%ld",NSLocalizableString(@"enrollment", nil),(long)self.detailModel.enrollmentNumber];
    self.enrolledRequestLabel.text = [NSString stringWithFormat:@"%@: %@",NSLocalizableString(@"signUpRequirements", nil),[NSString isValidStr:self.detailModel.limit] ? self.detailModel.limit :@"--"];
}
- (void)noPass{
    
}
- (void)configBottomBtn {
    if (self.detailModel.isPassFlag < 0) {
        self.reasonLabel.text = self.detailModel.noPassReason;
        self.reasonLabel.textColor = [UIColor colorWithHexString:@"#FF8500"];
        self.reasonLabel.font = FONT_MEDIUM_15;
        self.reasonLabel.hidden = NO;
        [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.reasonLabel.mas_bottom);
        }];
        self.bottomBtn.hidden = YES;
        self.bottomLabel.hidden = YES;
        return;
    }
    if (_detailModel.status == HICEnrolled) {
        if (self.detailModel.userRegisterStatus == HICAuditing){
            if(self.registerID){
                if ([self.view.subviews containsObject:self.bottomBtn]) {
                    [self.bottomBtn removeFromSuperview];
                }
                self.bottomBtn = _defalutBtn;
                self.bottomBtn.hidden = NO;
                [self.view addSubview:self.bottomBtn];
            }
                [self.bottomBtn setTitle:NSLocalizableString(@"inTheReview", nil) forState:UIControlStateNormal];
                self.bottomBtn.backgroundColor = [UIColor colorWithHexString:@"#D8D8D8"];
                self.bottomBtn.hidden = NO;
                self.reasonLabel.hidden = YES;
                self.bottomLabel.hidden = NO;
                [self.timeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.bottomView);
                }];
                [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.devideLine2).offset(16);
                }];

                [self.bottomBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(self.view).offset(-(45 + HIC_BottomHeight));
                    make.width.offset(HIC_ScreenWidth - 32);
                    make.height.offset(48);
                    make.left.equalTo(self.view).offset(16);
                }];


        }else if (self.detailModel.userRegisterStatus == HICDisqualification || self.detailModel.userRegisterStatus == HICCancelQualification || self.detailModel.userRegisterStatus == HICEnrollFaild){
            self.bottomBtn.hidden = YES;
            self.reasonLabel.hidden = NO;
            if (self.detailModel.userRegisterStatus == HICDisqualification) {
                self.reasonLabel.text = [NSString stringWithFormat:@"%@！",NSLocalizableString(@"registrationHasBeenAbandoned", nil)];
                self.timeLabel.text = [NSString stringWithFormat:@"%@: %@",NSLocalizableString(@"giveUpTime", nil),[HICCommonUtils timeStampToReadableDate:self.detailModel.giveUpTime isSecs:YES format:@"yyyy-MM-dd HH:mm"]];
                self.reasonLabel.textColor = [UIColor colorWithHexString:@"#FF8500"];
                self.reasonLabel.font = FONT_MEDIUM_15;
                self.enrolledRequestLabel.hidden = YES;
            }else if(self.detailModel.userRegisterStatus == HICCancelQualification){
                self.reasonLabel.text = _detailModel.expelReason;
                self.reasonLabel.numberOfLines = 0;
                self.reasonLabel.textColor = [UIColor colorWithHexString:@"#FF4B4B"];
            }else{
                 self.reasonLabel.textColor = [UIColor colorWithHexString:@"#FF4B4B"];
                if (_detailModel.approvalStatus == -1) {//审核不通过
                    self.reasonLabel.text = [NSString stringWithFormat:@"%@%@",_detailModel.curApproverName,[NSString isValidStr:_detailModel.approvalOpinion] ? _detailModel.approvalOpinion:NSLocalizableString(@"auditFailed", nil)];
                }else{//报名已结束
                    self.reasonLabel.text = NSLocalizableString(@"registrationClosed", nil);
                }
               
            }
            [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
                               make.top.equalTo(self.reasonLabel.mas_bottom);
                           }];
        }else if (self.detailModel.userRegisterStatus == HICFormalStudent){
            self.timeLabel.text = [NSString stringWithFormat:@"%@: %@",NSLocalizableString(@"submissionTime", nil),[HICCommonUtils timeStampToReadableDate:self.detailModel.createdTime isSecs:YES format:@"yyyy-MM-dd HH:mm"]];

            if ( self.detailModel.curTime.integerValue < self.detailModel.abandonEndTime.integerValue && self.detailModel.abandonFlag == 1) {
                [HICCommonUtils createGradientLayerWithBtn:self.bottomBtn fromColor:[UIColor colorWithHexString:@"00E2D8" alpha:1.0f] toColor:[UIColor colorWithHexString:@"00C5E0" alpha:1.0f]];
                self.bottomBtn.userInteractionEnabled = YES;
                self.bottomBtn.hidden = NO;
                [self.bottomBtn setTitle:[NSString stringWithFormat:@"%@(%@%@)",NSLocalizableString(@"giveUpTheRegistration", nil),[HICCommonUtils timeStampToReadableDate:self.detailModel.abandonEndTime isSecs:YES format:@"MM-dd HH:mm"],NSLocalizableString(@"stop", nil)] forState:UIControlStateNormal];
            }else{
                self.bottomBtn.hidden = YES;
            }
            
            self.reasonLabel.attributedText =[NSAttributedString stringInsertImageWithImageName:@"对勾成功" imageReact:CGRectMake(0, -2, 16, 16) content:[NSString stringWithFormat:@"  %@！",NSLocalizableString(@"signUpSuccess", nil)] stringColor:[UIColor colorWithHexString:@"#14BE6E"] stringFont:[UIFont fontWithName:@"PingFangSC-Medium" size:15]];
            self.enrolledRequestLabel.hidden = YES;
            self.reasonLabel.hidden = NO;
            [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.reasonLabel.mas_bottom);
            }];
            
        }else if (self.detailModel.userRegisterStatus == HICSubstituteStudent){
            [self.bottomBtn setTitle:NSLocalizableString(@"waiting", nil) forState:UIControlStateNormal];
            self.bottomBtn.backgroundColor = [UIColor colorWithHexString:@"#D8D8D8"];
            self.reasonLabel.text = NSLocalizableString(@"promptForFullQuota", nil);
            self.reasonLabel.textColor = [UIColor colorWithHexString:@"#FF8500"];
            self.reasonLabel.font = FONT_MEDIUM_15;
            self.reasonLabel.hidden = NO;
            self.timeLabel.hidden = YES;
            [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.reasonLabel.mas_bottom);
            }];
            [self.applicationNumLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.bottomView).offset(16);
                make.left.equalTo(self.bottomView).offset(16);
                make.right.equalTo(self.reasonLabel.mas_right);
                make.height.offset(20);
            }];
        }else{
            
        }
    }else if(_detailModel.status == HICEnrollExpired){
        [self.bottomBtn setTitle:NSLocalizableString(@"expired", nil) forState:UIControlStateNormal];
        self.bottomBtn.backgroundColor = [UIColor colorWithHexString:@"#D8D8D8"];
        self.bottomLabel.userInteractionEnabled = NO;
        if (_detailModel.registerStatus == HICEnrollHandEnd) {
            self.reasonLabel.text = NSLocalizableString(@"administratorCosedTheRegistration", nil);
            self.reasonLabel.textColor = [UIColor colorWithHexString:@"#FF8500"];
            self.reasonLabel.font = FONT_MEDIUM_15;
            self.reasonLabel.hidden = NO;
            self.timeLabel.hidden = YES;
            [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.reasonLabel.mas_bottom);
            }];
        }else{
            [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.devideLine2);
            }];
        }
    }else{
        self.reasonLabel.hidden = YES;
        [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.devideLine2);
        }];
        if (_detailModel.curTime.integerValue < _detailModel.registerStartTime.integerValue) {
            [self.bottomBtn setTitle:NSLocalizableString(@"notStarted", nil) forState:UIControlStateNormal];
            self.bottomBtn.backgroundColor = [UIColor colorWithHexString:@"#D8D8D8"];
            self.bottomLabel.userInteractionEnabled = NO;
        }else if(_detailModel.curTime.integerValue > _detailModel.registerEndTime.integerValue){
            [self.bottomBtn setTitle:NSLocalizableString(@"expired", nil) forState:UIControlStateNormal];
            self.bottomBtn.backgroundColor = [UIColor colorWithHexString:@"#D8D8D8"];
            self.bottomLabel.userInteractionEnabled = NO;
        }else{
            if (_detailModel.applicationsNumber ==  _detailModel.registerApplyNum) {
                [self.bottomBtn setTitle:NSLocalizableString(@"quotaisFull", nil) forState:UIControlStateNormal];
                self.bottomBtn.backgroundColor = [UIColor colorWithHexString:@"#D8D8D8"];
                self.bottomLabel.userInteractionEnabled = NO;
                return;
            }
            if (_detailModel.registerStatus == HICEnrollPause) {
                [self.bottomBtn setTitle:NSLocalizableString(@"registrationHasBeenSuspended", nil) forState:UIControlStateNormal];
                self.bottomBtn.backgroundColor = [UIColor colorWithHexString:@"#D8D8D8"];
                self.bottomLabel.userInteractionEnabled = NO;
                return;
            }
            [self.bottomBtn setTitle:NSLocalizableString(@"signUpImmediately", nil) forState:UIControlStateNormal];
            [HICCommonUtils createGradientLayerWithBtn:self.bottomBtn fromColor:[UIColor colorWithHexString:@"00E2D8" alpha:1.0f] toColor:[UIColor colorWithHexString:@"00C5E0" alpha:1.0f]];
            self.bottomBtn.userInteractionEnabled = YES;
            
        }
    }
}
-(void)updateConstraints{
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView).offset(20);
        make.left.equalTo(self.scrollView).offset(16);
        make.right.equalTo(self.scrollView).offset(-16);
    }];
    [self.charityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(6);
        make.left.equalTo(self.scrollView).offset(16);
        make.width.offset(HIC_ScreenWidth - 32);
//        make.height.offset(20);
    }];
    [self.devideLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.charityLabel.mas_bottom).offset(16);
        make.left.equalTo(self.scrollView).offset(16);
        make.width.offset(HIC_ScreenWidth - 32);
        make.height.offset(0.5);
    }];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.devideLine1).offset(16);
        make.left.equalTo(self.scrollView).offset(16);
        make.right.equalTo(self.charityLabel);
        make.height.offset(21);
    }];
    [self.descContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.descLabel.mas_bottom).offset(16);
        make.left.equalTo(self.scrollView).offset(16);
        make.right.equalTo(self.charityLabel);
    }];
    [self.devideLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.descContentLabel.mas_bottom).offset(16);
        make.left.equalTo(self.scrollView).offset(16);
        make.width.offset(HIC_ScreenWidth - 32);
        make.height.offset(0.5);
    }];
    [self.reasonLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.devideLine2).offset(16);
        make.left.equalTo(self.devideLine2);
        make.width.offset(HIC_ScreenWidth - 32);
//        make.height.offset(21);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.reasonLabel.mas_bottom).offset(12);
        make.left.equalTo(self.scrollView);
        make.width.offset(HIC_ScreenWidth);
        make.height.offset(140);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomView).offset(12);
        make.left.equalTo(self.bottomView).offset(16);
        make.right.equalTo(self.charityLabel);
        make.height.offset(20);
    }];
    [self.applicationNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeLabel.mas_bottom);
        make.left.equalTo(self.bottomView).offset(16);
        make.right.equalTo(self.charityLabel);
        make.height.offset(20);
    }];
    [self.enrolledNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.applicationNumLabel.mas_bottom);
        make.left.equalTo(self.bottomView).offset(16);
        make.right.equalTo(self.charityLabel);
        make.height.offset(20);
    }];
    [self.enrolledRequestLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.enrolledNumLabel.mas_bottom);
        make.left.equalTo(self.bottomView).offset(16);
        make.right.equalTo(self.charityLabel);
    }];
}
- (void)checkReview {//查看审核进度
    HICEnrollReviewVC * vc = HICEnrollReviewVC.new;
    vc.type = 2;
    vc.registerID = self.detailModel.registerId;
    vc.auditTemplateID = self.detailModel.acceptAuditProcessId;
    vc.registerName = self.detailModel.registerName;
    vc.trainId = self.detailModel.trainId;
    vc.auditInstanceId = self.detailModel.auditProcessInstanceId;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)leftBtnClicked {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)doRegisterWithType:(NSNumber*)type{
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setValue:_registerID ? _registerID :@-1 forKey:@"registerId"];
    [dic setValue:self.detailModel.customerId ? self.detailModel.customerId :@"" forKey:@"customerId"];
    [dic setValue:self.detailModel.registerName ? self.detailModel.registerName :@"" forKey:@"registerName"];
    [dic setValue:type forKey:@"doRegister"];
    [dic setValue:_trainId ?_trainId :@0 forKey:@"trainId"];
    [HICAPI doRegisterWithType:dic success:^(NSDictionary * _Nonnull responseObject) {
        if ([HICCommonUtils isValidObject:responseObject[@"msg"]]) {
            NSString *title;
            if ([type isEqual:@1]) {
                title = NSLocalizableString(@"registrationSuccessPrompt", nil);
            }else{
                title = [NSString stringWithFormat:@"%@！",NSLocalizableString(@"registrationHasBeenAbandoned", nil)];
            }
            UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:NSLocalizableString(@"prompt", nil) message:title preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *confirm = [UIAlertAction actionWithTitle:NSLocalizableString(@"determine", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [alertVc addAction:confirm];
            [self presentViewController:alertVc animated:YES completion:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}
- (void)clickButton:(UIButton *)btn{
    if ([btn.titleLabel.text isEqualToString:NSLocalizableString(@"signUpImmediately", nil)]) {
        if (self.detailModel.acceptAuditProcessStatus == 0) {//无审核
            [self doRegisterWithType:@1];
        }else{
            HICEnrollReviewVC *vc = HICEnrollReviewVC.new;
            vc.auditTemplateID = self.detailModel.acceptAuditProcessId;
            vc.type = 1;
            vc.registerID = _registerID;
            vc.trainId = _trainId;
            vc.registerName = self.detailModel.registerName;
            vc.auditInstanceId = self.detailModel.auditProcessInstanceId;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if ([btn.titleLabel.text containsString:NSLocalizableString(@"giveUpTheRegistration", nil)]){
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@?",NSLocalizableString(@"confirmCancellationPrompt", nil)] message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * cancel = [UIAlertAction actionWithTitle:NSLocalizableString(@"cancel", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *confirm = [UIAlertAction actionWithTitle:NSLocalizableString(@"determine", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self doRegisterWithType:@-1];
        }];
        [alertVc addAction:cancel];
        [alertVc addAction:confirm];
        [self presentViewController:alertVc animated:YES completion:nil];
    }else{
        
    }
}

/*
 [HICCommonUtils createGradientLayerWithBtn:shareBtn fromColor:[UIColor colorWithHexString:@"00E2D8" alpha:1.0f] toColor:[UIColor colorWithHexString:@"00C5E0" alpha:1.0f]];
 */
@end
