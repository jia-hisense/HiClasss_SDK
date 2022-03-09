//
//  OTPSignBackView.m
//  HiClass
//
//  Created by 铁柱， on 2020/4/17.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "OTPSignBackView.h"

#define SignBackViewHeight 223.6
#define SignBackViewWidth 280

@interface OTPSignBackView()<UITextViewDelegate>

// 输入框
@property (nonatomic, strong) UITextView *inputText;
// 父类视图
@property (nonatomic, weak) UIView *parentView;
// window的回调函数
@property (nonatomic, copy) SignBackViewBlock windowBackBlock;
// 弹框背景view
@property (nonatomic, strong) UIView *backView;

@end

@implementation OTPSignBackView

-(instancetype)initWithFrame:(CGRect)frame andParentView:(UIView *)parentView{
    if (self = [super initWithFrame:frame]) {
        // 定制化页面创建
        [self createView];
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        _parentView = parentView;
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 定制化页面创建
        [self createView];
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    }
    return self;
}

// 创建页面
-(void)createView {
    // 建立一个 背景
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake((self.width-SignBackViewWidth)/2, (self.height-SignBackViewHeight)/2, 280, SignBackViewHeight)];
    backView.backgroundColor = [UIColor colorWithHexString:@"#E6E6E6"];
    backView.layer.cornerRadius = 12.f;
    backView.layer.masksToBounds = YES;
    [self addSubview:backView];
    _backView = backView;

    // 建立一个底部白页
    UIView *topBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SignBackViewWidth, 173)];
    topBackView.backgroundColor = UIColor.whiteColor;

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, SignBackViewWidth-20*2, 20)];
    titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    titleLabel.font = FONT_MEDIUM_18;
    titleLabel.text = NSLocalizableString(@"signBack", nil);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [topBackView addSubview:titleLabel];

    UITextView *textField = [[UITextView alloc] initWithFrame:CGRectMake(20, 51, SignBackViewWidth-20*2, 102)];
    textField.font = FONT_REGULAR_15;
    textField.layer.borderColor = [UIColor colorWithHexString:@"#D8D8D8"].CGColor;
    textField.layer.borderWidth = 0.5;
    textField.layer.cornerRadius = 2.0;
    [topBackView addSubview:textField];
    _inputText = textField;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name: UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name: UIKeyboardWillShowNotification object:nil];
    textField.delegate = self;

    // _placeholderLabel
    UILabel *placeHolderLabel = [[UILabel alloc] init];
    placeHolderLabel.text = NSLocalizableString(@"enterReasonForLeavingEarly", nil);
    placeHolderLabel.numberOfLines = 0;
    placeHolderLabel.textColor = [UIColor lightGrayColor];
    [placeHolderLabel sizeToFit];
    [textField addSubview:placeHolderLabel];

    // same font
    placeHolderLabel.font = FONT_REGULAR_15;
    [textField setValue:placeHolderLabel forKey:@"_placeholderLabel"];

    // 建立底部按钮，
    UIButton *cancel = [[UIButton alloc] initWithFrame:CGRectMake(0, SignBackViewHeight-50.1, 140, 50.1)];
    [cancel setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    [cancel setTitle:NSLocalizableString(@"cancel", nil) forState:UIControlStateNormal];
    cancel.titleLabel.font = FONT_REGULAR_18;
    [cancel addTarget:self action:@selector(clickCancelBut:) forControlEvents:UIControlEventTouchUpInside];
    cancel.backgroundColor = UIColor.whiteColor;

    UIButton *sure = [[UIButton alloc] initWithFrame:CGRectMake(140.5, SignBackViewHeight-50.1, 139.5, 50.1)];
    [sure setTitleColor:[UIColor colorWithHexString:@"#00BED7"] forState:UIControlStateNormal];
    [sure setTitle:NSLocalizableString(@"determine", nil) forState:UIControlStateNormal];
    sure.titleLabel.font = FONT_MEDIUM_18;
    [sure addTarget:self action:@selector(clickSureBut:) forControlEvents:UIControlEventTouchUpInside];
    sure.backgroundColor = UIColor.whiteColor;

    [backView addSubview:topBackView];
    [backView addSubview:cancel];
    [backView addSubview:sure];
}

-(void)clickCancelBut:(UIButton *)btn {
    [self removeFromSuperview];
}

-(void)clickSureBut:(UIButton *)btn {
    NSString *str = self.inputText.text;
    if (![NSString isValidStr:str]) {
        [HICToast showWithText:NSLocalizableString(@"inputReason", nil)];
    }else {
        if (self.backBlock) {
            self.backBlock(str);
        }
        if (self.windowBackBlock) {
            self.windowBackBlock(str);
        }
        [self removeFromSuperview];
    }
}

// FIXME: 键盘将要出现
- (void)keyboardWillShow:(NSNotification *)notification{
    //获取键盘的高度
    NSDictionary *userInfo = [notification userInfo];
    NSValue *keyboardValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [keyboardValue CGRectValue];
    CGFloat height = CGRectGetHeight(keyboardRect);
     //做自定义事件
    CGFloat backBottom = (self.height - SignBackViewHeight)/2.f;
    if (backBottom < height) {
        // 说明此时有遮挡需要上移页面
        self.backView.Y -= (height-backBottom);
    }
}

// FIXME: 键盘将要消失
- (void)keyboardWillHide:(NSNotification *)notification{

    //获取键盘的高度 -- 此时不需要键盘的高度  直接赋值
//    NSDictionary *userInfo = [notification userInfo];
//    NSValue *keyboardValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
//    CGRect keyboardRect = [keyboardValue CGRectValue];
//    CGFloat height = CGRectGetHeight(keyboardRect);
    //做自定义事件
    CGFloat backBottom = (self.height - SignBackViewHeight)/2.f;
    self.backView.Y = backBottom;

}

-(void)showPassView {
    self.inputText.text = @"";
    [self.parentView addSubview:self];
}

+(void)showWindowSignBackViewBlock:(SignBackViewBlock)block {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;

    OTPSignBackView *passView = [[OTPSignBackView alloc] initWithFrame:window.bounds];
    passView.windowBackBlock = block;
    [window addSubview:passView];
}

-(void)dealloc {
    DDLogDebug(@"--- 析构 ----");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 输入框的协议方法
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSMutableString *str = [NSMutableString stringWithString:textView.text];
    [str appendString:text];
    if (str.length > 50) {
        return NO;
    }
    return YES;
}

@end
