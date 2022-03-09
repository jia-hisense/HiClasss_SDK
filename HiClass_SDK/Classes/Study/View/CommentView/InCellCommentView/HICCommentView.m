//
//  HICCommentView.m
//  HiClass
//
//  Created by Eddie Ma on 2020/2/5.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICCommentView.h"

@interface HICCommentView()

@property (nonatomic, assign) CGFloat commentViewHeight; // 评论view总高度
@property (nonatomic, strong) NSArray *comments;
@property (nonatomic, strong) NSMutableArray *showAllContentIndexArr; // 记录共有多少点击了展示"全文"的评论

@end

@implementation HICCommentView

- (instancetype)initWithData:(NSArray *)comments {
    if (self = [super init]) {
        NSArray *fakeComments = @[@{@"faPic":@"微信朋友圈",@"faName":@"王雪",@"faDate":@"2019-01-14 10:20", @"faContent":@"啥撒的谎啥的客户就，按时撒大声地按实际到货。按时撒大声地按实际到货按时撒大声地按实际到货按时撒大声地按实际到货按时撒大声地按实际到货按时撒大声地按实际到货按时撒大声地按实际到货按时撒大声地按实际到货按时撒大声地按实际到货按时撒大声地按实际到货按时撒大声地按实际到货按时撒大声地按实际到货萨达和时刻打开", @"faContentStatus":@"0",@"faReplay":@"0", @"faThumbUp":@"0"},@{@"faPic":@"微信朋友圈",@"faName":@"刘能",@"faDate":@"2019-01-10 11:20", @"faContent":@"就是很棒！", @"faContentStatus":@"1", @"chComments":@[@{@"chName":@"刘强东", @"chContent":@"我看行"},@{@"chName":@"马化腾", @"chContent":@"我就是觉得你真是个人才，哈哈哈哈哈"},@{@"chName":@"马云", @"chContent":@"二楼是傻叉"},@{@"chName":@"刘德华", @"chContent":@"真的是猪啊"}],@"faReplay":@"2", @"faThumbUp":@"1"},@{@"faPic":@"微信朋友圈",@"faName":@"赵嘿嘿",@"faDate":@"2019-01-07 10:20", @"faContent":@"你愁啥，瞅你咋地？不服气吗？不服出来一起舔冰棍", @"faContentStatus":@"1",@"faReplay":@"3", @"faThumbUp":@"0"}];
        self.comments = fakeComments;
        self.backgroundColor = [UIColor whiteColor];
        self.showAllContentIndexArr = [[NSMutableArray alloc] init];
        [self createUI];
    }
    return self;
}

- (void)createUI {
    for (int i = 0; i < self.comments.count; i ++) {
        NSDictionary *commentDic = self.comments[i];
        [self createCommentItem:commentDic startHeight:self.commentViewHeight index:i];

        if (i != self.comments.count - 1) {
            UIView *dividedLine = [[UIView alloc] initWithFrame:CGRectMake(68, self.commentViewHeight - 0.5, HIC_ScreenWidth - 68, 0.5)];
            dividedLine.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1/1.0];
            [self addSubview:dividedLine];
        }
    }
    self.frame = CGRectMake(0, 0, HIC_ScreenWidth, self.commentViewHeight);
    if ([self.delegate respondsToSelector:@selector(currentCommentViewFrame:)]) {
        [self.delegate currentCommentViewFrame:self.frame];
    }
}

- (void)createCommentItem:(NSDictionary *)dic startHeight:(CGFloat)startHeight index:(NSInteger)index {
    CGFloat height = 0.0;
    BOOL hasChildrenComments = NO;
    NSArray *chContents = dic[@"chComments"];
    if (chContents.count > 0) {
        hasChildrenComments = YES;
    }
    UIView *commentContainer = [[UIView alloc] init];
    [self addSubview:commentContainer];

#pragma mark 父用户信息section ---- start
    UIView *faInfoSection = [[UIView alloc] initWithFrame:CGRectMake(0, 0, HIC_ScreenWidth, 44 + 16)];
    [commentContainer addSubview:faInfoSection];
    height = height + faInfoSection.frame.size.height;

    // 父用户头像
    UIImageView *faPic = [[UIImageView alloc] init];
    [faInfoSection addSubview:faPic];
    faPic.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1/1.0];
    faPic.image = [UIImage imageNamed:dic[@"faPic"]];
    faPic.layer.cornerRadius = 4;
    faPic.layer.masksToBounds = YES;
    faPic.frame = CGRectMake(16, 16, 44, 44);

    // 父用户名字
    UILabel *faName = [[UILabel alloc] init];
    [faInfoSection addSubview:faName];
    faName.text = dic[@"faName"];
    faName.font = FONT_REGULAR_15;
    faName.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1/1.0];
    faName.frame = CGRectMake(16 + faPic.frame.size.width + 8, 17, 90, 21);

    // 父用户时间
    UILabel *faDate = [[UILabel alloc] init];
    [faInfoSection addSubview:faDate];
    faDate.text = dic[@"faDate"];
    faDate.font = FONT_REGULAR_13;
    faDate.textColor =  [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1/1.0];
    faDate.frame = CGRectMake(16 + faPic.frame.size.width + 8, 40, 120, 18.5);

    // 点赞
    CGFloat thumbupImgWidth = 15.5;
    CGFloat thumbupImgHeight = 14.5;
    UIButton *thumbupGroups = [[UIButton alloc] init];
    [faInfoSection addSubview: thumbupGroups];
    // 点赞-图片
    UIImageView *thumbupImg = [[UIImageView alloc] init];
    [thumbupGroups addSubview: thumbupImg];
    thumbupImg.image = [UIImage imageNamed:@"icon-点赞总数"];
    thumbupImg.frame = CGRectMake(0, 0, thumbupImgWidth, thumbupImgHeight);
    // 点赞-文字/数字
    UILabel *thumbupDes = [[UILabel alloc] init];
    [thumbupGroups addSubview:thumbupDes];
    if ([dic[@"faThumbUp"] isEqual:@"0"]) {
        thumbupDes.text = NSLocalizableString(@"giveLike", nil);
        thumbupDes.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1/1.0];
    } else {
        thumbupImg.image = [UIImage imageNamed:@"评论-icon-已点赞"];
        thumbupDes.text = dic[@"faThumbUp"];
        thumbupDes.textColor = [UIColor colorWithRed:255/255.0 green:133/255.0 blue:0/255.0 alpha:1/1.0];
    }
    thumbupDes.font = FONT_REGULAR_13;
    CGSize thumbupDesSize = [HICCommonUtils sizeOfString:thumbupDes.text stringWidthBounding:HIC_ScreenWidth font:13 stringOnBtn:NO fontIsRegular:YES];
    thumbupDes.frame = CGRectMake(thumbupImgWidth + 4.5, 0, thumbupDesSize.width, thumbupDesSize.height);
    thumbupImg.frame = CGRectMake(0, (thumbupDes.frame.size.height - thumbupImgHeight)/2, thumbupImgWidth, thumbupImgHeight);
    thumbupGroups.frame = CGRectMake(HIC_ScreenWidth - 16 - (thumbupImg.frame.size.width + 4.5 + thumbupDes.frame.size.width), 18, thumbupImg.frame.size.width + 4.5 + thumbupDes.frame.size.width, thumbupDes.frame.size.height);

    // 回复
    CGFloat replyImgWidth = 15;
    CGFloat replyImgHeight = 15;
    UIButton *replyGroups = [[UIButton alloc] init];
    [faInfoSection addSubview: replyGroups];
    // 回复-图片
    UIImageView *replyImg = [[UIImageView alloc] init];
    [replyGroups addSubview: replyImg];
    replyImg.image = [UIImage imageNamed:@"评论-icon-回复"];
    replyImg.frame = CGRectMake(0, 0, replyImgWidth, replyImgHeight);
    // 回复-文字/数字
    UILabel *replyDes = [[UILabel alloc] init];
    [replyGroups addSubview:replyDes];
    replyDes.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1/1.0];
    if ([dic[@"faReplay"] isEqual:@"0"]) {
        replyDes.text = NSLocalizableString(@"reply", nil);
    } else {
        replyDes.text = dic[@"faReplay"];
    }
    replyDes.font = FONT_REGULAR_13;
    CGSize replyDesSize = [HICCommonUtils sizeOfString:replyDes.text stringWidthBounding:HIC_ScreenWidth font:13 stringOnBtn:NO fontIsRegular:YES];
    replyDes.frame = CGRectMake(replyImgWidth + 4.5, 0, replyDesSize.width, replyDesSize.height);
    replyImg.frame = CGRectMake(0, (replyDes.frame.size.height - replyImgHeight)/2, replyImgWidth, replyImgHeight);
    replyGroups.frame = CGRectMake(HIC_ScreenWidth - 16 - thumbupGroups.frame.size.width - (replyImg.frame.size.width + 4.5 + replyDes.frame.size.width) - 14, 18, replyImg.frame.size.width + 4.5 + replyDes.frame.size.width, replyDes.frame.size.height);

    // 删除
    if ([dic[@"faContentStatus"] isEqual:@"0"]) {
        CGFloat deleteImgWidth = 14;
        CGFloat deleteImgHeight = 15;
        UIButton *deleteGroups = [[UIButton alloc] init];
        [faInfoSection addSubview: deleteGroups];
        // 删除-图片
        UIImageView *deleteImg = [[UIImageView alloc] init];
        [deleteGroups addSubview: deleteImg];
        deleteImg.image = [UIImage imageNamed:@"评论-删除"];
        deleteImg.frame = CGRectMake(0, 0, deleteImgWidth, deleteImgHeight);
        // 删除-文字
        UILabel *deleteDes = [[UILabel alloc] init];
        [deleteGroups addSubview:deleteDes];
        deleteDes.text = NSLocalizableString(@"delete", nil);
        deleteDes.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1/1.0];

        deleteDes.font = FONT_REGULAR_13;
        CGSize deleteDesSize = [HICCommonUtils sizeOfString:deleteDes.text stringWidthBounding:HIC_ScreenWidth font:13 stringOnBtn:NO fontIsRegular:YES];
        deleteDes.frame = CGRectMake(deleteImgWidth + 4.5, 0, deleteDesSize.width, deleteDesSize.height);
        deleteImg.frame = CGRectMake(0, (deleteDes.frame.size.height - deleteImgHeight)/2, deleteImgWidth, deleteImgHeight);
        deleteGroups.frame = CGRectMake(HIC_ScreenWidth - 16 - thumbupGroups.frame.size.width -  replyGroups.frame.size.width - (deleteImg.frame.size.width + 4.5 + deleteDes.frame.size.width) - 2 * 14, 18, deleteImg.frame.size.width + 4.5 + deleteDes.frame.size.width, deleteDes.frame.size.height);
    }
#pragma mark 父用户信息section ---- end

#pragma mark 父评论内容section ---- start
    UIView *faContentSection = [[UIView alloc] initWithFrame:CGRectMake(0, height, HIC_ScreenWidth, 0)];
    [commentContainer addSubview:faContentSection];
    CGFloat contentStatusHeight = 0.0;
    CGFloat allContentBtnHeight = 0.0;
    // 待审核
    if ([dic[@"faContentStatus"] isEqual:@"0"]) {
        UILabel *contentStatus = [[UILabel alloc] init];
        [faContentSection addSubview: contentStatus];
        contentStatus.text = NSLocalizableString(@"waitAudit", nil);
        contentStatus.font = FONT_MEDIUM_12;
        contentStatus.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1/1.0];
        contentStatus.backgroundColor = [UIColor colorWithRed:185/255.0 green:185/255.0 blue:185/255.0 alpha:1/1.0];
        contentStatus.layer.cornerRadius = 1.5;
        contentStatus.textAlignment = NSTextAlignmentCenter;
        contentStatus.layer.masksToBounds = YES;
        contentStatus.frame = CGRectMake(68, 5, 42, 20);
        contentStatusHeight = 20 + 4;
    }

    // 父评论内容
    UILabel *faCommnetContent = [[UILabel alloc] init];
    [faContentSection addSubview: faCommnetContent];
    faCommnetContent.text = dic[@"faContent"];
    faCommnetContent.font = FONT_REGULAR_15;
    faCommnetContent.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    if (![self.showAllContentIndexArr containsObject: @(index)]) {
        faCommnetContent.lineBreakMode = NSLineBreakByTruncatingTail;
        faCommnetContent.numberOfLines = 4;
    } else {
        faCommnetContent.numberOfLines = 0;
    }
    CGSize faCommnetContentSize = [HICCommonUtils sizeOfString:faCommnetContent.text stringWidthBounding:HIC_ScreenWidth - 68 - 16 font:15 stringOnBtn:NO fontIsRegular:YES];
    faCommnetContent.frame = CGRectMake(68, 5 + contentStatusHeight, HIC_ScreenWidth - 68 - 16, faCommnetContentSize.height);
    [faCommnetContent sizeToFit];
    NSArray *faCommnetContentLines = [HICCommonUtils getLinesArrayOfStringInLabel:faCommnetContent];
    if (faCommnetContentLines.count > 4 && ![self.showAllContentIndexArr containsObject: @(index)]) {
        // 全文按钮
        UIButton *allContentBtn = [[UIButton alloc] init];
        [faContentSection addSubview:allContentBtn];
        [allContentBtn setTitle:NSLocalizableString(@"fullText", nil) forState:UIControlStateNormal];
        [allContentBtn setTitleColor:[UIColor colorWithRed:0/255.0 green:190/255.0 blue:215/255.0 alpha:1/1.0] forState:UIControlStateNormal];
        allContentBtn.titleLabel.font = FONT_REGULAR_14;
        allContentBtn.tag = 40000 + index;
        [allContentBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        allContentBtn.frame = CGRectMake(68, 5 + contentStatusHeight + faCommnetContent.frame.size.height + 4, 28, 20);
        allContentBtnHeight = 20 + 4;
    }
    CGFloat childrenComments = hasChildrenComments ? 0 : 16;
    faContentSection.frame = CGRectMake(0, height, HIC_ScreenWidth, 5 + contentStatusHeight + faCommnetContent.frame.size.height + allContentBtnHeight + childrenComments);
    height = height + faContentSection.frame.size.height;
#pragma mark 父评论内容section ---- end

#pragma mark 子评论内容section ---- start
    if (chContents.count > 0) {
        UIView *chContentSection = [[UIView alloc] initWithFrame:CGRectMake(0, height, HIC_ScreenWidth, 0)];
        [commentContainer addSubview:chContentSection];
        UIView *chContentBg = [[UIView alloc] initWithFrame:CGRectMake(68, 6, HIC_ScreenWidth - (68 + 16), 0)];
        [chContentSection addSubview:chContentBg];
        chContentBg.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1/1.0];
        chContentBg.layer.cornerRadius = 2;
        chContentBg.layer.masksToBounds = YES;

        CGFloat chContentsHeight = 0.0;
        CGFloat topMargin = 10;
        for (int i = 0; i < chContents.count; i ++) {
            if (i < 3) {
                UILabel *chContent = [[UILabel alloc] init];
                [chContentBg addSubview:chContent];
                NSString *strTemp = [NSString stringWithFormat:@"%@: %@", chContents[i][@"chName"], chContents[i][@"chContent"]];
                chContent.text = strTemp;
                long NameLen = [chContents[i][@"chName"] length];
                NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:strTemp];
                [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1/1.0] range:NSMakeRange(0, NameLen + 1)];//颜色
                chContent.lineBreakMode = NSLineBreakByTruncatingTail;
                chContent.numberOfLines = 2;
                chContent.textColor = [UIColor colorWithRed:21/255.0 green:21/255.0 blue:21/255.0 alpha:1/1.0];
                chContent.font =FONT_REGULAR_14;
                chContent.attributedText = str;
                CGSize chContentSize = [HICCommonUtils sizeOfString:chContent.text stringWidthBounding:HIC_ScreenWidth - (68 + 16) - 20 font:14 stringOnBtn:NO fontIsRegular:YES];
                chContent.frame = CGRectMake(10, i == 0 ? topMargin : chContentsHeight, HIC_ScreenWidth - (68 + 16) - 20, chContentSize.height);
                [chContent sizeToFit];
                chContentsHeight =  i == 0 ? topMargin : chContentsHeight;
                CGFloat lastContent = 2.5;
                if (i == chContents.count - 1) {
                    lastContent = 10;
                }
                chContentsHeight = chContentsHeight + lastContent + chContentSize.height;
            } else {
                // 查看全部评论
                UIButton *allCommentsBtn = [[UIButton alloc] init];
                [chContentBg addSubview:allCommentsBtn];
                CGSize allCommentsBtnSize = [HICCommonUtils sizeOfString:[NSString stringWithFormat:@"%@%lu%@", NSLocalizableString(@"lookAtAll", nil),(unsigned long)chContents.count,NSLocalizableString(@"articleComments", nil)] stringWidthBounding:HIC_ScreenWidth - (68 + 16) - 20 font:14 stringOnBtn:NO fontIsRegular:YES];
                [allCommentsBtn setTitle:[NSString stringWithFormat:@"%@%lu%@", NSLocalizableString(@"lookAtAll", nil),(unsigned long)chContents.count,NSLocalizableString(@"articleComments", nil)] forState:UIControlStateNormal];
                [allCommentsBtn setTitleColor:[UIColor colorWithRed:0/255.0 green:190/255.0 blue:215/255.0 alpha:1/1.0] forState:UIControlStateNormal];
                allCommentsBtn.titleLabel.font = FONT_REGULAR_14;
                allCommentsBtn.frame = CGRectMake(10, chContentsHeight, allCommentsBtnSize.width, 20);
                allCommentsBtn.tag = 50000 + index;
                [allCommentsBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
                chContentsHeight = chContentsHeight + 20 + 10;
                break;
            }
        }
        chContentBg.frame = CGRectMake(68, 6, HIC_ScreenWidth - (68 + 16), chContentsHeight);

        chContentSection.frame = CGRectMake(0, height, HIC_ScreenWidth, 6 + chContentBg.frame.size.height + 16);
        height = height + chContentSection.frame.size.height;
    }
#pragma mark 子评论内容section ---- end

    CGFloat commentContainerX = self.commentViewHeight == 0 ? 0 : self.commentViewHeight;
    self.commentViewHeight = self.commentViewHeight + height;
    commentContainer.frame = CGRectMake(0, commentContainerX, HIC_ScreenWidth, height);

}

- (void)updateViewFrame:(NSArray *)comments {
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.commentViewHeight = 0;
    self.comments = comments;
    [self createUI];
}

- (void)btnClicked:(UIButton *)btn {
    DDLogDebug(@"asdasdasds %ld", (long)btn.tag);
    if (btn.tag >= 10000 && btn.tag < 20000) {
        // 10000 + index: 删除
    } else if (btn.tag >= 20000 && btn.tag < 30000) {
        // 20000 + index: 回复
    } else if (btn.tag >= 30000 && btn.tag < 40000) {
        // 30000 + index: 点赞
    } else if (btn.tag >= 40000 && btn.tag < 50000) {
        // 40000 + index: 全文
        NSInteger index = btn.tag - 40000;
        [self.showAllContentIndexArr addObject:@(index)];
        [self updateViewFrame:self.comments];
    } else if (btn.tag >= 50000 && btn.tag < 60000) {
        // 50000 + index: 查看所有评论
    } else {

    }
}

@end
