//
//  HICCourseDownloadView.m
//  HiClass
//
//  Created by Eddie Ma on 2020/2/13.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICCourseDownloadView.h"
#import "HICCourseDownloadCell.h"
#import "HICCourseDownloadModel.h"
#import "HICKnowledgeDownloadModel.h"

#define CDVTopMargin  (72 - 20 + HIC_StatusBar_Height)
#define CDVTitleSectionHeight  72
#define CDVBtmViewHeight  120

static NSString *courseDownloadIdenfer = @"courseDownloadCell";
static NSString *logName = @"[HIC][CDV]";

@interface HICCourseDownloadView()<UITableViewDataSource, UITableViewDelegate, HICCourseDownloadCellDelegate>

@property (nonatomic, strong) UIView *container;
@property (nonatomic, strong) NSArray *downloadArr;
@property (nonatomic, strong) NSString *courseName;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *confirmBtn;
@property (nonatomic, strong) NSMutableArray *extraViewArr;
@property (nonatomic, strong) NSMutableArray *clickedCellIndexArr;
@property (nonatomic, strong) NSMutableArray *clickedSubCellIndexArr;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@property (nonatomic, strong) NSString *downloadTotalSize;

@end

@implementation HICCourseDownloadView

- (instancetype)initWithCourseName:(NSString *)courseName DownloadArr:(NSArray *)arr {
    if (self = [super init]) {
        self.downloadArr = arr;
        self.courseName = courseName;
        [self initData];
        [self creatUI];
    }
    return self;
}

- (void)initData {
    self.extraViewArr = [[NSMutableArray alloc] init];
    self.clickedCellIndexArr = [[NSMutableArray alloc] init];
    self.clickedSubCellIndexArr = [[NSMutableArray alloc] init];
}

- (void)creatUI {
    self.frame = CGRectMake(0, 0, HIC_ScreenWidth, HIC_ScreenHeight);
    self.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.0];

    _container = [[UIView alloc] init];
    [self addSubview: _container];
    _container.frame = CGRectMake(0, HIC_ScreenHeight, self.frame.size.width, self.frame.size.height - CDVTopMargin);
    [UIView animateWithDuration:0.3 animations:^{
        self->_container.frame = CGRectMake(0, CDVTopMargin, self.frame.size.width, self.frame.size.height - CDVTopMargin);
    }];
    [HICCommonUtils setRoundingCornersWithView:_container TopLeft:YES TopRight:YES bottomLeft:NO bottomRight:NO cornerRadius:15];
    _container.backgroundColor = [UIColor whiteColor];

    UILabel *downloadTitle = [[UILabel alloc] init];
    [_container addSubview:downloadTitle];
    downloadTitle.frame = CGRectMake(16, 15, 68, 24);
    downloadTitle.font = FONT_MEDIUM_17;
    downloadTitle.text = NSLocalizableString(@"courseDownload", nil);
    downloadTitle.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];

    UILabel *downloadSubTitle = [[UILabel alloc] init];
    [_container addSubview:downloadSubTitle];
    downloadSubTitle.frame = CGRectMake(16, 15 + 24 + 1, _container.frame.size.width - 16 - 52, 20);
    downloadSubTitle.font = FONT_REGULAR_14;
    downloadSubTitle.text = _courseName;
    downloadSubTitle.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1/1.0];

    UIButton *cancelBtn = [[UIButton alloc] init];
    [_container addSubview: cancelBtn];
    cancelBtn.tag = 10000;
    [cancelBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setImage:[UIImage imageNamed:@"关闭弹窗"] forState:UIControlStateNormal];
    cancelBtn.frame = CGRectMake(_container.frame.size.width - 20 - 16, 15, 20, 20);

    UIView *dividedLine = [[UIView alloc] initWithFrame:CGRectMake(0, CDVTitleSectionHeight - 0.5, _container.frame.size.width, 0.5)];
    [_container addSubview: dividedLine];
    dividedLine.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1/1.0];

    [self initTableView];

    UIImageView *btmView = [[UIImageView alloc] initWithFrame:CGRectMake(0, _container.frame.size.height - (CDVBtmViewHeight + HIC_BottomHeight), _container.frame.size.width, CDVBtmViewHeight + HIC_BottomHeight)];
    [_container addSubview:btmView];
    btmView.userInteractionEnabled = YES;
    btmView.image = [UIImage imageNamed:@"studyBtm_Cover"];

    self.confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btmView addSubview:self.confirmBtn];
    self.confirmBtn.frame = CGRectMake(16, 56, btmView.frame.size.width - 2 * 16, 48);
    [self.confirmBtn setTitle:NSLocalizableString(@"confirmDownload", nil) forState: UIControlStateNormal];
    self.confirmBtn.titleLabel.font = FONT_MEDIUM_17;
    [self.confirmBtn setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
    self.confirmBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    self.confirmBtn.layer.masksToBounds = YES;
    self.confirmBtn.layer.cornerRadius = 4;
    self.confirmBtn.tag = 10001;
    [self.confirmBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.gradientLayer = [CAGradientLayer layer];
    [HICCommonUtils createGradientLayerWithBtn:self.confirmBtn gradientLayer:self.gradientLayer fromColor:[UIColor colorWithHexString:@"00E2D8" alpha:0.4f] toColor:[UIColor colorWithHexString:@"00C5E0" alpha:0.4f]];

}

- (void)initTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CDVTitleSectionHeight, _container.frame.size.width, _container.frame.size.height - CDVTitleSectionHeight - CDVBtmViewHeight - HIC_BottomHeight + 50) style:UITableViewStylePlain];
    [_container addSubview:_tableView];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
     _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (@available(iOS 15.0, *)) {
        _tableView.sectionHeaderTopPadding = 0;
    }
}

#pragma mark tableview dataSorce协议
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _downloadArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HICCourseDownloadCell *courseDownloadCell = (HICCourseDownloadCell *)[tableView dequeueReusableCellWithIdentifier:courseDownloadIdenfer];
    if (courseDownloadCell == nil) {
        courseDownloadCell = [[HICCourseDownloadCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:courseDownloadIdenfer];
        [courseDownloadCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        courseDownloadCell.delegate = self;
    } else {
    }

    HICCourseDownloadModel *model = _downloadArr[indexPath.row];
    BOOL showExtraView = NO;
    for (int i = 0; i < _extraViewArr.count; i++) {
        NSArray *arr = [_extraViewArr[i] componentsSeparatedByString:@"_"];
        NSInteger index = [arr.firstObject integerValue];
        CGFloat extraHeight = [arr.lastObject floatValue];
        if (index == indexPath.row) {
            if (extraHeight > 0) {
                showExtraView = YES;
            } else {
                showExtraView = NO;
            }
            break;
        }
    }

    NSMutableArray *subItemCheckedArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < _clickedSubCellIndexArr.count; i ++) {
        NSArray *arr = [_clickedSubCellIndexArr[i] componentsSeparatedByString:@"_"];
        NSInteger cIndex = [arr.firstObject integerValue];
        NSInteger kIndex = [arr.lastObject integerValue];
        if (indexPath.row == cIndex) {
            [subItemCheckedArr addObject:@(kIndex)];
        }
    }

    [courseDownloadCell setData:model index:indexPath.row showExtraView:showExtraView subItemChecked:subItemCheckedArr checkedItems:[self knowledgeDownloadBefore:model]];

    return courseDownloadCell;

}

#pragma mark tableview delegate协议方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat returnHeight = STUDY_DOWNLOAD_CELL_HEIGHT;
    CGFloat lastCellHeight = 0.0;
    if (_extraViewArr.count > 0) {
        for (int i = 0; i < _extraViewArr.count; i++) {
            NSArray *arr = [_extraViewArr[i] componentsSeparatedByString:@"_"];
            NSInteger index = [arr.firstObject integerValue];
            CGFloat extraHeight = [arr.lastObject floatValue];
            if (index == indexPath.row && extraHeight >= 0) {
                returnHeight = STUDY_DOWNLOAD_CELL_HEIGHT + extraHeight;
            }
        }
    }
    if (indexPath.row == _downloadArr.count - 1) {
        lastCellHeight = 20;
    }
    return returnHeight + lastCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HICCourseDownloadModel *cModel = _downloadArr[indexPath.row];
    // 检测是否之前该课程中已有知识被下载过
    if ([self knowledgeDownloadBefore:cModel].count > 0) {
        return;
    }

    NSArray *tempClickedSubCellIndexArr = [[NSArray alloc] initWithArray:_clickedSubCellIndexArr];
    NSInteger count = 0;
    for (int i = 0; i < tempClickedSubCellIndexArr.count; i ++) {
        NSArray *arr = [tempClickedSubCellIndexArr[i] componentsSeparatedByString:@"_"];
        NSInteger cIndex = [arr.firstObject integerValue];
        if (indexPath.row == cIndex) {
            count = count + 1;
        }
    }
    NSArray *subItems = cModel.knowledgeArr;
    for (int i = 0; i < tempClickedSubCellIndexArr.count; i ++) {
        NSArray *arr = [tempClickedSubCellIndexArr[i] componentsSeparatedByString:@"_"];
        NSInteger cIndex = [arr.firstObject integerValue];
        if (indexPath.row == cIndex) {
            [_clickedSubCellIndexArr removeObject:tempClickedSubCellIndexArr[i]];
        }
    }
    if (count != subItems.count) {
        for (int i = 0; i < subItems.count; i++) {
            NSString *cKIndex = [NSString stringWithFormat:@"%ld_%ld",(long)indexPath.row, (long)i];
            [_clickedSubCellIndexArr addObject:cKIndex];
        }
    }
    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
    [self updateConfirmBtnLabel];
}

- (void)btnClicked:(UIButton *)btn {
    if (btn.tag == 10000) {
        [UIView animateWithDuration:0.3 animations:^{
            self->_container.frame = CGRectMake(0, HIC_ScreenHeight, self.frame.size.width, self.frame.size.height - 72);
        }];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self removeFromSuperview];
        });
    } else if (btn.tag == 10001) {
        // 点击确认下载按钮
        if (NetManager.netStatus == HICNetUnknown || NetManager.netStatus == HICNetNotReachable) {
            DDLogDebug(@"%@ No internet, can NOT download", logName);
            return;
        }
        if (NetManager.netStatus == HICNetWWAN) {
            [self createAlertViewWithTitle:NSLocalizableString(@"trafficRemind", nil) message:[NSString stringWithFormat:@"%@%@，\n%@",NSLocalizableString(@"consumptionFlowPrompt", nil),_downloadTotalSize,NSLocalizableString(@"whetherOrNotContinue", nil)] cancelTitle:NSLocalizableString(@"cancel", nil) confirmTitle:NSLocalizableString(@"continue", nil)];
        } else {
            [self downloadMedias];
        }
    }
}

- (void)updateConfirmBtnLabel {
    CGFloat totalSize = 0.0;
    for (int i = 0; i < _clickedSubCellIndexArr.count; i ++) {
        NSArray *arr = [_clickedSubCellIndexArr[i] componentsSeparatedByString:@"_"];
        NSInteger cIndex = [arr.firstObject integerValue];
        NSInteger kIndex = [arr.lastObject integerValue];
        HICCourseDownloadModel *cModel = _downloadArr[cIndex];
        HICKnowledgeDownloadModel *kModel = cModel.knowledgeArr[kIndex];
        totalSize = totalSize + [kModel.mediaSize floatValue];
        DDLogDebug(@"total Size: %f", totalSize);
    }
    NSString *btnTitle = totalSize > 0.0 ? [NSString stringWithFormat:@"(%@)",[NSString fileSizeWith:totalSize]] : @"";
    _downloadTotalSize = btnTitle;
    CGFloat alpha = 1.0f;
    if (![NSString isValidStr:btnTitle]) {
        alpha = 0.4f;
    }
    [self.gradientLayer removeFromSuperlayer];
    self.gradientLayer = [CAGradientLayer layer];
    [HICCommonUtils createGradientLayerWithBtn:self.confirmBtn gradientLayer:self.gradientLayer fromColor:[UIColor colorWithHexString:@"00E2D8" alpha:alpha] toColor:[UIColor colorWithHexString:@"00C5E0" alpha:alpha]];
    [self.confirmBtn setTitle:[NSString stringWithFormat:@"%@%@", NSLocalizableString(@"confirmDownload", nil),btnTitle] forState: UIControlStateNormal];
}


#pragma mark HICCourseDownloadCellDelegate
- (void)actionClicked:(NSInteger)index extraViewHeight:(CGFloat)height {

    NSString *temStr = [NSString stringWithFormat:@"%ld_%f",(long)index, -height];
    NSString *str = [NSString stringWithFormat:@"%ld_%f",(long)index, height];

    if ([NSString isValidStr:temStr]) {
        if ([_extraViewArr containsObject:temStr]) {
            [_extraViewArr removeObject:temStr];
        }
    }

    [_extraViewArr addObject:str];
    [_tableView reloadData];
}

- (void)subItemClicked:(NSInteger)tag {
    NSInteger cIndex = tag / 10000;
    NSInteger kIndex = tag % 10000;

    NSString *cKIndex = [NSString stringWithFormat:@"%ld_%ld",(long)cIndex, (long)kIndex];
    if (![_clickedSubCellIndexArr containsObject:cKIndex]) {
        [_clickedSubCellIndexArr addObject:cKIndex];
    } else {
        [_clickedSubCellIndexArr removeObject:cKIndex];
    }
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:cIndex inSection:0];
    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];

    [self updateConfirmBtnLabel];
}

// 获取某个课程下所有已经被下载的知识
- (NSArray *)knowledgeDownloadBefore:(HICCourseDownloadModel *)cModel {
    NSMutableArray *checkedItems = [[NSMutableArray alloc] init];
//    if (DLManager.downloadMediaArr.count > 0) {
//        for (HICKnowledgeDownloadModel *kModel in cModel.knowledgeArr) {
//            for (int j = 0; j < DLManager.downloadMediaArr.count; j ++) {
//                HICKnowledgeDownloadModel *tempkModel = DLManager.downloadMediaArr[j];
//                if ([kModel.mediaId isEqual:tempkModel.mediaId] && tempkModel.mediaStatus == HICDownloadFinish) {
//                    [checkedItems addObject:tempkModel.mediaId];
//                }
//            }
//        }
//    } else {
        [checkedItems addObjectsFromArray:[DBManager selectMediasByMediaSectionId:cModel.mediaId]];
//    }
    return checkedItems;
}

- (void)createAlertViewWithTitle:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelTitle confirmTitle:(NSString *)confirmTitle {
    //临时UIViewController，从它这里present UIAlertController
    UIViewController *viewCTL = [[UIViewController alloc]init];
    //这句话很重要
    [self addSubview:viewCTL.view];
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
                [self downloadMedias];
            }
        }];
        [canleBtn setValue:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1/1.0] forKey:@"_titleTextColor"];
        [identityBtn setValue:[UIColor colorWithRed:0/255.0 green:190/255.0 blue:215/255.0 alpha:1/1.0] forKey:@"_titleTextColor"];
        [alertVc addAction :identityBtn];
        [alertVc setPreferredAction:identityBtn];
    }

    [viewCTL presentViewController:alertVc animated:YES completion:nil];
}

- (void)downloadMedias {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"COURSE_DOWNLOADING" object:nil userInfo:nil];
    NSMutableArray *medias = [[NSMutableArray alloc] init];
    for (int i = 0; i < self->_clickedSubCellIndexArr.count; i ++) {
        NSArray *arr = [self->_clickedSubCellIndexArr[i] componentsSeparatedByString:@"_"];
        NSInteger cIndex = [arr.firstObject integerValue];
        NSInteger kIndex = [arr.lastObject integerValue];
        HICCourseDownloadModel *cModel = self->_downloadArr[cIndex];
        HICKnowledgeDownloadModel *kModel = cModel.knowledgeArr[kIndex];
        kModel.mediaDownloadCount = _clickedSubCellIndexArr.count;
        [medias addObject:kModel];
    }
    DLManager.readyForDownloadArr = [[NSMutableArray alloc] initWithArray:medias];
    NSMutableArray *temMedias = [[NSMutableArray alloc] initWithArray:DLManager.downloadMediaArr];
    [temMedias addObjectsFromArray:medias];
    DLManager.downloadMediaArr = temMedias;
    [DLManager startDownloadWith:@[]];
    DDLogDebug(@"%@ Download media ids: %@", logName, temMedias);
}

@end
