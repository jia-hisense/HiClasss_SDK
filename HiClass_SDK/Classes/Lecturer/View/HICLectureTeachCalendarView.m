//
//  HICLectureTeachCalendarView.m
//  HiClass
//
//  Created by WorkOffice on 2020/4/1.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICLectureTeachCalendarView.h"
#import "HICLectureCalendarTrainCell.h"
#import "HICLectureCalendarCourseCell.h"
#import "UIView+Gradient.h"

@interface HICLectureTeachCalendarView()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, assign) NSInteger lastPageNum;
@property (nonatomic, assign) NSInteger pageNum; // 页码：从1开始
@property (nonatomic, assign) NSInteger offset; // 每页记录数，默认10条
@property (nonatomic, strong) NSString *sort; //desc-降序 asc-升序

@property (nonatomic, strong) UIView *defaultView;

@property (nonatomic, strong) HICLectureTrainModel *trainModel;

@property (nonatomic, strong) NSMutableArray<NSMutableArray *> *dataSections;

@end


@implementation HICLectureTeachCalendarView
-(instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame style:UITableViewStyleGrouped]) {
        [self createUI];
        self.isDataOnceSuccess = NO;
        self.offset = 15;
        self.sort = @"desc";
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
    if (@available(iOS 15.0, *)) {
        self.sectionHeaderTopPadding = 0;
    }
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
    NSMutableDictionary *requestDic = [NSMutableDictionary new];
    [requestDic setObject:[NSNumber numberWithInteger:_lecturerId] forKey:@"lecturerId"];
    [requestDic setObject:USER_CID forKey:@"customerId"];
    [requestDic setObject:[NSNumber numberWithInteger:self.pageNum] forKey:@"pageNum"];
    [requestDic setObject:[NSNumber numberWithInteger:self.offset] forKey:@"offset"];
    [requestDic setObject:self.sort forKey:@"sort"];
    [weakSelf.defaultView setHidden:YES];
    [HICAPI lecturerScheduleLectures:requestDic success:^(NSDictionary * _Nonnull responseObject) {
        [weakSelf.mj_footer resetNoMoreData];
        weakSelf.isDataOnceSuccess = YES;
        [weakSelf.mj_header endRefreshing];
        weakSelf.trainModel = nil;
        if (responseObject[@"data"]) {
            NSDictionary *dicData = [responseObject objectForKey:@"data"];
            if (dicData) {
                weakSelf.trainModel = [HICLectureTrainModel mj_objectWithKeyValues:dicData];
            }
        }
        if (!weakSelf.trainModel || weakSelf.trainModel.list.count <= 0) {
            weakSelf.pageNum = 0;
        }
        if (weakSelf.trainModel.list.count < weakSelf.offset) {
            [weakSelf.mj_footer endRefreshingWithNoMoreData];
        } else {
            [weakSelf.mj_footer resetNoMoreData];
        }
        [weakSelf updateData];
        [weakSelf reloadData];
        if (!weakSelf.trainModel.list || weakSelf.trainModel.list.count <= 0) {
            [weakSelf.defaultView setHidden:NO];
            [weakSelf bringSubviewToFront:weakSelf.defaultView];
        }
    } failure:^(NSError * _Nonnull error) {
        weakSelf.pageNum = weakSelf.lastPageNum;
        [weakSelf.mj_header endRefreshing];
        if (!weakSelf.trainModel.list || weakSelf.trainModel.list.count <= 0) {
            [weakSelf.defaultView setHidden:YES];
            // 重新请求数据
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
    [requestDic setObject:self.sort forKey:@"sort"];
    [HICAPI lecturerScheduleLectures:requestDic success:^(NSDictionary * _Nonnull responseObject) {
        weakSelf.isDataOnceSuccess = YES;
        BOOL isEndMj = NO;
        [weakSelf.defaultView setHidden:YES];
        NSMutableArray *listNew;
        if (responseObject[@"data"]) {
            NSDictionary *dicData = [responseObject objectForKey:@"data"];
            if (dicData) {
                HICLectureTrainModel *trainModel = [HICLectureTrainModel mj_objectWithKeyValues:dicData];
                listNew = trainModel.list;
                if (!weakSelf.trainModel) {
                    // 第一页数据
                    weakSelf.trainModel = trainModel;
                } else {
                    NSMutableArray *list = weakSelf.trainModel.list;
                    if (!list) {
                        list = [NSMutableArray new];
                        weakSelf.trainModel.list = list;
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
        [weakSelf updateData];
        [weakSelf reloadData];
        if (!weakSelf.trainModel.list || weakSelf.trainModel.list.count <= 0) {
            [weakSelf.defaultView setHidden:NO];
            [weakSelf bringSubviewToFront:weakSelf.defaultView];
        }
    } failure:^(NSError * _Nonnull error) {
        weakSelf.pageNum--;
        [weakSelf.mj_footer endRefreshing];
        if (!weakSelf.trainModel.list || weakSelf.trainModel.list.count <= 0) {
            [weakSelf.defaultView setHidden:YES];
            // 重新请求数据
            if (weakSelf.netErrorBlock) {
                weakSelf.netErrorBlock();
            }
        }
    }];
}

- (void)updateData {
    if (!self.trainModel.list || self.trainModel.list.count <= 0) {
        [self.dataSections removeAllObjects];
    } else {
        if (!self.dataSections) {
            self.dataSections = [NSMutableArray new];
        }
        [self.dataSections removeAllObjects];

        NSInteger count = self.trainModel.list.count;
        for (int i = 0; i < count; i++) {
            id data = self.trainModel.list[i];
            if ([data isKindOfClass:HICLectureTrainSubModel.class]) {
                id lastFrameData;

                NSMutableArray *sectionDatas = [NSMutableArray new];

                HICLectureTrainSubModel *train = (HICLectureTrainSubModel *)data;
                HICLectureCalendarTrainFrame *frame = [[HICLectureCalendarTrainFrame alloc] initWithTrain:train isSeparatorHidden:NO];
                lastFrameData = frame;
                [sectionDatas addObject:frame];

                NSInteger countCourse = train.classes.count;
                for (int i = 0; i < countCourse; i++) {
                    id data = train.classes[i];
                    if ([data isKindOfClass:HICLectureTrainSubCourseModel.class]) {
                        HICLectureTrainSubCourseModel *course = (HICLectureTrainSubCourseModel *)data;
                        HICLectureCalendarCourseFrame *frame = [[HICLectureCalendarCourseFrame alloc] initWithCourse:course isSeparatorHidden:NO];
                        [sectionDatas addObject:frame];
                        lastFrameData = frame;
                    }
                }

                if (sectionDatas.count > 0) {
                    [self.dataSections addObject:sectionDatas];
                }

                if ([lastFrameData isKindOfClass:HICLectureCalendarTrainFrame.class]) {
                    HICLectureCalendarTrainFrame *frame = (HICLectureCalendarTrainFrame *)lastFrameData;
                    frame.isSeparatorHidden = YES;
                }
                if ([lastFrameData isKindOfClass:HICLectureCalendarCourseFrame.class]) {
                    HICLectureCalendarCourseFrame *frame = (HICLectureCalendarCourseFrame *)lastFrameData;
                    frame.isSeparatorHidden = YES;
                }

            }
        }
    }
}

#pragma UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell;

    if (indexPath.section < self.dataSections.count) {
        NSArray *sectionDatas = self.dataSections[indexPath.section];
        NSInteger index = indexPath.row;
        if (index < sectionDatas.count) {

            BOOL isLastSectionCell = NO;
            if (index == sectionDatas.count-1) {
                isLastSectionCell = YES;
            }

            id frameData = (HICLectureCalendarTrainFrame *)sectionDatas[index];
            if ([frameData isKindOfClass:HICLectureCalendarTrainFrame.class]) {
                HICLectureCalendarTrainFrame *frame = (HICLectureCalendarTrainFrame *)frameData;
                HICLectureCalendarTrainCell *trainCell = [HICLectureCalendarTrainCell cellWithTableView:tableView];
                trainCell.trainFrame = frame;
                cell = trainCell;

                if (isLastSectionCell) {
                    [trainCell.bgView removeCorner];
                    [trainCell.bgView addCornerWithRadius:4 cornerType:CornerBottom];
                }
            }
            if ([frameData isKindOfClass:HICLectureCalendarCourseFrame.class]) {
                HICLectureCalendarCourseFrame *frame = (HICLectureCalendarCourseFrame *)frameData;
                HICLectureCalendarCourseCell *courseCell = [HICLectureCalendarCourseCell cellWithTableView:tableView];
                courseCell.courseFrame = frame;
                cell = courseCell;

                if (isLastSectionCell) {
                    [courseCell.bgView removeCorner];
                    [courseCell.bgView addCornerWithRadius:4 cornerType:CornerBottom];
                }
            }

        }
    }
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section < self.dataSections.count) {
        NSArray *sectionDatas = self.dataSections[indexPath.section];
        NSInteger index = indexPath.row;
        if (index < sectionDatas.count) {
            id frameData = (HICLectureCalendarTrainFrame *)sectionDatas[index];
            if ([frameData isKindOfClass:HICLectureCalendarTrainFrame.class]) {
                HICLectureCalendarTrainFrame *frame = (HICLectureCalendarTrainFrame *)frameData;
                return frame.cellHeight;
            }
            if ([frameData isKindOfClass:HICLectureCalendarCourseFrame.class]) {
                HICLectureCalendarCourseFrame *frame = (HICLectureCalendarCourseFrame *)frameData;
                return frame.cellHeight;
            }

        }
    }

    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section < self.dataSections.count) {
        NSArray *sectionDatas = self.dataSections[section];
        return sectionDatas.count;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSections.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 8)];
    view.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    return view ;

}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 12;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}





@end
