//
//  HomeStudyModelFourCell.m
//  iTest
//
//  Created by Sir_Jing on 2020/3/10.
//  Copyright © 2020 Sir_Jing. All rights reserved.
//

#import "HomeStudyModelFourCell.h"

#import "HomeStudyModelFourCollectionCell.h"

@interface HomeStudyModelFourCell ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UILabel *cellTitleLabel;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSArray *dataSource;

@property (nonatomic, strong) UILabel *moreLabel;
@property (nonatomic, strong) UIImageView *moreImageView;
@property (nonatomic, strong) UIButton *moreBut;

@end

@implementation HomeStudyModelFourCell

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

    [self.collectionView registerClass:HomeStudyModelFourCollectionCell.class forCellWithReuseIdentifier:@"cell"];

    [self.contentView addSubview:self.collectionView];
    [self.contentView addSubview:studyTitleLabel];
}

// 页面赋值
-(void)setHomeStudyModel:(HICHomeStudyModel *)homeStudyModel {
    if (self.homeStudyModel == homeStudyModel) {
        return;
    }
    [super setHomeStudyModel:homeStudyModel];
    self.dataSource = homeStudyModel.resourceList;
    [self.collectionView reloadData];
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

#pragma mark - CollectionDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HomeStudyModelFourCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];

    cell.model = self.dataSource[indexPath.row];
    cell.itemIndexPath = indexPath;

    return cell;
}

#pragma mark - CollectionDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    ResourceListItem *model = [self.dataSource objectAtIndex:indexPath.row];
    if ([self.delegate respondsToSelector:@selector(studyCell:onTap:other:)]) {
        [self.delegate studyCell:self onTap:model other:nil];
    }
}

#pragma mark - 懒加载
-(UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc]init];
        flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flow.itemSize = CGSizeMake(60, 88);
        flow.minimumLineSpacing = 20.f;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(16, 42, UIScreen.mainScreen.bounds.size.width-16*2, 89) collectionViewLayout:flow];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = UIColor.whiteColor;
        _collectionView.showsHorizontalScrollIndicator = NO;
    }
    return _collectionView;
}


@end
