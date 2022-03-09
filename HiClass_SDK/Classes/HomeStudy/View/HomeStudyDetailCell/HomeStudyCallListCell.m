//
//  HomeStudyCallListCell.m
//  HiClass
//
//  Created by 铁柱， on 2020/3/29.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HomeStudyCallListCell.h"

#import "HomeStudyListCell.h"

@interface HomeStudyCallListCell()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *cellTitleLabel;

@property (nonatomic, strong) NSArray *dataSource;

@property (nonatomic, strong) UILabel *moreLabel;
@property (nonatomic, strong) UIImageView *moreImageView;
@property (nonatomic, strong) UIButton *moreBut;


@end
@implementation HomeStudyCallListCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createView];
    }
    return self;
}

-(void)createView {

    CGFloat screenWidth = UIScreen.mainScreen.bounds.size.width;
    UILabel *studyTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 5, screenWidth - 16 - 25.5 - 26 - 5, 25)];
    studyTitleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
    studyTitleLabel.text = NSLocalizableString(@"todayRecommendation", nil);
    studyTitleLabel.textColor = UIColor.blackColor;
    self.cellTitleLabel = studyTitleLabel;

    UILabel *moreLabel = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth - 25.5 - 26, 8, 26, 19)];
    moreLabel.textColor = [UIColor colorWithRed:133/255.0 green:133/255.0 blue:133/255.0 alpha:1];
    moreLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    moreLabel.text = NSLocalizableString(@"all", nil);
    self.moreLabel = moreLabel;

    UIImageView *moreImageView = [[UIImageView alloc] initWithFrame:CGRectMake(screenWidth - 16 - 5.5, 12.5, 5.5, 10)];
    moreImageView.image = [UIImage imageNamed:@"全部-箭头"];
    self.moreImageView = moreImageView;

    UIButton *moreBut = [[UIButton alloc] initWithFrame:CGRectMake(screenWidth - 25.5 - 26, 8, 28, 19)];
    [moreBut addTarget:self action:@selector(clickMoreBut:) forControlEvents:UIControlEventTouchUpInside];
    self.moreBut = moreBut;
    [self.contentView addSubview:moreLabel];
    [self.contentView addSubview:moreImageView];
    [self.contentView addSubview:moreBut];

    [self.tableView registerClass:HomeStudyListCell.class forCellReuseIdentifier:@"cell"];

    [self.contentView addSubview:self.tableView];
    [self.contentView addSubview:studyTitleLabel];

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(studyTitleLabel.mas_bottom).offset(1);
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-4);
    }];
}

// 页面赋值
-(void)setHomeStudyModel:(HICHomeStudyModel *)homeStudyModel {
    if (self.homeStudyModel == homeStudyModel) {
        return;
    }
    [super setHomeStudyModel:homeStudyModel];
    self.dataSource = homeStudyModel.resourceList;
    [self.tableView reloadData];
    self.cellTitleLabel.text = homeStudyModel.name;
    if (homeStudyModel.source != 0) {
        [self showMoreBut];
    }else {
        [self hiddenMoreBut];
    }
}

-(void)hiddenMoreBut {
    self.moreImageView.hidden = YES;
    self.moreLabel.hidden = YES;
    self.moreBut.hidden = YES;
}

-(void)showMoreBut {
    self.moreImageView.hidden = NO;
    self.moreLabel.hidden = NO;
    self.moreBut.hidden = NO;
}

-(void)clickMoreBut:(UIButton *)btn {
    if([self.delegate respondsToSelector:@selector(studyCell:clickMoreBut:model:type:)]) {
        [self.delegate studyCell:self clickMoreBut:btn model:self.homeStudyModel type:0];
    }
}

#pragma mark - TableDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeStudyListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];

    ResourceListItem *item = [self.dataSource objectAtIndex:indexPath.row];
    cell.itemModel = item;
    cell.cellIndexPath = indexPath;

    return cell;
}


#pragma mark - CollectionDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ResourceListItem *model = [self.dataSource objectAtIndex:indexPath.row];
    if ([self.delegate respondsToSelector:@selector(studyCell:onTap:other:)]) {
        [self.delegate studyCell:self onTap:model other:nil];
    }
}

#pragma mark - 懒加载
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(16, 42, UIScreen.mainScreen.bounds.size.width-16*2, 89) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = UIColor.whiteColor;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = 95;
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0;
        }
    }
    return _tableView;
}


@end
