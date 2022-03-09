//
//  HICCheckNoteView.m
//  HiClass
//
//  Created by Eddie Ma on 2020/2/8.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICCheckNoteCell.h"
#import "HICCheckNoteView.h"
#import "HICCheckNoteModel.h"

static NSString *checkNoteCellIdenfer = @"allReplyCell";
static NSString *logName = @"[HIC][CNV]";

@interface HICCheckNoteView()<UITableViewDataSource, UITableViewDelegate, HICCheckNoteCellDelegate>
@property (nonatomic, strong) NSMutableArray *notes;
@property (nonatomic, strong) UIView *noteContainer;

@property (nonatomic, assign) NSInteger btnCanEditWithIndex;
@property (nonatomic, assign) HICStudyBtmViewType type;
@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) UILabel *noteNum;
@property (nonatomic, strong) UILabel *noteTitle;
@end

@implementation HICCheckNoteView

- (instancetype)initWithNotes:(NSArray *)notes type:(HICStudyBtmViewType)type identifier:(NSString *)identifier {
    if (self = [super init]) {
        self.type = type;
        self.identifier = identifier;
        [self initData];
        [self requestData];
        [self creatUI];
    }
    return self;
}
-(void)setIsMy:(BOOL)isMy{
    _isMy = isMy;
    if (_isMy) {
        self.frame = CGRectMake(0, HIC_NavBarAndStatusBarHeight + 79 + 8, HIC_ScreenWidth, HIC_ScreenHeight - HIC_NavBarAndStatusBarHeight - 79 -8);
        self.backgroundColor = [UIColor whiteColor];
        [self initTableView];
    }
}
- (void)initData {
    _notes = [[NSMutableArray alloc] init];
    self.btnCanEditWithIndex = -1;
}

- (void)requestData {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:_type == HICStudyBtmViewCourse ? @(6) : @(7)  forKey:@"objectType"];
    [dic setValue:[_identifier toNumber] forKey:@"objectId"];
    [dic setValue:@(1) forKey:@"terminalType"];
    [HICAPI studyNoteDetail:dic success:^(NSDictionary * _Nonnull responseObject) {
        if (![HICCommonUtils isValidObject:responseObject[@"data"]]) {
            return ;
        }
        NSDictionary *data = responseObject[@"data"];
        if ([HICCommonUtils isValidObject:data]) {
            NSArray * learningNotesList = [NSArray arrayWithArray:[data valueForKey:@"learningNotesList"]];
            for (int i = 0; i < learningNotesList.count; i ++) {
                HICCheckNoteModel *model = [[HICCheckNoteModel alloc] init];
                model.noteId = (NSNumber *)[learningNotesList[i] valueForKey:@"id"];
                model.noteTitle = [learningNotesList[i] valueForKey:@"title"];
                model.noteContent = [learningNotesList[i] valueForKey:@"content"];
                NSString *noteTagStr = @"";
                if ([(NSNumber *)[learningNotesList[i] valueForKey:@"majorFlag"] isEqual:@(1)]) {
                    noteTagStr = NSLocalizableString(@"important", nil);
                }
                model.noteTag = noteTagStr;
                model.noteMajorFlag = (NSNumber *)[learningNotesList[i] valueForKey:@"majorFlag"];
                model.noteTime = (NSNumber *)[learningNotesList[i] valueForKey:@"updateTime"];
                [self.notes addObject: model];
            }
            [self updateUI];
            [self.tableView reloadData];
        }
    } failure:^(NSError * _Nonnull error) {
        
        DDLogDebug(@"error");
    }];
}

- (void)creatUI {
    self.frame = CGRectMake(0, 0, HIC_ScreenWidth, HIC_ScreenHeight);
    self.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.50];
    _noteContainer = [[UIView alloc] init];
    [self addSubview: _noteContainer];
    CGFloat topMargin_for_more_notes = 327 - 20 + HIC_StatusBar_Height;
    CGFloat topMargin_for_one_note = 72 - 20 + HIC_StatusBar_Height;
    _noteContainer.frame = CGRectMake(0, HIC_ScreenHeight, self.frame.size.width, self.frame.size.height - topMargin_for_more_notes);
    [UIView animateWithDuration:0.3 animations:^{
        if (self->_notes.count == 1) {
            self->_noteContainer.frame = CGRectMake(0, topMargin_for_more_notes, self.frame.size.width, self.frame.size.height - topMargin_for_more_notes);
        } else {
            self->_noteContainer.frame = CGRectMake(0, topMargin_for_one_note, self.frame.size.width, self.frame.size.height - topMargin_for_one_note);
        }
    }];
    [HICCommonUtils setRoundingCornersWithView:_noteContainer TopLeft:YES TopRight:YES bottomLeft:NO bottomRight:NO cornerRadius:15];
    _noteContainer.backgroundColor = [UIColor whiteColor];

    self.noteTitle = [[UILabel alloc] init];
    [_noteContainer addSubview:_noteTitle];
    _noteTitle.frame = CGRectMake(16, (50 - 24)/2, 34, 24);
    _noteTitle.font = FONT_MEDIUM_17;
    _noteTitle.text = NSLocalizableString(@"note", nil);
    _noteTitle.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];

    self.noteNum = [[UILabel alloc] init];
    [_noteContainer addSubview:_noteNum];
    _noteNum.font = FONT_MEDIUM_14;
    _noteNum.text = [NSString stringWithFormat:@"(%lu)",(unsigned long)_notes.count];
    CGFloat noteNumWidth = [HICCommonUtils sizeOfString:_noteNum.text stringWidthBounding:HIC_ScreenWidth font:14 stringOnBtn:NO fontIsRegular:NO].width;
    _noteNum.frame = CGRectMake(16 + _noteTitle.frame.size.width + 4, (50 - 20)/2, noteNumWidth, 20);
    _noteNum.textColor =  [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1/1.0];

    UIButton *cancelBtn = [[UIButton alloc] init];
    [_noteContainer addSubview: cancelBtn];
    cancelBtn.tag = 10000;
    [cancelBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setImage:[UIImage imageNamed:@"关闭弹窗"] forState:UIControlStateNormal];
    cancelBtn.frame = CGRectMake(_noteContainer.frame.size.width - 20 - 16, (50 - 20)/2, 20, 20);

    UIView *dividedLine = [[UIView alloc] initWithFrame:CGRectMake(0, 50 - 0.5, _noteContainer.frame.size.width, 0.5)];
    [_noteContainer addSubview: dividedLine];
    dividedLine.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1/1.0];

    [self initTableView];
}

- (void)updateUI {
    _noteNum.text = [NSString stringWithFormat:@"(%lu)",(unsigned long)_notes.count];
    CGFloat noteNumWidth = [HICCommonUtils sizeOfString:_noteNum.text stringWidthBounding:HIC_ScreenWidth font:14 stringOnBtn:NO fontIsRegular:NO].width;
    _noteNum.frame = CGRectMake(16 + _noteTitle.frame.size.width + 4, (50 - 20)/2, noteNumWidth, 20);
}

- (void)initTableView {
    if (_isMy) {
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, HIC_ScreenWidth, self.height) style:UITableViewStylePlain];
        [self addSubview:self.tableView];
    }else{
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, _noteContainer.frame.size.width, _noteContainer.frame.size.height - 50) style:UITableViewStylePlain];
         [_noteContainer addSubview:_tableView];
    }
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
    return _notes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HICCheckNoteCell *checkNoteCell = (HICCheckNoteCell *)[tableView dequeueReusableCellWithIdentifier:checkNoteCellIdenfer];
    if (checkNoteCell == nil) {
        checkNoteCell = [[HICCheckNoteCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:checkNoteCellIdenfer];
        checkNoteCell.delegate = self;
        [checkNoteCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    } else {

    }

    HICCheckNoteModel *model = _notes[indexPath.row];
    BOOL isLast = NO;
    if (indexPath.row == _notes.count - 1) {
        isLast = YES;
    }
    BOOL canEdit = NO;
    BOOL eachMoteBtnCanEdit = NO;
    if (indexPath.row == _btnCanEditWithIndex || _btnCanEditWithIndex == -1) {
        if (_btnCanEditWithIndex == -1) {
            eachMoteBtnCanEdit = YES;
        }
        canEdit = YES;
    }

    [checkNoteCell setData:model index:indexPath.row isLastOne:isLast moreBtnCanEdit:canEdit eachMoteBtnCanEdit:eachMoteBtnCanEdit];

    return checkNoteCell;

}

#pragma mark tableview delegate协议方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    HICCheckNoteModel *model = _notes[indexPath.row];
    CGFloat tagHeight = 12;
    if ([NSString isValidStr:model.noteTag]) {
        tagHeight = 10 + 16 + 6;
    }

    CGFloat lastCellContentH = 0;
    if (indexPath.row == _notes.count - 1 &&  _btnCanEditWithIndex != -1) {
        lastCellContentH = [self getContentHeight:model.noteContent];
        if (lastCellContentH <= 25) {
            lastCellContentH = 120;
        } else if (lastCellContentH > 25 && lastCellContentH < 80) {
            lastCellContentH = 100;
        } else if (lastCellContentH >= 80 && lastCellContentH < 150) {
            lastCellContentH = 60;
        }
    }
    CGFloat lastCellHeight = indexPath.row == _notes.count - 1 && _btnCanEditWithIndex != -1 ? lastCellContentH : 0;
    return 16 + 20 + tagHeight + [self getContentHeight:model.noteContent] + 16 + lastCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == _btnCanEditWithIndex && _btnCanEditWithIndex != -1) {
        [_tableView bringSubviewToFront:cell];
    }
}

- (CGFloat)getContentHeight:(NSString *)str {
    UILabel *label = [[UILabel alloc] init];
    label.text = str;
    label.font = FONT_REGULAR_15;
    label.numberOfLines = 0;
    CGFloat labelHeight = [HICCommonUtils sizeOfString:str stringWidthBounding:HIC_ScreenWidth - 2 *16 font:15 stringOnBtn:NO fontIsRegular:YES].height;
    label.frame = CGRectMake(0, 0, HIC_ScreenWidth - 2 *16, labelHeight);
    [label sizeToFit];
    return label.frame.size.height;
}

- (void)btnClicked:(UIButton *)btn {
    if (btn.tag == 10000) {
        [UIView animateWithDuration:0.3 animations:^{
            self->_noteContainer.frame = CGRectMake(0, HIC_ScreenHeight, self.frame.size.width, self.frame.size.height - 72);
        }];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self removeFromSuperview];
        });
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"EIXT_NOTE_LIST_POP_WINDOW" object:nil userInfo:nil];
}

#pragma mark HICCheckNoteCellDelegate
/// 笔记复制按钮点击
- (void)copyClicked:(NSInteger)index {
    if (_notes.count - 1 >= index && _notes.count > 0) {
        DDLogDebug(@"%@ Note Copy btn Clicked, index: %ld", logName, (long)index);
        HICCheckNoteModel *model = _notes[index];
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = model.noteContent;
        [HICToast showWithText:NSLocalizableString(@"copySuccess", nil)];
        [self showMoreBtnClicked:-1 eachBtnCanEdit:YES];
    }
}

/// 笔记删除按钮点击
- (void)deleteClicked:(NSInteger)index {
    if (_notes.count - 1 >= index && _notes.count > 0) {
        DDLogDebug(@"%@ Note Delete btn Clicked, index: %ld", logName, (long)index);
        HICCheckNoteModel *model = _notes[index];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        //    [dic setValue:[model.noteId toString]  forKey:@"noteIds"];
        //    [dic setValue:@(2) forKey:@"action"];
        [dic setValue:@(1) forKey:@"terminalType"];
        
        NSString *url = [NSString stringWithFormat:@"%@?noteIds=%@&action=%@", MY_NOTE_MANAGE, [model.noteId toString], @(2)];
        [HICAPI setToImportantClicked:dic url:url success:^(NSDictionary * _Nonnull responseObject) {
            DDLogDebug(@"%@ Note deleted!", logName);
            [HICToast showWithText:NSLocalizableString(@"deleteSuccess", nil)];
            self.btnCanEditWithIndex = -1;
            [self.notes removeObjectAtIndex:index];
            [self updateUI];
            [self.tableView reloadData];
            if (self.notes.count == 0) {
                _tableView = nil;
            }
        } failure:^(NSError * _Nonnull error) {
            DDLogDebug(@"%@ Note deleted failed!, error: %@", logName, error);
            [HICToast showWithText:NSLocalizableString(@"deleteFailedPrompt", nil)];
        }];
    }
}

/// 笔记设置重要按钮点击
- (void)setToImportantClicked:(NSInteger)index {
    if (_notes.count - 1 >= index && _notes.count > 0) {
        DDLogDebug(@"%@ Note Set to Important btn Clicked, index: %ld", logName, (long)index);
        HICCheckNoteModel *model = _notes[index];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        //    [dic setValue:[model.noteId toString]  forKey:@"noteIds"];
        NSNumber *majorFlag = @(1);
        if ([model.noteMajorFlag integerValue] == 1) {
            majorFlag = @(0);
        }
        //    [dic setValue:majorFlag forKey:@"majorFlag"];
        //    [dic setValue:@(1) forKey:@"action"];
        [dic setValue:@(1) forKey:@"terminalType"];
        
        NSString *url = [NSString stringWithFormat:@"%@?noteIds=%@&action=%@&majorFlag=%@", MY_NOTE_MANAGE, [model.noteId toString], @(1), majorFlag];
        [HICAPI setToImportantClicked:dic url:url success:^(NSDictionary * _Nonnull responseObject) {
            DDLogDebug(@"%@ %@ note seted!", logName, [majorFlag integerValue] == 1 ? @"Important" : @"Unimportant");
            [HICToast showWithText:[majorFlag integerValue] == 1 ? NSLocalizableString(@"setUpSuccess", nil) : NSLocalizableString(@"cancelSuccess", nil)];
            model.noteMajorFlag = majorFlag;
            if ([majorFlag integerValue] == 1) {
                model.noteTag = NSLocalizableString(@"important", nil);
            } else {
                model.noteTag = @"";
            }
            self.btnCanEditWithIndex = -1;
            [self.tableView reloadData];
        } failure:^(NSError * _Nonnull error) {
            DDLogDebug(@"%@ Important note seted failed!, error: %@", logName, error);
            [HICToast showWithText:[majorFlag integerValue] == 1 ? NSLocalizableString(@"setupFailedPrompt", nil) : NSLocalizableString(@"cancelFailurePrompt", nil)];
        }];
    }
}

- (void)showMoreBtnClicked:(NSInteger)index eachBtnCanEdit:(BOOL)canEdit {
    self.btnCanEditWithIndex = canEdit ? -1 : index;
    [_tableView reloadData];
}

@end
