//
//  HICCourseExciseModel.h
//  HiClass
//
//  Created by WorkOffice on 2020/2/17.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HICCourseExciseModel : NSObject
@property (nonatomic ,assign)NSInteger reletedId;//"integer,关联明细ID",
@property (nonatomic ,assign)NSInteger resourceType;//"integer,资源类型  1-练习题集",
@property (nonatomic ,assign)NSInteger displayOrder;//"integer,展示顺序",
@property (nonatomic ,strong)NSDictionary *exerciseInfo;
@end

NS_ASSUME_NONNULL_END
