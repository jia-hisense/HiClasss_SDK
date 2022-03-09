//
//  HomewrokRecordView.h
//  HiClass
//
//  Created by 铁柱， on 2020/3/27.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class HomewrokRecordView;
@protocol HomeworkRecordViewDelegate <NSObject>

/// 录音页面发送语音到前端
/// @param view 当前视图
/// @param voiceName 录音名称
/// @param voicePath 录音路径
/// @param data 扩展数据
-(void)recordView:(HomewrokRecordView *)view sendVoiceName:(NSString *_Nullable)voiceName voicePath:(NSString *_Nullable)voicePath other:(id _Nullable)data;

@end

@interface HomewrokRecordView : UIView

@property (nonatomic, assign) NSInteger maxSeconds;

@property (nonatomic, weak) id <HomeworkRecordViewDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
