//
//  SearchRecommendCell.m
//  iTest
//
//  Created by Sir_Jing on 2020/3/16.
//  Copyright © 2020 Sir_Jing. All rights reserved.
//

#import "SearchRecommendCell.h"

#import "Masonry.h"

@interface SearchRecommendCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation SearchRecommendCell

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColor.clearColor;
        UIView *view = [[UIView alloc] initWithFrame:self.bounds];
        [self.contentView addSubview:view];
        view.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
        view.layer.cornerRadius = 16.f;
        view.layer.masksToBounds = YES;

        self.titleLabel = [[UILabel alloc] initWithFrame:view.bounds];
        self.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [view addSubview:self.titleLabel];
    }
    return self;
}

-(void)setModel:(NSDictionary *)model {
    _model = model;
    self.titleLabel.text = [model objectForKey:@"title"];
}

+(CGFloat)getTitleLabelHeightWith:(NSString *)str {

    NSDictionary *attribute = @{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size:13]};

    CGSize retSize = [str boundingRectWithSize:CGSizeMake(MAXFLOAT, 32)
                                       options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                    attributes:attribute
                                       context:nil].size;

    return retSize.width;
}

@end
