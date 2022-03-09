//
//  HICPreviewScrollVC.h
//  自定义Layout标签
//
//  Created by Sir_Jing on 2020/5/9.
//  Copyright © 2020 崔志伟. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class HICPreviewScrollVCCell;
@protocol HICPreviewScrollVCCellDelegate <NSObject>

@optional
-(void)previewCell:(HICPreviewScrollVCCell *)cell didClickBackTap:(UITapGestureRecognizer *)tap other:(id __nullable)data;

@end
@interface HICPreviewScrollVCCell : UICollectionViewCell

@property (nonatomic, copy) NSString *urlString;

@property (nonatomic, weak) id <HICPreviewScrollVCCellDelegate> delegate;

@end

@interface HICPreviewScrollVC : UIViewController

@property (nonatomic, strong) NSArray<NSString *> *dataSource;

@end

NS_ASSUME_NONNULL_END
