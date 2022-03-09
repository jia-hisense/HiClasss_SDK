//
//  HICEnrollReviewerCell.m
//  HiClass
//
//  Created by WorkOffice on 2020/6/9.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import "HICEnrollReviewerCell.h"
@interface HICEnrollReviewerCell()
@property (nonatomic ,strong)UIImageView *selectIcon;
@property (nonatomic ,strong)UILabel *nameLabel;
@property (nonatomic ,strong)UILabel *emailLabel;
@property (nonatomic ,strong)UILabel *departmentLabel;
@property (nonatomic ,strong)UIView *line;
@property (nonatomic ,strong)NSIndexPath *indexPath;
@property (nonatomic ,strong)HICEnrollReviewerModel *model;
@end
@implementation HICEnrollReviewerCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    [super awakeFromNib];
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
        self.backgroundColor = UIColor.whiteColor;
    }
    return self;
}
- (void)createUI{
    UILabel *name = self.nameLabel;
    [self.contentView addSubview:name];
    UILabel *email = self.emailLabel;
    [self.contentView addSubview:email];
    UILabel *department = self.departmentLabel;
    [self.contentView addSubview:department];
    [self.contentView addSubview:self.selectIcon];
}
- (void)setModel:(HICEnrollReviewerModel *)model andIndexPath:(NSIndexPath *)indexPath{
    self.indexPath = indexPath;
    if (self.model == model) {
        return;
    }
    self.model = model;
    self.nameLabel.text = model.name;
    DDLogDebug(@"dsagkdhkjsadgsahjlk%@",model.name);
    CGSize size = [[NSString stringWithFormat:@"一%@",self.nameLabel.text] sizeWithAttributes:@{NSFontAttributeName:self.nameLabel.font}];
    DDLogDebug(@"dsahlkjdhsak;lj%f",size.width);
    [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(52);
        make.top.equalTo(self.contentView).offset(13);
        make.width.offset(size.width);
    }];
    self.emailLabel.text = model.email;
    [self.emailLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_right).offset(5);
        make.top.equalTo(self.contentView).offset(13);
        make.right.equalTo(self.contentView).offset(-16);
    }];
    self.departmentLabel.text = model.department;
    if(model.isSelected){
       _selectIcon.image = [UIImage imageNamed:@"勾选"];
    }else{
        _selectIcon.image = [UIImage imageNamed:@"未选择"];
    }
}
- (void)selectReviewer{
    if (_selectIcon.image == [UIImage imageNamed:@"未选择"]) {
        _selectIcon.image = [UIImage imageNamed:@"勾选"];
//        if ([self.delegete respondsToSelector:@selector(selectReviewerWithModel:andSelect:)]){
//            [self.delegete selectReviewerWithModel:self.model andSelect:YES];
//        }
    }else{
        _selectIcon.image = [UIImage imageNamed:@"未选择"];
//        if ([self.delegete respondsToSelector:@selector(selectReviewerWithModel:andSelect:)]){
//            [self.delegete selectReviewerWithModel:self.model andSelect:NO];
//        }
    }
}
-(UIImageView *)selectIcon{
    if (!_selectIcon) {
        _selectIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"未选择"]];
        _selectIcon.frame = CGRectMake(16, 25, 24, 24);
        _selectIcon.userInteractionEnabled = YES;
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectReviewer)];
//        [_selectIcon addGestureRecognizer:tap];
        _selectIcon.userInteractionEnabled = YES;
    }
    return _selectIcon;
}
- (UILabel *)departmentLabel{
    if (!_departmentLabel) {
        _departmentLabel = [[UILabel alloc]initWithFrame:CGRectMake(52, 35, HIC_ScreenWidth - 52 - 16, 20)];
        _departmentLabel.font = FONT_REGULAR_13;
        _departmentLabel.textColor = TEXT_COLOR_LIGHTM;
        _departmentLabel.numberOfLines = 1;
    }
    return _departmentLabel;
}
-(UIView *)line{
    if (!_line) {
        _line = [[UIView alloc]initWithFrame:CGRectMake(52, 64, HIC_ScreenWidth - 52, 0.5)];
        _line.backgroundColor = DEVIDE_LINE_COLOR;
    }
    return _line;
}
- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(52, 11, 11, 22.5)];
        _nameLabel.textColor = TEXT_COLOR_DARK;
        _nameLabel.font = FONT_REGULAR_16;
    }
    return _nameLabel;
}
-(UILabel *)emailLabel{
    if (!_emailLabel) {
        _emailLabel = [[UILabel alloc]initWithFrame:CGRectMake(106.5, 11, HIC_ScreenWidth - 52 - 16, 20)];
        _emailLabel.font = FONT_REGULAR_13;
        _emailLabel.textColor = TEXT_COLOR_LIGHTS;
        _emailLabel.numberOfLines = 1;
    }
    return _emailLabel;
}
@end
