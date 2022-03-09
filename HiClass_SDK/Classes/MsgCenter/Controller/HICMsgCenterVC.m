//
//  HICMsgCenterVC.m
//  HiClass
//
//  Created by Eddie Ma on 2020/2/26.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICMsgCenterVC.h"
#import "HICMsgCenterCell.h"
#import "HICMsgCenterCellModel.h"
#import "HICMsgCenterDetailVC.h"

static NSString *msgCenterCellIdenfer = @"msgCenterCell";
static NSString *logName = @"[HIC][MCVC]";

@interface HICMsgCenterVC ()<HICCustomNaviViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) HICCustomNaviView *navi;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *subtitles;
@property (nonatomic, strong) NSMutableArray *items;

@end

@implementation HICMsgCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated {
    if (!self.navigationController.isNavigationBarHidden) {
        self.navigationController.navigationBarHidden = YES;
    }
    [self initData];
    [self requestData];
    [self createUI];
}

- (void)initData {
    self.items = [[NSMutableArray alloc] init];
    self.images = @[@"消息icon-任务", @"消息icon-内容更新", @"消息icon-待办",@"消息icon-评论"];//, @"消息icon-群消息", @"消息icon-评论"];
    self.titles = @[NSLocalizableString(@"task", nil), NSLocalizableString(@"contentUpdata", nil), NSLocalizableString(@"todo", nil),NSLocalizableString(@"comments", nil)];//, @"群消息", @"评论"];
    self.subtitles = @[NSLocalizableString(@"includeTaskNotifications", nil), NSLocalizableString(@"includeUpdataNotifications", nil), NSLocalizableString(@"needReadDueNotifications", nil),NSLocalizableString(@"includeCommentsNotifications", nil)];//, @"查阅培训项目中建立的群组信息", @"用户评论、知识评论、知识点赞信息等"];
    for (int i = 0; i < _images.count; i ++) {
        HICMsgCenterCellModel *cellModel = [[HICMsgCenterCellModel alloc] init];
        cellModel.msgCellImageName = _images[i];
        cellModel.msgCellTitle = _titles[i];
        cellModel.msgCellSubTitle = _subtitles[i];
        [_items addObject:cellModel];
    }
}

- (void)requestData {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:@(0) forKey:@"messageStatus"];
    [dic setValue:@(1) forKey:@"terminalType"];
    [HICAPI loadDataMessageNum:dic success:^(NSDictionary * _Nonnull responseObject) {
        NSDictionary *data = [responseObject valueForKey:@"data"];
        if (data) {
            NSArray *typeCountList = [data valueForKey:@"typeCountList"];
            if (![HICCommonUtils isValidObject:typeCountList]) {
                return ;
            }
            for (int i  = 0; i < typeCountList.count; i ++) {
                //  1-任务，2-待办，3-内容互动，4-群消息，5-评论
                NSNumber *type = (NSNumber *)[typeCountList[i] valueForKey:@"type"];
                NSNumber *unreadNum = (NSNumber *)[typeCountList[i] valueForKey:@"unreadNum"];
                NSDictionary *messageDic = [HICCommonUtils isValidObject:[typeCountList[i] valueForKey:@"message"]] ? [typeCountList[i] valueForKey:@"message"] : @{};
                NSNumber *time = (NSNumber *)[messageDic valueForKey:@"time"];
                NSString *subTitle = [messageDic valueForKey:@"title"];
                if (type) {
                    NSInteger itemIndex;
                    if ([type integerValue] == 1) {
                        itemIndex = 0;
                    } else if ([type integerValue] == 2) {
                        itemIndex = 2;
                    } else if ([type integerValue] == 3) {
                        itemIndex = 1;
                    } else if ([type integerValue] == 5) {
                        itemIndex = 3;
                    } else {
                        return;
                    }
                    HICMsgCenterCellModel *cellModel = self.items[itemIndex];
                    if (unreadNum) {
                        cellModel.msgCellHintNum =  unreadNum;
                    }
                    if (time)  {
                        cellModel.msgCellTime = time;
                    }
                    if ([NSString isValidStr:subTitle]) {
                        cellModel.msgCellSubTitle = subTitle;
                    }
                }
            }
            [_tableView reloadData];
        }
    } failure:^(NSError * _Nonnull error) {
        DDLogDebug(@"error");
    }];
}

- (void)createUI {
    [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self createNavi];
    [self createTableView];
//    [self createEmtyView];
//    [self createBtmEditView];
}

- (void)createNavi {
    self.navi = [[HICCustomNaviView alloc] initWithTitle:NSLocalizableString(@"messageCenter", nil) rightBtnName:nil showBtnLine:YES];
    _navi.delegate = self;
    [self.view addSubview:_navi];
}

- (void)createTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, HIC_NavBarAndStatusBarHeight + 0.5, HIC_ScreenWidth, HIC_ScreenHeight - HIC_NavBarAndStatusBarHeight - 0.5) style:UITableViewStylePlain];
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
    return _items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HICMsgCenterCell *msgCenterCell = (HICMsgCenterCell *)[tableView dequeueReusableCellWithIdentifier:msgCenterCellIdenfer];
    if (msgCenterCell == nil) {
        msgCenterCell = [[HICMsgCenterCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:msgCenterCellIdenfer];
        [msgCenterCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    } else {
    }
    HICMsgCenterCellModel *cellModel = _items[indexPath.row];
    [msgCenterCell setData:cellModel index:indexPath.row];
    return msgCenterCell;

}

#pragma mark tableview delegate协议方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return MSG_CENTER_CELL_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HICMsgCenterDetailVC *vc = [[HICMsgCenterDetailVC alloc] init];
    HICMsgType type;
    if (indexPath.row == 0) {
        type = HICMsgTypeTask;
    } else if (indexPath.row == 1) {
        type = HICMsgTypeInteract;
    } else if (indexPath.row == 2) {
        type = HICMsgTypeToDo;
    } else if (indexPath.row == 3) {
        type = HICMsgTypeComment;
    } else {
        type = HICMsgTypeGroupMsg;
    }
    vc.msgType = type;
    NSString *title = @"";
    if (indexPath.row == 0 || indexPath.row == 2) {
        title = [NSString stringWithFormat:@"%@%@", _titles[indexPath.row],NSLocalizableString(@"notification", nil)];
    } else {
        title = _titles[indexPath.row];
    }
    vc.naviTitle = title;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - - - HICCustomNaviViewDelegate  - - -
- (void)leftBtnClicked {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
