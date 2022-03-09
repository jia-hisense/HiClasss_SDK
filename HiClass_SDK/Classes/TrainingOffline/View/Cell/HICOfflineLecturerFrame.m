//
//  HICOfflineLecturerFrame.m
//  HiClass
//
//  Created by hisense on 2020/4/24.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import "HICOfflineLecturerFrame.h"
#import "NSString+String.h"

@implementation HICOfflineLecturerData

- (instancetype)initWithTitle:(NSString *)title iconUrl:(NSString *)iconUrl name:(NSString *)name post:(NSString *)post brief:(NSString *)brief isSeparatorHidden:(BOOL) isSeparatorHidden
{
    self = [super init];
    if (self) {
        self.title = title;
        self.iconUrl = iconUrl;
        self.name = name;
        self.post = post;
        self.brief = brief;
        self.isSeparatorHidden = isSeparatorHidden;
    }

    return self;
}

@end


@implementation HICOfflineLecturerFrame

- (instancetype)initWithData:(HICOfflineLecturerData *)data isOpened:(BOOL)isOpened
{
    self = [super init];
    if (self) {
        [self updateData:data isOpened:isOpened];
    }
    return self;
}



- (void)updateData:(HICOfflineLecturerData *)data isOpened:(BOOL)isOpened {

    self.data = data;
    self.isOpened = isOpened;

}

- (void)setIsOpened:(BOOL)isOpened {

    _isOpened = isOpened;

    CGFloat topPadding = 16;
    CGFloat leftPadding = 16;
    CGFloat bottomPadding = 12;
    CGFloat rightPadding = 16;

    CGFloat cellW = HIC_ScreenWidth;

    _titleLblF = CGRectMake(leftPadding, topPadding, cellW-(leftPadding+rightPadding), 24);

    _iconImgViewF = CGRectMake(leftPadding, CGRectGetMaxY(_titleLblF) + 12, 44, 44);

    CGFloat nameLblFX = CGRectGetMaxX(_iconImgViewF)+8;
    CGFloat nameLblFY = CGRectGetMinY(_iconImgViewF);
    CGFloat nameLblFW = cellW - rightPadding - nameLblFX;
    _nameLblF = CGRectMake(nameLblFX, nameLblFY, nameLblFW, 24);

    CGRect postLblF;

    if ([NSString isValidString:_data.post]) {
        _postLblF = CGRectMake(CGRectGetMinX(_nameLblF), CGRectGetMaxY(_nameLblF), nameLblFW, 20);
        postLblF = _postLblF;
    } else {
        _postLblF = CGRectZero;
        postLblF = _nameLblF;
    }


    CGFloat briefLblFY = CGRectGetMaxY(postLblF) + 8;
    CGSize size = [[NSString realString:_data.brief] sizeWithFont:[UIFont fontWithName:@"PingFangSC-Regular" size:14] maxSize:CGSizeMake(CGRectGetWidth(postLblF), MAXFLOAT)];
    if (size.height <= 40) {
        // 不需要展示更多
        _openBtnF = CGRectZero;
        _shrinkBtnF = CGRectZero;

        _briefLblF = CGRectMake(CGRectGetMinX(postLblF), briefLblFY, CGRectGetWidth(postLblF), size.height);

        _cellHeight = CGRectGetMaxY(_briefLblF) + bottomPadding;


        _separatorLineViewF = CGRectMake(leftPadding, _cellHeight-0.5, cellW-leftPadding, 0.5);

        return;

    }

    if (isOpened) {
        _openBtnF = CGRectZero;
        NSString *contentStr = [NSString realString:_data.brief];
        CGSize size = [contentStr sizeWithFont:[UIFont fontWithName:@"PingFangSC-Regular" size:14] maxSize:CGSizeMake(CGRectGetWidth(postLblF), MAXFLOAT)];
        _briefLblF = CGRectMake(CGRectGetMinX(postLblF), briefLblFY, CGRectGetWidth(postLblF), size.height);

        _shrinkBtnF = CGRectMake(CGRectGetMinX(postLblF), CGRectGetMaxY(_briefLblF) - 6, 120, 45);

        _cellHeight = CGRectGetMaxY(_shrinkBtnF);

    } else {
        _shrinkBtnF = CGRectZero;

        NSString *contentStr = [NSString realString:_data.brief];
        CGSize size = [contentStr sizeWithFont:[UIFont fontWithName:@"PingFangSC-Regular" size:14] maxSize:CGSizeMake(CGRectGetWidth(_titleLblF), 40)];
        _briefLblF = CGRectMake(CGRectGetMinX(postLblF), briefLblFY, CGRectGetWidth(postLblF), size.height);

        _openBtnF = CGRectMake(CGRectGetMinX(postLblF), CGRectGetMaxY(_briefLblF) - 6, 120, 45);

        _cellHeight = CGRectGetMaxY(_openBtnF);

    }

    _separatorLineViewF = CGRectMake(leftPadding, _cellHeight-0.5, cellW-leftPadding, 0.5);



}


@end
