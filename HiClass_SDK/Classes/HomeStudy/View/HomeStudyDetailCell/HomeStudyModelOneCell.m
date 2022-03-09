//
//  HomeStudyModelOneCell.m
//  iTest
//
//  Created by Sir_Jing on 2020/3/10.
//  Copyright © 2020 Sir_Jing. All rights reserved.
//

#import "HomeStudyModelOneCell.h"

//#import "UIImageView+WebCache.h"

#define ModelOneCellTag 200000

@interface HomeStudyModelOneCell ()

@property (nonatomic, strong) UILabel *cellTitleLabel;

@property (nonatomic, strong) NSMutableArray *imageViews;
@property (nonatomic, strong) NSMutableArray *titleLabels;
@property (nonatomic, strong) NSMutableArray *backButs;
@property (nonatomic, strong) NSMutableArray *playViews;

@property (nonatomic, strong) UILabel *moreLabel;
@property (nonatomic, strong) UIImageView *moreImageView;
@property (nonatomic, strong) UIButton *moreBut;

@end

@implementation HomeStudyModelOneCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.imageViews = [NSMutableArray array];
        self.titleLabels = [NSMutableArray array];
        self.backButs = [NSMutableArray array];
        self.playViews = [NSMutableArray array];
        [self createView];
    }
    return self;
}

-(void)createView {

    CGFloat screenWidth = UIScreen.mainScreen.bounds.size.width;
    UILabel *studyTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 5, screenWidth - 16 - 25.5 - 26 - 5, 25)];
    studyTitleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
    studyTitleLabel.text = NSLocalizableString(@"todayRecommendation", nil);
    studyTitleLabel.textColor = [UIColor blackColor];
    self.cellTitleLabel = studyTitleLabel;

    UILabel *moreLabel = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth - 25.5 - 26, 8, 26, 19)];
    moreLabel.textColor = [UIColor colorWithRed:133/255.0 green:133/255.0 blue:133/255.0 alpha:1];
    moreLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    moreLabel.text = NSLocalizableString(@"all", nil);
    self.moreLabel = moreLabel;

    UIImageView *moreImageView = [[UIImageView alloc] initWithFrame:CGRectMake(screenWidth - 16 - 5.5, 12.5, 5.5, 10)];
    moreImageView.image = [UIImage imageNamed:@"全部-箭头"];
    self.moreImageView = moreImageView;

    UIButton *moreBut = [[UIButton alloc] initWithFrame:CGRectMake(screenWidth - 25.5 - 26, 8, 28, 19)];
    [moreBut addTarget:self action:@selector(clickMoreBut:) forControlEvents:UIControlEventTouchUpInside];
    self.moreBut = moreBut;
    [self.contentView addSubview:moreLabel];
    [self.contentView addSubview:moreImageView];
    [self.contentView addSubview:moreBut];

    [self.contentView addSubview:studyTitleLabel];
}

// 页面赋值
-(void)setHomeStudyModel:(HICHomeStudyModel *)homeStudyModel {
    if (self.homeStudyModel == homeStudyModel) {
        return;
    }
    [super setHomeStudyModel:homeStudyModel];

    /*
    for (NSInteger i = 0; i < homeStudyModel.resourceList.count; i++) {
        if (i > 3) {
            // 页面不用在加载了
            break;
        }
        ResourceListItem *model = homeStudyModel.resourceList[i];
        UIImageView *imageView = self.imageViews[i];
        imageView.hidden = NO;
        UILabel *titleLabel = self.titleLabels[i];
        titleLabel.hidden = NO;
        if (model.picPath) {
            [imageView sd_setImageWithURL:[NSURL URLWithString:model.picPath]];
        }
        titleLabel.text = model.name;
    }
    if (homeStudyModel.resourceList.count < self.imageViews.count) {
        // 需要隐藏
        for (NSInteger i = homeStudyModel.resourceList.count; i < self.imageViews.count; i++) {
            UIImageView *imageView = self.imageViews[i];
            imageView.hidden = YES;
            UILabel *titleLabel = self.titleLabels[i];
            titleLabel.hidden = YES;
        }
    }*/
    if (self.imageViews.count > 0) {
        for (UIView *view in self.imageViews) {
            [view removeFromSuperview];
        }
        [self.imageViews removeAllObjects];
    }
    if (self.titleLabels.count > 0) {
        for (UIView *view in self.titleLabels) {
            [view removeFromSuperview];
        }
        [self.titleLabels removeAllObjects];
    }
    if (self.backButs.count > 0) {
        for (UIView *view in self.backButs) {
            [view removeFromSuperview];
        }
        [self.backButs removeAllObjects];
    }
    if (self.playViews.count > 0) {
        for (UIView *view in self.playViews) {
            [view removeFromSuperview];
        }
        [self.playViews removeAllObjects];
    }
    CGFloat titleTop = 42.f;
    CGFloat imageWidth = (HIC_ScreenWidth - 16*2 - 15)/2;
    CGFloat imageHeight = 92.f;
    CGFloat titleHeight = 21.f;

    for (NSInteger i = 0; i < homeStudyModel.resourceList.count; i++) {
        NSInteger l = i % 2;
        NSInteger n = i / 2;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(16 + l*imageWidth + l*15, titleTop + n*imageHeight + n*titleHeight + n*18 , imageWidth, imageHeight)];
        imageView.layer.cornerRadius = 4.f;
        imageView.layer.masksToBounds = YES;
        imageView.backgroundColor = [UIColor colorWithHexString:@"#E6E6E6"];
        UIView *playView = [self createClassBackView:imageView];
        [imageView addSubview:playView];
        playView.hidden = YES;
        [self.playViews addObject:playView];

        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16 + l*imageWidth + l*15, titleTop +imageHeight + 8 + n*imageHeight + n*titleHeight + n*18, imageWidth, titleHeight)];
        titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        titleLabel.text = NSLocalizableString(@"humanResourceManagement", nil);
        titleLabel.textColor = UIColor.blackColor;

        UIButton *btn = [[UIButton alloc] initWithFrame:imageView.frame];
        [self.contentView addSubview:btn];
        [btn addTarget:self action:@selector(clickBackBut:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = ModelOneCellTag + i;

        [self.contentView addSubview:imageView];
        [self.contentView addSubview:titleLabel];
        [self.imageViews addObject:imageView];
        [self.titleLabels addObject:titleLabel];
        [self.backButs addObject:btn];

        ResourceListItem *model = homeStudyModel.resourceList[i];
        if (model.picPath) {
            [imageView sd_setImageWithURL:[NSURL URLWithString:model.picPath]];
        }
        titleLabel.text = model.name;
        if (model.courseInfo && [model.courseInfo objectForKey:@"fileType"]) {
            NSNumber *type = [model.courseInfo objectForKey:@"fileType"];
            if ([type integerValue] == 1 || [type integerValue] == 2) {
                playView.hidden = YES; // TODO: 首页加载的不显示播放图标
            }
        }
    }

    self.cellTitleLabel.text = homeStudyModel.name;
    if (homeStudyModel.source != 0) {
        [self showMoreBut];
    }else {
        [self hiddenMoreBut];
    }
}

-(void)hiddenMoreBut {
    self.moreImageView.hidden = YES;
    self.moreLabel.hidden = YES;
    self.moreBut.hidden = YES;
}

-(void)showMoreBut {
    self.moreImageView.hidden = NO;
    self.moreLabel.hidden = NO;
    self.moreBut.hidden = NO;
}

-(void)clickBackBut:(UIButton *)btn {

    NSInteger index = btn.tag - ModelOneCellTag;
    if (index < self.homeStudyModel.resourceList.count) {
        ResourceListItem *item = [self.homeStudyModel.resourceList objectAtIndex:index];
        if ([self.delegate respondsToSelector:@selector(studyCell:onTap:other:)]) {
            [self.delegate studyCell:self onTap:item other:nil];
        }
    }
}

-(void)clickMoreBut:(UIButton *)btn {
    if([self.delegate respondsToSelector:@selector(studyCell:clickMoreBut:model:type:)]) {
        [self.delegate studyCell:self clickMoreBut:btn model:self.homeStudyModel type:0];
    }
}

@end
