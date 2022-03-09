//
//	IntegralTaskModel.m
//
//	Create by <#Creator#> on 17/11/2021
//	Copyright (c) 2021 <#Creator#>. All rights reserved.
//	*****************************接口调试工具*************************
//	Github源码: https://github.com/love-my-life/URLToModelUtil 欢迎提出改进建议
//	****************************************************************


#import <UIKit/UIKit.h>
#import "IntegralTaskListModel.h"

@interface IntegralTaskModel : NSObject

@property (nonatomic, strong) NSArray<IntegralTaskListModel*> * dailyTasklist;
@property (nonatomic, strong) NSArray<IntegralTaskListModel*> * recoTaskList;

@end
