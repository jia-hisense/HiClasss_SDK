//
//  HICHomeStudyModel.m
//  iTest
//
//  Created by Sir_Jing on 2020/3/13.
//  Copyright © 2020 Sir_Jing. All rights reserved.
//

#import "HICHomeStudyModel.h"

@implementation ResourceListItem

-(void)setValue:(id)value forUndefinedKey:(NSString *)key {
    // 空实现
}

@end

@implementation HICHomeStudyModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    // 空实现
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"resourceList":@"ResourceListItem"};
}

+ (NSArray *)createModelWithSourceData:(NSDictionary *)data {

    NSDictionary *dicData = [data objectForKey:@"data"];
    NSArray *columnList = [dicData objectForKey:@"columnList"];

    /*
    NSMutableArray *modelArray = [[NSMutableArray array]];

    for (NSDictionary *dic in columnList) {
        HICHomeStudyModel *model = [HICHomeStudyModel modelWithDict:dic];
        // 转化resourceList数据
        NSArray *resourceLists = [dic objectForKey:@"resourceList"];
        NSMutableArray *resourceArray = [NSMutableArray array];
        for (NSDictionary *dicRes in resourceLists) {
            ResourceListItem *item = [ResourceListItem modelWithDict:dicRes];
            [resourceArray addObject:item];
        }
//        for (NSDictionary *dicRes in resourceLists) {
//            if ([dicRes isKindOfClass:NSDictionary.class]) {
//                ResourceListItem *item = [ResourceListItem new];
//                [item setValuesForKeysWithDictionary:dicRes];
//                [resourceArray addObject:item];
//            }
//        }
        model.resourceList = [resourceArray copy];

        // 针对私有属性进行设置
        if (model.columnType != 1) {
            // 非顶部导航栏的其他的都认为是cell
            model.isCell = YES;
            if (model.columnType == 2) {
                model.cellID = @"BannerCell";
                model.cellHeight = 160.f;
            }else if (model.columnType == 3) {
                // 快捷按钮 - 一行高度  73+10 两行 73*2+16+10;
                model.cellID = @"QuickButCell";
                NSInteger count = model.resourceList.count;
                if (count <= 5 && count > 0) {
                    model.cellHeight = 73+20;
                }else if (count > 5) {
                    NSInteger line = count %5;
                    NSInteger row = count/5 + (line != 0 ? 1:0);
                    model.cellHeight = 73*row+16*(row-1)+20;
                }else {
                    model.cellHeight = 0;
                }
            }else if (model.columnType == 4) {
                model.cellID = @"AdvCell";
                model.cellHeight = 44.f;
            }else if (model.columnType == 5) {
                if (model.templateType == 1) {
                    model.cellID = @"ModelOneCell";
                    model.cellHeight = 305.f;
                }else if (model.templateType == 2) {
                    model.cellID = @"ModelTwoCell";
                    model.cellHeight = 270.f;
                }else if (model.templateType == 3) {
                    model.cellID = @"ModelThriceCell";
                    model.cellHeight = 135.f;
                }else if (model.templateType == 4) {
                    model.cellID = @"ModelFourCell";
                    model.cellHeight = 135.f;
                }
            }
        }

        // 添加到数组中
        [modelArray addObject:model];
    }*/
    NSMutableArray *modelArray = [self mj_objectArrayWithKeyValuesArray:columnList];
    for (HICHomeStudyModel *model in modelArray) {
        // 针对私有属性进行设置
        if (model.columnType != 1) {
            // 非顶部导航栏的其他的都认为是cell
            model.isCell = YES;
            if (model.columnType == 2) {
                model.cellID = @"BannerCell";
                model.cellHeight = 160.f+7;
            }else if (model.columnType == 3) {
                // 快捷按钮 - 一行高度  73+10 两行 73*2+16+10;
                model.cellID = @"QuickButCell";
                NSInteger count = model.resourceList.count;
                if (count <= 5 && count > 0) {
                    model.cellHeight = 73+25;
                }else if (count > 5) {
                    NSInteger line = count %5;
                    NSInteger row = count/5 + (line != 0 ? 1:0);
                    model.cellHeight = 73*row+16*(row-1)+25;
                }else {
                    model.cellHeight = 0;
                }
            }else if (model.columnType == 4) {
                model.cellID = @"AdvCell";
                model.cellHeight = 52.f;
            }else if (model.columnType == 5) {
                if (model.templateType == 1) {
                    model.cellID = @"ModelOneCell";
//                    if (model.resourceList.count > 2) {
//                        model.cellHeight = 305.f;
//                    }else {
//                        model.cellHeight = 174.f;
//                    }
                    NSInteger count = model.resourceList.count;
                    if (count <= 2 && count > 0) {
                        model.cellHeight = 174.f+15;
                    }else if (count > 2) {
                        NSInteger line = count %2;
                        NSInteger row = count/2 + (line != 0 ? 1:0);
                        model.cellHeight = 113*row+18*(row-1)+42+13+15;
                    }else {
                        model.cellHeight = 0;
                    }
                }else if (model.templateType == 2) {
                    // 需要确认
                    model.cellID = @"CallListCell";
                    model.cellHeight = 42+95*model.resourceList.count+5;
                }else if (model.templateType == 3) {
                    model.cellID = @"ModelThriceCell";
                    NSInteger count = model.resourceList.count;
                    if ( count <= 3 && count > 0) {
                        model.cellHeight = 135.f+15;
                    }else if(count > 3) {
                        NSInteger line = count %3;
                        NSInteger row = count/3 + (line != 0 ? 1:0);
                        model.cellHeight = 101*row+42+15;
                    }else {
                        model.cellHeight = 0;
                    }
                }else if (model.templateType == 4) {
//                    NSMutableArray *array = [NSMutableArray arrayWithArray:model.resourceList];
//                    [array addObjectsFromArray:model.resourceList];
//                    model.resourceList = [array copy];
                    model.cellID = @"ModelTwoCell";
                    NSInteger count = model.resourceList.count;
                    if ( count == 1) {
                        model.cellHeight = 270.f+15;
                    }else if(count > 1) {
                        model.cellHeight = 234*count+42+15;
                    }else {
                        model.cellHeight = 0;
                    }
                }else if (model.templateType == 5) {
                    model.cellID = @"TeacherCell";
                    model.cellHeight = 148.f;
                }else if (model.templateType == 6) {
                    model.cellID = @"ModelFourCell";
                    model.cellHeight = 148.f;
                }
            }
        }
    }
    return [modelArray copy];
}

+ (NSArray *)getHomeDataWithModels:(NSArray *)array {

    NSMutableArray *cellArray = [NSMutableArray array];

    for (HICHomeStudyModel *model in array) {
        if (model.isCell == YES && model.cellID) {
            if (model.columnType == 3) {
                // 需要根据条件筛选
                // "AppVideoConferenceS"-视频会议, "AppTrainManageS"-培训管理, "AppQuestionnaireS"-问卷, "AppCourseKnowledgeCatalogS"-课程知识目录, "AppJobMapS"-岗位地图, "AppSignUpS"-报名, "AppExamCenterS"-考试中心,AppLiveS-直播,AnswerGameS-答题游戏
                NSMutableArray *array = [NSMutableArray array];
                for (ResourceListItem *item in model.resourceList) {
                    NSString *codeStr = @"";
                    if (item.resourceType == 1001) {
                        codeStr = @"AppVideoConferenceS";
                    }else if (item.resourceType == 1002) {
                        codeStr = @"AppJobMapS";
                    }else if (item.resourceType == 1003) {
                        codeStr = @"AppExamCenterS";
                    }else if (item.resourceType == 1004) {
                        codeStr = @"AppTrainManageS";
                    }else if (item.resourceType == 1005) {
                        codeStr = @"AppQuestionnaireS";
                    }else if (item.resourceType == 1006) {
                        codeStr = @"AppSignUpS";
                    }else if (item.resourceType == 1007) {
                        codeStr = @"AppCourseKnowledgeCatalogS";
                    }else if (item.resourceType == 1012) {
                        codeStr = @"AppLiveS";
                    }else if (item.resourceType == 1013){//答题游戏
                        codeStr = @"AnswerGameS";
                    }
                    if (!RoleManager.isSuccessMenu) {
                        if ([codeStr isEqualToString:@""]) {
                            [array addObject:item];
                            continue;
                        }
                    }
                    for (NSString *str in RoleManager.menuCodes) {
                        if ([codeStr isEqualToString:@""]) {
                            [array addObject:item];
                            break;
                        }
                        if ([str isEqualToString:codeStr]) {
                            [array addObject:item];
                        }
                    }
                }
                model.resourceList = [array copy];
                if (model.resourceList.count != 0) {
                    [cellArray addObject:model];
                    NSInteger count = model.resourceList.count;
                    if (count <= 5 && count > 0) {
                        model.cellHeight = 73+25;
                    }else if (count > 5) {
                        NSInteger line = count %5;
                        NSInteger row = count/5 + (line != 0 ? 1:0);
                        model.cellHeight = 73*row+16*(row-1)+25;
                    }else {
                        model.cellHeight = 0;
                    }
                }
            }else {
                [cellArray addObject:model];
            }
        }
    }

    return [cellArray copy];
}

+(NSArray *)getHomeDataWithModels:(NSArray *)array addTaskCenters:(NSArray *)centers {

    NSMutableArray *cellArray = [NSMutableArray array];

    for (HICHomeStudyModel *model in array) {
        if (model.isCell == YES && model.cellID) {
            if (model.columnType == 3) {
                // 需要根据条件筛选
                // "AppVideoConferenceS"-视频会议, "AppTrainManageS"-培训管理, "AppQuestionnaireS"-问卷, "AppCourseKnowledgeCatalogS"-课程知识目录, "AppJobMapS"-岗位地图, "AppSignUpS"-报名, "AppExamCenterS"-考试中心,
                NSMutableArray *array = [NSMutableArray array];
                for (ResourceListItem *item in model.resourceList) {
                    NSString *codeStr = @"";
                    if (item.resourceType == 1001) {
                        codeStr = @"AppVideoConferenceS";
                    }else if (item.resourceType == 1002) {
                        codeStr = @"AppJobMapS";
                    }else if (item.resourceType == 1003) {
                        codeStr = @"AppExamCenterS";
                    }else if (item.resourceType == 1004) {
                        codeStr = @"AppTrainManageS";
                    }else if (item.resourceType == 1005) {
                        codeStr = @"AppQuestionnaireS";
                    }else if (item.resourceType == 1006) {
                        codeStr = @"AppSignUpS";
                    }else if (item.resourceType == 1007) {
                        codeStr = @"AppCourseKnowledgeCatalogS";
                    }else if (item.resourceType == 1012) {
                        codeStr = @"AppLiveS";
                    }else if (item.resourceType == 1013){//答题游戏
                        codeStr = @"AnswerGameS";
                    }
                    if (!RoleManager.isSuccessMenu) {
                        if ([codeStr isEqualToString:@""]) {
                            [array addObject:item];
                            continue;
                        }
                    }
                    for (NSString *str in RoleManager.menuCodes) {
                        if ([codeStr isEqualToString:@""]) {
                            [array addObject:item];
                            break;
                        }
                        if ([str isEqualToString:codeStr]) {
                            [array addObject:item];
                        }
                    }
                }
                model.resourceList = [array copy];
                if (model.resourceList.count != 0) {
                    [cellArray addObject:model];
                    NSInteger count = model.resourceList.count;
                    if (count <= 5 && count > 0) {
                        model.cellHeight = 73+25;
                    }else if (count > 5) {
                        NSInteger line = count %5;
                        NSInteger row = count/5 + (line != 0 ? 1:0);
                        model.cellHeight = 73*row+16*(row-1)+25;
                    }else {
                        model.cellHeight = 0;
                    }
                }
            }else {
                [cellArray addObject:model];
            }
        }
    }

    NSMutableArray *centerArray = [NSMutableArray array];

    if (centers.count > 0) {
        [centerArray addObjectsFromArray:centers];
    }
    HICHomeStudyModel *model = [HICHomeStudyModel new];
    model.isCell = YES;
    model.cellID = @"TodyCell";
    model.cellHeight = 42+(44+8)*centerArray.count+15;
    model.taskCenters = [centerArray copy];

    [cellArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        HICHomeStudyModel *mo = (HICHomeStudyModel *)obj;
        if (model.taskCenters.count > 0 && idx == 0) {
            [cellArray insertObject:model atIndex:idx+1];
            *stop = YES;
        }
    }];

    return [cellArray copy];
}

+(HICHomeStudyModel *)getMenuDataWithModels:(NSArray *)array {
    HICHomeStudyModel *model;

    for (HICHomeStudyModel *mo in array) {
        if (mo.columnType == 1) {
            model = mo;
        }
    }

    return model;
}

@end
