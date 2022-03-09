//
//  HICCustomerLabel.m
//  iTest
//
//  Created by Sir_Jing on 2020/3/11.
//  Copyright © 2020 Sir_Jing. All rights reserved.
//

#import "HICCustomerLabel.h"

@implementation HICCustomerLabel

- (id)initWithFrame:(CGRect)frame {

    return [super initWithFrame:frame];

}

- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines {

    CGRect textRect = [super textRectForBounds:bounds limitedToNumberOfLines:numberOfLines];


    if (_contentInset.left != 0 && _contentInset.right != 0) {
        textRect.origin.x -= _contentInset.left;
//        textRect.origin.y -= _contentInset.top;
        textRect.size.width += _contentInset.left + _contentInset.right;
//        textRect.size.height += _contentInset.top + _contentInset.bottom;
    }else {
        textRect.origin.y = bounds.origin.y;
    }

    return textRect;

}

-(void)drawTextInRect:(CGRect)requestedRect {

    if (_contentInset.left != 0 && _contentInset.right != 0) {
        [super drawTextInRect:requestedRect];
    }else {
        CGRect actualRect = [self textRectForBounds:requestedRect limitedToNumberOfLines:self.numberOfLines];
        [super drawTextInRect:actualRect];
    }

}

@end
