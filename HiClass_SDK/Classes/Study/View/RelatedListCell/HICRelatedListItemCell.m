//
//  HICRelatedListItemCell.m
//  iTest
//
//  Created by Sir_Jing on 2020/2/5.
//  Copyright © 2020 Sir_Jing. All rights reserved.
//

#import "HICRelatedListItemCell.h"

@interface HICRelatedListItemCell ()

@property (nonatomic, strong) UIImageView *studyImageView;

@property (nonatomic, strong) UILabel *studyTitleLabel;

@property (nonatomic, strong) UILabel *studyInfoLabel;

@property (nonatomic,strong) HICCourseModel *course;
@end

@implementation HICRelatedListItemCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createView];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
-(void)setCourseModel:(HICCourseModel *)courseModel{
     self.studyTitleLabel.text = courseModel.courseKLDName;
    self.studyInfoLabel.text = [NSString stringWithFormat:@"%ld%@",(long)courseModel.learnersNum,NSLocalizableString(@"peopleHaveToLearn", nil)];
}
// 1. 创建视图
-(void)createView {

    CGFloat screenWidth = UIScreen.mainScreen.bounds.size.width;

    self.studyImageView = [[UIImageView alloc] initWithFrame:CGRectMake(16, 20, 130, 73)];
    self.studyImageView.backgroundColor = [UIColor colorWithHexString:@"e6e6e6"];;
    self.studyImageView.layer.cornerRadius = 8.f;
    self.studyImageView.image = [UIImage imageNamed:self.course.coverPic];
    self.studyImageView.layer.masksToBounds = YES;

    self.studyTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(158, 20, screenWidth - 158 - 16, 42)];
    self.studyTitleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15.f];
    self.studyTitleLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
    self.studyTitleLabel.numberOfLines = 2;

    self.studyInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(158, 74.5, screenWidth - 158 - 16, 18.5)];
    self.studyInfoLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13.f];
    self.studyInfoLabel.textColor = [UIColor colorWithRed:133/255.0 green:133/255.0 blue:133/255.0 alpha:1];

    [self.contentView addSubview:self.studyImageView];
    [self.contentView addSubview:self.studyTitleLabel];
    [self.contentView addSubview:self.studyInfoLabel];
}

@end
