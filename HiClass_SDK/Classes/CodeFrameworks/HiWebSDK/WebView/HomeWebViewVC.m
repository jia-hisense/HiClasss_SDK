//
//  HomeWebViewVC.m
//  HiClass
//
//  Created by wangggang on 2020/1/13.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HomeWebViewVC.h"

#import <WebKit/WebKit.h>

#import "HomeWebViewScriptMsgDelegate.h"
#import "HomeWebLoadingView.h"
#import "HICMyCertificateDetailVC.h"
#import "HICCertificatesVC.h"
#define websdk_version   @"4"
@interface HomeWebViewVC ()<WKScriptMessageHandler, WKUIDelegate, WKNavigationDelegate, HICCustomNaviViewDelegate>

/// 加载网络信息地址
@property (nonatomic, strong) WKWebView *webView;

/// 信息配置
@property (nonatomic, strong) WKWebViewConfiguration *webConfig;

/// 加载图
@property (nonatomic, strong) HomeWebLoadingView *loadingView;
/// 进度条
@property (nonatomic, strong) UIProgressView *progressView;

@end

@implementation HomeWebViewVC

-(instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    // 1. 创建webView用于承载网页
    [self createWebView];

    // 2. 设置webView的背景色
    self.view.backgroundColor = UIColor.whiteColor; // 默认为白色背景

    for (NSString *name in self.webViewModel.userConfigNames) {
        if ([self.webConfig.userContentController userScripts].count == 0) {
            [self.webConfig.userContentController addScriptMessageHandler:[[HomeWebViewScriptMsgDelegate alloc]initWithDelegate:self] name:name];
        }

    }
    // 3. 添加监听的方法
    [self createNotifaction];
    DDLogDebug(@"WebView url=%@", self.urlStr);

    // 4. 增加防作弊的方法
    __weak typeof(self) weakSelf = self;
    [HiWebViewPerson sharePerson].backgroundBlock = ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf sendMsgToH5WithString:@"" funName:@"switchApp"];
    };
    // 5. 增加考试定时器暂停和启动
    [HiWebViewPerson sharePerson].timeBackgroundBlock = ^(BOOL isBackGround) {
        NSString *isBack = isBackGround? @"0":@"1";
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf sendMsgToH5WithString:isBack funName:@"webViewPageShow"];
    };
}

// 页面将要显示
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    // 1. 去掉系统的导航栏
    [self.navigationController setNavigationBarHidden:YES];
    
    self.tabBarController.tabBar.hidden = YES;

    //    [self.loadingView showLoadingView];
    if (self.progressView.progress != 1) {
        [self showProgressLoadingView];
    }
    if (self.isThirdUrl) {
        [self createCustomerNavView];
    }
}

-(void)dealloc {
    DDLogDebug(@"[WebSDK] -- 调用析构函数");
    [self.webConfig.userContentController removeAllUserScripts];
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    self.webView.scrollView.bounces = NO;
    [HiWebViewPerson sharePerson].backgroundBlock = nil;
    [HiWebViewPerson sharePerson].timeBackgroundBlock = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - 创建view
-(void)createWebView {

    CGFloat top = _hideNavi ? UIApplication.sharedApplication.statusBarFrame.size.height : HIC_NavBarAndStatusBarHeight;
    CGFloat marginBtm = _hideBtmTab ? 0 : 52 + HIC_BottomHeight;
    CGFloat screenWidth = UIScreen.mainScreen.bounds.size.width;
    CGFloat screenHeight = UIScreen.mainScreen.bounds.size.height;

    // 1. 添加一个完整覆盖view的组件
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, top, screenWidth, screenHeight-top)];
    backView.backgroundColor = [UIColor whiteColor];

    [self.view addSubview:backView];

    // 2. 如果没有web的模型则 创建一个, 并且使用默认的交互参数
    if (!self.webViewModel) {
        self.webViewModel = [[HomeWebViewModel alloc] init];
        [self.webViewModel setDefaultConfigNames];
    }

    // 2. 创建webView 偏好设置
    self.webConfig = [[WKWebViewConfiguration alloc] init];
    self.webConfig.allowsInlineMediaPlayback = YES;

    // 偏好设置
    self.webConfig.preferences = WKPreferences.new;
    self.webConfig.preferences.minimumFontSize = 10;
    self.webConfig.preferences.javaScriptEnabled = YES;
    self.webConfig.preferences.javaScriptCanOpenWindowsAutomatically = NO;

    // js交互配置
    self.webConfig.userContentController = WKUserContentController.new;

    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, top, screenWidth, top>20?screenHeight-34-top - marginBtm:screenHeight-top-marginBtm) configuration:self.webConfig];
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;

    [self.view addSubview:self.webView]; // 添加到控制器中

    // 加载url地址
    if (!self.urlStr) {
        self.urlStr = @"https://www.baidu.com";
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]];
    [self.webView loadRequest:request];

    self.loadingView = [HomeWebLoadingView createLoadingViewWith:self.webView.bounds onView:self.webView];
    
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    ExamManager.webviewVC = self.webView;
}

// -- 进度条的显示和隐藏
-(void)showProgressLoadingView {
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat top = UIApplication.sharedApplication.statusBarFrame.size.height;
    self.progressView.frame = CGRectMake(0, top, screenWidth, 2);
    self.progressView.hidden = NO;
}

-(void)hidenProgressLoadingView {
    self.progressView.hidden = YES;
}

-(void)createCustomerNavView {
    CGFloat top = HIC_StatusBar_Height;
    CGFloat navHeight = 44;
    self.webView.frame = CGRectMake(0, top+navHeight, HIC_ScreenWidth, HIC_ScreenHeight-(top+navHeight)-HIC_BottomHeight);
    HICCustomNaviView *view = [[HICCustomNaviView alloc] initWithTitle:@"" rightBtnName:nil showBtnLine:NO];
    [self.view addSubview:view];
    view.delegate = self;
}
-(void)leftBtnClicked {
    [self closeWebView];
}

#pragma mark - 注册通知消息
-(void)createNotifaction {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHidden:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - 键盘的监听方法
-(void)keyboardHidden:(NSNotification *)notification {

    //获取键盘的高度
    NSDictionary *userInfo = [notification userInfo];
    NSString *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    CGFloat dura = 1.0;
    if (duration) {
        dura = duration.floatValue;
    }
    [UIView animateWithDuration:dura animations:^{
        [self.webView.scrollView setContentOffset:CGPointMake(0, 0)];
    }];
}


#pragma mark - 页面逻辑事件处理
-(void)closeWebView {
    if (_isPush) {
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        [self dismissViewControllerAnimated:YES completion:^{

        }];
    }
}

#pragma mark - 网页的交互协议
-(void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {

    // 1.交互协议
    NSString *name = message.name; // 获取交互的名称
    NSMutableDictionary *messageDic = [NSMutableDictionary dictionary];
    id body = message.body;
    if ([body isKindOfClass:NSDictionary.class]) {
        [messageDic setDictionary:(NSDictionary *)body];
    }else if ([body isKindOfClass:NSString.class]) {
        [messageDic setValue:body forKey:name];
    }

    if ([name isEqualToString:@"uploadImg"]) {
        // 打开图片或者相机的接口
        if ([self.delegate respondsToSelector:@selector(homeWebView:clickH5SaveImageWith:block:)]) {
            [self.delegate homeWebView:self clickH5SaveImageWith:[messageDic copy] block:^(id  _Nonnull data, id _Nonnull paramers) {
                // 图片返回 -- 处理后上传
                if ([data isKindOfClass:NSArray.class]) {
                    NSArray *images = (NSArray *)data;
                    if (images.count != 0) {
                        [self sendH5ImageToSeverWith:data andParame:paramers];
                    }else {
                        if ([[paramers objectForKey:@"isFunc"] isEqualToString:@"1"]) {
                            [self sendMsgToH5WithString:nil funName:[paramers objectForKey:@"funcName"]];
                        }
                    }
                }
            }];
        }
    }else if ([name isEqualToString:@"finish"]) {
        // 设置系统状态栏
        if (@available(iOS 13.0, *)) {
            UIApplication.sharedApplication.statusBarStyle = UIStatusBarStyleDarkContent;
        } else {
            // Fallback on earlier versions
            UIApplication.sharedApplication.statusBarStyle = UIStatusBarStyleDefault;
        }
        // H5调用关闭页面
        if (self.isPush) {
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }else if ([name isEqualToString:@"getCustomerId"]) {
        [self getUserInfoWithParam:messageDic type:WebGetUserInfoCustomerId];
    }else if ([name isEqualToString:@"getToken"]) {
        [self getUserInfoWithParam:messageDic type:WebGetUserInfoToken];
    }else if ([name isEqualToString:@"getCustomName"]) {
        [self getUserInfoWithParam:messageDic type:WebGetUserInfoCustomerName];
    }else if ([name isEqualToString:@"getAppVersion"]) {
        [self getUserInfoWithParam:messageDic type:WebGetUserInfoAppVersion];
    }else if ([name isEqualToString:@"getAppVersionCode"]) {
        [self getUserInfoWithParam:messageDic type:WebGetUserInfoAppVersionCode];
    }else if ([name isEqualToString:@"getAppVersionName"]) {
        [self getUserInfoWithParam:messageDic type:WebGetUserInfoAppName];
    }else if ([name isEqualToString:@"getAppPackageName"]) {
        [self getUserInfoWithParam:messageDic type:WebGetUserInfoAppPackName];
    }else if ([name isEqualToString:@"openH5Url"]) {
        [self createNewWebVCWithParam:messageDic];
    }else if ([name isEqualToString:@"setStatusBarColor"]) {
        [self changeStatusBarColor:messageDic];
    }else if ([name isEqualToString:@"startExam"]) { // 暂时不用
        [self updateExamStatus:1];
    }else if ([name isEqualToString:@"finishExam"]) { // 暂时不用
        [self updateExamStatus:0];
    }else if ([name isEqualToString:@"getDeviceId"]) {
        [self getUserInfoWithParam:messageDic type:WebGetUserInfoDeviceId];
    }else if ([name isEqualToString:@"startLogin"]) { // H5判断token失效，调用原生到登录页面
        [HICCommonUtils setRootViewToLoginVC];
        [HICToast showWithText:NSLocalizableString(@"abnormalAccountPrompt", nil)];
    }else if ([name isEqualToString:@"startNativePage"]) {
        // 扫码后跳转的中转页面后 查看是否需要再次跳转
        [self scanWebJumpWithParam:messageDic type:WebScanUrlJumpToOhterVC];
    }else if ([name isEqualToString:@"getWebSDKVersion"]) {
        if ([[messageDic objectForKey:@"isFunc"] isEqualToString:@"1"]) {
            NSString *name = [messageDic objectForKey:@"funcName"];
            [self sendMsgToH5WithString:websdk_version funName:name];
        }
    }else if ([name isEqualToString:@"jumpToMyCertificate"]){//跳转到我的证书详情
        if ([[messageDic objectForKey:@"type"] isKindOfClass:[NSNumber class]]) {
            if ([[messageDic objectForKey:@"type"] isEqualToNumber:@1]) {
                HICCertificatesVC *vc = [HICCertificatesVC new];
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                if ([NSString isValidStr:[messageDic objectForKey:@"employeeCertId"]] ) {
                    //employeeCertId传参证书id
                    HICMyCertificateDetailVC *vc = HICMyCertificateDetailVC.new;
                    vc.employeeCertId = [messageDic objectForKey:@"employeeCertId"];
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }
        }else{
            [HICToast showWithText:@""];
        }

    }
}

#pragma mark - 网页的Navigation、UI协议
-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    //    //如果是跳转一个新页面
    //    if (navigationAction.targetFrame == nil) {
    //        [webView loadRequest:navigationAction.request];
    //    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [self hidenProgressLoadingView];
    DDLogDebug(@"%@", error);
}

-(void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [self hidenProgressLoadingView];
    DDLogDebug(@"%@", error);
    if (!self.isThirdUrl) {
        [self createCustomerNavView];
    }
}
// UI 协议
-(void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler {
    
}

// Alert
-(void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizableString(@"prompt", nil) message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *done = [UIAlertAction actionWithTitle:NSLocalizableString(@"complete", nil) style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:done];

    [self presentViewController:alert animated:YES completion:nil];
    completionHandler();
}

#pragma mark - 涉及到的JS交互的事件
// 1. 文件上传
-(void)sendH5ImageToSeverWith:(id)data andParame:(NSDictionary *)parame{

    // 1. 上传图片的方法，以及回调的借口
    NSInteger imageCount = [(NSArray *)data count];
    [self.loadingView showLoadingView];
    __weak typeof(self) weakSelf = self;
    [self.webViewModel sendH5SaveImageToSeverWith:parame data:data success:^(BOOL success, id  _Nonnull data, NSDictionary *_Nonnull param) {

        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.loadingView hidenLoadingView];
        // 成功的回调
        if (success) {
            // 上传成功
            if ([[param objectForKey:@"isFunc"] isEqualToString:@"1"]) {
                [strongSelf sendMsgToH5WithArray:data funName:[param objectForKey:@"funcName"]];
            }
        }else {
            // 上传失败 - 分两种情况
            if (data && [data count] != 0) {
                // 存在data的情况
                if ([[param objectForKey:@"isFunc"] isEqualToString:@"1"]) {
                    [strongSelf sendMsgToH5WithArray:data funName:[param objectForKey:@"funcName"]];
                }
                [HICToast showAtDefWithText:[NSString stringWithFormat:@"%@:%ld,%@:%ld", NSLocalizableString(@"uploadedSuccessfully", nil),(long)imageCount, NSLocalizableString(@"failed", nil),(long)imageCount-[data count]]];
            }else {
                if ([[param objectForKey:@"isFunc"] isEqualToString:@"1"]) {
                    [strongSelf sendMsgToH5WithString:nil funName:[param objectForKey:@"funcName"]];
                }
                [HICToast showAtDefWithText:NSLocalizableString(@"uploadingFilesFailedProcedure", nil)];
            }
        }
    }];
}
// 2. 获取用户信息
-(void)getUserInfoWithParam:(NSDictionary *)param type:(WebGetUserInfoType) type{

    // 获取用户信息  首先使用 自身的代理方法， 没有得情况下使用统一设置。
    if ([self.delegate respondsToSelector:@selector(homeWebView:type:getUserInfoWith:block:)]) {
        [self.delegate homeWebView:self type:type getUserInfoWith:param block:^(id  _Nonnull data, id  _Nonnull paramers, WebGetUserInfoType type) {
            
        }];
    }
    if (HiWebViewPerson.sharePerson.getPublicValueBlock) {
        NSDictionary *dic = HiWebViewPerson.sharePerson.getPublicValueBlock(type, param); // 这种统一的返回格式
        if ([[dic objectForKey:@"isFunc"] isEqualToString:@"1"]) {
            NSString *name = [dic objectForKey:@"funcName"];
            [self sendMsgToH5WithString:[dic objectForKey:@"returnValue"] funName:name];
        }
    }

}

// 3. 打开新的web页面
-(void)createNewWebVCWithParam:(NSDictionary *)dic {
    if (HiWebViewPerson.sharePerson.openNewWebViewBlock) {
        NSString *urlStr = [dic objectForKey:@"parameter"];
        HiWebViewPerson.sharePerson.openNewWebViewBlock(urlStr);
    }
}
// 4. 更改状态栏的颜色和状态栏文字的颜色
-(void)changeStatusBarColor:(NSDictionary *)dic {
    NSString *strColor = [dic objectForKey:@"statusBarBackgroundColor"];
    if (strColor) {
        unsigned int red = 0;
        unsigned int green = 0;
        unsigned int blue = 0;
        if (strColor.length == 2) {
            [[NSScanner scannerWithString:[strColor substringToIndex:2]] scanHexInt:&red];
        }else if (strColor.length == 4) {
            [[NSScanner scannerWithString:[strColor substringToIndex:2]] scanHexInt:&red];
            [[NSScanner scannerWithString:[strColor substringWithRange:NSMakeRange(2, 2)]] scanHexInt:&green];
        }else if (strColor.length == 6) {
            [[NSScanner scannerWithString:[strColor substringToIndex:2]] scanHexInt:&red];
            [[NSScanner scannerWithString:[strColor substringWithRange:NSMakeRange(2, 2)]] scanHexInt:&green];
            [[NSScanner scannerWithString:[strColor substringFromIndex:4]] scanHexInt:&blue];
        }

        self.view.backgroundColor = [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1];
    }

    NSString *fontColor = [dic objectForKey:@"fontColor"];
    if (fontColor && [fontColor isEqualToString:@"1"]) {
        if (@available(iOS 13.0, *)) {
            UIApplication.sharedApplication.statusBarStyle = UIStatusBarStyleDarkContent;
        } else {
            // Fallback on earlier versions
            UIApplication.sharedApplication.statusBarStyle = UIStatusBarStyleDefault;
        }
    }else if (fontColor && [fontColor isEqualToString:@"0"]) {
        UIApplication.sharedApplication.statusBarStyle = UIStatusBarStyleLightContent;
    }else {
        DDLogError(@"[WebSDK] -- 没有设置状态栏的接口");
    }
}

/// 更新考试状态
/// @param status 1-开始考试; 0-结束考试
- (void)updateExamStatus:(NSInteger)status {
    if (status == 1) {
        ExamManager.startExam = YES;
    } else {
        ExamManager.startExam = NO;
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}
/// 扫描跳转页面
-(void)scanWebJumpWithParam:(NSDictionary *)param type:(WebGetUserInfoType) type {
    if ([self.delegate respondsToSelector:@selector(homeWebView:type:getUserInfoWith:block:)]) {
        [self.delegate homeWebView:self type:type getUserInfoWith:param block:^(id  _Nonnull data, id  _Nonnull paramers, WebGetUserInfoType type) {

        }];
    }
}

#pragma mark - webView直接调用JS方法实现
-(void)sendMsgToH5WithArray:(NSArray *)array funName:(NSString *)name{
    NSError *jsonError;
    NSString *jsStr;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:&jsonError];
    NSString *paramStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

    if (!jsonError) {
        jsStr = [NSString stringWithFormat:@"%@(%@)", name, paramStr];
    }else {
        jsStr = [NSString stringWithFormat:@"%@([])", name];
    }

    // 统一的方法执行
    [self sendMsgToH5MainWithStr:jsStr];
}

-(void)sendMsgToH5WithDIctionary:(NSDictionary *)dic funName:(NSString *)name{

    NSError *jsonError;
    NSString *jsStr;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&jsonError];
    NSString *paramStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

    if (!jsonError) {
        jsStr = [NSString stringWithFormat:@"%@(%@)", name, paramStr];
    }else {
        jsStr = [NSString stringWithFormat:@"%@()", name];
    }

    // 统一的方法执行
    [self sendMsgToH5MainWithStr:jsStr];
}

-(void)sendMsgToH5WithString:(NSString * _Nullable)str funName:(NSString *)name{

    NSString *jsStr;
    if ([NSString isValidStr:str]) {
        jsStr = [NSString stringWithFormat:@"%@('%@')", name, str];
    }else {
        jsStr = [NSString stringWithFormat:@"%@()", name];
    }

    // 统一的方法执行
    [self sendMsgToH5MainWithStr:jsStr];
}

// 统一的调用js方法接口
-(void)sendMsgToH5MainWithStr:(NSString *)jsStr {
    NSString *str = [NSString stringWithFormat:@"%@.%@", @"jsApi4Native", jsStr];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (ExamManager.webviewVC) {
            [ExamManager.webviewVC evaluateJavaScript:str completionHandler:^(id _Nullable data, NSError * _Nullable error) {
                // 执行完成后的方法
                DDLogDebug(@"[HiClass] - [WebVC] - 执行js方法%@ error：%@", str ,error);
            }];
        } else {
            DDLogDebug(@"[HiClass] - [WebVC] - error: webviewVC is NOT valid");
        }
    });
}

#pragma mark - KVO
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {

    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        NSNumber *progressValue = [change objectForKey:NSKeyValueChangeNewKey];
        if (progressValue && [progressValue floatValue] > 0 && [progressValue floatValue] < 1) {
            self.progressView.progress = [progressValue floatValue];
        }else {
            self.progressView.progress = 1;
            [self hidenProgressLoadingView];
        }
    }
}

#pragma mark - 懒加载
-(UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectZero];
        _progressView.progressTintColor = [UIColor colorWithRed:0 green:226/255.0 blue:216/255.0 alpha:1];
        _progressView.trackTintColor = UIColor.whiteColor;
        _progressView.hidden = YES;
        [self.view addSubview: _progressView];
    }
    return _progressView;
}
@end
