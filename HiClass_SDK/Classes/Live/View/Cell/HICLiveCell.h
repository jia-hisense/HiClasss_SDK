//
//  HICLiveCell.h
//  HiClass
//
//  Created by hisense on 2020/8/18.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HICLiveListModel.h"

NS_ASSUME_NONNULL_BEGIN
@protocol HICLiveCellDelegate <NSObject>

- (void)playBackWithParams:(NSString *)params andMediaId:(NSNumber *)mediaId andMediaName:(NSString *)name;

@end
@interface HICLiveCell : UITableViewCell

@property (nonatomic, strong)HICLivePlayBackInfo *backModel;
@property (nonatomic, assign)BOOL isAll;
@property (nonatomic, weak)id<HICLiveCellDelegate>cellDelegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;

- (void)setBorderStyleWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;

- (void)loadData:(HICLiveListModel *)model;

@end

NS_ASSUME_NONNULL_END
