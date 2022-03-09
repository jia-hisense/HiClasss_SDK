//
//  HICStudyDocPhotoDetailView.h
//  HiClass
//
//  Created by Sir_Jing on 2020/2/10.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HICControlInfoModel.h"
NS_ASSUME_NONNULL_BEGIN
@protocol HICStudyDocPhotoDetailDelegate <NSObject>
@optional
- (void)removeDetailViewWithIndex:(NSInteger)currentIndex;
@optional
- (void)returnIndex:(NSInteger)currentIndex;
@optional
- (void)studyDocPhotoDetailViewDidClickedPicture;

@end
@interface HICStudyDocPhotoDetailView : UIView

@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) HICControlInfoModel *model;
@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, weak) id<HICStudyDocPhotoDetailDelegate>delegate;

- (void)scrollViewTo:(NSInteger)currentIndex;
- (void)relayoutWithOrentation:(BOOL)isLandscape;

@end

NS_ASSUME_NONNULL_END
