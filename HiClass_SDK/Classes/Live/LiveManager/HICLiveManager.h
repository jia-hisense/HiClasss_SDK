//
//  HICLiveManager.h
//  HiClass
//
//  Created by hisense on 2020/8/18.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HICLiveManager : NSObject
@property (nonatomic, assign) CGFloat contentSizeW;
@property (nonatomic, assign) CGFloat offlineContentSizeW;
+(instancetype)shared;
@end

NS_ASSUME_NONNULL_END
