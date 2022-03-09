//
//  HICStudyVideoPlayRelatedListVC.h
//  iTest
//
//  Created by Sir_Jing on 2020/2/5.
//  Copyright © 2020 Sir_Jing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HICStudyVideoPlayRelatedListVC : UIViewController
@property (nonatomic,strong)NSNumber *objectId;
@property (nonatomic,strong)NSNumber *objectType;
@property (nonatomic, strong)UITableView *tableView;
@end

NS_ASSUME_NONNULL_END
