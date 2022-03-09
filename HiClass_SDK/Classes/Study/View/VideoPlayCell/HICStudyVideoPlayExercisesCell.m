//
//  HICStudyVideoPlayExercisesCell.m
//  iTest
//
//  Created by Sir_Jing on 2020/2/4.
//  Copyright © 2020 Sir_Jing. All rights reserved.
//

#import "HICStudyVideoPlayExercisesCell.h"
#import "HICCourseExciseModel.h"
#import "HICExerciseModel.h"
@interface HICStudyVideoPlayExercisesCell ()
@property (nonatomic, strong) NSMutableArray *itemsArray;
@property (nonatomic, strong) NSMutableArray *arrData;
@property (nonatomic, strong) HICCourseExciseModel *courseExciseModel;
@property (nonatomic, strong) HICExerciseModel *exciseModel;
@property (nonatomic ,strong) UILabel *exercisesTitle;
@property (nonatomic ,strong) UILabel *exercisesMore;
@end

@implementation HICStudyVideoPlayExercisesCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createBackView];
    }
    return self;
}
-(NSMutableArray *)arrData{
    if (!_arrData) {
        _arrData = [NSMutableArray array];
       
    }
    return _arrData;
}
-(instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        [self superview];
    }
    return self;
}
- (void)setDataArr:(NSArray *)dataArr{
    if (![HICCommonUtils isValidObject:dataArr]) {
        if (self.contentView.subviews) {
                   [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
               }
        return;
    }
    if (self.arrData.count > 3) {
        NSRange range = NSMakeRange(0, 3);
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
        self.arrData = (NSMutableArray *)[dataArr objectsAtIndexes:indexSet];
        self.exercisesMore.hidden = NO;
    }else{
        self.arrData = (NSMutableArray *)dataArr;
        self.exercisesMore.hidden = YES;
    }
   
    [self createBackView];
}
// 1. 创建BackView
-(void)createBackView {

    // 初始化数据
    self.itemsArray = [NSMutableArray array];
    // 创建视图
    CGRect frame = CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, self.arrData.count * 50 + 56 + 16);
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height-8)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:backView];

    self.exercisesTitle = [[UILabel alloc] initWithFrame:CGRectMake(16, 16, 60, 24)];
    self.exercisesTitle.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
    self.exercisesTitle.font = [UIFont fontWithName:@"PingFangSC-Medium" size:17.f];
    self.exercisesTitle.text = NSLocalizableString(@"exercises", nil);

    self.exercisesMore = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width-52, 19, 26, 18.5)];
    self.exercisesMore.textColor = [UIColor colorWithRed:133/255.0 green:133/255.0 blue:133/255.0 alpha:1];
    self.exercisesMore.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13.f];
    self.exercisesMore.text = NSLocalizableString(@"more", nil);

    UIImageView *moreImage = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width-21.5, 23.5, 5.5, 10)];
    moreImage.image = [UIImage imageNamed:@"小箭头"];

    UIButton *moreBut = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width - 16 - 35.5, 19, 35.5, 18.5)];
    [moreBut addTarget:self action:@selector(clickMoreBut:) forControlEvents:UIControlEventTouchUpInside];

    [backView addSubview:self.exercisesTitle];
    [backView addSubview:self.exercisesMore];
    [backView addSubview:moreImage];
    [backView addSubview:moreBut];
            if (self.arrData.count > 3) {
                self.exercisesMore.hidden = NO;
                moreImage.hidden = NO;
            }else{
                self.exercisesMore.hidden = YES;
                moreImage.hidden = YES;
            }
    UIView *footer = [[UIView alloc]initWithFrame:CGRectMake(0, frame.size.height-8, HIC_ScreenHeight, 8)];
    footer.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    [self.contentView addSubview:footer];
    [self createItemWith:backView];
    self.contentView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
}

// 2. 循环创建Item
-(void)createItemWith:(UIView *)backView {

    CGFloat itemHeith = 42.f;
    CGFloat left = 16.f;
    CGFloat itemWidth = backView.bounds.size.width - 16*2.f;
    CGFloat top = 56.f;
    
    for (int i = 0; i < self.arrData.count; i++) {
//        self.courseExciseModel = [HICCourseExciseModel mj_objectWithKeyValues:self.arrData[i]];
        self.exciseModel = [HICExerciseModel mj_objectWithKeyValues:self.arrData[i]];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(left, top, itemWidth, itemHeith)];
        view.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1];
        view.layer.cornerRadius = 2.f;
        view.layer.masksToBounds = YES;

        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, itemWidth, itemHeith)];
        [view addSubview:button];
        button.tag = 10000 + i;
        [button addTarget:self action:@selector(clickItemBut:) forControlEvents:UIControlEventTouchUpInside];

        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 10, itemWidth/2.0 - 12, 22.5)];
        titleLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
        titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16.f];
        titleLabel.text = self.exciseModel.exerciseName;
        UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(itemWidth/2 - 5, 10, itemWidth/2 - 20.5, 23.5)];
        infoLabel.textColor = [UIColor colorWithRed:133/255.0 green:133/255.0 blue:133/255.0 alpha:1];
        infoLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13.f];
        infoLabel.textAlignment = NSTextAlignmentRight;
        infoLabel.text = [NSString stringWithFormat:@"%ld%@",(long)self.exciseModel.participantNum,NSLocalizableString(@"peopleHaveToAttend", nil)];
        
        UIImageView *moreImage = [[UIImageView alloc] initWithFrame:CGRectMake(itemWidth-17.5, 17, 5.5, 10)];
        moreImage.image = [UIImage imageNamed:@"小箭头"];
//        moreImage.backgroundColor = UIColor.redColor;
        
        [view addSubview:titleLabel];
        [view addSubview:infoLabel];
        [view addSubview:moreImage];
        [backView addSubview:view];
        top += 52;

        // 记录titleLabel和infoLabel
        [self.itemsArray addObject:@[titleLabel, infoLabel]];
    }

}

// 3. 更多事件的处理
-(void)clickMoreBut:(UIButton *)btn {
    DDLogDebug(@"点击更多");
    if ([self.delegate respondsToSelector:@selector(studyVideoPlayCell:clickMoreBut:cellType:)]) {
        [self.delegate studyVideoPlayCell:self clickMoreBut:btn cellType:StudyVideoPlayCellExercises];
    }
}

// 4. Item的点击事件
-(void)clickItemBut:(UIButton *)btn {

    NSInteger tag = btn.tag - 10000;

    // 表示点击的是第一个Item
    DDLogDebug(@"点击Item == %ld == %ld", (long)tag, (long)self.itemsArray.count);

    if ([self.delegate respondsToSelector:@selector(studyVideoPlayCell:clickItemBut:cellType:itemModel:)]) {
        [self.delegate studyVideoPlayCell:self clickItemBut:btn cellType:StudyVideoPlayCellExercises itemModel:[NSNumber numberWithInteger:tag]];
    }

}


//-(void)setExercisesModel:(id)exercisesModel {
//
//    _exercisesModel = exercisesModel;
//    // 赋值
//    for (NSArray *array in self.itemsArray) {
//        UILabel *titleLabel = array.firstObject;
//        titleLabel.text = @"标题";
//        UILabel *infoLabel = array.lastObject;
//        infoLabel.text = @"完成呢  34 题";
//    }
//}

@end
