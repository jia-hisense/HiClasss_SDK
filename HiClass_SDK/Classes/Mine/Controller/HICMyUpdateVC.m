//
//  HICMyUpdateVC.m
//  HiClass
//
//  Created by WorkOffice on 2020/3/17.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICMyUpdateVC.h"
#import "HICCustomNaviView.h"
@interface HICMyUpdateVC ()<HICCustomNaviViewDelegate>
@property (nonatomic, strong)UILabel *versionLabel;
@property (nonatomic, strong)UILabel *timeLabel;
@property (nonatomic, strong)UILabel *sizeLabel;
@property (nonatomic ,strong)UIImageView *topImage;
@property (nonatomic ,strong)UIButton *updateBtn;
@property (nonatomic ,strong)UIProgressView *progressView;
@property (nonatomic ,strong)UILabel *progressLabel;
@property (nonatomic, strong)HICCustomNaviView *navi;
@end

@implementation HICMyUpdateVC
- (UIImageView *)topImage{
    if (!_topImage) {
        _topImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_新版本"]];
        _topImage.frame = CGRectMake(0, HIC_StatusBar_Height + HIC_NavBarHeight, HIC_ScreenWidth, 188.5);
        [self.view addSubview:_topImage];
    }
    return _topImage;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self createNavi];
}
- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = NO;
}
- (void)createNavi {
    self.navi = [[HICCustomNaviView alloc] initWithTitle:NSLocalizableString(@"detectionOfUpdate", nil) rightBtnName:nil showBtnLine:NO];
    _navi.delegate = self;
    [self.view addSubview:_navi];
}
- (void)createUI{
    self.view.backgroundColor = UIColor.whiteColor;
    self.versionLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 214 + HIC_NavBarAndStatusBarHeight , HIC_ScreenWidth - 32, 20)];
    self.versionLabel.font = FONT_REGULAR_14;
    self.versionLabel.textColor  = TEXT_COLOR_DARK;
    self.versionLabel.text = [NSString stringWithFormat:@"%@：V1.2.0.2",NSLocalizableString(@"version", nil)];
    [self.view addSubview:self.versionLabel];
    self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 234 + HIC_NavBarAndStatusBarHeight , HIC_ScreenWidth - 32, 20)];
    self.timeLabel.font = FONT_REGULAR_14;
    self.timeLabel.textColor  = TEXT_COLOR_DARK;
    self.timeLabel.text = [NSString stringWithFormat:@"%@：V1.2.0.2",NSLocalizableString(@"version", nil)];
    [self.view addSubview:self.timeLabel];
    self.sizeLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 254 + HIC_NavBarAndStatusBarHeight , HIC_ScreenWidth - 32, 20)];
    self.sizeLabel.font = FONT_REGULAR_14;
    self.sizeLabel.textColor  = TEXT_COLOR_DARK;
    self.sizeLabel.text = [NSString stringWithFormat:@"%@：V1.2.0.2",NSLocalizableString(@"version", nil)];
    [self.view addSubview:self.sizeLabel];
    UILabel *introductLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 289 + HIC_NavBarAndStatusBarHeight, HIC_ScreenWidth, 20)];
    introductLabel.font = FONT_REGULAR_14;
    introductLabel.textColor  = TEXT_COLOR_DARK;
    [self.view addSubview:introductLabel];
    

    self.updateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _updateBtn .frame = CGRectMake(27.5, HIC_ScreenHeight - 16 - HIC_BottomHeight-48, HIC_ScreenWidth - 55, 48);
    [_updateBtn setTitle:NSLocalizableString(@"login", nil) forState: UIControlStateNormal];
    _updateBtn.titleLabel.font = FONT_MEDIUM_18;
    [_updateBtn setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
    _updateBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    _updateBtn.layer.masksToBounds = YES;
    _updateBtn.layer.cornerRadius = 4;
    [_updateBtn  addTarget:self action:@selector(update) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_updateBtn];
    
    self.progressLabel = [[UILabel alloc]initWithFrame:CGRectMake(51.5, HIC_ScreenHeight - HIC_BottomHeight - 36, HIC_ScreenWidth - 103, 20)];
    self.progressLabel.font = FONT_REGULAR_14;
    self.progressLabel.textColor = TEXT_COLOR_LIGHTM;
    [self.view addSubview:self.progressLabel];
    self.progressView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
    self.progressView.frame = CGRectMake(51.5, HIC_ScreenHeight - HIC_BottomHeight - 18, HIC_ScreenWidth - 103, 12);
    self.progressView.progressTintColor = [UIColor colorWithHexString:@"#00BED7"];
    [self.view addSubview:self.progressView];
    
    self.progressView.hidden = YES;
    self.progressLabel.hidden = YES;
    [self updateUI];
    
}
- (void)updateUI {
    [HICCommonUtils createGradientLayerWithBtn:self.updateBtn fromColor:[UIColor colorWithHexString:@"00E2D8" alpha:1.0f] toColor:[UIColor colorWithHexString:@"00C5E0" alpha:1.0f]];
}
- (void)update{
    self.updateBtn.hidden = YES;
    self.progressView.hidden = NO;
    self.progressLabel.hidden = NO;
}
#pragma mark - - - HICCustomNaviViewDelegate  - - -
- (void)leftBtnClicked {
    if (self.presentingViewController && self.navigationController.viewControllers.count == 1) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
