//
//  HICMsgDetailGroupMsgCell.m
//  HiClass
//
//  Created by Eddie Ma on 2020/2/27.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICMsgDetailGroupMsgCell.h"
#import "HICMsgModel.h"

@interface HICMsgDetailGroupMsgCell()

@property (nonatomic, strong) UIView *headBgView;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *subTitle;
@property (nonatomic, strong) UILabel *time;
@property (nonatomic, strong)UILabel *hintNum;

@end

@implementation HICMsgDetailGroupMsgCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    self.headBgView = [[UIView alloc] initWithFrame:CGRectMake(16, 16, 51, 51)];
    [self.contentView addSubview:_headBgView];

    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _headBgView.frame.size.width, _headBgView.frame.size.height)];
    [_headBgView addSubview:headView];
    headView.backgroundColor = [UIColor lightGrayColor];
    headView.layer.cornerRadius = 6;
    headView.layer.masksToBounds = YES;

    self.hintNum = [[UILabel alloc] init];
    [_headBgView addSubview: _hintNum];
    _hintNum.backgroundColor = [UIColor colorWithRed:255/255.0 green:75/255.0 blue:75/255.0 alpha:1/1.0];
    _hintNum.textColor = [UIColor whiteColor];
    _hintNum.font = FONT_REGULAR_12;
    _hintNum.layer.cornerRadius = 9;
    _hintNum.layer.masksToBounds = YES;
    _hintNum.layer.borderWidth = 0.5;
    _hintNum.layer.borderColor = [UIColor whiteColor].CGColor;
    _hintNum.textAlignment = NSTextAlignmentCenter;
    _hintNum.hidden = YES;

    CGFloat titleX = 16 + _headBgView.frame.size.width + 12;
    self.title = [[UILabel alloc] initWithFrame:CGRectMake(titleX, 16, HIC_ScreenWidth - 104 - titleX, 24)];
    [self.contentView addSubview:_title];
    _title.font = FONT_REGULAR_17;
    _title.textColor = [UIColor colorWithRed:24/255.0 green:24/255.0 blue:24/255.0 alpha:1/1.0];

    self.time = [[UILabel alloc] initWithFrame:CGRectMake(HIC_ScreenWidth - 104 - 16, 19, 104, 18.5)];
    [self.contentView addSubview:_time];
    _time.font = FONT_REGULAR_13;
    _time.textAlignment = NSTextAlignmentRight;
    _time.textColor = [UIColor colorWithRed:185/255.0 green:185/255.0 blue:185/255.0 alpha:1/1.0];

    self.subTitle = [[UILabel alloc] initWithFrame:CGRectMake(titleX, 46, HIC_ScreenWidth - 16 - titleX, 20)];
    [self.contentView addSubview:_subTitle];
    _subTitle.font = FONT_REGULAR_14;
    _subTitle.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1/1.0];

    UIView *dividedLine = [[UIView alloc] initWithFrame:CGRectMake(87, MSG_CENTER_GROUP_MSG_CELL_HEIGHT - 0.5, HIC_ScreenWidth - 87, 0.5)];
    [self.contentView addSubview:dividedLine];
    dividedLine.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1/1.0];

}

- (void)setData:(HICGroupMsgModel *)model index:(NSInteger)index {
    if ([model.unreadNum intValue] > 0) {
        NSString *hintNumStr = [NSString stringWithFormat:@"%@", model.unreadNum];
        _hintNum.hidden = NO;
        CGSize hintNumSize = [HICCommonUtils sizeOfString:hintNumStr stringWidthBounding:_headBgView.frame.size.width font:12 stringOnBtn:NO fontIsRegular:YES];
        CGFloat hintNumW = 18;
        DDLogDebug(@"zxczxc: %f",hintNumSize.width);
        if (hintNumSize.width >= 12 && hintNumSize.width < 13.5) {
            hintNumW = hintNumW + 4;
        } else if (hintNumSize.width >= 13.5 && hintNumSize.width < 20) {
            hintNumW = hintNumSize.width + 8;
        } else if (hintNumSize.width >= 20) {
            hintNumStr = @"...";
        }
        _hintNum.frame = CGRectMake(_headBgView.frame.size.width - hintNumW/2, -18/2, hintNumW, 18);
        _hintNum.text = hintNumStr;
    } else {
        _hintNum.hidden = YES;
    }
    _title.text = model.groupName;
    HICMsgModel *msgModel = model.messageList.firstObject;
    NSNumber *currentTime = [NSNumber numberWithInt:[[NSDate date] timeIntervalSince1970]];
    _time.text = [HICCommonUtils isSameDayWithTime:msgModel.msgTime isSecs:YES beComparedTime:currentTime] ? [HICCommonUtils timeStampToReadableDate:msgModel.msgTime isSecs:YES format:@"HH:mm"] : [HICCommonUtils timeStampToReadableDate:msgModel.msgTime isSecs:YES format:@"yyyy-MM-dd"];
    _subTitle.text = msgModel.msgContent;
}

@end
