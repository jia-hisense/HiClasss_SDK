//
//  HICOfflineClassTaskFrame.h
//  HiClass
//
//  Created by hisense on 2020/4/26.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HICSubTask.h"

NS_ASSUME_NONNULL_BEGIN

@interface HICOfflineTextAttribute : NSObject
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIFont *textFont;
@property (nonatomic, strong) NSString *value;

@property (nonatomic, assign) BOOL  isBtnEnable;

@end


@interface HICOfflineClassTaskFrame : NSObject

@property (nonatomic, assign) BOOL isSeparatorHidden;

@property (nonatomic, strong) HICSubTask *task;




@property (nonatomic, strong, nullable) HICOfflineTextAttribute *typeLblAtt;
@property (nonatomic, strong, nullable) HICOfflineTextAttribute *titleLblAtt;
@property (nonatomic, strong, nullable) HICOfflineTextAttribute *operateBtnAtt;
@property (nonatomic, strong, nullable) HICOfflineTextAttribute *timeLblAtt;
@property (nonatomic, strong, nullable) HICOfflineTextAttribute *locationLblAtt;
@property (nonatomic, strong, nullable) HICOfflineTextAttribute *bottomMapBtnAtt;
@property (nonatomic, strong, nullable) HICOfflineTextAttribute *bottomTimeBtnAtt;


/// 控件的透明度
@property (nonatomic, assign) CGFloat alpha;


@property (nonatomic, assign, readonly) CGRect typeLblF;
@property (nonatomic, assign, readonly) CGRect titleLblF;
@property (nonatomic, assign, readonly) CGRect operateBtnF;
@property (nonatomic, assign, readonly) CGRect timeLblF;
@property (nonatomic, assign, readonly) CGRect locationLblF;
@property (nonatomic, assign, readonly) CGRect bottomMapBtnF;
@property (nonatomic, assign, readonly) CGRect bottomTimeBtnF;
@property (nonatomic, assign, readonly) CGRect separatorLineViewF;
@property (nonatomic, assign, readonly) CGFloat cellHeight;



+ (instancetype)initWithTask:(HICSubTask *)task isSeparatorHidden:(BOOL)isSeparatorHidden alpha:(CGFloat)alpha;
@end

NS_ASSUME_NONNULL_END
