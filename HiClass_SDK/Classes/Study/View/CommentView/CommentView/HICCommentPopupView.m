//
//  HICCommentPopupView.m
//  HiClass
//
//  Created by Eddie_Ma on 17/2/20.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICCommentPopupView.h"
#import "HICCommentViewCell.h"
#import "HICCommentModel.h"
#import "HICCommentWriteView.h"
#import "HICAllReplyCommentView.h"

static NSString *commentCellIdenfer = @"commentCell";
static NSString *logName = @"[HIC][CPV]";
static NSInteger requestRowsNum = 12;

@interface HICCommentPopupView()<UITableViewDataSource, UITableViewDelegate, HICCommentViewCellDelegate, HICCommentWriteViewDelegate, HICAllReplyCommentViewDelegate>
@property (nonatomic, assign) CGFloat videoSectionHeight;
@property (nonatomic, strong) NSMutableArray *commentsArr;
@property (nonatomic, strong) UIView *commentContainer;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) HICCommentWriteView *cwv;
@property (nonatomic, assign) BOOL isFromCourse;
@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, assign) NSInteger totalCount;
@property (nonatomic, assign) NSInteger requestRows;
@property (nonatomic, strong) UIView *defaultBackView;
@property (nonatomic, strong) UILabel *commentTitle;
@property (nonatomic, strong) UILabel *commentNum;
@property (nonatomic, strong) NSNumber *totalNum;
@property (nonatomic, strong) HICAllReplyCommentView *arV;
@property (nonatomic, assign) CGFloat topMargin;
@end

@implementation HICCommentPopupView

-(UIView *)defaultBackView {
    if (!_defaultBackView) {
        _defaultBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 200, HIC_ScreenWidth, 255.5)];

        CGFloat left = (HIC_ScreenWidth-120)/2.0;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(left, 40, 120, 120)];
        imageView.image = [UIImage imageNamed:@"暂无评论"];
        [_defaultBackView addSubview:imageView];

        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 168, HIC_ScreenWidth-20, 50)];
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
        textLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15.f];
        textLabel.text = NSLocalizableString(@"noComments", nil);
        textLabel.numberOfLines = 2;
        [_defaultBackView addSubview:textLabel];
    }
    return _defaultBackView;
}

- (instancetype)initWithVideoSectionHeight:(CGFloat)videoSectionHeight isFromCourse:(BOOL)isFromCourse identifier:(NSString *)identifier {
    if (self = [super init]) {
        self.videoSectionHeight = videoSectionHeight;
        self.isFromCourse = isFromCourse;
        self.identifier = identifier;
        [self initData];
        [self requestData];
        [self creatUI];
    }
    return self;
}

- (void)initData {
    self.requestRows = requestRowsNum;
    self.totalCount = -1;
    self.commentsArr = [[NSMutableArray alloc] init];
}

- (void)refreshInitData {
    self.requestRows = _commentsArr.count;
    self.totalCount = -1;
    [self.commentsArr removeAllObjects];
}

- (void)requestData {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:_isFromCourse ? @"6" :@"7" forKey:@"typeCode"];
    [dic setValue:_identifier forKey:@"objectid"];
    [dic setValue:@"9999" forKey:@"productCode"];
    [dic setValue:@(self.commentsArr.count) forKey:@"start"];
    [dic setValue:@(_requestRows) forKey:@"rows"];
    [HICAPI commentList:dic success:^(NSDictionary * _Nonnull responseObject) {
        NSArray *commentlists = [responseObject valueForKey:@"commentlists"];
        self.totalNum = (NSNumber *)[responseObject valueForKey:@"totalnum"];
        if (commentlists.count > 0) {
            self.defaultBackView.hidden = YES;
            self.tableView.hidden = NO;
        } else {
            self.defaultBackView.hidden = NO;
            self.tableView.hidden = YES;
        }
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
            [self.commentsArr addObject:model];
            self.requestRows = requestRowsNum;
            [self updateUI];
            [self.tableView reloadData];
        }
    } failure:^(NSError * _Nonnull error) {
        DDLogDebug(@"error");
    }];
}

- (void)creatUI {
    self.topMargin = (_videoSectionHeight == 0.0) ? 72 - 20 + HIC_StatusBar_Height : _videoSectionHeight;
    self.frame = CGRectMake(0, _topMargin, HIC_ScreenWidth, HIC_ScreenHeight - _topMargin);
    self.backgroundColor = [UIColor clearColor];
    _commentContainer = [[UIView alloc] init];
    [self addSubview: _commentContainer];
    _commentContainer.backgroundColor = [UIColor whiteColor];
    _commentContainer.frame = CGRectMake(0, HIC_ScreenHeight, self.frame.size.width, self.frame.size.height);
    [UIView animateWithDuration:0.3 animations:^{
        self->_commentContainer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    }];
    if (_videoSectionHeight == 0.0) {
        [HICCommonUtils setRoundingCornersWithView:_commentContainer TopLeft:YES TopRight:YES bottomLeft:NO bottomRight:NO cornerRadius:15];
    }
    [_commentContainer addSubview:self.defaultBackView];

    self.commentTitle = [[UILabel alloc] init];
    [_commentContainer addSubview:_commentTitle];
    _commentTitle.frame = CGRectMake(16, (50 - 24)/2, 34, 24);
    _commentTitle.font = FONT_MEDIUM_17;
    _commentTitle.text = NSLocalizableString(@"comments", nil);
    _commentTitle.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];

    self.commentNum = [[UILabel alloc] init];
    [_commentContainer addSubview:_commentNum];
    _commentNum.font = FONT_MEDIUM_14;
    _commentNum.text = [NSString stringWithFormat:@"(%ld)",(long)_commentsArr.count];
    CGFloat noteNumWidth = [HICCommonUtils sizeOfString:_commentNum.text stringWidthBounding:HIC_ScreenWidth font:14 stringOnBtn:NO fontIsRegular:NO].width;
    _commentNum.frame = CGRectMake(16 + _commentTitle.frame.size.width + 4, (50 - 20)/2, noteNumWidth, 20);
    _commentNum.textColor =  [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1/1.0];

    UIButton *cancelBtn = [[UIButton alloc] init];
    [_commentContainer addSubview: cancelBtn];
    cancelBtn.tag = 10000;
    [cancelBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setImage:[UIImage imageNamed:@"关闭弹窗"] forState:UIControlStateNormal];
    cancelBtn.frame = CGRectMake(_commentContainer.frame.size.width - 20 - 16, (50 - 20)/2, 20, 20);

    UIView *dividedLine = [[UIView alloc] initWithFrame:CGRectMake(0, 50 - 0.5, _commentContainer.frame.size.width, 0.5)];
    [_commentContainer addSubview: dividedLine];
    dividedLine.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1/1.0];

    [self initTableView];
}

- (void)updateUI {
    _commentNum.text = [NSString stringWithFormat:@"(%@)", self.totalNum ? self.totalNum : @(0)];
    CGFloat noteNumWidth = [HICCommonUtils sizeOfString:_commentNum.text stringWidthBounding:HIC_ScreenWidth font:14 stringOnBtn:NO fontIsRegular:NO].width;
    _commentNum.frame = CGRectMake(16 + _commentTitle.frame.size.width + 4, (50 - 20)/2, noteNumWidth, 20);
}

- (void)initTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, _commentContainer.frame.size.width, _commentContainer.frame.size.height - 50) style:UITableViewStylePlain];
    [_commentContainer addSubview:_tableView];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
     _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (@available(iOS 15.0, *)) {
        _tableView.sectionHeaderTopPadding = 0;
    }
}

#pragma mark tableview dataSorce协议
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _commentsArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HICCommentViewCell *commentCell = (HICCommentViewCell *)[tableView dequeueReusableCellWithIdentifier:commentCellIdenfer];
    if (commentCell == nil) {
        commentCell = [[HICCommentViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:commentCellIdenfer];
        commentCell.delegate = self;
        [commentCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    } else {

    }
    HICCommentModel *model = _commentsArr[indexPath.row];
    [commentCell setData:model index:indexPath.row];

    return commentCell;

}

#pragma mark tableview delegate协议方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat tagHeight = 10.5;
    HICCommentModel *model = _commentsArr[indexPath.row];
    if (model.commentstatus && [model.commentstatus integerValue] == 0) {
        tagHeight = 10.5 + 18 + 4;
    }

    // 父评论文字高度
    CGFloat faCommentHeight = [self getContentHeight:model];
    
    // 子评论高度
    CGFloat chCommentHeight = 0.0;
    if (model.replies.count > 0) {
        NSMutableArray *chCommentStrArr = [[NSMutableArray alloc] init];
        for (int i = 0; i < model.replies.count; i ++) {
            HICCommentModel *smodel = model.replies[i];
            NSString *chCommentStr = [NSString stringWithFormat:@"%@: %@", smodel.username, smodel.comment];
            [chCommentStrArr addObject:chCommentStr];
        }
        chCommentHeight = [self getSubContentHeight:chCommentStrArr];
    }
    if ([model.totalReplies integerValue] > 3) {
        chCommentHeight = chCommentHeight + 2.5 + 20;
    }
    return 16 + 44 + tagHeight + faCommentHeight + chCommentHeight + 16;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat reminder =  (float)(self.commentsArr.count % _requestRows); //判断是否还需要继续请求新数据
    BOOL httpSendBack = _totalCount != _commentsArr.count ? YES : NO; // 用于检测是否有新数据来，防止新数据还没来，又去刷新请求
    if (indexPath.row == _commentsArr.count - 5 && reminder == 0.0 && httpSendBack) {
        [self requestData];
        _totalCount = _commentsArr.count;
    }
}

- (CGFloat)getContentHeight:(HICCommentModel *)model {
    UILabel *label = [[UILabel alloc] init];
    label.text = model.comment;
    label.font = FONT_REGULAR_15;
    label.numberOfLines = model.showFullComment ? 0 : 4;
    CGFloat labelHeight = [HICCommonUtils sizeOfString:model.comment stringWidthBounding:HIC_ScreenWidth - 16 - 68 font:15 stringOnBtn:NO fontIsRegular:YES].height;
    label.frame = CGRectMake(0, 0, HIC_ScreenWidth - 68 - 16, labelHeight);
    [label sizeToFit];

    NSArray *Lines = [HICCommonUtils getLinesArrayOfStringInLabel:label];
    CGFloat allContentHeight = 0.0;
    if (Lines.count > 4 && !model.showFullComment) {
        allContentHeight = 4 + 20 + 4;
    }
    return label.frame.size.height + allContentHeight;
}

- (CGFloat)getSubContentHeight:(NSArray *)arr {
    CGFloat subItemsHeight = 6 + 10 + 10;
    NSInteger count = arr.count > 3 ? 3 : arr.count;
    for (int i = 0; i < count; i ++) {
        NSString *str = arr[i];
        UILabel *label = [[UILabel alloc] init];
        label.text = str;
        label.font = FONT_REGULAR_14;
        label.numberOfLines = 2;
        CGFloat labelHeight = [HICCommonUtils sizeOfString:str stringWidthBounding:HIC_ScreenWidth - 26 - 78 font:14 stringOnBtn:NO fontIsRegular:YES].height;
        label.frame = CGRectMake(0, 0, HIC_ScreenWidth - 26 - 78, labelHeight);
        [label sizeToFit];
        subItemsHeight = subItemsHeight + label.frame.size.height;
    }
    subItemsHeight = subItemsHeight + 2.5 * (count - 1);
    return subItemsHeight;
}

- (void)btnClicked:(UIButton *)btn {
    if (btn.tag == 10000) {
        [UIView animateWithDuration:0.3 animations:^{
            self->_commentContainer.frame = CGRectMake(0, HIC_ScreenHeight, self.frame.size.width, self.frame.size.height);
        }];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self removeFromSuperview];
        });
    }
}

#pragma mark - - - HICCommentViewCellDelegate - - - Start
// 删除评论
- (void)commentDelete:(NSInteger)index {
    HICCommentModel *model = _commentsArr[index];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setValue:@(3) forKey:@"optype"];
        [dic setValue:self.isFromCourse ? @"6" : @"7" forKey:@"typeCode"];
        [dic setValue:[NSString stringWithFormat:@"%@", model.commentid] forKey:@"commentid"];
        [dic setValue:@"9999" forKey:@"productCode"];
        [HICAPI LikeReplyDeleteCommentReply:dic success:^(NSDictionary * _Nonnull responseObject) {
            DDLogDebug(@"%@ Comment Deleted!", logName);
            [HICToast showWithText:NSLocalizableString(@"deleteCommentSucceeded", nil)];
            [self refreshInitData];
            [self requestData];
        } failure:^(NSError * _Nonnull error) {
            DDLogDebug(@"%@ Comment Deleted failed!, error: %@", logName, error);
            [HICToast showWithText:NSLocalizableString(@"deleteCommentFaild", nil)];
        }];
    });
}

// 删除回复
- (void)commentDelete:(NSInteger)index subIndex:(NSInteger)subIndex {
    HICCommentModel *model = _commentsArr[index];
    if (model) {
        HICCommentModel *sModel = model.replies[subIndex];
        if (sModel) {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                [dic setValue:@(4) forKey:@"optype"];
                [dic setValue:self.isFromCourse ? @"6" : @"7" forKey:@"typeCode"];
                [dic setValue:[NSString stringWithFormat:@"%@", sModel.commentid] forKey:@"commentid"];
                [dic setValue:@"9999" forKey:@"productCode"];
                [HICAPI LikeReplyDeleteCommentReply:dic success:^(NSDictionary * _Nonnull responseObject) {
                    DDLogDebug(@"%@ Comment Deleted!", logName);
                    [HICToast showWithText:NSLocalizableString(@"deletingReplySucceeded", nil)];
                    [self refreshInitData];
                    [self requestData];
                } failure:^(NSError * _Nonnull error) {
                    DDLogDebug(@"%@ Comment Deleted failed!, error: %@", logName, error);
                    [HICToast showWithText:NSLocalizableString(@"failedDeleteReply", nil)];
                }];
            });
        }
    }
}

- (void)commentReply:(NSInteger)index {
    HICCommentModel *model = _commentsArr[index];
    self.cwv = [[HICCommentWriteView alloc] initWithType:HICCommentReply commentTo:model.username identifer:[NSString stringWithFormat:@"%@",model.commentid]];
    [self.onView addSubview:_cwv];
    if (!_cwv.delegate) {
        _cwv.delegate = self;
    }
}

// 点赞
- (void)commentThumbUp:(NSInteger)index {
    // 1. 更新本地UI
    HICCommentModel *model = _commentsArr[index];
    if ([model.upflag integerValue] == 0) {
        model.upflag = @(1);
    } else {
        [HICToast showWithText:NSLocalizableString(@"notLikeItTwice", nil)];
        return;
    }
    model.upnum = @([model.upnum integerValue] + 1);
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];

    // 2. 异步发送点赞请求
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setValue:@(1) forKey:@"optype"];
        [dic setValue:self.isFromCourse ? @"6" : @"7" forKey:@"typeCode"];
        [dic setValue:[NSString stringWithFormat:@"%@", model.commentid] forKey:@"commentid"];
        [dic setValue:@"9999" forKey:@"productCode"];
        [HICAPI LikeReplyDeleteCommentReply:dic success:^(NSDictionary * _Nonnull responseObject) {
            DDLogDebug(@"%@ Comment thumbuped!", logName);
            NSString *toastStr = NSLocalizableString(@"thumbUpSuccess", nil);
            if (responseObject[@"data"] && [responseObject[@"data"] isKindOfClass:NSDictionary.class]) {
                NSNumber *points = responseObject[@"data"][@"points"];
                if (points && points.integerValue > 0) {
                    toastStr = [NSString stringWithFormat:@"%@，%@", toastStr, HICLocalizedFormatString(@"rewardPointsToast", points.integerValue)];
                }
            }
            [HICToast showWithText:toastStr];
        } failure:^(NSError * _Nonnull error) {
            DDLogDebug(@"%@ Comment thumbuped failed!, error: %@", logName, error);
            [HICToast showWithText:NSLocalizableString(@"thumbUpFailure", nil)];
        }];
    });
}

- (void)seeFullComments:(NSInteger)index {
    HICCommentModel *model = _commentsArr[index];
    model.showFullComment = YES;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)seeAllSubComments:(NSInteger)index {
    HICCommentModel *model = _commentsArr[index];
    self.arV = [[HICAllReplyCommentView alloc] initWithFrame:CGRectMake(-HIC_ScreenWidth, self.topMargin, HIC_ScreenWidth, HIC_ScreenHeight - self.topMargin) fCommentModel:model totalChComments:[model.totalReplies integerValue] isFromCourse:self.isFromCourse needRoundCorner:_videoSectionHeight == 0.0 ? YES : NO];
    [self.onView addSubview: _arV];
    _arV.delegate = self;
    [UIView animateWithDuration:0.3 animations:^{
        self.arV.frame = CGRectMake(0, self.topMargin, HIC_ScreenWidth, HIC_ScreenHeight - self.topMargin);
    }];
}

#pragma mark - - - HICCommentViewCellDelegate - - - End

#pragma mark - - - HICCommentWriteViewDelegate - - - Start
    // 回复
- (void)publishBtnClickedWithContent:(NSString *)content type:(HICCommentType)type starNum:(NSInteger)stars isImportant:(BOOL)important toAnybody:(NSString *)name {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:@(2) forKey:@"optype"];
    [dic setValue:content forKey:@"comment"];
    [dic setValue:_isFromCourse ? @"6" : @"7" forKey:@"typeCode"];
    [dic setValue:name forKey:@"commentid"];
    [dic setValue:@"9999" forKey:@"productCode"];
    [HICAPI LikeReplyDeleteCommentReply:dic success:^(NSDictionary * _Nonnull responseObject) {
        DDLogDebug(@"%@ Comment replied!", logName);
        [HICToast showWithText:NSLocalizableString(@"replySuccess", nil)];
        [self.cwv hide];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"HICEditedInfoBefore"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self refreshInitData];
        [self requestData];
        if (self.arV) {
            [self.arV refreshData];
        }
    } failure:^(NSError * _Nonnull error) {
        DDLogDebug(@"%@ Comment replied falied!, error: %@", logName, error);
        [HICToast showWithText:NSLocalizableString(@"respondToFailurePrompt", nil)];
    }];
}
#pragma mark - - - HICCommentWriteViewDelegate - - - End

#pragma mark - - - HICAllReplyCommentViewDelegate - - - Start
- (void)showReplyInput:(HICCommentModel *)model {
    self.cwv = [[HICCommentWriteView alloc] initWithType:HICCommentReply commentTo:model.username identifer:[NSString stringWithFormat:@"%@",model.commentid]];
    [self.onView addSubview:_cwv];
    if (!_cwv.delegate) {
        _cwv.delegate = self;
    }
}

#pragma mark - - - HICAllReplyCommentViewDelegate - - - End

@end
