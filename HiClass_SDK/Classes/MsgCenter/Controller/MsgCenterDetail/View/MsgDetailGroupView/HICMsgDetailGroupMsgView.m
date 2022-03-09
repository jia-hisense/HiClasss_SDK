//
//  HICMsgDetailGroupMsgView.m
//  HiClass
//
//  Created by Eddie Ma on 2020/2/26.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICMsgDetailGroupMsgView.h"
#import "HICMsgDetailGroupMsgCell.h"
#import "HICGroupMsgModel.h"

static NSString *msgDetailGroupMsgCellIdenfer = @"msgDetailGroupMsgCell";
static NSString *logName = @"[HIC][MDGM]";

@interface HICMsgDetailGroupMsgView() <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation HICMsgDetailGroupMsgView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
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
    HICMsgDetailGroupMsgCell *msgDetailGroupMsgCell = (HICMsgDetailGroupMsgCell *)[tableView dequeueReusableCellWithIdentifier:msgDetailGroupMsgCellIdenfer];
    if (msgDetailGroupMsgCell == nil) {
        msgDetailGroupMsgCell = [[HICMsgDetailGroupMsgCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:msgDetailGroupMsgCellIdenfer];
        [msgDetailGroupMsgCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    } else {
    }

    HICGroupMsgModel *model = _data[indexPath.row];
    [msgDetailGroupMsgCell setData:model index:indexPath.row];
    return msgDetailGroupMsgCell;
}

#pragma mark tableview delegate协议方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return MSG_CENTER_GROUP_MSG_CELL_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HICGroupMsgModel *model = _data[indexPath.row];
    if ([self.delegate respondsToSelector:@selector(msgView:selectIndex:mode:)]) {
        [self.delegate msgView:self selectIndex:indexPath mode:model];
    }
}

@end
