//
//  HICMixTrainArrangeModel.m
//  HiClass
//
//  Created by WorkOffice on 2020/6/17.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import "HICMixTrainArrangeModel.h"

@implementation HICMixTrainArrangeModel
@end
@implementation HICMixTrainArrangeListModel
@end
@implementation OfflineMixTrainCellModel

-(instancetype)init {
    if (self = [super init]) {

    }
    return self;
}

// 1.0 构造方法 - 课程包含高度计算
+(instancetype)createModelWithRep:(NSArray *)arr {
    OfflineMixTrainCellModel *cellModel = [OfflineMixTrainCellModel new];
        // 获取到全部的 数据课程
        NSMutableArray *modelData = [HICMixTrainArrangeListModel mj_objectArrayWithKeyValuesArray:arr];
        if (modelData.count != 0) {
            HICMixTrainArrangeListModel *befoModel = modelData.firstObject;
            CGFloat heigh = [self getModelContentHeightWith:befoModel];
            NSMutableArray *cellHeights = [NSMutableArray array];
            [cellHeights addObject:[NSNumber numberWithDouble:heigh]];
            for (NSInteger index = 1; index < modelData.count; index++) {
                HICMixTrainArrangeListModel *currentModel = [modelData objectAtIndex:index];
                CGFloat currentHeight = [self getModelContentHeightWith:currentModel];
//                heigh += currentHeight;
//                currentHeight += 12;
//                 [cellHeights addObject:[NSNumber numberWithDouble:heigh]];
                [cellHeights addObject:[NSNumber numberWithDouble:currentHeight]];
                // 从新添加赋值
//                befoModel = currentModel;
//                heigh = currentHeight;
//                 heigh = 0;
                }
            // 3. 获取到数据后 模型赋值
            cellModel.listCellHeight = [cellHeights copy];
            cellModel.listModels = [modelData copy];
        }
    return cellModel;
}
// 获取每个 数据 对应view的高度， 其中涉及到课程的包含计算
+(CGFloat)getModelContentHeightWith:(HICMixTrainArrangeListModel *)model {
    return [self getModelHeightWithModel:model andType:1];
}
// 每个数据对应 view的高度，其中清除了 课程包含关系的高度计算
+(CGFloat)getModelContentItemHeightWith:(HICMixTrainArrangeListModel *)model {
    // 任务类型，1-课程，2-知识，3-考试，4-作业，6-问卷，7-评价，8-线下课，9-签到，10-签退
    return [self getModelHeightWithModel:model andType:2];
}
// Type: 1.存在课程分类的高度计算。2.不存在课程分类的子类计算
+(CGFloat)getModelHeightWithModel:(HICMixTrainArrangeListModel *)model andType:(NSInteger)type {
    // 任务类型，1-课程，2-知识，3-考试，4-作业，6-问卷，7-评价，8-线下课，9-签到，10-签退
    CGFloat h = 0.f; // 默认高度为0
    if (model.taskType == 8) {
        // 需要进一步判断是否有子内容
        h = 104.5;
        if (model.subTasks.count != 0 && type == 1) {
            NSMutableArray *tempArr = [HICMixTrainArrangeListModel mj_objectArrayWithKeyValuesArray:model.subTasks];
            model.subTasks = tempArr;
            for (HICMixTrainArrangeListModel *contentModel in model.subTasks) {
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
    }else if (model.taskType == 2 || model.taskType == 1){
        //线上课程或知识
        h = 82.5;
    }
    model.contentHeight = h;
    return h + 12;
}
//+(instancetype)createModelWithRep:(NSDictionary *)dic withType:(PlanDetailType)type{
//
//}
@end
