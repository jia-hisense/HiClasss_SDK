//
//  HICExercisesListItemCell.m
//  iTest
//
//  Created by Sir_Jing on 2020/2/4.
//  Copyright © 2020 Sir_Jing. All rights reserved.
//

#import "HICExercisesListItemCell.h"
#import "HICExerciseModel.h"
@interface HICExercisesListItemCell ()

@property (nonatomic, strong) UILabel *itemTitleLabel;

@property (nonatomic, strong) UILabel *itemNumLabel;

@property (nonatomic, strong) NSDictionary *dataDic;
@property (nonatomic, strong)HICExerciseModel *exerciseModel;
@end

@implementation HICExercisesListItemCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createView];
    }
    return self;
}
- (void)setExciseModel:(HICExerciseModel *)exciseModel{
    self.itemTitleLabel.text = exciseModel.exerciseName;
    self.itemNumLabel.text = [NSString stringWithFormat:@"%ld%@",(long)exciseModel.participantNum,NSLocalizableString(@"peopleHaveToAttend", nil)];
}
// 1. 创建视图
-(void)createView {

    CGFloat screenWidth = UIScreen.mainScreen.bounds.size.width;
    // 标题
    self.itemTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 17, screenWidth/2-18, 22.5)];
    self.itemTitleLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
    self.itemTitleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16.f];

    
    self.itemNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth/2, 18, screenWidth/2 - 29.5, 20)];
    self.itemNumLabel.textColor = [UIColor colorWithRed:133/255.0 green:133/255.0 blue:133/255.0 alpha:1];
    self.itemNumLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14.f];
    self.itemNumLabel.textAlignment = NSTextAlignmentRight;

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(screenWidth - 22, 22, 6.6, 12)];
    imageView.image = [UIImage imageNamed:@"小箭头"];

    [self.contentView addSubview:self.itemTitleLabel];
    [self.contentView addSubview:self.itemNumLabel];
    [self.contentView addSubview:imageView];

}

@end
