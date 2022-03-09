//
//  HICView.h
//  HiClass
//
//  Created by jiafujia on 2021/8/4.
//  Copyright © 2021 hisense. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HICView : UIView

@property (nonatomic, assign)CGSize cornerRadii;
@property (nonatomic, assign)UIRectCorner corners;

@property (nonatomic, strong) NSArray<UIColor *> *colors;
@property (nonatomic, strong) NSArray<NSNumber *> *locations;
@property (nonatomic)         CGPoint  startPoint;
@property (nonatomic)         CGPoint  endPoint;

@end

NS_ASSUME_NONNULL_END
