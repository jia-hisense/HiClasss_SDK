//
//  HICWaterView.m
//  HiClass
//
//  Created by WorkOffice on 2020/3/3.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICWaterView.h"

#define transform (M_PI_2 / 12)
@implementation HICWaterView

- (instancetype)initWithFrame:(CGRect)frame WithText:(NSString *)markText {
    if(self = [super initWithFrame:frame]){
        [self addUIWithMarkText:markText];
    }
    return self;
}

- (void)addUIWithMarkText:(NSString *)markText {
    CGSize textSize = [markText sizeWithFont:[UIFont systemFontOfSize:20] maxSize:CGSizeMake(MAXFLOAT, 20)];
    CGFloat offsetH = textSize.width *sin(transform);
    for (int i = 0; i<3; i++) {
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = TEXT_COLOR_LIGHTS;
        label.text = markText;
        [HICCommonUtils setTransform:transform forLable:label];
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            switch (i) {
                case 0:
                    make.top.equalTo(self).offset(offsetH);
                    break;
                case 1:
                    make.centerY.equalTo(self);
                case 2:
                    make.bottom.equalTo(self).inset(offsetH);
                default:
                    break;
            }
        }];
        
        
    }
}
@end
