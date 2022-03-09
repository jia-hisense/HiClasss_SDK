//
//  CHWBMediaControlviewDelegate.h
//  CHWhiteBoard
//
//  Created by jiang deng on 2021/1/4.
//

#ifndef CHWBMediaControlviewDelegate_h
#define CHWBMediaControlviewDelegate_h

#import <CHSession/CHSharedMediaFileModel.h>

@protocol CHWBMediaControlviewDelegate <NSObject>

@optional

- (void)mediaControlviewPlay:(BOOL)isPause withFileModel:(CHSharedMediaFileModel *)mediaFileModel;

- (void)mediaControlviewSliderPos:(NSTimeInterval)value withFileModel:(CHSharedMediaFileModel *)mediaFileModel;

- (void)mediaControlviewCloseWithFileModel:(CHSharedMediaFileModel *)mediaFileModel;

@end

#endif /* CHWBMediaControlviewDelegate_h */
