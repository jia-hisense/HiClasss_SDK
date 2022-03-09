//
//  HICKldSectionLIstModel.h
//  HiClass
//
//  Created by WorkOffice on 2020/2/17.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HICKldSectionLIstModel : NSObject
@property (nonatomic, strong)NSNumber *chapterId;//章节ID
@property (nonatomic, strong)NSString *name;//"string,章节名称",
@property (nonatomic, assign)NSInteger displayOrder;//展示顺序
@property (nonatomic, assign)NSInteger jumpFlag;//"integer,知识/考试是否可跳过，0-否，1-是
@property (nonatomic, strong)NSArray *courseList;//
@property (nonatomic, strong)NSString *learningRate;//string,学习进度，例：2/4
@end

NS_ASSUME_NONNULL_END
