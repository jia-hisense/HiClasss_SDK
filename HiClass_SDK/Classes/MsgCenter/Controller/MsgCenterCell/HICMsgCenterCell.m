//
//  HICMsgCenterCell.m
//  HiClass
//
//  Created by Eddie Ma on 2020/2/26.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICMsgCenterCell.h"

@interface HICMsgCenterCell()

@property (nonatomic, strong)UIImageView *imageV;
@property (nonatomic, strong)UILabel *hintNum;
@property (nonatomic, strong)UILabel *title;
@property (nonatomic, strong)UILabel *subTitle;
@property (nonatomic, strong)UILabel *timeLabel;

@end

@implementation HICMsgCenterCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    self.backgroundColor = [UIColor whiteColor];

    self.imageV = [[UIImageView alloc] initWithFrame:CGRectMake(16, (MSG_CENTER_CELL_HEIGHT - 52)/2, 52, 52)];
    [self.contentView addSubview: _imageV];

    self.hintNum = [[UILabel alloc] init];
    [_imageV addSubview: _hintNum];
    _hintNum.backgroundColor = [UIColor colorWithRed:255/255.0 green:75/255.0 blue:75/255.0 alpha:1/1.0];
    _hintNum.textColor = [UIColor whiteColor];
    _hintNum.font = FONT_REGULAR_12;
    _hintNum.layer.cornerRadius = 9;
    _hintNum.layer.masksToBounds = YES;
    _hintNum.layer.borderWidth = 0.5;
    _hintNum.layer.borderColor = [UIColor whiteColor].CGColor;
    _hintNum.textAlignment = NSTextAlignmentCenter;
    _hintNum.hidden = YES;

    self.title = [[UILabel alloc] initWithFrame:CGRectMake(16 + _imageV.frame.size.width + 12, 16, (HIC_ScreenWidth - 80 - 16)/2, 24)];
    [self.contentView  addSubview: _title];
    _title.font = FONT_REGULAR_17;
    _title.textColor = [UIColor colorWithRed:24/255.0 green:24/255.0 blue:24/255.0 alpha:1/1.0];

    self.subTitle = [[UILabel alloc] initWithFrame:CGRectMake(16 + _imageV.frame.size.width + 12, MSG_CENTER_CELL_HEIGHT - 20 - 15.5, HIC_ScreenWidth - 80 - 16, 20)];
    [self.contentView  addSubview: _subTitle];
    _subTitle.font = FONT_REGULAR_14;
    _subTitle.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1/1.0];

    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(16 + _imageV.frame.size.width + 12, MSG_CENTER_CELL_HEIGHT - 20 - 15.5, HIC_ScreenWidth - 80 - 16, 20)];
    [self.contentView  addSubview: _timeLabel];
    _timeLabel.font = FONT_REGULAR_13;
    _timeLabel.textColor = [UIColor colorWithRed:185/255.0 green:185/255.0 blue:185/255.0 alpha:1/1.0];
    _timeLabel.hidden = YES;

    UIView *dividedLine = [[UIView alloc] initWithFrame:CGRectMake(85, MSG_CENTER_CELL_HEIGHT - 0.5, HIC_ScreenWidth - 85, 0.5)];
    [self.contentView  addSubview: dividedLine];
    dividedLine.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1/1.0];

}

- (void)setData:(HICMsgCenterCellModel *)cellModel index:(NSInteger)index {
    _imageV.image = [UIImage imageNamed:cellModel.msgCellImageName];
    _title.text = cellModel.msgCellTitle;
    _subTitle.text = cellModel.msgCellSubTitle;
    if ([cellModel.msgCellHintNum intValue] > 0) {
        NSString *hintNumStr = [NSString stringWithFormat:@"%@", cellModel.msgCellHintNum];
        _hintNum.hidden = NO;
        CGSize hintNumSize = [HICCommonUtils sizeOfString:hintNumStr stringWidthBounding:_imageV.frame.size.width font:12 stringOnBtn:NO fontIsRegular:YES];
        CGFloat hintNumW = 18;
        if (hintNumSize.width >= 13.5 && hintNumSize.width < 19) {
            hintNumW = hintNumSize.width + 8;
        } else if (hintNumSize.width >= 19) {
            hintNumStr = @"...";
        }
        DDLogDebug(@"casdas %f", hintNumSize.width);
        _hintNum.frame = CGRectMake(_imageV.frame.size.width - hintNumW/2, -18/2, hintNumW, 18);
        _hintNum.text = hintNumStr;
    } else {
        _hintNum.hidden = YES;
    }

    if (cellModel.msgCellTime) {
        _timeLabel.hidden = NO;
        NSNumber *currentTime = [NSNumber numberWithInt:[[NSDate date] timeIntervalSince1970]];
        NSString *timeStr = [HICCommonUtils isSameDayWithTime:cellModel.msgCellTime isSecs:YES beComparedTime:currentTime] ? [HICCommonUtils timeStampToReadableDate:cellModel.msgCellTime isSecs:YES format:@"HH:mm"] : [HICCommonUtils timeStampToReadableDate:cellModel.msgCellTime isSecs:YES format:@"yyyy-MM-dd HH:mm"];
        CGSize timeStrSize = [HICCommonUtils sizeOfString:timeStr stringWidthBounding:HIC_ScreenWidth - 80 - 16 font:13 stringOnBtn:NO fontIsRegular:YES];
        _timeLabel.frame = CGRectMake(HIC_ScreenWidth - timeStrSize.width - 16, 16, timeStrSize.width, 18.5);
        _timeLabel.text = timeStr;
    } else {
        _timeLabel.hidden = YES;
    }
}

-  (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    //动画高亮变色效果
    [UIView animateWithDuration:0.3 animations:^{
        if(highlighted)
            self.contentView.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6"];
        else
            self.contentView.backgroundColor = [UIColor whiteColor];
    }];
}

@end
