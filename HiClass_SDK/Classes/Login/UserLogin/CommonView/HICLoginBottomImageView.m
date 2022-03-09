//
//  HICLoginBottomImageView.m
//  HiClass
//
//  Created by 铁柱， on 2020/1/3.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICLoginBottomImageView.h"
@interface HICLoginBottomImageView ()
@property(nonatomic, strong)UIImageView *bottomImageView;
@end
@implementation HICLoginBottomImageView

- (instancetype)init {
    if (self = [super init]) {
        [self creatUI];
    }
    return self;
}
- (void)creatUI{
    UIImage *image = [UIImage imageNamed:@"image_底部装饰"];
    self.bottomImageView = [[UIImageView alloc]initWithImage:image];
    [self addSubview:self.bottomImageView];

    [self.bottomImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.offset(HIC_ScreenWidth);
        make.height.offset(49);
    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
