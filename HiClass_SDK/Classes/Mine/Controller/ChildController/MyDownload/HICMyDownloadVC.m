//
//  HICMyDownloadVC.m
//  HiClass
//
//  Created by Eddie Ma on 2020/2/21.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICMyDownloadVC.h"
#import "HICMyDownloadCell.h"
#import "HICMyKDownloadVC.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "HomeworkImagePreViewVC.h"
//#import "AppDelegate.h"

static NSString *myDownloadCellIdenfer = @"myDownloadCell";
static NSString *logName = @"[HIC][MDVC]";

@interface HICMyDownloadVC ()<HICCustomNaviViewDelegate, UITableViewDataSource, UITableViewDelegate, HICDownloadManagerDelegate>

@property (nonatomic, strong) UIView *emtyView;
@property (nonatomic, strong) UIView *btmEditView;
@property (nonatomic, strong) NSMutableArray *originDownloadArr;
@property (nonatomic, strong) NSMutableArray *downloadArr;
@property (nonatomic, strong) NSMutableArray *checkArr;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) HICCustomNaviView *navi;
@property (nonatomic, assign) BOOL isEmpty;
@property (nonatomic, assign) BOOL isEditing;
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) NSMutableArray *cellArr;

@end

@implementation HICMyDownloadVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    DLManager.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    if (!self.navigationController.isNavigationBarHidden) {
        self.navigationController.navigationBarHidden = YES;
    }
    [self initData];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)initData {
    self.cellArr = [[NSMutableArray alloc] init];
    self.checkArr = [[NSMutableArray alloc] init];
    dispatch_async([DBManager database_queue], ^{
        self.downloadArr = [[NSMutableArray alloc] initWithArray:[DBManager selectAllDownloadMedia]];
        self.originDownloadArr = [[NSMutableArray alloc] initWithArray:self.downloadArr];
        NSMutableArray *temCMediaIds = [[NSMutableArray alloc] init];
        NSMutableArray *temDownloadArr = [[NSMutableArray alloc] init];
        // 筛选课程
        for (HICKnowledgeDownloadModel *kModel in self.downloadArr) {
            if (kModel.mediaSingle == 1) {
                [temDownloadArr addObject:kModel];
            } else {
                if ([HICCommonUtils isValidObject:kModel.cMediaId] && ![temCMediaIds containsObject:kModel.cMediaId]) {
                    [temCMediaIds addObject:kModel.cMediaId];
                    [temDownloadArr addObject:kModel];
                }
            }
        }
        self.downloadArr = temDownloadArr;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self createUI];
        });
    });
}

- (void)reloadData {
    dispatch_async([DBManager database_queue], ^{
        self.downloadArr = [[NSMutableArray alloc] initWithArray:[DBManager selectAllDownloadMedia]];
        self.originDownloadArr = [[NSMutableArray alloc] initWithArray:self.downloadArr];
        NSMutableArray *temCMediaIds = [[NSMutableArray alloc] init];
        NSMutableArray *temDownloadArr = [[NSMutableArray alloc] init];
        // 筛选课程
        for (HICKnowledgeDownloadModel *kModel in self.downloadArr) {
            if (kModel.mediaSingle == 1) {
                [temDownloadArr addObject:kModel];
            } else {
                if ([HICCommonUtils isValidObject:kModel.cMediaId] && ![temCMediaIds containsObject:kModel.cMediaId]) {
                    [temCMediaIds addObject:kModel.cMediaId];
                    [temDownloadArr addObject:kModel];
                }
            }
        }
        self.downloadArr = temDownloadArr;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_tableView) {
                [_tableView reloadData];
            }
        });
    });
}

- (void)clearData {
    [_cellArr removeAllObjects];
    [_checkArr removeAllObjects];
}

- (void)createUI {
    [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self createNavi];
    [self createTableView];
    [self createEmtyView];
    [self createBtmEditView];
}

- (void)createNavi {
    self.navi = [[HICCustomNaviView alloc] initWithTitle:NSLocalizableString(@"downloadContent", nil) rightBtnName:NSLocalizableString(@"edit", nil) showBtnLine:YES];
    _navi.delegate = self;
    [self.view addSubview:_navi];

    if (self.downloadArr.count == 0) {
        [_navi setRightBtnText:nil];
    }
}

- (void)createEmtyView {
    self.emtyView = [[UIView alloc] init];
    [self.view addSubview:_emtyView];
    _emtyView.frame = CGRectMake(0, HIC_NavBarAndStatusBarHeight, HIC_ScreenWidth, HIC_ScreenHeight - HIC_NavBarAndStatusBarHeight);
    _emtyView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1/1.0];
    _emtyView.hidden = self.downloadArr.count == 0 ? NO : YES;

    CGFloat topMargin = (_emtyView.frame.size.height - 120)/2 - 60;
    UIImageView *imgV = [[UIImageView alloc] init];
    [_emtyView addSubview:imgV];
    imgV.image = [UIImage imageNamed:@"暂无下载"];
    imgV.frame = CGRectMake((HIC_ScreenWidth - 120)/2 , topMargin, 120, 120);

    UILabel *emptyLabel  = [[UILabel alloc] init];
    [_emtyView addSubview:emptyLabel];
    emptyLabel.text = NSLocalizableString(@"noDownloadKnowledgePrompt", nil);
    emptyLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1/1.0];
    emptyLabel.font = FONT_REGULAR_16;
    emptyLabel.frame = CGRectMake((HIC_ScreenWidth - 160)/2, topMargin + imgV.frame.size.height + 8, 160, 22.5);

}

- (void)createBtmEditView {
    self.btmEditView = [[UIView alloc] initWithFrame:CGRectMake(0, HIC_ScreenHeight - 50 - HIC_BottomHeight, HIC_ScreenWidth, 50)];
    [self.view addSubview: _btmEditView];
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

- (void)createTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, HIC_NavBarAndStatusBarHeight, HIC_ScreenWidth, HIC_ScreenHeight - HIC_NavBarAndStatusBarHeight) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1/1.0];
    _tableView.delegate = self;
    _tableView.dataSource = self;
     _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (@available(iOS 15.0, *)) {
        _tableView.sectionHeaderTopPadding = 0;
    }
}

- (void)BtnClicked:(UIButton *)btn {
    if (btn.tag == 10000) { // 全选
        [_checkArr removeAllObjects];
        if (btn.isSelected) {
            btn.selected = NO;
            [_leftBtn setTitle:NSLocalizableString(@"selectAll", nil) forState:UIControlStateNormal];
            [_rightBtn setTitle:NSLocalizableString(@"delete", nil) forState:UIControlStateNormal];
            [_rightBtn setTitleColor:[UIColor colorWithRed:255/255.0 green:75/255.0 blue:75/255.0 alpha:0.5] forState:UIControlStateNormal];
        } else {
            btn.selected = YES;
             [_leftBtn setTitle:NSLocalizableString(@"cancelAllSelected", nil) forState:UIControlStateNormal];
            for (HICKnowledgeDownloadModel *kModel in self.downloadArr) {
                [_checkArr addObject:kModel];
            }
            [_rightBtn setTitle:[NSString stringWithFormat:@"%@(%ld)", NSLocalizableString(@"delete", nil),(long)_checkArr.count] forState:UIControlStateNormal];
            [_rightBtn setTitleColor:[UIColor colorWithRed:255/255.0 green:75/255.0 blue:75/255.0 alpha:1] forState:UIControlStateNormal];
        }
         [_tableView reloadData];
    } else { // 删除
        if (_checkArr.count > 0) {
            [self createAlertViewWithTitle:[NSString stringWithFormat:@"%@%ld%@", NSLocalizableString(@"deleteSelected", nil),(long)_checkArr.count,NSLocalizableString(@"aDownload", nil)] message:@"" cancelTitle:NSLocalizableString(@"cancel", nil) confirmTitle:NSLocalizableString(@"determine", nil)];
        }
    }
}

- (void)netChangedAlertViewWithTitle:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelTitle confirmTitle:(NSString *)confirmTitle type:(HICNetStatus)netStatus {
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

            }
        }];
        [canleBtn setValue:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1/1.0] forKey:@"_titleTextColor"];
        [identityBtn setValue:[UIColor colorWithRed:0/255.0 green:190/255.0 blue:215/255.0 alpha:1/1.0] forKey:@"_titleTextColor"];
        [alertVc addAction :identityBtn];
        [alertVc setPreferredAction:identityBtn];
    }

    [viewCTL presentViewController:alertVc animated:YES completion:nil];
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
                self.btmEditView.hidden = YES;
                self.tableView.frame = CGRectMake(0, HIC_NavBarAndStatusBarHeight, HIC_ScreenWidth, HIC_ScreenHeight - HIC_NavBarAndStatusBarHeight);
                NSMutableArray *arr = [[NSMutableArray alloc] init]; // 被删除的HICKnowledgeDownloadModel数组
                for (HICKnowledgeDownloadModel *kModel in self.checkArr) {
                    if (DLManager.downloadMediaArr.count > 0) {
                        // 取消下载
                        [DLManager cancelWith:kModel.mediaId];
                    }
                    // 删除tableview数组中相对应的媒资
                    NSMutableArray *temDownloadArr = [[NSMutableArray alloc] initWithArray:self.downloadArr];
                    for (HICKnowledgeDownloadModel *temKModel in self.downloadArr) {
                        if ([temKModel.mediaId isEqual:kModel.mediaId]) {
                            [temDownloadArr removeObject:temKModel];
                            [arr addObject:temKModel];
                        }
                    }
                    if (kModel.mediaSingle == 0) {
                        for (HICKnowledgeDownloadModel *temKModel in _originDownloadArr) {
                            if ([temKModel.cMediaId isEqual:kModel.cMediaId]) {
                                if (![arr containsObject:temKModel]) {
                                    [arr addObject:temKModel];
                                }
                            }
                        }
                    }
                    self.downloadArr = temDownloadArr;
                }
                if (self.downloadArr.count == 0) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.emtyView.hidden = NO;
                        [self.navi setRightBtnText:nil];
                    });
                }
                [self clearData];
                [self.tableView reloadData];
                // 删除数据库中所有被选中的媒资
                dispatch_async([DBManager database_queue], ^{
                    [DBManager deleteMediaWith:arr];
                });
            }
        }];
        [canleBtn setValue:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1/1.0] forKey:@"_titleTextColor"];
        [identityBtn setValue:[UIColor colorWithRed:0/255.0 green:190/255.0 blue:215/255.0 alpha:1/1.0] forKey:@"_titleTextColor"];
        [alertVc addAction :identityBtn];
        [alertVc setPreferredAction:identityBtn];
    }

    [viewCTL presentViewController:alertVc animated:YES completion:nil];
}

#pragma mark tableview dataSorce协议
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _downloadArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HICMyDownloadCell *myDownloadCell = (HICMyDownloadCell *)[tableView dequeueReusableCellWithIdentifier:myDownloadCellIdenfer];
    if (myDownloadCell == nil) {
        myDownloadCell = [[HICMyDownloadCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myDownloadCellIdenfer];
        [myDownloadCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self.cellArr addObject:myDownloadCell];
    } else {
        if (![_cellArr containsObject:myDownloadCell]) {
            [self.cellArr addObject:myDownloadCell];
        }
    }

    HICKnowledgeDownloadModel *kModel = _downloadArr[indexPath.row];
    [myDownloadCell setData:kModel index:indexPath.row isPureKnowledge:NO isEditing:_isEditing checked:_checkArr];

    return myDownloadCell;

}

#pragma mark tableview delegate协议方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.row == _downloadArr.count - 1 ? MY_DOWNLOAD_CELL_HEIGHT + 20 : MY_DOWNLOAD_CELL_HEIGHT ;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HICKnowledgeDownloadModel __block *kModel = _downloadArr[indexPath.row];
    if (_isEditing) {
        if ([_checkArr containsObject:kModel]) {
            [_checkArr removeObject:kModel];
        } else {
            [_checkArr addObject:kModel];
        }
        if (_checkArr.count == _downloadArr.count) {
            [_leftBtn  setTitle:NSLocalizableString(@"cancelAllSelected", nil) forState:UIControlStateNormal];
            _leftBtn.selected = YES;
        }else{
            [_leftBtn setTitle:NSLocalizableString(@"selectAll", nil) forState:UIControlStateNormal];
            _leftBtn.selected = NO;
        }
        if (_checkArr.count > 0) {
            [_rightBtn setTitle:[NSString stringWithFormat:@"%@(%ld)", NSLocalizableString(@"delete", nil),(long)_checkArr.count] forState:UIControlStateNormal];
            [_rightBtn setTitleColor:[UIColor colorWithRed:255/255.0 green:75/255.0 blue:75/255.0 alpha:1] forState:UIControlStateNormal];
        } else {
            [_rightBtn setTitle:NSLocalizableString(@"delete", nil) forState:UIControlStateNormal];
            [_rightBtn setTitleColor:[UIColor colorWithRed:255/255.0 green:75/255.0 blue:75/255.0 alpha:0.5] forState:UIControlStateNormal];
        }
        [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    } else {
        if (kModel.mediaSingle != 1) { // 是整个课程被下载
            HICMyKDownloadVC *mKDownloadVC = [[HICMyKDownloadVC alloc] init];
            mKDownloadVC.naviTitle = kModel.cMediaName;
            mKDownloadVC.cMediaId = kModel.cMediaId;
            [self.navigationController pushViewController:mKDownloadVC animated:YES];
        } else {
            if ([kModel.mediaType integerValue] == HICFileType || [kModel.mediaType integerValue] == HICPictureType) { // 图片
                dispatch_async([DBManager database_queue], ^{
                    kModel = [DBManager selectMediasByMediaId:kModel.mediaId isCourseId:NO].firstObject;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (kModel.mediaStatus == HICDownloadFinish) {
                            NSMutableArray *orderMediaArr = [[NSMutableArray alloc] init];
                            // 图片展示顺序数组
                            NSArray *orderArr = [kModel.mediaURL componentsSeparatedByString:@","];
                            // 图片存储路径数组
                            NSArray *mediaArr = [kModel.mediaPath componentsSeparatedByString:@","];
                            // 根据图片展示顺序将图片存储路径数组重新排序
                            for (NSString *url in orderArr) {
                                NSString *orderUrlStr = [url componentsSeparatedByString:@"/"].lastObject;
                                for (NSString *mediaPath in mediaArr) {
                                    NSString *mediaPathStr = [mediaPath componentsSeparatedByString:@"/"].lastObject;
                                    if ([orderUrlStr isEqualToString:mediaPathStr]) {
                                        [orderMediaArr addObject:mediaPath];
                                    }
                                }
                            }
                            // 跳转本地预览图片
                            HomeworkImagePreViewVC *imgPre = [[HomeworkImagePreViewVC alloc] init];
                            imgPre.modalPresentationStyle = UIModalPresentationFullScreen;
                            imgPre.previewDownImages = orderMediaArr;
                            [self.navigationController presentViewController:imgPre animated:YES completion:nil];
                        } else {
                            [HICToast showWithText:NSLocalizableString(@"resourcesAreNotFinishedDownloadingPrompt", nil)];
                        }
                    });
                });
            } else if ([kModel.mediaType integerValue] == HICVideoType || [kModel.mediaType integerValue] == HICAudioType) { // 音视频
                dispatch_async([DBManager database_queue], ^{
                    kModel = [DBManager selectMediasByMediaId:kModel.mediaId isCourseId:NO].firstObject;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (kModel.mediaStatus == HICDownloadFinish) {
                            // 跳转本地音视频播放器
                            AVPlayerViewController *vc = [AVPlayerViewController new];
                            NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];

                            NSString *playPath = @"";
                            [vc.player play];
                            vc.modalPresentationStyle = UIModalPresentationFullScreen;
                            [self presentViewController:vc animated:YES completion:nil];
                        } else {
                            [HICToast showWithText:NSLocalizableString(@"resourcesAreNotFinishedDownloadingPrompt", nil)];
                        }
                    });
                });
            } else {
                DDLogDebug(@"%@ unknow type: %@", logName, kModel.mediaType);
            }
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return _isEditing ? NO : YES;
}

// 定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

// 进入编辑模式，按下出现的编辑按钮后,进行删除操作
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // 处理删除单个cell逻辑
        HICKnowledgeDownloadModel *kModel = _downloadArr[indexPath.row];
        if (![_checkArr containsObject:kModel]) {
            [_checkArr addObject:kModel];
        }
        [self createAlertViewWithTitle:NSLocalizableString(@"deleteSelectedDownload", nil) message:@"" cancelTitle:NSLocalizableString(@"cancel", nil) confirmTitle:NSLocalizableString(@"determine", nil)];
    }
}

// 修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return NSLocalizableString(@"delete", nil);
}

#pragma mark - - - HICCustomNaviViewDelegate  - - -
- (void)leftBtnClicked {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBtnClicked:(NSString *)str {
    // 编辑
    if ([str isEqualToString:NSLocalizableString(@"edit", nil)]) {
        [_navi setRightBtnText:NSLocalizableString(@"cancel", nil)];
        _isEditing = YES;
        _btmEditView.hidden = NO;
        _tableView.frame = CGRectMake(0, HIC_NavBarAndStatusBarHeight, HIC_ScreenWidth, HIC_ScreenHeight - HIC_NavBarAndStatusBarHeight - _btmEditView.frame.size.height - HIC_BottomHeight);
    } else {
        [_navi setRightBtnText:NSLocalizableString(@"edit", nil)];
        _isEditing = NO;
        _btmEditView.hidden = YES;
        _tableView.frame = CGRectMake(0, HIC_NavBarAndStatusBarHeight, HIC_ScreenWidth, HIC_ScreenHeight - HIC_NavBarAndStatusBarHeight);
    }
    [self reloadData];
}

#pragma mark - - - HICDownloadManagerDelegate - - - Start
- (void)downloadProcess:(CGFloat)percent kModel:(HICKnowledgeDownloadModel *)kModel {
    for (HICMyDownloadCell *myDownloadCell in _cellArr) {
        [myDownloadCell setProcessUIWith:kModel percent:percent];
    }
}
#pragma mark - - - HICDownloadManagerDelegate - - - End

@end
