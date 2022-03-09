//
//  HICMixBaseView.h
//  HiClass
//
//  Created by WorkOffice on 2020/6/17.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OfflineTrainingListModel.h"
#import "HICMixTrainArrangeModel.h"
NS_ASSUME_NONNULL_BEGIN
@protocol HICMixTrainBaseViewDelegate <NSObject>

@optional
// 列表签到事件处理逻辑

-(void)signWithModel:(HICMixTrainArrangeListModel *)model signType:(NSInteger)signType signToSeverType:(NSInteger)severType isSignSuccess:(BOOL)isSuccess errorMsg:(NSString *__nullable)msg errorCode:(NSInteger)errorCode;

/// 早退刷新
/// @param model 当前model
/// @param isPassword 是否口令
-(void)signAgainModel:(HICMixTrainArrangeListModel *)model passWord:(BOOL)isPassword;

/// 点击查看地图信息
/// @param model 当前数据模型
-(void)clickMapViewWithModel:(HICMixTrainArrangeListModel *)model;

/// 点击cell其他事件处理 - 例如：作业、问卷、课程等
/// @param model 当前的数据模型
-(void)clickOtherButWithModel:(HICMixTrainArrangeListModel *)model;

@end

@interface HICMixBaseView : UIView
/// 数据模型
@property (nonatomic, strong) HICMixTrainArrangeListModel *model;
/// 内容背景 视图，
@property (nonatomic, strong) UIView *contentBackView;
@property (nonatomic ,assign) NSInteger index;
/// 数据模型数组
@property (nonatomic, strong) NSArray *modelDatas;
/// 代理协议
@property (nonatomic, weak) id <HICMixTrainBaseViewDelegate>delegate;

@property (nonatomic ,assign)CGFloat contentheight;
@property (nonatomic ,assign)NSInteger trainId;
///培训是否已结束
@property (nonatomic ,assign)NSInteger trainTerminated;
@property (nonatomic, copy) void(^refreshBlock)(NSInteger type);
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
-(void)setValueWith:(UILabel *__nullable)iconLabel timeLabel:(UILabel *__nullable)timeLabel but:(UIButton *__nullable)but titleLabel:(UILabel *__nullable)titleLabel commitLabel:(UILabel *__nullable)commitLabel signTypeLabel:(UILabel *__nullable)signTypeLabel againSignBut:(UIButton *__nullable)againSignBut backBut:(UIButton * __nullable)backBut progressLabel:(UILabel *__nullable)progressLabel progressView:(UIProgressView *__nullable)progressView model:(HICMixTrainArrangeListModel *)model;

/// 统一的点击事件处理
/// @param but 当前点击的but
/// @param model 对应的数据模型
/// @param type 点击类型默认值1，以后可以扩展
-(void)clickButWith:(UIButton *)but andModel:(HICMixTrainArrangeListModel *)model andType:(NSInteger)type;

/// 点击查看地图详情
/// @param model 当前model
-(void)clickMapViewWith:(HICMixTrainArrangeListModel *)model;

/// 点击刷新签到
/// @param model 当前model
-(void)clickSignAgainWith:(HICMixTrainArrangeListModel *)model;
@end

NS_ASSUME_NONNULL_END
