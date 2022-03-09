//
//  HICLectureCourseView.m
//  HiClass
//
//  Created by WorkOffice on 2020/4/1.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICLectureCourseView.h"
#import "HICLectureCourseModel.h"
#import "HICLectureCourseCell.h"
#import "HICOfflineCourseDetailVC.h"


@interface HICLectureCourseView()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, assign) NSInteger lastPageNum;
@property (nonatomic, assign) NSInteger pageNum; // 页码：从1开始
@property (nonatomic, assign) NSInteger offset; // 每页记录数，默认10条

@property (nonatomic, strong) UIView *defaultView;

@property (nonatomic, strong) HICLectureCourseModel *courseModel;
@end

@implementation HICLectureCourseView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createUI];
        self.isDataOnceSuccess = NO;
        self.offset = 15;
    }
    return self;
}
- (void)createUI{
    self.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.separatorColor = [UIColor clearColor];

    self.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    self.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    self.sectionHeaderHeight = CGFLOAT_MIN;
    self.sectionFooterHeight = CGFLOAT_MIN;

    self.delegate = self;
    self.dataSource = self;
    if (@available(iOS 15.0, *)) {
        self.sectionHeaderTopPadding = 0;
    }

    // 增加刷新机制
    __weak typeof(self) weakSelf = self;
    self.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf topRefresh];
    }];

    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        // 加载更多数据
        [weakSelf bottomRefresh];
    }];
    self.mj_footer = footer;
}


- (UIView *)defaultView {
    if (!_defaultView) {

        UIView *bgView = [[UIView alloc] initWithFrame:self.bounds];
        bgView.backgroundColor = [UIColor whiteColor];

        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, HIC_ScreenWidth, 148)];
        UIImageView *blackView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 120, 120)];
        blackView.image = [UIImage imageNamed:@"暂无数据"];
        [contentView addSubview:blackView];

        UILabel *blackLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(blackView.frame) + 8, HIC_ScreenWidth, 20)];
        blackLabel.text = NSLocalizableString(@"temporarilyNoData", nil);
        blackLabel.textColor = TEXT_COLOR_LIGHTS;
        blackLabel.font = FONT_REGULAR_15;
        blackLabel.textAlignment = NSTextAlignmentCenter;
        [contentView addSubview:blackLabel];

        blackView.center = CGPointMake(contentView.width/2.0, blackView.center.y);
        blackLabel.center = CGPointMake(contentView.width/2.0, blackLabel.center.y);

        contentView.center = CGPointMake(self.width/2.0, self.height/2.0);

        [bgView addSubview:contentView];

        _defaultView = bgView;

        [self addSubview:_defaultView];
    }

    return _defaultView;
}


- (void)topRefresh {
    self.lastPageNum = self.pageNum;
    self.pageNum = 1;
    
    __weak typeof(self) weakSelf = self;
    [weakSelf.defaultView setHidden:YES];
    NSMutableDictionary *requestDic = [NSMutableDictionary new];
    [requestDic setObject:[NSNumber numberWithInteger:_lecturerId] forKey:@"lecturerId"];
    [requestDic setObject:USER_CID forKey:@"customerId"];
    [requestDic setObject:[NSNumber numberWithInteger:self.pageNum] forKey:@"pageNum"];
    [requestDic setObject:[NSNumber numberWithInteger:self.offset] forKey:@"offset"];
    [HICAPI lecturerOfflineCourses:requestDic success:^(NSDictionary * _Nonnull responseObject) {
        weakSelf.isDataOnceSuccess = YES;
        [weakSelf.mj_header endRefreshing];
        weakSelf.courseModel = nil;
        if (responseObject[@"data"]) {
            
            NSDictionary *dicData = [responseObject objectForKey:@"data"];
            if (dicData) {
                weakSelf.courseModel = [HICLectureCourseModel mj_objectWithKeyValues:dicData];
            }
        }
        if (!weakSelf.courseModel || weakSelf.courseModel.list.count <= 0) {
            weakSelf.pageNum = 0;
        }
        if (weakSelf.courseModel.list.count < weakSelf.offset) {
            [weakSelf.mj_footer endRefreshingWithNoMoreData];
        } else {
            [weakSelf.mj_footer resetNoMoreData];
        }
        [weakSelf reloadData];
        if (weakSelf.refreshDoneBlock) {
            weakSelf.refreshDoneBlock(YES, weakSelf.courseModel.total);
        }
        if (!weakSelf.courseModel.list || weakSelf.courseModel.list.count <= 0) {
            [weakSelf.defaultView setHidden:NO];
            [weakSelf bringSubviewToFront:weakSelf.defaultView];
        }
    } failure:^(NSError * _Nonnull error) {
        weakSelf.pageNum = weakSelf.lastPageNum;
        [weakSelf.mj_header endRefreshing];
        
        if (!weakSelf.courseModel.list || weakSelf.courseModel.list.count <= 0) {
            [weakSelf.defaultView setHidden:YES];
            
            if (weakSelf.netErrorBlock) {
                weakSelf.netErrorBlock();
            }
        }
    }];
}

- (void)bottomRefresh {
    self.pageNum++;
    
    __weak typeof(self) weakSelf = self;
    
    NSMutableDictionary *requestDic = [NSMutableDictionary new];
    [requestDic setObject:[NSNumber numberWithInteger:_lecturerId] forKey:@"lecturerId"];
    [requestDic setObject:USER_CID forKey:@"customerId"];
    [requestDic setObject:[NSNumber numberWithInteger:self.pageNum] forKey:@"pageNum"];
    [requestDic setObject:[NSNumber numberWithInteger:self.offset] forKey:@"offset"];
    [HICAPI lecturerOfflineCourses:requestDic success:^(NSDictionary * _Nonnull responseObject) {
        weakSelf.isDataOnceSuccess = YES;
        BOOL isEndMj = NO;
        [weakSelf.defaultView setHidden:YES];
        NSMutableArray *listNew;
        if (responseObject[@"data"]) {
            NSDictionary *dicData = [responseObject objectForKey:@"data"];
            if (dicData) {
                HICLectureCourseModel *courseModel = [HICLectureCourseModel mj_objectWithKeyValues:dicData];
                listNew =courseModel.list;
                
                if (!weakSelf.courseModel) {
                    // 第一页数据
                    weakSelf.courseModel = courseModel;
                } else {
                    NSMutableArray *list = weakSelf.courseModel.list;
                    if (!list) {
                        list = [NSMutableArray new];
                        weakSelf.courseModel.list = list;
                    }
                    if (listNew.count > 0) {
                        [list addObjectsFromArray:listNew];
                    }
                }
            }
        }
        if (!listNew || listNew.count <= 0) {
            // 本页无数据
            weakSelf.pageNum--;
        }
        if (listNew.count < weakSelf.offset) {
            isEndMj = YES;
            [weakSelf.mj_footer endRefreshingWithNoMoreData];
        }
        if (!isEndMj) {
            [weakSelf.mj_footer endRefreshing];
        }
        [weakSelf reloadData];
        if (weakSelf.refreshDoneBlock) {
            weakSelf.refreshDoneBlock(YES, weakSelf.courseModel.total);
        }
        if (!weakSelf.courseModel.list || weakSelf.courseModel.list.count <= 0) {
            [weakSelf.defaultView setHidden:NO];
            [weakSelf bringSubviewToFront:weakSelf.defaultView];
        }
    } failure:^(NSError * _Nonnull error) {
        weakSelf.pageNum--;
        
        [weakSelf.mj_footer endRefreshing];
        
        //        [HICToast showWithText:@"请求失败，请重试！"];
        if (!weakSelf.courseModel.list || weakSelf.courseModel.list.count <= 0) {
            [weakSelf.defaultView setHidden:YES];
            
            if (weakSelf.netErrorBlock) {
                weakSelf.netErrorBlock();
            }
        }
    }];
}

#pragma UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    NSArray *list = self.courseModel.list;
    NSInteger index = indexPath.row;

    if (list && list.count > index) {
        id data = list[index];
        if ([data isKindOfClass:HICLectureCourseSubModel.class]) {
            HICLectureCourseSubModel *course = (HICLectureCourseSubModel *)data;
            BOOL isSeparatorHidden = NO;
            if (index == list.count-1) {
                isSeparatorHidden = YES;
            }
            HICLectureCourseFrame *courseFrame = [[HICLectureCourseFrame alloc] initWithCourse:course isSeparatorHidden:isSeparatorHidden];


            HICLectureCourseCell *courseCell = [HICLectureCourseCell cellWithTableView:self];
            courseCell.courseFrame = courseFrame;

            cell = courseCell;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *list = self.courseModel.list;
    NSInteger index = indexPath.row;

    if (list && list.count > index) {
        id data = list[index];
        if ([data isKindOfClass:HICLectureCourseSubModel.class]) {
            HICLectureCourseSubModel *course = (HICLectureCourseSubModel *)data;
            if (self.gotoCourseDetailBlock) {
                // 跳转到课程详情页
                self.gotoCourseDetailBlock(course.resClassId);
            }
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *list = self.courseModel.list;
    NSInteger index = indexPath.row;

    if (list && list.count > index) {
        id data = list[index];
        if ([data isKindOfClass:HICLectureCourseSubModel.class]) {
            HICLectureCourseSubModel *course = (HICLectureCourseSubModel *)data;

            BOOL isSeparatorHidden = NO;
            if (index == list.count-1) {
                isSeparatorHidden = YES;
            }

            HICLectureCourseFrame *courseFrame = [[HICLectureCourseFrame alloc] initWithCourse:course isSeparatorHidden:isSeparatorHidden];

            return courseFrame.cellHeight;

        }
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!self.courseModel.list) {
        return 0;
    }
    return self.courseModel.list.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


@end
