//
//  HICHomeStudyLastRecordView.h
//  HiClass
//
//  Created by jiafujia on 2021/6/8.
//  Copyright © 2021 hisense. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HICHomeStudyLastRecordViewDelegate <NSObject>

- (void)continueLearnLastRecord;

@end

@interface HICHomeStudyLastRecordView : UIView

@property (nonatomic, weak)id<HICHomeStudyLastRecordViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame recordTitle:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
