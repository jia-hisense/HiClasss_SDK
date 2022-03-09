//
//  HICMsgCenterDetailVC.m
//  HiClass
//
//  Created by Eddie Ma on 2020/2/26.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICMsgCenterDetailVC.h"
#import "HICMsgDetailCardView.h"
#import "HICMsgModel.h"
#import "HICGroupMsgModel.h"
#import "HICMsgDetailGroupMsgView.h"

static NSString *logName = @"[HIC][MCDVC]";

@interface HICMsgCenterDetailVC () <HICCustomNaviViewDelegate, HICMsgDetailGroupMsgViewDelegate, HICMsgDetailCardViewDelegate>

@property (nonatomic, strong) HICCustomNaviView *navi;
@property (nonatomic, strong) NSMutableArray *result;
@property (nonatomic, strong) HICMsgDetailCardView *cardView;
@property (nonatomic, strong) HICMsgDetailGroupMsgView *groupMsgView;

@end

@implementation HICMsgCenterDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated {
    if (!self.navigationController.isNavigationBarHidden) {
        self.navigationController.navigationBarHidden = YES;
    }
    [self initData];
    [self createUI];
    [self requestData];

}

// 数据初始化
- (void)initData {
    self.result = [[NSMutableArray alloc] init];
}

// 请求数据
- (void)requestData {
    [HICAPI queryingMessageList:self.msgType success:^(NSDictionary * _Nonnull responseObject) {
        NSDictionary *data = [responseObject valueForKey:@"data"];
        NSArray *messageList = [data valueForKey:@"messageList"];
        NSArray *messageGroupList = [data valueForKey:@"messageGroupList"];
        if (data) {
            NSMutableArray *unreadMsgArr = [[NSMutableArray alloc] init];
            // 处理请求来的数据  1-任务，2-待办，3-内容互动，4-群消息，5-评论
            if (self.msgType  == HICMsgTypeTask || self.msgType == HICMsgTypeToDo || self.msgType  == HICMsgTypeInteract || self.msgType == HICMsgTypeComment) {
                NSMutableArray *temMessageList = [[NSMutableArray alloc] init];
                for (int i = 0; i < messageList.count; i++) {
                    HICMsgModel *model = [[HICMsgModel alloc] init];
                    model.msgId = (NSNumber *)[messageList[i] valueForKey:@"id"];
                    model.msgType = (NSNumber *)[messageList[i] valueForKey:@"type"];
                    model.msgTitle = [messageList[i] valueForKey:@"title"];
                    model.msgContent = [messageList[i] valueForKey:@"content"];
                    model.msgStatus = (NSNumber *)[messageList[i] valueForKey:@"status"];
                    model.msgTime = (NSNumber *)[messageList[i] valueForKey:@"time"];
                    model.msgUrl = [messageList[i] valueForKey:@"jumpUrl"];
                    [temMessageList addObject:model];
                    if ([model.msgStatus integerValue] == 0) {
                        [unreadMsgArr addObject:model.msgId];
                    }
                }
                self.cardView.hidden = NO;
                self.groupMsgView.hidden = YES;
                self.cardView.data = temMessageList;
                [self changeUnreadMsgStatusWithArr:unreadMsgArr];
            } else if (self.msgType == HICMsgTypeGroupMsg) {
                NSMutableArray *temMessageGroupList = [[NSMutableArray alloc] init];
                for (int i = 0; i < messageGroupList.count; i++) {
                    HICGroupMsgModel *model = [[HICGroupMsgModel alloc] init];
                    model.groupId = (NSNumber *)[messageGroupList[i] valueForKey:@"groupId"];
                    model.groupName = [messageGroupList[i] valueForKey:@"groupName"];
                    model.count = (NSNumber *)[messageGroupList[i] valueForKey:@"count"];
                    model.unreadNum = (NSNumber *)[messageGroupList[i] valueForKey:@"unreadNum"];
                    NSArray *msgList = (NSArray *)[messageGroupList[i] valueForKey:@"messageList"];
                    NSMutableArray *temMsgList = [[NSMutableArray alloc] init];
                    for (int j = 0; j < msgList.count; j ++) {
                        HICMsgModel *msgModel = [[HICMsgModel alloc] init];
                        msgModel.msgId = (NSNumber *)[msgList[j] valueForKey:@"id"];
                        msgModel.msgType = (NSNumber *)[msgList[j] valueForKey:@"type"];
                        msgModel.msgTitle = [msgList[j] valueForKey:@"title"];
                        msgModel.msgContent = [msgList[j] valueForKey:@"content"];
                        msgModel.msgStatus = (NSNumber *)[msgList[j] valueForKey:@"status"];
                        msgModel.msgTime = (NSNumber *)[msgList[j] valueForKey:@"time"];
                        msgModel.msgUrl = [msgList[i] valueForKey:@"jumpUrl"];
                        [temMsgList addObject:msgModel];
                    }
                    model.messageList = temMsgList;
                    [temMessageGroupList addObject:model];
                }
                self.cardView.hidden = YES;
                self.groupMsgView.hidden = NO;
                self.groupMsgView.data = temMessageGroupList;
            }
        }
    }];
}

// 创建UI
- (void)createUI {
    [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self createNavi];
    [self createCardView];
    [self createGroupMsgView];

}

// 建立自定义导航栏
- (void)createNavi {
    self.navi = [[HICCustomNaviView alloc] initWithTitle:self.naviTitle rightBtnName:nil showBtnLine:YES];
    _navi.delegate = self;
    [self.view addSubview:_navi];
}

- (void)createCardView {
    self.cardView = [[HICMsgDetailCardView alloc] initWithFrame:CGRectMake(0, HIC_NavBarAndStatusBarHeight, HIC_ScreenWidth, HIC_ScreenHeight - HIC_NavBarAndStatusBarHeight) type:self.msgType];
    [self.view addSubview:_cardView];
    _cardView.delegate = self;
    _cardView.hidden = YES;
}

- (void)createGroupMsgView {
    self.groupMsgView = [[HICMsgDetailGroupMsgView alloc] initWithFrame:CGRectMake(0, HIC_NavBarAndStatusBarHeight, HIC_ScreenWidth, HIC_ScreenHeight - HIC_NavBarAndStatusBarHeight)];
    [self.view addSubview:_groupMsgView];
    _groupMsgView.delegate = self;
    _groupMsgView.hidden = YES;
}

- (void)changeUnreadMsgStatusWithArr:(NSArray *)arr {
    [HICAPI changeUnreadMsgStatusWithArr:arr success:^(NSDictionary * _Nonnull responseObject) {
        DDLogDebug(@"%@ %ld message changed to read", logName, (long)arr.count);
    } failure:^(NSError * _Nonnull error) {
        DDLogDebug(@"%@ %ld message changed to read falied, error: %@", logName, (long)arr.count, error);
    }];
}

#pragma mark - - - HICCustomNaviViewDelegate  - - -
- (void)leftBtnClicked {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 消息中心的tableview协议方法
-(void)msgView:(HICMsgDetailGroupMsgView *)view selectIndex:(NSIndexPath *)indexPath mode:(id)model {

    DDLogDebug(@"%@", model);
}

-(void)msgCardView:(HICMsgDetailCardView *)view selectIndex:(NSIndexPath *)indexPath mode:(id)model {

    HICMsgModel *msgModel = (HICMsgModel *)model;
    if ([HICCommonUtils isValidObject:msgModel.msgUrl]) {
        NSDictionary *dic = [msgModel.msgUrl mj_JSONObject];
        NSDictionary *iosDic = [dic objectForKey:@"iosvalue"];
        NSString *type = [iosDic objectForKey:@"type"];
        NSString *jumpUrl = [iosDic objectForKey:@"jumpUrl"];
        NSString *pageId = [iosDic objectForKey:@"pageId"];
        NSString *childType = [iosDic objectForKey:@"childType"];
        NSString *workId = [iosDic objectForKey:@"workId"];
        if (type && pageId) {
            if (([type isEqualToString:@"4"] || [type isEqualToString:@"13"]) && jumpUrl) {
                jumpUrl = [jumpUrl stringByRemovingPercentEncoding];
            }
            PushViewControllerModel *pushModel = [[PushViewControllerModel alloc] initWithPushType:type.integerValue urlStr:jumpUrl detailId:pageId.integerValue studyResourceType:0 pushType:0];
            if ([type isEqualToString:@"123"] &&workId &&childType) {
                pushModel.workId = workId.integerValue;
                ///classic经典  wisdomisland智慧岛
                pushModel.mixTrainType = childType;
                pushModel.registChannel = 2;
            }
            if ([type isEqualToString:@"8"] && workId) {
                 pushModel.workId = workId.integerValue;
            }
            if ([type isEqualToString:@"122"] && childType) {
                pushModel.childType = childType.integerValue;
                pushModel.workId = workId.integerValue;
            }
            
            if ([type isEqualToString:@"16"]) {//直播
               pushModel = [[PushViewControllerModel alloc] initWithPushType:1012 urlStr:jumpUrl detailId:pageId.integerValue studyResourceType:0 pushType:0];
            }
            
            [HICPushViewManager parentVC:self pushVCWithModel:pushModel];
        }

    }
}

@end
