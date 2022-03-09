//
//  HICHomeStudyClassModel.m
//  iTest
//
//  Created by Sir_Jing on 2020/3/14.
//  Copyright © 2020 Sir_Jing. All rights reserved.
//

#import "HICHomeStudyClassModel.h"

@implementation HSCourseKLD
-(void)setValue:(id)value forUndefinedKey:(NSString *)key {
    // 空实现
}
@end

@implementation HSContributor
-(void)setValue:(id)value forUndefinedKey:(NSString *)key {
    // 空实现
}
@end

@implementation HSAuthor

-(void)setValue:(id)value forKey:(NSString *)key {
    [super setValue:value forKey:key];
    if ([key isEqualToString:@"customer"]) {
        if ([value isKindOfClass:NSDictionary.class]) {
            _customer = [HSContributor mj_objectWithKeyValues:value];
        }
    }
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        if ([value isKindOfClass:NSNumber.class]) {
            NSNumber *num = (NSNumber *)value;
            _authorID = num.intValue;
        }else if ([value isKindOfClass:NSString.class]) {
            NSString *str = (NSString *)value;
            _authorID = str.intValue;
        }
    }
}
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"authorID":@"id"
    };
}
@end

@implementation HSAuditLog

-(void)setValue:(id)value forKey:(NSString *)key {
    [super setValue:value forKey:key];
    if ([key isEqualToString:@"customer"]) {
        if ([value isKindOfClass:NSDictionary.class]) {
            _customer = [HSContributor mj_objectWithKeyValues:value];
        }
    }
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        if ([value isKindOfClass:NSNumber.class]) {
            NSNumber *num = (NSNumber *)value;
            _logID = num.intValue;
        }else if ([value isKindOfClass:NSString.class]) {
            NSString *str = (NSString *)value;
            _logID = str.intValue;
        }
    }
}
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"logID":@"id"
    };
}
@end

@implementation HICHomeStudyClassModel

- (void)setValue:(id)value forKey:(NSString *)key {
    [super setValue:value forKey:key];
    if ([key isEqualToString:@"courseKLD"]) {
        if ([value isKindOfClass:NSDictionary.class]) {
            _courseKLD = [HSCourseKLD mj_objectWithKeyValues:value];
        }
    }else if ([key isEqualToString:@"contributor"]) {
        if ([value isKindOfClass:NSDictionary.class]) {
            _contributor = [HSContributor mj_objectWithKeyValues:value];
        }
    }else if ([key isEqualToString:@"author"]) {
        if ([value isKindOfClass:NSDictionary.class]) {
            _author = [HSAuthor mj_objectWithKeyValues:value];
        }
    }else if ([key isEqualToString:@"auditLog"]) {
        if ([value isKindOfClass:NSDictionary.class]) {
            _auditLog = [HSAuditLog mj_objectWithKeyValues:value];
        }
    }
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        if ([value isKindOfClass:NSNumber.class]) {
            NSNumber *num = (NSNumber *)value;
            _classID = num.intValue;
        }else if ([value isKindOfClass:NSString.class]) {
            NSString *str = (NSString *)value;
            _classID = str.intValue;
        }
    }
}

// 实现转换方法
+(NSArray *)createModelWithSourceData:(NSDictionary *)data {
    NSDictionary *dicData = [data objectForKey:@"data"];
    NSArray *columnList = [dicData objectForKey:@"courseKLDList"];

//    NSMutableArray *modelArray = [NSMutableArray array];
//
//    for (NSDictionary *dic in columnList) {
//        HICHomeStudyClassModel *model = [HICHomeStudyClassModel mj_objectWithKeyValues:dic];
//
//        // 添加到数组中
//        [modelArray addObject:model];
//    }
    if ([columnList isKindOfClass:NSArray.class]) {
        NSMutableArray *array = [self mj_objectArrayWithKeyValuesArray:columnList];
        return [array copy];
    }

//    return [modelArray copy];
    return @[];
}

@end
