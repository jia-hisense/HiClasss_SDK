//
//  DCPagerController.m
//  CDDPagerController
//
//  Created by apple on 2017/9/5.
//  Copyright © 2017年 RocketsChen. All rights reserved.
//

#import "DCPagerController.h"

// Controllers

// Models

// Views
#import "DCPagerProgressView.h"
// Vendors

// Categories
#import "UIView+DCPagerFrame.h"
// Others
#import "DCPagerConsts.h"

@interface DCPagerController ()<UIScrollViewDelegate>
{
    UIColor *_norColor;
    UIColor *_selColor;
    UIColor *_titleScrollViewBgColor;
}
/** 标题背景色 */
@property (nonatomic, strong) UIColor *titleScrollViewBgColor;
/** 正常标题颜色 */
@property (nonatomic, strong) UIColor *norColor;
/** 选中标题颜色 */
@property (nonatomic, strong) UIColor *selColor;
/** 指示器颜色 */
@property (nonatomic, strong) UIColor *proColor;
/** 标题字体 */
@property (nonatomic, strong) UIFont *titleFont;
/** 字体缩放比例 */
@property (nonatomic, assign) CGFloat titleScale;
/** 指示器的长度 */
@property (nonatomic, assign) CGFloat progressLength;
/** 指示器的宽度 */
@property (nonatomic, assign) CGFloat progressHeight;

/* 是否显示底部指示器 */
@property (nonatomic, assign) BOOL isShowPregressView;
/* 是否加载弹簧动画 */
@property (nonatomic, assign) BOOL isOpenStretch;
/* 是否开启渐变 */
@property (nonatomic, assign) BOOL isOpenShade;

/* 标题滚动视图 */
@property (strong , nonatomic)UIScrollView *titleScrollView;
/* 内容滚动视图 */
@property (strong , nonatomic)UIScrollView *contentScrollView;
/** 滚动条 */
@property (nonatomic, strong) DCPagerProgressView *pregressView;

/* 标题按钮 */
@property (strong , nonatomic)UIButton *titleButton;
/* 上一次选择的按钮 */
@property (weak , nonatomic)UIButton *lastSelectButton;
/* 标题按钮数组 */
@property (strong , nonatomic)NSMutableArray *titleButtonArray;
/** 指示条的frames */
@property (nonatomic, strong) NSMutableArray *pregressFrames;

/** 是否加载过标题 */
@property (nonatomic,assign)BOOL isLoadTitles;

/**
 开始颜色,取值范围0~1
 */
@property (nonatomic, assign) CGFloat startR;

@property (nonatomic, assign) CGFloat startG;

@property (nonatomic, assign) CGFloat startB;

/**
 完成颜色,取值范围0~1
 */
@property (nonatomic, assign) CGFloat endR;

@property (nonatomic, assign) CGFloat endG;

@property (nonatomic, assign) CGFloat endB;

@end

@implementation DCPagerController

#pragma mark - LazyLoad
- (UIScrollView *)titleScrollView
{
    if (!_titleScrollView) {
        _titleScrollView = [UIScrollView new];
        _titleScrollView.showsHorizontalScrollIndicator = NO;
        _titleScrollView.backgroundColor = UIColor.whiteColor;
        [self.view addSubview:_titleScrollView];// 添加标题滚动View
    }
    return _titleScrollView;
}

- (UIScrollView *)contentScrollView
{
    if (!_contentScrollView) {
        _contentScrollView = [UIScrollView new];
        _contentScrollView.backgroundColor = [UIColor whiteColor];
        _contentScrollView.showsHorizontalScrollIndicator = NO;
        _contentScrollView.pagingEnabled = YES;
        _contentScrollView.bounces = NO; //弹簧效果关闭
        _contentScrollView.delegate = self;
        [self.view addSubview:_contentScrollView];// 添加标题滚动View
    }
    return _contentScrollView;
}

- (NSMutableArray *)titleButtonArray
{
    if (!_titleButtonArray) {
        _titleButtonArray = [NSMutableArray array];
    }
    return _titleButtonArray;
}

- (NSMutableArray *)pregressFrames
{
    if (!_pregressFrames) {
        _pregressFrames = [NSMutableArray array];
    }
    return _pregressFrames;
}


#pragma mark - setUpDisplayStyle
- (void)setUpDisplayStyle:(void(^)(UIColor **titleScrollViewBgColor,UIColor **norColor,UIColor **selColor,UIColor **proColor,UIFont **titleFont,BOOL *isShowPregressView,BOOL *isOpenStretch,BOOL *isOpenShade))BaseSettingBlock
{
    UIColor *titleScrollViewBgColor;
    UIColor *norColor;
    UIColor *selColor;
    UIColor *proColor;
    UIFont *titleFont;
    
    BOOL isShowPregressView;
    BOOL isOpenStretch;
    BOOL isOpenShade;

    
    if (BaseSettingBlock) { //属性
        BaseSettingBlock(&titleScrollViewBgColor,&norColor,&selColor,&proColor,&titleFont,&isShowPregressView,&isOpenStretch,&isOpenShade);
        
        self.titleScrollViewBgColor = titleScrollViewBgColor;
        self.norColor = norColor;
        self.selColor = selColor;
        self.proColor = proColor;
        self.titleFont = titleFont;
        
        self.isOpenShade = isOpenShade;
        self.isOpenStretch = isOpenStretch;
        self.isShowPregressView = isShowPregressView;
    }
    
}
#pragma mark - LifeCyle
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (_isLoadTitles == NO && _isAgainView == NO) {
        [self setUpAllTitle];
        _isLoadTitles = YES;
    };
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpBase];
}

#pragma mark - initialize
- (void)setUpBase
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;

    UIApplication *manager = UIApplication.sharedApplication;
    //设置标题和内容的尺寸
    CGFloat tY = ([self.navigationController isNavigationBarHidden] == YES) ? manager.statusBarFrame.size.height : DCNormalTitleViewH + manager.statusBarFrame.size.height;
    tY = self.navigationController == nil ? manager.statusBarFrame.size.height:tY;
    tY = _isCustomer ? DCNormalTitleViewH + manager.statusBarFrame.size.height : tY;
    tY = _isAlertView ? 44:tY;
    CGFloat tX = _isAddBackBut ? 42:0;
    self.titleScrollView.frame = CGRectMake(tX, tY, ScreenW-tX, DCNormalTitleViewH);
    self.contentScrollView.frame = CGRectMake(0, _titleScrollView.dc_bottom, ScreenW, ScreenH - _contentScrollView.dc_y);

}

-(void)createTitleViewAgain {
    [self setUpAllTitle];
}

#pragma mark - 设置标题
- (void)setUpAllTitle
{
    NSInteger VCCount = self.childViewControllers.count;
    if (VCCount <=0) {
        return;
    }
    CGFloat space = 24;
    CGFloat butWidth = 0;
    for (UIViewController *VC in self.childViewControllers) {
        CGSize size = [HICCommonUtils sizeOfString:VC.title stringWidthBounding:HIC_ScreenWidth font:_titleFont.pointSize stringOnBtn:YES fontIsRegular:NO];
        butWidth += (size.width + space);
    }
    DDLogDebug(@"当前按钮的总宽度%f", butWidth);

//    CGFloat customW = 80;
    CGFloat buttonW = _isMenuEqualWidth?((butWidth < _titleScrollView.dc_width) ? _titleScrollView.dc_width / VCCount: 0):0;
    CGFloat buttonH = _titleScrollView.dc_height;
    CGFloat buttonY = 0;
    CGFloat buttonX = 0;
    
    CGFloat progressH = (_progressHeight && _progressHeight < DCMargin && _progressHeight > 0) ?  _progressHeight : DCUnderLineH;
    
    for (NSInteger i = 0; i < VCCount; i++) {
        
        _titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIViewController *vc = self.childViewControllers[i]; //拿到对应子控制器
        [_titleButton setTitle:vc.title forState:UIControlStateNormal];
        [_titleButton setTitleColor:self.norColor forState:UIControlStateNormal];
        _titleButton.titleLabel.font = (!_titleFont) ? DCTitleNorFont : _titleFont;
        _titleButton.tag = i + DCButtonTagValue; //绑定tag(增加额外值)
        CGSize size = [HICCommonUtils sizeOfString:vc.title stringWidthBounding:HIC_ScreenWidth font:_titleFont.pointSize stringOnBtn:YES fontIsRegular:NO];
        if (buttonW > 0) {
            buttonX = i * buttonW;
        }

        _titleButton.frame = CGRectMake(buttonX, buttonY, buttonW != 0?buttonW:size.width+space, buttonH);
        _titleButton.backgroundColor = [UIColor clearColor];

        CGFloat pace = (_progressLength && _progressLength < _titleButton.width) ? (_titleButton.width - _progressLength) / 2 : _titleButton.width * 0.22;//进度条比button短多少
        CGFloat framex = buttonX + pace;
        CGFloat frameWidth = buttonW != 0? buttonW - 2 * pace : size.width+space-2*pace;
        CGFloat frameY = buttonH - (progressH );
        CGRect frame = CGRectMake(framex,frameY, frameWidth, progressH);
        [self.pregressFrames addObject:[NSValue valueWithCGRect:frame]];

        if (buttonW == 0) {
            buttonX += (size.width + space);
        }

        [_titleScrollView addSubview:_titleButton];
        [_titleButton addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.titleButtonArray addObject:_titleButton];

        if (i == 0) { //默认第0个
            [self titleButtonClick:_titleButton];
        }
    }
    
    if (_isShowPregressView) {
        //指示条
        _pregressView = [[DCPagerProgressView alloc] initWithFrame:CGRectMake(0, buttonH - (progressH), buttonW!=0? VCCount * buttonW:butWidth, progressH)];
        _pregressView.itemFrames = self.pregressFrames;
        _pregressView.color = self.proColor.CGColor;
        _pregressView.backgroundColor = [UIColor clearColor];
        [_titleScrollView addSubview:_pregressView];
    }

    
    //设置标题是否可以滚动
    _titleScrollView.contentSize = CGSizeMake(buttonW==0?butWidth:VCCount*buttonW, 0);
    //设置滚动范围
    _contentScrollView.contentSize = CGSizeMake(VCCount * _contentScrollView.dc_width, 0);
}


#pragma mark - 选中标题
- (void)selectButton:(UIButton *)button
{
    _lastSelectButton.transform = CGAffineTransformIdentity; //还原
    [_lastSelectButton setTitleColor:self.norColor forState:UIControlStateNormal];
    
    [button setTitleColor:self.selColor forState:UIControlStateNormal];

    //字体缩放
    if (_titleScale > 0 && _titleScale < 1) {
        button.transform = CGAffineTransformMakeScale(1 + _titleScale, 1 + _titleScale);
        
    }
    _lastSelectButton = button;
    
    //标题居中
    CGFloat offsetX = button.center.x - _titleScrollView.dc_width * 0.5;
    if (offsetX < 0) { //最小
        offsetX = 0;
    }
    CGFloat offsetMax = _titleScrollView.contentSize.width - _titleScrollView.dc_width;
    if (offsetX > offsetMax) { //最大
        offsetX = offsetMax;
    }
    if (offsetX <0) {
        offsetX = 0;
    }
    [_titleScrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    
    _pregressView.isStretch = NO;
    _selectIndex = button.tag - DCButtonTagValue;
    [self changeView];
}

-(void)changeView {
    // 父类的方法，需要子类具体实现
}

#pragma mark - 底部滚动条滚动
- (void)bottomBarNaughtyWithOffset:(CGFloat)offsetx
{
    if (offsetx < 0) //最小
    {
        offsetx = 0;
    }
    _pregressView.progress = offsetx / _titleScrollView.dc_width;
}

//添加控制器View
- (void)AddOneVcWithButtton:(NSInteger)i
{
    UIViewController *vc = self.childViewControllers[i];
    if (vc.view.superview)return;
    vc.view.frame = CGRectMake(i * _contentScrollView.dc_width, 0,_contentScrollView.dc_width , _contentScrollView.dc_height);
    [_contentScrollView addSubview:vc.view];
}


#pragma mark - 标题点击
- (void)titleButtonClick:(UIButton *)button
{
    _pregressView.isStretch = NO;
    
    NSInteger buttonTag = button.tag - DCButtonTagValue;
    
    //选中标题
    [self selectButton:button];
    
    //添加控制器View
    [self AddOneVcWithButtton:buttonTag];
    
    //滚动到相应的位置
    _contentScrollView.contentOffset = CGPointMake(buttonTag * _contentScrollView.dc_width, 0);
}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    NSInteger tagI = scrollView.contentOffset.x / _contentScrollView.dc_width;
    UIButton *button = self.titleButtonArray[tagI];
    DDLogDebug(@"刷新滚动 ---- %ld", (long)tagI);
    [self selectButton:button];
    
    [self AddOneVcWithButtton:tagI];
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //是否有拉伸
    _pregressView.isStretch = _isOpenStretch;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    [self bottomBarNaughtyWithOffset:scrollView.contentOffset.x];
/*
    NSInteger tagI = scrollView.contentOffset.x / _contentScrollView.dc_width;
    
    NSInteger leftI = tagI;
    NSInteger rightI = tagI + 1;
    
    //缩放
    if (self.titleButtonArray.count != 0 && self.titleButtonArray.count-1 >= leftI) {
        UIButton *leftButton = self.titleButtonArray[leftI];

        UIButton *rightButton;
        if (rightI < self.titleButtonArray.count){
           rightButton = self.titleButtonArray[rightI];
        }

        CGFloat scaleR = scrollView.contentOffset.x / _contentScrollView.dc_width;
        scaleR -= leftI;

        CGFloat scaleL = 1 - scaleR;

        if (_titleScale > 0 && _titleScale < 1) { //缩放尺寸限定
            leftButton.transform = CGAffineTransformMakeScale(scaleL * _titleScale + 1, scaleL * _titleScale + 1);
            rightButton.transform = CGAffineTransformMakeScale(scaleR * _titleScale + 1, scaleR * _titleScale + 1);
        }

        if (_isOpenShade) {//开启渐变
            //颜色渐变
            CGFloat r = _endR - _startR;
            CGFloat g = _endG - _startG;
            CGFloat b = _endB - _startB;

            UIColor *rightColor = [UIColor colorWithRed:_startR + r * scaleR green:_startG + g * scaleR blue:_startB + b * scaleR alpha:1];

            UIColor *leftColor = [UIColor colorWithRed:_startR +  r * scaleL  green:_startG +  g * scaleL  blue:_startB +  b * scaleL alpha:1];

            [rightButton setTitleColor:rightColor forState:UIControlStateNormal];
            [leftButton setTitleColor:leftColor forState:UIControlStateNormal];
        }
    }*/

}

#pragma mark - 标题点击处理
- (void)setSelectIndex:(NSInteger)selectIndex
{
    _selectIndex = selectIndex;
    
    if (self.titleButtonArray.count) {
        if (_selectIndex < self.titleButtonArray.count) {
            UIButton *button = self.titleButtonArray[selectIndex];
            [self titleButtonClick:button];
        }
    }
}


#pragma mark - 标题缩放处理
- (void)setUpTitleScale:(void(^)(CGFloat *titleScale))titleScaleBlock
{
    !titleScaleBlock ? : titleScaleBlock(&_titleScale);//titleScaleBlock回调
}

#pragma mark - Progress属性设置
- (void)setUpProgressAttribute:(void (^)(CGFloat *progressLength, CGFloat *progressHeight))settingProgressBlock
{
    if (_isShowPregressView == NO) return;   //如果影藏Progress指示器则返回
    !settingProgressBlock ? : settingProgressBlock(&_progressLength,&_progressHeight);   //指示器属性设置Block
}

#pragma mark - 清空标题栏和内容栏的数据以方便重新添加
-(void)clearnTitleViewAndContentView {
    for (UIView *view in self.titleScrollView.subviews) {
        [view removeFromSuperview];
    }
    for (UIView *view in self.contentScrollView.subviews) {
        [view removeFromSuperview];
    }
    for (UIViewController *vc in self.childViewControllers) {
        [vc removeFromParentViewController];
    }
    [self.titleButtonArray removeAllObjects];
    self.titleScrollView.contentOffset = CGPointMake(0, 0);
    self.contentScrollView.contentOffset = CGPointMake(0, 0);
    self.titleScrollView.contentSize = CGSizeZero;
    self.contentScrollView.contentSize = CGSizeZero;
}


#pragma mark - get
- (UIColor *)norColor
{
    if (!_norColor) self.norColor = [UIColor blackColor];
    
    return _norColor;
}

- (UIColor *)selColor
{
    if (!_selColor) self.selColor = [UIColor redColor];
    return _selColor;
}

- (UIColor *)proColor
{
    if (!_proColor) self.proColor = self.selColor;
    return _proColor;
}


- (UIColor *)titleScrollViewBgColor
{
    if (!_titleScrollViewBgColor) self.titleScrollViewBgColor = [UIColor whiteColor];
    
    return _titleScrollViewBgColor;
}




#pragma mark - set
- (void)setNorColor:(UIColor *)norColor
{
    _norColor = norColor;
    [self setupStartColor:norColor];
    
}
- (void)setSelColor:(UIColor *)selColor
{
    _selColor = selColor;
    [self setupEndColor:selColor];
}

- (void)setTitleScrollViewBgColor:(UIColor *)titleScrollViewBgColor
{
    _titleScrollViewBgColor = titleScrollViewBgColor;
    
    self.titleScrollView.backgroundColor = titleScrollViewBgColor;
}


- (void)setupStartColor:(UIColor *)color
{
    CGFloat components[3];
    
    [self getRGBComponents:components forColor:color];
    
    _startR = components[0];
    _startG = components[1];
    _startB = components[2];
}

- (void)setupEndColor:(UIColor *)color
{
    CGFloat components[3];
    
    [self getRGBComponents:components forColor:color];
    
    _endR = components[0];
    _endG = components[1];
    _endB = components[2];
}


/**
 *  指定颜色，获取颜色的RGB值
 *
 *  @param components RGB数组
 *  @param color      颜色
 */
- (void)getRGBComponents:(CGFloat [3])components forColor:(UIColor *)color {
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char resultingPixel[4];
    CGContextRef context = CGBitmapContextCreate(&resultingPixel,1,1,8,4,rgbColorSpace,1);
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, 1, 1));
    CGContextRelease(context);
    CGColorSpaceRelease(rgbColorSpace);
    for (int component = 0; component < 3; component++) {
        components[component] = resultingPixel[component] / 255.0f;
    }
}

@end
