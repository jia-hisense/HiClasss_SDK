//
//  HICHomeworkListCell.m
//  HiClass
//
//  Created by Eddie Ma on 2020/3/11.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICHomeworkListCell.h"

@interface HICHomeworkListCell ()

@property (nonatomic, strong) UIImageView *courseImg;
@property (nonatomic, strong) UIImageView *arrow;
@property (nonatomic, strong) UIImageView *tagIV;
@property (nonatomic, strong) UILabel *content;
@property (nonatomic, strong) UILabel *status;
@property (nonatomic, strong) UILabel *statusDesc;
@property (nonatomic, strong) UIView *dividedLine;
@property (nonatomic, strong) UIView *gradientLabelView;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@end

@implementation HICHomeworkListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    self.backgroundColor = [UIColor whiteColor];

    self.courseImg = [[UIImageView alloc] initWithFrame:CGRectMake(16, (HOMEWORK_FIRST_CELL_HEIGHT - 8 - 47)/2, 84, 47)];
    [self.contentView addSubview:_courseImg];
    _courseImg.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1/1.0];
    _courseImg.layer.cornerRadius = 2;
    _courseImg.layer.masksToBounds = YES;
    _courseImg.hidden = YES;

    self.arrow = [[UIImageView alloc] initWithFrame:CGRectMake(HIC_ScreenWidth - 7 - 16, (HOMEWORK_FIRST_CELL_HEIGHT - 8 - 12)/2, 7, 12)];
//    [self addSubview:_arrow];
    _arrow.image = [UIImage imageNamed:@"跳转箭头"];

    self.content = [[UILabel alloc] init];
    [self.contentView addSubview:_content];
    _content.font = FONT_REGULAR_16;
    _content.numberOfLines = 2;

    self.gradientLabelView = [[UIView alloc] init];
    [self.contentView addSubview:_gradientLabelView];
    _gradientLabelView.layer.cornerRadius = 2;
    _gradientLabelView.layer.masksToBounds = YES;
    self.gradientLayer = [CAGradientLayer layer];

    self.status = [[UILabel alloc] init];
    [_gradientLabelView addSubview:_status];
    _status.font = FONT_MEDIUM_11;
    _status.backgroundColor = [UIColor clearColor];
    _status.layer.cornerRadius = 2;
    _status.layer.masksToBounds = YES;
    _status.textAlignment = NSTextAlignmentCenter;
    _status.textColor = [UIColor whiteColor];

    self.statusDesc = [[UILabel alloc] init];
    [self.contentView addSubview:_statusDesc];
    _statusDesc.font = FONT_REGULAR_14;

    self.tagIV = [[UIImageView alloc] init];
    [self.contentView addSubview:_tagIV];

    self.dividedLine = [[UIView alloc] init];
    [self.contentView addSubview: _dividedLine];
    _dividedLine.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1/1.0];
}

- (void)setData:(HICHomeworkModel *)hModel index:(NSInteger)index {
    if (index == 0) {
        _courseImg.hidden = NO;
        _arrow.hidden = NO;
        _statusDesc.hidden = YES;
        _gradientLabelView.hidden = YES;
        _tagIV.hidden = YES;

        _dividedLine.frame = CGRectMake(0, HOMEWORK_FIRST_CELL_HEIGHT - 8, HIC_ScreenWidth, 8);
        _dividedLine.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1/1.0];
        CGFloat cellHeight = 17;
        _content.text = hModel.workName;
        _content.textColor =  [UIColor colorWithRed:24/255.0 green:24/255.0 blue:24/255.0 alpha:1/1.0];
        CGSize contentSize = [HICCommonUtils sizeOfString:_content.text stringWidthBounding:HIC_ScreenWidth - 112 - 44 font:16 stringOnBtn:NO fontIsRegular:YES];
        _content.frame = CGRectMake(112, cellHeight, HIC_ScreenWidth - 112 - 44, contentSize.height);
        [_content sizeToFit];
        if (hModel.coverPic) {
            [_courseImg sd_setImageWithURL:[NSURL URLWithString:hModel.coverPic] placeholderImage:[UIImage imageNamed:@"作业-默认"]];
        }
        if (![NSString isValidStr:hModel.workName] && ![NSString isValidStr:hModel.coverPic]) {
            _courseImg.hidden = YES;
            _arrow.hidden = YES;
            _dividedLine.height = 0;
        }

    } else {
        _courseImg.hidden = YES;
        _arrow.hidden = YES;
        _statusDesc.hidden = NO;
        _gradientLabelView.hidden = NO;
        _tagIV.hidden = YES;
        [_tagIV.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

        CGFloat cellHeight = 12;
        [self.gradientLayer removeFromSuperlayer];
        self.gradientLayer = [CAGradientLayer layer];
        _gradientLabelView.frame = CGRectMake(16, cellHeight, 44, 17);
        NSString *statusText = @"";
        if (hModel.jobStatus == HICHomeworkNotStart) {
            statusText = NSLocalizableString(@"notStarted", nil);
            [HICCommonUtils createGradientLayerWithLabel:_gradientLabelView gradientLayer:self.gradientLayer fromColor:[UIColor colorWithHexString:@"FFC76C" alpha:1.0f] toColor:[UIColor colorWithHexString:@"FFB843" alpha:1.0f]];
        } else if (hModel.jobStatus == HICHomeworkWaitForCompleting) {
            statusText = NSLocalizableString(@"pending", nil);
            [HICCommonUtils createGradientLayerWithLabel:_gradientLabelView gradientLayer:self.gradientLayer fromColor:[UIColor colorWithHexString:@"FF6F00" alpha:1.0f] toColor:[UIColor colorWithHexString:@"FF9624" alpha:1.0f]];
        } else if (hModel.jobStatus == HICHomeworkWaitForGrading) {
            statusText = NSLocalizableString(@"waitExamines", nil);
            [HICCommonUtils createGradientLayerWithLabel:_gradientLabelView gradientLayer:self.gradientLayer fromColor:[UIColor colorWithHexString:@"30CFFF" alpha:1.0f] toColor:[UIColor colorWithHexString:@"00B5E5" alpha:1.0f]];
        } else if (hModel.jobStatus == HICHomeworkGrading) {
            statusText = NSLocalizableString(@"reviewing", nil);
            [HICCommonUtils createGradientLayerWithLabel:_gradientLabelView gradientLayer:self.gradientLayer fromColor:[UIColor colorWithHexString:@"30CFFF" alpha:1.0f] toColor:[UIColor colorWithHexString:@"2C87F2" alpha:1.0f]];
        } else if (hModel.jobStatus == HICHomeworkCompleted) {
            statusText = NSLocalizableString(@"hasBeenCompleted", nil);
            [HICCommonUtils createGradientLayerWithLabel:_gradientLabelView gradientLayer:self.gradientLayer fromColor:[UIColor colorWithHexString:@"D0D0D0" alpha:1.0f] toColor:[UIColor colorWithHexString:@"D0D0D0" alpha:1.0f]];
            _tagIV.hidden = NO;
            if ([hModel.scoreType isEqualToNumber:@1]) {
                 if (hModel.pass && [hModel.pass integerValue] == 1) {
                     if (hModel.maxScore && [hModel.score integerValue] == [hModel.maxScore integerValue]) {
                         _tagIV.image = [UIImage imageNamed:@"印章-满分"];
                     } else{
                         _tagIV.image = [UIImage imageNamed:@"分数印章"];
                         if ([hModel.scoreType isEqualToNumber:@1]) {
                             CGSize gradeSize = [HICCommonUtils sizeOfString:[hModel.score toString] stringWidthBounding:72 font:22 stringOnBtn:NO fontIsRegular:NO];
                             UILabel *grade = [[UILabel alloc] initWithFrame:CGRectMake((72 - gradeSize.width)/2, (72 - gradeSize.height)/2, gradeSize.width, gradeSize.height)];
                             [_tagIV addSubview:grade];
                             grade.text = [hModel.score toString];
                             grade.font = FONT_MEDIUM_22;
                             grade.textColor = [UIColor colorWithHexString:@"#14BE6E" alpha:0.5];
                             [HICCommonUtils setTransform:-30.0/180 forLable:grade];
                         }
                     }
                }else{
                    _tagIV.image = [UIImage imageNamed:@"印章-不合格"];
                }
            }
             else {
                 if (hModel.pass && [hModel.pass integerValue] == 1) {
                     _tagIV.image = [UIImage imageNamed:@"分数印章"];
                 }else{
                     _tagIV.image = [UIImage imageNamed:@"印章-不合格"];
                 }
            }
            if (hModel.essence && hModel.essence.integerValue == 1) {
                if (_tagIV.subviews.count > 0) {
                    [_tagIV.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                }
                _tagIV.image = [UIImage imageNamed:@"印章-精华"];
            }

        } else {}
        _status.text = statusText;
        _status.frame = CGRectMake(0, 0, _gradientLabelView.frame.size.width, _gradientLabelView.frame.size.height);

        cellHeight = cellHeight + _status.frame.size.height + 10;

        _content.text = hModel.name;
        _content.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
        CGSize contentSize = [HICCommonUtils sizeOfString:_content.text stringWidthBounding:HIC_ScreenWidth - 2 * 16 font:16 stringOnBtn:NO fontIsRegular:YES];
        _content.frame = CGRectMake(16, cellHeight, HIC_ScreenWidth - 2 * 16, contentSize.height);
        [_content sizeToFit];

        cellHeight = cellHeight + _content.frame.size.height + 5;

        if (hModel.jobStatus == HICHomeworkNotStart) {
            NSString *timeStr = [hModel.endTime isEqualToNumber:@0]?[NSString stringWithFormat:@"%@: %@",NSLocalizableString(@"dendline", nil),NSLocalizableString(@"unlimited", nil)]: [NSString stringWithFormat:@"%@: %@", NSLocalizableString(@"dendline", nil),[HICCommonUtils timeStampToReadableDate:hModel.endTime isSecs:YES format:@"MM-dd HH:mm"]];
            _statusDesc.text = timeStr;
            _statusDesc.textColor = [UIColor colorWithRed:133/255.0 green:133/255.0 blue:133/255.0 alpha:1/1.0];
            _statusDesc.frame = CGRectMake(16, cellHeight, HIC_ScreenWidth - 2 * 16, 20);
        }else if (hModel.jobStatus == HICHomeworkWaitForCompleting) {
            if (hModel.isTimeOut && hModel.isTimeOut.integerValue == 1) {
                _statusDesc.text = [NSString stringWithFormat:NSLocalizableString(@"timeoutWarning", nil)];
                _statusDesc.textColor = [UIColor colorWithHexString:@"#ff8500"];
                _statusDesc.frame = CGRectMake(16, cellHeight, HIC_ScreenWidth - 2 * 16, 20);
            }else if (hModel.rejected && hModel.rejected.integerValue == 1) {
                _statusDesc.text = [NSString stringWithFormat:NSLocalizableString(@"dismissPrompt", nil)];
                _statusDesc.textColor = [UIColor colorWithHexString:@"#ff8500"];
                _statusDesc.frame = CGRectMake(16, cellHeight, HIC_ScreenWidth - 2 * 16, 20);
            } else{
                NSString *timeStr = [hModel.endTime isEqualToNumber:@0]?[NSString stringWithFormat:@"%@: %@",NSLocalizableString(@"dendline", nil),NSLocalizableString(@"unlimited", nil)]: [NSString stringWithFormat:@"%@: %@", NSLocalizableString(@"dendline", nil),[HICCommonUtils timeStampToReadableDate:hModel.endTime isSecs:YES format:@"MM-dd HH:mm"]];
                _statusDesc.text = timeStr;
                _statusDesc.textColor = [UIColor colorWithRed:133/255.0 green:133/255.0 blue:133/255.0 alpha:1/1.0];
                _statusDesc.frame = CGRectMake(16, cellHeight, HIC_ScreenWidth - 2 * 16, 20);
            }
        }else if (hModel.jobStatus == HICHomeworkWaitForGrading || hModel.jobStatus == HICHomeworkGrading) {
            _statusDesc.text = [NSString stringWithFormat:@"%@: %@", NSLocalizableString(@"submitTime", nil),[HICCommonUtils timeStampToReadableDate:hModel.commitTime isSecs:YES format:@"MM-dd HH:mm"]];
            _statusDesc.textColor = [UIColor colorWithRed:133/255.0 green:133/255.0 blue:133/255.0 alpha:1/1.0];
            _statusDesc.frame = CGRectMake(16, cellHeight, HIC_ScreenWidth - 2 * 16, 20);
        }else if (hModel.jobStatus == HICHomeworkCompleted) {
            _statusDesc.text = [NSString stringWithFormat:@"%@: %@", NSLocalizableString(@"submitTime", nil),[HICCommonUtils timeStampToReadableDate:hModel.commitTime isSecs:YES format:@"MM-dd HH:mm"]];
            _statusDesc.textColor = [UIColor colorWithRed:133/255.0 green:133/255.0 blue:133/255.0 alpha:1/1.0];
            _statusDesc.frame = CGRectMake(16, cellHeight, HIC_ScreenWidth - 2 * 16, 20);
        }
        cellHeight = cellHeight + _statusDesc.frame.size.height + 16;

        _tagIV.frame = CGRectMake(HIC_ScreenWidth - 72 - 8, cellHeight - 72 - 8, 72, 72);

        _dividedLine.frame = CGRectMake(16, cellHeight - 0.5, HIC_ScreenWidth - 16, 0.5);
        _dividedLine.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1/1.0];
    }
}

@end
