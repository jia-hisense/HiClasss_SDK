//
//  HICAllReplyTableViewCell.m
//  HiClass
//
//  Created by Eddie Ma on 2020/2/10.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICAllReplyTableViewCell.h"

#define thumbupImgWidth    15.5
#define thumbupImgHeight   14.5

#define replyImgWidth  15
#define replyImgHeight  15

#define deleteImgWidth  14
#define deleteImgHeight  15

@interface HICAllReplyTableViewCell ()
@property (nonatomic, strong) UIImageView *faPic;
@property (nonatomic, strong) UILabel *faName;
@property (nonatomic, strong) UILabel *faDate;
@property (nonatomic, strong) UILabel *comment;
@property (nonatomic, strong) UIView *dividedView;
// 点赞view集
@property (nonatomic, strong) UIButton *thumbupGroups;
@property (nonatomic, strong) UIImageView *thumbupImg;
@property (nonatomic, strong) UILabel *thumbupDes;
// 回复view集
@property (nonatomic, strong) UIButton *replyGroups;
@property (nonatomic, strong) UIImageView *replyImg;
@property (nonatomic, strong) UILabel *replyDes;
// 删除view集
@property (nonatomic, strong) UIButton *deleteGroups;
@property (nonatomic, strong) UIImageView *deleteImg;
@property (nonatomic, strong) UILabel *deleteDes;

@property (nonatomic, assign) NSInteger index;
@end

@implementation HICAllReplyTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self creatUI];
    }
    return self;
}

- (void)creatUI {
    self.backgroundColor = [UIColor whiteColor];

    // 父用户头像
    _faPic = [[UIImageView alloc] init];
    [self.contentView addSubview:_faPic];
    _faPic.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1/1.0];
    _faPic.layer.cornerRadius = 4;
    _faPic.layer.masksToBounds = YES;
    _faPic.frame = CGRectMake(16, 16, 44, 44);

    // 父用户名字
    _faName = [[UILabel alloc] init];
    [self.contentView addSubview:_faName];
    _faName.font = FONT_REGULAR_15;
    _faName.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1/1.0];
    _faName.frame = CGRectMake(16 + _faPic.frame.size.width + 8, 17, 90, 21);

    // 父用户时间
    _faDate = [[UILabel alloc] init];
    [self.contentView addSubview:_faDate];
    _faDate.font = FONT_REGULAR_13;
    _faDate.textColor =  [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1/1.0];
    _faDate.frame = CGRectMake(16 + _faPic.frame.size.width + 8, 40, 120, 18.5);

    // 评论内容
    _comment = [[UILabel alloc] init];
    [self.contentView addSubview:_comment];
    _comment.font = FONT_REGULAR_15;
    _comment.numberOfLines = 0;
    _comment.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];

    _dividedView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 20)];
    [self.contentView addSubview: _dividedView];
    _dividedView.hidden = YES;
    UIView *dividedLine = [[UIView alloc] initWithFrame:CGRectMake(20, (_dividedView.frame.size.height - 0.5)/2, HIC_ScreenWidth - 20 * 2, 0.5)];
    [_dividedView addSubview:dividedLine];
    dividedLine.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1/1.0];
    UILabel *allRepliesLabel = [[UILabel alloc] init];
    [_dividedView addSubview:allRepliesLabel];
    allRepliesLabel.font = FONT_REGULAR_14;
    allRepliesLabel.text = NSLocalizableString(@"replyAll", nil);
    allRepliesLabel.textAlignment = NSTextAlignmentCenter;
    allRepliesLabel.textColor = [UIColor colorWithRed:133/255.0 green:133/255.0 blue:133/255.0 alpha:1/1.0];
    allRepliesLabel.frame = CGRectMake((HIC_ScreenWidth - 80)/2, 0, 80, _dividedView.frame.size.height);
    allRepliesLabel.backgroundColor = [UIColor whiteColor];

    // 点赞
    _thumbupGroups = [[UIButton alloc] init];
    [self.contentView addSubview: _thumbupGroups];
    _thumbupGroups.hidden = YES;
    _thumbupGroups.tag = 10000;
    [_thumbupGroups addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    // 点赞-图片
    _thumbupImg = [[UIImageView alloc] init];
    [_thumbupGroups addSubview: _thumbupImg];
    _thumbupImg.image = [UIImage imageNamed:@"icon-点赞总数"];
    _thumbupImg.frame = CGRectMake(0, 0, thumbupImgWidth, thumbupImgHeight);
    // 点赞-文字/数字
    _thumbupDes = [[UILabel alloc] init];
    [_thumbupGroups addSubview:_thumbupDes];
    _thumbupDes.font = FONT_REGULAR_13;

    // 回复
    _replyGroups = [[UIButton alloc] init];
    [self.contentView addSubview: _replyGroups];
    _replyGroups.hidden = YES;
    _replyGroups.tag = 20000;
    [_replyGroups addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    // 回复-图片
    _replyImg = [[UIImageView alloc] init];
    [_replyGroups addSubview: _replyImg];
    _replyImg.image = [UIImage imageNamed:@"评论-icon-回复"];
    _replyImg.frame = CGRectMake(0, 0, replyImgWidth, replyImgHeight);
    // 回复-文字/数字
    _replyDes = [[UILabel alloc] init];
    [_replyGroups addSubview:_replyDes];
    _replyDes.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1/1.0];
    _replyDes.font = FONT_REGULAR_13;

    // 删除
    _deleteGroups = [[UIButton alloc] init];
    [self.contentView addSubview: _deleteGroups];
    _deleteGroups.hidden = YES;
    _deleteGroups.tag = 30000;
    [_deleteGroups addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    // 删除-图片
    _deleteImg = [[UIImageView alloc] init];
    [_deleteGroups addSubview: _deleteImg];
    _deleteImg.image = [UIImage imageNamed:@"评论-删除"];
    _deleteImg.frame = CGRectMake(0, 0, deleteImgWidth, deleteImgHeight);
    // 删除-文字
    _deleteDes = [[UILabel alloc] init];
    [_deleteGroups addSubview:_deleteDes];
    _deleteDes.text = NSLocalizableString(@"delete", nil);
    _deleteDes.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1/1.0];
    _deleteDes.font = FONT_REGULAR_13;

}

- (void)setData:(HICCommentModel *)model index:(NSInteger)index {
    self.index = index;

    if ([NSString isValidStr:model.userpictureurl]) {
        [_faPic sd_setImageWithURL:[NSURL URLWithString:model.userpictureurl]];
    } else {
        UILabel *label = [HICCommonUtils setHeaderFrame:_faPic.bounds andText:model.username];
        label.hidden = NO;
        [_faPic addSubview:label];
    }

    _faName.text = model.username;

    _faDate.text = [HICCommonUtils timeStampToReadableDate:model.commenttime isSecs:NO format:@"yyyy-MM-dd HH:mm"];

    _comment.text = model.comment;
    CGFloat labelHeight = [HICCommonUtils sizeOfString:model.comment stringWidthBounding:HIC_ScreenWidth - 16 - 68 font:15 stringOnBtn:NO fontIsRegular:YES].height;
    _comment.frame = CGRectMake(68, 16 + 44 + 10.5, HIC_ScreenWidth - 16 - 68, labelHeight);
    [_comment sizeToFit];

    if (index == 0) {
        _dividedView.hidden = NO;
        _dividedView.frame = CGRectMake(0, 16 + 44 + 10.5 + labelHeight + 16, HIC_ScreenWidth, _dividedView.frame.size.height);
    } else {
         _dividedView.hidden = YES;
    }

    // 点赞
    if ([model.upnum integerValue] == 0) {
        _thumbupDes.text = NSLocalizableString(@"giveLike", nil);
        _thumbupDes.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1/1.0];
    } else {
        _thumbupImg.image = [UIImage imageNamed:@"评论-icon-已点赞"];
        _thumbupDes.text = [NSString stringWithFormat:@"%@", model.upnum];
        _thumbupDes.textColor = [UIColor colorWithRed:255/255.0 green:133/255.0 blue:0/255.0 alpha:1/1.0];
    }
    CGSize thumbupDesSize = [HICCommonUtils sizeOfString:_thumbupDes.text stringWidthBounding:HIC_ScreenWidth font:13 stringOnBtn:NO fontIsRegular:YES];
    _thumbupDes.frame = CGRectMake(thumbupImgWidth + 4.5, 0, thumbupDesSize.width, thumbupDesSize.height);
    _thumbupImg.frame = CGRectMake(0, (_thumbupDes.frame.size.height - thumbupImgHeight)/2, thumbupImgWidth, thumbupImgHeight);
    _thumbupGroups.frame = CGRectMake(HIC_ScreenWidth - 16 - (_thumbupImg.frame.size.width + 4.5 + _thumbupDes.frame.size.width), 18, _thumbupImg.frame.size.width + 4.5 + _thumbupDes.frame.size.width, _thumbupDes.frame.size.height);

    // 回复
    if ([model.replynum integerValue] == 0) {
        _replyDes.text = NSLocalizableString(@"reply", nil);
    } else {
        _replyDes.text = [NSString stringWithFormat:@"%@",model.replynum];
    }
    CGSize replyDesSize = [HICCommonUtils sizeOfString:_replyDes.text stringWidthBounding:HIC_ScreenWidth font:13 stringOnBtn:NO fontIsRegular:YES];
    _replyDes.frame = CGRectMake(replyImgWidth + 4.5, 0, replyDesSize.width, replyDesSize.height);
    _replyImg.frame = CGRectMake(0, (_replyDes.frame.size.height - replyImgHeight)/2, replyImgWidth, replyImgHeight);
    _replyGroups.frame = CGRectMake(HIC_ScreenWidth - 16 - _thumbupGroups.frame.size.width - (_replyImg.frame.size.width + 4.5 + _replyDes.frame.size.width) - 14, 18, _replyImg.frame.size.width + 4.5 + _replyDes.frame.size.width, _replyDes.frame.size.height);

    // 删除
    CGSize deleteDesSize = [HICCommonUtils sizeOfString:_deleteDes.text stringWidthBounding:HIC_ScreenWidth font:13 stringOnBtn:NO fontIsRegular:YES];
    _deleteDes.frame = CGRectMake(deleteImgWidth + 4.5, 0, deleteDesSize.width, deleteDesSize.height);
    _deleteImg.frame = CGRectMake(0, (_deleteDes.frame.size.height - deleteImgHeight)/2, deleteImgWidth, deleteImgHeight);
    if (index == 0) {
        _thumbupGroups.hidden = NO;
        _replyGroups.hidden = NO;
        if (model.isCurrentUser) {
            _deleteGroups.hidden = NO;
            _deleteGroups.frame = CGRectMake(HIC_ScreenWidth - 16 - _thumbupGroups.frame.size.width -  _replyGroups.frame.size.width - (_deleteImg.frame.size.width + 4.5 + _deleteDes.frame.size.width) - 2 * 14, 18, _deleteImg.frame.size.width + 4.5 + _deleteDes.frame.size.width, _deleteDes.frame.size.height);
        } else {
            _deleteGroups.hidden = YES;
        }
    } else {
        _thumbupGroups.hidden = YES;
        _replyGroups.hidden = YES;
        if (model.isCurrentUser) {
            _deleteGroups.hidden = NO;
            _deleteGroups.frame = CGRectMake(HIC_ScreenWidth - 16 - (_deleteImg.frame.size.width + 4.5 + _deleteDes.frame.size.width), 18, _deleteImg.frame.size.width + 4.5 + _deleteDes.frame.size.width, _deleteDes.frame.size.height);
        } else {
            _deleteGroups.hidden = YES;
        }
    }
}

- (void)btnClicked:(UIButton *)btn {
    HICCommentActions action;
    BOOL cancelThumbupBtn = NO;
    if (btn.tag == 10000) {
        // 点赞按钮
        action = HICThumbupAction;
        if (btn.isSelected) {
            // 取消收藏
            cancelThumbupBtn = YES;
            btn.selected = NO;
        } else {
            btn.selected = YES;
        }
    } else if (btn.tag == 20000) {
        // 回复按钮
        action = HICReplyAction;
    } else {
        // 删除按钮
        action = HICDeleteAction;
    }
    if ([self.delegate respondsToSelector:@selector(commentActionBtnClicked:index:cancelThumbupBtn:)]) {
        [self.delegate commentActionBtnClicked:action index:self.index cancelThumbupBtn:cancelThumbupBtn];
    }
}

@end
