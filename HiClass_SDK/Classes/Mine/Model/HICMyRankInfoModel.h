//
//  HICMyRankInfoModel.h
//  HiClass
//
//  Created by WorkOffice on 2020/3/20.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HICMyRankInfoModel : NSObject
/**
 
 "countType":"integer,类型：3-学分排行，4-积分排行，5-学时排行",
 "countTime":"integer,周期：0-周 1-月 2-年",
 "leaderboardList":[
     {
         "customerId":"long,用户ID",
         "name":"string,用户名称",
         "pic":"string,用户头像，空时终端取默认图",
         "dept":"string,部门信息",
         "score":"string,学分/学时/积分",
         "orderNum":"integer,排名"
     }
 ]
 */
@property (nonatomic ,strong)NSNumber *customerId;
@property (nonatomic ,strong)NSString *name;
@property (nonatomic ,strong)NSString *pic;
@property (nonatomic ,strong)NSString *dept;
@property (nonatomic ,strong)NSString *score;
@property (nonatomic ,assign)NSInteger orderNum;
@end

NS_ASSUME_NONNULL_END
