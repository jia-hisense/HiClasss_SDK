//
//  JHKOfflineCourseDefaultSectionView.h
//  JHKOffLineViewDemo
//
//  Created by wangggang on 2020/4/21.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHKOfflineCourseDefaultSectionView : UIView
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
+(instancetype)getDefaultSectionView;
@end

NS_ASSUME_NONNULL_END
