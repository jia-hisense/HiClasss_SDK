//
//  RankingListItemCell.m
//  iTest
//
//  Created by Sir_Jing on 2020/3/12.
//  Copyright © 2020 Sir_Jing. All rights reserved.
//

#import "RankingListItemCell.h"

@interface RankingListItemCell ()

@property (nonatomic, strong) NSArray *scroColors;

@property (nonatomic, strong) UILabel *numLable;            // 排名数字
@property (nonatomic, strong) UIImageView *numImageView;    // 排名图片
@property (nonatomic, strong) UILabel *scroLabel;           // 得分
@property (nonatomic, strong) UILabel *nameLabel;            // 名字
@property (nonatomic, strong) UILabel *deptLabel;           // 部门
@property (nonatomic, strong) UIImageView *headerImage;    // 排名图片
@end

@implementation RankingListItemCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createView];
        self.scroColors = @[[UIColor colorWithRed:1 green:75/255.0 blue:75/255.0 alpha:1],
                            [UIColor colorWithRed:1 green:133/255.0 blue:0 alpha:1],
                            [UIColor colorWithRed:245/255.0 green:166/255.0 blue:35/255.0 alpha:1],
                            [UIColor colorWithRed:133/255.0 green:133/255.0 blue:133/255.0 alpha:1]];
        self.backgroundColor = UIColor.whiteColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

-(void)createView {
    CGFloat screenWidth = UIScreen.mainScreen.bounds.size.width;
    CGFloat imageWidth = 50.f;
    CGFloat scroWidth =  150.f;
    CGFloat scroRight = 16.f;
    CGFloat scroLeft = 25;
    UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectMake(2, 16, 44, 50)];
    numLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
    numLabel.textAlignment = NSTextAlignmentCenter;
    numLabel.textColor = [UIColor colorWithRed:133/255.0 green:133/255.0 blue:133/255.0 alpha:1];
    numLabel.hidden = YES;
    self.numLable = numLabel;
    
    UIImageView *numImageView = [[UIImageView alloc] initWithFrame:CGRectMake(12.5, 30, 22, 22)];
    numImageView.hidden = YES;
    self.numImageView = numImageView;
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(48, 16, imageWidth, imageWidth)];
    iconImageView.layer.cornerRadius = 4.f;
    iconImageView.layer.masksToBounds = YES;
    iconImageView.backgroundColor = [UIColor colorWithHexString:@"e6e6e6"];
    self.headerImage = iconImageView;
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(48 + imageWidth + 10, 18.5, screenWidth - (48 + imageWidth + 10 + scroLeft + scroRight + 60), 22.5)];
    nameLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    nameLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(48 + imageWidth + 10, 18.5 + 3 + 22.5, screenWidth - (48 + imageWidth + 10 + scroLeft + scroRight + 60), 20)];
    contentLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    contentLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
    nameLabel.text = @"9fjaf";
    contentLabel.text = @"--f-99f3ff";
    self.nameLabel = nameLabel;
    self.deptLabel = contentLabel;
    UILabel *scroLabel = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth - scroWidth - scroRight, 18.5, scroWidth, 22.5)];
    scroLabel.textAlignment = NSTextAlignmentRight;
    scroLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
    self.scroLabel = scroLabel;
    
    [self.contentView addSubview:numLabel];
    [self.contentView addSubview:iconImageView];
    [self.contentView addSubview:nameLabel];
    [self.contentView addSubview:contentLabel];
    [self.contentView addSubview:scroLabel];
    [self.contentView addSubview:numImageView];
    
}
-(void)setModel:(HICMyRankInfoModel *)model{
    self.scroLabel.text = [model.score isEqualToString:@"-1"] ? [NSString stringWithFormat:@"0%@",NSLocalizableString(@"points", nil)]:model.score;
    self.numLable.text = [NSString stringWithFormat:@"%ld",(long)model.orderNum];
    if (model.orderNum  < 4 ) {
        self.numImageView.hidden = NO;
        self.numLable.hidden = YES;
    }else{
        self.numImageView.hidden = YES;
        self.numLable.hidden = NO;
    }
    self.deptLabel.text = model.dept;
    self.nameLabel.text = model.name;
    self.headerImage.image = nil;
    if (self.headerImage.subviews.count > 0) {
        [self.headerImage.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    if ([NSString isValidStr:model.pic]) {
        [self.headerImage sd_setImageWithURL:[NSURL URLWithString:model.pic]];
    }else{
        if ([NSString isValidStr:model.name]) {
            UILabel *imageLabel = [HICCommonUtils setHeaderFrame:CGRectMake(0, 0, 50, 50) andText:model.name];
            imageLabel.hidden = NO;
            [self.headerImage addSubview:imageLabel];
        }
    }
    
}
-(void)setCellIndexPath:(NSIndexPath *)cellIndexPath {
    _cellIndexPath = cellIndexPath;
    
    BOOL isNumLabelHidden = YES;
    NSString *numImageStr;
    UIColor *scroColor = self.scroColors.lastObject;
    NSString *numLabelStr = [NSString stringWithFormat:@"%ld", (long)cellIndexPath.row+1];
    if (cellIndexPath.row == 0) {
        numImageStr = @"第一名";
        scroColor = self.scroColors.firstObject;
    }else if (cellIndexPath.row == 1) {
        numImageStr = @"第二名";
        scroColor = self.scroColors[1];
    }else if (cellIndexPath.row == 2) {
        numImageStr = @"第三名";
        scroColor = self.scroColors[2];
    }else {
        isNumLabelHidden = NO;
    }
    
    self.numLable.hidden = isNumLabelHidden;
    self.numLable.text = numLabelStr;
    
    self.numImageView.hidden = !isNumLabelHidden;
    if (numImageStr) {
        self.numImageView.image = [UIImage imageNamed:numImageStr];
    }else {
        self.numImageView.image = nil;
    }
    
    self.scroLabel.text = [NSString stringWithFormat:@"%@%@", numLabelStr,NSLocalizableString(@"points", nil)];
    self.scroLabel.textColor = scroColor;
}

@end
