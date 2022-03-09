//
//  HICEnrollReviewStatusCell.m
//  HiClass
//
//  Created by WorkOffice on 2020/6/19.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import "HICEnrollReviewStatusCell.h"
@interface HICEnrollReviewStatusCell ()
@property (nonatomic ,strong)CAShapeLayer *circleLayer;
@property (nonatomic ,strong)UILabel *topLabel;
@property (nonatomic ,strong)UILabel *bottomLabel;

@property (nonatomic ,strong)UILabel *titleLabel;
@property (nonatomic ,strong)UILabel *nameLabel;
@property (nonatomic ,strong)UILabel *statusLabel;
@end
@implementation HICEnrollReviewStatusCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    [super awakeFromNib];
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
        self.backgroundColor = UIColor.whiteColor;
    }
    return self;
}
- (void)createUI{
    [self.contentView.layer addSublayer:self.circleLayer];
    [self.contentView addSubview:self.bottomLabel];
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel addSubview:self.statusLabel];
    [self.contentView addSubview:self.titleLabel];
}
-(void)setIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row != 0) {
        [self.contentView addSubview:self.topLabel];
    }
}
-(void)setProcessModel:(HICEnrollReviewProcessModel *)processModel{
    if (_processModel == processModel) {
        return;
    }
    _processModel = processModel;
    self.titleLabel.text = _processModel.name;
    HICEnrollReviewerModel *model = _processModel.auditProcessAuditor;
    self.nameLabel.text = [NSString stringWithFormat:@"  %@",model.name];
    if (_processModel.status == 2) {
        self.statusLabel.text = NSLocalizableString(@"pass", nil);
        self.statusLabel.textColor = [UIColor colorWithHexString:@"#14BE6E"];
        _circleLayer.strokeColor = [UIColor colorWithHexString:@"#00BED7"].CGColor;
    }else if(_processModel.status == 3) {
        self.statusLabel.text = NSLocalizableString(@"rejected", nil);
        self.statusLabel.textColor = [UIColor colorWithHexString:@"#FF4B4B"];
        _circleLayer.strokeColor = [UIColor colorWithHexString:@"#FF654E"].CGColor;
    }else if(_processModel.status == 0){
        self.statusLabel.text = @"";//待审核
        _circleLayer.strokeColor = [UIColor colorWithHexString:@"#979797"].CGColor;
    }else{
       self.statusLabel.text = NSLocalizableString(@"inTheReview", nil);
        self.statusLabel.textColor = TEXT_COLOR_LIGHTM;
        _circleLayer.strokeColor = [UIColor colorWithHexString:@"#F59900"].CGColor;
    }
}

#pragma mark ---lazyload
- (UILabel *)topLabel{
    if (!_topLabel) {
        _topLabel = [[UILabel alloc] initWithFrame:CGRectMake(22, 0, 0.5, 21)];
        _topLabel.backgroundColor = [UIColor colorWithHexString:@"#D8D8D8"];
    }
    return _topLabel;
}
-(UILabel *)bottomLabel{
    if (!_bottomLabel) {
        _bottomLabel = [[UILabel alloc]initWithFrame:CGRectMake(22, 31, 0.5, 63.5)];
        _bottomLabel.backgroundColor = [UIColor colorWithHexString:@"#D8D8D8"];
        
    }
    return _bottomLabel;
}
-(CAShapeLayer *)circleLayer{
    if (!_circleLayer) {
        _circleLayer = [CAShapeLayer layer];
        _circleLayer.strokeColor = [UIColor colorWithHexString:@"#F59900"].CGColor;
        _circleLayer.fillColor = [UIColor clearColor].CGColor;
        _circleLayer.lineWidth = 1.5;
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(17, 21, 10, 10) cornerRadius:5];
        _circleLayer.path = path.CGPath;
        
    }
    return _circleLayer;
}
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(42, 18, HIC_ScreenWidth - 42, 22)];
        _titleLabel.font = FONT_MEDIUM_16;
        _titleLabel.textColor = TEXT_COLOR_DARK;
    }
    return _titleLabel;
}
-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(42, 47, HIC_ScreenWidth - 82, 48)];
        _nameLabel.layer.borderWidth = 0.5;
        _nameLabel.layer.borderColor = DEVIDE_LINE_COLOR.CGColor;
        _nameLabel.textColor = TEXT_COLOR_LIGHT;
        _nameLabel.font = FONT_REGULAR_16;
        _nameLabel.layer.cornerRadius = 2;
        self.clipsToBounds = YES;
    }
    return _nameLabel;
}
- (UILabel *)statusLabel{
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(_nameLabel.width - 70, 12, 60, 21)];
        _statusLabel.font = FONT_REGULAR_14;
        _statusLabel.textColor = TEXT_COLOR_LIGHTM;
    }
    return _statusLabel;
}
@end
