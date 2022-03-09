//
//  HICTaskCneterVC.m
//  HiClass
//
//  Created by 铁柱， on 2020/1/14.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICTaskCneterVC.h"
#import "HICExamBaseVC.h"
#import "TaskTableViewCell.h"
#import "HICTestModel.h"
#import "HICExamBaseVC.h"
#import "HICExamModel.h"
#import "HICExamRecordModel.h"
#import "HICStudyBtmView.h"
#import "HICStudyShareView.h"
#import "HICCircleProgressView.h"
#import "HICCommentView.h"
#import "HICCommentWriteView.h"
#import "HICCollectionHintView.h"
#import "HICCommentModel.h"
#import "HICCheckNoteView.h"
#import "HICCourseDownloadView.h"
#import "HICCourseDownloadModel.h"
#import "HICKnowledgeDownloadModel.h"
#import "HICCommentPopupView.h"
#import "HICLoginManager.h"
#import "HICMyDownloadVC.h"
#import "HICMsgCenterVC.h"
#import "HICUpgradeView.h"
#import "HICLessonsVC.h"
#import "HICKnowledgeDetailVC.h"
#import "HICHomeworkListVC.h"
#import "HICOnlineTrainVC.h"

static NSString *taskCellIdenfer = @"taskCell";
static NSString *logName = @"[HIC][TC]";

@interface HICTaskCneterVC ()<UITableViewDelegate, UITableViewDataSource,HICStudyBtmViewDelegate, HICStudyShareViewDelegate, HICDownloadManagerDelegate> {
    UITableView *_tableView;
    NSArray *_tasksArr;
    NSArray *_taskItemsArr;
    NSMutableArray *_taskItemsModelArr;
    NSMutableArray *_taskItemsSectionArr;
    NSMutableArray *_cellIndexArr;
    double _oldY;
    BOOL _isScrolling;
    HICStudyBtmView *btmView;
    HICStudyShareView * studyView;
    HICCommentWriteView * cwv;
}
@property (nonatomic, strong) UIView *sectionView;
@property (nonatomic, strong) UIImageView *sectionIV;
@property (nonatomic, strong) UILabel *sectionLabel;

// 课程id输入
@property (nonatomic, strong) UITextField *courseIdTF;
@property (nonatomic, strong) UIButton *goToCourseBtn;
// 知识id输入
@property (nonatomic, strong) UITextField *kIdTF;
@property (nonatomic, strong) UITextField *typeTF;
@property (nonatomic, strong) UITextField *urlTF;
@property (nonatomic, strong) UIButton *goTokBtn;
@end

@implementation HICTaskCneterVC

- (UIView *)sectionView {
    if (!_sectionView) {
        _sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, TC_SECTION1_HEIGHT + HIC_StatusBar_Height, HIC_ScreenWidth, 22)];
        _sectionView.backgroundColor = GRAY_BACKGROUND;
    }
    return _sectionView;
}

- (UIImageView *)sectionIV {
    if (!_sectionIV) {
        _sectionIV = [[UIImageView alloc] initWithFrame:CGRectMake(17, (22 - 10)/2, 10, 10)];
    }
    return _sectionIV;
}

- (UILabel *)sectionLabel {
    if (!_sectionLabel) {
        _sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(42, 1, HIC_ScreenWidth, 20)];
        _sectionLabel.textColor = [UIColor colorWithRed:133/255.0 green:133/255.0 blue:133/255.0 alpha:1/1.0];
        _sectionLabel.font = FONT_MEDIUM_14;
    }
    return _sectionLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initUI];

    // 进入课程
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 230, 60, 30)];
    [self.view addSubview:label];
    label.text = [NSString stringWithFormat:@"%@: ",NSLocalizableString(@"courseID", nil)];;
    label.textColor = [UIColor blackColor];

    self.courseIdTF = [[UITextField alloc] initWithFrame:CGRectMake(80, 230, 80, 30)];
    [self.view addSubview:_courseIdTF];
    _courseIdTF.layer.borderWidth = 1;
    _courseIdTF.layer.borderColor = [UIColor blackColor].CGColor;
    _courseIdTF.textColor = [UIColor blackColor];
    self.goToCourseBtn = [[UIButton alloc] initWithFrame:CGRectMake(170, 230, 100, 30)];
    [self.view addSubview:_goToCourseBtn];
    _goToCourseBtn.tag = 1000;
    [_goToCourseBtn setTitle:NSLocalizableString(@"clickOnMe", nil) forState:UIControlStateNormal];
    [_goToCourseBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_goToCourseBtn setBackgroundColor:[UIColor lightGrayColor]];
    [_goToCourseBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];

    // 进入知识
    UILabel *klabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 270, 60, 30)];
    [self.view addSubview:klabel];
    klabel.text = [NSString stringWithFormat:@"%@: ",NSLocalizableString(@"knowledgeID", nil)];
    klabel.textColor = [UIColor blackColor];

    self.kIdTF = [[UITextField alloc] initWithFrame:CGRectMake(80, 270, 60, 30)];
    [self.view addSubview:_kIdTF];
    _kIdTF.layer.borderWidth = 1;
    _kIdTF.layer.borderColor = [UIColor blackColor].CGColor;
    _kIdTF.textColor = [UIColor blackColor];

    // 0-图片，1-视频，2-音频，3-文档，4-压缩包，5-scrom，6-html
    self.typeTF = [[UITextField alloc] initWithFrame:CGRectMake(150, 270, 80, 30)];
    [self.view addSubview:_typeTF];
    _typeTF.placeholder = NSLocalizableString(@"knowledgeType", nil);
    _typeTF.layer.borderWidth = 1;
    _typeTF.layer.borderColor = [UIColor blackColor].CGColor;
    _typeTF.textColor = [UIColor blackColor];

    UILabel *la = [[UILabel alloc] initWithFrame:CGRectMake(235, 260, 100, 60)];
    [self.view addSubview:la];
    la.text = NSLocalizableString(@"typeArray", nil);
    la.numberOfLines = 0;
    la.font = FONT_MEDIUM_9;
    la.textColor = [UIColor blueColor];

    self.goTokBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 310, 200, 30)];
    [self.view addSubview:_goTokBtn];
     _goTokBtn.tag = 1001;
    [_goTokBtn setTitle:NSLocalizableString(@"clickMeJumpVideoDetailsPage", nil) forState:UIControlStateNormal];
    [_goTokBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_goTokBtn setBackgroundColor:[UIColor lightGrayColor]];
    [_goTokBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];

    UIButton *goTokBtn1 = [[UIButton alloc] initWithFrame:CGRectMake(20, 350, 200, 30)];
    [self.view addSubview:goTokBtn1];
     goTokBtn1.tag = 1002;
    [goTokBtn1 setTitle:NSLocalizableString(@"clickMeJumpWordDetailsPage", nil) forState:UIControlStateNormal];
    [goTokBtn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [goTokBtn1 setBackgroundColor:[UIColor lightGrayColor]];
    [goTokBtn1 addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];

    self.urlTF = [[UITextField alloc] initWithFrame:CGRectMake(20, 390, HIC_ScreenWidth - 2 * 20, 30)];
    [self.view addSubview:_urlTF];
    _urlTF.placeholder = @"URL";
    _urlTF.layer.borderWidth = 1;
    _urlTF.layer.borderColor = [UIColor blackColor].CGColor;
    _urlTF.textColor = [UIColor blackColor];

    UIButton *goTokBtn2 = [[UIButton alloc] initWithFrame:CGRectMake(20, 430, 200, 30)];
    [self.view addSubview:goTokBtn2];
     goTokBtn2.tag = 1003;
    [goTokBtn2 setTitle:NSLocalizableString(@"clickMeJumpWebDetailsPage", nil) forState:UIControlStateNormal];
    [goTokBtn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [goTokBtn2 setBackgroundColor:[UIColor lightGrayColor]];
    [goTokBtn2 addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)btnClicked:(UIButton *)btn {
    if (btn.tag == 1000) {
        if (![NSString isValidStr:_courseIdTF.text]) {
            [HICToast showWithText:NSLocalizableString(@"enterCourseID", nil)];
            return;
        }
        HICLessonsVC *vc = [[HICLessonsVC alloc] init];
        vc.objectID = [_courseIdTF.text toNumber];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (btn.tag == 1001) {
        if (![NSString isValidStr:_kIdTF.text]) {
            [HICToast showWithText:NSLocalizableString(@"enterKnowledgeID", nil)];
            return;
        }
        if (![NSString isValidStr:_typeTF.text]) {
            [HICToast showWithText:NSLocalizableString(@"enterType", nil)];
            return;
        }
        HICKnowledgeDetailVC *vc = [[HICKnowledgeDetailVC alloc] init];
        vc.objectId = [_kIdTF.text toNumber];
        vc.kType = [_typeTF.text integerValue];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (btn.tag == 1002) {
        if (![NSString isValidStr:_kIdTF.text]) {
            [HICToast showWithText:NSLocalizableString(@"enterKnowledgeID", nil)];
            return;
        }
        HICKnowledgeDetailVC *vc = [[HICKnowledgeDetailVC alloc] init];
        vc.objectId = [_kIdTF.text toNumber];
        vc.kType = HICPictureType;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (btn.tag == 1003) {
        if (![NSString isValidStr:_kIdTF.text]) {
            [HICToast showWithText:NSLocalizableString(@"enterKnowledgeID", nil)];
            return;
        }
        if (![NSString isValidStr:_urlTF.text]) {
            [HICToast showWithText:NSLocalizableString(@"enterUrl", nil)];
            return;
        }
        HICKnowledgeDetailVC *htmlVC = [[HICKnowledgeDetailVC alloc] init];
        [self.navigationController pushViewController:htmlVC animated:YES];
        htmlVC.urlStr = _urlTF.text;
        htmlVC.hideNavi = NO;
        htmlVC.objectId = [_kIdTF.text toNumber];
        htmlVC.hideTabbar = NO;
        htmlVC.kType = HICHtmlType;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!self.navigationController.isNavigationBarHidden) {
        self.navigationController.navigationBarHidden = YES;
    }
//    [self requestData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)initData {
    _cellIndexArr = [[NSMutableArray alloc] init];
    _tasksArr = @[NSLocalizableString(@"testCenter", nil), NSLocalizableString(@"trainingManagement", nil), NSLocalizableString(@"clearCache", nil), NSLocalizableString(@"back", nil)];
}

- (void)requestData {
    NSMutableDictionary *dic  = [[NSMutableDictionary alloc] init];
    [dic setValue:USER_TOKEN forKey:@"accessToken"];
    [dic setValue:@(1) forKey:@"objectType"];
    [HICAPI examCenterList:dic success:^(NSDictionary * _Nonnull responseObject) {
        NSDictionary *dataDic = responseObject[@"data"];
        self->_taskItemsArr = dataDic[@"examList"];
        for (int i = 0; i < self->_taskItemsArr.count; i ++) {
            HICTestModel *model = [[HICTestModel alloc] initWithDic:dic];
            //                HICExamModel *model2 = [HICExamModel mj_objectWithKeyValues:dic];
            [self->_taskItemsModelArr addObject:model];
            NSNumber *assignTime = model.assignTime;
            NSString *assignTimeStr;
            if ([HICCommonUtils isSameDayWithTime:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]] isSecs:YES beComparedTime:assignTime]) {
                assignTimeStr = NSLocalizableString(@"todayDay", nil);
            } else {
                assignTimeStr = [HICCommonUtils timeStampToReadableDate:assignTime isSecs:YES format:[NSString stringWithFormat:@"M%@dd%@",NSLocalizableString(@"month", nil),NSLocalizableString(@"day", nil)]];
            }
            assignTimeStr = [NSString stringWithFormat:@"%@%@",assignTimeStr,NSLocalizableString(@"waitCompletedTask", nil)];
            if (![self->_taskItemsSectionArr containsObject:assignTimeStr]) {
                [self->_taskItemsSectionArr addObject:assignTimeStr];
            }
        }
    } failure:^(NSError * _Nonnull error) {
        DDLogDebug(@"error");
    }];
}

- (void)initUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.tabBarController.tabBar.hidden = YES;
    [self initNavigationBar];
//    [self initTableView];
}

- (void)initNavigationBar {
    UIView *naviView = [[UIView alloc] initWithFrame:CGRectMake(0, HIC_StatusBar_Height, HIC_ScreenWidth, TC_SECTION1_HEIGHT)];
    naviView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:naviView];

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 26, 88, 31)];
    titleLabel.text = NSLocalizableString(@"taskCenter", nil);
    titleLabel.font = FONT_MEDIUM_22;
    titleLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    [naviView addSubview:titleLabel];

    UIView *taskView = [[UIView alloc] initWithFrame:CGRectMake(0, 88, HIC_ScreenWidth, TC_SECTION1_HEIGHT - 88)];
    [naviView addSubview:taskView];

    CGFloat BtnHeight = 66.0;
    CGFloat leftMargin = [[HICCommonUtils iphoneType] isEqualToString:@"l-iPhone"] ? 1.5 * 16 : 16;
    CGFloat BtnInterval = (HIC_ScreenWidth - 4 * BtnHeight -  leftMargin * 2) / 3;

    UIScrollView *taskSV = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, HIC_ScreenWidth, TC_SECTION1_HEIGHT - 88)];
    taskSV.contentSize = CGSizeMake(BtnHeight * _tasksArr.count + BtnInterval * (_tasksArr.count - 1) + 2 * leftMargin, TC_SECTION1_HEIGHT - 88);
    taskSV.scrollEnabled = _tasksArr.count > 4 ? YES : NO;
    taskSV.showsHorizontalScrollIndicator = NO;  //不显示水平拖地的条
    taskSV.showsVerticalScrollIndicator=NO;      //不显示垂直拖动的条
    taskSV.pagingEnabled = NO;                   //允许分页滑动
    taskSV.bounces = NO;                         //到边了就不能再
    [taskView addSubview:taskSV];

    for(int i = 0; i < _tasksArr.count; i++){
        UIButton *taskBtn = [[UIButton alloc]initWithFrame:CGRectMake(leftMargin + i * BtnInterval + i * BtnHeight, 0, BtnHeight, BtnHeight)];
        taskBtn.backgroundColor = [UIImage imageNamed:_tasksArr[i]] ? [UIColor clearColor] : [UIColor redColor];
        [taskBtn addTarget:self action:@selector(taskBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [taskBtn setImage:[UIImage imageNamed:_tasksArr[i]] forState:UIControlStateNormal];
        taskBtn.layer.masksToBounds = YES;
        taskBtn.layer.cornerRadius = BtnHeight/2;
        taskBtn.tag = 10000 + i;
        [taskBtn setClipsToBounds:YES];
        [taskSV addSubview:taskBtn];

        CGSize taskNameLabelSize = [HICCommonUtils sizeOfString:_tasksArr[i] stringWidthBounding:HIC_ScreenWidth font:15 stringOnBtn:NO fontIsRegular:YES];
        CGFloat taskNameLabelX = leftMargin + BtnHeight/2 + i * BtnHeight + i * BtnInterval - taskNameLabelSize.width / 2;
        UILabel *taskNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(taskNameLabelX, 8 + BtnHeight, taskNameLabelSize.width, taskNameLabelSize.height)];
        taskNameLabel.text = _tasksArr[i];
        taskNameLabel.font = FONT_REGULAR_15;
        taskNameLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1/1.0];
        [taskSV addSubview:taskNameLabel];
    }
}

- (void)taskBtnClicked:(UIButton *)btn {
    if (btn.tag == 10000) {
        DDLogDebug(@"%@ Exam center clicked", logName);
        HICExamBaseVC *vc = [[HICExamBaseVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (btn.tag == 10001) {
        HICOnlineTrainVC *vc = [[HICOnlineTrainVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (btn.tag == 10002) {
        // 暂时加入，方便测试
        NSString *kFilePath = @"filePath";
        NSString *kFileSize = @"fileSize";
        NSMutableArray *cacheFileArr = [[NSMutableArray alloc]init];
        NSString *cacheDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        float folderSize = 0;
        if ([fileManager fileExistsAtPath:cacheDir]) {
            NSArray *childerFiles = [fileManager subpathsAtPath:cacheDir];
            for (NSString *fileName in childerFiles) {
                NSString *absolutePath = [cacheDir stringByAppendingPathComponent:fileName];
                float fileSize = [self fileSizeAtPath:absolutePath];
                NSNumber *fileSizeObj = [NSNumber numberWithFloat:fileSize];
                folderSize += fileSize;
                NSDictionary *cacheFileDic = [[NSDictionary alloc] initWithObjectsAndKeys:absolutePath, kFilePath, fileSizeObj, kFileSize, nil];
                [cacheFileArr addObject:cacheFileDic];
            }
        }

        NSFileManager *fileManager2 = [NSFileManager defaultManager];
        for (NSDictionary *cacheFileDic in cacheFileArr) {
            NSString *absolutePath = cacheFileDic[kFilePath];
            [fileManager2 removeItemAtPath:absolutePath error:nil];
        }
        [HICToast showWithText:NSLocalizableString(@"clearSuccess", nil)];
    } else {
        // 返回
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (float)fileSizeAtPath:(NSString *)path {
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:path]){
        long long size=[fileManager attributesOfItemAtPath:path error:nil].fileSize;
        return size/1024.0;
    }
    return 0;
}

- (void)initTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, HIC_StatusBar_Height + TC_SECTION1_HEIGHT, HIC_ScreenWidth, HIC_ScreenHeight - (HIC_StatusBar_Height + TC_SECTION1_HEIGHT)) style:UITableViewStylePlain];
    _tableView.backgroundColor = GRAY_BACKGROUND;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (@available(iOS 15.0, *)) {
        _tableView.sectionHeaderTopPadding = 0;
    }
    [self.view addSubview:_tableView];
}

#pragma mark tableview dataSorce协议
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _taskItemsModelArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TaskTableViewCell *taskCell = (TaskTableViewCell *)[tableView dequeueReusableCellWithIdentifier:taskCellIdenfer];
    if (taskCell == nil) {
        taskCell = [[TaskTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:taskCellIdenfer];
        [taskCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [_cellIndexArr addObject:indexPath];
    } else {
        NSArray *views = [taskCell subviews];
        for (UIView *obj in views) {
            if (obj.tag==1000) {      //只删除指定的自定View
                [obj removeFromSuperview];
            }
        }
        NSArray *subViews = [taskCell.taskContentView subviews];
        for (UIView *obj in subViews) {
            if (obj.tag==1000) {      //只删除指定的自定义View
                [obj removeFromSuperview];
            }
        }
    }
    HICTestModel *model = _taskItemsModelArr[indexPath.row];
    NSNumber *assignTime = model.assignTime;
    NSString *assignTimeStr;
    if ([HICCommonUtils isSameDayWithTime:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]] isSecs:YES beComparedTime:assignTime]) {
        assignTimeStr = NSLocalizableString(@"todayDay", nil);
    } else {
        assignTimeStr = [HICCommonUtils timeStampToReadableDate:assignTime isSecs:YES format:[NSString stringWithFormat:@"M%@dd%@",NSLocalizableString(@"month", nil),NSLocalizableString(@"day", nil)]];
    }
    assignTimeStr = [NSString stringWithFormat:@"%@%@",assignTimeStr,NSLocalizableString(@"waitCompletedTask", nil)];

    NSNumber *needShowSection = model.needShowSection;
    [taskCell setDataWith:model sectionName: [self showSectionWithStr:assignTimeStr needShowSection: [needShowSection isEqual:@(1)] ? YES : NO setShowSection:model] ? assignTimeStr : nil isFirstModel:indexPath.row == 0 ? YES : NO];
    return taskCell;

}

#pragma mark tableview delegate协议方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    HICTestModel *model = _taskItemsModelArr[indexPath.row];
    NSNumber *assignTime = model.assignTime;
    NSString *assignTimeStr;
    if ([HICCommonUtils isSameDayWithTime:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]] isSecs:YES beComparedTime:assignTime]) {
        assignTimeStr = NSLocalizableString(@"todayDay", nil);
    } else {
        assignTimeStr = [HICCommonUtils timeStampToReadableDate:assignTime isSecs:YES format:[NSString stringWithFormat:@"M%@dd%@",NSLocalizableString(@"month", nil),NSLocalizableString(@"day", nil)]];
    }
    assignTimeStr = [NSString stringWithFormat:@"%@%@",assignTimeStr,NSLocalizableString(@"waitCompletedTask", nil)];

    NSNumber *needShowSection = model.needShowSection;
    CGFloat assignTimeFloat = [self showSectionWithStr:assignTimeStr needShowSection:[needShowSection isEqual:@(1)] ? YES : NO setShowSection:model] ? 20 : -20;
    return 20 + assignTimeFloat + 8 + [self contentHeight:model];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([scrollView isEqual: _tableView]) {
        if (_tableView.contentOffset.y > _oldY) {
            // 上滑
            _isScrolling = YES;
            if ( _tableView.contentOffset.y - _oldY > 41) {
                if (!_sectionView) {
                    [self.view addSubview:self.sectionView];
                    [self.sectionView addSubview:self.sectionIV];
                    [self.sectionView addSubview:self.sectionLabel];
                }
            }
        } else if (_tableView.contentOffset.y < _oldY) {
            // 下滑
            if (_tableView.contentOffset.y < 0.0) {
                _isScrolling = NO;
                [self.sectionView removeFromSuperview];
                self.sectionView = nil;
            } else {
                 _isScrolling = YES;
            }
        } else {
            _isScrolling = NO;
        }
    }

    if (_cellIndexArr.count > 0) {
        for (int i = 0; i < _cellIndexArr.count; i++) {
            //标记的cell  在tableView中的坐标值
            CGRect  recttIntableview = [_tableView rectForRowAtIndexPath:_cellIndexArr[i]];
            //当前cell在屏幕中的坐标值
            CGRect rectInSuperView = [_tableView convertRect:recttIntableview toView:[_tableView superview]];
            if (rectInSuperView.origin.y < TC_SECTION1_HEIGHT + HIC_StatusBar_Height){ // 滑动到了屏幕上方
                NSIndexPath *indexPath = _cellIndexArr[i];
                if (_isScrolling) {
                    HICTestModel *model = _taskItemsModelArr[indexPath.row];
                    NSNumber *assignTime = model.assignTime;
                    NSString *assignTimeStr;
                    if ([HICCommonUtils isSameDayWithTime:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]] isSecs:YES beComparedTime:assignTime]) {
                        assignTimeStr = NSLocalizableString(@"todayDay", nil);
                    } else {
                        assignTimeStr = [HICCommonUtils timeStampToReadableDate:assignTime isSecs:YES format:[NSString stringWithFormat:@"M%@dd%@",NSLocalizableString(@"month", nil),NSLocalizableString(@"day", nil)]];
                    }
                    assignTimeStr = [NSString stringWithFormat:@"%@%@",assignTimeStr,NSLocalizableString(@"waitCompletedTask", nil)];
                    self.sectionLabel.text = assignTimeStr;
                    if ([assignTimeStr containsString:NSLocalizableString(@"todayDay", nil)]) {
                        _sectionIV.image = [UIImage imageNamed:@"时间圆点2"];
                        self.sectionLabel.textColor = [UIColor colorWithRed:255/255.0 green:133/255.0 blue:0/255.0 alpha:1/1.0];
                    } else {
                         _sectionIV.image = [UIImage imageNamed:@"时间圆点"];
                        self.sectionLabel.textColor = [UIColor colorWithRed:133/255.0 green:133/255.0 blue:133/255.0 alpha:1/1.0];
                    }
                }
            }
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    // 获取开始拖拽时tableview偏移量
    _oldY = _tableView.contentOffset.y;
}

- (CGFloat)labelHeightWithStr:(NSString *)str initHeight:(CGFloat)initHeight {
    UILabel *temLabel = [[UILabel alloc] init];
    temLabel.frame = CGRectMake(0, 0, HIC_ScreenWidth - 58 - 28, initHeight);
    temLabel.numberOfLines = 2;
    temLabel.font = FONT_MEDIUM_17;
    temLabel.text = str;
    [temLabel sizeToFit];
    return temLabel.frame.size.height;
}

- (BOOL)showSectionWithStr:(NSString *)assignTimeStr needShowSection:(BOOL)needShowSection setShowSection:(HICTestModel *)model {
    BOOL showSection = NO;
    if (needShowSection) {
        return YES;
    }
    for (int i = 0; i < _taskItemsSectionArr.count; i++) {
        NSString *section = _taskItemsSectionArr[i];
        if ([section isEqualToString:assignTimeStr]) {
            showSection = YES;
            model.needShowSection = @(1);
            [_taskItemsSectionArr removeObject:section];
        }
    }
    return showSection;
}

- (CGFloat)contentHeight:(HICTestModel *)model {
    UILabel *taskStatusLabel = [[UILabel alloc] init];
    taskStatusLabel.text = [NSString stringWithFormat:@"%@", model.start];
    taskStatusLabel.font = FONT_MEDIUM_15;
    CGFloat y = 12;
    CGFloat taskFinishStatusLabelHeight = [HICCommonUtils sizeOfString:taskStatusLabel.text stringWidthBounding:HIC_ScreenWidth font:15 stringOnBtn:NO fontIsRegular:NO].height;
    taskStatusLabel.frame = CGRectMake(0, 0, 0, taskFinishStatusLabelHeight);

    UILabel *taskTagLabel = [[UILabel alloc] init];
    taskTagLabel.text = NSLocalizableString(@"important", nil);
    CGFloat taskTagLabelWidth = [HICCommonUtils sizeOfString:taskTagLabel.text stringWidthBounding:HIC_ScreenWidth font:12 stringOnBtn:NO fontIsRegular:NO].width;

    UILabel *taskTitleLabel = [[UILabel alloc] init];
    taskTitleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    taskTitleLabel.numberOfLines = 2;
    taskTitleLabel.font = FONT_MEDIUM_17;
    taskTitleLabel.text = [NSString stringWithFormat:@"%@", model.name];
    y = y + taskStatusLabel.frame.size.height + 8;
    CGFloat taskTitleLabelHeight = [HICCommonUtils sizeOfString:taskTitleLabel.text stringWidthBounding:HIC_ScreenWidth - 58 - 28 font:17 stringOnBtn:NO fontIsRegular:NO].height;
    taskTitleLabel.frame = CGRectMake(0, 0, HIC_ScreenWidth - 58 - 28, taskTitleLabelHeight);
    NSMutableParagraphStyle*style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    //对齐方式
    style.alignment = NSTextAlignmentLeft;
    //首行缩进
    style.firstLineHeadIndent = taskTagLabelWidth + 12;
    NSAttributedString*attrText = [[NSAttributedString alloc] initWithString:taskTitleLabel.text attributes:@{NSParagraphStyleAttributeName: style}];
    taskTitleLabel.attributedText = attrText;
    [taskTitleLabel sizeToFit];

    UILabel *taskTimeLabel = [[UILabel alloc] init];
    taskTimeLabel.text = [NSString stringWithFormat:@"%@: %@", NSLocalizableString(@"testTime", nil),model.examTime];
    taskTimeLabel.font = FONT_REGULAR_15;
    y = y + taskTitleLabel.frame.size.height + 4;
    CGFloat taskTimeLabelHeight = [HICCommonUtils sizeOfString:taskTimeLabel.text stringWidthBounding:HIC_ScreenWidth font:15 stringOnBtn:NO fontIsRegular:YES].height;
    taskTimeLabel.frame = CGRectMake(0, 0, 0, taskTimeLabelHeight);
    y = y + taskTimeLabel.frame.size.height + 8;
    y = y + 0.5 + 8;

    UILabel *taskDurationLabel = [[UILabel alloc] init];
    taskDurationLabel.text = [NSString stringWithFormat:@"%@: %@%@",NSLocalizableString(@"testTime", nil), model.examDuration,NSLocalizableString(@"minutes", nil)];
    taskDurationLabel.font = FONT_REGULAR_14;
    CGFloat taskDurationLabelHeight = [HICCommonUtils sizeOfString:taskDurationLabel.text stringWidthBounding:HIC_ScreenWidth font:14 stringOnBtn:NO fontIsRegular:YES].height;
    taskDurationLabel.frame = CGRectMake(0, 0, 0, taskDurationLabelHeight);

    UILabel *taskTimesLabel = [[UILabel alloc] init];
    taskTimesLabel.text = [NSString stringWithFormat:@"%@: %@", NSLocalizableString(@"numberOfTestsAvailable", nil),model.examTimes];
    taskTimesLabel.font = FONT_REGULAR_14;
    CGFloat taskTimesLabelHeight = [HICCommonUtils sizeOfString:taskTimesLabel.text stringWidthBounding:HIC_ScreenWidth font:14 stringOnBtn:NO fontIsRegular:YES].height;
    taskTimesLabel.frame = CGRectMake(0, 0, 0, taskTimesLabelHeight);

    UILabel *taskPassScoreLabel = [[UILabel alloc] init];
    taskPassScoreLabel.text = [NSString stringWithFormat:@"%@: %@/%@%@",NSLocalizableString(@"passPoints", nil), model.passScore, model.score,NSLocalizableString(@"points", nil)];
    taskPassScoreLabel.font = FONT_REGULAR_14;
    CGFloat taskPassScoreLabelHeight = [HICCommonUtils sizeOfString:taskPassScoreLabel.text stringWidthBounding:HIC_ScreenWidth font:14 stringOnBtn:NO fontIsRegular:YES].height;
    taskPassScoreLabel.frame = CGRectMake(0, 0, 0, taskPassScoreLabelHeight);

    UILabel *taskAssignerLabel = [[UILabel alloc] init];
    taskAssignerLabel.text = [NSString stringWithFormat:@"%@: %@", NSLocalizableString(@"designatedPerson", nil),model.examer];
    taskAssignerLabel.font = FONT_REGULAR_14;
    CGFloat taskAssignerLabelHeight = [HICCommonUtils sizeOfString:taskAssignerLabel.text stringWidthBounding:HIC_ScreenWidth font:14 stringOnBtn:NO fontIsRegular:YES].height;
    taskAssignerLabel.frame = CGRectMake(0, 0, 0, taskAssignerLabelHeight);

    y = y + taskDurationLabel.frame.size.height;

    y = y + taskTimesLabel.frame.size.height;

    CGFloat scoreV = 16;
    if (model.grade.count > 0) {
        y = y + 8;
        y = y + 12 + 0.5;
        UILabel *taskGradeTitleLabel = [[UILabel alloc] init];
        taskGradeTitleLabel.font = FONT_MEDIUM_16
        taskGradeTitleLabel.text = NSLocalizableString(@"testScores", nil);
        CGFloat taskGradeTitleLabelHeight = [HICCommonUtils sizeOfString:taskGradeTitleLabel.text stringWidthBounding:HIC_ScreenWidth font:16 stringOnBtn:NO fontIsRegular:NO].height;
        CGFloat taskGradeTitleLabelWidth = [HICCommonUtils sizeOfString:taskGradeTitleLabel.text stringWidthBounding:HIC_ScreenWidth font:16 stringOnBtn:NO fontIsRegular:NO].width;
        taskGradeTitleLabel.frame = CGRectMake(16, y, taskGradeTitleLabelWidth, taskGradeTitleLabelHeight);
        y = y + taskGradeTitleLabel.frame.size.height + 8;
        y = y + 5 * (model.grade.count - 1) + model.grade.count * 42;
    }
    return y + scoreV;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

//    HICMyDownloadVC *vc = [[HICMyDownloadVC alloc] init];
//    HICMsgCenterVC *vc = [[HICMsgCenterVC alloc] init];
//    HICHomeworkListVC *vc = [[HICHomeworkListVC alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];

    [self.view endEditing:YES];

}

@end
