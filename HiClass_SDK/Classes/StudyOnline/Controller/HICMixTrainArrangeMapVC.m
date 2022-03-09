//
//  HICMixTrainArrangeMapVC.m
//  HiClass
//
//  Created by WorkOffice on 2020/6/15.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import "HICMixTrainArrangeMapVC.h"
#import "HICMixTrainArrangeTaskVC.h"
#import "HICMixTrainArrangeModel.h"
#import "OfflineTrainingListModel.h"
#import "HICOfflineTrainInfoVC.h"
@interface HICMixTrainArrangeMapVC ()
@property (nonatomic ,strong)UIScrollView *scrollView;
@property (nonatomic ,strong)NSMutableArray *dataArr;
@property (nonatomic ,strong)HICNetModel *netModel;
@property (nonatomic ,strong)UILabel *titleLabel;
@end
static NSInteger tagNum = 21321;
@implementation HICMixTrainArrangeMapVC
-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, HIC_NavBarAndStatusBarHeight, HIC_ScreenWidth, HIC_ScreenHeight - HIC_BottomHeight- HIC_NavBarAndStatusBarHeight)];
        _scrollView.backgroundColor = [UIColor colorWithHexString:@"#00BED7"];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
    }
    return _scrollView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#00BED7"];
    [self createNavView];
    [self getListData];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = NO;
}
-(void) createNavView {
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, HIC_ScreenWidth, HIC_StatusBar_Height + 44)];
    backView.backgroundColor = [UIColor colorWithHexString:@"#00BED7"];
    UIButton *backbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    backbutton.frame = CGRectMake(16, 11 + HIC_StatusBar_Height, 12, 22);
    [backbutton hicChangeButtonClickLength:30];
    [backbutton setImage:[UIImage imageNamed:@"头部-返回-白色"] forState:UIControlStateNormal];
    [backbutton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:backbutton];
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 10 + HIC_StatusBar_Height, HIC_ScreenWidth - 80, 25)];
    _titleLabel.textColor = UIColor.whiteColor;
    _titleLabel.font = FONT_MEDIUM_18;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    _titleLabel.text = _taskName?_taskName:NSLocalizableString(@"recruitModel", nil);
    [backView addSubview:_titleLabel];
    
    [self.view addSubview:backView];
}
- (void)getListData {
    [HICAPI mixedTrainingArrangement:_trainId success:^(NSDictionary * _Nonnull responseObject) {
        if (responseObject[@"data"] && [responseObject[@"data"] isKindOfClass:NSArray.class]) {
            self.dataArr = [HICMixTrainArrangeModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            [self createUI];
        }
    }];
}
- (void) createUI{
    CGFloat n = HIC_ScreenWidth / 375.0;
    [self.view addSubview:self.scrollView];
    UIImageView *topLeftView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,110, 168)];
    topLeftView.image = [UIImage imageNamed:@"岛-左上按钮"];
    topLeftView.userInteractionEnabled = YES;
    [self.scrollView addSubview:topLeftView];
    UILabel *descLabel = [self createLabel:NSLocalizableString(@"introduction", nil) frame:CGRectMake(10, 53, 72, 28)];
    [topLeftView addSubview:descLabel];
    
    HICMixTrainArrangeModel *model = (HICMixTrainArrangeModel *)self.dataArr.firstObject;
    if (model && [model.syncProgress integerValue] == 1) {
        descLabel.frame = CGRectMake(10, 33, 72, 28);
        UILabel *sysProgressLabel = [self createLabel:NSLocalizableString(@"synchronousProgress", nil) frame:CGRectMake(10, 66, 72, 28)];
        [topLeftView addSubview:sysProgressLabel];
    }
    
    NSInteger  arrCount = self.dataArr.count;
    NSInteger  surplusCount ;
    NSInteger  sCount ;
    if (arrCount  <= 7) {
        surplusCount = 0;
        sCount = 1;
    }else{
        sCount = arrCount / 8;
        surplusCount = (arrCount-7) %8;
    }
    CGFloat height = 692 * sCount *n;
    if (surplusCount == 1) {
        self.scrollView.contentSize = CGSizeMake(HIC_ScreenWidth, height + 62 + 19 + 20);
    }else if (surplusCount == 2){
        self.scrollView.contentSize = CGSizeMake(HIC_ScreenWidth, height + 32  + 191 + 20);
    }else if (surplusCount == 3){
        self.scrollView.contentSize = CGSizeMake(HIC_ScreenWidth, height + 174 + 153 + 20);
    }else if (surplusCount == 4){
        self.scrollView.contentSize = CGSizeMake(HIC_ScreenWidth, height + 80 + 259 + 20);
    }else if (surplusCount == 5){
        self.scrollView.contentSize = CGSizeMake(HIC_ScreenWidth, height + 363.5 + 62 + 20);
    }else if (surplusCount == 6){
        self.scrollView.contentSize = CGSizeMake(HIC_ScreenWidth, height + 340.5 + 204.5 + 20);
    }else if (surplusCount == 7){
        self.scrollView.contentSize = CGSizeMake(HIC_ScreenWidth, height + 464 + 198.5 + 20);
    }else{
        self.scrollView.contentSize = CGSizeMake(HIC_ScreenWidth, height + 20);
    }
    [self addImageViewWithArrCount:arrCount + 1 andAllCount:self.dataArr.count];
}
- (UILabel *)createLabel:(NSString *)title frame:(CGRect)frame {
    UILabel *descLabel = [[UILabel alloc]initWithFrame:frame];
    descLabel.text = title;
    descLabel.userInteractionEnabled = YES;
    descLabel.textAlignment = NSTextAlignmentCenter;
    descLabel.backgroundColor = [UIColor colorWithHexString:@"#54BF62"];
    descLabel.textColor = UIColor.whiteColor;
    descLabel.font = FONT_REGULAR_15;
    descLabel.layer.cornerRadius = 14;
    descLabel.clipsToBounds = YES;
    UITapGestureRecognizer *descTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(descTap:)];
    [descLabel addGestureRecognizer:descTap];
    return descLabel;
}

- (void)updateConstraintsWithStr:(NSString *)str andLabel:(UILabel *)label andImageView:(UIImageView *)imageview{
    CGFloat n = HIC_ScreenWidth / 375.0;
    CGSize strsize = [str sizeWithFont:[UIFont fontWithName:@"PingFangSC-Regular" size:14] maxSize:CGSizeMake(110 * n, 30)];
    CGFloat strW = strsize.width + 20;
    [label mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.offset(strW);
        make.centerX.equalTo(imageview);
        make.bottom.equalTo(imageview.mas_top).offset(-3);
        make.height.offset(30);
    }];
}

- (void)addImageViewWithArrCount:(NSInteger)count andAllCount:(NSInteger)allCount{
    CGFloat n = HIC_ScreenWidth / 375.0;
    NSInteger tempCount = 0;
    CGFloat yPoint = 0 ;
    
    for (int i = 0; i < count; i ++) {
        
        UIImageView *left1 = [[UIImageView alloc]initWithFrame:CGRectMake(38* n, 14.5* n + yPoint, 85 * n, 65* n)];
        left1.image = [UIImage imageNamed:@"岛-左3"];
        left1.userInteractionEnabled = YES;
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(39* n, -2* n, 31* n, 40* n)];
        image.image = [UIImage imageNamed:@"闯关-关卡"];
        [left1 addSubview:image];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, -32* n, 100* n, 28* n)];
        label.layer.cornerRadius = 14;
        label.clipsToBounds = YES;
        label.backgroundColor = UIColor.whiteColor;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = FONT_REGULAR_14;
        label.textColor = TEXT_COLOR_DARK;
        label.userInteractionEnabled = YES;
        if (tempCount <= allCount) {
            HICMixTrainArrangeModel *model = self.dataArr[tempCount];
            label.text = model.stageName;
            [left1 addSubview:label];
            [self updateConstraintsWithStr:model.stageName andLabel:label andImageView:image];
        }
        if (i > 0) {
            [self.scrollView addSubview:left1];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(jumpDetail:)];
            image.tag = tempCount + tagNum;
            [image addGestureRecognizer:tap];
            image.userInteractionEnabled = YES;
            tempCount += 1;
            if (allCount == tempCount) {
                break;
            }
        }
        UIImageView *right1 = [[UIImageView alloc]initWithFrame:CGRectMake(173* n, 32.5* n + yPoint, 200* n, 225* n)];
        right1.image = [UIImage imageNamed:@"岛-右1"];
        right1.userInteractionEnabled = YES;
              [self.scrollView addSubview:right1];
        UIImageView *image1 = [[UIImageView alloc]initWithFrame:CGRectMake(95* n, 54.5* n, 31* n, 40* n)];
        image1.image = [UIImage imageNamed:@"闯关-关卡"];
        [right1 addSubview:image1];
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(jumpDetail:)];
        image1.tag = tempCount + tagNum;
        [image1 addGestureRecognizer:tap1];
        image1.userInteractionEnabled = YES;
        //        HICMixTrainArrangeModel *model1 = self.dataArr[tempCount];
        UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(70* n, 23* n, 100* n, 28* n)];

        label1.layer.cornerRadius = 14;
        label1.clipsToBounds = YES;
        label1.textAlignment = NSTextAlignmentCenter;
        label1.font = FONT_REGULAR_14;
        label1.textColor = TEXT_COLOR_DARK;
        label1.backgroundColor = UIColor.whiteColor;

        if (tempCount <= allCount) {
            [right1 addSubview:label1];
            HICMixTrainArrangeModel *model1 = self.dataArr[tempCount];
            label1.text = model1.stageName;
            [self updateConstraintsWithStr:model1.stageName andLabel:label1 andImageView:image1];
        }
        
        tempCount += 1;
        if (allCount <= tempCount && tempCount >= 5) {
            break;
        }
        UIImageView *left2 = [[UIImageView alloc]initWithFrame:CGRectMake(18* n, 174.5* n  + yPoint, 167.5* n, 153* n)];
        left2.image = [UIImage imageNamed:@"岛-左2"];
        left2.userInteractionEnabled = YES;
        [self.scrollView addSubview:left2];
        UIImageView *image2 = [[UIImageView alloc]initWithFrame:CGRectMake(64.5* n, 0, 31* n, 40* n)];
        image2.image = [UIImage imageNamed:@"闯关-关卡"];
        [left2 addSubview:image2];
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(jumpDetail:)];
        image2.tag = tempCount + tagNum;
        [image2 addGestureRecognizer:tap2];
        image2.userInteractionEnabled = YES;
        //        HICMixTrainArrangeModel *model2 = self.dataArr[tempCount];
        UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(40* n, -32* n, 100* n, 28* n)];
        label2.layer.cornerRadius = 14;
        label2.clipsToBounds = YES;
        label2.textAlignment = NSTextAlignmentCenter;
        label2.font = FONT_REGULAR_14;
        label2.textColor = TEXT_COLOR_DARK;
        label2.backgroundColor = UIColor.whiteColor;
        if (tempCount < allCount) {
            HICMixTrainArrangeModel *model2 = self.dataArr[tempCount];
            label2.text = model2.stageName;
             [left2 addSubview:label2];
            [self updateConstraintsWithStr:model2.stageName andLabel:label2 andImageView:image2];
        }
        //        label2.text = model2.stageName;
       
        tempCount += 1;
        if (allCount <= tempCount && tempCount >= 5) {
            break;
        }
        UIImageView *right2 = [[UIImageView alloc]initWithFrame:CGRectMake(233* n, 262* n + yPoint , 85* n, 80* n)];
        right2.image = [UIImage imageNamed:@"岛-右2"];
        right2.userInteractionEnabled = YES;
        [self.scrollView addSubview:right2];
        UIImageView *image3 = [[UIImageView alloc]initWithFrame:CGRectMake(37.5* n, -2* n, 31* n, 40* n)];
        image3.image = [UIImage imageNamed:@"闯关-关卡"];
        [right2 addSubview:image3];
        UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(jumpDetail:)];
        image3.tag = tempCount + tagNum;
        [image3 addGestureRecognizer:tap3];
        image3.userInteractionEnabled = YES;
        //        HICMixTrainArrangeModel *model3 = self.dataArr[tempCount];
        UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(0, -32* n, 100* n, 28* n)];
        label3.layer.cornerRadius = 14;
        label3.clipsToBounds = YES;
        label3.textAlignment = NSTextAlignmentCenter;
        label3.font = FONT_REGULAR_14;
        label3.textColor = TEXT_COLOR_DARK;
        label3.backgroundColor = UIColor.whiteColor;
        if (tempCount < allCount) {
            HICMixTrainArrangeModel *model3 = self.dataArr[tempCount];
            label3.text = model3.stageName;
            [right2 addSubview:label3];
            [self updateConstraintsWithStr:model3.stageName andLabel:label3 andImageView:image3];
        }
        //        label3.text = model3.stageName;
        
        tempCount += 1;
        if (allCount == tempCount && tempCount >= 5) {
            break;
        }
        UIImageView *left3 = [[UIImageView alloc]initWithFrame:CGRectMake(38* n, 363.5* n + yPoint , 85* n, 80* n)];
        left3.image = [UIImage imageNamed:@"岛-左3"];
        left3.userInteractionEnabled = YES;
        [self.scrollView addSubview:left3];
        UIImageView *image4 = [[UIImageView alloc]initWithFrame:CGRectMake(42.5* n, -13* n, 31* n, 40* n)];
        image4.image = [UIImage imageNamed:@"闯关-关卡"];
        [left3 addSubview:image4];
        UITapGestureRecognizer *tap4 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(jumpDetail:)];
        image4.tag = tempCount + tagNum;
        [image4 addGestureRecognizer:tap4];
        image4.userInteractionEnabled = YES;
        UILabel *label4 = [[UILabel alloc]initWithFrame:CGRectMake(0, -45* n, 100* n, 28* n)];
        label4.layer.cornerRadius = 14;
        label4.clipsToBounds = YES;
        label4.textAlignment = NSTextAlignmentCenter;
        label4.font = FONT_REGULAR_14;
        label4.textColor = TEXT_COLOR_DARK;
        label4.backgroundColor = UIColor.whiteColor;
        //        HICMixTrainArrangeModel *model4 = self.dataArr[tempCount];
        if (tempCount < allCount) {
            HICMixTrainArrangeModel *model4 = self.dataArr[tempCount];
            label4.text = model4.stageName;
            [left3 addSubview:label4];
            [self updateConstraintsWithStr:model4.stageName andLabel:label4 andImageView:image4];
        }
        //        label4.text = model4.stageName;
        
        tempCount += 1;
        if (allCount <= tempCount && tempCount >= 5) {
            break;
        }
        UIImageView *right3 = [[UIImageView alloc]initWithFrame:CGRectMake(173* n, 340.5* n + yPoint, 200* n, 234.5* n)];
        right3.image = [UIImage imageNamed:@"岛-右3"];
        right3.userInteractionEnabled = YES;
        [self.scrollView addSubview:right3];
        UIImageView *image5 = [[UIImageView alloc]initWithFrame:CGRectMake(95* n, 96* n, 31* n, 40* n)];
        image5.image = [UIImage imageNamed:@"闯关-关卡"];
        [right3 addSubview:image5];
        UITapGestureRecognizer *tap5 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(jumpDetail:)];
        image5.tag = tempCount + tagNum;
        [image5 addGestureRecognizer:tap5];
        image5.userInteractionEnabled = YES;
        UILabel *label5 = [[UILabel alloc]initWithFrame:CGRectMake(55* n, 62* n, 100* n, 28* n)];
        label5.layer.cornerRadius = 14;
        label5.clipsToBounds = YES;
        label5.textAlignment = NSTextAlignmentCenter;
        label5.font = FONT_REGULAR_14;
        label5.textColor = TEXT_COLOR_DARK;
        label5.backgroundColor = UIColor.whiteColor;
        //        HICMixTrainArrangeModel *model5 = self.dataArr[tempCount];
        if (tempCount < allCount) {
            HICMixTrainArrangeModel *model5 = self.dataArr[tempCount];
            label5.text = model5.stageName;
            [right3 addSubview:label5];
            [self updateConstraintsWithStr:model5.stageName andLabel:label5 andImageView:image5];
        }
        //        label5.text = model5.stageName;
        
        tempCount += 1;
        if (allCount <= tempCount && tempCount >= 5) {
            break;
        }
        UIImageView *left4 = [[UIImageView alloc]initWithFrame:CGRectMake(18* n, 465* n + yPoint , 190* n, 230* n)];
        left4.image = [UIImage imageNamed:@"岛-左4"];
        left4.userInteractionEnabled = YES;
        [self.scrollView addSubview:left4];
        UIImageView *image6 = [[UIImageView alloc]initWithFrame:CGRectMake(70* n, 60* n, 31* n, 40* n)];
        image6.image = [UIImage imageNamed:@"闯关-关卡"];
        [left4 addSubview:image6];
        UITapGestureRecognizer *tap6 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(jumpDetail:)];
        image6.tag = tempCount + tagNum;
        [image6 addGestureRecognizer:tap6];
        image6.userInteractionEnabled = YES;
        UILabel *label6 = [[UILabel alloc]initWithFrame:CGRectMake(30* n, 28* n, 100* n, 28* n)];
        label6.layer.cornerRadius = 14;
        label6.clipsToBounds = YES;
        label6.textAlignment = NSTextAlignmentCenter;
        label6.font = FONT_REGULAR_14;
        label6.textColor = TEXT_COLOR_DARK;
        label6.backgroundColor = UIColor.whiteColor;
        HICMixTrainArrangeModel *model6 = self.dataArr[tempCount];
        label6.text = model6.stageName;
        [left4 addSubview:label6];
        [self updateConstraintsWithStr:model6.stageName andLabel:label6 andImageView:image6];
        tempCount += 1;
        if (allCount == tempCount) {
            break;
        }
        UIImageView *right4 = [[UIImageView alloc]initWithFrame:CGRectMake(233* n, 612* n  + yPoint, 85* n, 80* n)];
        right4.image = [UIImage imageNamed:@"岛-右2"];
        right4.userInteractionEnabled = YES;
        [self.scrollView addSubview:right4];
        UIImageView *image7 = [[UIImageView alloc]initWithFrame:CGRectMake(37.5* n, -2* n, 31* n, 40* n)];
        image7.image = [UIImage imageNamed:@"闯关-关卡"];
        [right4 addSubview:image7];
        UITapGestureRecognizer *tap7 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(jumpDetail:)];
        image7.tag = tempCount + tagNum;
        [image7 addGestureRecognizer:tap7];
        image7.userInteractionEnabled = YES;
        UILabel *label7 = [[UILabel alloc]initWithFrame:CGRectMake(0, -32* n, 100* n, 28* n)];
        label7.layer.cornerRadius = 14;
        label7.clipsToBounds = YES;
        label7.textAlignment = NSTextAlignmentCenter;
        label7.font = FONT_REGULAR_14;
        label7.textColor = TEXT_COLOR_DARK;
        label7.backgroundColor = UIColor.whiteColor;
        HICMixTrainArrangeModel *model7 = self.dataArr[tempCount];
        label7.text = model7.stageName;
        [right4 addSubview:label7];
        [self updateConstraintsWithStr:model7.stageName andLabel:label7 andImageView:image7];
        tempCount += 1;
        if (allCount == tempCount) {
            break;
        }
        yPoint += 692.0 *n;
    }
    
    CGFloat startY = 128.0;
    NSInteger num = allCount < 5 ? 5:allCount;
    for (int i = 1; i < num; i ++) {
        if (i%2) {
            UIImageView *imageLine = [[UIImageView alloc]initWithFrame:CGRectMake(115 *n, startY *n, 174*n, 75.5*n)];
            imageLine.image = [UIImage imageNamed:@"闯关路径-左箭头"];
            startY += 75.5 + 11;
            [self.scrollView addSubview:imageLine];
        }else{
            UIImageView *imageLine = [[UIImageView alloc]initWithFrame:CGRectMake(96.5 *n, startY *n, 174*n, 75.5*n)];
            imageLine.image = [UIImage imageNamed:@"闯关路径-右箭头"];
            startY += 75.5 + 11;
            [self.scrollView addSubview:imageLine];
        }
    }
    
    
    DDLogDebug(@"lknbhfasj;kdsh%f",yPoint);
}
- (void)jumpDetail:(UITapGestureRecognizer *)tap{
    NSInteger index = tap.view.tag - tagNum;
    if (index + 1 > self.dataArr.count) {
        return;
    }
    HICMixTrainArrangeModel *model = self.dataArr[index];
    NSMutableArray *subList = [HICMixTrainArrangeListModel mj_objectArrayWithKeyValuesArray:model.stageActionList];
    HICMixTrainArrangeTaskVC *vc = HICMixTrainArrangeTaskVC.new;
    vc.trainId = _trainId;
    vc.dataArr = subList;
    vc.name = model.stageName;
    vc.trainTerminated = model.trainTerminated;
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (void)descTap:(UITapGestureRecognizer *)tap {
    UILabel *tapLabel = (UILabel *)tap.view;
    if ([tapLabel.text isEqualToString:NSLocalizableString(@"introduction", nil)]) {
        if (_isDesc) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
             HICOfflineTrainInfoVC *vc = HICOfflineTrainInfoVC.new;
            vc.trainId = _trainId.integerValue;
            vc.registerActionId = _registerId;
            [self.navigationController pushViewController:vc animated:YES];
        }
    } else if([tapLabel.text isEqualToString:NSLocalizableString(@"synchronousProgress", nil)]){
        [self syncProgress];
    }
    
}

- (void)syncProgress {
    [HICAPI syncProgress:self.trainId success:^(NSDictionary * _Nonnull responseObject) {
        if (responseObject[@"data"]) {
            NSInteger i = [responseObject[@"data"] integerValue];
            if (i == 1) {
                [HICToast showWithText:NSLocalizableString(@"synchronousSuccess", nil)];
                [self getListData];
            }else {
                [HICToast showWithText:NSLocalizableString(@"donNotNeedSynchronize", nil)];
            }
        }
    } failure:^(NSError * _Nonnull error) {
        [HICToast showWithText:NSLocalizableString(@"synchronizationFailure", nil)];
    }];
}

- (void)backButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
