//
//  HICStudyShareView.h
//  HiClass
//
//  Created by Eddie Ma on 2020/2/4.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HICControlInfoModel.h"

NS_ASSUME_NONNULL_BEGIN
@protocol HICStudyShareViewDelegate <NSObject>
@optional
/// 分享
- (void)shareTo;

/// 下载
- (void)goToDownload:(HICDownloadStatus)downloadStatus type:(HICStudyBtmViewType)type;

/// 内容简介
- (void)goToContentIntro;

/// 练习题
- (void)goToPractice;

/// 相关推荐
- (void)goToRelated;

/// 添加笔记按钮点击
- (void)addNoteClicked;

/// 查阅笔记按钮点击
- (void)checkNoteClicked;

@end

@interface HICStudyShareView : UIView

@property (nonatomic, weak) id<HICStudyShareViewDelegate>delegate;

/// 更多页面
/// @param status 下载状态
/// @param type 课程或者知识
/// @param subType 知识中的类型
/// @param hasNote 是否有笔记
/// @param controlModel 哪些item要展示，哪些要隐藏。0-显示，1-隐藏
- (instancetype)initWithDownloadStatus:(HICDownloadStatus)status type:(HICStudyBtmViewType)type subType:(HICStudyResourceType)subType hasNote:(BOOL)hasNote itemsShow:(HICControlInfoModel *)controlModel hasExercise:(BOOL)hasExercise hasRelated:(BOOL)hasRelated andMediaId:(NSNumber *)mediaId;

- (void)updateDownloadStatus:(HICDownloadStatus)status andProcess:(CGFloat)percent;

- (void)hideShareView;

- (void)hasNote:(BOOL)hasNote;

@end

NS_ASSUME_NONNULL_END
