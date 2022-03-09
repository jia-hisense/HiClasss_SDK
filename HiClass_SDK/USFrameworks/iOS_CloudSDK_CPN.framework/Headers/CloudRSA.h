//
//  RSA.h
//  Test2
//
//  Created by WxkMac on 2017/3/8.
//  Copyright © 2017年 Wxk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CloudRSA : NSObject
+ (SecKeyRef)addPublicKey:(NSString *)key;
+ (NSString *)decryptString:(NSString *)str publicKey:(NSString *)pubKey;
+ (NSString *)encryptString:(NSString *)str publicKey:(NSString *)pubKey;
+ (NSData *)decryptData:(NSData *)data publicKey:(NSString *)pubKey;
+ (NSData *)encryptData:(NSData *)data publicKey:(NSString *)pubKey;
+ (NSData *) dataWithBase64EncodedString:(NSString *) string;

@end
