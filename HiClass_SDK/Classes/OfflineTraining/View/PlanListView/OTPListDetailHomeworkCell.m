//
//  OTPListDetailHomeworkCell.m
//  HiClass
//
//  Created by 铁柱， on 2020/4/17.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "OTPListDetailHomeworkCell.h"

#define Detail_Homework_Cell_Tag 80000

@implementation OTPListDetailHomeworkCell

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

    UIButton *backClickBut = [[UIButton alloc] initWithFrame:view.bounds];
    [view addSubview:backClickBut];
    backClickBut.tag = Detail_Homework_Cell_Tag + index;
    [backClickBut addTarget:self action:@selector(clickHomeworkBut:) forControlEvents:UIControlEventTouchUpInside];


    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 16, frame.size.width-112, 22.5)];
    titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    titleLabel.font = FONT_REGULAR_16;
    [view addSubview:titleLabel];

    UIButton *but = [[UIButton alloc] initWithFrame:CGRectMake(titleLabel.X+titleLabel.width+12, 16, 65, 22.5)];
    but.titleLabel.font = FONT_REGULAR_16;
    [view addSubview:but];
    but.tag = Detail_Homework_Cell_Tag + index;
    [but addTarget:self action:@selector(clickHomeworkBut:) forControlEvents:UIControlEventTouchUpInside];

    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 46.5, frame.size.width-32, 20)];
    timeLabel.textColor = [UIColor colorWithHexString:@"#858585"];
    timeLabel.font = FONT_REGULAR_14;
    [view addSubview:timeLabel];

    UILabel *commitLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 70.5, frame.size.width-32, 20)];
    commitLabel.textColor = [UIColor colorWithHexString:@"#FF8500"];
    commitLabel.font = FONT_REGULAR_14;
    [view addSubview:commitLabel];
    commitLabel.text = [NSString stringWithFormat:@"%@！",NSLocalizableString(@"timeoutWarning", nil)];
    commitLabel.hidden = YES;

    // 赋值
    [self setValueWith:nil timeLabel:timeLabel but:but titleLabel:titleLabel commitLabel:commitLabel signTypeLabel:nil againSignBut:nil backBut:backClickBut model:model];

    return view;

}


-(void)clickHomeworkBut:(UIButton *)but {
    DDLogDebug(@"家庭作业的点击事件------------ %ld", (long)but.tag - Detail_Homework_Cell_Tag);
    NSInteger index = but.tag - Detail_Homework_Cell_Tag;
    if (index >= 0 && index < self.modelDatas.count) {
        OfflineTrainingListModel *model = [self.modelDatas objectAtIndex:index];
        [self clickButWith:but cell:self andModel:model andType:1]; // 调用父类方法
    }
}

@end
