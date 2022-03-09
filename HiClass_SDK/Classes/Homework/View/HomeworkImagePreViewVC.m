//
//  HomeworkImagePreViewVC.m
//  HiClass
//
//  Created by 铁柱， on 2020/4/1.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HomeworkImagePreViewVC.h"

@interface HomeworkImagePreViewVC ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation HomeworkImagePreViewVC

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self.view addSubview:self.collectionView];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.attachDataSource.count != 0 && self.attachDataSource.count - 1 >= _currentIndex) {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }else if (self.imageDataSource.count != 0  && self.imageDataSource.count-1>=_currentIndex) {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    if (self.attachDataSource) {
        return self.attachDataSource.count;
    }
    if (self.imageDataSource) {
        return self.imageDataSource.count;
    }
    if (self.previewDownImages) {
        return self.previewDownImages.count;
    }
    if (self.previewWithImageName) {
        return 1;
    }
    return 0;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HomeworkImagePreviewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];

    if (self.attachDataSource) {
        cell.attModel = [self.attachDataSource objectAtIndex:indexPath.row];
    }else if (self.imageDataSource) {
        cell.imageModel = [self.imageDataSource objectAtIndex:indexPath.row];
    }else if (self.previewDownImages) {
        cell.imagePath = [self.previewDownImages objectAtIndex:indexPath.row];
    }else if (self.previewWithImageName) {
        cell.imageName = self.previewWithImageName;
    }
    

    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self dismissViewControllerAnimated:YES completion:^{

    }];
}

-(void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    //

}



#pragma mark - 懒加载
-(UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.itemSize = CGSizeMake(HIC_ScreenWidth, HIC_ScreenHeight);
        layout.minimumLineSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, HIC_ScreenWidth, HIC_ScreenHeight) collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.pagingEnabled = YES;
        [_collectionView registerClass:HomeworkImagePreviewCell.class forCellWithReuseIdentifier:@"cell"];
    }
    return _collectionView;
}

@end
