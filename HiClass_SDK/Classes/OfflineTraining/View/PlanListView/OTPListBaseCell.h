//
//  OTPListBaseCell.h
//  HiClass
//
//  Created by 铁柱， on 2020/4/16.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "OfflineTrainingListModel.h"

NS_ASSUME_NONNULL_BEGIN
@class OTPListBaseCell;
@protocol OTPListBaseCellDelegate <NSObject>

@optional
// 列表签到事件处理逻辑

/// 签到/退的事件处理
/// @param cell 当前cell
/// @param model 当前的数据模型
/// @param signType 签到/退类型 1：签到 2：签退
/// @param severType 签到/退是按什么签到/退 1：位置签 2：口令签 3：什么都没有
/// @param isSuccess 是否成功
/// @param msg 错误信息
/// @param errorCode 错误code 1：位置错误 2：时间错误 3：早退
-(void)listBaseCell:(OTPListBaseCell *)cell signModel:(OfflineTrainingListModel *)model signType:(NSInteger)signType signToSeverType:(NSInteger)severType isSignSuccess:(BOOL)isSuccess errorMsg:(NSString *__nullable)msg errorCode:(NSInteger)errorCode;

/// 早退刷新
/// @param cell 当前cell
/// @param model 当前model
/// @param isPassword 是否口令
-(void)listBaseCell:(OTPListBaseCell *)cell signAgainModel:(OfflineTrainingListModel *)model passWord:(BOOL)isPassword;

/// 点击查看地图信息
/// @param cell 当前cell
/// @param model 当前数据模型
-(void)listBaseCell:(OTPListBaseCell *)cell clickMapViewWithModel:(OfflineTrainingListModel *)model;

/// 点击cell其他事件处理 - 例如：作业、问卷、课程等
/// @param cell 当前cell
/// @param model 当前的数据模型
-(void)listBaseCell:(OTPListBaseCell *)cell clickOtherButWithModel:(OfflineTrainingListModel *)model;

@end

/// 基本列表信息 -- 基础高度 52， 剩下的需要计算 内容高度  104.5 和 82.5间隙12的组合高度
@interface OTPListBaseCell : UITableViewCell
// 颜色数组 0：当前颜色；1：非当前时间
@property (nonatomic, strong) NSArray<UIColor *> *circleColors;
@property (nonatomic, strong) NSArray<UIColor *> *allTimeLabelColors;

/// 圆圈的 -- 设置颜色
@property (nonatomic, strong) CAShapeLayer *circleLayer;
/// 设置cell的时间label
@property (nonatomic, strong) UILabel *timeCellLabel;

/// 内容背景 视图，
@property (nonatomic, strong) UIView *contentBackView;

@property (nonatomic, strong) NSIndexPath *cellIndexPath;

/// 数据模型数组
@property (nonatomic, strong) NSArray *modelDatas;

/// 代理协议
@property (nonatomic, weak) id <OTPListBaseCellDelegate>delegate;

/// 获取时间段的方法
-(NSString *)getTimeFormate:(NSInteger)startTime andEndTime:(NSInteger)endTime;

/// 只返回时分秒的方法
-(NSString *)getHoserTimeStringWith:(NSInteger)time;

/// 统一设置，这样可以做到修改一个地方其他地方都能得到修改
/// @param iconLabel 标签
/// @param timeLabel 时间字段
/// @param but 状态按钮
/// @param titleLabel 标题
/// @param commitLabel 底部的扩展label
/// @param signTypeLabel 签到/退的时间
/// @param againSignBut 签退的刷新
/// @param backBut item背景的but
/// @param model 赋值model
-(void)setValueWith:(UILabel *__nullable)iconLabel timeLabel:(UILabel *__nullable)timeLabel but:(UIButton *__nullable)but titleLabel:(UILabel *__nullable)titleLabel commitLabel:(UILabel *__nullable)commitLabel signTypeLabel:(UILabel *__nullable)signTypeLabel againSignBut:(UIButton *__nullable)againSignBut backBut:(UIButton * __nullable)backBut model:(OfflineTrainingListModel *)model;

/// 统一的点击事件处理
/// @param but 当前点击的but
/// @param model 对应的数据模型
/// @param type 点击类型默认值1，以后可以扩展
-(void)clickButWith:(UIButton *)but cell:(OTPListBaseCell *)cell andModel:(OfflineTrainingListModel *)model andType:(NSInteger)type;

/// 点击查看地图详情
/// @param model 当前model
/// @param cell 当前cell
-(void)clickMapViewWith:(OfflineTrainingListModel *)model andCell:(OTPListBaseCell *)cell;

/// 点击刷新签到
/// @param model 当前model
/// @param cell 当前cell
-(void)clickSignAgainWith:(OfflineTrainingListModel *)model andCell:(OTPListBaseCell *)cell;

@end

NS_ASSUME_NONNULL_END
