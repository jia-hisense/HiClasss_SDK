//
//  CHDocumentViewProtocol.h
//  CloudHubWhiteBoardKit
//
//  Created by jiang deng on 2020/12/1.
//

#ifndef CHDocumentViewProtocol_h
#define CHDocumentViewProtocol_h

#import "WBDrawViewProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@protocol CHDocumentViewDelegate <WBDrawViewDelegate>

@optional

/// 课件窗口点击事件
- (void)onDrawViewClicked;

/// 移动ScrollView
- (void)onScrollViewDidScroll;

/// 手势改变ZoomScale
- (void)onZoomScaleChanged:(CGFloat)zoomScale;

/// 课件加载结果
- (void)onWhiteBoardViewLoadFinishedWithFileId:(NSString *)fileId currentPage:(NSUInteger)currentPage totalPage:(NSUInteger)totalPage canPrevPage:(BOOL)canPrevPage canNextPage:(BOOL)canNextPage canZoom:(BOOL)canZoom isSuccess:(BOOL)isSuccess;

@end

NS_ASSUME_NONNULL_END

#endif /* CHDocumentViewProtocol_h */
