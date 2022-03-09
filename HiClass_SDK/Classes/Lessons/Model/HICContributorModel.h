//
//  HICContributorModel.h
//  HiClass
//
//  Created by WorkOffice on 2020/2/14.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HICContributorModel : NSObject
@property (nonatomic ,strong) NSNumber *customerId;//"long,用户ID"
@property (nonatomic ,strong) NSString *name;//"string,用户名称",
@property (nonatomic ,strong) NSString *picUrl;// "string,用户头像URL"
@property (nonatomic ,strong) NSString *positions;//"string,职级信息"
@property (nonatomic ,strong) NSString *synopsis;//synopsis
@end

NS_ASSUME_NONNULL_END
