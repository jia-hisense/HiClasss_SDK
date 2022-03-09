//
//  HICExamModel.h
//  HiClass
//
//  Created by 铁柱， on 2020/1/15.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HICExamModel : NSObject
@property (nonatomic, strong) NSDictionary *baseInfo;
@property (nonatomic, strong) NSDictionary *controlParams;
@property (nonatomic, strong) NSDictionary *paperInfo;
@property (nonatomic, strong) NSArray *examRecordInfoList;

//#pragma mark paperInfo
///// 考卷标识
//@property(nonatomic, strong) NSNumber *paperId;
///// 考试目标
//@property(nonatomic, strong) NSString *examObjective;

@end
NS_ASSUME_NONNULL_END
