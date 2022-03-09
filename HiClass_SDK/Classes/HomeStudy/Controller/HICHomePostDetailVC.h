//
//  HICHomePostDetailVC.h
//  iTest
//
//  Created by Sir_Jing on 2020/3/18.
//  Copyright © 2020 Sir_Jing. All rights reserved.
//

#import "DCPagerController.h"

NS_ASSUME_NONNULL_BEGIN

@interface HICHomePostDetailVC : DCPagerController

@property (nonatomic, copy) NSString *titleName;
///// 用于岗位要求请求
@property (nonatomic, assign) NSInteger trainPostId;
//岗位路线id
@property (nonatomic ,assign) NSInteger wayId;
//岗位地图id
@property (nonatomic ,strong) NSNumber *postLineId;
@end

NS_ASSUME_NONNULL_END
