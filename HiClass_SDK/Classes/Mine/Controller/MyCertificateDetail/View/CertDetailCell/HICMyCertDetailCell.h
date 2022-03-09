//
//  HICMyCertDetailCell.h
//  HiClass
//
//  Created by Eddie_Ma on 18/4/20.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HICCertificateModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol HICMyCertDetailCellDelegate <NSObject>
@optional
- (void)imgClicked:(NSString *)url;
- (void)showAll:(BOOL)showAll index:(NSInteger)index;
@end

@interface HICMyCertDetailCell : UITableViewCell

@property (nonatomic, weak) id<HICMyCertDetailCellDelegate>delegate;

- (void)setData:(HICCertificateModel *)cerModel index:(NSInteger)index descShowAll:(BOOL)descShowAll;

@end

NS_ASSUME_NONNULL_END
