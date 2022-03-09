//
//  HICMyRecordListModel.h
//  HiClass
//
//  Created by WorkOffice on 2020/3/16.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HICMyRecordListModel : NSObject
/**
 "id":"long,学习记录id",
                "courseKLDInfo":Object{...},
                "complete":"integer,是否完成",
                "updateTime":"long,学习时间，秒级时间戳",
                "learnningDuration":"integer,学习时长，分钟",
                "creditHours":"integer,学时，分钟",
                "credit":"integer,学分",
                "points":"integer,积分"*/
@property(nonatomic ,strong)NSNumber *recordId;
@property(nonatomic ,strong)NSDictionary *courseKLDInfo;
@property(nonatomic ,assign)NSInteger complete;
@property(nonatomic ,strong)NSNumber *updateTime;
@property(nonatomic ,assign)NSInteger learnningDuration;
@property(nonatomic ,assign)NSInteger creditHours;
@property(nonatomic ,assign)NSInteger credit;
@property(nonatomic ,assign)NSInteger points;
@end

NS_ASSUME_NONNULL_END
