//
//  SearchRecommendCell.h
//  iTest
//
//  Created by Sir_Jing on 2020/3/16.
//  Copyright © 2020 Sir_Jing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 热门 - 历史 通用Cell
@interface SearchRecommendCell : UICollectionViewCell

@property (nonatomic, strong) NSDictionary *model;


/// 获取标题的高度
/// @param str 标题文字
+(CGFloat)getTitleLabelHeightWith:(NSString *)str;

@end

NS_ASSUME_NONNULL_END
