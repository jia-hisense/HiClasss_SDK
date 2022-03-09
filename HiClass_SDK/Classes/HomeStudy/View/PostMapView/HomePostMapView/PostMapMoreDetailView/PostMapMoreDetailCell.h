//
//  PostMapMoreDetailCell.h
//  iTest
//
//  Created by Sir_Jing on 2020/3/17.
//  Copyright © 2020 Sir_Jing. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HICPostMapMoreModel.h"

NS_ASSUME_NONNULL_BEGIN

@class PostMapMoreDetailCell;
@protocol PostMapMoreDetailCellDelegate <NSObject>


/// 点击整个cell的回调方法
/// @param cell 当前cell
/// @param but 点击的but
/// @param data 数据模型数据
/// @param other 其他扩展数据
-(void)moreDetailCell:(PostMapMoreDetailCell *)cell didClickBut:(UIButton  * _Nullable )but dataSource:(id _Nullable)data other:(id _Nullable)other;

@end

@interface PostMapMoreDetailCell : UITableViewCell

@property (nonatomic, weak) id <PostMapMoreDetailCellDelegate> delegate;

@property (nonatomic, strong) MapMoreInfoModel *infoModel;

@end

NS_ASSUME_NONNULL_END
