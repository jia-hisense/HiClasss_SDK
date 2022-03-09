//
//  HICExamManager.h
//  HiClass
//
//  Created by Eddie Ma on 2020/2/20.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface HICExamManager : NSObject

/// 是否开始考试
@property (nonatomic, assign) BOOL startExam;
@property (nonatomic, strong) WKWebView *webviewVC;

///考试列表页的contensizeW
@property (nonatomic, assign) CGFloat contentSizeW;
+ (instancetype)shared;

@end

NS_ASSUME_NONNULL_END
