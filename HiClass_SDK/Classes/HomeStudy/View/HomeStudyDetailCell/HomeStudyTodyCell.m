//
//  HomeStudyTodyCell.m
//  iTest
//
//  Created by Sir_Jing on 2020/3/10.
//  Copyright © 2020 Sir_Jing. All rights reserved.
//

#import "HomeStudyTodyCell.h"

#define Tody_Cell_But_Tag 50000

@interface HomeStudyTodyCell ()

@property (nonatomic, strong) UILabel *firstTitleLabel;
@property (nonatomic, strong) UILabel *firstContentLabel;

@property (nonatomic, strong) UILabel *twoTitleLabel;
@property (nonatomic, strong) UILabel *twoContentLabel;

@property (nonatomic, strong) UILabel *moreLabel;
@property (nonatomic, strong) UIImageView *moreImageView;
@property (nonatomic, strong) UIButton *moreBut;

@property (nonatomic, strong) NSMutableArray<UIView *> *contentBackViews;
@property (nonatomic, strong) NSMutableArray<UILabel *>*contentTitleLabels;
@property (nonatomic, strong) NSMutableArray<UILabel *>*contentContLabels;

@end

@implementation HomeStudyTodyCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createView];
        _contentBackViews = [NSMutableArray array];
        _contentTitleLabels = [NSMutableArray array];
        _contentContLabels = [NSMutableArray array];
    }
    return self;
}

-(void)createView {

    CGFloat screenWidth = UIScreen.mainScreen.bounds.size.width;
    UILabel *studyTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 5, screenWidth - 16 - 25.5 - 26 - 5, 25)];
    studyTitleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
    studyTitleLabel.text = NSLocalizableString(@"dueToday", nil);

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
//    moreBut.backgroundColor = UIColor.redColor;

    [self.contentView addSubview:studyTitleLabel];
    [self.contentView addSubview:moreLabel];
    [self.contentView addSubview:moreImageView];
    [self.contentView addSubview:moreBut];

    /*
    UIView *towBackView = [[UIView alloc] initWithFrame:CGRectMake(16, titleTop + backViewH + 8, screenWidth - 16*2, backViewH)];
    towBackView.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1];
    towBackView.layer.cornerRadius = 8.f;
    towBackView.layer.masksToBounds = YES;
    UIButton *towBackBut = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, screenWidth - 16*2, backViewH)];
    [towBackView addSubview:towBackBut];
    [towBackBut addTarget:self action:@selector(clickTowBut:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *towTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 12, 35, 21)];
    towTitleLabel.textColor = [UIColor colorWithRed:133/255.0 green:133/255.0 blue:133/255.0 alpha:1];
    towTitleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    towTitleLabel.text = @"---";
    UILabel *towConstLabel = [[UILabel alloc] initWithFrame:CGRectMake(12+36+6, 12, firstBackView.bounds.size.width - (12+36+6)-12, 21)];
    towConstLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    towConstLabel.textColor = UIColor.blackColor;
    towConstLabel.text = @"---";

    [towBackView addSubview:towTitleLabel];
    [towBackView addSubview:towConstLabel];

    [self.contentView addSubview:firstBackView];
    [self.contentView addSubview:towBackView];

    self.firstTitleLabel = firstTitleLabel;
    self.firstContentLabel = firstConstLabel;
    self.twoTitleLabel = towTitleLabel;
    self.twoContentLabel = towConstLabel;*/
}

-(void)clickMoreBut:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(studyCell:clickOtherBut:model:type:)]) {
        [self.delegate studyCell:self clickOtherBut:btn model:nil type:0]; // 默认type传递0 以后可以增加定义
    }
}

// 页面赋值 -- 未完成
-(void)setHomeStudyModel:(HICHomeStudyModel *)homeStudyModel {
    if (self.homeStudyModel == homeStudyModel) {
        return;
    }
    [super setHomeStudyModel:homeStudyModel];

    // 今日任务比较特殊是另外接口提供的
    NSArray *centers = homeStudyModel.taskCenters;

    CGFloat titleTop = 42.f;
    CGFloat backViewH = 44.f;
    CGFloat backWidth = HIC_ScreenWidth - 16*2;
    for (UIView *view in self.contentBackViews) {
        [view removeFromSuperview];
    }
    [self.contentBackViews removeAllObjects];

    for (NSInteger i = 0; i < centers.count; i++) {

        UIView *firstBackView = [[UIView alloc] initWithFrame:CGRectMake(16, titleTop+i*(backViewH+8), backWidth, backViewH)];
        firstBackView.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1];
        firstBackView.layer.cornerRadius = 8.f;
        firstBackView.layer.masksToBounds = YES;
        UIButton *firstBackBut = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, backWidth, backViewH)];
        [firstBackView addSubview:firstBackBut];
        [firstBackBut addTarget:self action:@selector(clickFirstBut:) forControlEvents:UIControlEventTouchUpInside];
        firstBackBut.tag = Tody_Cell_But_Tag + i;

        UILabel *firstTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 12, 35, 21)];
        firstTitleLabel.textColor = [UIColor colorWithRed:133/255.0 green:133/255.0 blue:133/255.0 alpha:1];
        firstTitleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        firstTitleLabel.text = NSLocalizableString(@"live", nil);
        UILabel *firstConstLabel = [[UILabel alloc] initWithFrame:CGRectMake(12+36+6, 12, firstBackView.bounds.size.width - (12+36+6)-12, 21)];
        firstConstLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        firstConstLabel.textColor = UIColor.blackColor;
        firstConstLabel.text = @"---";

        [firstBackView addSubview:firstTitleLabel];
        [firstBackView addSubview:firstConstLabel];
        [self.contentView addSubview:firstBackView];
        HICHomeTaskCenterModel *model = centers[i];
        NSString *titleStr;
        switch (model.taskType) {
            case 1:
                titleStr = NSLocalizableString(@"exam", nil);
                break;
            case 2:
                titleStr = NSLocalizableString(@"training", nil);
                break;
            case 3:
                titleStr = NSLocalizableString(@"questionnaire", nil);
                break;
            case 4:
                titleStr = NSLocalizableString(@"signUp", nil);
                break;
            case 6:
                titleStr = NSLocalizableString(@"live", nil);
                break;
            default:
                break;
        }
        firstTitleLabel.text = titleStr;
        firstConstLabel.text = model.taskName;
        CGSize firstTitleLabelSize = [HICCommonUtils sizeOfString:firstTitleLabel.text stringWidthBounding:HIC_ScreenWidth font:15 stringOnBtn:NO fontIsRegular:YES];
        firstTitleLabel.width = firstTitleLabelSize.width;
        firstConstLabel.frame = CGRectMake(firstTitleLabel.rightX + 12, 12, firstBackView.bounds.size.width - firstTitleLabel.rightX - 24, 21);
//        if (i == 0) {
//            self.firstTitleLabel.text = titleStr;
//            self.firstContentLabel.text = model.taskName;
//        }else if (i == 1) {
//            self.twoTitleLabel.text = titleStr;
//            self.twoContentLabel.text = model.taskName;
//        }
        [self.contentBackViews addObject:firstBackView];
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

-(void)clickFirstBut:(UIButton *)but {
    NSInteger index = but.tag - Tody_Cell_But_Tag;
    if (self.homeStudyModel.taskCenters.count > index) {
        if ([self.delegate respondsToSelector:@selector(studyCell:clickOtherBut:model:type:)]) {
            [self.delegate studyCell:self clickOtherBut:but model:self.homeStudyModel.taskCenters[index] type:1]; // 默认type传递0 以后可以增加定义1为点击其他类型的任务
        }
    }
}

-(void)clickTowBut:(UIButton *)but {
    if (self.homeStudyModel.taskCenters.count >= 2) {
        if ([self.delegate respondsToSelector:@selector(studyCell:clickOtherBut:model:type:)]) {
            [self.delegate studyCell:self clickOtherBut:but model:self.homeStudyModel.taskCenters.firstObject type:1]; // 默认type传递0 以后可以增加定义
        }
    }
}

@end
