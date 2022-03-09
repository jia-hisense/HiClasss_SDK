//
//  HICHomeStudyNavView.h
//  iTest
//
//  Created by Sir_Jing on 2020/3/9.
//  Copyright © 2020 Sir_Jing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MessageNumModel : NSObject

@property (nonatomic, assign) NSInteger count;

@property (nonatomic, assign) NSInteger status;

@end

typedef void(^ClickButBolick)(UIView *clickView);

@interface HICHomeStudyNavView : UIView

/// 没有任何反应事件
-(instancetype)initDefault;

/// 返回数据
-(instancetype)initDefaultWithClickScan:(ClickButBolick)clickScan clickSearchText:(ClickButBolick)clickSearchText clickMessage:(ClickButBolick)clickMessage;

/// 是否正在刷新数据 -- 控制数据请求的
@property (nonatomic, assign, readonly) BOOL isRefreshNum;
/// 刷新消息的Num数量
-(void)loadDataMessageNum;

@end

NS_ASSUME_NONNULL_END
