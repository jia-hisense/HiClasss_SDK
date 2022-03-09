//
//  HomeworkImagePreViewVC.h
//  HiClass
//
//  Created by 铁柱， on 2020/4/1.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HomeworkImagePreviewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomeworkImagePreViewVC : UIViewController

@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, strong) NSArray<HomeworkDetailAttachmentModel *> *attachDataSource;

@property (nonatomic, strong) NSArray<HomeworkImageModel *> *imageDataSource;

@property (nonatomic, strong) NSArray<NSString *> *previewDownImages;

@property (nonatomic, strong) NSString *previewWithImageName;

@end

NS_ASSUME_NONNULL_END
