//
//  HICStudyVideoPlayCommentCell.m
//  iTest
//
//  Created by Sir_Jing on 2020/2/4.
//  Copyright © 2020 Sir_Jing. All rights reserved.
//

#import "HICStudyVideoPlayCommentCell.h"

@interface HICStudyVideoPlayCommentCell ()

/// 默认背景图
@property (nonatomic, strong) UIView *defaultBackView;

@end

@implementation HICStudyVideoPlayCommentCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createView];
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        [self createView];
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

// 1. 创建视图
-(void)createView {

    // 1. 评论内容
    UILabel *commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 16, 34, 24)];
    commentLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
    commentLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:17.f];
    commentLabel.text = NSLocalizableString(@"comments", nil);

    UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectMake(54, 19, 100, 20)];
    numLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
    numLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14.f];
    numLabel.text = @"(0)";

    [self.contentView addSubview:commentLabel];
    [self.contentView addSubview:numLabel];

    // 默认显示缺省图
    [self.contentView addSubview:self.defaultBackView];
}

// 新增View
-(void)addCommentView:(UIView *)view {

    [self.defaultBackView addSubview:view];
}

#pragma mark - 懒加载
-(UIView *)defaultBackView {
    if (!_defaultBackView) {
        CGFloat width = UIScreen.mainScreen.bounds.size.width;
        _defaultBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 180, width, 255.5)];

        CGFloat left = (width-120)/2.0;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(left, 40, 120, 120)];
        imageView.image = [UIImage imageNamed:@"暂无评论"];
        [_defaultBackView addSubview:imageView];

        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 168, width-20, 50)];
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
        textLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15.f];
        textLabel.text = NSLocalizableString(@"noComments", nil);
        textLabel.numberOfLines = 2;
        [_defaultBackView addSubview:textLabel];
    }
    return _defaultBackView;
}

@end
