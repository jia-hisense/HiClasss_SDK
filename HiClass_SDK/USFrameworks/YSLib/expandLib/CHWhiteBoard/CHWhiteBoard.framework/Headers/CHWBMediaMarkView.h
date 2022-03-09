//
//  CHWBMediaMarkView.h
//  CHWhiteBoard
//
//  Created by jiang deng on 2021/1/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CHWBMediaMarkView : UIView

- (instancetype)initWithFrame:(CGRect)frame fileId:(NSString *)fileId;

- (void)freshViewWithSavedSharpsData:(NSArray <NSDictionary *> *)sharpsDataArray videoRatio:(CGFloat)videoRatio;

- (void)freshViewWithData:(NSDictionary *)data savedSharpsData:(NSArray <NSDictionary *> *)sharpsDataArray;

@end

NS_ASSUME_NONNULL_END
