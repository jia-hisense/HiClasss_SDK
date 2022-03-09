//
//  HICMyCollectView.h
//  HiClass
//
//  Created by WorkOffice on 2020/2/20.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^checkArrBlock)(NSMutableArray *checkArr);
@interface HICMyCollectView : UITableView
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSMutableArray *checkedArr;
- (void) isEditSelect:(BOOL)isEdit;
@property (nonatomic, copy) checkArrBlock checkArrblock ;
- (void)returnArr:(checkArrBlock)block;
@end

NS_ASSUME_NONNULL_END
