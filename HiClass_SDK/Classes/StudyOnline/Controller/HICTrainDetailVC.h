//
//  HICTrainDetailVC.h
//  HiClass
//
//  Created by WorkOffice on 2020/3/4.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^MapDetailBlock)(BOOL isSync);
@interface HICTrainDetailVC : UIViewController
@property (nonatomic, strong)NSNumber *trainId;
/// 是否是岗位地图过来的
@property(nonatomic, assign) BOOL isMapPush;
//岗位路线id
@property (nonatomic, strong) NSNumber *wayId;
//岗位地图id
@property (nonatomic, strong) NSNumber *postId;
@property (nonatomic, assign)BOOL isReload;
@property (nonatomic, copy)MapDetailBlock block;
-(void)initListData;
@end

NS_ASSUME_NONNULL_END


