//
//  HICCourseRecommendModel.h
//  HiClass
//
//  Created by WorkOffice on 2020/2/17.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HICCourseRecommendModel : NSObject
@property (nonatomic ,assign)NSInteger recommendId;//"integer,推荐明细ID",
@property (nonatomic ,strong)NSDictionary *courseKLDInfo;
@end

NS_ASSUME_NONNULL_END
