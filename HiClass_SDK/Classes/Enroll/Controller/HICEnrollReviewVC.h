//
//  HICEnrollReviewVC.h
//  HiClass
//
//  Created by WorkOffice on 2020/6/5.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HICEnrollReviewVC : UIViewController
@property (nonatomic ,strong)NSNumber *auditTemplateID;
@property (nonatomic ,strong)NSNumber *registerID;
@property (nonatomic ,assign)NSInteger type;///1:模板选择审核人2：查看审核进度
@property (nonatomic ,strong)NSNumber *auditInstanceId;
@property (nonatomic ,strong)NSString *registerName;
@property (nonatomic ,strong)NSNumber *trainId;

@end

NS_ASSUME_NONNULL_END
