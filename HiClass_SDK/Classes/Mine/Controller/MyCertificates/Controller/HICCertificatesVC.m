//
//  HICCertificatesVC.m
//  HiClass
//
//  Created by Eddie_Ma on 18/4/20.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICCertificatesVC.h"
#import "HICCertificateCell.h"
#import "HICCertificateModel.h"
#import "HICMyCertificateDetailVC.h"

static NSString *myCertificatesCellIdenfer = @"myCertificatesCell";
static NSString *logName = @"[HIC][CVC]";
static NSInteger requestRowsNum = 10;

@interface HICCertificatesVC () <HICCustomNaviViewDelegate, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UIView *emtyView;
@property (nonatomic, strong) HICCustomNaviView *navi;
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger totalCount;
@property (nonatomic, assign) NSInteger requestRows;
@property (nonatomic, assign) NSInteger offset;
@end

@implementation HICCertificatesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initData];
    [self createUI];
}

- (void)viewWillAppear:(BOOL)animated {
    if (!self.navigationController.isNavigationBarHidden) {
        self.navigationController.navigationBarHidden = YES;
    }
    [self requestData];
}

- (void)initData {
    self.requestRows = requestRowsNum;
    self.totalCount = -1;
    self.items = [[NSMutableArray alloc] init];
}

- (void)createUI {
    [self createNavi];
    [self createTableView];
    [self createEmtyView];
}

- (void)requestData {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:@(_items.count) forKey:@"startNum"];
    [dic setValue:@(_requestRows) forKey:@"offset"];
    [HICAPI certificateList:dic success:^(NSDictionary * _Nonnull responseObject) {
        NSDictionary *data = [responseObject valueForKey:@"data"];
        if ([HICCommonUtils isValidObject:data]) {
            NSArray *list = [data valueForKey:@"list"];
            if ([HICCommonUtils isValidObject:list]) {
                for (int i = 0; i < list.count; i ++) {
                    HICCertificateModel *cerModel = [[HICCertificateModel alloc] init];
                    cerModel.employeeCertId = [list[i] valueForKey:@"employeeCertId"];
                    cerModel.certId = [list[i] valueForKey:@"certId"];
                    cerModel.certNo = [list[i] valueForKey:@"certNo"];
                    cerModel.name = [list[i] valueForKey:@"name"];
                    cerModel.employeeName = [list[i] valueForKey:@"employeeName"];
                    cerModel.createdTime = [list[i] valueForKey:@"createdTime"];
                    cerModel.authority = [list[i] valueForKey:@"authority"];
                    cerModel.status = [[list[i] valueForKey:@"status"] intValue];
                    cerModel.effectiveDate = [list[i] valueForKey:@"effectiveDate"];
                    cerModel.expireDate = [list[i] valueForKey:@"expireDate"];
                    cerModel.picUrl = [list[i] valueForKey:@"picUrl"];
                    cerModel.revokeReason = [list[i] valueForKey:@"revokeReason"];
                    [_items addObject:cerModel];
                }
            }
        }
        if (_items.count > 0) {
            _emtyView.hidden = YES;
            self.requestRows = requestRowsNum;
            [self.tableView reloadData];
        } else {
            _emtyView.hidden = NO;
        }
    }];
}

- (void)createNavi {
    self.navi = [[HICCustomNaviView alloc] initWithTitle:NSLocalizableString(@"certificate", nil) rightBtnName:@"" showBtnLine:YES];
    _navi.delegate = self;
    [self.view addSubview:_navi];
}

- (void)createEmtyView {
    self.emtyView = [[UIView alloc] init];
    [self.view addSubview:_emtyView];
    _emtyView.frame = CGRectMake(0, HIC_NavBarAndStatusBarHeight, HIC_ScreenWidth, HIC_ScreenHeight - HIC_NavBarAndStatusBarHeight);
    _emtyView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1/1.0];
    _emtyView.hidden = NO;

    CGFloat topMargin = (_emtyView.frame.size.height - 120)/2 - 60;
    UIImageView *imgV = [[UIImageView alloc] init];
    [_emtyView addSubview:imgV];
    imgV.image = [UIImage imageNamed:@"证书-空白页"];
    imgV.frame = CGRectMake((HIC_ScreenWidth - 120)/2 , topMargin, 120, 120);

    UILabel *emptyLabel  = [[UILabel alloc] init];
    [_emtyView addSubview:emptyLabel];
    emptyLabel.text = NSLocalizableString(@"notGettingCertificatePrompt", nil);
    emptyLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1/1.0];
    emptyLabel.font = FONT_REGULAR_16;
    emptyLabel.textAlignment = NSTextAlignmentCenter;
    emptyLabel.frame = CGRectMake(0, topMargin + imgV.frame.size.height + 8, HIC_ScreenWidth, 22.5);
}

- (void)createTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, HIC_NavBarAndStatusBarHeight, HIC_ScreenWidth, HIC_ScreenHeight - HIC_NavBarAndStatusBarHeight) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1/1.0];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.estimatedRowHeight = 150;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[HICCertificateCell class] forCellReuseIdentifier:myCertificatesCellIdenfer];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(HIC_NavBarAndStatusBarHeight);
    }];
    if (@available(iOS 15.0, *)) {
        _tableView.sectionHeaderTopPadding = 0;
    }
}

#pragma mark tableview dataSorce协议
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HICCertificateCell *certificateCell = [tableView dequeueReusableCellWithIdentifier:myCertificatesCellIdenfer forIndexPath:indexPath];
    [certificateCell setData:_items[indexPath.row]];
    return certificateCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

#pragma mark tableview delegate协议方法

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HICCertificateModel *cerModel = _items[indexPath.row];
    if (cerModel.status == HICCertInvalided || cerModel.status == HICCertRevoke) {
        return;
    }
    HICMyCertificateDetailVC *detailVC = [[HICMyCertificateDetailVC alloc] init];
    detailVC.employeeCertId = [cerModel.employeeCertId toString];
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat reminder =  (float)(self.items.count % _requestRows); // 判断是否还需要继续请求新数据
    BOOL httpSendBack = _totalCount != _items.count ? YES : NO; // 用于检测是否有新数据来，防止新数据还没来，又去刷新请求
    if (indexPath.row == _items.count - 3 && reminder == 0.0 && httpSendBack) {
        [self requestData];
        _totalCount = _items.count;
    }
}


#pragma mark - - - HICCustomNaviViewDelegate - - -
- (void)leftBtnClicked {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
