//
//  PhotoVideoGetImage.m
//  HsShare3.5
//
//  Created by wangggang on 2019/11/26.
//  Copyright © 2019 com.hisense. All rights reserved.
//

#import "PhotoVideoGetImage.h"

@implementation PhotoVideoGetImage

-(void)getPhotoImageWithAsset:(PHAsset *)asset handel:(void (^)(PHAsset * _Nonnull, UIImage * _Nonnull))handel {
    
    PHImageRequestOptions *option1 = [[PHImageRequestOptions alloc] init];
    option1.resizeMode = PHImageRequestOptionsResizeModeFast;
    
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(200, 200) contentMode:PHImageContentModeDefault options:option1 resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        
        UIImage *image = result;
        if (handel) {
            handel(asset, image);
        }
    }];
    
}

@end
