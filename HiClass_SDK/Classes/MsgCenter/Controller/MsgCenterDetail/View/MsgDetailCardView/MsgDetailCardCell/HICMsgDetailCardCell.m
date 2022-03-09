//
//  HICMsgDetailCardCell.m
//  HiClass
//
//  Created by Eddie Ma on 2020/2/26.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICMsgDetailCardCell.h"
#import "HICMsgModel.h"

@interface HICMsgDetailCardCell()

@property (nonatomic, strong) UIView *container;
@property (nonatomic, strong) UILabel *redPoint;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *content;
@property (nonatomic, strong) UILabel *time;
@property (nonatomic, assign) HICMsgType type;
@end

@implementation HICMsgDetailCardCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {

    self.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1/1.0];

    self.container = [[UIView alloc] init];
    [self.contentView addSubview: _container];
    _container.backgroundColor = [UIColor whiteColor];
    _container.layer.cornerRadius = 4;
    _container.layer.masksToBounds = YES;

    self.redPoint = [[UILabel alloc] init];
    [_container addSubview:_redPoint];
    _redPoint.backgroundColor = [UIColor colorWithRed:255/255.0 green:75/255.0 blue:75/255.0 alpha:1/1.0];
    _redPoint.layer.cornerRadius  =3.5;
    _redPoint.layer.masksToBounds = YES;
    _redPoint.hidden = YES;

    self.title = [[UILabel alloc] init];
    [_container addSubview:_title];
    _title.font = FONT_REGULAR_17;
    _title.textColor = [UIColor colorWithRed:24/255.0 green:24/255.0 blue:24/255.0 alpha:1/1.0];

    self.time = [[UILabel alloc] init];
    [_container addSubview:_time];
    _time.textColor = [UIColor colorWithRed:185/255.0 green:185/255.0 blue:185/255.0 alpha:1/1.0];

    self.content = [[UILabel alloc] init];
    [_container addSubview:_content];
    _content.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1/1.0];
    _content.numberOfLines = 0;

}

- (void)setData:(HICMsgModel *)model index:(NSInteger)index type:(HICMsgType)type {
    self.type = type;
    CGFloat titleTopMargin = 12;
    CGFloat titleHeight = 20 + 8;
    CGFloat contentBtmMargin = 16;
    if (_type == HICMsgTypeTask || _type == HICMsgTypeToDo) {
        titleTopMargin = 16;
        titleHeight = 24 + 8;
    }
    CGFloat contentH = [self getContentHeight:model.msgContent];
    CGFloat containerH =   titleTopMargin + titleHeight + contentH + contentBtmMargin;
    _container.frame = CGRectMake(12, 12, HIC_ScreenWidth - 12 * 2, containerH);

    if ([model.msgStatus integerValue] == 0) { // 未读
        _redPoint.hidden = NO;
        CGFloat redPointH = 18.5;
        if (_type == HICMsgTypeTask || _type == HICMsgTypeToDo || _type == HICMsgTypeComment) {
            redPointH = 24.5;
        }
        _redPoint.frame = CGRectMake(6, redPointH, 7, 7);
    } else { // 已读
        _redPoint.hidden = YES;
    }

    if ([NSString isValidStr:model.msgTitle] && _type != HICMsgTypeInteract) {
        _title.hidden = NO;
        _title.frame = CGRectMake(16, contentBtmMargin, _container.frame.size.width - 2 * 16, 24);
        _title.text = model.msgTitle;
    } else {
        _title.hidden = YES;
    }

    NSNumber *currentTime = [NSNumber numberWithInt:[[NSDate date] timeIntervalSince1970]];
    _time.text = [HICCommonUtils isSameDayWithTime:model.msgTime isSecs:YES beComparedTime:currentTime] ? [HICCommonUtils timeStampToReadableDate:model.msgTime isSecs:YES format:@"HH:mm"] : [HICCommonUtils timeStampToReadableDate:model.msgTime isSecs:YES format:@"yyyy-MM-dd HH:mm"];

    CGFloat contentY = 48;
    if (_type == HICMsgTypeTask || _type == HICMsgTypeToDo || _type == HICMsgTypeComment) {
        _time.font = FONT_REGULAR_13;
        CGSize timeSize = [HICCommonUtils sizeOfString:_time.text stringWidthBounding:_container.frame.size.width font:13 stringOnBtn:NO fontIsRegular:YES];
        _time.frame = CGRectMake(_container.frame.size.width - timeSize.width - 16, 18.5, timeSize.width, 18.5);
        _content.font = FONT_REGULAR_14;
    } else {
        _time.font = FONT_REGULAR_14;
        CGSize timeSize = [HICCommonUtils sizeOfString:_time.text stringWidthBounding:_container.frame.size.width font:14 stringOnBtn:NO fontIsRegular:YES];
        _time.frame = CGRectMake(16, 12, timeSize.width, 20);
        contentY = 40;
        _content.font = FONT_REGULAR_15;
    }
    _content.frame = CGRectMake(16, contentY, _container.frame.size.width - 2 * 16, contentH);
    _content.text = model.msgContent;
}

- (CGFloat)getContentHeight:(NSString *)str {
    UILabel *label = [[UILabel alloc] init];
    label.text = str;
    NSInteger fontInteger = 15;
    if (_type == HICMsgTypeTask || _type == HICMsgTypeToDo) {
        label.font = FONT_REGULAR_14;
        fontInteger = 14;
    } else {
        label.font = FONT_REGULAR_15;
    }
    label.numberOfLines = 0;
    CGFloat labelHeight = [HICCommonUtils sizeOfString:str stringWidthBounding:HIC_ScreenWidth - 2 * 28 font:fontInteger stringOnBtn:NO fontIsRegular:YES].height;
    label.frame = CGRectMake(0, 0, HIC_ScreenWidth - 2 * 28, labelHeight);
    [label sizeToFit];
    return label.frame.size.height;
}

@end
