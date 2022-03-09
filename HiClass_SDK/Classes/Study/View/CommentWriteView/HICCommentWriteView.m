//
//  HICCommentWriteView.m
//  HiClass
//
//  Created by Eddie Ma on 2020/2/6.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICCommentWriteView.h"

#define section1Height  50
#define section2Height  93.5
#define section3Height  127
#define section4Height  158

static NSString *logName = @"[HIC][CWV]";

@interface HICCommentWriteView()<UITextViewDelegate, UITextFieldDelegate>

@property (nonatomic, assign) HICCommentType commentType;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSInteger starLevel;
@property (nonatomic, strong) UIView *section2View;
@property (nonatomic, strong) NSArray *starLabelArr;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, strong) UITextView *inputContent;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UIButton *publishBtn;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@property (nonatomic, assign) CGFloat CommentWriteViewHeight;
@property (nonatomic, assign) CGFloat sectionThreeHeight;
@property (nonatomic, assign) CGFloat keyboardHeight;
@property (nonatomic, strong) UIView *allSectionView;
@property (nonatomic, strong) UIImageView *setImportantIV;
@property (nonatomic, strong) UIButton *setImportant;
@property (nonatomic, strong) NSString *identifer;
@property (nonatomic, strong) NSArray *editedInfoBefore;
@property (nonatomic, assign) BOOL editedBefore;
@property (nonatomic, strong) UILabel *placeholderLabel;
// 之前存储的id
@property (nonatomic, strong) NSString *identifer_before;
// 之前存储的内容
@property (nonatomic, strong) NSString *content_before;
// 之前存储的类型
@property (nonatomic, assign) HICCommentType type_before;
// 之前存储的几颗星
@property (nonatomic, strong) NSString *star_before;
// 之前存储的是否重要
@property (nonatomic, strong) NSString *importent_before;
// 之前存储的给谁回复
@property (nonatomic, strong) NSString *replyTo_before;
@property (nonatomic, strong) NSString *placeHolderContent;

@property (nonatomic ,assign)BOOL isPublish;

@end

@implementation HICCommentWriteView

- (instancetype)initWithType:(HICCommentType)commentType commentTo:(NSString *)name identifer:(NSString *)identifer {
    if (self = [super init]) {
        self.identifer = identifer;
        self.isPublish = NO;
        self.commentType = commentType;
        if (_commentType == HICCommentWrite) {
            self.placeHolderContent = NSLocalizableString(@"publishedView", nil);
            self.sectionThreeHeight = section3Height;
            self.CommentWriteViewHeight = section1Height + section2Height + self.sectionThreeHeight;
        } else if (_commentType == HICCommentReply){
            self.placeHolderContent = NSLocalizableString(@"publishedView", nil);
            self.sectionThreeHeight = section3Height;
            self.CommentWriteViewHeight = section1Height + self.sectionThreeHeight;
        } else {
            self.placeHolderContent = NSLocalizableString(@"enterNotesContent", nil);
            self.sectionThreeHeight = section4Height;
            self.CommentWriteViewHeight = section1Height + self.sectionThreeHeight;
        }
        self.name = name;
        [self initData];
        [self createUI];
        [self addOberver];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)initData {
    self.keyboardHeight = 0.0;
    self.starLabelArr = @[NSLocalizableString(@"tooBad", nil),NSLocalizableString(@"aLittleBad", nil),NSLocalizableString(@"justSoSo", nil),NSLocalizableString(@"veryNice", nil),NSLocalizableString(@"great", nil)];
    self.starLevel = self.starLabelArr.count;
    self.editedBefore = NO;
    self.editedInfoBefore = HIC_EDITED_INFO_BEFORE;
    if (self.editedInfoBefore.count > 0) {
        if ([self.identifer isEqualToString:self.editedInfoBefore[0]]) {
            self.identifer_before = self.editedInfoBefore[0];
            self.content_before = self.editedInfoBefore[1];
            self.star_before = self.editedInfoBefore[2];
            self.importent_before = self.editedInfoBefore[3];
            self.replyTo_before = self.editedInfoBefore[4];
            NSString *typeStr = self.editedInfoBefore[5];
            if ([typeStr isEqualToString:@"0"]) {
                self.type_before = HICCommentWrite;
                self.editedBefore = self.type_before == self.commentType ? YES : NO;
                self.starLevel = [self.star_before integerValue];
            } else if ([typeStr isEqualToString:@"1"]) {
                self.type_before = HICCommentReply;
                self.editedBefore = self.type_before == self.commentType && self.name == self.replyTo_before ? YES : NO;
            } else {
                self.type_before = HICCommentNote;
                self.editedBefore = self.type_before == self.commentType ? YES : NO;
            }
            DDLogDebug(@"%@ Edited before, identifer: %@, edited content: %@, important: %@", logName, _identifer_before, _content_before, _importent_before);
        }
        DDLogDebug(@"%@ Edited before, BUT not the same", logName);
    } else {
        DDLogDebug(@"%@ NO Edited before", logName);
    }
}

- (void)createUI {
    self.frame = CGRectMake(0, 0, HIC_ScreenWidth, HIC_ScreenHeight);
    UIView *bgView = [[UIView alloc] initWithFrame:self.frame];
    bgView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.5];
    [self addSubview:bgView];

    self.allSectionView = [[UIView alloc] initWithFrame:CGRectMake(0, HIC_ScreenHeight, HIC_ScreenWidth, self.CommentWriteViewHeight)];
    self.allSectionView.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:self.allSectionView];

    #pragma mark --- SECTION 1 ---
    UIView *section1View = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, section1Height)];
    [self.allSectionView addSubview:section1View];
    // 评论title
    UILabel *commentTitle = [[UILabel alloc] init];
    [section1View addSubview: commentTitle];
    if (_commentType == HICCommentWrite || _commentType == HICCommentNote) {
        NSString *title = _commentType == HICCommentWrite ? NSLocalizableString(@"publishedComments", nil) : NSLocalizableString(@"addNote", nil);
        CGSize titleSize = [HICCommonUtils sizeOfString:title stringWidthBounding:self.frame.size.width font:17 stringOnBtn:NO fontIsRegular:NO];
        commentTitle.text = title;
        commentTitle.font = FONT_MEDIUM_17;
        commentTitle.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
        commentTitle.frame = CGRectMake(16, (section1View.frame.size.height - titleSize.height)/2, titleSize.width, titleSize.height);
    } else {
        NSString *title = [NSString stringWithFormat:@"%@ %@", NSLocalizableString(@"commentsTo", nil), _name];
        long NameLen = [NSLocalizableString(@"commentsTo", nil) length];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:title];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:133/255.0 green:133/255.0 blue:133/255.0 alpha:1/1.0] range:NSMakeRange(0, NameLen)];//颜色
        CGSize titleSize = [HICCommonUtils sizeOfString:title stringWidthBounding:self.frame.size.width font:16 stringOnBtn:NO fontIsRegular:YES];
        commentTitle.text = title;
        commentTitle.font = FONT_REGULAR_16;
        commentTitle.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1/1.0];
        commentTitle.attributedText = str;
        commentTitle.frame = CGRectMake(16, (section1View.frame.size.height - titleSize.height)/2, titleSize.width, titleSize.height);
    }
    // 取消评论
    UIButton *cancelBtn = [[UIButton alloc] init];
    [section1View addSubview: cancelBtn];
    cancelBtn.tag = 10000;
    [cancelBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setImage:[UIImage imageNamed:@"关闭弹窗"] forState:UIControlStateNormal];
    cancelBtn.frame = CGRectMake(section1View.frame.size.width - 20 - 16, (section1View.frame.size.height - 20)/2, 20, 20);

    if (_commentType == HICCommentWrite) {
        UIView *dividedLine = [[UIView alloc] initWithFrame:CGRectMake(0, section1View.frame.size.height - 0.5, section1View.frame.size.width, 0.5)];
        [section1View addSubview: dividedLine];
        dividedLine.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1/1.0];
    }

    #pragma mark --- SECTION 2 ---
    if (_commentType == HICCommentWrite) {
        self.section2View = [[UIView alloc] initWithFrame:CGRectMake(0, section1Height, self.frame.size.width, section2Height)];
        [self.allSectionView addSubview:self.section2View];
        CGFloat topMargin = 22;
        CGFloat starHW = 27;
        CGFloat interval = 20;
        CGFloat leftMargin = (self.section2View.frame.size.width - starHW * 5 - interval * 4) / 2;
        for (int i = 0; i < self.starLabelArr.count; i ++) {
            UIButton *starBtn = [[UIButton alloc] init];
            [self.section2View addSubview: starBtn];
            starBtn.tag = 20000 + i;
            [starBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
            if (_editedBefore) {
                if (i < _starLevel) {
                    starBtn.selected = YES;
                    [starBtn setImage:[UIImage imageNamed:@"星形"] forState:UIControlStateNormal];
                } else {
                    starBtn.selected = NO;
                    [starBtn setImage:[UIImage imageNamed:@"星形 未点亮"] forState:UIControlStateNormal];
                }
            } else {
                starBtn.selected = YES;
                [starBtn setImage:[UIImage imageNamed:@"星形"] forState:UIControlStateNormal];
            }
            starBtn.frame = CGRectMake(leftMargin + i * starHW + i * interval, topMargin , starHW, starHW);
        }

        NSString *starLabelStr = _editedBefore ? self.starLabelArr[_starLevel - 1] : @"这个知识点太棒了，强烈推荐";
        CGSize starLabelStrSize = [HICCommonUtils sizeOfString:starLabelStr stringWidthBounding:self.frame.size.width font:12 stringOnBtn:NO fontIsRegular:YES];
        UILabel *starLabel = [[UILabel alloc] init];
        [self.section2View addSubview: starLabel];
        starLabel.font = FONT_REGULAR_12;
        starLabel.text = starLabelStr;
        starLabel.textColor = [UIColor colorWithRed:133/255.0 green:133/255.0 blue:133/255.0 alpha:1/1.0];
        starLabel.frame = CGRectMake((self.section2View.frame.size.width - starLabelStrSize.width)/2, topMargin + starHW + 12, starLabelStrSize.width, starLabelStrSize.height);
    }

    #pragma mark --- SECTION 3 ---
    UIView *section3View = [[UIView alloc] initWithFrame:CGRectMake(0, self.CommentWriteViewHeight - self.sectionThreeHeight, self.frame.size.width, self.sectionThreeHeight)];
    section3View.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1/1.0];
    [self.allSectionView addSubview:section3View];

    self.inputContent = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, section3View.frame.size.width, section3View.frame.size.height - 28 - 12)];
    [section3View addSubview:self.inputContent ];
    self.inputContent.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1/1.0];
    self.inputContent.delegate = self;
    self.inputContent.font = FONT_REGULAR_15;
    self.inputContent.textContainerInset = UIEdgeInsetsMake(12, 10, 12, 10);//设置页边距
    self.inputContent.text = self.editedBefore ? _content_before : @"";
    self.inputContent.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    [self.inputContent becomeFirstResponder];
    UIToolbar * toobar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, HIC_ScreenWidth, 44.0f)];
    toobar.backgroundColor = UIColor.whiteColor;
        toobar.translucent = YES;
        toobar.barStyle = UIBarStyleDefault;
        UIBarButtonItem * spaceBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem * doneBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizableString(@"complete", nil) style:UIBarButtonItemStyleDone target:self action:@selector(resignKeyboard)];
        [toobar setItems:@[spaceBarButtonItem,doneBarButtonItem]];
    self.inputContent.inputAccessoryView = toobar;

    self.placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(17, 12, section3View.frame.size.width - 16 * 2, 21)];
    [self.inputContent addSubview:self.placeholderLabel];
    self.placeholderLabel.font = FONT_REGULAR_15;
    self.placeholderLabel.text = _placeHolderContent;
    self.placeholderLabel.hidden = self.editedBefore && [NSString isValidStr:_content_before] ? YES : NO;
    self.placeholderLabel.textColor = [UIColor colorWithRed:185/255.0 green:185/255.0 blue:185/255.0 alpha:1/1.0];

    self.publishBtn = [[UIButton alloc] init];
    [section3View addSubview:self.publishBtn];
    self.publishBtn.frame = CGRectMake(section3View.frame.size.width - 54 - 16, self.inputContent.frame.size.height, 54, 28);
    [self.publishBtn setTitle:NSLocalizableString(@"release", nil) forState:UIControlStateNormal];
    [self.publishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.publishBtn.titleLabel.font = FONT_REGULAR_16;
    self.publishBtn.layer.cornerRadius = 2;
    self.publishBtn.layer.masksToBounds = YES;
    self.publishBtn.tag = 30000;
    self.gradientLayer = [CAGradientLayer layer];
    [self showActivePublishBtn:NO];
    [self.publishBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];

    self.textLabel = [[UILabel alloc] init];
    [section3View addSubview:self.textLabel];
    self.textLabel.text = @"1000";
    self.textLabel.font = FONT_REGULAR_14;
    self.textLabel.textAlignment = NSTextAlignmentRight;
    self.textLabel.textColor = [UIColor colorWithRed:185/255.0 green:185/255.0 blue:185/255.0 alpha:1/1.0];
    CGFloat textLabelY = (section3View.frame.size.height - self.inputContent.frame.size.height - 20 - 12)/2 + self.inputContent.frame.size.height;
    self.textLabel.frame = CGRectMake(section3View.frame.size.width - 31 - 10 - self.publishBtn.frame.size.width - 16, textLabelY, 31, 20);

    if (_commentType == HICCommentNote) {
        self.setImportant = [[UIButton alloc] init];
        [section3View addSubview:self.setImportant];
        self.setImportant.tag = 40000;
        [self.setImportant addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];

        self.setImportantIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, (20 -14)/2, 14, 14)];
        [self.setImportant addSubview: self.setImportantIV];
        if (_editedBefore && [self.importent_before isEqualToString:@"1"]) {
            self.setImportant.selected = YES;
            self.setImportantIV.image = [UIImage imageNamed:@"添加笔记-设为重要-已勾选"];
        } else {
            self.setImportant.selected = NO;
            self.setImportantIV.image = [UIImage imageNamed:@"添加笔记-设为重要-未勾选"];
        }

        UILabel *setImportantLabel = [[UILabel alloc] initWithFrame:CGRectMake(14 + 6, 0, 56, 20)];
        [self.setImportant addSubview:setImportantLabel];
        setImportantLabel.text = NSLocalizableString(@"asImportant", nil);
        setImportantLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1/1.0];
        setImportantLabel.font = FONT_REGULAR_14;
        CGFloat setImportantY = (section3View.frame.size.height - self.inputContent.frame.size.height - setImportantLabel.frame.size.height - 12)/2 + self.inputContent.frame.size.height;
        self.setImportant.frame = CGRectMake(16, setImportantY, self.setImportant.frame.size.width + 6 + setImportantLabel.frame.size.width, setImportantLabel.frame.size.height);
    }
}

- (void)updateStarLevel {
    [ self.section2View.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.section2View = [[UIView alloc] initWithFrame:CGRectMake(0, section1Height, self.frame.size.width, section2Height)];
    [self.allSectionView addSubview:self.section2View];
    CGFloat topMargin = 22;
    CGFloat starHW = 27;
    CGFloat interval = 20;
    CGFloat leftMargin = (self.section2View.frame.size.width - starHW * 5 - interval * 4) / 2;

    for (int i = 0; i < self.starLabelArr.count; i ++) {
        UIButton *starBtn = [[UIButton alloc] init];
        [self.section2View addSubview: starBtn];
        starBtn.tag = 20000 + i;
        starBtn.selected = self.starLevel == i ? YES : NO;
        [starBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        if (i <= self.starLevel) {
            [starBtn setImage:[UIImage imageNamed:@"星形"] forState:UIControlStateNormal];
        } else {
            [starBtn setImage:[UIImage imageNamed:@"星形 未点亮"] forState:UIControlStateNormal];
        }
        starBtn.frame = CGRectMake(leftMargin + i * starHW + i * interval, topMargin , starHW, starHW);
    }

    NSString *starLabelStr = self.starLabelArr[self.starLevel];
    CGSize starLabelStrSize = [HICCommonUtils sizeOfString:starLabelStr stringWidthBounding:self.frame.size.width font:12 stringOnBtn:NO fontIsRegular:YES];
    UILabel *starLabel = [[UILabel alloc] init];
    [self.section2View addSubview: starLabel];
    starLabel.font = FONT_REGULAR_12;
    starLabel.text = starLabelStr;
    starLabel.textColor = [UIColor colorWithRed:133/255.0 green:133/255.0 blue:133/255.0 alpha:1/1.0];
    starLabel.frame = CGRectMake((self.section2View.frame.size.width - starLabelStrSize.width)/2, topMargin + starHW + 12, starLabelStrSize.width, starLabelStrSize.height);
}
- (void)resignKeyboard{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}
- (void)addOberver {
    // 注册观察键盘的变化
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(transformView:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

//移动UIView
-(void)transformView:(NSNotification *)aNSNotification {
    // 获取键盘弹出前的Rect
    NSValue *keyBoardBeginBounds = [[aNSNotification userInfo]objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect beginRect=[keyBoardBeginBounds CGRectValue];
    // 获取键盘弹出后的Rect
    NSValue *keyBoardEndBounds = [[aNSNotification userInfo]objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect  endRect = [keyBoardEndBounds CGRectValue];
    // 键盘的弹出时间
    CGFloat keyboardDuration = [[[aNSNotification userInfo]objectForKey: UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 获取键盘位置变化前后纵坐标Y的变化值
    CGFloat deltaY = endRect.origin.y - beginRect.origin.y;
    _keyboardHeight = _keyboardHeight + deltaY;
    DDLogDebug(@"看看这个变化的Y值:%f",_keyboardHeight);

    // 根据键盘的弹出时间完成self.view的Frame的变化，等于是给self.view添加一个向上移动deltaY的动画
    [UIView animateWithDuration:keyboardDuration animations:^{
        self.allSectionView.frame = CGRectMake(0, HIC_ScreenHeight + self.keyboardHeight - self.CommentWriteViewHeight, HIC_ScreenWidth, self.CommentWriteViewHeight);
    }];
}

- (void)hide {
    [self removeFromSuperview];
    [self endEditing:YES];
}

- (void)btnClicked:(UIButton *)btn {
    if (btn.tag == 10000) {
        [self removeFromSuperview];
        [self endEditing:YES];
        // 存储当前操作的数据
        BOOL important = NO;
        if (self.setImportant) {
            important = self.setImportant.selected;
        }
        NSString *importantStr = important ? @"1" : @"0";
        NSInteger starNum = self.starLevel + 1 > 5 ? 5 : self.starLevel + 1;
        NSString *starNumStr = [NSString stringWithFormat:@"%ld",(long)starNum];
        NSString *content = [NSString isValidStr:self.inputContent.text] ? self.inputContent.text : @"";
        NSString *contentType = [NSString stringWithFormat:@"%ld", (long)self.commentType];
        self.name = [NSString isValidStr:self.name] ? self.name : @"";
        // 记录内容存储数组storeArr: [0]-内容id, [1]-内容, [2]-几颗星, [3]-是否重要, [4]-给谁回复, [5]-内容类型
        if ([NSString isValidStr:self.identifer]) {
            NSArray *storeArr = @[self.identifer, content, starNumStr, importantStr, self.name, contentType];
            [[NSUserDefaults standardUserDefaults] setObject:storeArr forKey:@"HICEditedInfoBefore"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    } else if (btn.tag >= 20000 && btn.tag < 30000) {
        NSInteger index = btn.tag - 20000;
        if (btn.selected) {
            // 取消
            self.isSelected = NO;
            if (self.starLevel > index && (self.starLevel + 1) != self.starLabelArr.count) {
                self.starLevel = index;
            } else {
                self.starLevel = index - 1 < 0 ? 0 : index - 1;
            }
        } else {
            // 选中
            self.isSelected = YES;
            self.starLevel = index;
        }
        DDLogDebug(@"%@ %ld star(s)", logName, (long)(self.starLevel + 1));

        [self updateStarLevel];
    } else if (btn.tag == 30000) {
        // 发布
        if (self.isPublish) {
            [HICToast showWithText:NSLocalizableString(@"pleaseRefrainFromFrequentComments", nil)];
            return;
        }
        self.isPublish = YES;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
               self.isPublish = NO;
         });

        if (![NSString isValidStr:self.inputContent.text]) {
            DDLogDebug(@"请先输入内容");
            return;
        }

        BOOL important = NO;
        if (self.setImportant) {
            important = self.setImportant.selected;
        }
        NSInteger starNum = self.starLevel + 1 > 5 ? 5 : self.starLevel + 1;
        DDLogDebug(@"%@ Publish Btn clicked, content: %@, star num: %ld, isImportant: %@", logName, self.inputContent.text, (long)starNum, important ? @"YES" : @"NO");
        if ([self.delegate respondsToSelector:@selector(publishBtnClickedWithContent:type:starNum:isImportant:toAnybody:)]) {
            [self.delegate publishBtnClickedWithContent:self.inputContent.text type:_commentType starNum:starNum isImportant:important toAnybody:self.identifer];
        }
    } else if (btn.tag == 40000) {
        // 笔记设置为重要
        if (btn.selected) {
            btn.selected = NO;
            self.setImportantIV.image = [UIImage imageNamed:@"添加笔记-设为重要-未勾选"];
        } else {
            btn.selected = YES;
            self.setImportantIV.image = [UIImage imageNamed:@"添加笔记-设为重要-已勾选"];
        }
    }
}

#pragma mark - - - UITextView delegate start - - -
- (void)textViewDidBeginEditing:(UITextView *)textView {
    if (textView.text.length < 1000) {
        self.textLabel.text = [NSString stringWithFormat:@"%ld", 1000 - (unsigned long)textView.text.length];
    } else {
        self.textLabel.text = @"0";
        textView.text = [textView.text substringToIndex:1000];
    }

    if (![textView.text isEqualToString:@""]) {
        [self showActivePublishBtn:YES];
    } else {
        [self showActivePublishBtn:NO];
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length < 1000) {
        self.textLabel.text = [NSString stringWithFormat:@"%ld", 1000 - (unsigned long)textView.text.length];
    } else {
        self.textLabel.text = @"0";
        textView.text = [textView.text substringToIndex:1000];
    }
    if ([textView.text isEqualToString:@""]) {
        self.textLabel.text = @"1000";
        self.placeholderLabel.hidden = NO;
        [self showActivePublishBtn:NO];
    }else{
        self.placeholderLabel.hidden = YES;
        [self showActivePublishBtn:YES];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@""]) {
        self.textLabel.text = @"1000";
        self.placeholderLabel.hidden = NO;
        [self showActivePublishBtn:NO];
    } else {
        self.placeholderLabel.hidden = YES;
        [self showActivePublishBtn:YES];
    }

}
#pragma mark - - - UITextView delegate end - - -

- (void)showActivePublishBtn:(BOOL)show {
    [self.gradientLayer removeFromSuperlayer];
    self.gradientLayer = [CAGradientLayer layer];
    if (show) {
        [HICCommonUtils createGradientLayerWithBtn:self.publishBtn gradientLayer:self.gradientLayer fromColor:[UIColor colorWithHexString:@"00E2D8" alpha:1.0f] toColor:[UIColor colorWithHexString:@"00C5E0" alpha:1.0f]];
    } else {
        [HICCommonUtils createGradientLayerWithBtn:self.publishBtn gradientLayer:self.gradientLayer fromColor:[UIColor colorWithHexString:@"00E2D8" alpha:0.4f] toColor:[UIColor colorWithHexString:@"00C5E0" alpha:0.4f]];
    }
}

@end
