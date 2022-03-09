//
//  HICMyWorkSpaceCell.m
//  HiClass
//
//  Created by 铁柱， on 2021/1/7.
//  Copyright © 2021 haoqian. All rights reserved.
//

#import "HICMyWorkSpaceCell.h"
@interface HICMyWorkSpaceCell()
@property (nonatomic ,strong)UIImageView *imageV;
@property (nonatomic ,strong)UILabel *nameLabel;
@property (nonatomic ,strong)UILabel *numLabel;
@end
@implementation HICMyWorkSpaceCell
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}
-(void) createUI{
    self.backgroundColor = UIColor.whiteColor;
    self.layer.cornerRadius = 4;
    self.clipsToBounds = YES;
    [self.contentView addSubview:self.imageV];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.numLabel];

}
- (void)setModel:(HICMyspaceModel *)model{
    _model = model;
    self.numLabel.hidden = NO;
    self.nameLabel.text = _model.name;
    self.numLabel.text = [NSString stringWithFormat:@"%@",_model.num];
    if (_model.type == HICKnowledgeAudit) {
        self.imageV.image = [UIImage imageNamed:@"icon_zhishi"];
    }else if (_model.type == HICExamAudit){
        self.imageV.image = [UIImage imageNamed:@"icon_shijuan"];
    }else if (_model.type == HICQuestionAudit){
        self.imageV.image = [UIImage imageNamed:@"icon_shiti"];
    }else if (_model.type == HICGradeAudit){
        self.numLabel.hidden = YES;
        self.imageV.image = [UIImage imageNamed:@"icon_实操批阅"];
    }else if (_model.type == HICMyRegisterAudit){
        self.imageV.image = [UIImage imageNamed:@"icon_baoming"];
    }
}
- (UIImageView *)imageV{
    if (!_imageV) {
        _imageV = [[UIImageView alloc]initWithFrame:CGRectMake((self.width - 56)/2 , 22, 56, 56)];
    }
    return _imageV;
}
-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 96, self.width, 21)];
        _nameLabel.font = FONT_REGULAR_15;
        _nameLabel.textColor = TEXT_COLOR_DARK;
        _nameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _nameLabel;
}
-(UILabel *)numLabel{
    if (!_numLabel) {
        _numLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 123, self.width, 21)];
        _numLabel.textColor = TEXT_COLOR_LIGHTS;
        _numLabel.textAlignment = NSTextAlignmentCenter;
        _numLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _numLabel;
}
@end
