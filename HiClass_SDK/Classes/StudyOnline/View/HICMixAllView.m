//
//  HICMixAllView.m
//  HiClass
//
//  Created by WorkOffice on 2020/6/22.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import "HICMixAllView.h"
//#define HICMIX_All_Tag  2173012379
//#define HICMIX_All_Map_Tag   908978943

#define HICMIX_All_Tag  150000
#define HICMIX_All_Sign_Tag  250000
#define HICMIX_All_Map_Tag 251000
#define HICMIX_All_Back_Tag 25200
@implementation HICMixAllView
-(instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        self.backgroundColor = BACKGROUNG_COLOR;
    }
    return self;
}

-(void)setModelDatas:(NSArray *)modelDatas {
    if (modelDatas == self.modelDatas) {
        return;
    }
    [super setModelDatas:modelDatas];
    
    [self.contentBackView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)]; // 清空在建
    // FIXME: 区分类型创建 课程、签到(签退的高度82.5)、考试 高度104.5；作业(超时的高度104.5)、问卷 高度82.5
    CGFloat top = 0;
    for (NSInteger index = 0; index < modelDatas.count; index++) {
        HICMixTrainArrangeListModel *model = [modelDatas objectAtIndex:index];
        CGRect frame = CGRectMake(0, top, HIC_ScreenWidth-24, model.contentHeight);
        top += model.contentHeight;
        top += 12;
        UIView *classView = [self createViewWithFrame:frame dataModel:model index:index];
        CGFloat subTop = 104.5;
        for (NSInteger i = 0; i < model.subTasks.count; i++) {
            HICMixTrainArrangeListModel *subModel = [model.subTasks objectAtIndex:i];
            CGRect subFrame = CGRectMake(0, subTop, HIC_ScreenWidth-24, subModel.contentHeight);
            subTop += subModel.contentHeight;
            [classView addSubview:[self createSubViewWithFrame:subFrame dataModel:subModel index:i andModelIndex:index]];
        }
        [self.contentBackView addSubview:classView];
    }
}

-(UIView *)createViewWithFrame:(CGRect)frame dataModel:(HICMixTrainArrangeListModel *)model index:(NSInteger)index {
    
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = UIColor.whiteColor;
    view.layer.cornerRadius = 2.f;
    view.layer.masksToBounds = YES;
    UIButton *backClickBut;
    if (model.taskType == 8) {
        // 线下课程添加背景按钮
        UIButton *backBut = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 104.5)];
        [view addSubview:backBut];
        backBut.tag = HICMIX_All_Tag + index;
        [backBut addTarget:self action:@selector(clickBackBut:) forControlEvents:UIControlEventTouchUpInside];
    } else {
        // 其他类型的添加backBut
        backClickBut = [[UIButton alloc] initWithFrame:view.bounds];
        [view addSubview:backClickBut];
        backClickBut.tag = HICMIX_All_Back_Tag + index;
        [backClickBut addTarget:self action:@selector(clickAllBut:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    UILabel *iconLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 16, 32, 22.5)];
    iconLabel.textColor = [UIColor colorWithHexString:@"#4A90E2"];
    iconLabel.font = FONT_REGULAR_16;
    
    [view addSubview:iconLabel];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(51, 16, frame.size.width-144, 22.5)];
    titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    titleLabel.font = FONT_REGULAR_16;
    [view addSubview:titleLabel];
    
    UIButton *but = [[UIButton alloc] initWithFrame:CGRectMake(titleLabel.X+titleLabel.width+12, 16, 65, 22.5)];
    but.titleLabel.font = FONT_REGULAR_16;
    [view addSubview:but];
    but.tag = HICMIX_All_Back_Tag + index;
    [but addTarget:self action:@selector(clickAllBut:) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat timeWidth = frame.size.width-32;
    UILabel *signTypeLabel;
    UIButton *againSignBut;
    if (model.taskType == 9 || model.taskType == 10) {
        signTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width-16-72, 46.5, 71.5, 20)];
        signTypeLabel.textColor = [UIColor colorWithHexString:@"#FF8500"];
        signTypeLabel.font = FONT_REGULAR_14;
        [view addSubview:signTypeLabel];
        signTypeLabel.textAlignment = NSTextAlignmentRight;
        signTypeLabel.hidden = YES;
        againSignBut = [[UIButton alloc] initWithFrame:signTypeLabel.frame];
        [view addSubview:againSignBut];
        [againSignBut addTarget:self action:@selector(clickAgainBut:) forControlEvents:UIControlEventTouchUpInside];
        againSignBut.enabled = NO;
        againSignBut.tag = HICMIX_All_Sign_Tag + index;
        timeWidth = frame.size.width-32-72;
    }
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 46.5, timeWidth, 20)];
    timeLabel.textColor = [UIColor colorWithHexString:@"#858585"];
    timeLabel.font = FONT_REGULAR_14;
    [view addSubview:timeLabel];
    
    UILabel *commitLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 70.5, frame.size.width-32, 20)];
    commitLabel.textColor = [UIColor colorWithHexString:@"#858585"];
    commitLabel.font = FONT_REGULAR_14;
    [view addSubview:commitLabel];
    commitLabel.hidden = YES;
    UILabel *progressLabel = [[UILabel alloc]initWithFrame:CGRectMake(frame.size.width - 60, 28, 40, 20)];
    progressLabel.font = FONT_REGULAR_12;
    progressLabel.textColor = TEXT_COLOR_LIGHTS;
    [view addSubview:progressLabel];
    progressLabel.hidden = YES;
    
    UIProgressView *progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(frame.size.width - 70, 50, 50, 5)];
    progressView.progressViewStyle = UIProgressViewStyleDefault;
    progressView.layer.cornerRadius = 2.5;
       progressView.layer.masksToBounds = YES;
     progressView.progressTintColor = [UIColor colorWithHexString:@"#00BED7"];
    [view addSubview:progressView];
    progressView.hidden = YES;
    // 赋值
    [self setValueWith:iconLabel timeLabel:timeLabel but:but titleLabel:titleLabel commitLabel:commitLabel signTypeLabel:signTypeLabel againSignBut:againSignBut backBut:backClickBut progressLabel:progressLabel progressView:progressView model:model];
    
    if (model.taskType == 9 || model.taskType == 10) {
        // 签到或者签退
        backClickBut.enabled = NO; // 没有背景点击事件
        if (!commitLabel.hidden) {
            UIButton *commitBut = [[UIButton alloc] initWithFrame:commitLabel.frame];
            [view addSubview:commitBut];
            commitBut.tag = HICMIX_All_Map_Tag + index;
            [commitBut addTarget:self action:@selector(clickMapBut:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    return view;
    
}

-(UIView *)createSubViewWithFrame:(CGRect)frame dataModel:(HICMixTrainArrangeListModel *)model index:(NSInteger)index andModelIndex:(NSInteger)parentIndex{
    
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = UIColor.whiteColor;
    UIButton *backClickBut;
    if (model.taskType == 8) {
        // 线下课程添加背景按钮
        UIButton *backBut = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 104.5)];
        [view addSubview:backBut];
        backBut.tag = HICMIX_All_Tag + index + parentIndex*100;
        [backBut addTarget:self action:@selector(clickSubBackBut:) forControlEvents:UIControlEventTouchUpInside];
    }else {
        backClickBut = [[UIButton alloc] initWithFrame:view.bounds];
        [view addSubview:backClickBut];
        backClickBut.tag = HICMIX_All_Back_Tag + index + parentIndex*100;
        [backClickBut addTarget:self action:@selector(clickSubAllBut:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    UILabel *iconLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 16, 40, 22.5)];
    iconLabel.textColor = [UIColor colorWithHexString:@"#4A90E2"];
    iconLabel.font = FONT_REGULAR_16;
    
    [view addSubview:iconLabel];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(51, 16, frame.size.width-144, 22.5)];
    titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    titleLabel.font = FONT_REGULAR_16;
    [view addSubview:titleLabel];
    
    UIButton *but = [[UIButton alloc] initWithFrame:CGRectMake(titleLabel.X+titleLabel.width+12, 16, 65, 22.5)];
    but.titleLabel.font = FONT_REGULAR_16;
    [view addSubview:but];
    but.tag = HICMIX_All_Back_Tag + index + parentIndex*100;
    [but addTarget:self action:@selector(clickSubAllBut:) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat timeWidth = frame.size.width-32;
    UILabel *signTypeLabel;
    UIButton *againSignBut;
    if (model.taskType == 9 || model.taskType == 10) {
        signTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width-16-72, 46.5, 71.5, 20)];
        signTypeLabel.textColor = [UIColor colorWithHexString:@"#FF8500"];
        signTypeLabel.font = FONT_REGULAR_14;
        [view addSubview:signTypeLabel];
        signTypeLabel.textAlignment = NSTextAlignmentRight;
        signTypeLabel.hidden = YES;
        againSignBut = [[UIButton alloc] initWithFrame:signTypeLabel.frame];
        [view addSubview:againSignBut];
        [againSignBut addTarget:self action:@selector(clickSubAgainBut:) forControlEvents:UIControlEventTouchUpInside];
        againSignBut.enabled = NO;
        againSignBut.tag = HICMIX_All_Sign_Tag + index + parentIndex*100;
        timeWidth = frame.size.width-32-72;
    }
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 46.5, timeWidth, 20)];
    timeLabel.textColor = [UIColor colorWithHexString:@"#858585"];
    timeLabel.font = FONT_REGULAR_14;
    [view addSubview:timeLabel];
    
    UILabel *commitLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 70.5, frame.size.width-32, 20)];
    commitLabel.textColor = [UIColor colorWithHexString:@"#858585"];
    commitLabel.font = FONT_REGULAR_14;
    [view addSubview:commitLabel];
    commitLabel.hidden = YES;
    
    UILabel *progressLabel = [[UILabel alloc]initWithFrame:CGRectMake(frame.size.width - 60, 28, 40, 20)];
    progressLabel.font = FONT_REGULAR_12;
    progressLabel.textColor = TEXT_COLOR_LIGHTS;
    [view addSubview:progressLabel];
    progressLabel.hidden = YES;
    
    UIProgressView *progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(frame.size.width - 70, 50, 50, 5)];
    progressView.layer.cornerRadius = 2.5;
   progressView.layer.masksToBounds = YES;
    progressView.progressTintColor = [UIColor colorWithHexString:@"#00BED7"];
    [view addSubview:progressView];
    progressView.hidden = YES;
    
    // 页面赋值 --- 分情况处理
    // 赋值
    [self setValueWith:iconLabel timeLabel:timeLabel but:but titleLabel:titleLabel commitLabel:commitLabel signTypeLabel:signTypeLabel againSignBut:againSignBut backBut:backClickBut progressLabel:progressLabel progressView:progressView model:model];
    if (model.taskType == 9 || model.taskType == 10) {
        // 签到或者签退
        backClickBut.enabled = NO; // 没有背景点击事件
        if (!commitLabel.hidden) {
            UIButton *commitBut = [[UIButton alloc] initWithFrame:commitLabel.frame];
            [view addSubview:commitBut];
            commitBut.tag = HICMIX_All_Map_Tag + index + parentIndex*100;
            [commitBut addTarget:self action:@selector(clickSubMapBut:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    return view;
}

-(void)clickBackBut:(UIButton *)but {
    NSInteger index = but.tag - HICMIX_All_Tag;
    if (index >= 0 && index < self.modelDatas.count) {
        HICMixTrainArrangeListModel *model = [self.modelDatas objectAtIndex:index];
        [self clickButWith:but andModel:model andType:1]; // 调用父类方法
    }
}

-(void)clickSubBackBut:(UIButton *)but {
    NSInteger index = but.tag - HICMIX_All_Tag;
    NSInteger modelIndex = index / 100;
    if (modelIndex >= 0 && modelIndex < self.modelDatas.count) {
        HICMixTrainArrangeListModel *model = [self.modelDatas objectAtIndex:modelIndex];
        NSInteger subIndex = index %100;
        if (subIndex >= 0 && subIndex < model.subTasks.count) {
            HICMixTrainArrangeListModel *subModel = [model.subTasks objectAtIndex:subIndex];
            [self clickButWith:but andModel:subModel andType:1]; // 调用父类方法
        }
        
    }
}

-(void)clickAllBut:(UIButton *)but {
    DDLogDebug(@"------ AllBut ------- %ld", (long)but.tag - HICMIX_All_Back_Tag);
    NSInteger index = but.tag - HICMIX_All_Back_Tag;
    if (index >= 0 && index < self.modelDatas.count) {
        HICMixTrainArrangeListModel *model = [self.modelDatas objectAtIndex:index];
        [self clickButWith:but  andModel:model andType:1]; // 调用父类方法
    }
}

-(void)clickSubAllBut:(UIButton *)but {
    DDLogDebug(@"------ SubAllBut -------%ld", (long)but.tag - HICMIX_All_Back_Tag);
    NSInteger index = but.tag - HICMIX_All_Back_Tag;
    NSInteger modelIndex = index / 100;
    if (modelIndex >= 0 && modelIndex < self.modelDatas.count) {
        HICMixTrainArrangeListModel *model = [self.modelDatas objectAtIndex:modelIndex];
        NSInteger subIndex = index % 100;
        if (subIndex >= 0 && subIndex < model.subTasks.count) {
            HICMixTrainArrangeListModel *subModel = [model.subTasks objectAtIndex:subIndex];
            [self clickButWith:but andModel:subModel andType:1]; // 调用父类方法
        }
        
    }
}

-(void)clickSubAgainBut:(UIButton *)but {
    DDLogDebug(@"------ SubAgainBut -------%ld", (long)but.tag - HICMIX_All_Sign_Tag);
    NSInteger index = but.tag - HICMIX_All_Sign_Tag;
    NSInteger modelIndex = index / 100;
    if (modelIndex >= 0 && modelIndex < self.modelDatas.count) {
        HICMixTrainArrangeListModel *model = [self.modelDatas objectAtIndex:modelIndex];
        NSInteger subIndex = index % 100;
        if (subIndex >= 0 && subIndex < model.subTasks.count) {
            HICMixTrainArrangeListModel *subModel = [model.subTasks objectAtIndex:subIndex];
            [self clickSignAgainWith:subModel]; // 调用父类方法
        }
        
    }
}

-(void)clickAgainBut:(UIButton *)but {
    DDLogDebug(@"------ AgainBut -------%ld", (long)but.tag - HICMIX_All_Sign_Tag);
    NSInteger index = but.tag - HICMIX_All_Sign_Tag;
    if (index >= 0 && index < self.modelDatas.count) {
        HICMixTrainArrangeListModel *model = [self.modelDatas objectAtIndex:index];
        [self clickSignAgainWith:model]; // 调用父类方法
    }
}

-(void)clickMapBut:(UIButton *)but {
    DDLogDebug(@"点击签到地图 %ld", (long)but.tag - HICMIX_All_Map_Tag);
    NSInteger index = but.tag - HICMIX_All_Map_Tag;
    if (index >= 0 && index < self.modelDatas.count) {
        HICMixTrainArrangeListModel *model = [self.modelDatas objectAtIndex:index];
        [self clickMapViewWith:model]; // 调用父类方法
    }
}

-(void)clickSubMapBut:(UIButton *)but {
    DDLogDebug(@"点击签到地图 %ld", (long)but.tag - HICMIX_All_Map_Tag);
    NSInteger index = but.tag - HICMIX_All_Map_Tag;
    NSInteger modelIndex = index/100;
    if (modelIndex >= 0 && modelIndex < self.modelDatas.count) {
        HICMixTrainArrangeListModel *model = [self.modelDatas objectAtIndex:modelIndex];
        NSInteger subIndex = index % 100;
        if (subIndex >= 0 && subIndex < model.subTasks.count) {
            HICMixTrainArrangeListModel *subModel = [model.subTasks objectAtIndex:subIndex];
            [self clickMapViewWith:subModel]; // 调用父类方法
        }
    }
}


@end
