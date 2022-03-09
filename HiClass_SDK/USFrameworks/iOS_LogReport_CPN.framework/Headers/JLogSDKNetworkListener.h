//
//  JLogSDKNetworkListener.h
//  AFNetworking
//
//  Created by keep on 2018/6/15.
//

#import "JLogSDKSingleton.h"
#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

@interface JLogSDKNetworkListener : NSObject

singleton_interface(JLogSDKNetworkListener)

@property (nonatomic, assign, readonly) AFNetworkReachabilityStatus reachablilityStatus;

@end
