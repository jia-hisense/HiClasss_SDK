//
//  HICHomeStudyNavView.m
//  iTest
//
//  Created by Sir_Jing on 2020/3/9.
//  Copyright © 2020 Sir_Jing. All rights reserved.
//

#import "HICHomeStudyNavView.h"

@implementation MessageNumModel



@end

@interface HICHomeStudyNavView ()<UITextFieldDelegate>

@property (nonatomic, copy) ClickButBolick clickScan;

@property (nonatomic, copy) ClickButBolick clickSearch;

@property (nonatomic, copy) ClickButBolick clickMessage;

@property (nonatomic, strong) UILabel *numLabel;

@property (nonatomic ,strong)UITextField *searchText;

@end

@implementation HICHomeStudyNavView

-(instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        [self createNavView];
    }
    return self;
}

-(instancetype)initDefault {

    UIApplication *manager = UIApplication.sharedApplication;
    if (self = [super initWithFrame:CGRectMake(0, manager.statusBarFrame.size.height, UIScreen.mainScreen.bounds.size.width, 44)]) {
        [self createNavView];
        self.backgroundColor = UIColor.whiteColor;
    }
    return self;
}

-(instancetype)initDefaultWithClickScan:(ClickButBolick)clickScan clickSearchText:(ClickButBolick)clickSearchText clickMessage:(ClickButBolick)clickMessage {

    self = [[HICHomeStudyNavView alloc] initDefault];

    self.clickScan = clickScan;
    self.clickSearch = clickSearchText;
    self.clickMessage = clickMessage;
    [self loadDataMessageNum];

    return self;
}

-(void)createNavView {

    CGFloat butWH = 24;
    CGFloat screenWidth = UIScreen.mainScreen.bounds.size.width;
    UIButton *scanBut = [[UIButton alloc] initWithFrame:CGRectMake(16, 10, butWH, butWH)];
    [scanBut setImage:[UIImage imageNamed:@"BT-扫一扫"] forState:UIControlStateNormal];
    [scanBut addTarget:self action:@selector(clickScanBut:) forControlEvents:UIControlEventTouchUpInside];

    UIButton *messageBut = [[UIButton alloc] initWithFrame:CGRectMake(screenWidth - 16 - 24, 10, butWH, butWH)];
    [messageBut setImage:[UIImage imageNamed:@"BT-消息"] forState:UIControlStateNormal];
    [messageBut addTarget:self action:@selector(clickMessBut:) forControlEvents:UIControlEventTouchUpInside];

    UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(16+24+16, 4, screenWidth - (16+24+16)*2, 36)];
    searchView.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
    UIImageView *searchLeft = [[UIImageView alloc] initWithFrame:CGRectMake(12, 8, 20, 20)];
    searchLeft.image = [UIImage  imageNamed:@"ICON-搜索框-搜索"];
    [searchView addSubview:searchLeft];
    searchView.layer.cornerRadius = 18;
    searchView.layer.masksToBounds = YES;
    UITextField *searchText = [[UITextField alloc] initWithFrame:CGRectMake(32+4, 3, searchView.bounds.size.width-36-10, 32)];
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:NSLocalizableString(@"searchKeywords", nil) attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#858585"],NSFontAttributeName:searchText.font}];
    searchText.attributedPlaceholder = attrString;
    searchText.delegate = self;
    searchText.font = FONT_REGULAR_15;
    searchText.keyboardType = UIKeyboardTypeWebSearch;
    [searchView addSubview:searchText];
    [self addSubview:scanBut];
    [self addSubview:messageBut];
    [self addSubview:searchView];

    // 红色底View
    UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth-8-20, 3, 18, 18)];
    numLabel.backgroundColor = [UIColor redColor];
    numLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:11];
    numLabel.textColor = [UIColor whiteColor];
    numLabel.textAlignment = NSTextAlignmentCenter;
    numLabel.layer.cornerRadius = 9;
    numLabel.layer.masksToBounds = YES;
    self.numLabel = numLabel;
    self.numLabel.hidden = YES;
    [self addSubview:numLabel];
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {

    DDLogDebug(@"将要开始编辑时调用 -- 可以跳转到搜索页面");
    if (self.clickSearch) {
        self.clickSearch(textField);
    }
    return NO;
}

#pragma mark - 按钮的点击事件
-(void)clickScanBut:(UIButton *)btn {

    if (self.clickScan) {
        self.clickScan(btn);
    }
}

-(void)clickMessBut:(UIButton *)btn {

    if (self.clickMessage) {
        self.clickMessage(btn);
    }
}
#pragma mark - 网络请求
-(void)loadDataMessageNum {
    if (_isRefreshNum) {
        return;
    }
    _isRefreshNum = YES;
    NSDictionary *dic = @{@"messageStatus" : @0};
    [HICAPI loadDataMessageNum:dic success:^(NSDictionary * _Nonnull responseObject) {
        NSDictionary *dic = [responseObject objectForKey:@"data"];
        NSArray *statusCountList = [dic objectForKey:@"statusCountList"];
        NSMutableArray *array = [MessageNumModel mj_objectArrayWithKeyValuesArray:statusCountList];
        for (MessageNumModel *model in array) {
            if (model.status == 0 && model.count != 0) {
                if (model.count <= 99) {
                    self.numLabel.text = [NSString stringWithFormat:@"%ld", (long)model.count];
                    self.numLabel.hidden = NO;
                    self.numLabel.width = 18;
                }else {
                    self.numLabel.text = @"99+";
                    self.numLabel.hidden = NO;
                    self.numLabel.width = 25;
                }
                break;
            }else {
                self.numLabel.text = @"0";
                self.numLabel.hidden = YES;
                self.numLabel.width = 18;
            }
        }
        _isRefreshNum = NO;
    } failure:^(NSError * _Nonnull error) {
        DDLogDebug(@"MessageNum == 错误%@", error.userInfo);
        _isRefreshNum = NO;
    }];
}
@end
