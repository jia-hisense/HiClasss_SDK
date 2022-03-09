//
//  HICMineTableVC.m
//  HiClass
//
//  Created by WorkOffice on 2020/2/20.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICMineTableVC.h"
#import "HICMyNoteView.h"
#import "HICMyCollectView.h"
#import "HICMyStudyRecordView.h"
#import "HICMyCollectModel.h"
@interface HICMineTableVC ()<HICCustomNaviViewDelegate>
@property (nonatomic ,strong) HICCustomNaviView *navi;
@property (nonatomic, strong) UIView *btmEditView;
@property (nonatomic ,strong) NSString *naviTitle;
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) NSMutableArray *checkedArr;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) HICNetModel *netModel;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) HICMyNoteView *noteView;
@property (nonatomic, strong) HICMyCollectView *collectView;
@property (nonatomic, strong) HICMyStudyRecordView *recordView;
@property (nonatomic, strong)UIImageView *blackView;
@property (nonatomic, strong)UILabel *blackLable;
@end

@implementation HICMineTableVC
- (instancetype)initWithTitle:(NSString *)title andType:(HICMineType)type {
    if (self = [super init]) {
        self.type = type;
        self.naviTitle = title;
        self.view.backgroundColor = UIColor.whiteColor;
       }
       return self;
}
#pragma mark -lazzyLoad
- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, HIC_NavBarAndStatusBarHeight, HIC_ScreenWidth, HIC_ScreenHeight - HIC_NavBarAndStatusBarHeight)];
    }
    return _contentView;
}
-(HICMyNoteView *)noteView{
    if (!_noteView) {
        _noteView = [[HICMyNoteView alloc]init];
    }
    return _noteView;
}
-(HICMyCollectView *)collectView{
    if (!_collectView) {
        _collectView = [[HICMyCollectView alloc]init];
        __weak typeof(self) weakSelf = self;
        [_collectView returnArr:^(NSMutableArray * _Nonnull checkArr) {
            weakSelf.checkedArr = checkArr;
            if (checkArr.count == 0) {
                [weakSelf.leftBtn setTitle:NSLocalizableString(@"selectAll", nil) forState:UIControlStateNormal];
                [weakSelf.rightBtn setTitle:[NSString stringWithFormat:NSLocalizableString(@"delete", nil)] forState:UIControlStateNormal];
                [weakSelf.rightBtn setTitleColor:[UIColor colorWithRed:255/255.0 green:75/255.0 blue:75/255.0 alpha:0.5] forState:UIControlStateNormal];
            }else {
                [weakSelf.rightBtn setTitle:[NSString stringWithFormat:@"%@(%ld)", NSLocalizableString(@"delete", nil),(long)checkArr.count] forState:UIControlStateNormal];
                [weakSelf.rightBtn setTitleColor:[UIColor colorWithRed:255/255.0 green:75/255.0 blue:75/255.0 alpha:1] forState:UIControlStateNormal];
                if (checkArr.count == self.collectView.dataArr.count) {
                    [weakSelf.leftBtn setTitle:NSLocalizableString(@"cancelAllSelected", nil) forState:UIControlStateNormal];
                    _leftBtn.selected = YES;
                }else{
                [weakSelf.leftBtn setTitle:NSLocalizableString(@"selectAll", nil) forState:UIControlStateNormal];
                    _leftBtn.selected = NO;
                }
            }

        }];
    }
    return _collectView;
}
-(HICMyStudyRecordView *)recordView{
    if (!_recordView) {
        _recordView = [[HICMyStudyRecordView alloc]init];
    }
    return _recordView;
}
- (NSMutableArray *)checkedArr{
    if (!_checkedArr) {
        _checkedArr  = [NSMutableArray array];
    }
    return _checkedArr;
}
- (UIImageView *)blackView{
    if (!_blackView) {
        _blackView = [[UIImageView alloc]initWithFrame:CGRectMake(HIC_ScreenWidth /2 - 60, 214.4 + HIC_StatusBar_Height, 120, 120)];
        if (self.type == HICMyStudyRecord) {
            _blackView.image = [UIImage imageNamed:@"暂无学习记录"];
        }else if (self.type == HICMyNote){
        _blackView.image = [UIImage imageNamed:@"暂无笔记"];
        }else{
        _blackView.image = [UIImage imageNamed:@"暂无收藏"];
        }
    }
    return _blackView;
}
- (UILabel *)blackLable{
    if (!_blackLable) {
        _blackLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 345 + HIC_StatusBar_Height, HIC_ScreenWidth, 20)];
        _blackLable.font = FONT_REGULAR_16;
        _blackLable.textColor = TEXT_COLOR_LIGHTS;
        _blackLable.textAlignment = NSTextAlignmentCenter;
        if (self.type == HICMyStudyRecord) {
                   _blackLable.text = NSLocalizableString(@"noStudyRecord", nil);
               }else if (self.type == HICMyNote){
                   _blackLable.text = NSLocalizableString(@"noNote", nil);
               }else{
                   _blackLable.text = NSLocalizableString(@"noCollection", nil);
               }
    }
    return _blackLable;
}
#pragma mark -生命周期
- (void)viewWillAppear:(BOOL)animated{
      [super viewWillAppear:YES];
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    if(_type == HICMyNote && self.noteView.dataArr){
        [self initData];
    }
    
}
- (void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = NO;
     self.tabBarController.tabBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.contentView];
    [self initData];
    [self createBtmEditView];
}
- (void)initData{
    if (self.type == HICMyNote) {
        [self createNaviWithRight:NO];
        [self.contentView addSubview:self.noteView];
        [HICAPI studyNoteList:^(NSDictionary * _Nonnull responseObject) {
            [self dataProcessing:responseObject];
        } failure:^(NSError * _Nonnull error) {
            [RoleManager hiddenWindowLoadingView];
        }];
    }else if(self.type == HICMyCollect){
        [self createNaviWithRight:YES];
        [self.contentView addSubview:self.collectView];
        [HICAPI myCollectionList:^(NSDictionary * _Nonnull responseObject) {
            [self dataProcessing:responseObject];
        } failure:^(NSError * _Nonnull error) {
            [RoleManager hiddenWindowLoadingView];
        }];
    }else{
        [self createNaviWithRight:NO];
        [self.contentView addSubview:self.recordView];
        [HICAPI studyRecordList:^(NSDictionary * _Nonnull responseObject) {
            [self dataProcessing:responseObject];
        } failure:^(NSError * _Nonnull error) {
            [RoleManager hiddenWindowLoadingView];
        }];
    }
}

-(void)dataProcessing:(NSDictionary * _Nonnull)responseObject{
    [RoleManager hiddenWindowLoadingView];
    if (responseObject) {
        if (self.type == HICMyNote) {
            self.noteView.dataArr = responseObject[@"data"][@"learningNoteOverviewList"];
            if (self.noteView.dataArr.count == 0) {
                [self.noteView removeFromSuperview];
                [self.view addSubview:self.blackView];
                [self.view addSubview:self.blackLable];
            }
        }else if(self.type == HICMyCollect){
            self.collectView.dataArr = responseObject[@"data"][@"collectionList"];
            if (self.collectView.dataArr.count == 0) {
                [self.collectView removeFromSuperview];
                [self.view addSubview:self.blackView];
                [self.view addSubview:self.blackLable];
                [_navi setRightBtnText:@""];
            }
        }else{
            self.recordView.dataArr = responseObject[@"data"][@"learningRecordList"];
            if (self.recordView.dataArr.count == 0) {
                [self.recordView removeFromSuperview];
                [self.view addSubview:self.blackView];
                [self.view addSubview:self.blackLable];
            }
        }
    }
}

// 建立自定义导航栏
- (void)createNaviWithRight:(BOOL)isRight {
    if (isRight) {
       self.navi = [[HICCustomNaviView alloc] initWithTitle:self.naviTitle rightBtnName:NSLocalizableString(@"edit", nil) showBtnLine:YES];
    }else{
     self.navi = [[HICCustomNaviView alloc] initWithTitle:self.naviTitle rightBtnName:nil showBtnLine:YES];
    }
    _navi.delegate = self;
    [self.view addSubview:_navi];
}
- (void)createBtmEditView {
    self.btmEditView = [[UIView alloc] initWithFrame:CGRectMake(0, HIC_ScreenHeight - 50 - HIC_BottomHeight, HIC_ScreenWidth, 50)];
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, HIC_ScreenWidth, 0.5)];
    line.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1/1.0];
    [self.btmEditView addSubview:line];
    [self.view addSubview: self.btmEditView];
    _btmEditView.hidden = YES;
    _leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, HIC_ScreenWidth/2 - 0.5, _btmEditView.frame.size.height)];
    [_btmEditView addSubview:_leftBtn];
    [_leftBtn setTitle:NSLocalizableString(@"selectAll", nil) forState:UIControlStateNormal];
    _leftBtn.titleLabel.font = FONT_MEDIUM_17;
    [_leftBtn setTitleColor:[UIColor colorWithRed:133/255.0 green:133/255.0 blue:133/255.0 alpha:1/1.0] forState:UIControlStateNormal];
    _leftBtn.tag = 10000;
    [_leftBtn addTarget:self action:@selector(BtnClicked:) forControlEvents:UIControlEventTouchUpInside];

    UIView *dividedLine = [[UIView alloc] initWithFrame:CGRectMake(HIC_ScreenWidth/2 - 0.5, 0, 0.5, _btmEditView.frame.size.height)];
    [_btmEditView addSubview:dividedLine];
    dividedLine.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1/1.0];

   _rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(HIC_ScreenWidth/2 +0.5, 0, HIC_ScreenWidth/2 - 0.5, _btmEditView.frame.size.height)];
    [_btmEditView addSubview:_rightBtn];
    [_rightBtn setTitle:NSLocalizableString(@"delete", nil) forState:UIControlStateNormal];
    _rightBtn.titleLabel.font = FONT_MEDIUM_17;
    [_rightBtn setTitleColor:[UIColor colorWithRed:255/255.0 green:75/255.0 blue:75/255.0 alpha:0.5] forState:UIControlStateNormal];
    _rightBtn.tag = 20000;
    [_rightBtn addTarget:self action:@selector(BtnClicked:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)BtnClicked:(UIButton *)btn {
    if (btn.tag == 10000) { // 全选
        [self.checkedArr removeAllObjects];
        if (btn.isSelected) {
            btn.selected = NO;
            [_leftBtn setTitle:NSLocalizableString(@"selectAll", nil) forState:UIControlStateNormal];
            [_rightBtn setTitle:NSLocalizableString(@"delete", nil) forState:UIControlStateNormal];
            [_rightBtn setTitleColor:[UIColor colorWithRed:255/255.0 green:75/255.0 blue:75/255.0 alpha:0.5] forState:UIControlStateNormal];
        } else {
            btn.selected = YES;
//            for ( HICMyCollectModel*kModel in self.dataArr) {
//                [self.checkedArr addObject:kModel];
//            }
            [_leftBtn setTitle:NSLocalizableString(@"cancelAllSelected", nil) forState:UIControlStateNormal];
            for (int i = 0; i< self.collectView.dataArr.count; i ++) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                [self.checkedArr addObject:indexPath];
            }
            if (self.checkedArr.count > 0) {
                [_rightBtn setTitle:[NSString stringWithFormat:@"%@(%ld)",NSLocalizableString(@"delete", nil), (long)self.checkedArr.count] forState:UIControlStateNormal];
                [_rightBtn setTitleColor:[UIColor colorWithRed:255/255.0 green:75/255.0 blue:75/255.0 alpha:1] forState:UIControlStateNormal];
            }
        }
        self.collectView.checkedArr = self.checkedArr;
        [self.collectView reloadData];
    } else { // 删除
        if (self.checkedArr.count > 0) {
            [_rightBtn setTitle:[NSString stringWithFormat:@"%@(%ld)", NSLocalizableString(@"delete", nil),(long)self.checkedArr.count] forState:UIControlStateNormal];
            [_rightBtn setTitleColor:[UIColor colorWithRed:255/255.0 green:75/255.0 blue:75/255.0 alpha:1] forState:UIControlStateNormal];
            [self createAlertViewWithTitle:[NSString stringWithFormat:@"%@%lu%@",NSLocalizableString(@"sureDeleteSelected", nil),(unsigned long)self.checkedArr.count,NSLocalizableString(@"aKnowledge", nil)] message:@"" cancelTitle:NSLocalizableString(@"cancel", nil) confirmTitle:NSLocalizableString(@"determine", nil)];
        }
    }
}
- (void)createAlertViewWithTitle:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelTitle confirmTitle:(NSString *)confirmTitle {
    //临时UIViewController，从它这里present UIAlertController
    UIViewController *viewCTL = [[UIViewController alloc]init];
    //这句话很重要
    [self.view addSubview:viewCTL.view];
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    // 取消按钮
    UIAlertAction * canleBtn = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        DDLogDebug(@"%@",cancelTitle);
        [viewCTL.view removeFromSuperview];
    }];
    [canleBtn setValue:[UIColor colorWithRed:76/255.0 green:81/255.0 blue:87/255.0 alpha:1/1.0] forKey:@"_titleTextColor"];
    [alertVc addAction :canleBtn];
    // 确认按钮
    if (confirmTitle) {
        UIAlertAction * identityBtn = [UIAlertAction actionWithTitle:confirmTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            DDLogDebug(@"%@",confirmTitle);
            if (confirmTitle) {
                [viewCTL.view removeFromSuperview];
//                self.btmEditView.hidden = YES;
                self.contentView.frame = CGRectMake(0, HIC_NavBarAndStatusBarHeight, HIC_ScreenWidth, HIC_ScreenHeight - HIC_NavBarAndStatusBarHeight);
                // 删除tableview数组中相对应的媒资 - 网络请求删除后刷新页面即可
                NSMutableArray *tempDataArr = [NSMutableArray array];
                for (NSIndexPath *indexPath in self.checkedArr) {
                    [tempDataArr addObject:self.collectView.dataArr[indexPath.row]];
                }
                NSMutableDictionary *postModel = [NSMutableDictionary new];
                NSMutableString *collectionIds = [NSMutableString string];
                for (NSDictionary *dic in tempDataArr) {
                    HICMyCollectModel *collectModel = [HICMyCollectModel mj_objectWithKeyValues:dic];
                    [collectionIds appendFormat:@"%@,", collectModel.collectId];
                }

                [postModel setValue:[NSString stringWithFormat:@"%@",[collectionIds copy]] forKey:@"collectionIds"];
                [postModel setValue:@(1) forKey:@"terminalType"];
                 NSString *url = [NSString stringWithFormat:@"%@?collectionIds=%@", MY_COLLECT_DELETE, [collectionIds copy]];
                [HICAPI deleteCollection:postModel url:url success:^(NSDictionary * _Nonnull responseObject) {
                    if (responseObject) {
                        NSMutableArray *tempDataArr = [NSMutableArray arrayWithArray:[self.collectView.dataArr copy]];
                        for (NSIndexPath *indexPath in self.checkedArr) {
                            [tempDataArr removeObject:self.collectView.dataArr[indexPath.row]];
                        }
                        [self.checkedArr removeAllObjects];
                        self.collectView.dataArr = tempDataArr;
                        [self rightBtnClicked:NSLocalizableString(@"cancel", nil)];
                        if (self.collectView.dataArr.count == 0) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                        //       self.emtyView.hidden = NO;
                                [self.navi setRightBtnText:nil];
                            });
                        }

                        [self.collectView reloadData];
                    }
                }];
            }
        }];
        [canleBtn setValue:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1/1.0] forKey:@"_titleTextColor"];
        [identityBtn setValue:[UIColor colorWithRed:0/255.0 green:190/255.0 blue:215/255.0 alpha:1/1.0] forKey:@"_titleTextColor"];
        [alertVc addAction :identityBtn];
        [alertVc setPreferredAction:identityBtn];
    }

    [viewCTL presentViewController:alertVc animated:YES completion:nil];
}
- (void)clearData{
    [self.checkedArr removeAllObjects];
    [self.collectView.dataArr removeAllObjects];
}
#pragma mark - - - HICCustomNaviViewDelegate  - - -
- (void)leftBtnClicked {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBtnClicked:(NSString *)str {
    // 编辑
    if ([str isEqualToString:NSLocalizableString(@"edit", nil)]) {
        [_navi setRightBtnText:NSLocalizableString(@"cancel", nil)];
         [self.collectView isEditSelect:YES];
        
        self.btmEditView.hidden = NO;
        self.collectView.height -= (HIC_BottomHeight+50);
    } else {
        [_navi setRightBtnText:NSLocalizableString(@"edit", nil)];
         [self.collectView isEditSelect:NO];
        self.btmEditView.hidden = YES;
        self.collectView.height += (HIC_BottomHeight+50);
    }
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
