//
//  SearchTeacherInfoCell.m
//  iTest
//
//  Created by Sir_Jing on 2020/3/18.
//  Copyright © 2020 Sir_Jing. All rights reserved.
//

#import "SearchTeacherInfoCell.h"

@interface SearchTeacherInfoCell ()

/// 教师的图片View
@property (nonatomic, strong) UIImageView *iconImageView;

/// 教师的标题
@property (nonatomic, strong) UILabel *nameLabel;

/// 教师的副标题
@property (nonatomic, strong) UILabel *companyLabel;

/// 教师的简介
@property (nonatomic, strong) UILabel *teacherConLabel;

@end

@implementation SearchTeacherInfoCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = UIColor.whiteColor;
        [self createView];
    }
    return self;
}

-(void)createView {

    CGFloat screenWidth = UIScreen.mainScreen.bounds.size.width;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(16, 20, 50, 50)];
    imageView.layer.cornerRadius = 4.f;
    imageView.layer.masksToBounds = YES;
    imageView.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16+10+50, 20, screenWidth-16*2-10-50, 22.5)];
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    titleLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
    titleLabel.text = @"iiifiefeaiiif";

    UILabel *contenLabel = [[UILabel alloc] initWithFrame:CGRectMake(16+10+50, 20+22.5+4, screenWidth-16*2-10-50, 37)];
    contenLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    contenLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
    contenLabel.numberOfLines = 2;
    contenLabel.text = @"3faefaf   yixuan jiifeiaf3faefaf   yixuan jiifeiaf3faefaf   yixuan jiifeiaf3faefaf   yixuan jiifeiaf";

    UILabel *tcLabel = [[UILabel alloc] initWithFrame:CGRectMake(16+10+50, 20+22.5+4+37+4, screenWidth-16*2-10-50, 18.5)];
    tcLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    tcLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
    tcLabel.text = [NSString stringWithFormat:@"%@：%@ ---",NSLocalizableString(@"introduction", nil),NSLocalizableString(@"goodTeachers", nil)];

    [self.contentView addSubview:imageView];
    [self.contentView addSubview:titleLabel];
    [self.contentView addSubview:contenLabel];
//    [self.contentView addSubview:tcLabel];
    self.iconImageView = imageView;
    self.nameLabel = titleLabel;
    self.companyLabel = contenLabel;
    self.teacherConLabel = tcLabel;
}

// 针对Cell赋值
-(void)setInfoModel:(SearchDetailInfoModel *)infoModel {
    if (_infoModel == infoModel) {
        return;
    }
    _infoModel = infoModel;
 
    self.nameLabel.text = infoModel.title;
    self.companyLabel.text = infoModel.dept;
    self.teacherConLabel.text = infoModel.infoDescription;

    if ([NSString isValidStr:infoModel.coverPic]) {
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:infoModel.coverPic]];
    }else {
        // 没有图片的情况下使用默认图片
        if (self.iconImageView.subviews.count > 0) {
            [self.iconImageView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        }
        NSString *name = infoModel.title;
//        if (name.length == 0) {
//            name = @"无";
//        }
//        NSArray *names = [name componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@",.<>/?;'\"|，。/？‘“、()（）"]];
//        name = names.firstObject;
//        if (name.length == 0) {
//            name = @"无";
//        }
//        name = [name substringWithRange:NSMakeRange(name.length-1, 1)];
        UILabel *label = [HICCommonUtils setHeaderFrame:self.iconImageView.bounds andText:name];
        label.hidden = NO;
        [self.iconImageView addSubview:label];
    }

    
}


@end
