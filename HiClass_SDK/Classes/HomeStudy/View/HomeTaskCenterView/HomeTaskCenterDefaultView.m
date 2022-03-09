//
//  HomeTaskCenterDefaultView.m
//  iTest
//
//  Created by Sir_Jing on 2020/3/16.
//  Copyright © 2020 Sir_Jing. All rights reserved.
//

#import "HomeTaskCenterDefaultView.h"

@interface HomeTaskCenterDefaultView()

@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic ,strong) UIImageView *imageView;
@end

@implementation HomeTaskCenterDefaultView

-(instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        [self createView];
    }
    return self;
}

-(void)createView {

    CGFloat screenWidth = self.frame.size.width;
    CGFloat screenHeight = self.frame.size.height;
    CGFloat imageWidth = 110;
    CGFloat labelTotal = 31.f;

    CGFloat imageTop = screenHeight/2.0 - (imageWidth + labelTotal)/2.0 - 30;
    CGFloat imageLeft = screenWidth/2.0 - imageWidth/2.0;

    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageLeft, imageTop, imageWidth, imageWidth)];
    _imageView.image = [UIImage imageNamed:@"消息-任务空白页"];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, imageTop+imageWidth+8, HIC_ScreenWidth - 32, 22)];
    label.text = NSLocalizableString(@"noTaskTodo", nil);
    label.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    _textLabel = label;

    [self addSubview:_imageView];
    [self addSubview:label];
    self.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
}

-(void)setTitleStr:(NSString *)titleStr {
    _titleStr = titleStr;
    self.textLabel.text = titleStr;
}
-(void)setImageName:(NSString *)imageName{
    _imageView.image = [UIImage imageNamed:imageName];
}
-(void)setNumber:(NSInteger)number{
    self.textLabel.numberOfLines = number;
    self.textLabel.height = 22.5 *number;
}
@end
