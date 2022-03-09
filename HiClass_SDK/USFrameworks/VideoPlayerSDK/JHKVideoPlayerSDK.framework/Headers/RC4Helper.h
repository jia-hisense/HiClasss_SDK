//
//  RC4Helper.h
//  Base64+rc4
//
//  Created by Belinda on 2019/7/10.
//  Copyright © 2019年 com.hisense. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RC4Helper : NSObject

/**
 RC4解码

 @param data NSString
 @param key NSString
 @return NSString
 */
+ (NSString *)decode:(NSString *)data key:(NSString *)key;

@end

