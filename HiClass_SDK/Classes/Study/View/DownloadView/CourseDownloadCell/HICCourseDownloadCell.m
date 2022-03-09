//
//  HICCourseDownloadCell.m
//  HiClass
//
//  Created by Eddie Ma on 2020/2/13.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICCourseDownloadCell.h"
#import "HICKnowledgeDownloadModel.h"

#define CDLCCheckBoxHeight 24

@interface HICCourseDownloadCell()

@property (nonatomic, strong) UIImageView *checkBoxIV;
@property (nonatomic, strong) UILabel *sizeLable;
@property (nonatomic, strong) UILabel *contentLable;
@property (nonatomic, strong) UIButton *actionBtns;
@property (nonatomic, strong) UILabel *actionLabel;
@property (nonatomic, strong) UIImageView *actionIV;
@property (nonatomic, strong) UIView *extraView; // 点击'展开'后的view
@property (nonatomic, strong) UIView *dividedLine;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) CGFloat extraViewHeight;
@property (nonatomic, strong) HICCourseDownloadModel *cModel;
@property (nonatomic, assign) BOOL allSubItemChecked;
@property (nonatomic, strong) NSMutableArray *subItemCheckedArr;
@property (nonatomic, assign) BOOL allSubItemsDownloadFinished;
@property (nonatomic, strong) NSMutableArray *allSubItemsDownloadFinishedArr;
@end

@implementation HICCourseDownloadCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initData];
        [self creatUI];
    }
    return self;
}

- (void)initData {
    self.subItemCheckedArr = [[NSMutableArray alloc] init];
}

- (void)creatUI {
    self.backgroundColor = [UIColor whiteColor];

    _checkBoxIV = [[UIImageView alloc] initWithFrame:CGRectMake(16, (STUDY_DOWNLOAD_CELL_HEIGHT - CDLCCheckBoxHeight)/2, CDLCCheckBoxHeight, CDLCCheckBoxHeight)];
    [self.contentView addSubview: _checkBoxIV];
    _checkBoxIV.image = [UIImage imageNamed:@"未选择"];

    _sizeLable = [[UILabel alloc] init];
    [self.contentView addSubview: _sizeLable];
    _sizeLable.font = FONT_REGULAR_14;
    _sizeLable.textColor = [UIColor colorWithRed:133/255.0 green:133/255.0 blue:133/255.0 alpha:1/1.0];

    _contentLable = [[UILabel alloc] init];
    [self.contentView addSubview: _contentLable];
    _contentLable.font = FONT_MEDIUM_16;
    _contentLable.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];

    _actionBtns = [[UIButton alloc] init];
    [self.contentView addSubview:_actionBtns];
    _actionBtns.tag = -10000;
    [_actionBtns addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];

    _actionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 28, STUDY_DOWNLOAD_CELL_HEIGHT)];
    [_actionBtns addSubview: _actionLabel];
    _actionLabel.text = NSLocalizableString(@"develop", nil);
    _actionLabel.textAlignment = NSTextAlignmentCenter;
    _actionLabel.textColor = [UIColor colorWithRed:133/255.0 green:133/255.0 blue:133/255.0 alpha:1/1.0];
    _actionLabel.font = FONT_REGULAR_14;

    _actionIV = [[UIImageView alloc] initWithFrame:CGRectMake(28 + 2, (_actionLabel.frame.size.height - 15)/2, 15, 15)];
    [_actionBtns addSubview: _actionIV];
    _actionIV.image = [UIImage imageNamed:@"章节展开"];

    _actionBtns.frame = CGRectMake(HIC_ScreenWidth - (_actionLabel.frame.size.width + 2 + _actionIV.frame.size.width + 14), (STUDY_DOWNLOAD_CELL_HEIGHT - _actionLabel.frame.size.height)/2, _actionLabel.frame.size.width + 2 + _actionIV.frame.size.width, _actionLabel.frame.size.height);

    _dividedLine = [[UIView alloc] initWithFrame:CGRectMake(105, STUDY_DOWNLOAD_CELL_HEIGHT - 0.5, HIC_ScreenWidth - 105, 0.5)];
    [self.contentView addSubview:_dividedLine];
    _dividedLine.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1/1.0];

    _extraView = [[UIView alloc] init];

}

- (void)setData:(HICCourseDownloadModel *)model index:(NSInteger)index showExtraView:(BOOL)showExtraView subItemChecked:(NSArray *)arr checkedItems:(NSArray *)checkedItems {
    self.index = index;
    self.cModel = model;
    self.subItemCheckedArr = [[NSMutableArray alloc] initWithArray:arr];
    self.allSubItemsDownloadFinishedArr = [[NSMutableArray alloc] initWithArray:checkedItems];

    BOOL allChecked = YES;
    if (arr.count != self.cModel.knowledgeArr.count || self.cModel.knowledgeArr.count == 0) {
        allChecked = NO;
    }
    _allSubItemChecked = allChecked;

    BOOL allDownloadFinished = YES;
    if (checkedItems.count != self.cModel.knowledgeArr.count || checkedItems.count == 0) {
        allDownloadFinished = NO;
    }
    _allSubItemsDownloadFinished = allDownloadFinished;

    CGSize sizeLableSize = [HICCommonUtils sizeOfString:[NSString fileSizeWith:[model.mediaSize floatValue]] stringWidthBounding:HIC_ScreenWidth font:14 stringOnBtn:NO fontIsRegular:YES];
    _sizeLable.frame = CGRectMake(16 + _checkBoxIV.frame.size.width + 7, (STUDY_DOWNLOAD_CELL_HEIGHT - sizeLableSize.height)/2, sizeLableSize.width, sizeLableSize.height);
    _sizeLable.text = [NSString fileSizeWith:[model.mediaSize floatValue]];

    _contentLable.frame = CGRectMake(105, (STUDY_DOWNLOAD_CELL_HEIGHT - 22.5)/2, HIC_ScreenWidth - (105 + 83), 22.5);
    _contentLable.text = model.mediaName;

    if (model.knowledgeArr.count > 0) {
        _actionBtns.hidden = NO;
        _extraViewHeight = model.knowledgeArr.count * STUDY_DOWNLOAD_CELL_HEIGHT;
    } else {
        _actionBtns.hidden = YES;
        _extraViewHeight = 0.0;
    }

    if (showExtraView) {
        [self createExtraViewWith:_cModel];
        _actionLabel.text = NSLocalizableString(@"packUp", nil);
        _actionIV.image = [UIImage imageNamed:@"章节收起"];
    } else {
        [self createExtraViewWith:nil];
        _actionLabel.text = NSLocalizableString(@"develop", nil);
        _actionIV.image = [UIImage imageNamed:@"章节展开"];
    }

    if (allDownloadFinished) {
        _checkBoxIV.image = [UIImage imageNamed:@"icon-课程已下载"];
    } else {
        if ((_subItemCheckedArr.count == self.cModel.knowledgeArr.count) && _allSubItemChecked) {
            _checkBoxIV.image = [UIImage imageNamed:@"勾选"];
        } else {
            // 如果该章节中无课程下载
            if (self.cModel.knowledgeArr.count == 0) {
                self.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1/1.0];
                _checkBoxIV.hidden = YES;
            } else {
                _checkBoxIV.hidden = NO;
            }
            _checkBoxIV.image = [UIImage imageNamed:@"未选择"];
        }
    }

}

- (void)createExtraViewWith:(HICCourseDownloadModel *)model {
    if (!model) {
        _dividedLine.hidden = NO;
        [_extraView removeFromSuperview];
        return;
    }
    if (model.knowledgeArr.count > 0) {
        for (int i = 0; i < model.knowledgeArr.count; i++) {
            HICKnowledgeDownloadModel *kModel = model.knowledgeArr[i];
            UIButton *subItem = [[UIButton alloc] init];
            [subItem setBackgroundColor:[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1/1.0]];
            [_extraView addSubview:subItem];
            subItem.frame = CGRectMake(0, i * STUDY_DOWNLOAD_CELL_HEIGHT, HIC_ScreenWidth, STUDY_DOWNLOAD_CELL_HEIGHT);
            subItem.tag = _index * 10000 + i;

            UIImageView *subCheckBox = [[UIImageView alloc] initWithFrame:CGRectMake(16, (STUDY_DOWNLOAD_CELL_HEIGHT - CDLCCheckBoxHeight)/2, CDLCCheckBoxHeight, CDLCCheckBoxHeight)];
            [subItem addSubview:subCheckBox];
            if (_allSubItemsDownloadFinished) {
                subCheckBox.image = [UIImage imageNamed:@"icon-课程已下载"];
            } else {
                // 检查是否有已经下载完毕的媒资
                NSMutableArray *arr = [[NSMutableArray alloc] init];
                for (HICKnowledgeDownloadModel *aKMdoel in _allSubItemsDownloadFinishedArr) {
                    [arr addObject:aKMdoel.mediaId];
                }
                if ([arr containsObject:kModel.mediaId]) {
                    subCheckBox.image = [UIImage imageNamed:@"icon-课程已下载"];
                } else {
                    [subItem addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
                    if (_allSubItemChecked) {
                        subCheckBox.image = [UIImage imageNamed:@"勾选"];
                    } else if (_subItemCheckedArr.count == 0) {
                        subCheckBox.image = [UIImage imageNamed:@"未选择"];
                    } else {
                        for (int j = 0; j < _subItemCheckedArr.count; j++) {
                            NSInteger kIndex = [_subItemCheckedArr[j] integerValue];
                            if (kIndex == i) {
                                subCheckBox.image = [UIImage imageNamed:@"勾选"];
                                break;
                            } else {
                                subCheckBox.image = [UIImage imageNamed:@"未选择"];
                            }
                        }
                    }
                }
            }

            UILabel *subSizeLable = [[UILabel alloc] init];
            [subItem addSubview: subSizeLable];
            subSizeLable.font = FONT_REGULAR_14;
            subSizeLable.textColor = [UIColor colorWithRed:133/255.0 green:133/255.0 blue:133/255.0 alpha:1/1.0];
            subSizeLable.text = [NSString fileSizeWith:[kModel.mediaSize floatValue]];
            CGSize sizeLableSize = [HICCommonUtils sizeOfString:[NSString fileSizeWith:[kModel.mediaSize floatValue]] stringWidthBounding:HIC_ScreenWidth font:14 stringOnBtn:NO fontIsRegular:YES];
            subSizeLable.frame = CGRectMake(16 + subCheckBox.frame.size.width + 7, (STUDY_DOWNLOAD_CELL_HEIGHT - sizeLableSize.height)/2, sizeLableSize.width, sizeLableSize.height);


            UILabel *subContentLable = [[UILabel alloc] init];
            [subItem addSubview: subContentLable];
            subContentLable.font = FONT_REGULAR_15;
            subContentLable.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
            subContentLable.text = kModel.mediaName;
            subContentLable.frame = CGRectMake(105, (STUDY_DOWNLOAD_CELL_HEIGHT - 21)/2, HIC_ScreenWidth - (105 + 16), 21);

            if (i != model.knowledgeArr.count - 1) {
                UIView *subDividedLine = [[UIView alloc] initWithFrame:CGRectMake(105, STUDY_DOWNLOAD_CELL_HEIGHT - 0.5, HIC_ScreenWidth - 105, 0.5)];
                [subItem addSubview:subDividedLine];
                subDividedLine.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1/1.0];
            }
        }
    }
    _dividedLine.hidden = YES;
    _extraView.frame = CGRectMake(0, STUDY_DOWNLOAD_CELL_HEIGHT, HIC_ScreenWidth, _extraViewHeight);
    [self.contentView addSubview:_extraView];
}

- (void)btnClicked:(UIButton *)btn {
    if (btn.tag == -10000) {
        CGFloat extraHeight = _extraViewHeight;
        if ([_actionLabel.text isEqualToString:NSLocalizableString(@"develop", nil)]) {
            _actionLabel.text = NSLocalizableString(@"packUp", nil);
            _actionIV.image = [UIImage imageNamed:@"章节收起"];
            [self createExtraViewWith:_cModel];
        } else {
            _actionLabel.text = NSLocalizableString(@"develop", nil);
            _actionIV.image = [UIImage imageNamed:@"章节展开"];
            extraHeight = -extraHeight;
            [self createExtraViewWith:nil];
        }
        if ([self.delegate respondsToSelector:@selector(actionClicked:extraViewHeight:)]) {
            [self.delegate actionClicked:_index extraViewHeight:extraHeight];
        }
    } else {
        if ([self.delegate respondsToSelector:@selector(subItemClicked:)]) {
            [self.delegate subItemClicked:btn.tag];
        }
    }
}

@end
