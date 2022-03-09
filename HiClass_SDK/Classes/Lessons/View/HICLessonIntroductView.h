//
//  HICLessonIntroductView.h
//  HiClass
//
//  Created by WorkOffice on 2020/2/4.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HICBaseInfoModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HICLessonIntroductView : UITableView
@property(nonatomic,strong)UIViewController *vc;
@property(nonatomic,strong)HICBaseInfoModel *baseModel;
@property (nonatomic,strong)NSArray *arrRelated;
@property (nonatomic,strong)NSArray *arrExercise;
@property (nonatomic,assign)BOOL isInside;
@property (nonatomic ,strong)NSNumber *trainId;
- (instancetype)initWithVC:(UIViewController *)vc;

@end

NS_ASSUME_NONNULL_END
