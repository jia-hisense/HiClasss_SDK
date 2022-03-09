//
//  NSObject+DicTransModel.h
//  HiClass
//
//  Created by 铁柱， on 2020/1/17.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (DicTransModel)
+ (instancetype)modelWithDict:(NSDictionary *)dict;
+ (instancetype)modelWithDictArr:(NSMutableArray *)dictArr;
@end

NS_ASSUME_NONNULL_END
