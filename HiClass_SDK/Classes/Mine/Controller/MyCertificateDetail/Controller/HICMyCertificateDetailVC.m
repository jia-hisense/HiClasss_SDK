//
//  HICMyCertificateDetailVC.m
//  HiClass
//
//  Created by Eddie_Ma on 18/4/20.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICMyCertificateDetailVC.h"
#import "HICMyCertDetailCell.h"
#import "HICCertificateModel.h"
#import "HomeworkImagePreViewVC.h"

static NSString *myCertDetailCellIdenfer = @"myCertDetailCell";
static NSString *logName = @"[HIC][MCDVC]";

@interface HICMyCertificateDetailVC () <HICCustomNaviViewDelegate, UITableViewDataSource, UITableViewDelegate, HICMyCertDetailCellDelegate>
@property (nonatomic, strong) HICCustomNaviView *navi;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) HICCertificateModel *certModel;
@property (nonatomic, assign) BOOL showAll;
@end

@implementation HICMyCertificateDetailVC

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

- (void)requestData {
    [HICAPI certificateDetails:self.employeeCertId success:^(NSDictionary * _Nonnull responseObject) {
        NSDictionary *data = [responseObject valueForKey:@"data"];
        if ([HICCommonUtils isValidObject:data]) {
            _certModel.certId = [data valueForKey:@"certId"];
            _certModel.certNo = [data valueForKey:@"certNo"];
            _certModel.name = [NSString isValidStr:[data valueForKey:@"name"]] ? [data valueForKey:@"name"] : NSLocalizableString(@"noNow", nil);
            _certModel.employeeName = [data valueForKey:@"employeeName"];
            _certModel.createdTime = [data valueForKey:@"createdTime"];
            _certModel.authority = [NSString isValidStr:[data valueForKey:@"authority"]] ? [data valueForKey:@"authority"] : NSLocalizableString(@"licenseIssuingAuthorityUnknown", nil);
            _certModel.status = [[data valueForKey:@"status"] intValue];
            _certModel.effectiveDate = [data valueForKey:@"effectiveDate"] ? [data valueForKey:@"effectiveDate"] : _certModel.createdTime;
            _certModel.expireDate = [[data valueForKey:@"expireDate"] integerValue] <= 0 ? @([[data valueForKey:@"expireDate"] integerValue]) : [data valueForKey:@"expireDate"];
            _certModel.picUrl = [data valueForKey:@"picUrl"];
                _certModel.desc = [NSString isValidStr:[data valueForKey:@"description"]] ? [data valueForKey:@"description"] : NSLocalizableString(@"noNow", nil);
            _certModel.certSource = [NSString isValidStr:[data valueForKey:@"certSource"]] ? [data valueForKey:@"certSource"] : NSLocalizableString(@"noNow", nil);
            _certModel.reason = [NSString isValidStr:[data valueForKey:@"reason"]] ? [data valueForKey:@"reason"] : NSLocalizableString(@"noNow", nil);
        }
        if (_certModel) {
            [self.tableView reloadData];
        }
    }];
}

- (void)initData {
    self.certModel = [[HICCertificateModel alloc] init];
}

- (void)createUI {
    [self createNavi];
    [self createTableView];
}

- (void)createNavi {
    self.navi = [[HICCustomNaviView alloc] initWithTitle:NSLocalizableString(@"certificate", nil) rightBtnName:@"" showBtnLine:YES];
    _navi.delegate = self;
    [self.view addSubview:_navi];
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

#pragma mark tableview dataSorce协议
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HICMyCertDetailCell *myCertDetailCell = (HICMyCertDetailCell *)[tableView dequeueReusableCellWithIdentifier:myCertDetailCellIdenfer];
    if (myCertDetailCell == nil) {
        myCertDetailCell = [[HICMyCertDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCertDetailCellIdenfer];
        [myCertDetailCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        myCertDetailCell.delegate = self;
    } else {
    }

    [myCertDetailCell setData:_certModel index:indexPath.row descShowAll:self.showAll];
    return myCertDetailCell;

}

#pragma mark tableview delegate协议方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 16 + (HIC_ScreenWidth - 16 *2) * 193 / 343 + 16 + [self getContentHeight:_certModel.name fontSize:17 numOfLines:2 isDesc:NO] + 12 + 80 + 16.5 + 16 + 21 + 8 + [self getContentHeight:_certModel.authority fontSize:14 numOfLines:2 isDesc:NO] + 16 + 21 + 8 + [self getContentHeight:_certModel.certSource fontSize:14 numOfLines:2 isDesc:NO] + 16 + 8;
    } else {
        return 16 + 21 + 8 + [self getContentHeight:_certModel.desc fontSize:14 numOfLines:_showAll ? 0 : 3 isDesc:YES] + 16 + 21 + 8 + [self getContentHeight:_certModel.reason fontSize:14 numOfLines:0 isDesc:NO] + 16;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

- (CGFloat)getContentHeight:(NSString *)str fontSize:(NSInteger)font numOfLines:(NSInteger)num isDesc:(BOOL)isDesc {
    if (str) {
        UILabel *label = [[UILabel alloc] init];
        label.text = str;
        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:font];
        label.numberOfLines = num;
        CGFloat labelHeight = [HICCommonUtils sizeOfString:str stringWidthBounding:HIC_ScreenWidth - 2 * 16 font:font stringOnBtn:NO fontIsRegular:YES].height;
        label.frame = CGRectMake(0, 0, HIC_ScreenWidth - 2 * 16, labelHeight);
        [label sizeToFit];

        CGFloat showAllbtnH = 0;
        if (isDesc) {
            NSArray *descLines = [HICCommonUtils getLinesArrayOfStringInLabel:label];
            if (descLines.count > 3) {
                showAllbtnH = 20;
            }
        }
        return label.frame.size.height + showAllbtnH;
    } else {
        return 0;
    }
}

#pragma mark - - - HICCustomNaviViewDelegate - - -
- (void)leftBtnClicked {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - - - HICMyCertDetailCellDelegate - - -
- (void)imgClicked:(NSString *)url {
    HomeworkImagePreViewVC *imgPre = [[HomeworkImagePreViewVC alloc] init];
    imgPre.modalPresentationStyle = UIModalPresentationFullScreen;
    if ([NSString isValidStr:url]) {
        imgPre.previewDownImages = @[url];
    } else {
        imgPre.previewWithImageName = @"证书默认图";
    }
    [self.navigationController presentViewController:imgPre animated:YES completion:nil];
}

- (void)showAll:(BOOL)showAll index:(NSInteger)index{
    self.showAll = showAll;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    //2.将indexPath添加到数组
    NSArray <NSIndexPath *> *indexPathArray = @[indexPath];
    //3.传入数组，对当前cell进行刷新
    [_tableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationAutomatic];
}

@end
