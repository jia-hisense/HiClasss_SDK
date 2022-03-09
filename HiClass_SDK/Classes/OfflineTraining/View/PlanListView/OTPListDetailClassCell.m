//
//  OTPListDetailClassCell.m
//  HiClass
//
//  Created by 铁柱， on 2020/4/16.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "OTPListDetailClassCell.h"

#define Detail_Class_Cell_Tag 100000

@implementation OTPListDetailClassCell

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

    UIButton *backBut = [[UIButton alloc] initWithFrame:view.bounds];
    [view addSubview:backBut];
    backBut.tag = Detail_Class_Cell_Tag + index;
    [backBut addTarget:self action:@selector(clickBackBut:) forControlEvents:UIControlEventTouchUpInside];

    CGFloat titleWidth = frame.size.width-112;

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 16, titleWidth, 22.5)];
    titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    titleLabel.font = FONT_REGULAR_16;
    [view addSubview:titleLabel];


    UIButton *but = [[UIButton alloc] initWithFrame:CGRectMake(titleLabel.X+titleLabel.width+12, 16, 65, 22.5)];
    but.titleLabel.font = FONT_REGULAR_16;
    but.enabled = NO;
    [view addSubview:but];


    // 时间 -- 讲师的显示
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 46.5, frame.size.width-32, 20)];
    timeLabel.textColor = [UIColor colorWithHexString:@"#858585"];
    timeLabel.font = FONT_REGULAR_14;
    [view addSubview:timeLabel];

    UILabel *commitLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 70.5, frame.size.width-32, 20)];
    commitLabel.textColor = [UIColor colorWithHexString:@"#858585"];
    commitLabel.font = FONT_REGULAR_14;
    [view addSubview:commitLabel];

    // 赋值
    [self setValueWith:nil timeLabel:timeLabel but:but titleLabel:titleLabel commitLabel:commitLabel signTypeLabel:nil againSignBut:nil backBut:nil model:model];

    return view;

}


-(void)clickBackBut:(UIButton *)but {
    DDLogDebug(@"点击===== %ld", (long)but.tag - Detail_Class_Cell_Tag);
    NSInteger index = but.tag - Detail_Class_Cell_Tag;
    if (index >= 0 && index < self.modelDatas.count) {
        OfflineTrainingListModel *model = [self.modelDatas objectAtIndex:index];
        [self clickButWith:but cell:self andModel:model andType:1]; // 调用父类方法
    }
}

@end
