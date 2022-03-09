//
//  HICEnrollReviewerList.h
//  HiClass
//
//  Created by WorkOffice on 2020/6/9.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HICEnrollReviewModel.h"
NS_ASSUME_NONNULL_BEGIN
typedef void (^ReturnNameBlock) (NSString * name,NSNumber *ID);
@protocol HICEnrollReviewerDelegate <NSObject>
@optional
- (void)selectReviewerWithModel:(HICEnrollReviewerModel *)model;
@end
@interface HICEnrollReviewerList : UIViewController
@property (nonatomic ,strong)NSArray *dataArr;
@property (nonatomic ,strong)NSString *naviTitle;
@property (nonatomic ,assign)NSInteger type;
@property (nonatomic ,strong)NSIndexPath *indexPath;
@property (nonatomic ,weak)id<HICEnrollReviewerDelegate>delegete;
@property (nonatomic ,copy) ReturnNameBlock returnNameBlock;
@property (nonatomic ,strong)NSNumber *auditorId;
@end

NS_ASSUME_NONNULL_END
