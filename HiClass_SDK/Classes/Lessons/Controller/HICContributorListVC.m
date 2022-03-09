//
//  HICContributorListVC.m
//  HiClass
//
//  Created by WorkOffice on 2020/2/5.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICContributorListVC.h"
#import "HICContributeKnowledgeCell.h"
#import "HICNetModel.h"
#import "HICCourseModel.h"
#import "HICAuthorCustomerModel.h"
#import "HICKnowledgeDetailVC.h"
#import "HICLessonsVC.h"
static NSString *contributeCell = @"contributeCell";
@interface HICContributorListVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong)UIView *topView;
@property (nonatomic ,strong)UIImageView *headerBackView;
@property (nonatomic ,strong)UIImageView *headerImageView;
@property (nonatomic ,strong)UILabel *nameLabel;
@property (nonatomic ,strong)UILabel *companyLabel;
@property (nonatomic ,strong)UITableView *listView;
@property (nonatomic ,strong)UIButton *backButton;
@property (nonatomic ,strong)NSMutableArray *dataArr;
@property (nonatomic ,strong)HICNetModel *netModel;
@property (nonatomic ,strong)HICAuthorCustomerModel *customerModel;
@end

@implementation HICContributorListVC
#pragma mark -lazyload
- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, HIC_ScreenWidth, 188 + HIC_Status_Phase_Height)];
        _topView.backgroundColor = [UIColor colorWithHexString:@"#999999"];
        [self.view addSubview:_topView];
    }
    return _topView;
}
- (UITableView *)listView{
    if (!_listView) {
        _listView = [[UITableView alloc]initWithFrame:CGRectMake(0, 188 + HIC_Status_Phase_Height, HIC_ScreenWidth, HIC_ScreenHeight - 188 - HIC_Status_Phase_Height) style:UITableViewStylePlain];
        if (@available(iOS 15.0, *)) {
            _listView.sectionHeaderTopPadding = 0;
        }
    }
    return _listView;
}
- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray new];
    }
    return _dataArr;
}
- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    [self createHeader];
    [self initData];
    
}
//创建顶部视图
- (void)createHeader {
    self.headerBackView =  [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"贡献者主页-背景"]];
    [self.topView addSubview:self.headerBackView];
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backButton setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.backButton hicChangeButtonClickLength:30];
    self.headerBackView.userInteractionEnabled = true;
    [self.headerBackView addSubview:self.backButton];

    self.headerImageView = [[UIImageView alloc]init];
    self.headerImageView.backgroundColor = [UIColor lightGrayColor];
    [self.headerBackView addSubview:self.headerImageView];
    _headerImageView.layer.cornerRadius = 4;
    _headerImageView.layer.masksToBounds = YES;
    
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.font = FONT_MEDIUM_20;
    self.nameLabel.textColor = TEXT_COLOR_DARK;
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    [self.headerBackView addSubview:self.nameLabel];
    
    self.companyLabel = [[UILabel alloc]init];
    self.companyLabel.textColor = TEXT_COLOR_LIGHT;
    self.companyLabel.font = FONT_REGULAR_14;
    self.companyLabel.textAlignment = NSTextAlignmentCenter;
    self.companyLabel.lineBreakMode = NSLineBreakByTruncatingHead;
    [self.headerBackView addSubview:self.companyLabel];
    [self updateViewConstraints];
    if (_type == 1000) {//贡献者列表
        if([NSString isValidStr:self.contributor.picUrl]){
            [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:self.contributor.picUrl]];
        }else{
            UILabel *label = [HICCommonUtils setHeaderFrame:self.headerImageView.bounds andText:self.contributor.name];
            label.hidden = NO;
            [self.headerImageView addSubview:label];
        }
        self.nameLabel.text = self.contributor.name;
        self.companyLabel.text = [NSString isValidStr:self.contributor.positions] ? self.contributor.positions : @"";
    }else {//作者列表
        if ([_authorModel.type isEqual:@1]) {//内部人员
            self.customerModel = [HICAuthorCustomerModel mj_objectWithKeyValues:_authorModel.customer];
            if([NSString isValidStr:self.customerModel.picUrl]){
                [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:self.customerModel.picUrl]];
            }else{
                UILabel *label = [HICCommonUtils setHeaderFrame:self.headerImageView.bounds andText:self.customerModel.name];
                label.hidden = NO;
                [self.headerImageView addSubview:label];
            }
            
            self.nameLabel.text = self.customerModel.name;
            self.companyLabel.text = [NSString isValidStr:self.customerModel.positions] ? self.customerModel.positions : @"";
        }else{
            
            self.nameLabel.text = _authorModel.name;
            //            self.companyLabel.text = @"外部人员";
        }
        
        
    }

}
//配置tableview
- (void)configTableView{
    [self.view addSubview:self.listView];
    self.listView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.listView.separatorColor = [UIColor clearColor];
    self.listView.delegate = self;
    self.listView.dataSource = self;
    [self.listView registerClass:[HICContributeKnowledgeCell class] forCellReuseIdentifier:contributeCell];
}
- (void)updateViewConstraints {
    [super updateViewConstraints];
    [self.headerBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.width.offset(HIC_ScreenWidth);
        make.height.offset(188 + HIC_Status_Phase_Height);
    }];
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(32 + HIC_Status_Phase_Height);
        make.left.equalTo(self.view).offset(16);
        make.width.offset(12);
        make.height.offset(22);
    }];
    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(52 + HIC_Status_Phase_Height);
        make.centerX.equalTo(self.view);
        make.height.offset(60);
        make.width.offset(60);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(120 + HIC_Status_Phase_Height);
        make.centerX.equalTo(self.view);
        make.width.offset(HIC_ScreenWidth);
    }];
    [self.companyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(2);
        make.centerX.equalTo(self.view);
        make.left.equalTo(self.backButton);
        make.width.offset(HIC_ScreenWidth - 32);
    }];
    
    [self.view layoutIfNeeded];
}
- (void)initData{
    
    NSMutableDictionary *postModel = [NSMutableDictionary new];
    if (_type == 1000) {//贡献者
        if (!self.contributor.customerId) {
            [HICToast showWithText:NSLocalizableString(@"noIntroduction", nil)];
            return;
        }
        [postModel setObject:self.contributor.customerId forKey:@"contributor"];
        
    }else {
        if ([_authorModel.type isEqual:@1]) {//内部人员
            if (!self.customerModel.customerId) {
                [HICToast showWithText:NSLocalizableString(@"noIntroduction", nil)];
                return;
            }
            [postModel setObject:[NSString stringWithFormat:@"%@",self.customerModel.customerId] forKey:@"author"];
        }else{
            if (!_authorModel.name) {
                [HICToast showWithText:NSLocalizableString(@"noIntroduction", nil)];
                return;
            }
            [postModel setObject:[NSString stringWithFormat:@"%@",_authorModel.name] forKey:@"author"];
        }
    }
    [HICAPI knowledgeAndCourseEnquiries:postModel success:^(NSDictionary * _Nonnull responseObject) {
        if (responseObject) {
            //            self.dataArr = responseObject[@"data"][@"courseKLDList"];
            self.dataArr = responseObject[@"data"][@"courseKLDList"];
            [self configTableView];
        }
    }];

}
//返回按钮
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -uitableviewdelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
    //    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HICContributeKnowledgeCell *cell = (HICContributeKnowledgeCell *)[tableView dequeueReusableCellWithIdentifier:contributeCell];
    cell.courseModel = [HICCourseModel mj_objectWithKeyValues:self.dataArr[indexPath.row][@"courseKLD"]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, HIC_ScreenWidth, 50)];
    UILabel *numLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 200, 50)];
    [headerView addSubview:numLabel];
    numLabel.font = FONT_MEDIUM_17;
    numLabel.textColor = TEXT_COLOR_DARK;
    NSString *tStr = [NSString stringWithFormat:@"%@(%lu)",NSLocalizableString(@"contributionKnowledge", nil),(unsigned long)self.dataArr.count];
    NSMutableAttributedString *astr = [[NSMutableAttributedString alloc]initWithString:tStr];
    [astr addAttributes:@{NSForegroundColorAttributeName : TEXT_COLOR_LIGHTS,NSFontAttributeName : [UIFont fontWithName:@"PingFangSC-Medium" size:14]} range:NSMakeRange(4, tStr.length - 4)];
    numLabel.attributedText = astr;
    headerView.backgroundColor = UIColor.whiteColor;
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HICCourseModel *model = [HICCourseModel mj_objectWithKeyValues:self.dataArr[indexPath.row][@"courseKLD"]];
    if (model.courseKLDType == 6) {
        HICLessonsVC *vc = [HICLessonsVC new];
        vc.objectID = model.courseKLDId;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        HICKnowledgeDetailVC *vc = HICKnowledgeDetailVC.new;
        vc.kType = model.resourceType;
        vc.objectId = model.courseKLDId;
        vc.partnerCode = model.partnerCode;
        [self.navigationController pushViewController:vc animated:YES];
    }

    //      if (model.resourceType == HICScromType || model.resourceType == HICHtmlType ) {
    //          vc.urlStr = self.baseInfoModel.mediaInfoList[0][@"url"];
    //          vc.hideNavi = YES;
    //          vc.hideTabbar = YES;
    //      }

}

@end
