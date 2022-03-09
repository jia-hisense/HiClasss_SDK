//
//  HICKnowledgeDetailVC.h
//  HiClass
//
//  Created by Eddie Ma on 2020/3/10.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HICKnowledgeDetailVC : UIViewController

@property (nonatomic, assign) HICStudyResourceType kType;
@property (nonatomic, copy) NSString *urlStr;
// 第三方代码（智胜），第三方数据需要单独处理
@property (nonatomic, copy) NSString *partnerCode;
@property (nonatomic, assign) BOOL hideNavi;
@property (nonatomic, assign) BOOL hideTabbar;
@property (nonatomic, strong) NSNumber *objectId;
@property (nonatomic, strong) NSNumber *sectionId;
@property (nonatomic, strong) NSNumber *courseId;
@property (nonatomic, strong) NSNumber *trainId;
@property (nonatomic, assign) BOOL shouldFullScreen;

@end

NS_ASSUME_NONNULL_END
