//
//  CKMenuSoreRightView.m
//  HiClass
//
//  Created by wangggang on 2020/3/23.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "CKMenuSoreRightView.h"

#import "CKMenuSoreLeftCell.h"

#import "HICCompanyMenuModel.h"

@interface CKMenuSoreRightView ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation CKMenuSoreRightView

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        [self registerClass:CKMenuSoreLeftCell.class forCellReuseIdentifier:@"cell"];
        self.dataSource = self;
        self.delegate = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableFooterView = UIView.new;
    }
    return self;
}

-(void)setData:(NSArray *)data {
//    _data = data;
    NSMutableArray *array = [NSMutableArray arrayWithArray:data];
    HICCompanyMenuModel *model = HICCompanyMenuModel.new;
    model.catalogName = NSLocalizableString(@"all", nil);
    [array insertObject:model atIndex:0];
    _data = [array copy];
    [self reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    CKMenuSoreLeftCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];

    cell.model = self.data[indexPath.row];
    cell.isRightView = YES;

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    HICCompanyMenuModel *model = [self.data objectAtIndex:indexPath.row];

    if (model.children.count != 0) {
        // 还有下一级目录
        if ([self.viewDelegate respondsToSelector:@selector(soreRightView:clicCell:hasMore:dataSource:parentModel:)]) {
            [self.viewDelegate soreRightView:self clicCell:[tableView cellForRowAtIndexPath:indexPath] hasMore:YES dataSource:model.children parentModel:model];
        }
    }else {
        // 没有下一级目录
        if ([self.viewDelegate respondsToSelector:@selector(soreRightView:clicCell:hasMore:selectID:parentModel:)]) {
            if (indexPath.row == 0) {
                [self.viewDelegate soreRightView:self clicCell:[tableView cellForRowAtIndexPath:indexPath] hasMore:YES selectID:model.catalogId parentModel:self.parentModel];
            }else {
                [self.viewDelegate soreRightView:self clicCell:[tableView cellForRowAtIndexPath:indexPath] hasMore:NO selectID:model.catalogId parentModel:self.parentModel];
            }
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

@end
