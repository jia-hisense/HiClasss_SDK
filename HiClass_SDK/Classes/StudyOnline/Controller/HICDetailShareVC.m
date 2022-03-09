//
//  HICDetailShareVC.m
//  HiClass
//
//  Created by WorkOffice on 2020/3/5.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICDetailShareVC.h"
#import "HICNetModel.h"
#import "HICMyBaseInfoModel.h"
@interface HICDetailShareVC ()<HICCustomNaviViewDelegate>
@property (nonatomic ,strong)UIImageView *headerView;
@property (nonatomic ,strong)UILabel *nameLabel;
@property (nonatomic ,strong)UILabel *positionLabel;
@property (nonatomic ,strong)UILabel *trainNameLabel;
@property (nonatomic ,strong)UILabel *timeLabel;
@property (nonatomic ,strong)UILabel *rankLabel;
@property (nonatomic ,strong)UILabel *rankTitleLabel;
@property (nonatomic ,strong)UILabel *wordLabel;
@property (nonatomic ,strong)UIView *line;
@property (nonatomic ,strong)UIImageView *leftImage;
@property (nonatomic ,strong)UIImageView *rightImage;
@property (nonatomic ,strong)UIImageView *backView;
@property (nonatomic ,strong)HICNetModel *netModel;
@property (nonatomic ,strong)HICMyBaseInfoModel *baseInfoModel;
@end

@implementation HICDetailShareVC
- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    // Do any additional setup after loading the view.
    [self createUI];
    [self getUserData];
    [self createNavi];
}
- (void)createUI{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, HIC_NavBarAndStatusBarHeight, HIC_ScreenWidth, HIC_ScreenHeight - HIC_NavBarAndStatusBarHeight)];
    view.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
    [self.view addSubview:view];
    CGFloat n = (HIC_ScreenWidth - 32) /343.0;
   
    self.backView = [[UIImageView alloc]initWithFrame:CGRectMake(16,10, HIC_ScreenWidth - 32, 500 * n)];
    _backView.image = [UIImage imageNamed:@"分享排名-卡片背景"];
    [view addSubview:_backView];
    self.headerView  = [[UIImageView alloc]initWithFrame:CGRectMake((HIC_ScreenWidth - 90 - 32) /2, 54, 90, 90)];
    self.headerView.backgroundColor = UIColor.lightGrayColor;
    self.headerView.layer.cornerRadius = 45;
    self.headerView.clipsToBounds = YES;
    [_backView addSubview:self.headerView];
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 152 *n, HIC_ScreenWidth - 32, 25)];
    self.nameLabel.font = FONT_MEDIUM_18;
    self.nameLabel.textColor = TEXT_COLOR_DARK;
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    
    self.nameLabel.text = RoleManager.userDetailModel.name;
    [_backView addSubview:self.nameLabel];
    
//    self.positionLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 190, HIC_ScreenWidth - 32, 25)];
//    self.positionLabel.text = @"-";
//    self.positionLabel.textAlignment = NSTextAlignmentCenter;
//    self.positionLabel.font =
    self.line = [[UIView alloc]initWithFrame:CGRectMake((HIC_ScreenWidth - 32 - 2)/2, 193 *n, 2, 2)];
    self.line.backgroundColor = [UIColor colorWithHexString:@"#B9B9B9"];
    [_backView addSubview:self.line];
    
    self.trainNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 212 *n, HIC_ScreenWidth - 70, 45)];
    self.trainNameLabel.textAlignment = NSTextAlignmentCenter;
    self.trainNameLabel.font = FONT_REGULAR_16;
    self.trainNameLabel.textColor = TEXT_COLOR_DARK;
    self.trainNameLabel.text = _model.trainName;
    self.trainNameLabel.numberOfLines = 2;
    [_backView addSubview:self.trainNameLabel];
    
    self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 258.5 *n, HIC_ScreenWidth - 32, 20)];
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    self.timeLabel.font = FONT_REGULAR_14;
    self.timeLabel.textColor = TEXT_COLOR_LIGHTM;
     self.timeLabel.text = [HICCommonUtils returnReadableTimeZoneWithStartTime:_model.startTime andEndTime:_model.endTime];
    [_backView addSubview:self.timeLabel];
    
   self.rankLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 313.5 *n, HIC_ScreenWidth - 32, 70)];
   self.rankLabel.textAlignment = NSTextAlignmentCenter;
   self.rankLabel.font = FONT_REGULAR_50;
   self.rankLabel.textColor = [UIColor colorWithHexString:@"#181818"];
//    self.rankLabel.text = @"1";
    self.rankLabel.text = [NSString stringWithFormat:@"%@",_rankNum];
   [_backView addSubview:self.rankLabel];
    
//    self.rankTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake((HIC_ScreenWidth - 32 - 28)/2*n, 383.5 * n, 28 *n, 20)];
    self.rankTitleLabel = [[UILabel alloc]init];
    self.rankTitleLabel.width = 28;
    self.rankTitleLabel.height = 20;
    self.rankTitleLabel.centerX = _backView.centerX - 16;
    self.rankTitleLabel.Y = 383.5 * n;
    self.rankTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.rankTitleLabel.font = FONT_REGULAR_14;
    self.rankTitleLabel.textColor = TEXT_COLOR_LIGHT;
    self.rankTitleLabel.text = NSLocalizableString(@"ranking", nil);
    [_backView addSubview:self.rankTitleLabel];
    
//    self.leftImage = [[UIImageView alloc]initWithFrame:CGRectMake((HIC_ScreenWidth - 32 - 28)/2*n - 17.5 - 6.5, 388.5 *n, 17.5 + 6.5, 10)];
    self.leftImage = [[UIImageView alloc]init];
    self.leftImage.X = self.rankTitleLabel.X - 25;
    self.leftImage.Y = self.rankTitleLabel.Y + 5;
    self.leftImage.height = 10;
    self.leftImage.width = 17.5;
    self.leftImage.image = [UIImage imageNamed:@"排名-装饰线"];
    [_backView addSubview:self.leftImage];
    
//    self.rightImage = [[UIImageView alloc]initWithFrame:CGRectMake((HIC_ScreenWidth - 32)/2*n + 14, 388.5 *n, 17.5 + 6.5, 10)];
    self.rightImage = [[UIImageView alloc]init];
    self.rightImage.X = self.rankTitleLabel.X + 34;
    self.rightImage.Y = self.rankTitleLabel.Y + 5;
    self.rightImage.height = 10;
    self.rightImage.width = 17.5;
    self.rightImage.image = [UIImage imageNamed:@"排名-装饰线"];
    [_backView addSubview:self.rightImage];
    
    self.wordLabel = [[UILabel alloc]initWithFrame:CGRectMake( 0 , 423.5 *n, HIC_ScreenWidth - 32, 22.5)];
    self.wordLabel.textAlignment = NSTextAlignmentCenter;
    self.wordLabel.font = FONT_REGULAR_16;
    self.wordLabel.textColor = TEXT_COLOR_DARK;
    [_backView addSubview:self.wordLabel];
    
    UIButton *shareBtn = [[UIButton alloc]initWithFrame:CGRectMake(27.5, HIC_ScreenHeight - 27 - 47 - HIC_BottomHeight - HIC_NavBarAndStatusBarHeight, HIC_ScreenWidth - 54, 48)];
    [shareBtn setTitle:NSLocalizableString(@"clickShare", nil) forState: UIControlStateNormal];
    shareBtn.titleLabel.font = FONT_MEDIUM_18;
    [shareBtn setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
    shareBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    shareBtn.layer.masksToBounds = YES;
    shareBtn.layer.cornerRadius = 4;
    [shareBtn addTarget:self action:@selector(shareClick) forControlEvents:UIControlEventTouchUpInside];
     [HICCommonUtils createGradientLayerWithBtn:shareBtn fromColor:[UIColor colorWithHexString:@"00E2D8" alpha:1.0f] toColor:[UIColor colorWithHexString:@"00C5E0" alpha:1.0f]];
    [view addSubview:shareBtn];
    if ([_rankNum isEqual: @1]) {
           self.wordLabel.text = NSLocalizableString(@"invincible", nil);
       }else if ([_rankNum isEqual:@2]){
           self.wordLabel.text = NSLocalizableString(@"peak", nil);
       }else{
           self.wordLabel.text = NSLocalizableString(@"nextLookMe", nil);
       }
}
- (void)getUserData{
    [HICAPI homePageDataQuery:^(NSDictionary * _Nonnull responseObject) {
        [RoleManager hiddenWindowLoadingView];
        if (responseObject[@"data"] ) {
            self.baseInfoModel = [HICMyBaseInfoModel mj_objectWithKeyValues:responseObject[@"data"][@"baseInfo"]];
            if ([NSString  isValidStr:self.baseInfoModel.headPic]) {
                //                         NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.baseInfoModel.headPic]];
                //                         self.headerView.image = [UIImage imageWithData:data];
                if (self.headerView.subviews) {
                    [self.headerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                }
                [self.headerView sd_setImageWithURL:[NSURL URLWithString:self.baseInfoModel.headPic]];
            }
            else{
                UILabel *label = [HICCommonUtils setHeaderFrame:self.headerView.bounds andText:self.baseInfoModel.name];
                label.hidden = NO;
                [self.headerView addSubview:label];
            }
            self.nameLabel.text = self.baseInfoModel.name;
        }
    } failure:^(NSError * _Nonnull error) {
        [RoleManager hiddenWindowLoadingView];
        UILabel *label = [HICCommonUtils setHeaderFrame:self.headerView.bounds andText:RoleManager.userDetailModel.name];
        label.hidden = NO;
        [self.headerView addSubview:label];
    }];
}
- (void)createNavi {
    HICCustomNaviView *navi = [[HICCustomNaviView alloc] initWithTitle:NSLocalizableString(@"shareRanking", nil) rightBtnName:nil showBtnLine:NO];
    navi.backgroundColor = UIColor.whiteColor;
    navi.delegate = self;
    [self.view addSubview:navi];
}
- (void)setModel:(HICTrainDetailBaseModel *)model{
    _model = model;

}
- (UIImage *)convertCreateImageWithUIView:(UIImageView *)view{
//    UIGraphicsBeginImageContext(view.bounds.size);
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//    [view.layer renderInContext:ctx];
//    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, 0.0);//[UIScreen mainScreen].scale
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
- (void)shareClick{
    UIImage *shareImg = [self convertCreateImageWithUIView:self.backView];
    //    NSURL *shareUrl = [NSURL URLWithString:@"http://www.baidu.com"];
    //    NSArray *activityItems = @[shareTitle,shareImg,shareUrl];
        NSArray *activityItems = @[shareImg];
        UIActivityViewController *activityVc = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
        [self presentViewController:activityVc animated:YES completion:nil];
        activityVc.completionWithItemsHandler = ^(UIActivityType _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
            if (completed) {
                DDLogDebug(@"分享成功");
            }else{
                DDLogDebug(@"分享取消");
            }
        };
        
}
#pragma mark ----HICCustomNaviViewDelegate
- (void)leftBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
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
