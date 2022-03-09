//
//  HICMsgDetailCardView.m
//  HiClass
//
//  Created by Eddie Ma on 2020/2/26.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICMsgDetailCardView.h"
#import "HICMsgDetailCardCell.h"
#import "HICMsgModel.h"

static NSString *msgDetailCardCellIdenfer = @"msgDetailCardCell";
static NSString *logName = @"[HIC][MDCV]";

@interface HICMsgDetailCardView() <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) HICMsgType type;
@property (nonatomic,strong) UIImageView *blackView;
@property (nonatomic,strong) UILabel *blackLabel;
@end

@implementation HICMsgDetailCardView
-(UIImageView *)blackView{
    if (!_blackView) {
        _blackView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"消息-任务空白页"]];
        _blackView.frame = CGRectMake(HIC_ScreenWidth/ 2 - 60, 214 + HIC_StatusBar_Height, 120, 120);
    }
    return _blackView;
}
-(UILabel *)blackLabel{
    if (!_blackLabel) {
        _blackLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 342 + HIC_StatusBar_Height, HIC_ScreenWidth, 20)];
        _blackLabel.text = NSLocalizableString(@"temporarilyNoData", nil);
        _blackLabel.textColor = TEXT_COLOR_LIGHTS;
        _blackLabel.font = FONT_REGULAR_16;
        _blackLabel.textAlignment = NSTextAlignmentCenter;
        
    }
    return _blackLabel;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self creatUI];
    }
    return self;
}

- (void)setData:(NSArray *)data {
    _data = data;
    if (![HICCommonUtils isValidObject:_data] || _data.count == 0) {
        if (!(self.type == HICMsgTypeToDo || self.type == HICMsgTypeTask)) {
            self.blackView.image = [UIImage imageNamed:@"消息-内容更新-空白页"];
            _blackView.frame = CGRectMake(HIC_ScreenWidth/ 2 - 60, 214 + HIC_StatusBar_Height, 120, 120);
            self.blackLabel.text = NSLocalizableString(@"noUpData", nil);
               }
        [self addSubview:self.blackLabel];
        [self addSubview:self.blackView];
        return;
    }else{
        if ([self.subviews containsObject:self.blackView]) {
            [self.blackView removeFromSuperview];
            [self.blackLabel removeFromSuperview];
        }
    }
    [_tableView reloadData];
}

- (instancetype)initWithFrame:(CGRect)frame type:(HICMsgType)type {
    if (self = [super initWithFrame:frame]) {
        self.type = type;
        [self creatUI];
    }
    return self;
}

- (void)creatUI {
    [self createTableView];
}

- (void)createTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) style:UITableViewStylePlain];
    [self addSubview:_tableView];
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
    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HICMsgDetailCardCell *msgDetailCardCell = (HICMsgDetailCardCell *)[tableView dequeueReusableCellWithIdentifier:msgDetailCardCellIdenfer];
    if (msgDetailCardCell == nil) {
        msgDetailCardCell = [[HICMsgDetailCardCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:msgDetailCardCellIdenfer];
        [msgDetailCardCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    } else {
    }
    
    HICMsgModel *model = _data[indexPath.row];
    [msgDetailCardCell setData:model index:indexPath.row type:_type];
    return msgDetailCardCell;
}

#pragma mark tableview delegate协议方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat topAndBtnMargin = 12;
    CGFloat titleTopMargin = 12;
    CGFloat titleHeight = 20 + 8;
    CGFloat contentBtmMargin = 16;
    if (_type == HICMsgTypeTask || _type == HICMsgTypeToDo) {
        titleTopMargin = 16;
        titleHeight = 24 + 8;
    }
    HICMsgModel *model = _data[indexPath.row];
    return topAndBtnMargin + titleTopMargin + titleHeight + [self getContentHeight:model.msgContent] + contentBtmMargin;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HICMsgModel *model = _data[indexPath.row];
    if ([self.delegate respondsToSelector:@selector(msgCardView:selectIndex:mode:)]) {
        [self.delegate msgCardView:self selectIndex:indexPath mode:model];
    }
}

- (CGFloat)getContentHeight:(NSString *)str {
    UILabel *label = [[UILabel alloc] init];
    label.text = str;
    NSInteger fontInteger = 15;
    if (_type == HICMsgTypeTask || _type == HICMsgTypeToDo) {
        label.font = FONT_REGULAR_14;
        fontInteger = 14;
    } else {
        label.font = FONT_REGULAR_15;
    }
    
    label.numberOfLines = 0;
    CGFloat labelHeight = [HICCommonUtils sizeOfString:str stringWidthBounding:HIC_ScreenWidth - 2 * 28 font:fontInteger stringOnBtn:NO fontIsRegular:YES].height;
    label.frame = CGRectMake(0, 0, HIC_ScreenWidth - 2 * 28, labelHeight);
    [label sizeToFit];
    return label.frame.size.height;
}


@end
