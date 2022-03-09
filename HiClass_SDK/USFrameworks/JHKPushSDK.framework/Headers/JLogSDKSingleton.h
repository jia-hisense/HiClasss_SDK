//
//  JLogSDKSingleton.h
//  iOSDataSDK
//
//  Created by keep on 2018/1/8.
//  Copyright © 2018年 keep. All rights reserved.
//

#ifndef JLogSDKSingleton_h
#define JLogSDKSingleton_h

// @interface
#define singleton_interface(className) \
+ (className *)shared;


// @implementation
#define singleton_implementation(className) \
static className *_instance; \
+ (id)allocWithZone:(NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [super allocWithZone:zone]; \
}); \
return _instance; \
} \
+ (className *)shared \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [[self alloc] init]; \
}); \
return _instance; \
}

#endif /* iLogSDKSingleton_h */
