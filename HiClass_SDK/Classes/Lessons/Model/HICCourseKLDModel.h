//
//  HICCourseKLDModel.h
//  HiClass
//
//  Created by WorkOffice on 2020/2/19.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HICCourseKLDModel : NSObject
@property (nonatomic ,assign)NSInteger courseID;
@property (nonatomic ,strong)NSDictionary *courseKLD;
@property (nonatomic ,strong)NSDictionary *contributor;
@property (nonatomic ,strong)NSDictionary *author;
@property (nonatomic ,assign)NSInteger status;
@property (nonatomic ,strong)NSDictionary *auditLog;

@end

NS_ASSUME_NONNULL_END
