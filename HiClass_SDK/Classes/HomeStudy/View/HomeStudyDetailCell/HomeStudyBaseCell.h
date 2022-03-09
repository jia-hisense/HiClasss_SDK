//
//  HomeStudyBaseCell.h
//  iTest
//
//  Created by Sir_Jing on 2020/3/10.
//  Copyright © 2020 Sir_Jing. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HICHomeStudyModel.h"
#import "HICHomeStudyClassModel.h"

NS_ASSUME_NONNULL_BEGIN
@class HomeStudyBaseCell;
@protocol HomeStudyBaseCellDelegate <NSObject>
@optional
/// 点击首页cell事件
/// @param cell 当前cell
/// @param item 对应的数据
/// @param data 扩展字段(方便传递其他参数)
-(void)studyCell:(HomeStudyBaseCell *)cell onTap:(ResourceListItem *)item other:(id _Nullable)data;

/// cell上点击事件处理 - 任务
/// @param cell 当前cell
/// @param but 点击的按钮
/// @param model 返回的数据模型
/// @param type 点击事件类型 -- 默认先传0 以后方便扩展
-(void)studyCell:(HomeStudyBaseCell *)cell clickOtherBut:(UIButton * _Nullable)but model:(id _Nullable)model type:(NSInteger)type;

/// cell上点全部的点击事件处理
/// @param cell 当前cell
/// @param but 点击的按钮
/// @param model 返回的数据模型
/// @param type 点击事件类型 -- 默认先传0 以后方便扩展
-(void)studyCell:(HomeStudyBaseCell *)cell clickMoreBut:(UIButton * _Nullable)but model:(HICHomeStudyModel * _Nullable)model type:(NSInteger)type;

/// 首页知识列表的点击事件
/// @param cell 当前cell
/// @param item 对应的数据
/// @param data 扩展字段(方便传递其他参数)
-(void)studyCell:(HomeStudyBaseCell *)cell clickItem:(HICHomeStudyClassModel *)item other:(id _Nullable)data;

/// 企业知识列表的点击事件
/// @param cell 当前cell
/// @param model 对应的数据
/// @param data 扩展字段(方便传递其他参数)
-(void)studyCell:(HomeStudyBaseCell *)cell knoledgeModel:(HSCourseKLD *)model other:(id _Nullable)data;

@end

@interface HomeStudyBaseCell : UITableViewCell

/// 当前cell的IndexPath -- 扩展用的
@property (nonatomic, strong) NSIndexPath *cellIndexPath;
/// 首页展示数据模型
@property (nonatomic, strong) HICHomeStudyModel *homeStudyModel;
/// 首页知识列表数据模型
@property (nonatomic, strong) HICHomeStudyClassModel *studyClassModel;
/// 企业知识列表数据模型
@property (nonatomic, strong) HSCourseKLD *companyKnoledgeModel;
/// 首页推荐位上的知识列表模型
@property (nonatomic, strong) ResourceListItem *itemModel;

/// 协议方法
@property (nonatomic, weak) id <HomeStudyBaseCellDelegate> delegate;

-(UIView *)createClassBackView:(UIView *)backView;

@end

NS_ASSUME_NONNULL_END
