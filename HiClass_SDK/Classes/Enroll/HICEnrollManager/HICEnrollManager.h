//
//  HICEnrollManager.h
//  HiClass
//
//  Created by WorkOffice on 2020/6/4.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HICEnrollManager : NSObject
@property (nonatomic, assign) CGFloat contentSizeW;
@property (nonatomic, assign) CGFloat offlineContentSizeW;
@property (nonatomic, strong) NSMutableArray *seleArr;
+(instancetype)shared;
@end

NS_ASSUME_NONNULL_END
