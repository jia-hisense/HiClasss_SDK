//
//  HICPhotoPickerVC.h
//  HiClass
//
//  Created by Eddie Ma on 2020/1/14.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HICPhotoPickerVCDelegate <NSObject>
@optional
- (void)photoSelecedDone:(NSArray *)arr;
@end

@interface HICPhotoPickerVC : UIViewController
@property (nonatomic, weak) id<HICPhotoPickerVCDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *photosBefore;
@property (nonatomic, assign) NSInteger selectedPhotosBefore;
@property (nonatomic, strong) NSString *maximumPhoto;

@end

NS_ASSUME_NONNULL_END
