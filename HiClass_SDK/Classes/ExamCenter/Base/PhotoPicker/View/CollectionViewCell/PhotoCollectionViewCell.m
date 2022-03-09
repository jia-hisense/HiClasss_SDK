//
//  PhotoCollectionViewCell.m
//  HiClass
//
//  Created by Eddie Ma on 2020/1/14.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "PhotoCollectionViewCell.h"

@implementation PhotoCollectionViewCell


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self creatUI];
    }
    return self;
}

- (void)creatUI {
    // 相册相片
    self.photoIV = [[UIImageView alloc] init];
    self.photoIV.frame = CGRectMake(0, 0, PH_COLLECTION_CELL_HEIGHT, PH_COLLECTION_CELL_HEIGHT);
    self.photoIV.backgroundColor = [UIColor redColor];
    self.photoIV.contentMode = UIViewContentModeScaleAspectFill;
    self.photoIV.clipsToBounds = YES;
    [self.contentView addSubview:self.photoIV];

    // 选择后遮罩层
    self.coverView = [[UIView alloc] init];
    self.coverView.frame = CGRectMake(0, 0, PH_COLLECTION_CELL_HEIGHT, PH_COLLECTION_CELL_HEIGHT);
    self.coverView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.5];
    self.coverView.hidden = YES;
    [self.photoIV addSubview:self.coverView];

    // 未选择图片
    self.unselectedIV = [[UIImageView alloc] init];
    self.unselectedIV.frame = CGRectMake(PH_COLLECTION_CELL_HEIGHT - 28, 0, 28, 28);
    self.unselectedIV.image = [UIImage imageNamed:@"photo_unpick"];
    self.unselectedIV.hidden = YES;
    [self.photoIV addSubview:self.unselectedIV];
    // 已选图片
    self.selectedIV = [[UIImageView alloc] init];
    self.selectedIV.frame = CGRectMake(PH_COLLECTION_CELL_HEIGHT - 28, 0, 28, 28);
    self.selectedIV.image = [UIImage imageNamed:@"photo_picked"];
    self.selectedIV.hidden = YES;
    [self.coverView addSubview:self.selectedIV];


}

- (void)setData:(UIImage *)img index:(NSInteger)index selectedArry:(NSArray *)arr {
    // 相册相片
    self.photoIV.image = img;
    if (arr.count > 0) {
        for (NSString *indexStr in arr) {
            if ([[NSString stringWithFormat:@"%ld", (long)index] isEqualToString:indexStr]) {
                self.photoIV.tag = -(200000 + index);
                self.unselectedIV.hidden = YES;
                self.coverView.hidden = NO;
                self.selectedIV.hidden = NO;
                break;
            } else {
                self.photoIV.tag = 200000 + index;
                self.unselectedIV.hidden = NO;
                self.coverView.hidden = YES;
                self.selectedIV.hidden = YES;
            }
        }
    } else {
        // 未选择
        self.photoIV.tag = 200000 + index;
        self.unselectedIV.hidden = NO;
        self.coverView.hidden = YES;
        self.selectedIV.hidden = YES;
    }
}

- (void)showUnselectedView:(BOOL)show {
    self.unselectedIV.hidden = !show;
    self.selectedIV.hidden = show;
    self.coverView.hidden = show;
    self.photoIV.tag =  - self.photoIV.tag;
}

- (BOOL)unSelectedImg {
    if (self.photoIV.tag > 0) {
        return YES;
    }
    return NO;
}

@end
