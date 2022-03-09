//
//  HICCommentPopupView.h
//  HiClass
//
//  Created by Eddie_Ma on 17/2/20.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HICCommentPopupView : UIView

@property (nonatomic, strong) UIView *onView;

/// 弹窗式评论
/// @param videoSectionHeight 距离视频的高度
/// @param isFromCourse 是课程还是详情
/// @param identifier 课程或详情的id
- (instancetype)initWithVideoSectionHeight:(CGFloat)videoSectionHeight isFromCourse:(BOOL)isFromCourse identifier:(NSString *)identifier;

@end

NS_ASSUME_NONNULL_END
