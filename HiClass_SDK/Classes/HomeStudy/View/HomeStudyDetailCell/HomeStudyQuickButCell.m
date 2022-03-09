//
//  HomeStudyQuickButCell.m
//  iTest
//
//  Created by Sir_Jing on 2020/3/13.
//  Copyright © 2020 Sir_Jing. All rights reserved.
//

#import "HomeStudyQuickButCell.h"

//#import "UIImageView+WebCache.h"

#define QuickButCellButTag 1000000

@interface HomeStudyQuickButCell ()

@property (nonatomic, strong) UIView *backButView;

@end

@implementation HomeStudyQuickButCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

    }
    return self;
}

-(void)createViewWith:(NSArray *)buttons {

    CGFloat screenWidth = UIScreen.mainScreen.bounds.size.width;
    CGFloat backWidth = screenWidth - 16*2;
    CGFloat itemWidth = 50;
    if (itemWidth*5 > backWidth) {
        // 此时5个按钮会超出屏幕
        itemWidth = backWidth/5.0; // 设置最小值
    }
    CGFloat backHeight = 0;
    CGFloat itemSpace = (backWidth - itemWidth*5)/4.0;
    if (!self.backButView) {
        if (buttons.count <= 5) {
            // 只有一行
            backHeight = itemWidth + 6 + 17;
        }else {
            // 两行 或  多行
            NSInteger count = buttons.count;
            NSInteger line = count %5;
            NSInteger row = count/5 + (line != 0 ? 1:0);
            backHeight = (itemWidth + 6 + 17)*row + 16*(row-1);
        }

        self.backButView = [[UIView alloc] initWithFrame:CGRectMake(16, 5, backWidth, backHeight)];
        self.backButView.backgroundColor = UIColor.whiteColor;
        [self.contentView addSubview:self.backButView];
    }

    if (self.backButView.subviews.count == 0) {
        for (NSInteger i = 0; i < buttons.count; i++) {
            NSInteger line = i%5;
            NSInteger row = i/5;
            UIView *itemView = [self createItemViewWithFrame:CGRectMake(line*(itemWidth+itemSpace), row*(itemWidth+6+17+16), itemWidth, itemWidth+6+17) butTag:i];
            [self.backButView addSubview:itemView];
        }
    }
}

-(UIView *)createItemViewWithFrame:(CGRect)frame butTag:(NSInteger)tag{

    UIView *view = [[UIView alloc] initWithFrame:frame];

    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.width)];

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.width + 6, frame.size.width, 17)];
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"fjaeifia";
    titleLabel.textColor = UIColor.blackColor;

    [view addSubview:iconImageView];
    [view addSubview:titleLabel];

    UIButton *backBut = [[UIButton alloc] initWithFrame:view.bounds];
    backBut.tag = QuickButCellButTag + tag;
    [backBut addTarget:self action:@selector(clickBackBut:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:backBut];

    // 直接赋值
    ResourceListItem *item = [self.homeStudyModel.resourceList objectAtIndex:tag];
    titleLabel.text = item.name;
    if (item.picPath) {
        [iconImageView sd_setImageWithURL:[NSURL URLWithString:item.picPath]];  // 图片赋值 -- 可以约定本地图片。
    }

    return view;
}

#pragma mark - Cell赋值
-(void)setHomeStudyModel:(HICHomeStudyModel *)homeStudyModel {
    [super setHomeStudyModel:homeStudyModel];

    [self createViewWith:homeStudyModel.resourceList];
}

-(void)clickBackBut:(UIButton *)btn {
    NSInteger index = btn.tag - QuickButCellButTag;
    ResourceListItem *item = [self.homeStudyModel.resourceList objectAtIndex:index];
    if ([self.delegate respondsToSelector:@selector(studyCell:onTap:other:)]) {
        [self.delegate studyCell:self onTap:item other:nil];
    }
}

@end
