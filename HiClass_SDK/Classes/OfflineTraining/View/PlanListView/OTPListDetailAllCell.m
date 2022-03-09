//
//  OTPListDetailCell.m
//  HiClass
//
//  Created by 铁柱， on 2020/4/16.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "OTPListDetailAllCell.h"

#define Detail_All_Cell_Tag  10000
#define Detail_All_Cell_Sign_Tag  20000
#define Detail_All_Cell_Map_Tag 21000
#define Detail_All_Cell_Back_Tag 2200

@interface OTPListDetailAllCell ()

@end

@implementation OTPListDetailAllCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 创建一个时间控件和线 , 放置到父类中创建
    }
    return self;
}

-(void)setCellIndexPath:(NSIndexPath *)cellIndexPath {
    if (self.cellIndexPath == cellIndexPath) {
        return;
    }
    [super setCellIndexPath:cellIndexPath];

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
        OfflineTrainingListModel *model = [modelDatas objectAtIndex:index];
        CGRect frame = CGRectMake(0, top, HIC_ScreenWidth-46, model.contentHeight);
        top += model.contentHeight;
        top += 12;
        UIView *classView = [self createViewWithFrame:frame dataModel:model index:index];
        CGFloat subTop = 104.5;
        for (NSInteger i = 0; i < model.subTasks.count; i++) {
            OfflineTrainingListModel *subModel = [model.subTasks objectAtIndex:i];
            CGRect subFrame = CGRectMake(0, subTop, HIC_ScreenWidth-46, subModel.contentHeight);
            subTop += subModel.contentHeight;
            [classView addSubview:[self createSubViewWithFrame:subFrame dataModel:subModel index:i andModelIndex:index]];
        }
        [self.contentBackView addSubview:classView];
    }
}

-(UIView *)createViewWithFrame:(CGRect)frame dataModel:(OfflineTrainingListModel *)model index:(NSInteger)index {

    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = UIColor.whiteColor;
    view.layer.cornerRadius = 2.f;
    view.layer.masksToBounds = YES;
    UIButton *backClickBut;
    if (model.taskType == 8) {
        // 线下课程添加背景按钮
        UIButton *backBut = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 104.5)];
        [view addSubview:backBut];
        backBut.tag = Detail_All_Cell_Back_Tag + index;
        [backBut addTarget:self action:@selector(clickBackBut:) forControlEvents:UIControlEventTouchUpInside];
    } else {
        // 其他类型的添加backBut
        backClickBut = [[UIButton alloc] initWithFrame:view.bounds];
        [view addSubview:backClickBut];
        backClickBut.tag = Detail_All_Cell_Tag + index;
        [backClickBut addTarget:self action:@selector(clickAllBut:) forControlEvents:UIControlEventTouchUpInside];
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
    but.tag = Detail_All_Cell_Tag + index;
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
        againSignBut.tag = Detail_All_Cell_Sign_Tag + index;
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

    // 赋值
    [self setValueWith:iconLabel timeLabel:timeLabel but:but titleLabel:titleLabel commitLabel:commitLabel signTypeLabel:signTypeLabel againSignBut:againSignBut backBut:backClickBut model:model];

    if (model.taskType == 9 || model.taskType == 10) {
        // 签到或者签退
        backClickBut.enabled = NO; // 没有背景点击事件
        if (!commitLabel.hidden) {
            UIButton *commitBut = [[UIButton alloc] initWithFrame:commitLabel.frame];
            [view addSubview:commitBut];
            commitBut.tag = Detail_All_Cell_Map_Tag + index;
            [commitBut addTarget:self action:@selector(clickMapBut:) forControlEvents:UIControlEventTouchUpInside];
        }
    }

    return view;

}

-(UIView *)createSubViewWithFrame:(CGRect)frame dataModel:(OfflineTrainingListModel *)model index:(NSInteger)index andModelIndex:(NSInteger)parentIndex{

    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = UIColor.whiteColor;
    UIButton *backClickBut;
    if (model.taskType == 8) {
        // 线下课程添加背景按钮
        UIButton *backBut = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 104.5)];
        [view addSubview:backBut];
        backBut.tag = Detail_All_Cell_Back_Tag + index + parentIndex*100;
        [backBut addTarget:self action:@selector(clickSubBackBut:) forControlEvents:UIControlEventTouchUpInside];
    }else {
        backClickBut = [[UIButton alloc] initWithFrame:view.bounds];
        [view addSubview:backClickBut];
        backClickBut.tag = Detail_All_Cell_Tag + index + parentIndex*100;
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
    but.tag = Detail_All_Cell_Tag + index + parentIndex*100;
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
        againSignBut.tag = Detail_All_Cell_Sign_Tag + index + parentIndex*100;
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

    // 页面赋值 --- 分情况处理
    // 赋值
    [self setValueWith:iconLabel timeLabel:timeLabel but:but titleLabel:titleLabel commitLabel:commitLabel signTypeLabel:signTypeLabel againSignBut:againSignBut backBut:backClickBut model:model];

    if (model.taskType == 9 || model.taskType == 10) {
        // 签到或者签退
        backClickBut.enabled = NO; // 没有背景点击事件
        if (!commitLabel.hidden) {
            UIButton *commitBut = [[UIButton alloc] initWithFrame:commitLabel.frame];
            [view addSubview:commitBut];
            commitBut.tag = Detail_All_Cell_Map_Tag + index + parentIndex*100;
            [commitBut addTarget:self action:@selector(clickSubMapBut:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    return view;
}

-(void)clickBackBut:(UIButton *)but {
    NSInteger index = but.tag - Detail_All_Cell_Back_Tag;
    if (index >= 0 && index < self.modelDatas.count) {
        OfflineTrainingListModel *model = [self.modelDatas objectAtIndex:index];
        [self clickButWith:but cell:self andModel:model andType:1]; // 调用父类方法
    }
}

-(void)clickSubBackBut:(UIButton *)but {
    NSInteger index = but.tag - Detail_All_Cell_Back_Tag;
    NSInteger modelIndex = index / 100;
    if (modelIndex >= 0 && modelIndex < self.modelDatas.count) {
        OfflineTrainingListModel *model = [self.modelDatas objectAtIndex:modelIndex];
        NSInteger subIndex = index %100;
        if (subIndex >= 0 && subIndex < model.subTasks.count) {
            OfflineTrainingListModel *subModel = [model.subTasks objectAtIndex:subIndex];
            [self clickButWith:but cell:self andModel:subModel andType:1]; // 调用父类方法
        }

    }
}

-(void)clickAllBut:(UIButton *)but {
    DDLogDebug(@"------ AllBut ------- %ld", (long)but.tag - Detail_All_Cell_Tag);
    NSInteger index = but.tag - Detail_All_Cell_Tag;
    if (index >= 0 && index < self.modelDatas.count) {
        OfflineTrainingListModel *model = [self.modelDatas objectAtIndex:index];
        [self clickButWith:but cell:self andModel:model andType:1]; // 调用父类方法
    }
}

-(void)clickSubAllBut:(UIButton *)but {
    DDLogDebug(@"------ SubAllBut -------%ld", (long)but.tag - Detail_All_Cell_Tag);
    NSInteger index = but.tag - Detail_All_Cell_Tag;
    NSInteger modelIndex = index / 100;
    if (modelIndex >= 0 && modelIndex < self.modelDatas.count) {
        OfflineTrainingListModel *model = [self.modelDatas objectAtIndex:modelIndex];
        NSInteger subIndex = index % 100;
        if (subIndex >= 0 && subIndex < model.subTasks.count) {
            OfflineTrainingListModel *subModel = [model.subTasks objectAtIndex:subIndex];
            [self clickButWith:but cell:self andModel:subModel andType:1]; // 调用父类方法
        }

    }
}

-(void)clickSubAgainBut:(UIButton *)but {
    DDLogDebug(@"------ SubAgainBut -------%ld", (long)but.tag - Detail_All_Cell_Sign_Tag);
    NSInteger index = but.tag - Detail_All_Cell_Sign_Tag;
    NSInteger modelIndex = index / 100;
    if (modelIndex >= 0 && modelIndex < self.modelDatas.count) {
        OfflineTrainingListModel *model = [self.modelDatas objectAtIndex:modelIndex];
        NSInteger subIndex = index % 100;
        if (subIndex >= 0 && subIndex < model.subTasks.count) {
            OfflineTrainingListModel *subModel = [model.subTasks objectAtIndex:subIndex];
            [self clickSignAgainWith:subModel andCell:self]; // 调用父类方法
        }

    }
}

-(void)clickAgainBut:(UIButton *)but {
    DDLogDebug(@"------ AgainBut -------%ld", (long)but.tag - Detail_All_Cell_Sign_Tag);
    NSInteger index = but.tag - Detail_All_Cell_Sign_Tag;
    if (index >= 0 && index < self.modelDatas.count) {
        OfflineTrainingListModel *model = [self.modelDatas objectAtIndex:index];
        [self clickSignAgainWith:model andCell:self]; // 调用父类方法
    }
}

-(void)clickMapBut:(UIButton *)but {
    DDLogDebug(@"点击签到地图 %ld", (long)but.tag - Detail_All_Cell_Map_Tag);
    NSInteger index = but.tag - Detail_All_Cell_Map_Tag;
    if (index >= 0 && index < self.modelDatas.count) {
        OfflineTrainingListModel *model = [self.modelDatas objectAtIndex:index];
        [self clickMapViewWith:model andCell:self]; // 调用父类方法
    }
}

-(void)clickSubMapBut:(UIButton *)but {
    DDLogDebug(@"点击签到地图 %ld", (long)but.tag - Detail_All_Cell_Map_Tag);
    NSInteger index = but.tag - Detail_All_Cell_Map_Tag;
    NSInteger modelIndex = index/100;
    if (modelIndex >= 0 && modelIndex < self.modelDatas.count) {
        OfflineTrainingListModel *model = [self.modelDatas objectAtIndex:modelIndex];
        NSInteger subIndex = index % 100;
        if (subIndex >= 0 && subIndex < model.subTasks.count) {
            OfflineTrainingListModel *subModel = [model.subTasks objectAtIndex:subIndex];
            [self clickMapViewWith:subModel andCell:self]; // 调用父类方法
        }
    }
}

@end
