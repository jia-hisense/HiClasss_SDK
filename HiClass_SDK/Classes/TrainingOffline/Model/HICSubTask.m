//
//  HICSubTask.m
//  HiClass
//
//  Created by hisense on 2020/4/23.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import "HICSubTask.h"
#import "NSString+String.h"

@implementation HICAttendanceRequires

- (NSInteger)lateArrivalThreshold {
    if (_lateArrivalThreshold > 0) {
        return _lateArrivalThreshold*60;
    }
    return _lateArrivalThreshold;
}

@end

@implementation HICSubTask
+(NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"trainStageId":@"id"};
}




@end
