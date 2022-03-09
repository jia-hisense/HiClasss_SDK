//
//  HICCheckNoteCell.m
//  HiClass
//
//  Created by Eddie Ma on 2020/2/11.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICCheckNoteCell.h"
#import "HICCheckNoteMoreView.h"

@interface HICCheckNoteCell()<HICCheckNoteMoreViewDelegate>

@property (nonatomic, strong) UILabel *noteTime;
@property (nonatomic, strong) UILabel *noteTag;
@property (nonatomic, strong) UILabel *noteContent;
@property (nonatomic, strong) UIButton *noteMoteBtn;
@property (nonatomic, strong) UILabel *noteMore;
@property (nonatomic, strong) UIImageView *noteMoreImg;
@property (nonatomic, strong) UIView *tagView;
@property (nonatomic, strong) UIView *dividedLine;
@property (nonatomic, strong) HICCheckNoteMoreView *chechNoteMoreView;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) BOOL chechNoteMoreViewShow;
@end

@implementation HICCheckNoteCell

- (HICCheckNoteMoreView *)chechNoteMoreView {
    if (!_chechNoteMoreView) {
        NSArray *viewTitles = @[NSLocalizableString(@"copy", nil), NSLocalizableString(@"delete", nil), NSLocalizableString(@"asImportant", nil)];
        _chechNoteMoreView = [[HICCheckNoteMoreView alloc] initWithFrame:CGRectMake(HIC_ScreenWidth - 113 - 16, 44, 113, 150) titles:viewTitles]; // 150
        _chechNoteMoreView.delegate = self;
        _chechNoteMoreView.hidden = NO;
    }
    return _chechNoteMoreView;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    if (view == nil && _chechNoteMoreViewShow) {
        for (UIButton *btn in _chechNoteMoreView.subviews) {
            // 转换坐标系
            CGPoint newPoint = [btn convertPoint:point fromView:self];
            // 判断触摸点是否在button上
            if (CGRectContainsPoint(btn.bounds, newPoint)) {
                return btn;
            }
        }
    }
    return view;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self creatUI];
    }
    return self;
}

- (void)creatUI {
    self.backgroundColor = [UIColor whiteColor];

    _noteTime = [[UILabel alloc] init];
    [self.contentView addSubview: _noteTime];
    _noteTime.font = FONT_REGULAR_14;
    _noteTime.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1/1.0];

    _noteTag = [[UILabel alloc] init];
    [self.contentView addSubview: _noteTag];
    _noteTag.hidden = YES;
    _noteTag.font = FONT_REGULAR_14;
    _noteTag.textColor = [UIColor whiteColor];

    _noteContent = [[UILabel alloc] init];
    [self.contentView addSubview: _noteContent];
    _noteContent.font = FONT_REGULAR_15;
    _noteContent.numberOfLines = 0;
    _noteContent.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];

    _dividedLine = [[UIView alloc] init];
    [self.contentView addSubview: _dividedLine];
    _dividedLine.hidden = YES;
    _dividedLine.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1/1.0];

    _tagView = [[UIView alloc] init];
    [self.contentView addSubview:_tagView];
    _tagView.hidden = YES;

    _noteMoteBtn = [[UIButton alloc] init];
    [self.contentView addSubview:_noteMoteBtn];
    _noteMoteBtn.tag = 10000;
    [_noteMoteBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];

    _noteMore = [[UILabel alloc] init];
    [_noteMoteBtn addSubview:_noteMore];
    _noteMore.frame = CGRectMake(0, 0, 56, 20);
    _noteMore.text = NSLocalizableString(@"moreOperations", nil);
    _noteMore.font = FONT_REGULAR_14;
    _noteMore.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1/1.0];

    _noteMoreImg = [[UIImageView alloc] init];
    [_noteMoteBtn addSubview:_noteMoreImg];
    _noteMoreImg.frame = CGRectMake(_noteMore.frame.size.width + 6, (_noteMore.frame.size.height - 11.5)/2, 4.5, 11.5);
    _noteMoreImg.image = [UIImage imageNamed:@"笔记-更多操作icon"];

    _noteMoteBtn.frame = CGRectMake(HIC_ScreenWidth - ((_noteMore.frame.size.width + 6 + _noteMoreImg.frame.size.width) + 18), 16, _noteMore.frame.size.width + 6 + _noteMoreImg.frame.size.width, _noteMore.frame.size.height);
}

- (void)setData:(HICCheckNoteModel *)model index:(NSInteger)index isLastOne:(BOOL)isLast moreBtnCanEdit:(BOOL)can eachMoteBtnCanEdit:(BOOL)eachMoteBtnCanEdit {
    self.index = index;

    if ([model.noteMajorFlag intValue] == 1) {
        _chechNoteMoreView.viewTitles = @[NSLocalizableString(@"copy", nil), NSLocalizableString(@"delete", nil), NSLocalizableString(@"cancelImportant", nil)];
    } else {
        _chechNoteMoreView.viewTitles = @[NSLocalizableString(@"copy", nil), NSLocalizableString(@"delete", nil), NSLocalizableString(@"asImportant", nil)];
    }

    _noteTime.text = [HICCommonUtils timeStampToReadableDate:model.noteTime isSecs:YES format:@"yyyy-MM-dd HH:mm"];
    CGFloat noteTimeWidth = [HICCommonUtils sizeOfString:_noteTime.text stringWidthBounding:HIC_ScreenWidth font:14 stringOnBtn:NO fontIsRegular:YES].width;
    _noteTime.frame = CGRectMake(16, 16, noteTimeWidth, 20);

    if ([NSString isValidStr:model.noteTag]) {
        _tagView.hidden = NO;
        CGFloat tagViewWidth = [HICCommonUtils sizeOfString:model.noteTag stringWidthBounding:HIC_ScreenWidth font:12 stringOnBtn:NO fontIsRegular:NO].width;
        _tagView.frame = CGRectMake(16, 16 + 20 + 10, tagViewWidth + 6, 16);
        _tagView.layer.masksToBounds = YES;
        _tagView.layer.cornerRadius = 2;
        _tagView.tag = 1000;
        [HICCommonUtils createGradientLayerWithLabel:_tagView fromColor:[UIColor colorWithHexString:@"FF8E6F" alpha:1.0f] toColor:[UIColor colorWithHexString:@"FF553C" alpha:1.0f]];

        UILabel *tagLabel = [[UILabel alloc] init];
        tagLabel.font = FONT_MEDIUM_12;
        tagLabel.textAlignment = NSTextAlignmentCenter;
        tagLabel.frame = CGRectMake(0, 0, _tagView.frame.size.width, _tagView.frame.size.height);
        tagLabel.backgroundColor = [UIColor clearColor];
        tagLabel.layer.masksToBounds = YES;
        tagLabel.layer.cornerRadius = 2;
        tagLabel.tag = 1000;
        tagLabel.text = model.noteTag;
        tagLabel.textColor = [UIColor whiteColor];
        [_tagView addSubview:tagLabel];
    } else {
        _tagView.hidden = YES;
    }

    CGFloat tagHeight = 12;
    if ([NSString isValidStr:model.noteTag]) {
        tagHeight = 10 + 16 + 6;
    }

    _noteContent.text = model.noteContent;
    CGFloat noteContentHeight = [HICCommonUtils sizeOfString:_noteContent.text stringWidthBounding:HIC_ScreenWidth - 2 * 16 font:15 stringOnBtn:NO fontIsRegular:YES].height;
    _noteContent.frame = CGRectMake(16, 16 + 20 + tagHeight, HIC_ScreenWidth - 2 * 16, noteContentHeight);
    [_noteContent sizeToFit];

    _dividedLine.frame = CGRectMake(16, 16 + 20 + tagHeight + noteContentHeight + 15.5, HIC_ScreenWidth - 2 * 16, 0.5);
    if (isLast) {
        _dividedLine.hidden = YES;
    } else {
        _dividedLine.hidden = NO;
    }

    if (can) {
        _noteMoteBtn.userInteractionEnabled = YES;
        if (eachMoteBtnCanEdit) {
            _chechNoteMoreViewShow = NO;
            [_chechNoteMoreView removeFromSuperview];
        } else {
            if (!_chechNoteMoreViewShow) {
                _chechNoteMoreViewShow = YES;
                [self.contentView addSubview:self.chechNoteMoreView];
            }
        }
    } else {
        _noteMoteBtn.userInteractionEnabled = NO;
        _chechNoteMoreViewShow = NO;
        [_chechNoteMoreView removeFromSuperview];
    }

}

- (void)btnClicked:(UIButton *)btn {
    if (btn.tag == 10000) {
       if (!_chechNoteMoreViewShow) {
            _chechNoteMoreViewShow = YES;
           [self.contentView addSubview:self.chechNoteMoreView];
        } else {
            _chechNoteMoreViewShow = NO;
            [_chechNoteMoreView removeFromSuperview];
        }
        if ([self.delegate respondsToSelector:@selector(showMoreBtnClicked:eachBtnCanEdit:)]) {
            [self.delegate showMoreBtnClicked:_index eachBtnCanEdit:!_chechNoteMoreViewShow];
        }
    }
}

#pragma mark HICCheckNoteMoreViewDelegate
- (void)copyClicked {
    if ([self.delegate respondsToSelector:@selector(copyClicked:)]) {
        [self.delegate copyClicked:_index];
    }
}

- (void)deleteClicked {
    if ([self.delegate respondsToSelector:@selector(deleteClicked:)]) {
        [self.delegate deleteClicked:_index];
    }
}

- (void)setToImportantClicked {
    if ([self.delegate respondsToSelector:@selector(setToImportantClicked:)]) {
        [self.delegate setToImportantClicked:_index];
    }
}

@end
