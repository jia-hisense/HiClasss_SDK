//
//  HICOfflineClassHeaderFrame.h
//  HiClass
//
//  Created by hisense on 2020/4/23.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HICOfflineClassInfoModel.h"
#import "HICOfflineClassHeaderData.h"

NS_ASSUME_NONNULL_BEGIN



@interface HICOfflineClassHeaderFrame : NSObject

@property (nonatomic, strong) HICOfflineClassHeaderData *data;

@property (nonatomic, assign, readonly) CGRect bgImgViewF;
@property (nonatomic, assign, readonly) CGRect titleLblF;
@property (nonatomic, assign, readonly) CGRect timeLblF;
@property (nonatomic, assign, readonly) CGRect placeLblF;
@property (nonatomic, assign, readonly) CGRect imgViewF;

@property (nonatomic, assign, readonly) CGFloat headerHeight;


- (instancetype)initWithData:(HICOfflineClassHeaderData *)data;

@end

NS_ASSUME_NONNULL_END
