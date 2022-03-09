//
//  HICOfflineClassHeaderData.m
//  HiClass
//
//  Created by hisense on 2020/5/6.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import "HICOfflineClassHeaderData.h"

@implementation HICOfflineClassHeaderData
- (instancetype)initWithTitle:(NSString *)title time:(NSString *)time place:(NSString *)place scoreGroup:(NSNumber *)scoreGroup {
    self = [super init];
    if (self) {
        self.title = title;
        self.time = time;
        self.place = place;
        self.scoreGroup = scoreGroup;
    }

    return self;
}
@end
