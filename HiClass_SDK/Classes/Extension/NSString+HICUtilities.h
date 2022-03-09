//
//  NSString+HICUtilities.h
//  HiClass
//
//  Created by Eddie Ma on 2020/1/2.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (HICUtilities)

+ (BOOL)isValidStr:(NSString *)str;
+ (BOOL)isPhoneNum:(NSString *)phone;
+ (BOOL)isValidPass:(NSString *)pass;
+ (BOOL)isM3U8URL:(NSString *)url;
+ (BOOL)isTSFile:(NSString *)str;
+ (NSString *)fileSizeWith:(CGFloat)size;
- (NSNumber *)toNumber;
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;
@end

NS_ASSUME_NONNULL_END
