//
//  HomeworkDetailModel.m
//  HiClass
//
//  Created by 铁柱， on 2020/3/28.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HomeworkDetailModel.h"

@implementation HomeworkDetailAttachmentModel

+(NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"attId":@"id"};
}

@end

@implementation HomeworkDetailModel

+(NSDictionary *)mj_objectClassInArray {
    return @{@"attachments":@"HomeworkDetailAttachmentModel"};
}

+(instancetype)createModeWithDataSource:(NSDictionary *)dic {
    NSDictionary *data = [dic objectForKey:@"data"];
    HomeworkDetailModel *model = [HomeworkDetailModel new];
    if ([data isKindOfClass:NSDictionary.class]) {
        model = [HomeworkDetailModel mj_objectWithKeyValues:data];
    }
    return model;
}

@end
