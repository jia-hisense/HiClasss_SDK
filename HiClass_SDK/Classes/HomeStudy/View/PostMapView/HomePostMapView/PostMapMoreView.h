//
//  PostMapMoreView.h
//  iTest
//
//  Created by Sir_Jing on 2020/3/17.
//  Copyright © 2020 Sir_Jing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PostMapMoreView : UIView

-(instancetype)initWithFrame:(CGRect)frame andParentController:(UIViewController *)controller;

-(void)showAnimationWithController:(UIViewController *)vc;
// 节点ID
@property (nonatomic, assign) NSInteger nodeId;

@property (nonatomic ,strong)NSNumber *postId;
@property (nonatomic ,strong)NSNumber *wayId;
@end

NS_ASSUME_NONNULL_END
