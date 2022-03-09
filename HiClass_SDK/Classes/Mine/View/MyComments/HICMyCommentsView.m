//
//  HICMyCommentsView.m
//  HiClass
//
//  Created by Eddie Ma on 2020/2/20.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICMyCommentsView.h"
#import "HICMyCommentCell.h"
#import "HICMyCommentsModel.h"
#import "HICNetModel.h"
#import "HICKnowledgeDetailVC.h"
#import "HICLessonsVC.h"
#define tagNum  40000
#define sectionTag 30000
static NSString *myCommentsCellIdenfer = @"myCommentsCell";
static NSString *logName = @"[HIC][MCV]";

@interface HICMyCommentsView()<UITableViewDataSource, UITableViewDelegate,HICMyCommentsDelegate>
@property (nonatomic, strong) NSMutableArray *myCommentsArr;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) HICNetModel *netModel;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, strong) UIImageView *blackView;
@property (nonatomic ,strong)UILabel *blackLabel;
@property (nonatomic ,assign) NSInteger btnIndex;
@end

@implementation HICMyCommentsView
-(UIImageView *)blackView{
    if (!_blackView) {
        _blackView = [[UIImageView alloc]initWithFrame:CGRectMake(HIC_ScreenWidth / 2 - 60, 101.5, 120, 120)];
        _blackView.image = [UIImage imageNamed:@"暂无评论"];
    }
    return _blackView;
}
- (UILabel *)blackLabel{
    if (!_blackLabel) {
        _blackLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 221.5 + 8, HIC_ScreenWidth, 20)];
        _blackLabel.text = NSLocalizableString(@"noPostedComment", nil);
        _blackLabel.textColor = TEXT_COLOR_LIGHTS;
        _blackLabel.font = FONT_REGULAR_15;
        _blackLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _blackLabel;
}
- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, HIC_ScreenWidth, 80)];
        _headerView.backgroundColor = UIColor.whiteColor;
        _headerView.userInteractionEnabled = YES;
    }
    return _headerView;
}

- (NSMutableArray *)myCommentsArr{
    if (!_myCommentsArr) {
        _myCommentsArr = [[NSMutableArray alloc]init];
    }
    return _myCommentsArr;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initData];
        [self creatUI];
        // 增加刷新机制
        __weak typeof(self) weakSelf = self;
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf.myCommentsArr removeAllObjects];
            [weakSelf.tableView reloadData];
            weakSelf.pageIndex = 0;
            [weakSelf initData];
        }];
        
        MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            // 加载更多数据
            weakSelf.pageIndex++;
            [weakSelf initData];
        }];
        self.tableView.mj_footer = footer;
    }
    return self;
}
- (void)initData {
    [HICAPI myComment:self.pageIndex success:^(NSDictionary * _Nonnull responseObject) {
        [self.tableView.mj_header endRefreshing];
        if ([responseObject objectForKey:@"data"]) {
            if (responseObject[@"data"][@"commentsList"]) {
                NSMutableArray *tempArr = responseObject[@"data"][@"commentsList"];
                [self.myCommentsArr addObjectsFromArray:tempArr];
                [self.tableView reloadData];
                [self.tableView.mj_footer endRefreshing];
                if ([self.subviews containsObject:self.blackView]) {
                    [self.blackView removeFromSuperview];
                    [self.blackLabel removeFromSuperview];
                }
            }else{
                if (self.myCommentsArr.count == 0) {
                    [self addSubview:self.blackView];
                    [self addSubview:self.blackLabel];
                }
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                if (self.pageIndex>0) {
                    self.pageIndex--;
                }
            }
        }else{
            if (![self.subviews containsObject:self.blackView]) {
                [self addSubview:self.blackView];
                [self addSubview:self.blackLabel];
            }
            [self.tableView.mj_footer endRefreshing];
            if (self.pageIndex>0) {
                self.pageIndex--;
            }
        }
    } failure:^(NSError * _Nonnull error) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        [self.tableView.mj_header endRefreshing];
    }];
}
- (void)creatUI {
    [self initTableView];
}

- (void)initTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) style:UITableViewStylePlain];
    [self addSubview:_tableView];
    _tableView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1/1.0];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (@available(iOS 15.0, *)) {
        _tableView.sectionHeaderTopPadding = 0;
    }
}
- (CGFloat)getContentHeight:(NSString *)str {
    UILabel *label = [[UILabel alloc] init];
    label.text = str;
    label.font = FONT_REGULAR_15;
    label.numberOfLines = 0;
    CGFloat labelHeight = [HICCommonUtils sizeOfString:str stringWidthBounding:HIC_ScreenWidth - 32 font:15 stringOnBtn:NO fontIsRegular:YES].height;
    label.frame = CGRectMake(0, 0, HIC_ScreenWidth - 32, labelHeight);
    [label sizeToFit];
    return label.frame.size.height;
}

- (void)btnClick:(UITapGestureRecognizer *)tap{
    NSInteger index;
    index = tap.view.tag - sectionTag;
    HICMyCommentsObjectModel *model = [HICMyCommentsObjectModel mj_objectWithKeyValues:self.myCommentsArr[index][@"objectInfo"]];
    if (![NSString isValidStr:[NSString stringWithFormat:@"%@",model.commentObjectId]]) {
        return;
    }
    if (model.type == 6) {
        HICLessonsVC *vc = [HICLessonsVC new];
        vc.objectID = model.commentObjectId;
        HICStudyLogReportModel *reportModel = [[HICStudyLogReportModel alloc]initWithType:HICMyCommentToKnowledge];
        ///日志上报
        reportModel.mediaid = model.commentObjectId;
        reportModel.knowtype = @-1;
        reportModel.mediatype = [NSNumber numberWithInteger:HICReportCourseType];
        NSMutableDictionary *report = [NSMutableDictionary dictionaryWithDictionary:[reportModel getParamDict]];
        [report setValuesForKeysWithDictionary:[LogManager getSerLogEventDictWithType:HICMyCommentToKnowledge]];
        [LogManager reportSerLogWithDict:report];
        [[HICCommonUtils viewController:self].navigationController pushViewController:vc animated:YES];
    }else{
        HICKnowledgeDetailVC *vc = [HICKnowledgeDetailVC new];
        vc.objectId = model.commentObjectId;
        vc.kType = model.resourceType;
        vc.partnerCode = model.partnerCode;
        ///日志上报
        HICStudyLogReportModel *reportModel = [[HICStudyLogReportModel alloc]initWithType:HICMyCommentToKnowledge];
        reportModel.mediaid = model.commentObjectId;
        reportModel.knowtype = [NSNumber numberWithInteger:model.resourceType];
        reportModel.mediatype = [NSNumber numberWithInteger:HICReportKnowledgeType];
        NSMutableDictionary *report = [NSMutableDictionary dictionaryWithDictionary:[reportModel getParamDict]];
        [report setValuesForKeysWithDictionary:[LogManager getSerLogEventDictWithType:HICMyCommentToKnowledge]];
        [LogManager reportSerLogWithDict:report];
        [[HICCommonUtils viewController:self].navigationController pushViewController:vc animated:YES];
    }
    
}

#pragma mark --- mycommentsDelegate
- (void)deleteClick:(NSNumber *)commentsId andType:(nonnull NSString *)type andIndexPath:(nonnull NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    NSInteger index = indexPath.row;
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:@3 forKey:@"optype"];
    [dic setValue:commentsId.stringValue forKey:@"commentid"];
    [dic setValue:type forKey:@"typeCode"];
    [dic setValue:@"9999" forKey:@"productCode"];
    [HICAPI LikeReplyDeleteCommentReply:dic success:^(NSDictionary * _Nonnull responseObject) {
        DDLogDebug(@"%@ Comment Deleted!", logName);
        [HICToast showWithText:NSLocalizableString(@"deleteCommentSucceeded", nil)];
        NSMutableArray *temp = _myCommentsArr;
        if (temp.count >section) {
            NSMutableArray *sectionDatas = [temp[section][@"comments"] mutableCopy];
            if (sectionDatas.count > index) {
                [sectionDatas removeObjectAtIndex:index];
            }
            if (sectionDatas.count == 0) {
                [temp removeObjectAtIndex:section];
            }else{
                NSDictionary *dic = temp[section];
                NSMutableDictionary *mDic = [NSMutableDictionary dictionaryWithDictionary:dic];
                [mDic setObject:sectionDatas forKey:@"comments"];
                [temp replaceObjectAtIndex:section withObject:[mDic copy]];
            }
        }
        _myCommentsArr = temp;
        [self.tableView reloadData];
        if (_myCommentsArr.count == 0) {
            [self addSubview:self.blackView];
            [self addSubview:self.blackLabel];
        }
    } failure:^(NSError * _Nonnull error) {
        DDLogDebug(@"%@ Comment Deleted failed!, error: %@", logName, error);
        [HICToast showWithText:NSLocalizableString(@"deleteCommentFaildPrompt", nil)];
    }];
}
#pragma mark tableview dataSorce协议
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _myCommentsArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.myCommentsArr.count > section){
        NSArray *sectionDatas = _myCommentsArr[section][@"comments"];// 转成数据模型数组，其他地方使用时直接使用模型
        return sectionDatas.count;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger index = indexPath.row;
    HICMyCommentCell *myCommentCell = (HICMyCommentCell *)[tableView dequeueReusableCellWithIdentifier:myCommentsCellIdenfer];
    if (myCommentCell == nil) {
        myCommentCell = [[HICMyCommentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCommentsCellIdenfer];
        [myCommentCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    if (self.myCommentsArr.count > section) {
        NSArray *comments = self.myCommentsArr[section][@"comments"];
        myCommentCell.model = [HICMyCommentsModel mj_objectWithKeyValues:comments[index]];
    }
    myCommentCell.commentDelegate = self;
    myCommentCell.indexPath = indexPath;
    return myCommentCell;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, HIC_ScreenWidth, 80)];
    header.backgroundColor = UIColor.whiteColor;
    self.btnIndex = section;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(btnClick:)];
    header.tag = section + sectionTag;
    [header addGestureRecognizer:tap];
    header.userInteractionEnabled = YES;
    UIImageView *leftView = [[UIImageView alloc]initWithFrame:CGRectMake(16, 16, 84, 47)];
    leftView.layer.cornerRadius = 4;
    leftView.clipsToBounds = YES;
    leftView.backgroundColor = BACKGROUNG_COLOR;
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.numberOfLines = 2;
    titleLabel.font = FONT_MEDIUM_17;
    titleLabel.textColor = [UIColor colorWithHexString:@"#181818"];
    titleLabel.X = 112;
    titleLabel.width = HIC_ScreenWidth - 112 - 42;
    titleLabel.height = 50;
    titleLabel.centerY = leftView.centerY;
    if (self.myCommentsArr.count >= section) {
        HICMyCommentsObjectModel *model = [HICMyCommentsObjectModel mj_objectWithKeyValues:self.myCommentsArr[section][@"objectInfo"]];
        [leftView sd_setImageWithURL:[NSURL URLWithString:model.coverPic]];
        titleLabel.text = model.name;
        UIButton *detailBtn = [[UIButton alloc]initWithFrame:CGRectMake(HIC_ScreenWidth - 24, 36, 5, 9)];
        detailBtn.tag = section + tagNum;
        [detailBtn setImage:[UIImage imageNamed:@"成绩详情-箭头"] forState:UIControlStateNormal];
        [header addSubview:leftView];
        [header addSubview:titleLabel];
        [header addSubview:detailBtn];
    }
    
    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, HIC_ScreenWidth, 8)];
    footer.backgroundColor = BACKGROUNG_COLOR;
    return footer;
}
#pragma mark tableview delegate协议方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger index = indexPath.row;
    if (self.myCommentsArr.count > section) {
        NSArray *comments = self.myCommentsArr[section][@"comments"];
        if (comments.count == 0) {
            return 0;
        }
        HICMyCommentsModel *model = [HICMyCommentsModel mj_objectWithKeyValues:comments[index]];
        return 48 + 16 + [self getContentHeight:model.content];
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 80;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 8;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
@end
