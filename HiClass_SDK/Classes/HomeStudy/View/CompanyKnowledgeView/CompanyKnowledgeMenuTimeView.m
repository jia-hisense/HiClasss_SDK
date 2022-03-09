//
//  CompanyKnowledgeMenuTimeView.m
//  iTest
//
//  Created by Sir_Jing on 2020/3/12.
//  Copyright © 2020 Sir_Jing. All rights reserved.
//

#import "CompanyKnowledgeMenuTimeView.h"

#import "CKMenuTypeCell.h"

@interface CompanyKnowledgeMenuTimeView ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *dataSource;

@property (nonatomic, assign) NSInteger selectIndex;

@end

@implementation CompanyKnowledgeMenuTimeView

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _dataSource = @[NSLocalizableString(@"byReleaseTime", nil), NSLocalizableString(@"byUpdateTime", nil), NSLocalizableString(@"learnPeopleNumber", nil)];
        _selectIndex = 0;
        [self createView];
    }
    return self;
}

-(void)createView {

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerClass:CKMenuTypeCell.class forCellReuseIdentifier:@"cell"];
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 44;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.tableFooterView = [UIView new];
    if (@available(iOS 15.0, *)) {
        self.tableView.sectionHeaderTopPadding = 0;
    }

    [self addSubview:self.tableView];

}

#pragma mark - TableDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CKMenuTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];

    cell.cellIndexPath = indexPath;
    cell.titleStr = _dataSource[indexPath.row];
    if (_selectIndex == indexPath.row) {
        cell.isSelect = YES;
    }else {
        cell.isSelect = NO;
    }

    return cell;
}

#pragma mark - TableDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_selectIndex != indexPath.row) {
        _selectIndex = indexPath.row;
        [tableView reloadData];
    }
    if (self.changeIndexBlock) {
        self.changeIndexBlock(_selectIndex, _dataSource[_selectIndex]);
    }
}


@end
