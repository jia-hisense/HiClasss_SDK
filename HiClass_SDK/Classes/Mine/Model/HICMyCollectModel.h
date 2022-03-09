//
//  HICMyCollectModel.h
//  HiClass
//
//  Created by WorkOffice on 2020/2/24.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HICMyCollectModel : NSObject
@property (nonatomic ,strong)NSNumber *collectId;//"long,收藏ID",
@property (nonatomic ,strong)NSDictionary *courseKLDInfo;
@property (nonatomic ,strong)NSNumber *updateTime;//"long,收藏时间，秒级时间戳"
@end

NS_ASSUME_NONNULL_END
