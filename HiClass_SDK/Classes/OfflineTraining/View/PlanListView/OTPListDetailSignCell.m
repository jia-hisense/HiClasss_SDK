//
//  OTPListDetailSignCell.m
//  HiClass
//
//  Created by 铁柱， on 2020/4/17.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "OTPListDetailSignCell.h"

#define Detail_Sign_Cell_Tag 40000
#define Detail_Sign_Cell_Again_Tag 50000
#define Detail_Sign_Cell_Map_Tag 51000

@implementation OTPListDetailSignCell

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
        [self.contentBackView addSubview:classView];
    }
}

-(UIView *)createViewWithFrame:(CGRect)frame dataModel:(OfflineTrainingListModel *)model index:(NSInteger)index {

    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = UIColor.whiteColor;
    view.layer.cornerRadius = 2.f;
    view.layer.masksToBounds = YES;

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
    but.titleLabel.textAlignment = NSTextAlignmentRight;
    [view addSubview:but];
    but.tag = Detail_Sign_Cell_Tag + index;
    [but addTarget:self action:@selector(clickSignBut:) forControlEvents:UIControlEventTouchUpInside];

    UILabel *signTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width-16-72, 46.5, 71.5, 20)];
    signTypeLabel.textColor = [UIColor colorWithHexString:@"#FF8500"];
    signTypeLabel.font = FONT_REGULAR_14;
    [view addSubview:signTypeLabel];
    signTypeLabel.textAlignment = NSTextAlignmentRight;
    signTypeLabel.hidden = YES;
    UIButton *againSignBut = [[UIButton alloc] initWithFrame:signTypeLabel.frame];
    [view addSubview:againSignBut];
    [againSignBut addTarget:self action:@selector(clickAgainBut:) forControlEvents:UIControlEventTouchUpInside];
    againSignBut.enabled = NO;
    againSignBut.tag = Detail_Sign_Cell_Again_Tag + index;

    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 46.5, frame.size.width-32-72, 20)];
    timeLabel.textColor = [UIColor colorWithHexString:@"#858585"];
    timeLabel.font = FONT_REGULAR_14;
    [view addSubview:timeLabel];

    UILabel *commitLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 70.5, frame.size.width-32, 20)];
    commitLabel.textColor = [UIColor colorWithHexString:@"#858585"];
    commitLabel.font = FONT_REGULAR_14;
    [view addSubview:commitLabel];
    commitLabel.hidden = YES;

    // 赋值
    [self setValueWith:iconLabel timeLabel:timeLabel but:but titleLabel:titleLabel commitLabel:commitLabel signTypeLabel:signTypeLabel againSignBut:againSignBut backBut:nil model:model];

    if (model.taskType == 9 || model.taskType == 10) {
        // 签到或者签退
        if (!commitLabel.hidden) {
            UIButton *commitBut = [[UIButton alloc] initWithFrame:commitLabel.frame];
            [view addSubview:commitBut];
            commitBut.tag = Detail_Sign_Cell_Map_Tag + index;
            [commitBut addTarget:self action:@selector(clickMapBut:) forControlEvents:UIControlEventTouchUpInside];
        }
    }

    return view;

}

-(void)clickSignBut:(UIButton *) but {
    DDLogDebug(@"------- 签到或者签退 --------- %ld ", (long)but.tag - Detail_Sign_Cell_Tag);
    // 获取model
    NSInteger index = but.tag - Detail_Sign_Cell_Tag;
    if (index >= 0 && index < self.modelDatas.count) {
        OfflineTrainingListModel *model = [self.modelDatas objectAtIndex:index];
        [self clickButWith:but cell:self andModel:model andType:1]; // 调用父类方法
    }
}

-(void)clickAgainBut:(UIButton *)but {
    DDLogDebug(@"刷新签退范围 ---------   %ld ", (long)but.tag - Detail_Sign_Cell_Again_Tag);
    NSInteger index = but.tag - Detail_Sign_Cell_Again_Tag;
    if (index >= 0 && index < self.modelDatas.count) {
        OfflineTrainingListModel *model = [self.modelDatas objectAtIndex:index];
        [self clickSignAgainWith:model andCell:self]; // 调用父类方法
    }
}

-(void)clickMapBut:(UIButton *)but {
    DDLogDebug(@"点击签到地图 %ld", (long)but.tag - Detail_Sign_Cell_Map_Tag);
    NSInteger index = but.tag - Detail_Sign_Cell_Map_Tag;
    if (index >= 0 && index < self.modelDatas.count) {
        OfflineTrainingListModel *model = [self.modelDatas objectAtIndex:index];
        [self clickMapViewWith:model andCell:self]; // 调用父类方法
    }
}

@end
