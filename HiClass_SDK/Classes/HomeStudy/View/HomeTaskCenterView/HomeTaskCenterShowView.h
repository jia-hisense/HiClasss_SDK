//
//  HomeTaskCenterShowView.h
//  iTest
//
//  Created by Sir_Jing on 2020/3/16.
//  Copyright © 2020 Sir_Jing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HomeTaskCenterShowViewDelegate <NSObject>
@optional
- (void)enter;
@end

@interface HomeTaskCenterShowView : UIView

@property (nonatomic, weak) id<HomeTaskCenterShowViewDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
