//
//  HICLiveListModel.m
//  HiClass
//
//  Created by hisense on 2020/8/18.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import "HICLiveListModel.h"

@implementation HICLiveListModel
-(NSArray *)lessonTeacherList{
    return [HICLiveTeacherModel mj_objectArrayWithKeyValuesArray:_lessonTeacherList];
}
-(NSString *)teacherName {
    NSString *nameStr;
    if (_lessonTeacherList.count > 0) {
        NSMutableArray *arr = [NSMutableArray array];
        for (int i = 0; i < _lessonTeacherList.count; i++) {
            HICLiveTeacherModel *model = [HICLiveTeacherModel mj_objectWithKeyValues:_lessonTeacherList[i]];
            if (![NSString isValidStr:model.name]) {
                model.name = @"";
            }
            [arr addObject:model.name];
        }
        nameStr = [arr componentsJoinedByString:@","];
    }
    return nameStr;
}
@end
@implementation HICLiveLessonModel
+(NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"lessonId" : @"id",@"lessonDes":@"description", };
}
@end
@implementation HICLivePlayBackInfo

@end
@implementation HICLiveTeacherModel

@end
@implementation HICLiveAttachmentModel
+(NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"attachtemtId" : @"id"};
}
@end
@implementation HICLiveLessonQuestionModel
+(NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"exciseId" : @"id"};
}
@end
@implementation HICLiveGroupModel
+(NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"groupDetailId" : @"id"};
}
@end
@implementation HICLiveStatusModel

@end
@implementation HICLiveRoomModel

@end
