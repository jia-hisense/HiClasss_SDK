//
//  PhotoVideoPickerVC.h
//  HsShare3.5
//
//  Created by wangggang on 2019/10/26.
//  Copyright © 2019 com.hisense. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN



@class PhotoVideoPickerVC;
@protocol PhotoVideoPickerVCDelegate<NSObject>

@optional
-(void)videoPickerVC:(PhotoVideoPickerVC *)vc clickVideoFile:(NSString *)videoFile durat:(NSInteger)second ratio:(CGFloat)ratio;

@end

@interface PhotoVideoPickerVC : UIViewController

@property (nonatomic, weak) id <PhotoVideoPickerVCDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
