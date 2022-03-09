//
//  PhotoCollectionViewCell.h
//  HiClass
//
//  Created by Eddie Ma on 2020/1/14.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PhotoCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *photoIV;
@property (nonatomic, strong) UIImageView *selectedIV;
@property (nonatomic, strong) UIImageView *unselectedIV;
@property (nonatomic, strong) UIView *coverView;

- (void)setData:(UIImage*)img index:(NSInteger)index selectedArry:(NSArray *)arr;
- (void)showUnselectedView:(BOOL)show;
- (BOOL)unSelectedImg;
@end
NS_ASSUME_NONNULL_END
