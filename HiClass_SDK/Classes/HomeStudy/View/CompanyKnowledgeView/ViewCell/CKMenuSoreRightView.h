//
//  CKMenuSoreRightView.h
//  HiClass
//
//  Created by wangggang on 2020/3/23.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HICCompanyMenuModel.h"

NS_ASSUME_NONNULL_BEGIN
@class CKMenuSoreRightView;
@protocol CKMenuSoreRightViewDelegate <NSObject>

-(void)soreRightView:(CKMenuSoreRightView *)view clicCell:(UITableViewCell *)cell hasMore:(BOOL)isMore dataSource:(NSArray *)dataSource parentModel:(HICCompanyMenuModel *)parentModel;

-(void)soreRightView:(CKMenuSoreRightView *)view clicCell:(UITableViewCell *)cell hasMore:(BOOL)isMore selectID:(NSString *)selectID parentModel:(HICCompanyMenuModel *)parentModel;

@end

@interface CKMenuSoreRightView : UITableView

@property (nonatomic, strong) HICCompanyMenuModel *parentModel;

@property (nonatomic, strong) NSArray *data;

@property (nonatomic, weak) id<CKMenuSoreRightViewDelegate> viewDelegate;

@end

NS_ASSUME_NONNULL_END
