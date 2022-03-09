//
//  HomeworkImagePreviewCell.h
//  HiClass
//
//  Created by 铁柱， on 2020/4/1.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HomeworkDetailModel.h"
#import "HICHomeWorkWriteVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomeworkImagePreviewCell : UICollectionViewCell

@property (nonatomic, strong) HomeworkDetailAttachmentModel *attModel;

@property (nonatomic, strong) HomeworkImageModel *imageModel;

@property (nonatomic, copy) NSString *imagePath;

@property (nonatomic, copy) NSString *imageName;

@end

NS_ASSUME_NONNULL_END
