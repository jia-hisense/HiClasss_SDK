//
//  HICTestModel.m
//  HiClass
//
//  Created by Eddie Ma on 2020/1/19.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICTestModel.h"

@implementation HICTestModel

- (instancetype)initWithDic:(NSDictionary *)dic {
    if (self = [super init]) {
        self.assignTime = dic[@"assignTime"];
        self.examDuration = dic[@"examDuration"];
        self.examer = dic[@"examer"];
        self.examTime = dic[@"examTime"];
        self.examTimes = dic[@"examTimes"];
        self.grade = dic[@"grade"];
        self.needShowSection = dic[@"needShowSection"];
        self.passScore = dic[@"passScore"];
        self.start = dic[@"start"];
        self.startLable = dic[@"startLable"];
        self.name = dic[@"title"];
        self.tag = dic[@"tag"];
        self.score = dic[@"score"];
    }
    return self;
}

@end
