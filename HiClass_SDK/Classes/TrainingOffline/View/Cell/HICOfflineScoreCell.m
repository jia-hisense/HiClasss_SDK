//
//  HICOfflineScoreCell.m
//  HiClass
//
//  Created by hisense on 2020/4/24.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import "HICOfflineScoreCell.h"

#define HICOfflineScoreCellLblHeight 40


@implementation HICOfflineScoreCellData

+ (instancetype)dataWithTitle:(NSString *)title score:(NSString *)score isSeparatorHidden:(BOOL )isSeparatorHidden maxFormatScore:(NSString *)maxFormatScore textFont:( UIFont *)textFont textColor:(UIColor *)textColor lblBgColor:(UIColor *)lblBgColor topPadding:(CGFloat)topPadding cellHeight:(CGFloat)cellHeight {
    HICOfflineScoreCellData *data = [[HICOfflineScoreCellData alloc] init];
    data.title = title;
    data.score = score;
    data.isSeparatorHidden = isSeparatorHidden;
    data.maxFormatScore = maxFormatScore;
    data.textFont = textFont;
    data.textColor = textColor;
    data.lblBgColor = lblBgColor;
    data.topPadding = topPadding;
    data.cellHeight = cellHeight;
    return data;
}

@end


@interface HICOfflineScoreCell()

@property (nonatomic, weak) UILabel *titleLbl;
@property (nonatomic, weak) UILabel *scoreLbl;
@property (nonatomic, weak) UIView *lblBgView;

@property (nonatomic, weak) UIView *separatorLineView;

@property (nonatomic, assign) CGFloat maxScoreLblW;


@end


@implementation HICOfflineScoreCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {

    static NSString *reusableIdentifier = @"HICOfflineScoreCell";

    HICOfflineScoreCell *cell = [tableView dequeueReusableCellWithIdentifier:reusableIdentifier];

    if (cell == nil) {
        cell = [[HICOfflineScoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusableIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    UIView *lblBgView = [[UIView alloc] init];
    [self.contentView addSubview:lblBgView];
    self.lblBgView = lblBgView;

    UILabel *titleLbl = [[UILabel alloc] init];
    //    titleLbl.adjustsFontSizeToFitWidth = YES;
    [self.contentView addSubview:titleLbl];
    self.titleLbl = titleLbl;
    titleLbl.backgroundColor = [UIColor clearColor];


    UILabel *scoreLbl = [[UILabel alloc] init];
    //    scoreLbl.adjustsFontSizeToFitWidth = YES;
    [self.contentView addSubview:scoreLbl];
    self.scoreLbl = scoreLbl;
    scoreLbl.textAlignment = NSTextAlignmentRight;
    scoreLbl.backgroundColor = [UIColor clearColor];


     UIView *separatorLineView = [[UIView alloc] init];
     self.separatorLineView = separatorLineView;
     [self.contentView addSubview:separatorLineView];
     separatorLineView.backgroundColor = [UIColor colorWithHexString:@"#E6E6E6"];

     return self;
     }

     -(void)setData:(HICOfflineScoreCellData *)data {
        _data = data;

        _titleLbl.text = data.title;
        _scoreLbl.text = data.score;

        _titleLbl.font = data.textFont;
        _titleLbl.textColor = data.textColor;

        _scoreLbl.font = data.textFont;
        _scoreLbl.textColor = data.textColor;

        _lblBgView.backgroundColor = data.lblBgColor;

        CGSize size = [data.maxFormatScore sizeWithFont:_data.textFont maxSize:CGSizeMake(MAXFLOAT, HICOfflineScoreCellLblHeight)];
        _maxScoreLblW = size.width;

        [_separatorLineView setHidden:data.isSeparatorHidden];
    }


     - (void)layoutSubviews {
        [super layoutSubviews];


        CGFloat leftPadding = 16;
        CGFloat rightPadding = 16;

        self.scoreLbl.frame = CGRectMake(self.width- (rightPadding+_maxScoreLblW), 11, _maxScoreLblW, HICOfflineScoreCellLblHeight);
        self.titleLbl.frame = CGRectMake(leftPadding, 11,CGRectGetMinX(self.scoreLbl.frame)-leftPadding, HICOfflineScoreCellLblHeight);
        self.lblBgView.frame = CGRectMake(12, _data.topPadding, self.width-24, HICOfflineScoreCellLblHeight);

        self.scoreLbl.center = CGPointMake(self.scoreLbl.center.x, self.lblBgView.center.y);
        self.titleLbl.center = CGPointMake(self.titleLbl.center.x, self.lblBgView.center.y);

         self.separatorLineView.frame = CGRectMake(leftPadding, self.height-0.5, self.width-leftPadding, 0.5);

    }



     - (void)awakeFromNib {
        [super awakeFromNib];
        // Initialization code
    }

     - (void)setSelected:(BOOL)selected animated:(BOOL)animated {
        [super setSelected:selected animated:animated];

        // Configure the view for the selected state
    }

     @end
