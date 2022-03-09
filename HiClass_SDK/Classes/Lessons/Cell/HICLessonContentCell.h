//
//  HICLessonContentCell.h
//  HiClass
//
//  Created by WorkOffice on 2020/2/4.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HICAuthorModel.h"
#import "HICBaseInfoModel.h"
NS_ASSUME_NONNULL_BEGIN
@protocol HICLessonContentDelegate <NSObject>
@optional
- (void)extensionClicked:(NSString *)title;
- (void)jumpToContributor:(HICAuthorModel *)authorModel;
@end
@interface HICLessonContentCell : UITableViewCell
@property (nonatomic,strong)HICBaseInfoModel *baseModel;
@property (nonatomic,weak)id<HICLessonContentDelegate>extensionDelegate;
@property (nonatomic,strong)NSString *title;
@end

NS_ASSUME_NONNULL_END
