//
//  HICOfflineTitleCell.m
//  HiClass
//
//  Created by hisense on 2020/4/24.
//  Copyright © 2020 haoqian. All rights reserved.
//
#import "HICOfflineTitleCell.h"

@implementation HICOfflineTitleData
+ (instancetype)initWithTitle:(NSString *)title cellHeight:(CGFloat)cellHeight {
    HICOfflineTitleData *data = [[HICOfflineTitleData alloc] init];
    data.title = title;
    data.cellHeight = cellHeight;
    return data;
}
@end




@interface HICOfflineTitleCell()
@property (nonatomic, weak) UILabel *lbl;

@end


@implementation HICOfflineTitleCell


+(instancetype)cellWithTableView:(UITableView *)tableView {

    static NSString *reusableIdentifier = @"HICOfflineTitleCell";

    HICOfflineTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:reusableIdentifier];

    if (cell == nil) {
        cell = [[HICOfflineTitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusableIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    UILabel *lbl = [[UILabel alloc] init];
    [self.contentView addSubview:lbl];
    self.lbl = lbl;
    lbl.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    lbl.textColor = [UIColor colorWithHexString:@"#333333"];

    return self;
}

- (void)setData:(HICOfflineTitleData *)data {
    _data = data;
    _lbl.text = data.title;


    CGFloat topPadding = 16;
    CGFloat leftPadding = 16;
    CGFloat rightPadding = 16;
    CGFloat cellW = HIC_ScreenWidth;

    _lbl.frame = CGRectMake(leftPadding, topPadding, cellW-(leftPadding+rightPadding), 23);
    
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
