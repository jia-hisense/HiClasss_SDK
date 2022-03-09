//
//  HICTrainingOtherInfoFrame.h
//  HiClass
//
//  Created by hisense on 2020/4/17.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface HICTrainingOtherInfoFrame : NSObject

@property (nonatomic, strong, readonly) NSString *title;
@property (nonatomic, strong, readonly) NSString *conent;
@property (nonatomic, assign) BOOL isSeparatorHidden;

@property (nonatomic, assign, readonly) CGRect titleF;
@property (nonatomic, assign, readonly) CGRect contentF;
@property (nonatomic, assign, readonly) CGRect separatorLineViewF;
@property (nonatomic, assign, readonly) CGFloat cellHeight;

-(instancetype)initWithTitle:(NSString *)title content:(NSString *)content isSeparatorHidden:(BOOL)isSeparatorHidden;

@end

NS_ASSUME_NONNULL_END
