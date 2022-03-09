//
//  JLogSDKInterfaceManager.h
//  iOSDataSDK
//
//  Created by keep on 2018/1/8.
//  Copyright © 2018年 keep. All rights reserved.
//


#import "JLogSDKEnum.h"
#import "JLogSDKSingleton.h"
#import "JLogSDKInterfaceBase.h"
#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

@interface JLogSDKInterfaceManager : NSObject

singleton_interface(JLogSDKInterfaceManager)

@property (nonatomic, strong) AFHTTPSessionManager *manager;

- (JLogSDKInterfaceBase *)createInterface:(JLogSDKInterfaceType)type;

@end
