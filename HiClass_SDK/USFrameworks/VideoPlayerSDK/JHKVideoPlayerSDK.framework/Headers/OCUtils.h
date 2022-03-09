//
//  OCUtils.h
//  JHKVideoPlayerSDK
//
//  Created by Belinda on 2019/4/12.
//  Copyright © 2019年 com.hisense. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OCUtils : NSObject

/**
 添加防盗链

 @param path NSString
 @return NSString
 */
+ (NSString *)updateDownLoadPath:(NSString *)path;


/**
 判断是否iPhoneX

 @return 返回结果
 */
+ (BOOL)isiPhoneX;

@end

NS_ASSUME_NONNULL_END
