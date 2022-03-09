//
//  PhotoVideoGetImage.h
//  HsShare3.5
//
//  Created by wangggang on 2019/11/26.
//  Copyright © 2019 com.hisense. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface PhotoVideoGetImage : NSObject

-(void)getPhotoImageWithAsset:(PHAsset *)asset handel:(void (^)(PHAsset *asset, UIImage *image)) handel;

@end

NS_ASSUME_NONNULL_END
