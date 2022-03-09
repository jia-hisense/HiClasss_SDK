//
//  HICEnrollReviewCell.m
//  HiClass
//
//  Created by WorkOffice on 2020/6/5.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import "HICEnrollReviewCell.h"
#import "HICEnrollReviewModel.h"
@interface HICEnrollReviewCell()
@property (nonatomic ,strong)CAShapeLayer *circleLayer;
@property (nonatomic ,strong)UILabel *topLabel;
@property (nonatomic ,strong)UILabel *bottomLabel;
@property (nonatomic ,strong)UILabel *titleLabel;
@property (nonatomic ,strong)UILabel *nameLabel;
@property (nonatomic ,strong)UILabel *selectNameLabel;
@property (nonatomic ,strong)UILabel *statusLabel;
@end
@implementation HICEnrollReviewCell
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
    [self.contentView addSubview:self.titleLabel];
}
-(void)setIndexPath:(NSIndexPath *)indexPath{
    _indexPath = indexPath;
    if (indexPath.row != 0) {
        [self.contentView addSubview:self.topLabel];
    }
}
-(void)setReviewModel:(HICEnrollReviewModel *)reviewModel{
    _reviewModel = reviewModel;
    self.titleLabel.text = _reviewModel.name;
    self.nameLabel.userInteractionEnabled = NO;
    if ([NSString isValidStr:_reviewModel.auditorName]) {
        self.nameLabel.text = [NSString stringWithFormat:@"  %@",_reviewModel.auditorName];
        self.nameLabel.userInteractionEnabled = YES;
        self.nameLabel.textColor = TEXT_COLOR_DARK;
    }else{
        if (_reviewModel.auditTemplateNodeAuditors.count == 1) {
            HICEnrollReviewerModel *model = _reviewModel.auditTemplateNodeAuditors[0];
            self.nameLabel.text = [NSString stringWithFormat:@" %@",model.name];
            self.nameLabel.backgroundColor = UIColor.whiteColor;
            _nameLabel.textColor = TEXT_COLOR_LIGHT;
        }else if(_reviewModel.auditTemplateNodeAuditors.count > 1){
            self.nameLabel.backgroundColor = BACKGROUNG_COLOR;
            self.nameLabel.text = [NSString stringWithFormat:@"  %@",NSLocalizableString(@"selectAReviewer", nil)];
            self.nameLabel.textColor = [UIColor colorWithHexString:@"#C9C9C9"];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectReviewer:)];
            self.nameLabel.tag = 273912;
            self.nameLabel.userInteractionEnabled = YES;
            [self.nameLabel addGestureRecognizer:tap];
        }else{
            self.nameLabel.backgroundColor = BACKGROUNG_COLOR;
            self.nameLabel.text = [NSString stringWithFormat:@"  %@",NSLocalizableString(@"chooseFromTheOrganizationalStructure", nil)];
            self.nameLabel.textColor = [UIColor colorWithHexString:@"#C9C9C9"];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectReviewer:)];
            self.nameLabel.tag = 2739213;
            self.nameLabel.userInteractionEnabled = YES;
            [self.nameLabel addGestureRecognizer:tap];
        }
    }
    
}
- (void)selectReviewer:(UIGestureRecognizer *)tap{
    if (tap.view.tag == 273912) {
        if ([self.delegate respondsToSelector:@selector(jumpWithModelArr:andIndexPath:)]) {
            [self.delegate jumpWithModelArr:_reviewModel.auditTemplateNodeAuditors andIndexPath:_indexPath];
        }
    }else{
        if ([self.delegate respondsToSelector:@selector(jumpSearchWithIndexPath:)]) {
            [self.delegate jumpSearchWithIndexPath:_indexPath];
        }
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
        _circleLayer.strokeColor = [UIColor colorWithHexString:@"#979797"].CGColor;
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
        _nameLabel.backgroundColor = UIColor.whiteColor;
        _nameLabel.clipsToBounds = YES;
    }
    return _nameLabel;
}
@end
