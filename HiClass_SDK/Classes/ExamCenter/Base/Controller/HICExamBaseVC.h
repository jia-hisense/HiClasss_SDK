//
//  HICExamBaseVC.h
//  HiClass
//
//  Created by 铁柱， on 2020/1/14.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
//@protocol HICExamBaseVCDelegate <NSObject>
//- (void)reloadUI:(NSInteger )index;
//@end
@interface HICExamBaseVC : HICBaseViewController
//点击的第几个按钮
typedef void (^TitleViewClick)(NSInteger);
@property (nonatomic, strong) TitleViewClick titleClickBlock;
//@property (nonatomic, assign) id <HICExamBaseVCDelegate> examDelegate;
/** 注释  */
@end

NS_ASSUME_NONNULL_END
