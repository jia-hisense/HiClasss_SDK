//
//  PhotoVideoPickerCell.h
//  HsShare3.5
//
//  Created by wangggang on 2019/10/26.
//  Copyright © 2019 com.hisense. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

#define phCollectionCellSection 3
#define phCollectionCellInteritemSpacing 7.5
#define phCollectionCellHeight (HIC_ScreenWidth-(phCollectionCellSection+1)*phCollectionCellInteritemSpacing)/phCollectionCellSection

@interface PhotoVideoPickerCell : UICollectionViewCell


@property (nonatomic, strong) NSIndexPath *cellIndexPath;

@property (nonatomic, strong) PHAsset *asset;

@property (nonatomic, assign) BOOL isSelectBut;

@property (nonatomic, copy) void(^clickSelectBut)(BOOL isSelect, NSIndexPath *cellIndexPath, NSString *filePath, NSInteger durat, CGFloat ratio);

-(void)clickCellPlayVideo:(UIViewController *)vc;


@end

NS_ASSUME_NONNULL_END
