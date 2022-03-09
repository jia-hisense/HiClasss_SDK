//
//  HICHomeWorkWriteVC.m
//  HiClass
//
//  Created by 铁柱， on 2020/3/26.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICHomeWorkWriteVC.h"

#import "HICPhotoPickerVC.h"
#import "HICOpenCamera.h"
#import "PhotoVideoPickerVC.h"
#import "MessageBoardVideoVC.h"
#import "HomewrokRecordView.h"
#import "HomeworkImagePreViewVC.h"
#import <AVKit/AVKit.h>

#import "HomeworkImageViewCell.h"

#define TextViewTop         (39.5+HIC_StatusBar_Height+HIC_NavBarHeight)
#define TextViewNumHeight   20
#define TextViewBottom      35
#define ToolBarHeight       50
#define ImageBackHeight     92

#define Write_Video @"Video"
#define Write_Photo @"Photo"
#define Write_Carme @"Carme"
#define Write_Voice @"Voice"

#define Write_Tool_Bar_Tag 8900000

@implementation HomeworkImageModel

+(instancetype)createModelWith:(HMBMessageFileType)type filePath:(NSString *)filePath image:(UIImage *)image {
    HomeworkImageModel *model = [HomeworkImageModel new];
    model.type = type;
    model.filePath = filePath;
    model.image = image;
    return model;
}

@end

@interface HICHomeWorkWriteVC ()<UICollectionViewDataSource, UICollectionViewDelegate, HICOpenCameraDelegate, HICPhotoPickerVCDelegate, PhotoVideoPickerVCDelegate, HomeworkRecordViewDelegate, UITextViewDelegate, HomeworkImageViewCellDelegate,UITextFieldDelegate>

@property (nonatomic, strong) HICOpenCamera *camera; // 相机

@property (nonatomic, assign) BOOL isToolBar;   // 是否有工具条 -- 展示在TextView上的
@property (nonatomic, assign) BOOL isShowImageView; // 是否显示图片背景
@property (nonatomic, assign) BOOL isTextView; // 是否存在TextView

@property (nonatomic, strong) UITextView *inputText; // 输入框
@property (nonatomic, strong) UILabel *textNumLabel; // 文字限制框
@property (nonatomic, strong) UICollectionView *collectionView; // 图片显示
@property (nonatomic, strong) UIView *toolBarView;  // 工具条

@property (nonatomic, strong) HomewrokRecordView *recordView;

/// 保存用户上传的图片、语音、视频等信息
@property (nonatomic, strong) NSMutableArray<HomeworkImageModel *> *imageDatas;

@property (nonatomic, strong) NSMutableArray *toolBarButs;
@property (nonatomic, assign) BOOL isVideoAndCarme;
@property (nonatomic, copy) NSString *textString;
@property (nonatomic, assign) BOOL isTextViewEnable;
@property (nonatomic ,strong) UITextView *textview;

/// 如果是撤销回来的需要增加的数据
@property (nonatomic, strong) NSMutableArray *againImageArray;

@end

@implementation HICHomeWorkWriteVC

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
    _isTextView = YES;
    _toolBarButs = [NSMutableArray arrayWithArray:@[Write_Photo, Write_Carme, Write_Video, Write_Voice]];

    if (![_toolBars containsObject:@"1"] && ![_toolBars containsObject:@"4"]) {
        [_toolBarButs removeObject:Write_Photo];
        [_toolBarButs removeObject:Write_Carme];
        [_toolBarButs removeObject:Write_Video];
    }
    if (![_toolBars containsObject:@"2"]) {
        [_toolBarButs removeObject:Write_Voice];
    }
    if (![_toolBars containsObject:@"3"]) {
        _isTextView = NO;
    }
    if (![_toolBars containsObject:@"4"]) {
        [_toolBarButs removeObject:Write_Carme];
    }
    if (![_toolBars containsObject:@"1"]) {
        [_toolBarButs removeObject:Write_Video];
    }


    if (_toolBarButs.count != 0) {
         _isToolBar = YES;
    }
    if ([_toolBarButs containsObject:Write_Carme] && [_toolBarButs containsObject:Write_Video]) {
        _isVideoAndCarme = YES;
    }

    _imageDatas = [NSMutableArray array];

    [self createNavUI];
    [self createWarnView];
    if (_isTextView) {
        [self createTextView];
        if (_isToolBar) {
            [self createToolBut];
            [self createImageViewBack];
        }
    }else {
        [self createOnleToolBut];
        [self createImageViewBack];
    }

    if (_isAgainWrite) {
        // 此时是重写进入页面，需要显示原来的数据
        if (_isTextView) {
            self.inputText.text = self.detailModel.textContent; // 赋值
            self.textString = self.detailModel.textContent; // 文字值
            self.textNumLabel.text = NSLocalizableString(@"requirementsMet", nil);
        }
        if (self.detailModel.attachments.count != 0) {
            for (HomeworkDetailAttachmentModel *model in self.detailModel.attachments) {
                HomeworkImageModel *imageModel = [HomeworkImageModel new];
                imageModel.isAgainWrite = YES;
                if (model.type == 1) {
                    imageModel.againFileType = HICHomeworkAgainFileType_video;
                }else if (model.type == 2) {
                    imageModel.againFileType = HICHomeworkAgainFileType_voic;
                }else if (model.type == 3) {
                    imageModel.againFileType = HICHomeworkAgainFileType_string;
                }else if (model.type == 4) {
                    imageModel.againFileType = HICHomeworkAgainFileType_image;
                }else {
                    imageModel.againFileType = HICHomeworkAgainFileType_unknow;
                }
                imageModel.attachmentModel = model;
                [self.imageDatas addObject:imageModel];
            }
            if (_isTextView) {
                [self changeImageViewShow:YES];
                self.collectionView.hidden = NO;
            }
        }
    }

    // 设置图片展示时使用 --
//    _isShowImageView = NO;
//    [self changeTextAndNumFrame];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

-(void)dealloc {
    // 注销到所有的通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 创建View
// 导航栏
-(void)createNavUI {
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, HIC_StatusBar_Height, HIC_ScreenWidth, HIC_NavBarHeight)];
    [self.view addSubview:backView];

    UIButton *goBackBtn = [[UIButton alloc] init];
    [backView addSubview:goBackBtn];
    goBackBtn.frame = CGRectMake(0, 0, 12 + 16 + 16, HIC_NavBarHeight);
    goBackBtn.tag = 10000;
    [goBackBtn addTarget:self action:@selector(clickLeftBut:) forControlEvents:UIControlEventTouchUpInside];

    UIImageView *goBackIV = [[UIImageView alloc] init];
    [goBackBtn addSubview:goBackIV];
    goBackIV.frame = CGRectMake(16, (HIC_NavBarHeight- 22)/2, 12, 22);
    goBackIV.image = [UIImage imageNamed:@"返回"];

    UILabel *titleLabel = [[UILabel alloc] init];
    [backView addSubview:titleLabel];
    CGSize titleSize = [HICCommonUtils sizeOfString:NSLocalizableString(@"writeHomework", nil) stringWidthBounding:HIC_ScreenWidth - 44 * 2 font:18 stringOnBtn:NO fontIsRegular:NO];
    titleLabel.text = NSLocalizableString(@"writeHomework", nil);
    titleLabel.font = FONT_MEDIUM_18;
    titleLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    titleLabel.frame = CGRectMake((HIC_ScreenWidth - titleSize.width)/2, (HIC_NavBarHeight - 25)/2, titleSize.width, 25);

    UIButton *rightBtn = [[UIButton alloc] init];
    [backView addSubview:rightBtn];
    rightBtn.frame = CGRectMake(HIC_ScreenWidth - (16 + 32 + 16), 0, 16 + 32 + 16, HIC_NavBarHeight);
    [rightBtn addTarget:self action:@selector(clickRightBut:) forControlEvents:UIControlEventTouchUpInside];

    UILabel *rightLabel = [[UILabel alloc] init];
    [rightBtn addSubview:rightLabel];
    rightLabel.frame = CGRectMake(16, (HIC_NavBarHeight - 22.5)/2, 32, 22.5);
    rightLabel.text = NSLocalizableString(@"submit", nil);
    rightLabel.textColor = [UIColor colorWithRed:3/255.0 green:179/255.0 blue:204/255.0 alpha:1/1.0];
    rightLabel.font = FONT_MEDIUM_16

    UIView *naviBtmLine = [[UIView alloc] initWithFrame:CGRectMake(0, HIC_NavBarHeight - 0.5, HIC_ScreenWidth, 0.5)];
    [backView addSubview:naviBtmLine];
    naviBtmLine.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1/1.0];
}

-(void)createWarnView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, HIC_StatusBar_Height+HIC_NavBarHeight, HIC_ScreenWidth, 24)];
    view.backgroundColor = [UIColor colorWithHexString:@"#ebebeb"];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, HIC_ScreenWidth-32, 24)];
    label.textColor = [UIColor colorWithHexString:@"#999999"];
    label.font = FONT_REGULAR_13;
    [view addSubview:label];

    [self.view addSubview:view];
    NSMutableString *str = [NSMutableString string];
    if (self.detailModel.audioNumMax == 0 && self.detailModel.videoNumMax == 0 && self.detailModel.picNumMax == 0) {
        label.text = @"";
    }else {
        if (self.detailModel.audioNumMax != 0) {
            [str appendFormat:@"%ld%@, ",(long)self.detailModel.audioNumMax,NSLocalizableString(@"audio", nil)];
        }
        if (self.detailModel.videoNumMax != 0) {
            [str appendFormat:@"%ld%@, ",(long)self.detailModel.videoNumMax,NSLocalizableString(@"video", nil)];
        }
        if (self.detailModel.picNumMax != 0) {
            [str appendFormat:@"%ld%@ ",(long)self.detailModel.picNumMax,NSLocalizableString(@"picture", nil)];
        }
        label.text = [NSString stringWithFormat:@"%@%@", NSLocalizableString(@"maximumUploadsAllowed", nil),[str copy]];
    }

}

-(void)createTextView {
    CGFloat textHeight = _isToolBar ? HIC_ScreenHeight-TextViewTop-TextViewBottom-ToolBarHeight-HIC_BottomHeight:HIC_ScreenHeight-TextViewTop-TextViewBottom-HIC_BottomHeight;
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(16, TextViewTop, HIC_ScreenWidth-32, textHeight)];
    [self.view addSubview:textView];
    textView.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
//    textView.returnKeyType = UIReturnKeyDone;
    self.inputText = textView;
    textView.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange:) name:UITextViewTextDidChangeNotification object:nil];

    // _placeholderLabel
    UILabel *placeHolderLabel = [[UILabel alloc] init];
    placeHolderLabel.text = [NSString isValidStr:self.detailModel.jobReminder]?self.detailModel.jobReminder:NSLocalizableString(@"pleaseEnterContent", nil);
    placeHolderLabel.numberOfLines = 0;
    placeHolderLabel.textColor = [UIColor lightGrayColor];
    [placeHolderLabel sizeToFit];
    [textView addSubview:placeHolderLabel];

    // same font
    textView.font = [UIFont systemFontOfSize:15.f];
    placeHolderLabel.font = [UIFont systemFontOfSize:15.f];
    [textView setValue:placeHolderLabel forKey:@"_placeholderLabel"];

    UILabel *textViewNum = [[UILabel alloc] initWithFrame:CGRectMake(16, textView.Y+textView.height+3, HIC_ScreenWidth-32, TextViewNumHeight)];
    textViewNum.textColor = [UIColor colorWithHexString:@"#b9b9b9"];
    textViewNum.font = FONT_REGULAR_14;
    textViewNum.textAlignment = NSTextAlignmentRight;
    textViewNum.text = [NSString stringWithFormat:@"%@%ld", NSLocalizableString(@"left", nil),(long)self.detailModel.wordsNumMin];
    UIToolbar * toobar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, HIC_ScreenWidth, 44.0f)];
    toobar.backgroundColor = UIColor.whiteColor;
        toobar.translucent = YES;
        toobar.barStyle = UIBarStyleDefault;
        UIBarButtonItem * spaceBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem * doneBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizableString(@"complete", nil) style:UIBarButtonItemStyleDone target:self action:@selector(resignKeyboard)];
        [toobar setItems:@[spaceBarButtonItem,doneBarButtonItem]];
    textView.inputAccessoryView = toobar;
    self.textview = textView;
    [self.view addSubview:textViewNum];
    self.textNumLabel = textViewNum;
    [self addKeyboardNotifaction];
}
- (void)resignKeyboard{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}
-(void)createToolBut {
    UIView *toolView = [[UIView alloc] initWithFrame:CGRectMake(0, HIC_ScreenHeight-HIC_BottomHeight-ToolBarHeight, HIC_ScreenWidth, ToolBarHeight)];
    for (NSInteger i = 0; i < _toolBarButs.count; i++) {
        NSString *name = [_toolBarButs objectAtIndex:i];
        UIButton *but = [[UIButton alloc] initWithFrame:CGRectMake(16+ToolBarHeight*i+10*i, 0, ToolBarHeight, ToolBarHeight)];
        if ([name isEqualToString:Write_Photo]) {
            [but setImage:[UIImage imageNamed:@"作业-上传照片"] forState:UIControlStateNormal];
        } else if ([name isEqualToString:Write_Carme]) {
            [but setImage:[UIImage imageNamed:@"作业-拍照"] forState:UIControlStateNormal];
        } else if ([name isEqualToString:Write_Video]) {
            [but setImage:[UIImage imageNamed:@"作业-录制视频"] forState:UIControlStateNormal];
        } else if ([name isEqualToString:Write_Voice]) {
            [but setImage:[UIImage imageNamed:@"作业-录音"] forState:UIControlStateNormal];
        }
        but.tag = i+Write_Tool_Bar_Tag;
        but.layer.cornerRadius = 2.f;
        but.layer.masksToBounds = YES;
        [but addTarget:self action:@selector(clickToolBut:) forControlEvents:UIControlEventTouchUpInside];
        [toolView addSubview:but];
    }
    [self.view addSubview:toolView];
    self.toolBarView = toolView;
}

-(void)createOnleToolBut {
    UIView *toolView = [[UIView alloc] initWithFrame:CGRectMake(0, HIC_ScreenHeight-HIC_BottomHeight-ToolBarHeight-16, HIC_ScreenWidth, ToolBarHeight)];
    // 创建的 工具页面需要根据工具按钮的个数来确定
    NSInteger toolCount = _toolBarButs.count;
    CGFloat toolWidth = (HIC_ScreenWidth-32-(toolCount-1)*10)/(CGFloat)toolCount;
    for (NSInteger i = 0; i < toolCount; i++) {
        NSString *name = [_toolBarButs objectAtIndex:i];
        UIButton *but = [[UIButton alloc] initWithFrame:CGRectMake(16+toolWidth*i+10*i, 0, toolWidth, ToolBarHeight)];
        if ([name isEqualToString:Write_Photo]) {
            [but setImage:[UIImage imageNamed:@"作业-上传照片"] forState:UIControlStateNormal];
        } else if ([name isEqualToString:Write_Carme]) {
            [but setImage:[UIImage imageNamed:@"作业-拍照"] forState:UIControlStateNormal];
        } else if ([name isEqualToString:Write_Video]) {
            [but setImage:[UIImage imageNamed:@"作业-录制视频"] forState:UIControlStateNormal];
        } else if ([name isEqualToString:Write_Voice]) {
            [but setImage:[UIImage imageNamed:@"作业-录音"] forState:UIControlStateNormal];
        }
        but.layer.cornerRadius = 2.f;
        but.layer.masksToBounds = YES;
        but.tag = i+Write_Tool_Bar_Tag;
        [toolView addSubview:but];
        [but setBackgroundColor:[UIColor whiteColor]];
        [but addTarget:self action:@selector(clickToolBut:) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.view addSubview:toolView];
    self.toolBarView = toolView;
}

-(void)createImageViewBack {
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.itemSize = CGSizeMake(82, 82);
    layout.minimumLineSpacing = 10.f;
    layout.minimumInteritemSpacing = 1.f;
    layout.sectionInset = UIEdgeInsetsMake(5, 16, 5, 16);
    CGFloat top = _isTextView?HIC_ScreenHeight-ToolBarHeight-ImageBackHeight-HIC_BottomHeight:TextViewTop;
    CGFloat collHeight = _isTextView?ImageBackHeight:HIC_ScreenHeight-ToolBarHeight-TextViewTop-HIC_BottomHeight-16;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, top, HIC_ScreenWidth, collHeight) collectionViewLayout:layout];
    if (_isTextView) {
        collectionView.hidden = YES;
    }
    [self.view addSubview:collectionView];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
    [collectionView registerClass:HomeworkImageViewCell.class forCellWithReuseIdentifier:@"ImageCell"];
    self.collectionView = collectionView;
}

#pragma mark - 页面逻辑处理事件
-(void)showAlertPhoto {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizableString(@"prompt", nil) message:NSLocalizableString(@"chooseVideoOrPicture", nil) preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:NSLocalizableString(@"enterPicture", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self openPhotoImage];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:NSLocalizableString(@"enterVideo", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self openPhotoVideo];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizableString(@"cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

    }];
    [alert addAction:action1];
    [alert addAction:action2];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:^{

    }];
}

#pragma mark - 位置转换
// 显示增加的图片时的操作
-(void)changeTextAndNumFrame {
    CGRect frame = self.inputText.frame;
    if (_isShowImageView) {
        frame.size.height -= ImageBackHeight;
    }else {
        frame.size.height += ImageBackHeight;
    }
    self.inputText.frame = frame;
    CGRect numFrame = self.textNumLabel.frame;
    numFrame.origin.y = self.inputText.Y+self.inputText.height;
    self.textNumLabel.frame = numFrame;
}
// 键盘的弹出和收起时视图的变化
-(void)keyboardChangeViewWith:(CGFloat)height show:(BOOL)isShow{
    CGRect toolFrame = self.toolBarView.frame;
    if (isShow) {
        toolFrame.origin.y = HIC_ScreenHeight - height - ToolBarHeight;
    }else {
        toolFrame.origin.y = HIC_ScreenHeight - ToolBarHeight - HIC_BottomHeight;
    }

    self.toolBarView.frame = toolFrame;

    CGSize size = self.inputText.size;
    CGFloat imageHeight = _isShowImageView? ImageBackHeight:0;
    CGFloat toolBarHeight = _isToolBar?ToolBarHeight:0;
    if (isShow) {
        size.height = HIC_ScreenHeight-height-TextViewTop-TextViewBottom-imageHeight-toolBarHeight;
    }else {
        size.height = HIC_ScreenHeight-TextViewTop-TextViewBottom-imageHeight-HIC_BottomHeight-toolBarHeight;
    }
    self.inputText.size = size;
    CGRect numFrame = self.textNumLabel.frame;
    numFrame.origin.y = self.inputText.Y+self.inputText.height;
    self.textNumLabel.frame = numFrame;

    CGRect imageFrame = self.collectionView.frame;
    imageFrame.origin.y = self.toolBarView.Y-ImageBackHeight;
    self.collectionView.frame = imageFrame;

}
// 更改工具条增加图片的操作
-(void)changeImageViewShow:(BOOL)isShow {
    if (_isTextView) {
        _isShowImageView = isShow;
        self.collectionView.hidden = !_isShowImageView;
        [self changeTextAndNumFrame];
    }
}

#pragma mark - 提交提示
-(void)alertCommentWithMsg:(NSString *)msg sure:(void(^)(BOOL isSure))block {
    UIAlertController *aVC = [UIAlertController alertControllerWithTitle:NSLocalizableString(@"prompt", nil) message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:NSLocalizableString(@"determine", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (block) {
            block(YES);
        }
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizableString(@"cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (block) {
            block(NO);
        }
    }];
    [aVC addAction:sure];
    [aVC addAction:cancel];
    [self presentViewController:aVC animated:YES completion:^{

    }];
}

#pragma mark - 页面的点击事件
- (void)clickLeftBut:(UIButton *)but {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizableString(@"prompt", nil) message:NSLocalizableString(@"exitEditPrompt", nil) preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *sure = [UIAlertAction actionWithTitle:NSLocalizableString(@"determine", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizableString(@"cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

    }];
    [alert addAction:sure];
    [alert addAction:cancel];

    [self presentViewController:alert animated:YES completion:^{

    }];
}
-(void)clickRightBut:(UIButton *)but {
    [self.view endEditing:YES];

    if (_isTextView) {
        // 需要输入文字的
        if (!self.textString || self.textString.length < self.detailModel.wordsNumMin) {
            [HICToast showAtDefWithText:NSLocalizableString(@"enterMoreThanSpecifiedNumberWords", nil)];
            return;
        }
    }
    if (self.detailModel.reviewFlag == 1) {
        [self alertCommentWithMsg:NSLocalizableString(@"sureSubmitHomework", nil) sure:^(BOOL isSure) {
            if (isSure) {
                // 提交作业
                [self commientDataToSever];
            }
        }];
    }else {
        [self alertCommentWithMsg:NSLocalizableString(@"sureSubmitHomeworkPrompt", nil) sure:^(BOOL isSure) {
            if (isSure) {
                // 提交作业
                [self commientDataToSever];
            }
        }];
    }

}

-(void)clickToolBut:(UIButton *)but {

    // 需要根据不同的 形式打开不同的页面
    NSInteger index = but.tag - Write_Tool_Bar_Tag;
    if (index < _toolBarButs.count) {
        NSString *str = [_toolBarButs objectAtIndex:index];
        if ([str isEqualToString:Write_Photo]) {
            if (_isVideoAndCarme) {
                // 存在视频和图片
                [self showAlertPhoto];
            }else {
                if ([_toolBarButs containsObject:Write_Video]) {
                    [self openPhotoVideo];
                }else if ([_toolBarButs containsObject:Write_Carme]) {
                    [self openPhotoImage];
                }
            }
        }else if ([str isEqualToString:Write_Carme]) {
            [self openCarme];
        }else if ([str isEqualToString:Write_Video]) {
            [self openCarmeVideo];
        }else if ([str isEqualToString:Write_Voice]) {
            [self openRecordView];
        }
    }
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - 页面事件处理
// FIXME: 键盘监听
- (void)addKeyboardNotifaction{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];//键盘将要显示
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];//键盘将要消失
}

// FIXME: 键盘将要出现
- (void)keyboardWillShow:(NSNotification *)notification{
    //获取键盘的高度
    NSDictionary *userInfo = [notification userInfo];
    NSValue *keyboardValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [keyboardValue CGRectValue];
    CGFloat height = CGRectGetHeight(keyboardRect);
     //做自定义事件
    [self keyboardChangeViewWith:height show:YES];
}

// FIXME: 键盘将要消失
- (void)keyboardWillHide:(NSNotification *)notification{

    //获取键盘的高度
    NSDictionary *userInfo = [notification userInfo];
    NSValue *keyboardValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [keyboardValue CGRectValue];
    CGFloat height = CGRectGetHeight(keyboardRect);
    //做自定义事件
    [self keyboardChangeViewWith:height show:NO];
}

// 打开相机
-(void)openCarme {
    [self.view endEditing:YES];
    NSInteger count = self.imageDatas.count;
    if (count == 0 && self.detailModel.picNumMax > count) {
        self.camera = [[HICOpenCamera alloc] initFromVC:self toVC:nil];
        self.camera.delegate = self;
    }else if (self.detailModel.picNumMax == 0) {
        [HICToast showAtDefWithText:NSLocalizableString(@"canNotUploadPicture", nil)];
    }else {
        NSInteger picNum = 0;
        for (HomeworkImageModel *model in self.imageDatas) {
            if (model.type == HMBMessageFileType_image) {
                picNum += 1;
            }else if (model.againFileType == HICHomeworkAgainFileType_image) {
                picNum += 1;
            }
        }
        if (picNum>=self.detailModel.picNumMax) {
            [HICToast showAtDefWithText:NSLocalizableString(@"exceededUploadedImagesNumber", nil)];
        }else {
            self.camera = [[HICOpenCamera alloc] initFromVC:self toVC:nil];
            self.camera.delegate = self;
        }
    }

}

// 打开相册
-(void)openPhotoImage {

    [self.view endEditing:YES];
    NSInteger count = self.imageDatas.count;
    if (count == 0 && self.detailModel.picNumMax > count) {
        HICPhotoPickerVC *vc = [[HICPhotoPickerVC alloc] init];
        vc.delegate = self;
        // TODO: 需要解析当前存在几张图片
        vc.maximumPhoto = [NSString stringWithFormat:@"%ld", (long)self.detailModel.picNumMax-1];
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:vc animated:YES completion:nil];
    }else if (self.detailModel.picNumMax == 0) {
        [HICToast showAtDefWithText:NSLocalizableString(@"canNotUploadPicture", nil)];
    }else {
        NSInteger picNum = 0;
        for (HomeworkImageModel *model in self.imageDatas) {
            if (model.type == HMBMessageFileType_image) {
                picNum += 1;
            }else if (model.againFileType == HICHomeworkAgainFileType_image) {
                picNum += 1;
            }
        }
        if (picNum>=self.detailModel.picNumMax) {
            [HICToast showAtDefWithText:NSLocalizableString(@"exceededUploadedImagesNumber", nil)];
        }else {
            HICPhotoPickerVC *vc = [[HICPhotoPickerVC alloc] init];
            vc.delegate = self;
            // TODO: 需要解析当前存在几张图片
            vc.maximumPhoto = [NSString stringWithFormat:@"%ld", (long)self.detailModel.picNumMax];
            vc.selectedPhotosBefore = picNum+1;
            vc.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:vc animated:YES completion:nil];
        }
    }

}

// 打开相册视频
-(void)openPhotoVideo {

    [self.view endEditing:YES];
    NSInteger count = self.imageDatas.count;
    if (count == 0 && self.detailModel.videoNumMax > count) {
        PhotoVideoPickerVC *vc = [[PhotoVideoPickerVC alloc] init];
        vc.delegate = self;
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:vc animated:YES completion:^{

        }];
    }else if (self.detailModel.videoNumMax == 0) {
        [HICToast showAtDefWithText:NSLocalizableString(@"canNotUploadVideo", nil)];
    }else {
        NSInteger picNum = 0;
        for (HomeworkImageModel *model in self.imageDatas) {
            if (model.type == HMBMessageFileType_video) {
                picNum += 1;
            }else if (model.againFileType == HICHomeworkAgainFileType_video) {
                picNum += 1;
            }
        }
        if (picNum>=self.detailModel.videoNumMax) {
            [HICToast showAtDefWithText:NSLocalizableString(@"exceededUploadedVideoNumber", nil)];
        }else {
            PhotoVideoPickerVC *vc = [[PhotoVideoPickerVC alloc] init];
            vc.delegate = self;
            vc.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:vc animated:YES completion:^{

            }];
        }
    }
}

// 打开相机拍摄视频
-(void)openCarmeVideo {
    [self.view endEditing:YES];
    NSInteger count = self.imageDatas.count;
    if (count == 0 && self.detailModel.videoNumMax > count) {
        MessageBoardVideoVC *vc = [MessageBoardVideoVC new];
        vc.maxSeconds = 15.f;
        __weak typeof(self) weakSelf = self;
        vc.finishBlock = ^(id  _Nonnull content, NSString * _Nonnull duration) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if ([content isKindOfClass:NSString.class]) {
                NSInteger size = [strongSelf getVideoSizeWithPath:content];
                if (size > strongSelf.detailModel.videoSizeMax*1024*1024) {
                    [HICToast showAtDefWithText:[NSString stringWithFormat:@"%@%ldM",NSLocalizableString(@"videoCannotExceed", nil), (long)strongSelf.detailModel.videoSizeMax]];
                    return;
                }
                [strongSelf commitDataWithType:HMBMessageFileType_video andImage:nil andFilePath:content];
//                HomeworkImageModel *model = [HomeworkImageModel createModelWith:HMBMessageFileType_video filePath:content image:nil];
//                [strongSelf.imageDatas addObject:model];
//                [strongSelf.collectionView reloadData];
//                if (strongSelf.imageDatas.count >= 1 && !strongSelf.isShowImageView) {
//                    [strongSelf changeImageViewShow:YES];
//                }
            }
        };
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:vc animated:YES completion:nil];
    }else if (self.detailModel.videoNumMax == 0) {
        [HICToast showAtDefWithText:NSLocalizableString(@"canNotUploadVideo", nil)];
    }else {
        NSInteger picNum = 0;
        for (HomeworkImageModel *model in self.imageDatas) {
            if (model.type == HMBMessageFileType_video) {
                picNum += 1;
            }else if(model.againFileType == HICHomeworkAgainFileType_video) {
                picNum += 1;
            }
        }
        if (picNum>=self.detailModel.videoNumMax) {
            [HICToast showAtDefWithText:NSLocalizableString(@"exceededUploadedVideoNumber", nil)];
        }else {
            MessageBoardVideoVC *vc = [MessageBoardVideoVC new];
            vc.maxSeconds = 15.f;
            __weak typeof(self) weakSelf = self;
            vc.finishBlock = ^(id  _Nonnull content, NSString * _Nonnull duration) {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                if ([content isKindOfClass:NSString.class]) {
                    NSInteger size = [strongSelf getVideoSizeWithPath:content];
                    if (size > strongSelf.detailModel.videoSizeMax*1024*1024) {
                        [HICToast showAtDefWithText:[NSString stringWithFormat:@"%@%ldM",NSLocalizableString(@"videoCannotExceed", nil), (long)strongSelf.detailModel.videoSizeMax]];
                        return;
                    }
                    [strongSelf commitDataWithType:HMBMessageFileType_video andImage:nil andFilePath:content];
//                    HomeworkImageModel *model = [HomeworkImageModel createModelWith:HMBMessageFileType_video filePath:content image:nil];
//                    [strongSelf.imageDatas addObject:model];
//                    [strongSelf.collectionView reloadData];
//                    if (strongSelf.imageDatas.count >= 1 && !strongSelf.isShowImageView) {
//                        [strongSelf changeImageViewShow:YES];
//                    }
                }
            };
            vc.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:vc animated:YES completion:nil];
        }
    }
}

// 打开录音界面
-(void)openRecordView {

    [self.view endEditing:YES];
    NSInteger count = self.imageDatas.count;
    if (count == 0 && self.detailModel.audioNumMax > count) {
        _recordView = [[HomewrokRecordView alloc] initWithFrame:self.view.bounds];
        _recordView.maxSeconds = self.detailModel.audioAppDurationMax;
        _recordView.delegate = self;
        [self.view addSubview:_recordView];
    }else if (self.detailModel.audioNumMax == 0) {
        [HICToast showAtDefWithText:NSLocalizableString(@"canNotUploadAudio", nil)];
    }else {
        NSInteger picNum = 0;
        for (HomeworkImageModel *model in self.imageDatas) {
            if (model.type == HMBMessageFileType_wav) {
                picNum += 1;
            }else if (model.againFileType == HICHomeworkAgainFileType_voic) {
                picNum += 1;
            }
        }
        if (picNum>=self.detailModel.audioNumMax) {
            [HICToast showAtDefWithText:NSLocalizableString(@"exceededUploadedAudioNumber", nil)];
        }else {
            _recordView = [[HomewrokRecordView alloc] initWithFrame:self.view.bounds];
            _recordView.maxSeconds = self.detailModel.audioAppDurationMax;
            _recordView.delegate = self;
            [self.view addSubview:_recordView];
        }
    }


}

#pragma mark - TextView协议方法
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {

    NSMutableString *str = [NSMutableString stringWithString:textView.text];
    [str appendString:text];
    if ([textView.text isEqualToString:@""]) {
        return YES;
    }

    return YES;
}
-(void)textViewDidEndEditing:(UITextView *)textView {

    self.textString = textView.text;
}
-(void)textChange:(NSNotification *)note{

        NSInteger Max_Num_TextView = self.detailModel.wordsNumMin;
        //获取当前键盘类型
        UITextInputMode *mode = (UITextInputMode *)[UITextInputMode activeInputModes][0];

        //获取当前键盘语言
        NSString *lang = mode.primaryLanguage;

        self.isTextViewEnable = true;

        //如果语言是汉语(拼音)
        if ([lang isEqualToString:@"zh-Hans"])
            {

                    //取到高亮部分范围
                    UITextRange *selectedRange = [self.inputView markedTextRange];

                    //取到高亮部分
                    UITextPosition *position = [self.inputView positionFromPosition:selectedRange.start offset:0];

                    //如果取不到高亮部分,代表没有拼音
                    if (!position){

                            //当期超过最大限制时
                            if (self.inputText.text.length >= Max_Num_TextView) {

                                    //对超出部分进行裁剪
//                                    self.inputText.text = [self.inputText.text substringToIndex:Max_Num_TextView];

                                    //同时对可继续书写属性设为否,shouldChangeTextInRange方法会调用
                                    self.isTextViewEnable = NO;

                                    //同时将下方提示label设置为0
                                self.textNumLabel.text = NSLocalizableString(@"requirementsMet", nil);
                            }else {
                                //如果没超出,那么就计算剩余字数
                                self.textNumLabel.text = [NSString stringWithFormat:@"%@%lu", NSLocalizableString(@"left", nil),(unsigned long)Max_Num_TextView - self.inputText.text.length];
                            }

                        }else{
                                //表示还有高亮部分，暂不处理
                            }

                }else{
                        //如果语言不是汉语,直接计算
                        if (self.inputText.text.length >= Max_Num_TextView) {

//                                self.inputText.text = [self.inputText.text substringToIndex:Max_Num_TextView];
                                self.isTextViewEnable = NO;

                                 self.textNumLabel.text = NSLocalizableString(@"requirementsMet", nil);

                        }else {
                            self.textNumLabel.text = [NSString stringWithFormat:@"%@%lu", NSLocalizableString(@"left", nil),(unsigned long)Max_Num_TextView - self.inputText.text.length];
                        }
                    }

}

#pragma mark - 图片CollectionCell的协议方法
-(void)imageViewCell:(HomeworkImageViewCell *)cell clickDeleateBut:(UIButton *)but model:(HomeworkImageModel *)model {
    [self.imageDatas removeObject:model];
    [self.collectionView reloadData];
    if (self.imageDatas.count == 0) {
        [self changeImageViewShow:NO];
    }
}

#pragma mark - CollectionDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imageDatas.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HomeworkImageViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageCell" forIndexPath:indexPath];

    cell.model = self.imageDatas[indexPath.row];
    cell.delegate = self;

    return cell;
}

#pragma mark - collectionDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    HomeworkImageModel *model = [self.imageDatas objectAtIndex:indexPath.row];
    if (model.isAgainWrite && (model.againFileType == HICHomeworkAgainFileType_voic || model.againFileType == HICHomeworkAgainFileType_video)) {
        if (model.attachmentModel.url) {
            AVPlayerViewController *vc = [AVPlayerViewController new];
            vc.player = [AVPlayer playerWithURL:[NSURL URLWithString:model.attachmentModel.url]];
            [vc.player play];
            vc.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:vc animated:YES completion:nil];
        }
    }else if (model.type == HMBMessageFileType_wav || model.type == HMBMessageFileType_video) {
        if (model.filePath) {
            AVPlayerViewController *vc = [AVPlayerViewController new];
            AVAsset *asset = [AVAsset assetWithURL:[NSURL fileURLWithPath:model.filePath]];
            AVPlayerItem *item = [AVPlayerItem playerItemWithAsset:asset];
            vc.player = [AVPlayer playerWithPlayerItem:item];
            [vc.player play];
            vc.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:vc animated:YES completion:nil];
        }
    }else {
        HomeworkImagePreViewVC *vc = [HomeworkImagePreViewVC new];
        vc.currentIndex = indexPath.row;
        vc.imageDataSource = self.imageDatas;
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:vc animated:YES completion:^{

        }];
    }

}

#pragma mark - 相册、相机的协议方法
-(void)takePhotoResult:(NSArray *)photoArr {
    // 1. 获取相机信息
    if (photoArr.count > 0) {
        NSMutableArray *imags = [NSMutableArray array];
        for (UIImage *image in photoArr) {
            NSData *data = UIImagePNGRepresentation(image);
            if (!data || data.length == 0) {
                data = UIImageJPEGRepresentation(image, 0.5);
            }
            if (data.length > self.detailModel.picSizeMax*1024*1024) {
                [HICToast showAtDefWithText:[NSString stringWithFormat:@"%@%ldM", NSLocalizableString(@"selectedPictureCannotExceed", nil),(long)self.detailModel.picSizeMax]];
                continue;
            }
//            NSDictionary *dic = [self commitData];
//            HomeworkImageModel *model = [HomeworkImageModel createModelWith:HMBMessageFileType_image filePath:nil image:image];
//            model.imageName = [NSString stringWithFormat:@"%@.png", [HICCommonUtils getTimeWithZone]];
//            [self.imageDatas addObject:model];
            [imags addObject:image];

        }
        if (imags.count > 0) {
            [self commitDataWithType:HMBMessageFileType_image andImage:[imags copy] andFilePath:nil];
        }
    }

}

-(void)photoSelecedDone:(NSArray *)arr {

    NSInteger picNum = 0;
    for (HomeworkImageModel *model in self.imageDatas) {
        if (model.type == HMBMessageFileType_image) {
            picNum += 1;
        }else if (model.againFileType == HICHomeworkAgainFileType_image) {
            picNum += 1;
        }
    }
    NSInteger lastNum = self.detailModel.picNumMax - picNum;
    // 1. 获取相册信息
    if (arr.count > 0) {
        NSInteger i = 0;
        NSMutableArray *imags = [NSMutableArray array];
        for (UIImage *image in arr) {
            NSData *data = UIImagePNGRepresentation(image);
            if (!data || data.length == 0) {
                data = UIImageJPEGRepresentation(image, 0.8);
            }
            if (data.length > self.detailModel.picSizeMax*1024*1024) {
                [HICToast showAtDefWithText:[NSString stringWithFormat:@"%@%ldM", NSLocalizableString(@"selectedPictureCannotExceed", nil),(long)self.detailModel.picSizeMax]];
                continue;
            }
            if (i+1>lastNum) {
                [HICToast showAtDefWithText:[NSString stringWithFormat:@"%@%ld%@", NSLocalizableString(@"selectedPictureCannotExceed", nil),(long)self.detailModel.picNumMax,NSLocalizableString(@"zhang", nil)]];
                break;
            }
//            HomeworkImageModel *model = [HomeworkImageModel createModelWith:HMBMessageFileType_image filePath:nil image:image];
//            model.imageName = [NSString stringWithFormat:@"%@.png", [HICCommonUtils getTimeWithZone]];
//            [self.imageDatas addObject:model];
//            [self.collectionView reloadData];
            [imags addObject:image];
            i++;
        }
        if (imags.count > 0) {
            [self commitDataWithType:HMBMessageFileType_image andImage:[imags copy] andFilePath:nil];
        }
    }
//    if (self.imageDatas.count >= 1 && !_isShowImageView) {
//        [self changeImageViewShow:YES];
//    }
}
-(void)videoPickerVC:(PhotoVideoPickerVC *)vc clickVideoFile:(NSString *)videoFile durat:(NSInteger)second ratio:(CGFloat)ratio {

    DDLogDebug(@"%@ --", videoFile);
    NSInteger size = [self getVideoSizeWithPath:videoFile];
    if (size > self.detailModel.videoSizeMax*1024*1024) {
        [HICToast showAtDefWithText:[NSString stringWithFormat:@"%@%ldM",NSLocalizableString(@"videoCannotExceed", nil), (long)self.detailModel.videoSizeMax]];
        return;
    }

    [self commitDataWithType:HMBMessageFileType_video andImage:nil andFilePath:videoFile];

//    HomeworkImageModel *model = [HomeworkImageModel createModelWith:HMBMessageFileType_video filePath:videoFile image:nil];
//    [self.imageDatas addObject:model];
//    [self.collectionView reloadData];
//
//    if (self.imageDatas.count >= 1 && !_isShowImageView) {
//        [self changeImageViewShow:YES];
//    }

}

// 语音的协议方法
-(void)recordView:(HomewrokRecordView *)view sendVoiceName:(NSString *)voiceName voicePath:(NSString *)voicePath other:(id)data {
    DDLogDebug(@"%@ --", voicePath);
    //判断本地是否存在WAV
    if (![[NSFileManager defaultManager] fileExistsAtPath:voicePath]) {
        //不存在此条语音进行转换 AMR ——> WAV
        [EMVoiceConverter amrToWav:[HICCommonUtils getFilePathWithName:voiceName type:HMBMessageFileType_amr] wavSavePath:voicePath];
    }
    NSInteger size = [self getVideoSizeWithPath:voicePath];
    if (size > self.detailModel.audioWebSizeMax*1024*1024) {
        [HICToast showAtDefWithText:[NSString stringWithFormat:@"选择的音频不能超过%ldM", (long)self.detailModel.audioWebSizeMax]];
        return;
    }
    [self commitDataWithType:HMBMessageFileType_wav andImage:nil andFilePath:voicePath];
//    HomeworkImageModel *model = [HomeworkImageModel createModelWith:HMBMessageFileType_wav filePath:voicePath image:nil];
//    [self.imageDatas addObject:model];
//    [self.collectionView reloadData];
//
//    if (self.imageDatas.count >= 1 && !_isShowImageView) {
//        [self changeImageViewShow:YES];
//    }
}

#pragma mark - 上传文件
//-(void)commitData {
//
//    // 提交文件
//    NSMutableArray *fileDatas = [NSMutableArray array];
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        if (_imageDatas.count != 0) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [RoleManager showWindowLoadingView];
//            });
//            // 需要上传文件到服务器
//            for (HomeworkImageModel *model in _imageDatas) {
//                if (model.isAgainWrite) {
//                    // 是撤回编辑后的页面提交数据，不需要上传文件
//                    continue;
//                }
//                if (model.type == HMBMessageFileType_image) {
//                    NSData *imageData = UIImageJPEGRepresentation(model.image, 0.8);
//                    if (imageData.length == 0) {
//                        imageData = UIImagePNGRepresentation(model.image);
//                    }
//                    NSDictionary *dic = [self updateFileToSever:YES fileData:imageData fileName:model.imageName];
//                    if (dic) {
//                        [fileDatas addObject:dic];
//                    }
//                }else if (model.type == HMBMessageFileType_wav || model.type == HMBMessageFileType_video) {
//                    NSData *data = [NSData dataWithContentsOfFile:model.filePath];
//                    NSString *name;
//                    if (model.type == HMBMessageFileType_wav) {
//                        name = [NSString stringWithFormat:@"%@.wav", [HICCommonUtils getNameWithUrl:model.filePath]];
//                    }else {
//                        name = [NSString stringWithFormat:@"%@.mp4", [HICCommonUtils getNameWithUrl:model.filePath]];
//                    }
//                    NSDictionary *dic = [self updateFileToSever:NO fileData:data fileName:name];
//                    if (dic) {
//                        [fileDatas addObject:dic];
//                    }
//                }
//            }
//        }
////        [self commientDataWith:fileDatas];
//    });
//
//}

-(void)commitDataWithType:(HMBMessageFileType)type andImage:(NSArray<UIImage*> *_Nullable)images andFilePath:(NSString *)filePath {

    // 提交文件
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [RoleManager showWindowLoadingView];
        });
        // 需要上传文件到服务器
        if (type == HMBMessageFileType_image) {
            for (UIImage *image in images) {
                NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
                if (imageData.length == 0) {
                    imageData = UIImagePNGRepresentation(image);
                }
                NSString *imageName = [NSString stringWithFormat:@"%@.png", [HICCommonUtils getTimeWithZone]];
                NSDictionary *dic = [self updateFileToSever:YES fileData:imageData fileName:imageName];
                if (dic) {
                    HomeworkImageModel *model = [HomeworkImageModel createModelWith:HMBMessageFileType_image filePath:nil image:image];
                    model.fileDic = dic;
                    [self.imageDatas addObject:model];
                }
            }
        }else if (type == HMBMessageFileType_wav || type == HMBMessageFileType_video) {
            NSData *data = [NSData dataWithContentsOfFile:filePath];
            NSString *name;
            if (type == HMBMessageFileType_wav) {
                name = [NSString stringWithFormat:@"%@.wav", [HICCommonUtils getNameWithUrl:filePath]];
            }else {
                name = [NSString stringWithFormat:@"%@.mp4", [HICCommonUtils getNameWithUrl:filePath]];
            }
            NSDictionary *dic = [self updateFileToSever:NO fileData:data fileName:name];
            if (dic) {
                HomeworkImageModel *model = [HomeworkImageModel createModelWith:type filePath:filePath image:nil];
                model.fileDic = dic;
                [self.imageDatas addObject:model];
            }
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            [RoleManager hiddenWindowLoadingView];
            [self.collectionView reloadData];
            if (self.imageDatas.count >= 1 && !_isShowImageView) {
                [self changeImageViewShow:YES];
            }
        });

    });

}

-(void)commientDataToSever  {

    // 数据一致可以提交
    dispatch_async(dispatch_get_main_queue(), ^{
        [RoleManager showWindowLoadingView];
    });
    NSMutableArray *dataSource = [NSMutableArray array];
    if (self.imageDatas.count != 0) {
        for (HomeworkImageModel *imageMode in self.imageDatas) {
            // 再次提交的数据

            if (imageMode.isAgainWrite) {
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                [dic setValue:imageMode.attachmentModel.url forKey:@"url"];
                [dic setValue:[NSNumber numberWithInteger:imageMode.attachmentModel.type] forKey:@"type"];
                [dataSource addObject:dic];
            }else {
                NSMutableDictionary *par = [NSMutableDictionary dictionary];
                NSInteger type = 0;
                if (imageMode.type == HMBMessageFileType_video) {
                    type = 1;
                }else if(imageMode.type == HMBMessageFileType_wav) {
                    type = 2;
                }else if (imageMode.type == HMBMessageFileType_image) {
                    type = 4;
                }
                NSString *name = [imageMode.fileDic objectForKey:@"name"];
                NSString *url = [imageMode.fileDic objectForKey:@"url"];
                NSNumber *size = [imageMode.fileDic objectForKey:@"size"];
                NSNumber *numType = [NSNumber numberWithInteger:type];
                [par setValue:name forKey:@"name"];
                [par setValue:url forKey:@"url"];
                [par setValue:size forKey:@"size"];
                [par setValue:numType forKey:@"type"];
                [dataSource addObject:par];
            }
        }
    }
    NSDictionary *dic;
    NSString *text;
    if (_isTextView) {
            // @"jobId":[NSNumber numberWithInteger:self.detailModel.jobId],@"workId":[NSNumber numberWithInteger:self.detailVC.workId], @"jobText":self.inputText.text,
        if (dataSource.count != 0) {
            dic = @{ @"attachments":[dataSource copy], @"accessToken":USER_TOKEN};
        }else {
            dic = @{@"accessToken":USER_TOKEN, };
        }
        if (self.textString && self.textString.length >= self.detailModel.wordsNumMin) {
            text = self.textString;
        }else {
            if (dataSource.count == 0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [HICToast showAtDefWithText:NSLocalizableString(@"pleaseEnterRequiredNumberOfWords", nil)];
                    [RoleManager hiddenWindowLoadingView];
                });
                return;
            }
        }
    }else {
        if (dataSource.count != 0) {
            dic = @{ @"attachments":[dataSource copy], @"accessToken":USER_TOKEN};
        }else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [HICToast showAtDefWithText:NSLocalizableString(@"noAnyData", nil)];
                [RoleManager hiddenWindowLoadingView];
            });
            return;
        }
    }
    NSString *url;
    if (text) {
        text = [text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet letterCharacterSet]];
        url = [NSString stringWithFormat:@"1.0/app/train/work/job/save?jobId=%@&workId=%@&jobText=%@&customerId=%@", [NSNumber numberWithInteger:self.detailModel.jobId], [NSNumber numberWithInteger:self.detailVC.workId], text, USER_CID];
    }else {
        url = [NSString stringWithFormat:@"1.0/app/train/work/job/save?jobId=%@&workId=%@&customerId=%@", [NSNumber numberWithInteger:self.detailModel.jobId], [NSNumber numberWithInteger:self.detailVC.workId], USER_CID];
    }
    [HICAPI homeworkSubtaskSubmit:dic url:url success:^(NSDictionary * _Nonnull responseObject) {
        if (self.detailModel.reviewFlag == 1) {
            self.detailVC.status = HICHomeworkWaitForGrading;
        }else {
            self.detailVC.status = HICHomeworkGrading;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [RoleManager hiddenWindowLoadingView];
        });
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [HICToast showAtDefWithText:NSLocalizableString(@"failedToSubmitJob", nil)];
            [RoleManager hiddenWindowLoadingView];
        });
    }];
    
}

//-(void)commientDataWith:(NSArray *)fileData  {
//    NSInteger count = 0;
//    NSInteger againCount = 0;
//    for (HomeworkImageModel *imageModel in self.imageDatas) {
//        if (!imageModel.isAgainWrite) {
//            count += 1;
//        }else {
//            againCount += 1;
//        }
//    }
//    if (count == fileData.count) {
//        // 数据一致可以提交
//        NSMutableArray *dataSource = [NSMutableArray array];
//        if (self.imageDatas.count != 0) {
//            for (HomeworkImageModel *imageMode in self.imageDatas) {
//                // 再次提交的数据
//                if (imageMode.isAgainWrite) {
//                    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//                    [dic setValue:imageMode.attachmentModel.url forKey:@"url"];
//                    [dic setValue:[NSNumber numberWithInteger:imageMode.attachmentModel.type] forKey:@"type"];
//                    [dataSource addObject:dic];
//                }
//            }
//            NSInteger index = 0;
//            // 这是本地上传的来的图片信息
//            for (NSDictionary *dic in fileData) {
//                NSMutableDictionary *par = [NSMutableDictionary dictionary];
//                NSInteger type = 0;
//                HomeworkImageModel *model = [self.imageDatas objectAtIndex:index];
//                if (model.type == HMBMessageFileType_video) {
//                    type = 1;
//                }else if(model.type == HMBMessageFileType_wav) {
//                    type = 2;
//                }else if (model.type == HMBMessageFileType_image) {
//                    type = 4;
//                }
//                NSString *name = [dic objectForKey:@"name"];
//                NSString *url = [dic objectForKey:@"url"];
//                NSNumber *size = [dic objectForKey:@"size"];
//                NSNumber *numType = [NSNumber numberWithInteger:type];
//                [par setValue:name forKey:@"name"];
//                [par setValue:url forKey:@"url"];
//                [par setValue:size forKey:@"size"];
//                [par setValue:numType forKey:@"type"];
//                [dataSource addObject:par];
//            }
//        }
//        NSDictionary *dic;
//        NSString *text;
//        if (_isTextView) {
//            // @"jobId":[NSNumber numberWithInteger:self.detailModel.jobId],@"workId":[NSNumber numberWithInteger:self.detailVC.workId], @"jobText":self.inputText.text,
//            if (dataSource.count != 0) {
//                dic = @{ @"attachments":[dataSource copy], @"accessToken":USER_TOKEN};
//            }else {
//                dic = @{@"accessToken":USER_TOKEN, };
//            }
//            if (self.textString && ![self.textString isEqualToString:@""] && self.textString.length >= self.detailModel.wordsNumMin) {
//                text = self.textString;
//            }else {
//                if (dataSource.count == 0) {
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [HICToast showAtDefWithText:@"请输入规定字数"];
//                        [RoleManager hiddenWindowLoadingView];
//                    });
//                    return;
//                }
//            }
//        }else {
//            if (dataSource.count != 0) {
//                dic = @{ @"attachments":[dataSource copy], @"accessToken":USER_TOKEN};
//            }else {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [HICToast showAtDefWithText:@"没有任何数据"];
//                    [RoleManager hiddenWindowLoadingView];
//                });
//                return;
//            }
//        }
//        NSString *url;
//        if (text) {
//            text = [text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet letterCharacterSet]];
//            url = [NSString stringWithFormat:@"1.0/app/train/work/job/save?jobId=%@&workId=%@&jobText=%@&customerId=%@", [NSNumber numberWithInteger:self.detailModel.jobId], [NSNumber numberWithInteger:self.detailVC.workId], text, USER_CID];
//        }else {
//            url = [NSString stringWithFormat:@"1.0/app/train/work/job/save?jobId=%@&workId=%@&customerId=%@", [NSNumber numberWithInteger:self.detailModel.jobId], [NSNumber numberWithInteger:self.detailVC.workId], USER_CID];
//        }
//        HICNetModel *netModel = [[HICNetModel alloc] initWithURL:url params:dic];
//        netModel.method = HTTPMethodPOST;
//        netModel.contentType = HTTPContentTypeJsonType;
//        netModel.urlType = DefaultCommentURLType;
//        [NetManager sentHTTPRequest:netModel success:^(NSDictionary * _Nonnull responseObject) {
//            if (self.detailModel.reviewFlag == 1) {
//                self.detailVC.status = HICHomeworkWaitForGrading;
//            }else {
//                self.detailVC.status = HICHomeworkGrading;
//            }
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [RoleManager hiddenWindowLoadingView];
//            });
//            [self.navigationController popViewControllerAnimated:YES];
//        } failure:^(NSError * _Nonnull error) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [HICToast showAtDefWithText:@"提交作业失败！"];
//                [RoleManager hiddenWindowLoadingView];
//            });
//        }];
//
//    } else {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [RoleManager hiddenWindowLoadingView];
//            [HICToast showAtDefWithText:@"上传文件失败！"];
//        });
//    }
//}
-(NSDictionary *)updateFileToSever:(BOOL)isImage fileData:(NSData *)fileData fileName:(NSString *)name {
    __block NSDictionary *reponDic;
    NSURL *reqURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/heduopapi/course/file/upload?accessToken=%@", APP_UPLOAD_DOMAIN, USER_TOKEN]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:reqURL];

    NSString *boundary = @"wfWiEWrgEFA9A78512weF7106A";
    request.HTTPMethod = @"POST";
    [request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary] forHTTPHeaderField:@"Content-Type"];
    request.timeoutInterval = 30.f;

    NSMutableData *paramData = [NSMutableData data];
    NSString *fileName = name;
    NSString *fileKey = @"file";
    NSString *filePair = [NSString stringWithFormat:@"--%@\r\nContent-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n\r\n",boundary,fileKey,fileName];
    [paramData appendData:[filePair dataUsingEncoding:NSUTF8StringEncoding]];
    [paramData appendData:fileData]; //加入文件的数据
    [paramData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    //设置结尾
    [paramData appendData:[[NSString stringWithFormat:@"--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    request.HTTPBody = paramData;
    //设置请求头总数据长度
    [request setValue:[NSString stringWithFormat:@"%lu",(unsigned long)paramData.length] forHTTPHeaderField:@"Content-Length"];

        // 上传
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *task;

        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (!error) {
                // 解析数据
                NSError *jsonError;
                NSDictionary *pesDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
                if (!jsonError) {
                    // 正确的解析道服务器数据
                    NSNumber *code = [pesDic objectForKey:@"resultCode"];
                    if ([code isEqualToNumber:@0]) {
                        // 成功
                        reponDic = [pesDic objectForKey:@"data"];
                    }
                }
            } else {
                DDLogError(@"[WebSDK] -- 上传图片失败：%@", error);
            }
            dispatch_semaphore_signal(sema);
        }];

        [task resume];

    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);

    return reponDic;
}

#pragma mark 获取视频size
- (CGFloat)getVideoSizeWithPath:(NSString *)path{

   NSDictionary *dic = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
   return [dic fileSize];
}

#pragma mark - 懒加载

@end
