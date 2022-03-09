//
//  HomeStudyAdvCell.m
//  iTest
//
//  Created by Sir_Jing on 2020/3/10.
//  Copyright © 2020 Sir_Jing. All rights reserved.
//

#import "HomeStudyAdvCell.h"

#import "WMZBannerView.h"

@interface HomeStudyAdvCell ()

@property (nonatomic, strong) UIView *titleBackView;

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation HomeStudyAdvCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createView];
    }
    return self;
}

-(void)createView {

    CGFloat screenWidth = UIScreen.mainScreen.bounds.size.width;

    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(16, 5, screenWidth - 16*2, 32)];
    backView.backgroundColor = [UIColor colorWithRed:255/255.0 green:245/255.0 blue:226/255.0 alpha:1];
    backView.layer.cornerRadius = 16.0;
    backView.layer.masksToBounds = YES;

    UIButton *clickBut = [[UIButton alloc] initWithFrame:backView.bounds];
    [clickBut addTarget:self action:@selector(clickBackBut:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:clickBut];

    UILabel *label = [[UILabel alloc] initWithFrame:backView.bounds];
    label.textColor = [UIColor colorWithRed:255/255.0 green:133/255.0 blue:0 alpha:1];
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = [NSString stringWithFormat:@"%@: 2020年企业管理培训春季班已经开始报名啦~",NSLocalizableString(@"announcement", nil)];
    [backView addSubview:label];

    [self.contentView addSubview:backView];

    self.titleBackView = backView;
    self.titleLabel = label;

}

// 页面赋值
-(void)setHomeStudyModel:(HICHomeStudyModel *)homeStudyModel {
    if (self.homeStudyModel == homeStudyModel) {
        return;
    }
    [super setHomeStudyModel:homeStudyModel];

    if (homeStudyModel.resourceList.count == 1) {
        // 只有一个广告内容时
        ResourceListItem *item = homeStudyModel.resourceList.firstObject;
        self.titleLabel.hidden = NO;
        self.titleLabel.text = item.text;
    }else if (homeStudyModel.resourceList.count > 1) {
        if (self.titleBackView.subviews.count >= 3) {
            // 此时已经添加过滚动图层了
            return;
        }
        // 有多个 广告时
        self.titleLabel.hidden = YES;
        NSMutableArray *textArray = [NSMutableArray array];
        for (ResourceListItem *item in homeStudyModel.resourceList) {
            if (item.text) {
                [textArray addObject:item.text];
            }
        }

        WMZBannerParam *param =  BannerParam()
        .wFrameSet(self.titleBackView.bounds)
        .wMyCellClassNameSet(@"KuaiBaoCell")
        .wMyCellSet(^UICollectionViewCell *(NSIndexPath *indexPath, UICollectionView *collectionView, id model, UIImageView *bgImageView,NSArray*dataArr) {
            //自定义视图
            KuaiBaoCell *cell = (KuaiBaoCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([KuaiBaoCell class]) forIndexPath:indexPath];
            cell.detailBtn.text = model;
            return cell;
        })
        .wDataSet([textArray copy])
        //关闭手指滑动
        .wCanFingerSlidingSet(NO)
        .wHideBannerControlSet(YES)
        //开启循环滚动
        .wRepeatSet(YES)
        //开启自动滚动
        .wAutoScrollSet(YES)
        .wVerticalSet(YES)
        .wEventClickSet(^(id data, NSInteger index){
            if ([self.delegate respondsToSelector:@selector(studyCell:onTap:other:)]) {
                [self.delegate studyCell:self onTap:self.homeStudyModel.resourceList[index] other:nil];
            }
        });

        WMZBannerView *bannView = [[WMZBannerView alloc]initConfigureWithModel:param];
        [self.titleBackView addSubview:bannView];
    }
}

-(void)clickBackBut:(UIButton *)btn {
    if (self.homeStudyModel.resourceList.count == 1) {
        // 只有在此时才会用到
        if ([self.delegate respondsToSelector:@selector(studyCell:onTap:other:)]) {
            [self.delegate studyCell:self onTap:self.homeStudyModel.resourceList.firstObject other:nil];
        }
    }
}

@end



@implementation KuaiBaoCell

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self){
        self.contentView.backgroundColor = [UIColor clearColor];

        self.detailBtn = [UILabel new];
        self.detailBtn.textColor = [UIColor colorWithRed:255/255.0 green:133/255.0 blue:0 alpha:1];
        self.detailBtn.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        self.detailBtn.textAlignment = NSTextAlignmentCenter;
        self.detailBtn.frame = CGRectMake(0, 0, frame.size.width,frame.size.height);
        [self.contentView addSubview:self.detailBtn];
    }
    return self;
}

@end
