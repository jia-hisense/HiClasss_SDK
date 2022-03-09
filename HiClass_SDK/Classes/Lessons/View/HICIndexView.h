//
//  HICIndexView.h
//  HiClass
//
//  Created by WorkOffice on 2020/2/4.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HICIndexView : UITableView

@property (nonatomic, strong)NSArray *dataArr;
@property (nonatomic, strong)UIViewController *vc;
@property (nonatomic, strong)NSNumber *courseId;
@property (nonatomic, strong)NSNumber *trainId;
@property (nonatomic, assign)BOOL isJumpChapter;

- (instancetype)initWithVC:(UIViewController *)vc;

@end

NS_ASSUME_NONNULL_END
