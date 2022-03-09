//
//  AlbumsTableViewCell.h
//  HiClass
//
//  Created by Eddie Ma on 2020/1/14.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AlbumsTableViewCell : UITableViewCell

- (void)setDataWith:(NSString *)title photo:(UIImage *)img amount:(NSUInteger)amount showPicked:(BOOL)show;

@end

NS_ASSUME_NONNULL_END
