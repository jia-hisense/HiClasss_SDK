//
//  NSString+HICUtilities.m
//  HiClass
//
//  Created by Eddie Ma on 2020/1/2.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "NSString+HICUtilities.h"
#import <Security/Security.h>
#import <CocoaLumberjack/CocoaLumberjack.h>
@implementation NSString (HICUtilities)

+ (BOOL)isValidStr:(NSString *)str {
    if (str == nil || [str isEqual:[NSNull null]] || str == NULL || [str isEqual:@""] || [str isEqual:@"(null)"] || [str isEqual:@"（null）"] || [str isEqual:@"(Null)"] || [str isEqual:@"（Null）"]|| [str isEqualToString:@"null"] || [str isEqualToString:@"<null>"] || str == nil)
        return NO;
    else
        return YES;
}

+ (BOOL)isPhoneNum:(NSString *)phone {
    if (phone.length <= 2) {
        DDLogDebug(@"[HIC][NSString] Phone Num: %@ lengh <= 2", phone);
        return NO;
    }
    NSString *firstBit = [phone substringToIndex:1];
    NSString *thirdBit = [phone substringToIndex:3];
    if ((phone.length == 11 && [firstBit isEqualToString:@"1"]) || ([thirdBit isEqualToString:@"861"] && phone.length == 13)) {
        NSString *pattern = @"^[10]+[23456789]+\\d{9}";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF  MATCHES %@",pattern];
        return [pred evaluateWithObject:phone];
    } else {
        return NO;
    }
}

+ (BOOL)isValidPass:(NSString *)pass {
    return YES;
}

+ (BOOL)isM3U8URL:(NSString *)url {
    if ([url containsString:@".m3u8"]) {
        return YES;
    }
    return NO;
}

+ (BOOL)isTSFile:(NSString *)str {
    if ([str containsString:@".ts"]) {
        return YES;
    }
    return NO;
}

+ (NSString *)fileSizeWith:(CGFloat)size {
    if (size >= 1024*1024*1024) {
        return [NSString stringWithFormat:@"%.1fG",size/(1024*1024*1024)];
    } else if (size >= 1024*1024) {
        return [NSString stringWithFormat:@"%.1fM",size/(1024*1024)];
    } else if (size > 1024){
        return [NSString stringWithFormat:@"%.0fK",size/1024];
    } else if (size > 0){
        return [NSString stringWithFormat:@"%.0fB",size];
    } else {
        return @"";
    }
}

- (NSNumber *)toNumber {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber *numTemp = [numberFormatter numberFromString:self];
    return numTemp;
}
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize
{
//    if (self.length <= 0) {
//        CGSize sizee = CGSizeMake(0.01f, 0.01f);
//        return sizee;
//    }else{
        NSDictionary *attrs = @{NSFontAttributeName : font};
        return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
//    }
}
@end
