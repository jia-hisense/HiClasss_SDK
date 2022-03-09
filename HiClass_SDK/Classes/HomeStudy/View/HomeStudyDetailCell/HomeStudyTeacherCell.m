//
//  HomeStudyTeacherCell.m
//  iTest
//
//  Created by Sir_Jing on 2020/3/10.
//  Copyright © 2020 Sir_Jing. All rights reserved.
//

#import "HomeStudyTeacherCell.h"

#import "HomeStudyTeacherCollectionCell.h"

@interface HomeStudyTeacherCell ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UILabel *cellTitleLabel;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSArray *teacherData;

@end

@implementation HomeStudyTeacherCell

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
    self.cellTitleLabel = studyTitleLabel;

    [self.collectionView registerClass:HomeStudyTeacherCollectionCell.class forCellWithReuseIdentifier:@"cell"];

    [self.contentView addSubview:self.collectionView];
    [self.contentView addSubview:studyTitleLabel];
}

// 页面赋值
-(void)setHomeStudyModel:(HICHomeStudyModel *)homeStudyModel {
    if (self.homeStudyModel == homeStudyModel) {
        return;
    }
    [super setHomeStudyModel:homeStudyModel];
    self.teacherData = homeStudyModel.resourceList;
    [self.collectionView reloadData];
    self.cellTitleLabel.text = homeStudyModel.name;
}

#pragma mark - CollectionDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.teacherData.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HomeStudyTeacherCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];

    ResourceListItem *item = self.teacherData[indexPath.row];
    cell.model = item;

    return cell;
}

#pragma mark - CollectionDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    ResourceListItem *model = [self.teacherData objectAtIndex:indexPath.row];
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
