//
//  HICStudyVideoPlayRelatedCell.m
//  iTest
//
//  Created by Sir_Jing on 2020/2/4.
//  Copyright © 2020 Sir_Jing. All rights reserved.
//

#import "HICStudyVideoPlayRelatedCell.h"
#import "HICCourseRecommendModel.h"
#import "HICCourseModel.h"
@interface HICStudyVideoPlayRelatedCell ()

@property (nonatomic, strong) NSMutableArray *itemsArray;
@property (nonatomic ,strong) NSMutableArray *arrData;
@property (nonatomic ,strong) UILabel *exercisesTitle;
@property (nonatomic ,strong) UILabel *exercisesMore;
@end

@implementation HICStudyVideoPlayRelatedCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createBackView];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self superview];
    }
    return self;
}
-(NSMutableArray *)arrData{
    if (!_arrData) {
        _arrData = [NSMutableArray array];
    }
    return _arrData;
}
//- (void)setIsAll:(BOOL)isAll{
//    _isAll = isAll;
//}
- (void)setDataArr:(NSArray *)dataArr{
    _dataArr = dataArr;
    if (![HICCommonUtils isValidObject:dataArr]) {
        if (self.contentView.subviews) {
           [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        }
           return;
       }
    self.arrData = [NSMutableArray arrayWithArray:dataArr];
    if (self.arrData.count > 3) {
        NSRange range = NSMakeRange(0, 3);
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
        self.arrData = (NSMutableArray *)[dataArr objectsAtIndexes:indexSet];
    }else{
        self.arrData = (NSMutableArray *)dataArr;
    }
//    if (_isAll) {
//        self.arrData = (NSMutableArray *)dataArr;
//    }else{
//        if (self.arrData.count > 3) {
//            NSRange range = NSMakeRange(0, 3);
//            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
//            self.arrData = (NSMutableArray *)[dataArr objectsAtIndexes:indexSet];
//
//        }else{
//
//            self.arrData = (NSMutableArray *)dataArr;
//        }
//    }
    [self createBackView];
}
// 1. 创建BackView
-(void)createBackView {
    // 初始化数据
    self.itemsArray = [NSMutableArray array];
    CGRect frame;
//    if (_isAll) {
//        // 创建视图
//        frame = CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, self.arrData.count * 50  + 16);
//    }else{
        // 创建视图
        frame = CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, self.arrData.count * 50 + 56 + 16);
//    }
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height-8)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:backView];

    self.exercisesTitle = [[UILabel alloc] initWithFrame:CGRectMake(16, 16, 68, 24)];
    self.exercisesTitle.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
    self.exercisesTitle.font = [UIFont fontWithName:@"PingFangSC-Medium" size:17.f];
    self.exercisesTitle.text = NSLocalizableString(@"relatedRecommend", nil);

    self.exercisesMore = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width-52, 19, 26, 18.5)];
    self.exercisesMore.textColor = [UIColor colorWithRed:133/255.0 green:133/255.0 blue:133/255.0 alpha:1];
    self.exercisesMore.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13.f];
    self.exercisesMore.text = NSLocalizableString(@"more", nil);

    UIImageView *moreImage = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width-21.5, 23.5, 5.5, 10)];
    moreImage.image = [UIImage imageNamed:@"小箭头"];
    if (_dataArr.count > 3) {
        moreImage.hidden = NO;
        self.exercisesMore.hidden = NO;
    }else{
        moreImage.hidden = YES;
        self.exercisesMore.hidden = YES;
    }
    
    UIButton *moreBut = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width - 16 - 35.5, 19, 35.5, 18.5)];
    [moreBut addTarget:self action:@selector(clickMoreBut:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:self.exercisesTitle];
    [backView addSubview:self.exercisesMore];
    [backView addSubview:moreImage];
    [backView addSubview:moreBut];
    [self createItemWith:backView];
    self.contentView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
}

// 2. 循环创建Item
-(void)createItemWith:(UIView *)backView {

    
    CGFloat left = 16.f;
    CGFloat itemWidth = backView.bounds.size.width - 16*2.f;
    CGFloat top;
    CGFloat itemHeith;
//    if (_isAll) {
//        top = 0;
//        itemHeith = 50.f;
//    }else{
        top = 56.f;
        itemHeith = 42.f;
//    }
    
    for (int i = 0; i < self.arrData.count; i++) {
        HICCourseRecommendModel *recommendModel = [HICCourseRecommendModel mj_objectWithKeyValues:self.arrData[i]];
        HICCourseModel *courseModel = [HICCourseModel mj_objectWithKeyValues:recommendModel.courseKLDInfo];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(left, top, itemWidth, itemHeith)];
//        if (_isAll) {
//            view.backgroundColor = [UIColor whiteColor];
//        }else{
            view.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1];
//        }
        view.layer.cornerRadius = 2.f;
        view.layer.masksToBounds = YES;

        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, itemWidth, itemHeith)];
        [view addSubview:button];
        button.tag = 10000 + i;
        [button addTarget:self action:@selector(clickItemBut:) forControlEvents:UIControlEventTouchUpInside];

        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 10, itemWidth/2.0 - 12, 22.5)];
        titleLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
        titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16.f];
        titleLabel.text = NSLocalizableString(@"title", nil);
        titleLabel.text = courseModel.courseKLDName;
        UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(itemWidth/2 - 5, 10, itemWidth/2 - 20.5, 23.5)];
        infoLabel.textColor = [UIColor colorWithRed:133/255.0 green:133/255.0 blue:133/255.0 alpha:1];
        infoLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13.f];
        infoLabel.textAlignment = NSTextAlignmentRight;
//        infoLabel.text = @"完成 34 题";
        infoLabel.text = [NSString stringWithFormat:@"%ld%@",(long)courseModel.learnersNum,NSLocalizableString(@"peopleHaveToLearn", nil)];
//        infoLabel.backgroundColor = [UIColor blueColor];

        UIImageView *moreImage = [[UIImageView alloc] initWithFrame:CGRectMake(itemWidth-17.5, 17, 5.5, 10)];
        moreImage.image = [UIImage imageNamed:@"小箭头"];
//        moreImage.backgroundColor = UIColor.redColor;
        [view addSubview:titleLabel];
        [view addSubview:infoLabel];
        [view addSubview:moreImage];
        [backView addSubview:view];
        top += 52;
//        if (_isAll) {
//            titleLabel.frame = CGRectMake(16, 14, itemWidth/2.0 , 22.5);
//            infoLabel.frame = CGRectMake(itemWidth/2-5, 14, itemWidth/2 - 20.5, 23.5);
//            moreImage.frame = CGRectMake(itemWidth-17.5, 22.5, 5.5, 10);
//            titleLabel.font = FONT_MEDIUM_16;
//            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 49.5, HIC_ScreenWidth, 0.5)];
//            line.backgroundColor = [UIColor colorWithHexString:@"#E6E6E6"];
//            [view addSubview:line];
//        }
        // 记录titleLabel和infoLabel
        [self.itemsArray addObject:@[titleLabel, infoLabel]];
    }

}

// 3. 更多事件的处理
-(void)clickMoreBut:(UIButton *)btn {
    DDLogDebug(@"点击更多");
        if ([self.delegate respondsToSelector:@selector(studyVideoPlayCell:clickMoreBut:cellType:)]) {
        [self.delegate studyVideoPlayCell:self clickMoreBut:btn cellType:StudyVideoPlayCellRelated];
    }
}

// 4. Item的点击事件
-(void)clickItemBut:(UIButton *)btn {
    NSInteger tag = btn.tag - 10000;
    if ([self.delegate respondsToSelector:@selector(studyVideoPlayCell:clickItemBut:cellType:itemModel:)]) {
        [self.delegate studyVideoPlayCell:self clickItemBut:btn cellType:StudyVideoPlayCellRelated itemModel:[NSNumber numberWithInteger:tag]];
    }
}

@end
