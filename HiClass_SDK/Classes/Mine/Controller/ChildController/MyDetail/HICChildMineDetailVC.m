//
//  HICChildMineDetailVC.m
//  HiClass
//
//  Created by WorkOffice on 2020/2/24.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICChildMineDetailVC.h"
#import "HICCheckNoteCell.h"
#import "HICCheckNoteModel.h"
#import "HICNetModel.h"
#import "HICCheckNoteView.h"
#import "HICCourseModel.h"
#import "HICCustomNaviView.h"
#import "HICKnowledgeDetailVC.h"
#import "HICLessonsVC.h"
static NSString *noteCell = @"noteCell";
@interface HICChildMineDetailVC ()<HICCheckNoteCellDelegate,HICCustomNaviViewDelegate>
@property (nonatomic ,strong) UIView *headerView;
@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) UIImageView *leftView;
@property (nonatomic ,strong) UILabel *nameLabel;
@property (nonatomic ,strong) UIButton *rightBtn;
@property (nonatomic ,strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger btnCanEditWithIndex;
@property (nonatomic ,strong) HICNetModel *netModel;
@property (nonatomic ,strong) HICCheckNoteView *noteView;
@end

@implementation HICChildMineDetailVC
- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, HIC_NavBarAndStatusBarHeight, HIC_ScreenWidth, 79)];
        _headerView.backgroundColor = [UIColor whiteColor];
    }
    return _headerView;
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0;
        }
    }
    return _tableView;
}
-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;

}
- (void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    HICCustomNaviView *navi = [[HICCustomNaviView alloc] initWithTitle:NSLocalizableString(@"noteDetails", nil) rightBtnName:nil showBtnLine:YES];
    navi.delegate = self;
    [self.view addSubview:navi];
    [self createUI];
    [self configTableView];
//    [self initData];
}
- (void)createUI{
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    [self.view addSubview:self.headerView];
    self.leftView = [[UIImageView alloc]init];
    self.leftView.layer.cornerRadius = 4;
    [self.headerView addSubview:self.leftView];
//    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:_model.coverPic]];
//    self.leftView.image = [UIImage imageWithData:data];
    [self.leftView sd_setImageWithURL:[NSURL URLWithString:_model.coverPic]];
    self.leftView.backgroundColor = [UIColor colorWithHexString:@"e6e6e6"];
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.textColor = [UIColor colorWithHexString:@"#181818"];
    self.nameLabel.font = FONT_MEDIUM_16;
    self.nameLabel.numberOfLines = 2;
    self.nameLabel.text = _model.courseKLDName;
    [self.headerView addSubview:self.nameLabel];
    self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.rightBtn setImage:[UIImage imageNamed:@"成绩详情-箭头"] forState:UIControlStateNormal];
    [self.rightBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.rightBtn hicChangeButtonClickLength:20];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(btnClick)];
    [self.headerView addGestureRecognizer:tap];
    self.headerView.userInteractionEnabled = YES;
    [self.headerView addSubview:self.rightBtn];
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    [self.headerView addSubview:line];
    [self.leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerView).offset(16);
        make.top.equalTo(self.headerView).offset(16.5);
        make.width.offset(84);
        make.height.offset(47);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftView.mas_right).offset(12);
//        make.top.equalTo(self.leftView);
         make.right.equalTo(self.headerView.mas_right).offset(-42);
        make.centerY.equalTo(self.leftView.mas_centerY);
    }];
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView).offset(33.5);
        make.left.equalTo(self.nameLabel.mas_right).offset(18);
        make.width.offset(7);
        make.height.offset(12);
    }];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerView);
        make.top.equalTo(self.headerView.mas_bottom).offset(8);
        make.width.offset(HIC_ScreenWidth);
        make.height.offset(8);
    }];
    
}
- (void)configTableView {
    [self.view addSubview:self.tableView];
    HICCheckNoteView *noteView = [[HICCheckNoteView alloc]initWithNotes:@[] type:_objectType identifier:[NSString stringWithFormat:@"%@",_objectId]];
    noteView.isMy = YES;
    [self.view addSubview:noteView];
}
//- (void)initData{
//    NSMutableDictionary *postModel = [NSMutableDictionary new];
//    [postModel setObject:[NSNumber numberWithInteger:_objectType] forKey:@"objectType"];
//    [postModel setObject:_objectId forKey:@"objectId"];
//    self.netModel = [[HICNetModel alloc]initWithURL:MY_NOTE_LIST  params:postModel];
//    self.netModel.contentType = HTTPContentTypeWwwFormType;
//    self.netModel.method = HTTPMethodGET;
//    self.netModel.urlType = DefaultExamURLType;
//    [NetManager sentHTTPRequest:self.netModel success:^(NSDictionary * _Nonnull responseObject){
//        if (responseObject[@"data"]) {
////            self.model = [HICCourseModel mj_objectWithKeyValues:responseObject[@"data"][@"courseKLDInfo"]];
////            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.model.coverPic]];
////            self.leftView.image = [UIImage imageWithData:data];
////            self.nameLabel.text = self.model.courseKLDName;
//        }
//    } failure:^(NSError * _Nonnull error) {
//
//    }];
//}
- (void)btnClick {
    
    if (![NSString isValidStr:[NSString stringWithFormat:@"%@",self.model.courseKLDId]]) {
        return;
    }
    if (self.model.courseKLDType == 6) {
        HICLessonsVC *vc = [HICLessonsVC new];
        vc.objectID = self.model.courseKLDId;
        HICStudyLogReportModel *reportModel = [[HICStudyLogReportModel alloc]initWithType:HICMyNoteToKnowledge];
                   ///日志上报
                   reportModel.mediaid = self.model.courseKLDId;
                   reportModel.knowtype = @-1;
                   reportModel.mediatype = [NSNumber numberWithInteger:HICReportCourseType];
                   NSMutableDictionary *report = [NSMutableDictionary dictionaryWithDictionary:[reportModel getParamDict]];
                   [report setValuesForKeysWithDictionary:[LogManager getSerLogEventDictWithType:HICMyNoteToKnowledge]];
                   [LogManager reportSerLogWithDict:report];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        HICKnowledgeDetailVC *vc = [HICKnowledgeDetailVC new];
        vc.objectId = self.model.courseKLDId;
        vc.kType = self.model.resourceType;
        vc.partnerCode = self.model.partnerCode;
        ///日志上报
        HICStudyLogReportModel *reportModel = [[HICStudyLogReportModel alloc]initWithType:HICMyNoteToKnowledge];
        reportModel.mediaid = self.model.courseKLDId;
        reportModel.knowtype = [NSNumber numberWithInteger:self.model.resourceType];
        reportModel.mediatype = [NSNumber numberWithInteger:HICReportKnowledgeType];
        NSMutableDictionary *report = [NSMutableDictionary dictionaryWithDictionary:[reportModel getParamDict]];
        [report setValuesForKeysWithDictionary:[LogManager getSerLogEventDictWithType:HICMyNoteToKnowledge]];
        [LogManager reportSerLogWithDict:report];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (void)leftBtnClicked {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
