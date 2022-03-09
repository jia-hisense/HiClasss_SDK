//
//  OfflineTrainingListModel.m
//  HiClass
//
//  Created by 铁柱， on 2020/4/22.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "OfflineTrainingListModel.h"

@implementation OfflineTrainListAttendanceRequires

-(NSInteger)lateArrivalThreshold {
    if (_lateArrivalThreshold > 0) {
        return _lateArrivalThreshold * 60;
    }
    return _lateArrivalThreshold;
}

@end

@implementation OfflineTrainingListModel

+(NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"trainId" : @"id"};
}

+(NSDictionary *)mj_objectClassInArray {
    return @{@"subTasks":@"OfflineTrainingListModel"};
}

@end


@implementation OfflineTrainListCellModel

-(instancetype)init {
    if (self = [super init]) {
        _currentTimeIndex = -1;
    }
    return self;
}

// 1.0 构造方法 - 课程包含高度计算
+(instancetype)createModelWithRep:(NSDictionary *)dic {

    OfflineTrainListCellModel *cellModel = [OfflineTrainListCellModel new];

    // 这里解析list数据并且进行数据赋值
    id data = [dic objectForKey:@"data"];
    if (data && [data isKindOfClass:NSArray.class]) {
        // 获取到全部的 数据课程
        NSMutableArray *modelData = [OfflineTrainingListModel mj_objectArrayWithKeyValuesArray:data];
        if (modelData.count != 0) {
            NSMutableArray *dataArray = [NSMutableArray array];
            // 1. 首先需要按照时间进行分类
            NSMutableArray *timeData = [NSMutableArray arrayWithObject:modelData.firstObject];
            OfflineTrainingListModel *befoModel = modelData.firstObject;
            NSInteger currentTime = befoModel.curTime; // 今天的日期
            NSString *contentTimeStr = [self getTimeStringWith:befoModel.startTime];
            // 1.1 取出来的第一层先判断一下 增加高度计算
            CGFloat heigh = [self getModelContentHeightWith:befoModel];
            NSMutableArray *timeCellHeights = [NSMutableArray array];
            NSMutableArray *timeCellStrings = [NSMutableArray array];
            for (NSInteger index = 1; index < modelData.count; index++) {
                OfflineTrainingListModel *currentModel = [modelData objectAtIndex:index];
                CGFloat currentHeight = [self getModelContentHeightWith:currentModel];
                if ([self isSameTime:befoModel.startTime endTime:currentModel.startTime]) {
                    [timeData addObject:currentModel];
                    heigh += currentHeight;
                    heigh += 12;
                }else {
                    [dataArray addObject:[timeData copy]];
                    [timeCellHeights addObject:[NSNumber numberWithDouble:heigh+52.f]]; // 最后的时候更新cell的总体高度
                    if ([self isSameTime:currentTime endTime:befoModel.startTime]) {
                        cellModel.currentTimeIndex = timeCellStrings.count;
                    }
                    [timeCellStrings addObject:contentTimeStr];

                    // 从新添加赋值
                    timeData = [NSMutableArray arrayWithObject:currentModel];
                    befoModel = currentModel;
                    heigh = currentHeight;
                    contentTimeStr = [self getTimeStringWith:befoModel.startTime];
                }
            }
            // 2. 最后一层的数据没有正常添加，需要一次添加
            if (timeData.count != 0) {
                [dataArray addObject:[timeData copy]];
                [timeCellHeights addObject:[NSNumber numberWithDouble:heigh+52.f]];
                if ([self isSameTime:currentTime endTime:befoModel.startTime]) {
                    cellModel.currentTimeIndex = timeCellStrings.count;
                }
                [timeCellStrings addObject:contentTimeStr];
            }
            // 3. 获取到数据后 模型赋值
            cellModel.listCellHeight = [timeCellHeights copy];
            cellModel.listModels = [dataArray copy];
            cellModel.listCellTimes = [timeCellStrings copy];
        }
    }

    return cellModel;
}
// 2.0 构造方法 - 课程不包含高度计算
+(instancetype)createModelWithRep:(NSDictionary *)dic withType:(PlanDetailType)type {

    OfflineTrainListCellModel *cellModel = [OfflineTrainListCellModel new];

    // 这里解析list数据并且进行数据赋值
    id data = [dic objectForKey:@"data"];
    if (data && [data isKindOfClass:NSArray.class]) {
        // 获取到全部的 数据课程
        NSMutableArray *modelData = [OfflineTrainingListModel mj_objectArrayWithKeyValuesArray:data];
        // 这种首先筛一遍数据
        modelData = [self getPlayTypeWith:type data:[modelData copy]];
        if (modelData.count != 0) {
            NSMutableArray *dataArray = [NSMutableArray array];
            // 1. 首先需要按照时间进行分类
            NSMutableArray *timeData = [NSMutableArray arrayWithObject:modelData.firstObject];
            OfflineTrainingListModel *befoModel = modelData.firstObject;
            NSInteger currentTime = befoModel.curTime; // 今天的日期
            NSString *contentTimeStr = [self getTimeStringWith:befoModel.startTime];
            // 1.1 取出来的第一层先判断一下 增加高度计算
            CGFloat heigh = [self getModelContentItemHeightWith:befoModel];
            NSMutableArray *timeCellHeights = [NSMutableArray array];
            NSMutableArray *timeCellStrings = [NSMutableArray array];
            for (NSInteger index = 1; index < modelData.count; index++) {
                OfflineTrainingListModel *currentModel = [modelData objectAtIndex:index];
                CGFloat currentHeight = [self getModelContentItemHeightWith:currentModel];
                if ([self isSameTime:befoModel.startTime endTime:currentModel.startTime]) {
                    [timeData addObject:currentModel];
                    heigh += currentHeight;
                    heigh += 12;
                }else {
                    [dataArray addObject:[timeData copy]];
                    // 1.2 最后的时候更新cell的总体高度
                    [timeCellHeights addObject:[NSNumber numberWithDouble:heigh+52.f]];
                    if ([self isSameTime:currentTime endTime:befoModel.startTime]) {
                        cellModel.currentTimeIndex = timeCellStrings.count;
                    }
                    [timeCellStrings addObject:contentTimeStr];

                    // 从新添加赋值
                    timeData = [NSMutableArray arrayWithObject:currentModel];
                    befoModel = currentModel;
                    heigh = currentHeight;
                    contentTimeStr = [self getTimeStringWith:befoModel.startTime];
                }
            }
            // 1.3 最后一层的数据没有正常添加，需要一次添加
            if (timeData.count != 0) {
                [dataArray addObject:[timeData copy]];
                [timeCellHeights addObject:[NSNumber numberWithDouble:heigh+52.f]];
                if ([self isSameTime:currentTime endTime:befoModel.startTime]) {
                    cellModel.currentTimeIndex = timeCellStrings.count;
                }
                [timeCellStrings addObject:contentTimeStr];
            }
            // 3. 获取到数据后 模型赋值
            cellModel.listCellHeight = [timeCellHeights copy];
            cellModel.listModels = [dataArray copy];
            cellModel.listCellTimes = [timeCellStrings copy]; 
        }
    }

    return cellModel;
}
/// 数据筛选，得到自己想要的对应类型的数据
+(NSMutableArray *)getPlayTypeWith:(PlanDetailType)type data:(NSArray *)data {
    NSMutableArray *array = [NSMutableArray array];

    for (OfflineTrainingListModel *model in data) {
        if (type == PlanDetailType_Class && model.taskType == 8) {
            [array addObject:model];
        }else {
            if (model.taskType == 8 && model.subTasks.count != 0) {
                for (OfflineTrainingListModel *subModel in model.subTasks) {
                    if (type == PlanDetailType_Exam && subModel.taskType == 3) {
                        [array addObject:subModel];
                    }else if (type == PlanDetailType_Homework && subModel.taskType == 4) {
                        [array addObject:subModel];
                    }else if (type == PlanDetailType_Sign && (subModel.taskType == 9 || subModel.taskType == 10)) {
                        [array addObject:subModel];
                    }else if (type == PlanDetailType_Questionnaire && subModel.taskType == 6) {
                        [array addObject:subModel];
                    }else if (type == PlanDetailType_Evaluate && subModel.taskType == 7) {
                        [array addObject:subModel];
                    }else if (type == PlabDetailType_Grade && subModel.taskType == 11) {
                        [array addObject:subModel];
                    }
                }
            }else {
                if (type == PlanDetailType_Exam && model.taskType == 3) {
                    [array addObject:model];
                }else if (type == PlanDetailType_Homework && model.taskType == 4) {
                    [array addObject:model];
                }else if (type == PlanDetailType_Sign && (model.taskType == 9 || model.taskType == 10)) {
                    [array addObject:model];
                }else if (type == PlanDetailType_Questionnaire && model.taskType == 6) {
                    [array addObject:model];
                }else if (type == PlanDetailType_Evaluate && model.taskType == 7) {
                    [array addObject:model];
                }else if (type == PlabDetailType_Grade && model.taskType == 11) {
                    [array addObject:model];
                }
            }
        }
    }

    return array;
}

// 获取每个 数据 对应view的高度， 其中涉及到课程的包含计算
+(CGFloat)getModelContentHeightWith:(OfflineTrainingListModel *)model {
    return [self getModelHeightWithModel:model andType:1];
}
// 每个数据对应 view的高度，其中清除了 课程包含关系的高度计算
+(CGFloat)getModelContentItemHeightWith:(OfflineTrainingListModel *)model {
    // 任务类型，1-课程，2-知识，3-考试，4-作业，6-问卷，7-评价，8-线下课，9-签到，10-签退
    return [self getModelHeightWithModel:model andType:2];
}
// Type: 1.存在课程分类的高度计算。2.不存在课程分类的子类计算
+(CGFloat)getModelHeightWithModel:(OfflineTrainingListModel *)model andType:(NSInteger)type {
    // 任务类型，1-课程，2-知识，3-考试，4-作业，6-问卷，7-评价，8-线下课，9-签到，10-签退
    CGFloat h = 0.f; // 默认高度为0
    if (model.taskType == 8) {
        // 需要进一步判断是否有子内容
        h = 104.5;
        if (model.subTasks.count != 0 && type == 1) {
            for (OfflineTrainingListModel *contentModel in model.subTasks) {
                CGFloat height = [self getModelContentHeightWith:contentModel];
                h += height;
            }
        }
    }else if (model.taskType == 3) {
        h = 104.5;
    }else if (model.taskType == 4) {
        if (model.endTime == -1) {
            h = 82.5; // 不限时
        }else {
            h = 82.5;
            if (model.workStatus == 1) {
                // 作业进行中的的
                if (model.endTime < model.curTime && model.endTime > 0) {
                    h = 104.5;
                }else {
                    h = 82.5;
                }
            }
        }
    }else if (model.taskType == 6 || model.taskType == 7) {
        h = 82.5;
    }else if (model.taskType == 9) {
        h = 82.5;
        if (model.attendanceRequires.latitude.doubleValue != 0 && model.attendanceRequires.longitude.doubleValue != 0 && model.attendanceRequires.radius != 0) {
            // 存在范围签到
            if (model.attendanceLastExeTime == 0 && model.curTime <= model.attendanceRequires.endTime+model.attendanceRequires.lateArrivalThreshold) {
                // 没有签到并且没有缺勤
                h = 104.5;
            }
        }
    }else if (model.taskType == 10) {
        h = 82.5;
        if (model.attendanceRequires.latitude.doubleValue != 0 && model.attendanceRequires.longitude.doubleValue != 0 && model.attendanceRequires.radius != 0) {
            // 存在范围签退
            if (model.attendanceLastExeTime == 0 && model.curTime <= model.attendanceRequires.endTime+model.attendanceRequires.lateArrivalThreshold) {
                // 没有签退并且没有缺勤
                h = 104.5;
            }
        }
    }else if (model.taskType == 11) {
        // 线下课成绩
        h = 82.5;
    }
    model.contentHeight = h;
    return h;
}


+(BOOL)isSameTime:(NSInteger)startTime endTime:(NSInteger)endTime {

    BOOL isSame = NO;
    if (startTime > 0 && endTime <= 0) {
        return isSame; // 正常时间和不限时的对比
    }else if (endTime - startTime > 3600*24) {
        return isSame; // 肯定不是同一天
    }else if (endTime <= 0 && startTime <= 0) {
        return YES; // 同样是不限时的日期时间
    }
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"MM-dd"];

    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:startTime];
    NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:endTime];

    NSString *startStr = [dateFormat stringFromDate:startDate];
    NSString *endStr = [dateFormat stringFromDate:endDate];

    if ([startStr isEqualToString:endStr]) {
        isSame = YES;
    }

    return isSame;

}

+(NSString *)getTimeStringWith:(NSInteger)time {

    if (time <= 0) {
        return NSLocalizableString(@"unlimited", nil);
    }
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"MM-dd"];

    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:time];

    NSString *startStr = [dateFormat stringFromDate:startDate];

    return startStr;
}

@end

