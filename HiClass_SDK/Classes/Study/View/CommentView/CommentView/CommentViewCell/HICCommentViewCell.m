//
//  HICCommentViewCell.m
//  HiClass
//
//  Created by Eddie_Ma on 17/2/20.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICCommentViewCell.h"

#define CVCThumbupImgWidth      15.5
#define CVCThumbupImgHeight     14.5

#define CVCReplyImgWidth        15
#define CVCReplyImgHeight       15

#define CVCDeleteImgWidth       14
#define CVCDeleteImgHeight      15

@interface HICCommentViewCell()

@property (nonatomic, strong) UIView *faInfoSection; // 父用户信息区
@property (nonatomic, strong) UIImageView *faPic; // 父用户头像
@property (nonatomic, strong) UILabel *faName; // 父用户名字
@property (nonatomic, strong) UILabel *faDate; // 父用户时间
@property (nonatomic, strong) UIButton *thumbupGroups; // 点赞
@property (nonatomic, strong) UIImageView *thumbupImg;
@property (nonatomic, strong) UILabel *thumbupDes;
@property (nonatomic, strong) UIButton *replyGroups; // 回复
@property (nonatomic, strong) UIImageView *replyImg;
@property (nonatomic, strong) UILabel *replyDes;
@property (nonatomic, strong) UIButton *deleteGroups; // 删除
@property (nonatomic, strong) UIImageView *deleteImg;
@property (nonatomic, strong) UILabel *deleteDes;

@property (nonatomic, strong) UIView *faContentSection; // 父用户评论区
@property (nonatomic, strong) UILabel *contentStatus; // 待审核
@property (nonatomic, strong) UILabel *faCommnetContent; // 父评论内容
@property (nonatomic, strong) UIButton *allContentBtn; // 全文按钮

@property (nonatomic, strong) UIView *chContentSection; // 子评论区
@property (nonatomic, strong) UIView *chContentBg;

@property (nonatomic, strong) UIView *dividedLine;

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) NSInteger subIndex;
@property (nonatomic, strong) HICCommentModel *model;

@property (nonatomic, strong) UIImageView *hintIV;

@end

@implementation HICCommentViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self creatUI];
    }
    return self;
}

- (void)creatUI {
    self.backgroundColor = [UIColor whiteColor];

#pragma mark - - - 父用户信息section - - - Start
    _faInfoSection = [[UIView alloc] initWithFrame:CGRectMake(0, 0, HIC_ScreenWidth, 44 + 16)];
    [self.contentView addSubview:_faInfoSection];

    // 父用户头像
    _faPic = [[UIImageView alloc] init];
    [_faInfoSection addSubview:_faPic];
    _faPic.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1/1.0];
//    faPic.image = [UIImage imageNamed:dic[@"faPic"]];
    _faPic.layer.cornerRadius = 4;
    _faPic.layer.masksToBounds = YES;
    _faPic.frame = CGRectMake(16, 16, 44, 44);

    // 父用户名字
    _faName = [[UILabel alloc] init];
    [_faInfoSection addSubview:_faName];
//    _faName.text = dic[@"faName"];
    _faName.font = FONT_REGULAR_15;
    _faName.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1/1.0];
    _faName.frame = CGRectMake(16 + _faPic.frame.size.width + 8, 17, 90, 21);

    // 父用户时间
    _faDate = [[UILabel alloc] init];
    [_faInfoSection addSubview:_faDate];
//    faDate.text = dic[@"faDate"];
    _faDate.font = FONT_REGULAR_13;
    _faDate.textColor =  [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1/1.0];
    _faDate.frame = CGRectMake(16 + _faPic.frame.size.width + 8, 40, 120, 18.5);

    // 点赞
    _thumbupGroups = [[UIButton alloc] init];
    [_faInfoSection addSubview: _thumbupGroups];
    _thumbupGroups.tag = 10000;
    [_thumbupGroups addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    // 点赞-图片
    _thumbupImg = [[UIImageView alloc] init];
    [_thumbupGroups addSubview: _thumbupImg];
    _thumbupImg.image = [UIImage imageNamed:@"评论-icon-点赞"];
    _thumbupImg.frame = CGRectMake(0, 0, CVCThumbupImgWidth, CVCThumbupImgHeight);
    // 点赞-文字/数字
    _thumbupDes = [[UILabel alloc] init];
    [_thumbupGroups addSubview:_thumbupDes];
    _thumbupDes.font = FONT_REGULAR_13;

    // 回复
    _replyGroups = [[UIButton alloc] init];
    [_faInfoSection addSubview: _replyGroups];
    _replyGroups.tag = 20000;
    [_replyGroups addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    // 回复-图片
    _replyImg = [[UIImageView alloc] init];
    [_replyGroups addSubview: _replyImg];
    _replyImg.image = [UIImage imageNamed:@"评论-icon-回复"];
    _replyImg.frame = CGRectMake(0, 0, CVCReplyImgWidth, CVCReplyImgHeight);
    // 回复-文字/数字
    _replyDes = [[UILabel alloc] init];
    [_replyGroups addSubview:_replyDes];
    _replyDes.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1/1.0];
    _replyDes.font = FONT_REGULAR_13;

    // 删除
    _deleteGroups = [[UIButton alloc] init];
    [_faInfoSection addSubview: _deleteGroups];
    _deleteGroups.tag = 30000;
    [_deleteGroups addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    // 删除-图片
    _deleteImg = [[UIImageView alloc] init];
    [_deleteGroups addSubview: _deleteImg];
    _deleteImg.image = [UIImage imageNamed:@"评论-删除"];
    _deleteImg.frame = CGRectMake(0, 0, CVCDeleteImgWidth, CVCDeleteImgHeight);
    // 删除-文字
    _deleteDes = [[UILabel alloc] init];
    [_deleteGroups addSubview:_deleteDes];
    _deleteDes.text = NSLocalizableString(@"delete", nil);
    _deleteDes.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1/1.0];
    _deleteDes.font = FONT_REGULAR_13;
#pragma mark - - - 父用户信息section - - - End

#pragma mark - - - 父评论内容section - - - Start
    _faContentSection = [[UIView alloc] initWithFrame:CGRectMake(0, _faInfoSection.frame.size.height, HIC_ScreenWidth, 0)];
    [self.contentView addSubview:_faContentSection];

    // 待审核
    _contentStatus = [[UILabel alloc] init];
    [_faContentSection addSubview: _contentStatus];
//    _contentStatus.text = @"待审核";
    _contentStatus.font = FONT_MEDIUM_12;
    _contentStatus.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1/1.0];
    _contentStatus.backgroundColor = [UIColor colorWithRed:185/255.0 green:185/255.0 blue:185/255.0 alpha:1/1.0];
    _contentStatus.layer.cornerRadius = 1.5;
    _contentStatus.textAlignment = NSTextAlignmentCenter;
    _contentStatus.layer.masksToBounds = YES;
    _contentStatus.frame = CGRectMake(68, 10.5, 42, 18);

    // 父评论内容
    _faCommnetContent = [[UILabel alloc] init];
    [_faContentSection addSubview: _faCommnetContent];
//    faCommnetContent.text = dic[@"faContent"];
    _faCommnetContent.font = FONT_REGULAR_15;
    _faCommnetContent.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    _faCommnetContent.numberOfLines = 4;

    // 全文按钮
    _allContentBtn = [[UIButton alloc] init];
    [_faContentSection addSubview:_allContentBtn];
    [_allContentBtn setTitle:NSLocalizableString(@"fullText", nil) forState:UIControlStateNormal];
    [_allContentBtn setTitleColor:[UIColor colorWithRed:0/255.0 green:190/255.0 blue:215/255.0 alpha:1/1.0] forState:UIControlStateNormal];
    _allContentBtn.titleLabel.font = FONT_REGULAR_14;
    _allContentBtn.tag = 40000;
    [_allContentBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];

#pragma mark - - - 父评论内容section - - - End

#pragma mark - - - 子评论内容section - - - Start
    _chContentSection = [[UIView alloc] init];
    [self.contentView addSubview:_chContentSection];
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(event:)];
    [tapGesture setNumberOfTapsRequired:1];
    [_chContentSection addGestureRecognizer:tapGesture];

    _chContentBg = [[UIView alloc] initWithFrame:CGRectMake(68, 6, HIC_ScreenWidth - (68 + 16), 0)];
    [_chContentSection addSubview:_chContentBg];
    _chContentBg.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1/1.0];
    _chContentBg.layer.cornerRadius = 2;
    _chContentBg.layer.masksToBounds = YES;
#pragma mark - - - 子评论内容section - - - End

    _dividedLine = [[UIView alloc] init];
    [self.contentView addSubview:_dividedLine];
    _dividedLine.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1/1.0];
}

- (void)setData:(HICCommentModel *)model index:(NSInteger)index {
    self.index = index;
    self.model = model;
    if ([NSString isValidStr:model.userpictureurl]) {
        [_faPic sd_setImageWithURL:[NSURL URLWithString:model.userpictureurl]];
    } else {
        UILabel *label = [HICCommonUtils setHeaderFrame:_faPic.bounds andText:model.username];
        label.hidden = NO;
        [_faPic addSubview:label];
    }

    _faName.text = model.username;
    _faDate.text = [HICCommonUtils timeStampToReadableDate:model.commenttime isSecs:NO format:@"yyyy-MM-dd HH:mm"];
    if ([model.upnum integerValue] == 0) {
        _thumbupImg.image = [UIImage imageNamed:@"评论-icon-点赞"];
        _thumbupDes.text = NSLocalizableString(@"giveLike", nil);
        _thumbupDes.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1/1.0];
    } else {
        _thumbupImg.image = [model.upflag integerValue] == 0 ? [UIImage imageNamed:@"评论-icon-点赞"] : [UIImage imageNamed:@"评论-icon-已点赞"];
        _thumbupDes.text = [NSString stringWithFormat:@"%@",model.upnum];
        _thumbupDes.textColor = [model.upflag integerValue] == 0 ? [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1/1.0] : [UIColor colorWithRed:255/255.0 green:133/255.0 blue:0/255.0 alpha:1/1.0];
    }
    CGSize thumbupDesSize = [HICCommonUtils sizeOfString:_thumbupDes.text stringWidthBounding:HIC_ScreenWidth font:13 stringOnBtn:NO fontIsRegular:YES];
    _thumbupDes.frame = CGRectMake(CVCThumbupImgWidth + 4.5, 0, thumbupDesSize.width, thumbupDesSize.height);
    _thumbupImg.frame = CGRectMake(0, (_thumbupDes.frame.size.height - CVCThumbupImgHeight)/2, CVCThumbupImgWidth, CVCThumbupImgHeight);
    _thumbupGroups.frame = CGRectMake(HIC_ScreenWidth - 16 - (_thumbupImg.frame.size.width + 4.5 + _thumbupDes.frame.size.width), 18, _thumbupImg.frame.size.width + 4.5 + _thumbupDes.frame.size.width, _thumbupDes.frame.size.height);

    if ([model.replynum integerValue] == 0) {
        _replyDes.text = NSLocalizableString(@"reply", nil);
    } else {
        _replyDes.text = [NSString stringWithFormat:@"%@",model.replynum];
    }
    CGSize replyDesSize = [HICCommonUtils sizeOfString:_replyDes.text stringWidthBounding:HIC_ScreenWidth font:13 stringOnBtn:NO fontIsRegular:YES];
    _replyDes.frame = CGRectMake(CVCReplyImgWidth + 4.5, 0, replyDesSize.width, replyDesSize.height);
    _replyImg.frame = CGRectMake(0, (_replyDes.frame.size.height - CVCReplyImgHeight)/2, CVCReplyImgWidth, CVCReplyImgHeight);
    _replyGroups.frame = CGRectMake(HIC_ScreenWidth - 16 - _thumbupGroups.frame.size.width - (_replyImg.frame.size.width + 4.5 + _replyDes.frame.size.width) - 14, 18, _replyImg.frame.size.width + 4.5 + _replyDes.frame.size.width, _replyDes.frame.size.height);

    if (model.isCurrentUser) {
        _deleteGroups.hidden = NO;
        CGSize deleteDesSize = [HICCommonUtils sizeOfString:_deleteDes.text stringWidthBounding:HIC_ScreenWidth font:13 stringOnBtn:NO fontIsRegular:YES];
        _deleteDes.frame = CGRectMake(CVCDeleteImgWidth + 4.5, 0, deleteDesSize.width, deleteDesSize.height);
        _deleteImg.frame = CGRectMake(0, (_deleteDes.frame.size.height - CVCDeleteImgHeight)/2, CVCDeleteImgWidth, CVCDeleteImgHeight);
        _deleteGroups.frame = CGRectMake(HIC_ScreenWidth - 16 - _thumbupGroups.frame.size.width -  _replyGroups.frame.size.width - (_deleteImg.frame.size.width + 4.5 + _deleteDes.frame.size.width) - 2 * 14, 18, _deleteImg.frame.size.width + 4.5 + _deleteDes.frame.size.width, _deleteDes.frame.size.height);
    } else {
        _deleteGroups.hidden = YES;
    }

    CGFloat contentStatusHeight = 0.0;
    // 待审核
    if (model.commentstatus && [model.commentstatus integerValue] == 0) {
        _contentStatus.hidden = NO;
        _contentStatus.text = NSLocalizableString(@"waitAudit", nil);
        contentStatusHeight = 10.5 + 18 + 4;
    } else {
        _contentStatus.hidden = YES;
        contentStatusHeight = 10.5;
    }

    _faCommnetContent.text = model.comment;
    _faCommnetContent.numberOfLines = model.showFullComment ? 0 : 4;
    CGSize faCommnetContentSize = [HICCommonUtils sizeOfString:_faCommnetContent.text stringWidthBounding:HIC_ScreenWidth - 68 - 16 font:15 stringOnBtn:NO fontIsRegular:YES];
    _faCommnetContent.frame = CGRectMake(68, contentStatusHeight, HIC_ScreenWidth - 68 - 16, faCommnetContentSize.height);
    [_faCommnetContent sizeToFit];
    NSArray *faCommnetContentLines = [HICCommonUtils getLinesArrayOfStringInLabel:_faCommnetContent];
    CGFloat allContentBtnHeight = 0.0;
    if (faCommnetContentLines.count > 4 && !model.showFullComment) {
        // 全文按钮
        _allContentBtn.hidden = NO;
        _allContentBtn.tag = 40000;
        _allContentBtn.frame = CGRectMake(68, contentStatusHeight + _faCommnetContent.frame.size.height + 4, 28, 20);
        allContentBtnHeight = 4 + _allContentBtn.frame.size.height + 4;
    } else {
        _allContentBtn.hidden = YES;
    }
    _faContentSection.frame = CGRectMake(0, _faInfoSection.frame.size.height, HIC_ScreenWidth, contentStatusHeight + _faCommnetContent.frame.size.height + allContentBtnHeight);

    // 创建子评论
    if (model.replies.count > 0) {
        _chContentBg.hidden = NO;
        [_chContentBg.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        CGFloat chContentsHeight = 0.0;
        CGFloat topMargin = 10;
        for (int i = 0; i < model.replies.count; i ++) {
            HICCommentModel *smodel = model.replies[i];
            if (i < 3) {
                UILabel *chContent = [[UILabel alloc] init];
                [_chContentBg addSubview:chContent];
                chContent.tag = i;
                if (smodel.isCurrentUser) {
                    chContent.userInteractionEnabled = YES;
                    UILongPressGestureRecognizer *labelLongPressGestureRecognizer = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(labelLongPress:)];
                    labelLongPressGestureRecognizer.minimumPressDuration = 1.0;
                    [chContent addGestureRecognizer:labelLongPressGestureRecognizer];
                }
                NSString *strTemp = [NSString stringWithFormat:@"%@: %@", smodel.username, smodel.comment];
                chContent.text = strTemp;
                long NameLen = [smodel.username length];
                NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:strTemp];
                [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1/1.0] range:NSMakeRange(0, NameLen + 1)];//颜色
                chContent.lineBreakMode = NSLineBreakByTruncatingTail;
                chContent.numberOfLines = 2;
                chContent.textColor = [UIColor colorWithRed:21/255.0 green:21/255.0 blue:21/255.0 alpha:1/1.0];
                chContent.font = FONT_REGULAR_14;
                chContent.attributedText = str;
                CGSize chContentSize = [HICCommonUtils sizeOfString:chContent.text stringWidthBounding:HIC_ScreenWidth - (68 + 16) - 20 font:14 stringOnBtn:NO fontIsRegular:YES];
                chContent.frame = CGRectMake(10, i == 0 ? topMargin : chContentsHeight, HIC_ScreenWidth - (68 + 16) - 20, chContentSize.height);
                [chContent sizeToFit];

                chContentsHeight =  i == 0 ? topMargin : chContentsHeight;
                CGFloat lastContent = 2.5;
                if (i == model.replies.count - 1) {
                    lastContent = 10;
                }
                chContentsHeight = chContentsHeight + lastContent + chContent.frame.size.height;
            } else {}
        }
        if ([model.totalReplies integerValue] > 3) {
            // 查看全部评论
            UIButton *allCommentsBtn = [[UIButton alloc] init];
            [_chContentBg addSubview:allCommentsBtn];
            CGSize allCommentsBtnSize = [HICCommonUtils sizeOfString:[NSString stringWithFormat:@"%@%ld%@", NSLocalizableString(@"lookAtAll", nil),(long)[model.totalReplies integerValue],NSLocalizableString(@"articleComments", nil)] stringWidthBounding:HIC_ScreenWidth - (68 + 16) - 20 font:14 stringOnBtn:NO fontIsRegular:YES];
            [allCommentsBtn setTitle:[NSString stringWithFormat:@"%@%ld%@", NSLocalizableString(@"lookAtAll", nil),(long)[model.totalReplies integerValue],NSLocalizableString(@"articleComments", nil)] forState:UIControlStateNormal];
            [allCommentsBtn setTitleColor:[UIColor colorWithRed:0/255.0 green:190/255.0 blue:215/255.0 alpha:1/1.0] forState:UIControlStateNormal];
            allCommentsBtn.titleLabel.font = FONT_REGULAR_14;
            allCommentsBtn.frame = CGRectMake(10, chContentsHeight, allCommentsBtnSize.width, 20);
            allCommentsBtn.tag = 50000;
            [allCommentsBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
            chContentsHeight = chContentsHeight + 20 + 10;
        }
        _chContentBg.frame = CGRectMake(68, 6, HIC_ScreenWidth - (68 + 16), chContentsHeight);
//        [HICCommonUtils setRoundingCornersWithView:_chContentBg TopLeft:YES TopRight:YES bottomLeft:YES bottomRight:YES cornerRadius:2];
        _chContentSection.frame = CGRectMake(0, _faInfoSection.frame.size.height + _faContentSection.frame.size.height, HIC_ScreenWidth, 6 + _chContentBg.frame.size.height + 16);
    } else {
        _chContentBg.hidden = YES;
        [_chContentBg.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        _chContentSection.frame = CGRectMake(0, _faInfoSection.frame.size.height + _faContentSection.frame.size.height, HIC_ScreenWidth, 16);
    }

    _dividedLine.frame = CGRectMake(68, _faInfoSection.frame.size.height + _faContentSection.frame.size.height + _chContentSection.frame.size.height - 0.5, HIC_ScreenWidth - 68, 0.5);
}

- (void)btnClicked:(UIButton *)btn {
    if (btn.tag == 10000) {
        // 点赞
        if ([self.delegate respondsToSelector:@selector(commentThumbUp:)]) {
            [self.delegate commentThumbUp:_index];
        }
    } else if (btn.tag == 20000) {
        // 回复
        if ([self.delegate respondsToSelector:@selector(commentReply:)]) {
            [self.delegate commentReply:_index];
        }
    } else if (btn.tag == 30000) {
        // 删除
        if ([self.delegate respondsToSelector:@selector(commentDelete:)]) {
            [self.delegate commentDelete:_index];
        }
    } else if (btn.tag == 40000) {
        // 全文
        if ([self.delegate respondsToSelector:@selector(seeFullComments:)]) {
            [self.delegate seeFullComments:_index];
        }
    } else if (btn.tag == 50000) {
        // 查看全部子评论
        if ([self.delegate respondsToSelector:@selector(seeAllSubComments:)]) {
            [self.delegate seeAllSubComments:_index];
        }
    } else if (btn.tag == 60000) {
        // 删除回复
        if ([self.delegate respondsToSelector:@selector(commentDelete:subIndex:)]) {
            [self.delegate commentDelete:_index subIndex:_subIndex];
            [_hintIV removeFromSuperview];
            _hintIV = nil;
        }
    }
}

- (void)event:(UITapGestureRecognizer *)gesture {
    if (_hintIV) {
        [_hintIV removeFromSuperview];
    }
 }

- (void)labelLongPress:(UILongPressGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        UILabel *subCommnentLabel = (UILabel*)recognizer.view;
        CGFloat subItemsHeight = 6 + 10;
        NSInteger stopAt = subCommnentLabel.tag;
        self.subIndex = stopAt;
        for (int i = 0; i < _model.replies.count; i++) {
            if (i < stopAt) {
                HICCommentModel *smodel = _model.replies[i];
                NSString *chCommentStr = [NSString stringWithFormat:@"%@: %@", smodel.username, smodel.comment];
                UILabel *label = [[UILabel alloc] init];
                label.text = chCommentStr;
                label.font = FONT_REGULAR_14;
                label.numberOfLines = 2;
                CGFloat labelHeight = [HICCommonUtils sizeOfString:chCommentStr stringWidthBounding:HIC_ScreenWidth - 26 - 78 font:14 stringOnBtn:NO fontIsRegular:YES].height;
                label.frame = CGRectMake(0, 0, HIC_ScreenWidth - 26 - 78, labelHeight);
                [label sizeToFit];
                subItemsHeight = subItemsHeight + label.frame.size.height;
            }
        }
        subItemsHeight = subItemsHeight + 2.5 * stopAt;

        self.hintIV = [[UIImageView alloc] init];
        [self.contentView addSubview:_hintIV];
        _hintIV.userInteractionEnabled = YES;
        _hintIV.image = [UIImage imageNamed:@"长按删除-背景"];
        _hintIV.frame = CGRectMake(_chContentBg.frame.origin.x + 30, _faInfoSection.frame.size.height + _faContentSection.frame.size.height + subItemsHeight - 40, 52, 40);

        UIButton *hintDeleteBtn = [[UIButton alloc] init];
        [_hintIV addSubview:hintDeleteBtn];
        [hintDeleteBtn setTitle:NSLocalizableString(@"delete", nil) forState:UIControlStateNormal];
        hintDeleteBtn.tag = 60000;
        hintDeleteBtn.titleLabel.font = FONT_REGULAR_15;
        [hintDeleteBtn setTintColor:[UIColor whiteColor]];
        hintDeleteBtn.frame = CGRectMake(0, 0, 52, 31);
        [hintDeleteBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
}

@end
