//
//  HomeStudyTeacherCollectionCell.m
//  iTest
//
//  Created by Sir_Jing on 2020/3/10.
//  Copyright © 2020 Sir_Jing. All rights reserved.
//

#import "HomeStudyTeacherCollectionCell.h"

//#import "UIImageView+WebCache.h"

@interface HomeStudyTeacherCollectionCell ()

@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic, strong) UILabel *nameLabel;

@end

@implementation HomeStudyTeacherCollectionCell

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createView];
    }
    return self;
}

-(void)createView {

    UIImageView *teacherImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    teacherImageView.layer.cornerRadius = 4.f;
    teacherImageView.layer.masksToBounds = YES;
    teacherImageView.backgroundColor = UIColor.grayColor;

    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 61, 60, 88-62)];
    nameLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.text = @"赵老师找";

    [self.contentView addSubview:nameLabel];
    [self.contentView addSubview:teacherImageView];

    self.iconImageView = teacherImageView;
    self.nameLabel = nameLabel;
}

-(void)setModel:(ResourceListItem *)model {
    if (_model == model) {
        return;
    }
    _model = model;
    // 没有图片的情况下使用默认图片
    if (self.iconImageView.subviews.count > 0) {
        [self.iconImageView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    self.iconImageView.image = nil;
    if ([NSString isValidStr:model.picPath]) {
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.picPath]];
    }else {
        NSString *name = model.name;
//        if (name.length == 0) {
//            name = @"无";
//        }
//        NSArray *names = [name componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@",.<>/?;'\"|，。/？‘“、()（）"]];
//        name = names.firstObject;
//        if (name.length == 0) {
//            name = @"无";
//        }
//        name = [name substringWithRange:NSMakeRange(name.length-1, 1)];
        UILabel *label = [HICCommonUtils setHeaderFrame:self.iconImageView.bounds andText:name];
        label.hidden = NO;
        [self.iconImageView addSubview:label];
    }
    self.nameLabel.text = model.name;
}

@end
