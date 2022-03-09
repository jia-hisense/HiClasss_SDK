//
//  HICEnrollReviewModel.m
//  HiClass
//
//  Created by WorkOffice on 2020/6/12.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import "HICEnrollReviewModel.h"

@implementation HICEnrollReviewModel
+(NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"auditId" : @"id"};
}
-(void)setAuditTemplateNodeAuditors:(NSMutableArray *)auditTemplateNodeAuditors{
    _auditTemplateNodeAuditors = [HICEnrollReviewerModel mj_objectArrayWithKeyValuesArray:auditTemplateNodeAuditors];
}
@end
@implementation HICEnrollReviewerModel
+(NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"auditorKey" : @"id"};
}
@end
@implementation HICEnrollReviewProcessModel
+(NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"auditNodeId" : @"id"};
}

@end
@implementation HICEnrollReviewStatusModel

@end
