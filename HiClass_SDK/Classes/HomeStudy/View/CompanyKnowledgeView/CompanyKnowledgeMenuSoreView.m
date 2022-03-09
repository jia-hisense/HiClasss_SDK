//
//  CompanyKnowledgeMenuClassSoreView.m
//  iTest
//
//  Created by Sir_Jing on 2020/3/12.
//  Copyright © 2020 Sir_Jing. All rights reserved.
//

#import "CompanyKnowledgeMenuSoreView.h"

#import "CKMenuSoreLeftCell.h"
#import "CKMenuSoreRightCell.h"
#import "CKMenuSoreRightView.h"

#import "HICCompanyMenuModel.h"

@interface CompanyKnowledgeMenuSoreView ()<UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, CKMenuSoreRightViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, assign) NSInteger isSelectIndex;

@property (nonatomic, assign) NSInteger isSelectRight;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) NSMutableArray *rightViews;

@end

@implementation CompanyKnowledgeMenuSoreView

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _isSelectIndex = 0;
        _rightViews = [NSMutableArray array];
        [self createView];
    }
    return self;
}

-(void)createView {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, HIC_ScreenWidth, self.frame.size.height)];
    [self addSubview:scrollView];
    self.scrollView = scrollView;
 
    CGFloat tableWidth = HIC_ScreenWidth/3.0;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, tableWidth, self.frame.size.height) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerClass:CKMenuSoreLeftCell.class forCellReuseIdentifier:@"cell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 60;
    self.tableView.showsVerticalScrollIndicator = NO;
    if (@available(iOS 15.0, *)) {
        self.tableView.sectionHeaderTopPadding = 0;
    }

//    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
//    flow.minimumLineSpacing = 1;
//    flow.minimumInteritemSpacing = 1;
//    CGFloat itemWidth = (self.frame.size.width-116 - 1)/2.0;
//    flow.itemSize = CGSizeMake(itemWidth, 60);
//    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(116, 0, self.frame.size.width-116, self.frame.size.height) collectionViewLayout:flow];
//    self.collectionView.dataSource = self;
//    self.collectionView.delegate = self;
//    self.collectionView.backgroundColor = UIColor.whiteColor;
//    [self.collectionView registerClass:CKMenuSoreRightCell.class forCellWithReuseIdentifier:@"cell"];

    [scrollView addSubview:self.tableView];
//    [scrollView addSubview:self.collectionView];
}

#pragma mark - 页面赋值
-(void)setDataSource:(NSArray *)dataSource {
//    _dataSource = dataSource;
    NSMutableArray *array = [NSMutableArray arrayWithArray:dataSource];
    HICCompanyMenuModel *model = HICCompanyMenuModel.new;
    model.catalogName = NSLocalizableString(@"allCourses", nil);
    [array insertObject:model atIndex:0];
    _dataSource = [array copy];
    [self.tableView reloadData];
    [self.collectionView reloadData];
}

#pragma mark - TableDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CKMenuSoreLeftCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];

    cell.model = self.dataSource[indexPath.row];

    return cell;
}

#pragma mark - TableDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_isSelectIndex != indexPath.row) {
        _isSelectIndex = indexPath.row;
    }

    [self.rightViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIView *view = (UIView *)obj;
        [view removeFromSuperview];
    }];
    [self.rightViews removeAllObjects];
    [self.scrollView setContentSize:CGSizeMake(0, 0)];

    if (indexPath.row == 0) {
        if (self.changeIndexBlock) {
            self.changeIndexBlock(_isSelectIndex, @"");
        }
        return;
    }

    if (self.dataSource.count -1 >= indexPath.row) {
        HICCompanyMenuModel *model = self.dataSource[_isSelectIndex];
        if (model.children.count == 0) {
            if (self.changeIndexBlock) {
                self.changeIndexBlock(_isSelectIndex, model.catalogId);
            }
        }else {
            CGFloat tableWidth = HIC_ScreenWidth/3.0;
            CKMenuSoreRightView *view = [[CKMenuSoreRightView alloc] initWithFrame:CGRectMake(tableWidth*(self.rightViews.count+1), 0, tableWidth, self.bounds.size.height) style:UITableViewStylePlain];
            view.viewDelegate = self;
            view.data = model.children;
            view.parentModel = model;
            [self.scrollView addSubview:view];
            [self.rightViews addObject:view];
            if (self.rightViews.count > 2) {
                [self.scrollView setContentOffset:CGPointMake((self.rightViews.count-2)*tableWidth, 0)];
                [self.scrollView setContentSize:CGSizeMake((self.rightViews.count+1)*tableWidth, 0)];
            }
        }
    }
}

#pragma mark - RightViewDelegate
-(void)soreRightView:(CKMenuSoreRightView *)view clicCell:(UITableViewCell *)cell hasMore:(BOOL)isMore selectID:(NSString *)selectID parentModel:(nonnull HICCompanyMenuModel *)parentModel{

    if (isMore) {
        if (self.changeIndexBlock) {
            self.changeIndexBlock(_isSelectIndex, parentModel.catalogId);
        }
    }else {
        if (self.changeIndexBlock) {
            self.changeIndexBlock(_isSelectIndex, selectID);
        }
    }
    NSInteger index = [self.rightViews indexOfObject:view];
    NSMutableArray *views = [NSMutableArray array];
    [self.rightViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx > index) {
            CKMenuSoreRightView *view = (CKMenuSoreRightView *)obj;
            [view removeFromSuperview];
            [views addObject:view];
        }
    }];
    [views enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.rightViews removeObject:obj];
    }];
    CGFloat tableWidth = HIC_ScreenWidth/3.0;
    if (self.rightViews.count > 2) {
        [self.scrollView setContentOffset:CGPointMake((self.rightViews.count-2)*tableWidth, 0)];
        [self.scrollView setContentSize:CGSizeMake((self.rightViews.count+1)*tableWidth, 0)];
    }else {
        [self.scrollView setContentOffset:CGPointMake(0, 0)];
        [self.scrollView setContentSize:CGSizeMake(0, 0)];
    }
}

-(void)soreRightView:(CKMenuSoreRightView *)view clicCell:(UITableViewCell *)cell hasMore:(BOOL)isMore dataSource:(NSArray *)dataSource parentModel:(nonnull HICCompanyMenuModel *)parentModel{

    NSInteger index = [self.rightViews indexOfObject:view];
    NSMutableArray *views = [NSMutableArray array];
    [self.rightViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx > index) {
            CKMenuSoreRightView *view = (CKMenuSoreRightView *)obj;
            [view removeFromSuperview];
            [views addObject:view];
        }
    }];
    [views enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.rightViews removeObject:obj];
    }];

    CGFloat tableWidth = HIC_ScreenWidth/3.0;
    CKMenuSoreRightView *rightView = [[CKMenuSoreRightView alloc] initWithFrame:CGRectMake(tableWidth*(self.rightViews.count+1), 0, tableWidth, self.bounds.size.height) style:UITableViewStylePlain];
    rightView.viewDelegate = self;
    rightView.data = dataSource;
    rightView.parentModel = parentModel;
    [self.scrollView addSubview:rightView];
    [self.rightViews addObject:rightView];


    if (self.rightViews.count > 2) {
        [self.scrollView setContentOffset:CGPointMake((self.rightViews.count-2)*tableWidth, 0)];
        [self.scrollView setContentSize:CGSizeMake((self.rightViews.count+1)*tableWidth, 0)];
    }
}

#pragma mark - CollectDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSArray *childen = self.dataSource[_isSelectIndex];
    return childen.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *childen = self.dataSource[_isSelectIndex];
    CKMenuSoreRightCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];

    cell.model = childen.count-1>=indexPath.row ? childen[indexPath.row]:@{};

    return cell;
}

@end
