//
//  HICOfflineClassHeaderView.m
//  HiClass
//
//  Created by hisense on 2020/4/23.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import "HICOfflineClassHeaderView.h"
#import "NSString+String.h"

@interface HICOfflineClassHeaderView()
@property (nonatomic, weak) UILabel *titleLbl;
@property (nonatomic, weak) UILabel *timeLbl;
@property (nonatomic, weak) UILabel *placeLbl;
@property (nonatomic, weak) UIImageView *imgView;

@property (nonatomic, weak) UIImageView *bgImgView;


@end


@implementation HICOfflineClassHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithHeaderFrame:(HICOfflineClassHeaderFrame *)headerframe
{
    self = [super init];
    if (self) {

        [self createSubviews];

        self.headerFrame = headerframe;
    }
    return self;
}


- (void)createSubviews
{
    UIImageView *bgImgView = [[UIImageView alloc] init];
    self.bgImgView = bgImgView;
    [self addSubview:bgImgView];
    [bgImgView setImage:[UIImage imageNamed:@"详情背景"]];
    [bgImgView setContentMode:UIViewContentModeScaleToFill];



    UILabel *titleLbl = [[UILabel alloc] init];
    [self addSubview:titleLbl];
    self.titleLbl = titleLbl;
    titleLbl.font = [UIFont fontWithName:@"PingFangSC-Regular" size:18];
    titleLbl.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    titleLbl.numberOfLines = 0;


    UILabel *timeLbl = [[UILabel alloc] init];
    [self addSubview:timeLbl];
    self.timeLbl = timeLbl;
    timeLbl.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    timeLbl.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
//    timeLbl.adjustsFontSizeToFitWidth = YES;

    UILabel *placeLbl = [[UILabel alloc] init];
    [self addSubview:placeLbl];
    self.placeLbl = placeLbl;
    placeLbl.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    placeLbl.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
//    placeLbl.adjustsFontSizeToFitWidth = YES;

    UIImageView *imgView = [[UIImageView alloc] init];
    [self addSubview:imgView];
    self.imgView = imgView;

}

- (void)setHeaderFrame:(HICOfflineClassHeaderFrame *)headerFrame {
    _headerFrame = headerFrame;

    [self settingData];

    [self settingFrame];

}

- (void)settingData {

    HICOfflineClassHeaderData *data = _headerFrame.data;

    _titleLbl.text = [NSString realString:data.title];
    _timeLbl.text = [NSString realString:data.time];
    _placeLbl.text = [NSString realString:data.place];
    [_imgView setHidden:NO];

    if(data.scoreGroup) {
        switch (data.scoreGroup.integerValue) {

            case GroupNone:
                [_imgView setHidden:YES];
                break;
            case GroupUnqualified:
                _imgView.image = [UIImage imageNamed:@"考试印章_不合格"];
                break;
            case GroupQualified:
                _imgView.image = [UIImage imageNamed:@"考试印章_合格"];
                break;
            case GroupWell:
                _imgView.image = [UIImage imageNamed:@"考试印章_良好"];
                break;
            case GroupExcellent:
                _imgView.image = [UIImage imageNamed:@"考试印章_优秀"];
                break;
            default:
                [_imgView setHidden:YES];
                break;
        }
    } else {
        [_imgView setHidden:YES];
    }


}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self settingFrame];
}


- (void)settingFrame {
    self.bgImgView.frame = _headerFrame.bgImgViewF;
    self.titleLbl.frame = _headerFrame.titleLblF;
    self.timeLbl.frame = _headerFrame.timeLblF;
    self.placeLbl.frame = _headerFrame.placeLblF;
    self.imgView.frame = _headerFrame.imgViewF;
}

@end
