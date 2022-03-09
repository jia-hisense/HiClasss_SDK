//
//  HICMySettingCell.m
//  HiClass
//
//  Created by WorkOffice on 2020/3/17.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICMySettingCell.h"
@interface HICMySettingCell()
@property (nonatomic ,strong)UILabel *rightLabel;
@property (nonatomic ,strong)UILabel *leftLabel;
@property (nonatomic ,strong)UILabel *disclosureLabel;
@property (nonatomic ,strong)UISwitch *switchR;
@property (nonatomic ,strong)UIImageView *imageViewR;
@property (nonatomic ,strong)UIImageView *headerImage;
@property (nonatomic ,strong)UILabel *nameLabel;
@end
@implementation HICMySettingCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    [super awakeFromNib];
     if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
        [self updateConstraintsIfNeeded];
       }
    return self;
}
- (void)createUI{
    self.contentView.backgroundColor = UIColor.whiteColor;
    self.leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 14, HIC_ScreenWidth - 100, 22.5)];
    _leftLabel.font = FONT_REGULAR_16;
    _leftLabel.textColor = TEXT_COLOR_DARK;
//    [self.contentView addSubview:_leftLabel];
    self.rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(HIC_ScreenWidth - 16 - 100, 14, 100, 22.5)];
    _rightLabel.font = FONT_REGULAR_16;
    _rightLabel.textColor = TEXT_COLOR_LIGHTM;
    _rightLabel.textAlignment = NSTextAlignmentRight;
//    [self.contentView addSubview:_rightLabel];
    self.disclosureLabel = [[UILabel alloc]initWithFrame:CGRectMake(HIC_ScreenWidth - 33.5 - 100, 14, 100, 22.5)];
    _disclosureLabel.font = FONT_REGULAR_16;
    _disclosureLabel.textColor = TEXT_COLOR_LIGHTM;
    _disclosureLabel.textAlignment = NSTextAlignmentRight;
    self.switchR = [[UISwitch alloc]initWithFrame:CGRectMake(HIC_ScreenWidth - 16 - 47.5, 11, 47.5, 28.5)];
    _switchR.onTintColor = [UIColor colorWithHexString:@"#00BED7"];
    [_switchR addTarget:self action:@selector(valueChanged:) forControlEvents:(UIControlEventValueChanged)];
    self.imageViewR = [[UIImageView alloc]initWithFrame:CGRectMake(HIC_ScreenWidth - 33.5 - 24.5, 17.5, 24.5, 15)];
    self.imageViewR.image = [UIImage imageNamed:@"new"];
    self.headerImage = [[UIImageView alloc]initWithFrame:CGRectMake(HIC_ScreenWidth - 33.5 - 60, 12, 60, 60)];
    _headerImage.layer.cornerRadius = 4;
    _headerImage.clipsToBounds = YES;
    _headerImage.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageTap)];
    [_headerImage addGestureRecognizer:tap];
    _headerImage.userInteractionEnabled = YES;
}
- (void)haveDiscoureLabel:(BOOL)haveDiscoureLabel isSwitch:(BOOL)isSwitch haveRightLabel:(BOOL)haveRightLabel haveRightImage:(BOOL)haveRightImage isHeader:(BOOL)isHeader andLeftStr:(NSString *)left andRightStr:(NSString *)rightStr{
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.contentView addSubview:self.leftLabel];
    self.leftLabel.text = left;
    if (isSwitch) {
         [self.contentView addSubview:self.switchR];
//        if (_indexPath.row == 0){
//            if (![NSString isValidStr:[[NSUserDefaults standardUserDefaults] objectForKey:[NSNumber numberWithInteger:_indexPath.row].stringValue]]) {
//                self.switchR.on = YES;
//                [[NSUserDefaults standardUserDefaults] setObject:@"isOn" forKey:[NSNumber numberWithInteger:_indexPath.row].stringValue];
//            }else{
//              self.switchR.on = _isOn;
//            }
//        }else{
//           self.switchR.on = _isOn;
//        }
        self.switchR.on = _isOn;
    }
    if (haveRightImage) {
        [self.contentView addSubview:self.imageViewR];
    }
    if (isHeader) {
        self.leftLabel.Y = 40;
        [self.contentView addSubview:self.headerImage];
    }
    if (haveDiscoureLabel) {
        [self.contentView addSubview:self.disclosureLabel];
        self.disclosureLabel.text = rightStr;
    }
    if (haveRightLabel) {
        [self.contentView addSubview:self.rightLabel];
        self.rightLabel.text = rightStr;
        self.leftLabel.width = 100;
        self.rightLabel.frame = CGRectMake(100 + 16 + 5, 14, HIC_ScreenWidth - 100 - 16 *2 - 5, 22.5);
        self.rightLabel.textAlignment = NSTextAlignmentRight;
    }
}
- (void)setHeader:(UIImage *)header{
    if (header) {
        self.headerImage.image = header;
    }
}
- (void)setHeaderPic:(NSString *)headerPic{
    if (headerPic) {
        [self.headerImage sd_setImageWithURL:[NSURL URLWithString:headerPic]];
    }
}
- (void)setIsHeader:(BOOL)isHeader{
    if (isHeader) {
        self.nameLabel.hidden = YES;
    }
}
-(void)setName:(NSString *)name{
    if (name) {
        self.nameLabel = [HICCommonUtils setHeaderFrame:CGRectMake(0, 0, self.headerImage.width, self.headerImage.height) andText:name];
        [self.headerImage addSubview:self.nameLabel];
        self.nameLabel.hidden = NO;
    }
}
- (void)valueChanged:(UISwitch *)Switch{
    if (self.delegate && [self.delegate respondsToSelector:@selector(switchTouched:andSwitchStatus:)]) {
        [self.delegate switchTouched:_indexPath andSwitchStatus:Switch.on];
    }
}
- (void)imageTap{
    if (self.delegate && [self.delegate respondsToSelector:@selector(changeHeader)]) {
        [self.delegate changeHeader];
    }
}
@end
