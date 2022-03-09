//
//  HICMyCommentCell.h
//  HiClass
//
//  Created by Eddie Ma on 2020/2/20.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HICMyCommentsModel.h"
NS_ASSUME_NONNULL_BEGIN
@protocol HICMyCommentsDelegate <NSObject>
- (void)deleteClick:(NSNumber *)commentsId andType:(NSString *)type andIndexPath:(NSIndexPath *)indexPath;
@end
@interface HICMyCommentCell : UITableViewCell
@property (nonatomic ,weak)id<HICMyCommentsDelegate>commentDelegate;
@property (nonatomic ,strong)HICMyCommentsModel *model;
@property (nonatomic ,strong) NSIndexPath *indexPath;
@end

NS_ASSUME_NONNULL_END
