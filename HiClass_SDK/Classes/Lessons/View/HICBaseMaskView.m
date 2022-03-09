//
//  HICBaseMaskView.m
//  HiClass
//
//  Created by WorkOffice on 2020/3/31.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICBaseMaskView.h"
#define CDVTopMargin  (72 - 20 + HIC_StatusBar_Height)
#define CDVTitleSectionHeight  50
#define CDVBtmViewHeight  120
@interface HICBaseMaskView ()
@property (nonatomic, strong) UIView *container;
@property (nonatomic, strong) NSString *titleName;
@end
@implementation HICBaseMaskView
-(instancetype)initWithTitle:(NSString *)title{
    if (self = [super init]) {
        self.titleName = title;
        [self createUI];
    }
    return self;
}
- (void)createUI{
    self.frame = CGRectMake(0, 0, HIC_ScreenWidth, HIC_ScreenHeight);
    self.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.5];
    
    self.container = [[UIView alloc] init];
    [self addSubview: _container];
    _container.frame = CGRectMake(0, HIC_ScreenHeight, self.frame.size.width, self.frame.size.height - CDVTopMargin);
    [UIView animateWithDuration:0.3 animations:^{
        self->_container.frame = CGRectMake(0, CDVTopMargin, self.frame.size.width, self.frame.size.height - CDVTopMargin);
    }];
    [HICCommonUtils setRoundingCornersWithView:_container TopLeft:YES TopRight:YES bottomLeft:NO bottomRight:NO cornerRadius:15];
    _container.backgroundColor = [UIColor whiteColor];
    UILabel *titleLabel = [[UILabel alloc] init];
    [_container addSubview:titleLabel];
    titleLabel.frame = CGRectMake(16, 15, 68, 24);
    titleLabel.font = FONT_MEDIUM_17;
    titleLabel.text = self.titleName;
    titleLabel.textColor = TEXT_COLOR_DARK;
    
    UIButton *cancelBtn = [[UIButton alloc] init];
    [_container addSubview: cancelBtn];
    cancelBtn.tag = 10000;
    [cancelBtn addTarget:self action:@selector(btnClicked) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setImage:[UIImage imageNamed:@"关闭弹窗"] forState:UIControlStateNormal];
    cancelBtn.frame = CGRectMake(_container.frame.size.width - 20 - 16, 15, 20, 20);
    
    UIView *dividedLine = [[UIView alloc] initWithFrame:CGRectMake(0, CDVTitleSectionHeight - 0.5, _container.frame.size.width, 0.5)];
    [_container addSubview: dividedLine];
    dividedLine.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1/1.0];
 
}
- (void)btnClicked{
    if (self.maskDelegate && [self.maskDelegate respondsToSelector:@selector(closeMaskView)]) {
        [self.maskDelegate closeMaskView];
    }
}
@end
