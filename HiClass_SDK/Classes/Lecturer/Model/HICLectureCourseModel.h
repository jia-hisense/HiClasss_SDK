//
//  HICLectureCourseModel.h
//  HiClass
//
//  Created by hisense on 2020/5/13.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HICLectureCourseSubModel  : NSObject
@property (nonatomic, assign) NSInteger resClassId; //":"long,线下课程Id",
@property (nonatomic, strong) NSString *resClassName; //":"string,线下课程名称",
@property (nonatomic, assign) NSString *briefIntroduction; //":"string,线下课程简介",
@property (nonatomic, assign) NSInteger joinNum; //":"int, 参与学员总数",
@property (nonatomic, assign) NSInteger isAuth; //":"int,是否认证课程(1:是 0:否)"
@end

@interface HICLectureCourseModel : NSObject

@property (nonatomic, assign) NSInteger total;
@property (nonatomic, strong) NSMutableArray *list;


@end

NS_ASSUME_NONNULL_END
