//
//  NSData+JLogSDKExtension.h
//  AFNetworking
//
//  Created by keep on 2018/1/26.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>

@interface NSData (JLogSDKExtension)

/**
 *  根据CCOperation，确定加密还是解密
 *
 *  @param operation kCCEncrypt -> 加密  kCCDecrypt－>解密
 *  @param key       公钥
 *  @param iv        偏移量
 *
 *  @return 加密或者解密的NSData
 */
- (NSData *)AES128Operation:(CCOperation)operation key:(NSString *)key iv:(NSString *)iv;

/** gzip解压 */
+ (NSData *)uncompressZippedData:(NSData *)compressedData;

/** gzip压缩 */
+ (NSData *)gzipData:(NSData *)pUncompressedData;

@end
