//
//  PostMapMoreDetailVCView.h
//  iTest
//
//  Created by Sir_Jing on 2020/3/17.
//  Copyright © 2020 Sir_Jing. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HICPostMapMoreModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PostMapMoreDetailVCView : UIViewController

@property (nonatomic, strong) HICPostMapMoreModel *model;
@property (nonatomic ,strong)NSNumber *postId;
@property (nonatomic ,strong)NSNumber *wayId;
@end

NS_ASSUME_NONNULL_END
