//
//  HICM3U8SegmentModel.h
//  HiClass
//
//  Created by Eddie_Ma on 16/2/20.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HICM3U8SegmentModel : NSObject

/// ts时长
@property (nonatomic, strong) NSString *duration;

/// ts的url
@property (nonatomic, strong) NSString *downloadURL;

@end

NS_ASSUME_NONNULL_END
