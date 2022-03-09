//
//  HICAuthorModel.h
//  HiClass
//
//  Created by WorkOffice on 2020/2/14.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HICAuthorCustomerModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HICAuthorModel : NSObject
@property (nonatomic ,strong) NSNumber *authorID;//"long,作者ID",
@property (nonatomic ,strong) NSNumber *type;//"string,人员类型:1-系统内人员，2-外部人员",
@property (nonatomic ,strong) NSString *name;//"string,用户名称（type=2适用）"
@property (nonatomic ,strong) NSDictionary *customer;//
@end

NS_ASSUME_NONNULL_END
