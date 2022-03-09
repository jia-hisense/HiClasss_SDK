//
//  HICMyspaceModel.h
//  HiClass
//
//  Created by 铁柱， on 2021/1/7.
//  Copyright © 2021 haoqian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HICEnum.h"
NS_ASSUME_NONNULL_BEGIN

@interface HICMyspaceModel : NSObject
@property (nonatomic ,assign)HICMineWorkSpaceType type;
@property (nonatomic ,strong)NSString *name;
@property (nonatomic ,strong)NSNumber *num;

@end

NS_ASSUME_NONNULL_END
