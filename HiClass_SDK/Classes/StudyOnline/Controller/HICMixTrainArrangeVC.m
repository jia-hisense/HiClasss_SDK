//
//  HICMixTrainArrangeVC.m
//  HiClass
//
//  Created by WorkOffice on 2020/6/15.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import "HICMixTrainArrangeVC.h"
#import "HICMixTrainArrangeModel.h"
#import "HICMixTrainArrangeCell.h"
#import "OfflineTrainingListModel.h"
#import "HICOfflineTrainInfoVC.h"
#import "HICSyncProgressPopview.h"

static NSString *mixArrangeCell = @"mixArrangeCell";
@interface HICMixTrainArrangeVC ()<UITableViewDelegate,UITableViewDataSource,HICMixTrainArrangeDelegate>
@property (nonatomic ,strong)UIView *moreView;
@property (nonatomic ,strong)UITableView *tableView;
@property (nonatomic ,strong)HICNetModel *netModel;
@property (nonatomic, strong)NSMutableArray *listArr;
@property (nonatomic ,assign)CGFloat cellHeight;
@property (nonatomic ,strong)NSMutableArray *heightArr;
@property (nonatomic, strong)NSMutableArray *showArr;
@property (nonatomic ,assign)BOOL isFirst;
@property (nonatomic ,assign)CGFloat firstHeight;
@property (nonatomic ,strong)OfflineMixTrainCellModel *cellModel;
@property (nonatomic ,assign)BOOL syncProgress;
@end

@implementation HICMixTrainArrangeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    self.isFirst = YES;
    [self createNavView];
    [self getListData];
    [self configTableView];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    if (self.listArr.count > 0) {
        [self getListData];
    }
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = NO;

}
-(void) createNavView {
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, HIC_ScreenWidth, HIC_StatusBar_Height + 44)];
    backView.backgroundColor = UIColor.whiteColor;
    UIButton *backbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    backbutton.frame = CGRectMake(16, 11 + HIC_StatusBar_Height, 12, 22);
    [backbutton hicChangeButtonClickLength:30];
    [backbutton setImage:[UIImage imageNamed:@"头部-返回"] forState:UIControlStateNormal];
    [backbutton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:backbutton];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10 + HIC_StatusBar_Height, HIC_ScreenWidth, 25)];
    titleLabel.text = NSLocalizableString(@"trainingArrangement", nil);
    titleLabel.font = FONT_MEDIUM_18;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:titleLabel];
    
    UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [moreBtn setImage:[UIImage imageNamed:@"更多"] forState:UIControlStateNormal];
    moreBtn.frame = CGRectMake(HIC_ScreenWidth - 16 - 12, 11 + HIC_StatusBar_Height, 12, 22);
    [moreBtn hicChangeButtonClickLength:30];
    moreBtn.tag = 1000001;
    [moreBtn addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:moreBtn];
    [self.view addSubview:backView];
}

- (void)configTableView{
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    if (@available(iOS 15.0, *)) {
        self.tableView.sectionHeaderTopPadding = 0;
    }
    [self.view addSubview:self.moreView];
}
- (void)getListData {
    [HICAPI mixedTrainingArrangement:_trainId success:^(NSDictionary * _Nonnull responseObject) {
        if (responseObject[@"data"] && [responseObject[@"data"] isKindOfClass:NSArray.class]) {
            self.listArr = [HICMixTrainArrangeModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            NSString *str;
            if (self.listArr.count == 0) {
                return ;
            }

            HICMixTrainArrangeModel *model = [HICMixTrainArrangeModel mj_objectWithKeyValues:self.listArr[0]];
            OfflineMixTrainCellModel *cellModel = [OfflineMixTrainCellModel createModelWithRep:model.stageActionList];
            self.syncProgress = [model.syncProgress integerValue] == 1;
            DDLogDebug(@"混合培训self.syncProgres= %ld", (long)self.syncProgress);
            NSMutableArray *titles = [NSMutableArray arrayWithArray:@[NSLocalizableString(@"trainingDetails", nil)]];
            if (self.syncProgress) {
                [titles addObject:NSLocalizableString(@"synchronousProgress", nil)];
            }
            [self showSyncProgressToast];
            [self updateMoreViewOptions:titles];
            
            
            for (int i = 0;i < cellModel.listCellHeight.count ;i ++) {
                self.firstHeight += cellModel.listCellHeight[i].floatValue;
            }
            for (int i = 0; i  < self.listArr.count; i ++) {
                if (i == 0) {
                    str = @"yes";
                    [self.showArr addObject:str];
                }else{
                    str = @"no";
                    [self.showArr addObject:str];
                }
                if (self.heightArr.count < self.listArr.count) {
                    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
                    if (self.isFirst) {
                        if (i == 0) {
                            [dic setValue:[NSNumber numberWithInteger:self.firstHeight + 12 + 60] forKey:[NSString stringWithFormat:@"%d",i]];
                        }else{
                            [dic setValue:@60 forKey:[NSString stringWithFormat:@"%d",i]];
                        }
                    }else{
                        [dic setValue:@60 forKey:[NSString stringWithFormat:@"%d",i]];
                    }
                    [self.heightArr addObject:dic];

                }
            }
            [UIView performWithoutAnimation:^{
                [self.tableView reloadData];
            }];
        }
    }];
}
- (void)backButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)moreBtnClick:(UIButton *)btn{
    if (btn.tag == 1000001) {
        self.moreView.hidden = !self.moreView.hidden;
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint point=[[touches anyObject]locationInView:self.view];
    CALayer *layer=[self.moreView.layer hitTest:point];
    if (layer!=self.moreView.layer) {
        self.moreView.hidden = YES;
    }
}

- (void)moreInClick:(UIButton *)btn {
    self.moreView.hidden = YES;
    if (_isDesc) {
        [self.navigationController popViewControllerAnimated:YES];
    } else if ([btn.titleLabel.text isEqualToString:NSLocalizableString(@"trainingDetails", nil)]) {
        HICOfflineTrainInfoVC *vc = HICOfflineTrainInfoVC.new;
        vc.trainId = _trainId.integerValue;
        vc.registerActionId = _registerId;
        vc.isShowArrange = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([btn.titleLabel.text isEqualToString:NSLocalizableString(@"synchronousProgress", nil)]) {
        [self syncProgressAction];
    }
}

- (void)refreshData {
    [self getListData];
}

- (void)showSyncProgressToast {
    BOOL hadShow = [[NSUserDefaults standardUserDefaults] boolForKey:hadShowMixTrainyncProgressToastKey];
    if (hadShow || !self.syncProgress){
        return;
    }
    // 显示同步进度提示
    HICSyncProgressPopview *syncView = [[HICSyncProgressPopview alloc] initWithFrame:self.view.bounds from:HICSyncProgressPageMixTrain];
    [self.view addSubview:syncView];
    [syncView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

///同步进度
- (void)syncProgressAction {
    [HICAPI syncProgress:_trainId success:^(NSDictionary * _Nonnull responseObject) {
        if (responseObject[@"data"]) {
            NSInteger i = [responseObject[@"data"] integerValue];
            if (i == 1) {
                [HICToast showWithText:NSLocalizableString(@"synchronousSuccess", nil)];
                [self refreshData];
            } else {
                [HICToast showWithText:NSLocalizableString(@"noNeedSynchronizeProgress", nil)];
            }
        } else {
            [HICToast showWithText:NSLocalizableString(@"noNeedSynchronizeProgress", nil)];
        }
    } failure:^(NSError * _Nonnull error) {
        [HICToast showWithText:NSLocalizableString(@"synchronizationFailure", nil)];
    }];
}
- (void)updateMoreViewOptions:(NSArray *)titles {
    for (int i = 0; i < titles.count; i++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 50 *i, 113, 50)];
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(moreInClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        btn.titleLabel.font = FONT_MEDIUM_16;
        [self.moreView addSubview:btn];
        [btn setTitleColor:[UIColor colorWithHexString:@"#e6e6e6"] forState:UIControlStateDisabled];
        [btn setTitleColor:TEXT_COLOR_LIGHT forState:UIControlStateNormal];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.moreView);
            make.height.equalTo(@50);
            make.top.equalTo(self.moreView).offset(50 * i);
            if (i == titles.count - 1) {
                make.bottom.equalTo(self.moreView);
            }
        }];
        if (i < titles.count - 1) {
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 50, 113, 0.5)];
            line.backgroundColor = [UIColor colorWithHexString:@"#E6E6E6"];
            [self.moreView addSubview:line];
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@0.5);
                make.left.right.bottom.equalTo(btn);
            }];
        }
    }
}
#pragma mark ----tableViewdelegate && datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HICMixTrainArrangeCell *cell = (HICMixTrainArrangeCell *)[tableView dequeueReusableCellWithIdentifier:mixArrangeCell];
    if (cell == nil) {
        cell = [[HICMixTrainArrangeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:mixArrangeCell];
    }
    cell.extensionDelegate = self;
    cell.indexPath = indexPath;
    cell.isFirst = self.isFirst;

    HICMixTrainArrangeModel *model = self.listArr[indexPath.row];
    cell.trainTerminated = model.trainTerminated;
    cell.cellModel = [OfflineMixTrainCellModel createModelWithRep:model.stageActionList];
    cell.model = self.listArr[indexPath.row];
    cell.trainId = _trainId.integerValue;
    if ([self.showArr[indexPath.row] isEqualToString:@"yes"]) {
        cell.isShowContent = YES;
    }else{
        cell.isShowContent = NO;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0.0;
    for (int i = 0; i < self.heightArr.count; i ++) {
        if ([[self.heightArr[i] allKeys][0] isEqual:[NSString stringWithFormat:@"%ld",(long)indexPath.row]]) {
            height = [self.heightArr[i][[NSString stringWithFormat:@"%ld",(long)indexPath.row]] floatValue];
        }
    }
    return height;
}
- (void)clickExtension:(CGFloat)cellHeight andIndex:(NSInteger)index andIsShowContent:(BOOL)isShowContent {
    self.isFirst = NO;
    self.cellHeight = cellHeight;
    for (int i = 0; i < self.heightArr.count; i ++) {
        if ([[self.heightArr[i] allKeys][0] isEqual:[NSString stringWithFormat:@"%ld",(long)index]]) {
            [self.heightArr[i] setValue:[NSString stringWithFormat:@"%f",self.cellHeight] forKey:[NSString stringWithFormat:@"%ld",(long)index]];
        }
        if (i == index) {
            NSString *str;
            if (isShowContent) {
                str = @"yes";
            }else{
                str = @"no";
            }
            [self.showArr replaceObjectAtIndex:i withObject:str];
        }
    }
    [UIView performWithoutAnimation:^{
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }];
}
- (UIView *)moreView {
    if (!_moreView) {
        _moreView = [[UIView alloc]initWithFrame:CGRectMake(HIC_ScreenWidth - 16 - 113 - 12,44 + HIC_StatusBar_Height, 113, 50)];
        _moreView.backgroundColor = [UIColor whiteColor];
        _moreView.layer.cornerRadius = 3;
        _moreView.layer.shadowRadius = 3;
        _moreView.layer.shadowColor = [UIColor blackColor].CGColor;
        _moreView.layer.shadowOpacity = 0.1;
        _moreView.layer.shadowOffset = CGSizeZero;
        _moreView.hidden = YES;
        [self.view addSubview:_moreView];
        [_moreView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.view).inset(15);
            make.top.equalTo(self.view).offset(HIC_NavBarAndStatusBarHeight);
            make.width.equalTo(@113);
        }];
    }
    return _moreView;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, HIC_NavBarAndStatusBarHeight, HIC_ScreenWidth, HIC_ScreenHeight - HIC_BottomHeight - HIC_NavBarAndStatusBarHeight) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.separatorColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = BACKGROUNG_COLOR;
        [_tableView registerClass:[HICMixTrainArrangeCell class] forCellReuseIdentifier:mixArrangeCell];
    }
    return _tableView;
}
-(NSMutableArray *)heightArr{
    if (!_heightArr) {
        _heightArr = [NSMutableArray new];
    }
    return _heightArr;
}
-(NSMutableArray *)showArr{
    if (!_showArr) {
        _showArr = [NSMutableArray array];
    }
    return _showArr;
}
@end
