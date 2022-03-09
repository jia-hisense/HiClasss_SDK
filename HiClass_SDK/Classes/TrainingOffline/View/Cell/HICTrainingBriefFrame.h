//
//  HICTrainingBriefFrame.h
//  HiClass
//
//  Created by hisense on 2020/4/16.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HICTrainingInfoModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface HICTrainingBriefData : NSObject
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString * _Nullable time;
@property (nonatomic, strong) NSString *brief;

- (instancetype)initWithTitle:(NSString *)title time:(NSString * _Nullable)time brief:(NSString *)brief;
@end



@interface HICTrainingBriefFrame : NSObject


@property (nonatomic, strong) HICTrainingBriefData *data;

@property (nonatomic, assign) BOOL isOpened;


@property (nonatomic, assign, readonly) CGRect titleLblF;
@property (nonatomic, assign, readonly) CGRect timeLblF;
@property (nonatomic, assign, readonly) CGRect briefLblF;

@property (nonatomic, assign, readonly) CGRect openBtnF;
@property (nonatomic, assign, readonly) CGRect shrinkBtnF;

@property (nonatomic, assign, readonly) CGRect separatorLineViewF;

@property (nonatomic, assign, readonly) CGFloat cellHeight;


- (instancetype)initWithData:(HICTrainingBriefData *)data isOpened:(BOOL)isOpened;

@end

NS_ASSUME_NONNULL_END
