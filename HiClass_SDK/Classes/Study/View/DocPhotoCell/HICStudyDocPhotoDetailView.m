//
//  HICStudyDocPhotoDetailView.m
//  HiClass
//
//  Created by Sir_Jing on 2020/2/10.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICStudyDocPhotoDetailView.h"
#import "HICStudyDocPhotoDetailCell.h"

@interface HICStudyDocPhotoDetailView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,HICStudyDocPhotoDetailCellDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UILabel *pageNumLabel;
@property (nonatomic, readonly)BOOL isLandscape;
@end

@implementation HICStudyDocPhotoDetailView
// 构造方法
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createViewWith:frame];
        self.currentIndex = 0;
    }
    return self;
}

- (void)createViewWith:(CGRect)frame {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) collectionViewLayout:layout];
    [self addSubview:self.collectionView];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.pagingEnabled = YES;
    [self.collectionView registerClass:HICStudyDocPhotoDetailCell.class forCellWithReuseIdentifier:@"cell"];
    if (@available(iOS 11.0, *)) {
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } 
    
    self.pageNumLabel = [[UILabel alloc]initWithFrame:CGRectMake((HIC_ScreenWidth - 72)/2, HIC_ScreenHeight - 28 - 30 - HIC_BottomHeight - 66, 72, 30)];
    self.pageNumLabel.backgroundColor = [UIColor colorWithHexString:@"#000000"];
    self.pageNumLabel.textColor = UIColor.whiteColor;
    self.pageNumLabel.font = FONT_REGULAR_14;
    self.pageNumLabel.textAlignment = NSTextAlignmentCenter;
    self.pageNumLabel.layer.cornerRadius = 15;
    self.pageNumLabel.clipsToBounds = YES;
    [self addSubview:self.pageNumLabel];
    [self makeLayout];
}

// 2. 设置数据
- (void)setDataSource:(NSArray *)dataSource {
    _dataSource = dataSource;
    [self.collectionView reloadData];
}

- (void)setCurrentIndex:(NSInteger)currentIndex {
    _currentIndex = currentIndex;
    self.pageNumLabel.text = [NSString stringWithFormat:@"%ld/%lu",(long)currentIndex + 1, (unsigned long)self.dataSource.count];
    [self scrollViewTo:currentIndex];
}

- (BOOL)isLandscape {
    return HIC_ScreenWidth > HIC_ScreenHeight;
}

- (void)relayoutWithOrentation:(BOOL)isLandscape {
    [self.collectionView reloadData];
    [self scrollViewTo:self.currentIndex];
}

#pragma mark - 页面的处理方法
- (void)scrollViewTo:(NSInteger)currentIndex {
    if (self.dataSource.count >= currentIndex + 1) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:currentIndex inSection:0];
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat offSetX = scrollView.contentOffset.x;
    NSInteger current = offSetX / HIC_ScreenWidth;
    DDLogDebug(@"offSetX=%f,HIC_ScreenWidth=%f", offSetX, HIC_ScreenWidth);
    self.currentIndex = current;
}
#pragma mark - CollectionView 数据源
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HICStudyDocPhotoDetailCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.model = [HICMediaInfoModel mj_objectWithKeyValues:self.dataSource[indexPath.row]];
    cell.controlModel = _model;
    cell.docDelegate = self;
    [cell resumeScale];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize itemSize = CGSizeMake(HIC_ScreenWidth, self.isLandscape ? HIC_ScreenHeight : HIC_ScreenHeight - HIC_NavBarAndStatusBarHeight);
    DDLogDebug(@"itemSzie W=%f,H=%f, self.height=%f", itemSize.width, itemSize.height, self.height);
    return itemSize;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsZero;
}
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    HICStudyDocPhotoDetailCell *detailCell = (HICStudyDocPhotoDetailCell *)cell;
    [detailCell resumeScale];
}

#pragma mark ----dochide代理方法
- (void)clickPic {
    if (self.isLandscape) { return; }
    
    self.hidden = YES;
    if (self.delegate && [self.delegate respondsToSelector:@selector(removeDetailViewWithIndex:)]) {
        [self.delegate removeDetailViewWithIndex:self.currentIndex];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(studyDocPhotoDetailViewDidClickedPicture)]) {
        [self.delegate studyDocPhotoDetailViewDidClickedPicture];
    }
}

#pragma mark - MakeAutoLayout
- (void)makeLayout {
    [self.pageNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).inset(28 + HIC_BottomHeight);
        make.width.mas_equalTo(72);
        make.height.mas_equalTo(30);
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.width.height.equalTo(self);
    }];
}

@end
