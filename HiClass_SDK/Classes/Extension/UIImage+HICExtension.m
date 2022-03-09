//
//  UIImage+HICExtension.m
//  HiClass
//
//  Created by Eddie Ma on 2020/2/13.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "UIImage+HICExtension.h"

@implementation UIImage (HICExtension)

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (void)load {
    Method imageNamed = class_getClassMethod(self, @selector(imageNamed:));
    Method hicImageNamed = class_getClassMethod(self, @selector(imageInHiClassSDKBundle:));
    method_exchangeImplementations(imageNamed, hicImageNamed);
}

+ (UIImage *)imageInHiClassSDKBundle:(NSString *)name {
    UIImage *image = [UIImage imageInHiClassSDKBundle:name];
    if (!image) {
        NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"HiClass_SDK" ofType:@"bundle"]];
        image = [UIImage imageNamed:name inBundle:bundle compatibleWithTraitCollection:nil];
    }
    return image;
}

@end
