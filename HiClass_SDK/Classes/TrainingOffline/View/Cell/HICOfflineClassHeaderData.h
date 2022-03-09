//
//  HICOfflineClassHeaderData.h
//  HiClass
//
//  Created by hisense on 2020/5/6.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HICOfflineCourseDetailVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface HICOfflineClassHeaderData : NSObject
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *place;
@property (nonatomic, strong) NSNumber *scoreGroup;

@property (nonatomic, assign) NSInteger pageType;

- (instancetype)initWithTitle:(NSString *)title time:(nullable NSString *)time place:(nullable NSString *)place scoreGroup:(nullable NSNumber *)scoreGroup ;

@end

NS_ASSUME_NONNULL_END
