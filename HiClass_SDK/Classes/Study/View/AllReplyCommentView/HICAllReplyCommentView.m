//
//  HICAllReplyCommentView.m
//  HiClass
//
//  Created by Eddie Ma on 2020/2/10.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICAllReplyCommentView.h"
#import "HICAllReplyTableViewCell.h"
#import "HICCommentWriteView.h"

static NSString *allReplyCellIdenfer = @"allReplyCell";
static NSString *logName = @"[HIC][ARCV]";
static NSInteger requestRowsNum = 12;

@interface HICAllReplyCommentView()<UITableViewDataSource, UITableViewDelegate, HICAllReplyTableViewCellDelegate>
@property (nonatomic, strong) HICCommentModel *fModel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *exitView;
@property (nonatomic, assign) NSInteger totalCount;
@property (nonatomic, strong) NSMutableArray *replies;
@property (nonatomic, assign) NSInteger requestRows;
@property (nonatomic, strong) NSNumber *totalNum;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *number;
@property (nonatomic, assign) BOOL isFromCourse;
@property (nonatomic, assign) BOOL needRoundCorner;
@end

@implementation HICAllReplyCommentView

- (instancetype)initWithFrame:(CGRect)frame fCommentModel:(HICCommentModel *)fModel totalChComments:(NSInteger)totalCount isFromCourse:(BOOL)isFromCourse needRoundCorner:(BOOL)needRoundCorner {
    if (self = [super initWithFrame:frame]) {
        self.totalCount = totalCount;
        self.fModel = fModel;
        self.isFromCourse = isFromCourse;
        self.needRoundCorner = needRoundCorner;
        [self initData];
        [self requestData];
        [self creatUI];
    }
    return self;
}

- (void)initData {
    self.requestRows = requestRowsNum;
    self.totalCount = _totalCount > 0 ? _totalCount : 0;
    self.replies = [[NSMutableArray alloc] init];
    [_replies addObject:self.fModel];
}

- (void)refreshData {
    [self refreshInitData];
    [self requestData];
}

- (void)refreshInitData {
    self.requestRows = _replies.count;
    self.totalCount = _totalCount > 0 ? _totalCount : 0;
    [self.replies removeAllObjects];
    [_replies addObject:self.fModel];
}

- (void)requestData {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:[self.fModel.commentid toString] forKey:@"commentid"];
    [dic setValue:@(self.replies.count) forKey:@"start"];
    [dic setValue:@(_requestRows) forKey:@"rows"];

    [HICAPI commentBack:dic success:^(NSDictionary * _Nonnull responseObject) {
        NSArray *commentlists = [responseObject valueForKey:@"commentlists"];
        self.totalNum = (NSNumber *)[responseObject valueForKey:@"totalnum"];
        for (int i = 0; i < commentlists.count; i++) {
            HICCommentModel *model = [[HICCommentModel alloc] init];
            model.commentid = (NSNumber *)[commentlists[i] valueForKey:@"commentid"];
            model.comment = [commentlists[i] valueForKey:@"comment"];
            model.commenttime = (NSNumber *)[commentlists[i] valueForKey:@"commenttime"];
            model.upflag = (NSNumber *)[commentlists[i] valueForKey:@"upflag"];
            model.upnum = (NSNumber *)[commentlists[i] valueForKey:@"upnum"];
            model.replynum = (NSNumber *)[commentlists[i] valueForKey:@"replynum"];
            model.userpictureurl = [commentlists[i] valueForKey:@"userpictureurl"];
            model.username = [commentlists[i] valueForKey:@"username"] ? [commentlists[i] valueForKey:@"username"] : @"";
            NSNumber *userId = (NSNumber *)[commentlists[i] valueForKey:@"userId"];
            NSString *userIdStr = [NSString stringWithFormat:@"%@", userId];
            model.isCurrentUser = [USER_CID isEqualToString:userIdStr] ? YES : NO;
            NSDictionary *repilesDic = [commentlists[i] valueForKey:@"commentReplys"];
            model.totalReplies = (NSNumber *)[repilesDic valueForKey:@"totalnum"];
            NSArray *repiles = [repilesDic valueForKey:@"commentlists"];
            NSMutableArray *temRepiles = [[NSMutableArray alloc] init];
            for (int j = 0; j < repiles.count; j++) {
                HICCommentModel *smodel = [[HICCommentModel alloc] init];
                smodel.commentid = (NSNumber *)[repiles[j] valueForKey:@"commentid"];
                smodel.comment = [repiles[j] valueForKey:@"comment"];
                smodel.username = [repiles[j] valueForKey:@"username"];
                NSNumber *suserId = (NSNumber *)[repiles[j] valueForKey:@"userId"];
                NSString *suserIdStr = [NSString stringWithFormat:@"%@", suserId];
                smodel.isCurrentUser = [USER_CID isEqualToString:suserIdStr] ? YES : NO;
                [temRepiles addObject:smodel];
            }
            model.replies = temRepiles;
            [self.replies addObject:model];
            self.requestRows = requestRowsNum;
            [self updateUI];
            [self.tableView reloadData];
        }
    }];
}

- (void)creatUI {
    self.backgroundColor = [UIColor whiteColor];
    if (_needRoundCorner) {
        [HICCommonUtils setRoundingCornersWithView:self TopLeft:YES TopRight:YES bottomLeft:NO bottomRight:NO cornerRadius:15];
    }
    [self initExitView];
    [self initTableView];
}

- (void)updateUI {
    _number.text = [NSString stringWithFormat:@"(%ld)", (long)_totalCount];
    CGFloat noteNumWidth = [HICCommonUtils sizeOfString:_number.text stringWidthBounding:HIC_ScreenWidth font:14 stringOnBtn:NO fontIsRegular:NO].width;
    _number.frame = CGRectMake(16 + _title.frame.size.width + 4, (_exitView.frame.size.height - 20)/2, noteNumWidth, 20);
}

- (void)initExitView {
    _exitView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 50)];
    [self addSubview:_exitView];

    self.title = [[UILabel alloc] initWithFrame:CGRectMake(16, (_exitView.frame.size.height - 24)/2, 34, 24)];
    [_exitView addSubview:_title];
    _title.font = FONT_MEDIUM_17;
    _title.text = NSLocalizableString(@"reply", nil);
    _title.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];

    self.number = [[UILabel alloc] initWithFrame:CGRectMake(16 + _title.frame.size.width + 4, (_exitView.frame.size.height - 20)/2, 23.5, 20)];
    [_exitView addSubview:_number];
    _number.font = FONT_MEDIUM_14;
    _number.text = [NSString stringWithFormat:@"(%ld)", (long)_totalCount];
    _number.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1/1.0];

    UIButton *cancelBtn = [[UIButton alloc] init];
    [_exitView addSubview: cancelBtn];
    cancelBtn.tag = 10000;
    [cancelBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setImage:[UIImage imageNamed:@"关闭弹窗"] forState:UIControlStateNormal];
    cancelBtn.frame = CGRectMake(_exitView.frame.size.width - 20 - 16, (_exitView.frame.size.height - 20)/2, 20, 20);

    UIView *dividedLine = [[UIView alloc] initWithFrame:CGRectMake(0, _exitView.frame.size.height - 0.5, _exitView.frame.size.width, 0.5)];
    [_exitView addSubview: dividedLine];
    dividedLine.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1/1.0];

}

- (void)initTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _exitView.frame.size.height, self.frame.size.width, self.frame.size.height - _exitView.frame.size.height) style:UITableViewStylePlain];
    [self addSubview:_tableView];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
     _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (@available(iOS 15.0, *)) {
        _tableView.sectionHeaderTopPadding = 0;
    }
}

- (void)btnClicked:(UIButton *)btn {
    if (btn.tag == 10000) {
        [UIView animateWithDuration:0.3 animations:^{
            self.frame = CGRectMake(self.frame.origin.x, HIC_ScreenHeight, self.frame.size.width, self.frame.size.height);
        }];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self removeFromSuperview];
        });
    }
}

#pragma mark tableview dataSorce协议
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _replies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HICAllReplyTableViewCell *allReplyCell = (HICAllReplyTableViewCell *)[tableView dequeueReusableCellWithIdentifier:allReplyCellIdenfer];
    if (allReplyCell == nil) {
        allReplyCell = [[HICAllReplyTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:allReplyCellIdenfer];
        allReplyCell.delegate = self;
        [allReplyCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    } else {
    }

    HICCommentModel *model = _replies[indexPath.row];
    [allReplyCell setData:model index:indexPath.row];

    return allReplyCell;

}

#pragma mark tableview delegate协议方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    HICCommentModel *model = _replies[indexPath.row];
    CGFloat height = 0.0;
    if (indexPath.row == 0) {
        height = 16 + 44 + 10.5 + [self getContentHeight:model.comment] + 16 + 20;
    } else {
        height = 16 + 44 + 10.5 + [self getContentHeight:model.comment] + 16;
    }
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat reminder =  (float)(_replies.count % _requestRows); //判断是否还需要继续请求新数据
    BOOL httpSendBack = _totalCount != _replies.count ? YES : NO; // 用于检测是否有新数据来，防止新数据还没来，又去刷新请求
    if (indexPath.row == _replies.count - 5 && reminder == 0.0 && httpSendBack) {
        [self requestData];
        _totalCount = _replies.count;
    }
}

- (CGFloat)getContentHeight:(NSString *)str {
    UILabel *label = [[UILabel alloc] init];
    label.text = str;
    label.font = FONT_REGULAR_15;
    label.numberOfLines = 0;
    CGFloat labelHeight = [HICCommonUtils sizeOfString:str stringWidthBounding:HIC_ScreenWidth - 16 - 68 font:15 stringOnBtn:NO fontIsRegular:YES].height;
    label.frame = CGRectMake(0, 0, HIC_ScreenWidth - 16 - 68, labelHeight);
    [label sizeToFit];
    return label.frame.size.height;
}

#pragma mark HICAllReplyTableViewCellDelegate
- (void)commentActionBtnClicked:(HICCommentActions)action index:(NSInteger)index cancelThumbupBtn:(BOOL)cancelThumbupBtn{
    HICCommentModel *model = _replies[index];
    NSNumber *optype = @(0);
    if (action == HICThumbupAction) {
        optype = @(1);
        if ([model.upflag integerValue] == 0) {
            model.upflag = @(1);
        } else {
            [HICToast showWithText:NSLocalizableString(@"notLikeItTwice", nil)];
            return;
        }
        model.upnum = cancelThumbupBtn ? @([model.upnum integerValue] - 1) : @([model.upnum integerValue] + 1);
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
    } else if (action == HICReplyAction) {
        optype = @(2);
        if ([self.delegate respondsToSelector:@selector(showReplyInput:)]) {
            [self.delegate showReplyInput: model];
        }
        return;
    } else {
        if (index == 0) { // 删除评论
            optype = @(3);
        } else { // 删除回复
            optype = @(4);
        }
    }

    DDLogDebug(@"%@ Index: %ld, commentID: %@", logName, (long)index, model.commentid);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setValue:optype forKey:@"optype"];
        [dic setValue:self.isFromCourse ? @"6" : @"7" forKey:@"typeCode"];
        [dic setValue:[NSString stringWithFormat:@"%@", model.commentid] forKey:@"commentid"];
        [dic setValue:@"9999" forKey:@"productCode"];
        [HICAPI LikeReplyDeleteCommentReply:dic success:^(NSDictionary * _Nonnull responseObject) {
            DDLogDebug(@"%@ Comment Deleted!", logName);
            NSString *hint = @"";
            if (action == HICThumbupAction) {
                hint = NSLocalizableString(@"thumbUpSuccess", nil);
                if (responseObject[@"data"] && [responseObject[@"data"] isKindOfClass:NSDictionary.class]) {
                    NSNumber *points = responseObject[@"data"][@"points"];
                    if (points && points.integerValue > 0) {
                        hint = [NSString stringWithFormat:@"%@，%@", hint, HICLocalizedFormatString(@"rewardPointsToast", points.integerValue)];
                    }
                }
            } else if (action == HICReplyAction) {
                hint = NSLocalizableString(@"replySuccess", nil);
            } else {
                if (index == 0) { // 删除评论
                    hint = NSLocalizableString(@"deleteCommentSucceeded", nil);
                } else { // 删除回复
                    hint = NSLocalizableString(@"deletingReplySucceeded", nil);
                }
            }
            [HICToast showWithText:hint];
            [self refreshInitData];
            [self requestData];
        } failure:^(NSError * _Nonnull error) {
            DDLogDebug(@"%@ Comment Deleted failed!, error: %@", logName, error);
            NSString *hint = @"";
            if (action == HICThumbupAction) {
                hint = NSLocalizableString(@"thumbUpFailurePrompt", nil);
            } else if (action == HICReplyAction) {
                hint = NSLocalizableString(@"respondToFailurePrompt", nil);
            } else {
                if (index == 0) { // 删除评论
                    hint = NSLocalizableString(@"deleteCommentFaildPrompt", nil);
                } else { // 删除回复
                    hint = NSLocalizableString(@"failedDeleteReplyPrompt", nil);
                }
            }
            [HICToast showWithText:hint];
        }];
    });
}

@end
