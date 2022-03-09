//
//  CAAnimation+Blocks.h
//  CAAnimationBlocks
//
//  Created by xissburg on 7/7/11.
//  Copyright 2011 xissburg. All rights reserved.
//
//  https://github.com/xissburg/CAAnimationBlocks

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface CAAnimation (BMBlocksAddition)

@property (nonatomic, copy) void (^bm_completion)(BOOL finished);
@property (nonatomic, copy) void (^bm_start)(void);

- (void)setBm_completion:(void (^)(BOOL finished))completion; // Forces auto-complete of setCompletion: to add the name 'finished' in the block parameter

@end
