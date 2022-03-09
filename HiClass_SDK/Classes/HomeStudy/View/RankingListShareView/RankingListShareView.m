//
//  RankingListShareView.m
//  iTest
//
//  Created by Sir_Jing on 2020/3/12.
//  Copyright © 2020 Sir_Jing. All rights reserved.
//

#import "RankingListShareView.h"

@interface RankingListShareView ()<UITextViewDelegate>
// 分享弹框
@property (nonatomic, strong) UITextView *inputTextView;
@property (nonatomic, strong) UILabel *myNameLabel;
@property (nonatomic, strong) UILabel *myCompanyLabel;
@property (nonatomic, strong) UIImageView *myImageView;
@property (nonatomic, strong) UILabel *mySoreLabel;
@property (nonatomic, strong) UILabel *myRankLabel;

/// 弹出框的背景图
@property (nonatomic, strong) UIView *alertView;

@property (nonatomic, strong) NSArray *iconImages;

@property (nonatomic, strong) NSString *strTime;
@property (nonatomic, strong) NSString *strType;;
@end

@implementation RankingListShareView

-(instancetype)initWithDefault {
    CGFloat screenWidth = UIScreen.mainScreen.bounds.size.width;
    CGFloat screenHeight = UIScreen.mainScreen.bounds.size.height;
    if (self = [super initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)]) {
//        [self createView];
//        [self createShareView];
        //注册观察键盘的变化
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(transformView:) name:UIKeyboardWillChangeFrameNotification object:nil];
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        _iconImages = @[[UIImage imageNamed:@"第一名"], [UIImage imageNamed:@"第二名"], [UIImage imageNamed:@"第三名"]];
    }
    return self;
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/// 创建弹出式的分享视图
-(void)createView {
    CGFloat alertWidth = 320;
    CGFloat alertHeight = 464.5;
    CGFloat left = (self.frame.size.width-alertWidth)/2.0;
    CGFloat top = (self.frame.size.height-alertHeight)/2.0;
    UIView *alertView = [[UIView alloc] initWithFrame:CGRectMake(left, top, alertWidth, alertHeight)];
    alertView.layer.cornerRadius = 12;
    alertView.layer.masksToBounds = YES;
    alertView.backgroundColor = UIColor.whiteColor;
    self.alertView = alertView;

    UIButton *alertBackBut = [[UIButton alloc] initWithFrame:alertView.bounds];
    [alertView addSubview:alertBackBut];

    [self addSubview:alertView];

    // 内部的页面
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(88, 20, 144, 25)];
    
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];

    UIButton *closeBut = [[UIButton alloc] initWithFrame:CGRectMake(alertWidth-12-20, 12, 20, 20)];
    [closeBut setImage:[UIImage imageNamed:@"关闭弹窗"] forState:UIControlStateNormal];
    [closeBut addTarget:self action:@selector(clickCloseBut:) forControlEvents:UIControlEventTouchUpInside];

    CGFloat contenTop = 65;
    CGFloat contenLeft = 20;
    CGFloat contenWidth = 280;
    CGFloat contenHeight = 250;
    UIView *contentBackView = [[UIView alloc] initWithFrame:CGRectMake(contenLeft, contenTop, contenWidth, contenHeight)];
    contentBackView.backgroundColor = [UIColor colorWithRed:3/255.0 green:179/255.0 blue:204/255.0 alpha:1];
    contentBackView.layer.cornerRadius = 5.f;
    contentBackView.layer.masksToBounds = YES;
    // 增加内部视图
    UIImageView *sharContImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[HICCommonUtils appBundleIden] == HICAppBundleIdenZhiYu ? @"shared_ranklist_zhiyu" : @"排名-分享配图"]];

    sharContImageView.frame = CGRectMake(0, 0, contenWidth, 104.5);
    [contentBackView addSubview:sharContImageView];

    UIView *myBackView = [[UIView alloc] initWithFrame:CGRectMake(5, contenHeight-180, contenWidth-10, 190)];
    myBackView.backgroundColor = [UIColor whiteColor];
    myBackView.layer.cornerRadius = 10.f;
    myBackView.layer.masksToBounds = YES;
    [contentBackView addSubview:myBackView];

    // 我的内容展示
    UIImageView *myImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 50, 30, 30)];
    myImageView.layer.cornerRadius = 3.f;
    myImageView.layer.masksToBounds = YES;
    myImageView.backgroundColor = [UIColor grayColor];
    self.myImageView = myImageView;

    UILabel *myNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 52, 220, 13)];
    myNameLabel.text = @"";
    myNameLabel.font = [UIFont systemFontOfSize:13];
    self.myNameLabel = myNameLabel;
    UILabel *myCompanyLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 67, 220, 13)];
    myCompanyLabel.text = @"";
    myCompanyLabel.textColor = [UIColor colorWithRed:133/255.0 green:133/255.0 blue:133/255.0 alpha:1];
    myCompanyLabel.font = [UIFont systemFontOfSize:10];
    self.myCompanyLabel = myCompanyLabel;

    // 本周得分View
    UIView *myScoreView = [[UIView alloc] initWithFrame:CGRectMake(10, 90, 122.5, 80)];
    [self addColorsWith:myScoreView colors:@[(__bridge id)[UIColor colorWithRed:0.0 green:197/255.0 blue:224/255.0 alpha:1].CGColor,
                                             (__bridge id)[UIColor colorWithRed:0.0 green:226/255.0 blue:216/255.0 alpha:1].CGColor]];
    myScoreView.layer.cornerRadius = 3.f;
    myScoreView.layer.masksToBounds = YES;
    UILabel *myScoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 102.5, 15)];
    myScoreLabel.textColor = UIColor.whiteColor;
    myScoreLabel.font = [UIFont systemFontOfSize:15];
    UILabel *myScoreNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 35, 102.5, 25)];
    myScoreNumLabel.textColor = UIColor.whiteColor;
    myScoreNumLabel.font = [UIFont systemFontOfSize:21];
    myScoreNumLabel.text = @"";
    self.mySoreLabel = myScoreNumLabel;
    [myScoreView addSubview:myScoreLabel];
    [myScoreView addSubview:myScoreNumLabel];

    // 排名
    UIView *myRankView = [[UIView alloc] initWithFrame:CGRectMake(137.5, 90, 122.5, 80)];
    [self addColorsWith:myRankView colors:@[(__bridge id)[UIColor colorWithRed:0.0 green:197/255.0 blue:224/255.0 alpha:1].CGColor,
                                            (__bridge id)[UIColor colorWithRed:0.0 green:226/255.0 blue:216/255.0 alpha:1].CGColor]];
    myRankView.layer.cornerRadius = 3.f;
    myRankView.layer.masksToBounds = YES;
    UILabel *myRankLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 102.5, 15)];
    myRankLabel.textColor = UIColor.whiteColor;
    myRankLabel.font = [UIFont systemFontOfSize:15];
    UILabel *myRankNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 35, 102.5, 25)];
    myRankNumLabel.textColor = UIColor.whiteColor;
    myRankNumLabel.font = [UIFont systemFontOfSize:21];
    myRankNumLabel.text = @"";
    self.myRankLabel = myRankNumLabel;
    [myRankView addSubview:myRankLabel];
    [myRankView addSubview:myRankNumLabel];

    [myBackView addSubview:myScoreView];
    [myBackView addSubview:myRankView];
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, contenWidth, 40)];
    textView.text = NSLocalizableString(@"encourageLanguage", nil);
    textView.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    textView.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
    textView.delegate = self;
    self.inputTextView = textView;
    [myBackView addSubview:self.inputTextView];
    [myBackView addSubview:myImageView];
    [myBackView addSubview:myNameLabel];
    [myBackView addSubview:myCompanyLabel];



    UIButton *sharBut = [[UIButton alloc] initWithFrame:CGRectMake(20, 396, contenWidth, 48)];
    [sharBut setTitle:NSLocalizableString(@"clickShare", nil) forState:UIControlStateNormal];
    // 渐变色
    [self addColorsWith:sharBut colors:@[(__bridge id)[UIColor colorWithRed:0.0 green:226/255.0 blue:216/255.0 alpha:1].CGColor,
                                         (__bridge id)[UIColor colorWithRed:0.0 green:197/255.0 blue:224/255.0 alpha:1].CGColor]];
    [sharBut addTarget:self action:@selector(clickSharBut:) forControlEvents:UIControlEventTouchUpInside];

    [alertView addSubview:titleLabel];
    [alertView addSubview:closeBut];
    [alertView addSubview:contentBackView];
//    [alertView addSubview:textView];
    [alertView addSubview:sharBut];
    
    
    if (self.rankIndex == 0) {
        self.strTime = NSLocalizableString(@"thisWeek", nil);
    }else if (self.rankIndex == 1) {
        self.strTime = NSLocalizableString(@"thisMonth", nil);
    }else if (self.rankIndex == 2) {
        self.strTime = NSLocalizableString(@"thisYear", nil);
    }
    if (self.rankType == 3) {
        self.strType = NSLocalizableString(@"credits", nil);
    }else if (self.rankType == 4) {
        self.strType = NSLocalizableString(@"integral", nil);
    }else if (self.rankType == 5) {
        self.strType = NSLocalizableString(@"studyTime", nil);
    }
    titleLabel.text = [NSString stringWithFormat:@"%@%@%@",NSLocalizableString(@"baskInTheSun", nil),self.strType,NSLocalizableString(@"list", nil)];;
    myScoreLabel.text = [NSString stringWithFormat:@"%@%@",self.strTime,self.strType];
    myRankLabel.text = [NSString stringWithFormat:@"%@%@%@",self.strTime,self.strType,NSLocalizableString(@"ranking", nil)];
    
}

-(void)showShare {
    UIWindow *keyWindow = UIApplication.sharedApplication.keyWindow;
    [keyWindow addSubview:self];

}

-(void)hiddenShare {
    [self removeFromSuperview];
}


/// 创建分享视图 -- 最后会将视图转化成Image
-(void)createShareView {

    HICMyRankInfoModel *model = [HICMyRankInfoModel mj_objectWithKeyValues: self.rankInfoModels.firstObject];

    UIView *shareViewBack = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 375, 667)];
    shareViewBack.backgroundColor = [UIColor colorWithRed:3/255.0 green:179/255.0 blue:204/255.0 alpha:1];

    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 375, 140)];
    backImageView.image = [UIImage imageNamed:[HICCommonUtils appBundleIden] == HICAppBundleIdenZhiYu ? @"shared_ranklist_zhiyu" : @"排名-分享配图"];


    UIView *contentBackView = [[UIView alloc] initWithFrame:CGRectMake(12, 147, 351, 512.5)];
    contentBackView.backgroundColor = [UIColor whiteColor];
    contentBackView.layer.cornerRadius = 8;
    contentBackView.layer.masksToBounds = YES;

    // 增加分享的内容
    UILabel *contentTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 22, 311, 50)];
    contentTitleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:17];
    contentTitleLabel.numberOfLines = 0;
    contentTitleLabel.text = self.inputTextView.text;

    UIImageView *contentMyImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 94, 50, 50)];
    contentMyImageView.layer.cornerRadius = 4;
    contentMyImageView.layer.masksToBounds = YES;
    contentMyImageView.backgroundColor = UIColor.redColor;
    if ([NSString isValidStr:model.pic]) {
        [contentMyImageView sd_setImageWithURL:[NSURL URLWithString:model.pic]];
    }else {
        UILabel *headerLabel = [HICCommonUtils setHeaderFrame:contentMyImageView.bounds andText:model.name];
        headerLabel.hidden = NO;
        [contentMyImageView addSubview:headerLabel];
    }

    UILabel *contentMyName = [[UILabel alloc] initWithFrame:CGRectMake(80, 96.5, 351-90, 22.5)];
    contentMyName.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    contentMyName.text = model.name;

    UILabel *contentMyCompany = [[UILabel alloc] initWithFrame:CGRectMake(80, 122, 351-90, 20)];
    contentMyCompany.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    contentMyCompany.textColor = [UIColor colorWithRed:133/255.0 green:133/255.0 blue:133/255.0 alpha:1];
    contentMyCompany.text = model.dept;

    UIView *scoreBackView = [[UIView alloc] initWithFrame:CGRectMake(20, 160, 150, 86)];
    [self addColorsWith:scoreBackView colors:@[(__bridge id)[UIColor colorWithRed:0.0 green:197/255.0 blue:224/255.0 alpha:1].CGColor,
                                               (__bridge id)[UIColor colorWithRed:0.0 green:226/255.0 blue:216/255.0 alpha:1].CGColor]];
    scoreBackView.layer.cornerRadius = 4;
    scoreBackView.layer.masksToBounds = YES;
    UILabel *myScoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 11, 102.5, 20)];
    myScoreLabel.textColor = UIColor.whiteColor;
    myScoreLabel.font = [UIFont systemFontOfSize:14];
    UILabel *myScoreNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 35, 118, 42)];
    myScoreNumLabel.textColor = UIColor.whiteColor;
    myScoreNumLabel.font = [UIFont systemFontOfSize:30];
    myScoreNumLabel.text = [model.score isEqualToString:@"-1"]?@"-":model.score;
    [scoreBackView addSubview:myScoreLabel];
    [scoreBackView addSubview:myScoreNumLabel];

    UIView *rankBackView = [[UIView alloc] initWithFrame:CGRectMake(181, 160, 150, 86)];
    [self addColorsWith:rankBackView colors:@[(__bridge id)[UIColor colorWithRed:0.0 green:197/255.0 blue:224/255.0 alpha:1].CGColor,
                                               (__bridge id)[UIColor colorWithRed:0.0 green:226/255.0 blue:216/255.0 alpha:1].CGColor]];
    rankBackView.layer.cornerRadius = 4;
    rankBackView.layer.masksToBounds = YES;
    UILabel *myRankLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 11, 102.5, 20)];
    myRankLabel.textColor = UIColor.whiteColor;
    myRankLabel.font = [UIFont systemFontOfSize:14];
    UILabel *myRankNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 35, 118, 42)];
    myRankNumLabel.textColor = UIColor.whiteColor;
    myRankNumLabel.font = [UIFont systemFontOfSize:30];
    myRankNumLabel.text = model.orderNum == -1? @"-": [NSString stringWithFormat:@"%ld", (long)model.orderNum];
    [rankBackView addSubview:myRankLabel];
    [rankBackView addSubview:myRankNumLabel];
    

    myScoreLabel.text = [NSString stringWithFormat:@"%@%@",self.strTime,self.strType];
    myRankLabel.text = [NSString stringWithFormat:@"%@%@%@",self.strTime,self.strType,NSLocalizableString(@"ranking", nil)];

    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(20, 268, 311, 0.5)];
    lineView.backgroundColor = [UIColor colorWithRed:133/255.0 green:133/255.0 blue:133/255.0 alpha:1];
    NSMutableArray *array = [NSMutableArray array];
    NSInteger index = 0;
    for (NSDictionary *dic in self.rankInfoModels) {
        if (index == 1 || index == 2 || index == 3) {
            HICMyRankInfoModel *model = [HICMyRankInfoModel mj_objectWithKeyValues:dic];
            [array addObject:model];
        }else if (index == 0) {
            // 第一个过滤
        }else {
            break;
        }
        index++;
    }
    for (NSInteger i = 0; i < array.count; i ++) {
        HICMyRankInfoModel *model = [array objectAtIndex:i];
        UIView *list = [self createListItemView:CGRectMake(0, 268.5 + 74*i, 351, 74) andModel:model index:i];
        [contentBackView addSubview:list];
    }

    [contentBackView addSubview:contentTitleLabel];
    [contentBackView addSubview:contentMyImageView];
    [contentBackView addSubview:contentMyCompany];
    [contentBackView addSubview:contentMyName];
    [contentBackView addSubview:scoreBackView];
    [contentBackView addSubview:rankBackView];
    [contentBackView addSubview:lineView];

    [shareViewBack addSubview:backImageView];
    [shareViewBack addSubview:contentBackView];

//    [self addSubview:shareViewBack];

    UIImage *image = [self makeImageWithView:shareViewBack];
    // TODO: 测试图片生成问题 --- 需要在分享时处理掉
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 300)];
//    imageView.image = image;
//    [self addSubview:imageView];
    // FIXME: 分享
    if ([self.delegate respondsToSelector:@selector(clickShareView:shareImage:)]) {
        [self.delegate clickShareView:self shareImage:image];
    }
    [self hiddenShare];
}

-(UIView *)createListItemView:(CGRect)frame andModel:(HICMyRankInfoModel *)model index:(NSInteger)index{
    UIView *view = [[UIView alloc] initWithFrame:frame];

    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(19.5, 36, 22, 22)];
    iconImageView.image = [_iconImages objectAtIndex:index%3];

    UIImageView *myImageView = [[UIImageView alloc] initWithFrame:CGRectMake(51, 22, 50, 50)];
    myImageView.layer.cornerRadius = 4;
    myImageView.layer.masksToBounds = YES;
    myImageView.backgroundColor = UIColor.redColor;
    if ([NSString isValidStr:model.pic]) {
        [myImageView sd_setImageWithURL:[NSURL URLWithString:model.pic]];
    }else {
        UILabel *headerLabel = [HICCommonUtils setHeaderFrame:myImageView.bounds andText:model.name];
        headerLabel.hidden = NO;
        [myImageView addSubview:headerLabel];
    }

    UILabel *myName = [[UILabel alloc] initWithFrame:CGRectMake(111, 24.5, 351-111-75, 22.5)];
    myName.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    myName.text = model.name;

    UILabel *myCompany = [[UILabel alloc] initWithFrame:CGRectMake(111, 50, 351-111-75, 20)];
    myCompany.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    myCompany.textColor = [UIColor colorWithRed:133/255.0 green:133/255.0 blue:133/255.0 alpha:1];
    myCompany.text = model.dept;

    UILabel *scroLabel = [[UILabel alloc] initWithFrame:CGRectMake(351-20-53, 36.5, 53, 21)];
    scroLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
    scroLabel.text = [model.score isEqualToString:@"-1"]?@"-":model.score;

    [view addSubview:iconImageView];
    [view addSubview:myImageView];
    [view addSubview:myName];
    [view addSubview:myCompany];
    [view addSubview:scroLabel];

    return view;
}

#pragma mark - 点击事件处理
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [self hiddenShare];
    [self endEditing:YES];
}

-(void)addColorsWith:(UIView *)view colors:(NSArray *)colors  {

    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = view.bounds;
    [view.layer insertSublayer:gradientLayer atIndex:0];
    gradientLayer.startPoint = CGPointMake(0, 1);
    gradientLayer.endPoint = CGPointMake(1, 1);
    gradientLayer.colors = colors;
    gradientLayer.locations = @[@(0.0f), @(1.0f)];
}

-(void)clickCloseBut:(UIButton *)but {
    [self hiddenShare];
}

-(void)clickSharBut:(UIButton *)btn {
    [self.inputTextView resignFirstResponder];
    [self createShareView];
}

#pragma mark - 页面事件处理
-(UIImage *)makeImageWithView:(UIView *)view{
    CGSize s = view.bounds.size;
    UIGraphicsBeginImageContextWithOptions(s, NO, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

//移动UIView
-(void)transformView:(NSNotification *)aNSNotification
{
    //获取键盘弹出前的Rect
    NSValue *keyBoardBeginBounds=[[aNSNotification userInfo]objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect beginRect=[keyBoardBeginBounds CGRectValue];

    //获取键盘弹出后的Rect
    NSValue *keyBoardEndBounds=[[aNSNotification userInfo]objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect  endRect=[keyBoardEndBounds CGRectValue];

    //获取键盘位置变化前后纵坐标Y的变化值
    CGFloat deltaY=endRect.origin.y-beginRect.origin.y;

    //在0.25s内完成self.view的Frame的变化，等于是给self.view添加一个向上移动deltaY的动画
    [UIView animateWithDuration:0.25f animations:^{
        [self.alertView setFrame:CGRectMake(self.alertView.frame.origin.x, self.alertView.frame.origin.y+deltaY, self.alertView.frame.size.width, self.alertView.frame.size.height)];
    }];
}

// 页面赋值
-(void)setRankInfoModels:(NSArray *)rankInfoModels {

    _rankInfoModels = rankInfoModels;
    // 第一个是自己的数据
    if (rankInfoModels.count > 0) {
        HICMyRankInfoModel *model = [HICMyRankInfoModel mj_objectWithKeyValues:rankInfoModels.firstObject];
        self.myNameLabel.text = model.name;
        self.myCompanyLabel.text = model.dept;
        self.mySoreLabel.text = [model.score isEqualToString:@"-1"]?@"-":model.score;
        self.myRankLabel.text = model.orderNum == -1?@"-":[NSString stringWithFormat:@"%ld", (long)model.orderNum];
        if ([NSString isValidStr:model.pic]) {
            [self.myImageView sd_setImageWithURL:[NSURL URLWithString:model.pic]];
        }else {
            UILabel *headerLabel = [HICCommonUtils setHeaderFrame:self.myImageView.bounds andText:model.name];
            headerLabel.hidden = NO;
            [self.myImageView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [self.myImageView addSubview:headerLabel];
        }
    }
}

@end
