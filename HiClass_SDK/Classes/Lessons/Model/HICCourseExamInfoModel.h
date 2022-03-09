//
//  HICCourseExamInfoModel.h
//  HiClass
//
//  Created by WorkOffice on 2020/2/17.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HICCourseExamInfoModel : NSObject
@property (nonatomic ,assign)NSInteger examId;//章节ID
@property (nonatomic ,strong)NSString *name;//"string,考试名称",
@property (nonatomic ,strong)NSString *desc;//"string,考试说明",
@property (nonatomic ,strong)NSString *tags;//"string,"string,考试标签：补考、重要"",
@property (nonatomic ,strong)NSString *assignor;//"string,考试指派人",
@property (nonatomic ,assign)NSInteger status;//integer,考试状态 0-待考试，1-进行中，2-批阅中，3-已完成，4-缺考",
@property (nonatomic ,assign)NSInteger score;//"integer,integer,考卷总分",
@property (nonatomic ,assign)NSInteger passScroe;//"integer,integer,通过分数",
@property (nonatomic ,assign)NSInteger questionNum;//"integer,integer,试卷题数",
@property (nonatomic ,strong)NSNumber * assignTime;//"integer,long,考试安排时间，秒级时间戳",
@property (nonatomic ,assign)NSInteger times;//"integer,剩余考试次数",
@end

NS_ASSUME_NONNULL_END
