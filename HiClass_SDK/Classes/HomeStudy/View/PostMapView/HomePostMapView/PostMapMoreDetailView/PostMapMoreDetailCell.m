//
//  PostMapMoreDetailCell.m
//  iTest
//
//  Created by Sir_Jing on 2020/3/17.
//  Copyright © 2020 Sir_Jing. All rights reserved.
//

#import "PostMapMoreDetailCell.h"

@interface PostMapMoreDetailCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *progressLabel;

@property (nonatomic, strong) UIProgressView *progressView;

@end

@implementation PostMapMoreDetailCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1];
        [self createView];
    }
    return self;
}

-(void)createView {

    CGFloat screenWidth = UIScreen.mainScreen.bounds.size.width;

    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 52)];
    [backButton setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1]] forState:UIControlStateHighlighted];
    [self.contentView addSubview:backButton];
    [backButton addTarget:self action:@selector(clickCellBut:) forControlEvents:UIControlEventTouchUpInside];

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 15, screenWidth/2.0-16-15, 22.5)];
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    self.titleLabel = titleLabel;

    UILabel *progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth/2.0+15, 18, screenWidth/2.0-15-6-50-16, 16.5)];
    progressLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    progressLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
    progressLabel.textAlignment = NSTextAlignmentRight;
    self.progressLabel = progressLabel;
    [self.contentView addSubview:titleLabel];
    [self.contentView addSubview:progressLabel];

    UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(screenWidth-50-16, 24, 50, 5)];
    progressView.progressTintColor = [UIColor colorWithRed:3/255.0 green:179/255.0 blue:204/255.0 alpha:1];
    progressView.tintColor = [UIColor colorWithRed:133/255.0 green:133/255.0 blue:133/255.0 alpha:1];
    progressView.progress = 0.5;
    progressView.layer.cornerRadius = 2.5;
    progressView.layer.masksToBounds = YES;
    self.progressView = progressView;
    [self.contentView addSubview:progressView];
}

//  颜色转换为背景图片
- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}

-(void)clickCellBut:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(moreDetailCell:didClickBut:dataSource:other:)]) {
        [self.delegate moreDetailCell:self didClickBut:btn dataSource:self.infoModel other:nil];
    }
}

// 页面赋值
-(void)setInfoModel:(MapMoreInfoModel *)infoModel {
    _infoModel = infoModel;
    double pro = infoModel.taskProgress >= 100.0?1:infoModel.taskProgress/100;
    if (infoModel.isPrePost == 1) {
        self.titleLabel.text = [NSString stringWithFormat:@"%@", infoModel.postName];
        self.titleLabel.textColor = [UIColor colorWithHexString:@"#00BED7"];
    }else {
        self.titleLabel.text = infoModel.postName;
        self.titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    }
    self.progressLabel.text = [NSString stringWithFormat:@"%.0f%%", pro*100];
    self.progressView.progress = pro;
}

@end
