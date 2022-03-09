//
//  UIButton+HICExtendClickFrame.m
//  HiClass
//
//  Created by WorkOffice on 2020/2/12.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "UIButton+HICExtendClickFrame.h"
#import <objc/runtime.h>
static char hicTopKey;
static char hicLeftKey;
static char hicBottomKey;
static char hicRightKey;
@implementation UIButton (HICExtendClickFrame)
- (void)hicChangeButtonClickLength:(CGFloat)length{
    [self hicChangeButtonClickRange:HICClickEdgeInsetsMake(length, length, length, length)];
}
- (void)hicChangeButtonClickRange:(HICClickEdgeInsets)edgeInsets{
    objc_setAssociatedObject(self, &hicTopKey, [NSNumber numberWithFloat:edgeInsets.top], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &hicLeftKey, [NSNumber numberWithFloat:edgeInsets.left], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &hicBottomKey, [NSNumber numberWithFloat:edgeInsets.bottom], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &hicRightKey, [NSNumber numberWithFloat:edgeInsets.right], OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    CGRect rect = [self enlargedRect];
    if (CGRectEqualToRect(rect, self.bounds))
    {
        return [super hitTest:point withEvent:event];
    }
    return CGRectContainsPoint(rect, point) ? self : nil;
}

- (CGRect)enlargedRect
{
    NSNumber *topEdge = objc_getAssociatedObject(self, &hicTopKey);
    NSNumber *leftEdge = objc_getAssociatedObject(self, &hicLeftKey);
    NSNumber *bottomEdge = objc_getAssociatedObject(self, &hicBottomKey);
    NSNumber *rightEdge = objc_getAssociatedObject(self, &hicRightKey);
    if (topEdge && rightEdge && bottomEdge && leftEdge){
        return CGRectMake(self.bounds.origin.x - leftEdge.floatValue,
                          self.bounds.origin.y - topEdge.floatValue,
                          self.bounds.size.width + leftEdge.floatValue + rightEdge.floatValue,
                          self.bounds.size.height + topEdge.floatValue + bottomEdge.floatValue);
    } else {
        return self.bounds;
    }
}

@end
