//
//  HICTrainManager.h
//  HiClass
//
//  Created by WorkOffice on 2020/3/5.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HICTrainManager : NSObject
///培训列表页的contensizeW
@property (nonatomic, assign) CGFloat contentSizeW;
@property (nonatomic, assign) CGFloat offlineContentSizeW;
+(instancetype)shared;
@end

NS_ASSUME_NONNULL_END
