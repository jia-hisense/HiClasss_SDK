//
//  HomeStudyModelTwoCell.m
//  iTest
//
//  Created by Sir_Jing on 2020/3/10.
//  Copyright © 2020 Sir_Jing. All rights reserved.
//

#import "HomeStudyModelTwoCell.h"

//#import "UIImageView+WebCache.h"

#define ModelTwoCellTag 987900000

@interface HomeStudyModelTwoCell ()

@property (nonatomic, strong) UILabel *cellTitleLabel;

@property (nonatomic, strong) NSMutableArray *iconImageViews;
@property (nonatomic, strong) NSMutableArray *titleLabels;
@property (nonatomic, strong) NSMutableArray *backButs;
@property (nonatomic, strong) NSMutableArray *playViews;

@end

@implementation HomeStudyModelTwoCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createView];
        _iconImageViews = [NSMutableArray array];
        _titleLabels = [NSMutableArray array];
        _backButs = [NSMutableArray array];
        _playViews = [NSMutableArray array];
    }
    return self;
}

-(void)createView {

    CGFloat screenWidth = UIScreen.mainScreen.bounds.size.width;
    UILabel *studyTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 5, screenWidth - 16 - 25.5 - 26 - 5, 25)];
    studyTitleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
    studyTitleLabel.text = NSLocalizableString(@"todayRecommendation", nil);
    studyTitleLabel.textColor = UIColor.blackColor;
    self.cellTitleLabel = studyTitleLabel;

    [self.contentView addSubview:studyTitleLabel];
}

// 页面赋值
-(void)setHomeStudyModel:(HICHomeStudyModel *)homeStudyModel {
    if (self.homeStudyModel == homeStudyModel) {
        return;
    }
    [super setHomeStudyModel:homeStudyModel];

    if (self.iconImageViews.count > 0) {
        for (UIView *view in self.iconImageViews) {
            [view removeFromSuperview];
        }
        [self.iconImageViews removeAllObjects];
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
    CGFloat imageWidth = HIC_ScreenWidth - 16*2;
    CGFloat imageHeight = 193.f;
    CGFloat titleHeight = 21.f;
    CGFloat space = 12;

    for (NSInteger i = 0; i < homeStudyModel.resourceList.count; i++) {
        NSInteger n = i;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(16, titleTop+n*(imageHeight+8+titleHeight+space), imageWidth, imageHeight)];
        imageView.layer.cornerRadius = 4.f;
        imageView.layer.masksToBounds = YES;
        imageView.backgroundColor = [UIColor colorWithHexString:@"#E6E6E6"];
        UIView *playView = [self createClassBackView:imageView];
        [imageView addSubview:playView];
        playView.hidden = YES;
        [self.playViews addObject:playView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, titleTop+imageHeight+8+n*(imageHeight+8+titleHeight+space), imageWidth, titleHeight)];
        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        label.textColor = UIColor.blackColor;

        UIButton *btn = [[UIButton alloc] initWithFrame:imageView.frame];
        [self.contentView addSubview:btn];
        btn.tag = ModelTwoCellTag+i;
        [btn addTarget:self action:@selector(clickBackBut:) forControlEvents:UIControlEventTouchUpInside];


        [self.contentView addSubview:imageView];
        [self.contentView addSubview:label];

        ResourceListItem *model = [homeStudyModel.resourceList objectAtIndex:i];
        if (model.picPath) {
            [imageView sd_setImageWithURL:[NSURL URLWithString:model.picPath]];
        }
        label.text = model.name;
        [self.iconImageViews addObject:imageView];
        [self.titleLabels addObject:label];
        [self.backButs addObject:btn];
        if (model.courseInfo && [model.courseInfo objectForKey:@"fileType"]) {
            NSNumber *type = [model.courseInfo objectForKey:@"fileType"];
            if ([type integerValue] == 1 || [type integerValue] == 2) {
                playView.hidden = YES; // TODO: 首页加载的不显示播放图标
            }
        }
    }
    self.cellTitleLabel.text = homeStudyModel.name;
}

-(void)clickBackBut:(UIButton *)btn {

    NSInteger index = btn.tag - ModelTwoCellTag;
    if (index < self.homeStudyModel.resourceList.count) {
        ResourceListItem *item = [self.homeStudyModel.resourceList objectAtIndex:index];
        if ([self.delegate respondsToSelector:@selector(studyCell:onTap:other:)]) {
            [self.delegate studyCell:self onTap:item other:nil];
        }
    }
}

@end
