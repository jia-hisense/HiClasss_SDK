//
//  HICLiveLessonListVC.m
//  HiClass
//
//  Created by jiafujia on 2021/11/19.
//  Copyright © 2021 hisense. All rights reserved.
//

#import "HICLiveLessonListVC.h"
#import "HICLiveCell.h"
#import "HomeTaskCenterDefaultView.h"
#import <YSLiveSDK/YSSDKManager.h>
#import "HICLiveReplayVC.h"

#define kLiveCellIden  @"HICLiveCellIden"

@interface HICLiveLessonListVC ()<UITableViewDelegate, UITableViewDataSource, HICLiveCellDelegate>

@property (nonatomic, strong)NSArray *dataSource;
@property (nonatomic, strong)UITableView *table;
@property (nonatomic, assign)HICLiveLessonListType type;
@property (nonatomic, strong)HomeTaskCenterDefaultView *defaultView;

@end

@implementation HICLiveLessonListVC

- (instancetype)initWithType:(HICLiveLessonListType)type {
    if (self = [super init]) {
        self.type = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getLessonList];
    [self addUI];
}
- (void)updateWithData:(NSArray *)dataSource {
    if (!dataSource || dataSource.count == 0) {
        self.defaultView.hidden = NO;
//        self.table.hidden = YES;
        return;
    }
    self.defaultView.hidden = YES;
//    self.table.hidden = NO;
    self.dataSource = dataSource;
    [self.table reloadData];
}

#pragma mark -- 私有方法
- (void)addUI {
//    if (!_table) {
        [self.view addSubview:self.table];
//    }
//    if (!_defaultView) {
        [self.table addSubview:self.defaultView];
//    }
    __weak __typeof(self) weakSelf = self;
    self.table.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getLessonList];
        weakSelf.getLiveNumBlock();
    }];
}

- (void)getLessonList {
    [HICAPI getLiveList:self.type success:^(NSDictionary * _Nonnull responseObject) {
        if (responseObject) {
            NSArray *dataArr = [HICLiveListModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"liveLessonList"]];
            [self updateWithData:dataArr];
        }
        [self.table.mj_header endRefreshing];
    } failure:^(NSError * _Nonnull error) {
        [self updateWithData:nil];
        [self.table.mj_header endRefreshing];
    }];
}

- (void)getRoomNumWithID:(NSNumber *)lessonId {
    self.table.userInteractionEnabled = NO;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [HICAPI getRoomNumWithID:lessonId success:^(NSDictionary * _Nonnull responseObject) {
            self.table.userInteractionEnabled = YES;
            if ([responseObject [@"data"] valueForKey:@"liveRoom"]) {
                HICLiveRoomModel *model = [HICLiveRoomModel mj_objectWithKeyValues:responseObject[@"data"][@"liveRoom"]];
                DDLogDebug(@"%ld", (long)[NSString isValidStr:model.roomNum]);
                if ([NSString isValidStr:model.roomNum] && [model.status integerValue] == 2) {
                    [self.delegate initLiveSDKWithRoomNumber:model.roomNum];
                } else {
                    [HICToast showWithText:NSLocalizableString(@"liveNotStartPrompt", nil)];
                }
            }
        } failure:^(NSError * _Nonnull error) {
            self.table.userInteractionEnabled = YES;
        }];
    });
}

- (void)makeAutoLayout {
    [self.table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.defaultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
#pragma mark -- HICLiveCellDelegate
- (void)playBackWithParams:(NSString *)params andMediaId:(nonnull NSNumber *)mediaId andMediaName:(nonnull NSString *)name {
    NSArray *arr = [HICCommonUtils covertJSONStrToArray:params];
    NSMutableArray *meArr = [NSMutableArray array];
    for (NSDictionary *dic in arr) {
        NSMutableDictionary *meDic = [NSMutableDictionary dictionary];
        [meDic setValue: [dic objectForKey:@"https_playpath_mp4"] forKey:@"assetStr"];
        [meDic setValue:name forKey:@"title"];
         NSMutableDictionary *resolutionURLs = [NSMutableDictionary dictionary];
        [resolutionURLs setObject:[dic objectForKey:@"https_playpath_mp4"] forKey:@"11"];
        [meDic setValue:resolutionURLs forKey:@"resolutionURLs"];
        [meArr addObject:meDic];
    }
    HICLiveReplayVC *reVC = [HICLiveReplayVC new];
    reVC.videoArr = meArr;
    reVC.mediaId = mediaId;
    UIViewController *vc = self.parentViewController ?: self;
    [vc.navigationController pushViewController:reVC animated:YES];
}

#pragma mark -- UITableViewDelegate & UITableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HICLiveListModel *model = self.dataSource[indexPath.row];
    HICLiveLessonModel *lessonModel = [HICLiveLessonModel mj_objectWithKeyValues:model.liveLesson];
    if (lessonModel.status == HICLiveWait) {
        [self getRoomNumWithID:lessonModel.lessonId];
    } else if (lessonModel.status == HICLiveInProgress) {
        [self.delegate initLiveSDKWithRoomNumber:lessonModel.roomNum];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HICLiveCell *cell = (HICLiveCell *)[tableView dequeueReusableCellWithIdentifier:kLiveCellIden forIndexPath:indexPath];
    cell.cellDelegate = self;
    HICLiveListModel *model = self.dataSource[indexPath.row];
    cell.isAll = self.type == HICLiveLessonListAll;
    cell.backModel = [HICLivePlayBackInfo mj_objectWithKeyValues:model.playBackInfo];
    [cell setBorderStyleWithTableView:tableView indexPath:indexPath];
    [cell loadData:model];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    DDLogDebug(@"HICLiveLessonListVC:%lu", (unsigned long)self.dataSource.count);
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 6;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, HIC_ScreenWidth, 6)];
    line.backgroundColor = BACKGROUNG_COLOR;
    return line;
}
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    view.backgroundColor = [UIColor clearColor];
}

#pragma mark -- 懒加载
- (UITableView *)table {
    if (!_table) {
        _table = [[UITableView alloc] initWithFrame:self.view.bounds];
        _table.delegate = self;
        _table.dataSource = self;
        _table.estimatedRowHeight = 110;
        _table.rowHeight = UITableViewAutomaticDimension;
        [_table registerClass:[HICLiveCell class] forCellReuseIdentifier:kLiveCellIden];
        _table.separatorStyle = UITableViewCellSeparatorStyleNone;
        _table.separatorColor = [UIColor clearColor];
        _table.backgroundColor = BACKGROUNG_COLOR;
        if (@available(iOS 15.0, *)) {
            _table.sectionHeaderTopPadding = 0;
        }
    }
    return _table;
}

- (HomeTaskCenterDefaultView *)defaultView {
    if (!_defaultView) {
        _defaultView = [[HomeTaskCenterDefaultView alloc] initWithFrame:self.view.bounds];
        _defaultView.titleStr = NSLocalizableString(@"noLiveNow", nil);
        _defaultView.imageName = @"暂无直播";
    }
    return _defaultView;
}

- (NSArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSArray array];
    }
    return _dataSource;
}

@end
