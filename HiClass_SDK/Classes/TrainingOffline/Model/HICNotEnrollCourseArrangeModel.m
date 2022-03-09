//
//  HICNotEnrollCourseArrangeModel.m
//  HiClass
//
//  Created by WorkOffice on 2020/6/11.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import "HICNotEnrollCourseArrangeModel.h"

@implementation HICNotEnrollCourseArrangeModel
-(void)setClassStages:(NSArray *)classStages{
    _classStages = [HICClassStageModel mj_objectArrayWithKeyValuesArray:classStages];
}
@end

@implementation HICClassStageModel

@end
