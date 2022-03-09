//
//  HICHomeWorkDetail.m
//  HiClass
//
//  Created by 铁柱， on 2020/3/26.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICHomeWorkDetail.h"

#import "HomeworkDetailTitleCell.h"
#import "HomeworkDetailReqCell.h"
#import "HomeworkDetailWriteCell.h"
#import "HomeworkDetailTeacherCell.h"

#import "HICHomeWorkWriteVC.h"
#import "HomeworkImagePreViewVC.h"
#import <AVKit/AVKit.h>

#import "HomeworkDetailModel.h"

@interface HICHomeWorkDetail ()<UITableViewDataSource, UITableViewDelegate, HomeworkDetailBaseCellDelegate>

@property (nonatomic, strong) UIButton *rightBut;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIButton *writeBut;

@property (nonatomic, strong) HomeworkDetailModel *detailModel;

@end

@implementation HICHomeWorkDetail
#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.whiteColor;

    [self.view addSubview:self.tableView];
    [self.tableView registerClass:HomeworkDetailTitleCell.class forCellReuseIdentifier:@"TitleCell"];
    [self.tableView registerClass:HomeworkDetailReqCell.class forCellReuseIdentifier:@"ReqCell"];
    [self.tableView registerClass:HomeworkDetailWriteCell.class forCellReuseIdentifier:@"WriteCell"];
    [self.tableView registerClass:HomeworkDetailTeacherCell.class forCellReuseIdentifier:@"TeacherCell"];

    [self createNavUI];
    [self createWriteBut];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self loadDataSever];
    if (_status == HICHomeworkWaitForGrading) {
        self.rightBut.hidden = NO;
        self.writeBut.hidden = YES;
    }else if (_status == HICHomeworkWaitForCompleting) {
        self.writeBut.hidden = NO;
        self.rightBut.hidden = YES;
    }else {
        self.writeBut.hidden = YES;
        self.rightBut.hidden = YES;
    }
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

}
#pragma mark - 创建导航栏-页面视图
- (void)createNavUI {
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
    CGSize titleSize = [HICCommonUtils sizeOfString:NSLocalizableString(@"jobDetails", nil) stringWidthBounding:HIC_ScreenWidth - 44 * 2 font:18 stringOnBtn:NO fontIsRegular:NO];
    titleLabel.text = NSLocalizableString(@"jobDetails", nil);
    titleLabel.font = FONT_MEDIUM_18;
    titleLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    titleLabel.frame = CGRectMake((HIC_ScreenWidth - titleSize.width)/2, (HIC_NavBarHeight - 25)/2, titleSize.width, 25);

    UIButton *rightBtn = [[UIButton alloc] init];
    [backView addSubview:rightBtn];
    rightBtn.frame = CGRectMake(HIC_ScreenWidth - (16 + 64 + 16), 0, 16 + 64 + 16, HIC_NavBarHeight);
    [rightBtn addTarget:self action:@selector(clickRightBut:) forControlEvents:UIControlEventTouchUpInside];

    UILabel *rightLabel = [[UILabel alloc] init];
    [rightBtn addSubview:rightLabel];
    rightLabel.frame = CGRectMake(16, (HIC_NavBarHeight - 22.5)/2, 64, 22.5);
    rightLabel.text = NSLocalizableString(@"withdrawEditor", nil);
    rightLabel.textColor = [UIColor colorWithRed:3/255.0 green:179/255.0 blue:204/255.0 alpha:1/1.0];
    rightLabel.font = FONT_MEDIUM_16
    rightBtn.hidden = YES;

    self.rightBut = rightBtn;
    if (_status == HICHomeworkWaitForGrading) {
        rightBtn.hidden = NO;
    }

    UIView *naviBtmLine = [[UIView alloc] initWithFrame:CGRectMake(0, HIC_NavBarHeight - 0.5, HIC_ScreenWidth, 0.5)];
    [backView addSubview:naviBtmLine];
    naviBtmLine.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1/1.0];
}

-(void)createWriteBut {

    UIButton *writeBut = [[UIButton alloc] initWithFrame:CGRectMake(16, HIC_ScreenHeight-HIC_BottomHeight-16-48, HIC_ScreenWidth-16*2, 48)];
    [writeBut setTitle:NSLocalizableString(@"writeHomework", nil) forState:UIControlStateNormal];
    [writeBut setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [HICCommonUtils createGradientLayerWithBtn:writeBut fromColor:[UIColor colorWithHexString:@"#00e2d8"] toColor:[UIColor colorWithHexString:@"#00c5e0"]];
    writeBut.layer.cornerRadius = 4.f;
    writeBut.layer.masksToBounds = YES;
    [self.view addSubview:writeBut];
    writeBut.hidden = YES;
    self.writeBut = writeBut;
    if (_status == HICHomeworkWaitForCompleting) {
        writeBut.hidden = NO;
    }
    [writeBut addTarget:self action:@selector(clickWriteBut:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 网络数据请求
-(void)loadDataSever {
    NSString *train = _trainId?_trainId:@"";
    NSDictionary *dic = @{@"jobId":[NSNumber numberWithInteger:_jobId], @"trainId":train};
    [HICAPI homeworkSubtaskDetails:dic success:^(NSDictionary * _Nonnull responseObject) {
        self.detailModel = [HomeworkDetailModel createModeWithDataSource:responseObject];
        [self.tableView reloadData];
    }];
}

#pragma mark - 页面的点击事件
-(void)clickLeftBut:(UIButton *)but {
    DDLogDebug(@"left");
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)clickRightBut:(UIButton *)but {
    // 此时需要撤销编辑

    NSDictionary *dic = @{@"jobId":[NSNumber numberWithInteger:_detailModel.jobId], @"jobRetId":[NSNumber numberWithInteger:_detailModel.jobRetId], @"workId":[NSNumber numberWithInteger:_workId]};
    [HICAPI homeworkSubtaskWithdraw:dic success:^(NSDictionary * _Nonnull responseObject) {
        self.writeBut.hidden = NO;
        self.rightBut.hidden = YES;
        _status = HICHomeworkWaitForCompleting;
        [self.tableView reloadData];
        // 等同于点击写作业， 但是需要传递 之前编辑的内容给写作业页面
        [self clickWriteBut:self.writeBut andWithAgainWrite:YES];
    }];
}

-(void)clickWriteBut:(UIButton *)but {
    HICHomeWorkWriteVC *vc = HICHomeWorkWriteVC.new;
    if (self.detailModel.jobTypes) {
        NSMutableArray *array = [NSMutableArray arrayWithArray:[self.detailModel.jobTypes componentsSeparatedByString:@","]];
        [array removeObject:@""];
        if (array.count != 0) {
            vc.toolBars = array;
            vc.detailVC = self;
            vc.detailModel = self.detailModel;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }

}

-(void)clickWriteBut:(UIButton *)but andWithAgainWrite:(BOOL)isAgain {
    HICHomeWorkWriteVC *vc = HICHomeWorkWriteVC.new;
    if (isAgain) {
        if (self.detailModel.jobTypes) {
            NSMutableArray *array = [NSMutableArray arrayWithArray:[self.detailModel.jobTypes componentsSeparatedByString:@","]];
            [array removeObject:@""];
            if (array.count != 0) {
                vc.toolBars = array;
                vc.detailVC = self;
                vc.detailModel = self.detailModel;
                vc.isAgainWrite = isAgain;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    }
}

#pragma mark - TableDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger num = 0;
    if (!self.detailModel) {
        return num;
    }
    if (_status == HICHomeworkCompleted && self.detailModel.reviewFlag == 1) {
        num = 4;
    }else if (_status == HICHomeworkCompleted && self.detailModel.reviewFlag == 0) {
        num = 3;
    }else if (_status == HICHomeworkWaitForGrading || _status == HICHomeworkGrading) {
        num = 3;
    }else if (_status == HICHomeworkWaitForCompleting) {
        num = 2;
    }
    return num;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeworkDetailBaseCell *cell ;
    if (indexPath.row %4 == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"TitleCell" forIndexPath:indexPath];
    }else if(indexPath.row %4 == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"ReqCell" forIndexPath:indexPath];
    }else if (indexPath.row %4 == 2) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"WriteCell" forIndexPath:indexPath];
    }else if (indexPath.row %4 == 3) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"TeacherCell" forIndexPath:indexPath];
    }
    cell.cellIndexPath = indexPath;
    cell.titleName = _jobName;
    if (_status == HICHomeworkCompleted) {
        if (self.detailModel.reviewFlag == 1) {
            cell.endTime = [NSString stringWithFormat:@"%@: %@", NSLocalizableString(@"markingTime", nil),[HICCommonUtils timeStampToReadableDate:[NSNumber numberWithInteger:self.detailModel.reviewTime] isSecs:YES format:@"MM-dd HH:mm"]];
        }else {
            cell.endTime = [NSString stringWithFormat:@"%@: %@", NSLocalizableString(@"submitTime", nil),[HICCommonUtils timeStampToReadableDate:[NSNumber numberWithInteger:self.detailModel.commitTime] isSecs:YES format:@"MM-dd HH:mm"]];
        }
        cell.totalScore = self.detailModel.maxScore;
        [cell setCellPassImage:self.detailModel.pass score:self.detailModel.score isShowScore:_isShowScore];

    }else if (_status == HICHomeworkWaitForGrading || _status == HICHomeworkGrading) {
        cell.endTime = [NSString stringWithFormat:@"%@: %@", NSLocalizableString(@"submitTime", nil),[HICCommonUtils timeStampToReadableDate:[NSNumber numberWithInteger:self.detailModel.commitTime] isSecs:YES format:@"MM-dd HH:mm"]];
    }else if (_status == HICHomeworkWaitForCompleting || _status == HICHomeworkNotStart) {
        cell.endTime = [_endTime isEqualToNumber:@0]?[NSString stringWithFormat:@"%@: %@",NSLocalizableString(@"dendline", nil),NSLocalizableString(@"unlimited", nil)]: [NSString stringWithFormat:@"%@: %@", NSLocalizableString(@"dendline", nil),[HICCommonUtils timeStampToReadableDate:_endTime isSecs:YES format:@"MM-dd HH:mm"]];
    }
    cell.detailModel = self.detailModel; // 赋值不能早于setCellPassImage方法，需要精华覆盖
    cell.delegate = self;

    return cell;
}

#pragma mark - TableDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat strHeight = 0;
    if (indexPath.row %4 == 0) {
        strHeight = [HomeworkDetailTitleCell getStringHeight:_jobName];
        return 104 + strHeight;
    }else if ( indexPath.row %4 == 1) {
        strHeight = [HomeworkDetailReqCell getStringHeight:self.detailModel.requires];
        if (self.detailModel.rewardPoints == 0) {
            return 87 + strHeight;
        }
        return 107 + 20 + strHeight;
    }else if (indexPath.row %4 == 2) {
        strHeight = [HomeworkDetailWriteCell getStringHeight:self.detailModel.textContent];
        CGFloat imageHeight = 0;
        if (self.detailModel.attachments.count > 0) {
            NSInteger line = self.detailModel.attachments.count % 4;
            NSInteger row = self.detailModel.attachments.count / 4;
            if (line != 0) {
                row += 1;
            }
            imageHeight = row*HWD_WriteContentImageWidth+(row-1)*HWD_WriteContentImageRowSepc;
        }
        return 117.f + strHeight + imageHeight;
    }else if (indexPath.row %4 == 3) {
        strHeight = [HomeworkDetailTeacherCell getStringHeight:self.detailModel.evaluation];
        if (strHeight > 0) {
            return 117.f + strHeight;
        }else{
            return 0;
        }
        
    }
    return 0;
}

#pragma mark - cell的协议方法
-(void)detailBaseCell:(HomeworkDetailBaseCell *)cell didSelectIndex:(NSInteger)currentIndex withModel:(HomeworkDetailAttachmentModel *)attModel {

    if (attModel.type == 1 || attModel.type == 2) {
        if (attModel.url) {
            AVPlayerViewController *vc = [AVPlayerViewController new];
            vc.player = [AVPlayer playerWithURL:[NSURL URLWithString:attModel.url]];
            [vc.player play];
            vc.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:vc animated:YES completion:nil];
        }
    }else if (attModel.type == 4) {
        HomeworkImagePreViewVC *vc = [HomeworkImagePreViewVC new];
        vc.currentIndex = currentIndex;
        vc.attachDataSource = self.detailModel.attachments;
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:vc animated:YES completion:^{
        }];
    }
}

#pragma mark - 懒加载
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, HIC_StatusBar_Height+HIC_NavBarHeight, HIC_ScreenWidth, HIC_ScreenHeight-(HIC_StatusBar_Height+HIC_NavBarHeight)-HIC_BottomHeight) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0;
        }
    }
    return _tableView;
}

@end
