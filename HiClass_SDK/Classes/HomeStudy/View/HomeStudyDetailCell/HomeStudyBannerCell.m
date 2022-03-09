//
//  HomeStudyBannerCell.m
//  iTest
//
//  Created by Sir_Jing on 2020/3/10.
//  Copyright © 2020 Sir_Jing. All rights reserved.
//

#import "HomeStudyBannerCell.h"

#import "WMZBannerView.h"

@interface HomeStudyBannerCell()

@property (nonatomic, strong) UIView *bannerBackView;

@end

@implementation HomeStudyBannerCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createView];
    }
    return self;
}

-(void)createView {

    CGFloat screenWidth = UIScreen.mainScreen.bounds.size.width;
    self.bannerBackView = [[UIView alloc] initWithFrame:CGRectMake(16, 5, screenWidth - 32, 150)];
    [self.contentView addSubview:self.bannerBackView];
}

-(void)setHomeStudyModel:(HICHomeStudyModel *)homeStudyModel {
    [super setHomeStudyModel:homeStudyModel];

    if (self.bannerBackView.subviews.count == 0) {
        // 添加view
        NSArray *resourceList = homeStudyModel.resourceList;
        // 需要获取 图片的Url地址 数组然后 反馈给
        NSMutableArray *urls = [NSMutableArray array];
        for (ResourceListItem *item in resourceList) {
            if (item.picPath) {
                [urls addObject:item.picPath];
            }
        }
        WMZBannerParam *param =  BannerParam()
        .wBannerControlImageSet(@"bannerP3")
        .wBannerControlSelectImageSet(@"slideCirclePoint")
        .wBannerControlImageSizeSet(CGSizeMake(8, 8))
        .wBannerControlSelectImageSizeSet(CGSizeMake(6, 6))
         //调整间距
        .wBannerControlSelectMarginSet(3)
        .wBannerControlPositionSet(BannerControlRight)
        .wFrameSet(self.bannerBackView.bounds)
        .wDataSet(urls.copy)
        //开启循环滚动
        .wRepeatSet(YES)
        //开启自动滚动
        .wAutoScrollSet(YES)
        .wEventClickSet(^(id anyID,NSInteger index) {
            if ([self.delegate respondsToSelector:@selector(studyCell:onTap:other:)]) {
                [self.delegate studyCell:self onTap:self.homeStudyModel.resourceList[index] other:nil];
            }
        });
        WMZBannerView *bannerView = [[WMZBannerView alloc]initConfigureWithModel:param];
        [self.bannerBackView addSubview:bannerView];
    }
}

@end
