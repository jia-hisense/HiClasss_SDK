//
//  CompanyKnowledgeMenuView.h
//  iTest
//
//  Created by Sir_Jing on 2020/3/12.
//  Copyright © 2020 Sir_Jing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class CompanyKnowledgeMenuView;
@protocol CompanyKnowledgeMenuViewDelegate <NSObject>
@optional

/// 菜单栏更改选项方法
/// @param view 当前的菜单
/// @param soreId 课程分类的ID
/// @param type 类型的选择(可以为负值)
/// @param time 时间的选择顺序 0:按时间；1:按更新；2:
-(void)menuView:(CompanyKnowledgeMenuView *)view changeMenuItemWith:(NSInteger)soreId andSoreStrId:(NSString*)soreStr selectType:(NSInteger)type selectTime:(NSInteger)time;

@end

@interface CompanyKnowledgeMenuView : UIView

@property (nonatomic, strong) NSArray *dataSource;

@property (nonatomic, weak) id <CompanyKnowledgeMenuViewDelegate> delegate;

@property (nonatomic, assign) BOOL isNotEnableTypeClick;

@property (nonatomic, assign) BOOL isHiddenSoreView;

-(void)addContentViewWithParentView:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
