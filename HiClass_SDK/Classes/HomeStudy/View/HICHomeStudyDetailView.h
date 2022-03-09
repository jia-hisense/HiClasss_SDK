//
//  HICHomeStudyDetailView.h
//  iTest
//
//  Created by Sir_Jing on 2020/3/10.
//  Copyright © 2020 Sir_Jing. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HICHomeStudyModel.h"
#import "HICHomeStudyClassModel.h"

#import "HICHomeTaskCenterVC.h"
#import "HICHomeStudyNavView.h"
#import "HICLiveListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HICHomeStudyDetailView : UIViewController

/// 数据源
@property (nonatomic, strong) NSArray *homeDataSource;

/// 网络请求地址可以使用
@property (nonatomic, copy) NSString *urlStr;

/// 知识详情页请求数据ID
@property (nonatomic, assign) NSInteger resourceID;
@property (nonatomic ,strong)HICHomeStudyNavView *homeNavi;

@end

NS_ASSUME_NONNULL_END
