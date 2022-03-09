//
//  HICCompanyKnowledgeModel.m
//  HiClass
//
//  Created by Sir_Jing on 2020/3/20.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICCompanyKnowledgeModel.h"

@implementation HICCompanyKnowledgeModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"content"]) {
        if ([value isKindOfClass:NSArray.class]) {
            NSMutableArray *array = [NSMutableArray array];
            for (NSDictionary *dic in value) {
                if ([dic isKindOfClass:NSDictionary.class]) {
                    HSCourseKLD *course = [HSCourseKLD mj_objectWithKeyValues:value];
                    [array addObject:course];
                }
            }
            _content = [array copy];
        }
    }
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"content":@"HSCourseKLD"};
}


+(HICCompanyKnowledgeModel *)createModelWithSourceData:(NSDictionary *)data {

    NSDictionary *list = [data objectForKey:@"data"];

    HICCompanyKnowledgeModel *model = [self mj_objectWithKeyValues:list];
//    if ([list isKindOfClass:NSDictionary.class]) {
//    model = [HICCompanyKnowledgeModel modelWithDict:list];
//    }
    return model;
}
@end
