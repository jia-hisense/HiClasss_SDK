//
//  HICMyCommentCell.m
//  HiClass
//
//  Created by Eddie Ma on 2020/2/20.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICMyCommentCell.h"
@interface HICMyCommentCell()
@property (nonatomic ,strong)UILabel *timeLabel;
@property (nonatomic ,strong)UIButton *deleBtn;
@property (nonatomic ,strong)UILabel *contentLabel;
@property (nonatomic ,strong)UIView *deleView;
@property (nonatomic ,strong)UIImageView *deleImage;
@property (nonatomic ,strong)UILabel *deleLabel;
@end
@implementation HICMyCommentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self creatUI];
    }
    return self;
}

- (void)creatUI {
    self.backgroundColor = [UIColor whiteColor];
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(16, 0, HIC_ScreenWidth - 16, 0.5)];
    line.backgroundColor = DEVIDE_LINE_COLOR;
    [self.contentView addSubview:line];
    self.timeLabel = [[UILabel alloc]init];
    self.timeLabel.font = FONT_REGULAR_14;
    self.timeLabel.textColor = TEXT_COLOR_LIGHTS;
    [self.contentView addSubview:self.timeLabel];
    
    self.deleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.deleBtn setImage:[UIImage imageNamed:@"评论-删除"] forState:UIControlStateNormal];
    if (@available(iOS 13.0, *)) {
        self.deleBtn.titleEdgeInsets = UIEdgeInsetsZero;
    } else {
        self.deleBtn.titleEdgeInsets = UIEdgeInsetsMake(2,-20,2,2);
    }
    self.deleBtn.imageEdgeInsets = UIEdgeInsetsMake(1,1,1,31);
    self.deleBtn.titleLabel.font = FONT_REGULAR_13;
    [self.deleBtn setTitle:NSLocalizableString(@"delete", nil) forState:UIControlStateNormal];
    [self.deleBtn setTitleColor:TEXT_COLOR_LIGHTM forState:UIControlStateNormal];
    [self.deleBtn addTarget:self action:@selector(deleteComments) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.deleBtn];
    
    self.contentLabel = [[UILabel alloc]init];
    self.contentLabel.textColor = TEXT_COLOR_LIGHTM;
    self.contentLabel.font = FONT_REGULAR_15;
    self.contentLabel.numberOfLines = 0;
//    self.contentLabel.Y = 48;
//    self.contentLabel.X = 0;
//    self.contentLabel.width = HIC_ScreenWidth - 32;
    [self.contentView addSubview:self.contentLabel];
    
    
}
-(void)setModel:(HICMyCommentsModel *)model{
    _model = model;
    self.timeLabel.text = [HICCommonUtils timeStampToReadableDate:_model.time isSecs:NO format:@"yyyy-MM-dd HH:mm"];
    self.contentLabel.text = _model.content;
    [self updateConstraints];
}
- (void)updateConstraints{
    [super updateConstraints];

    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(16);
        make.left.equalTo(self.contentView).offset(16);
        make.height.offset(20);
    }];
    [self.deleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeLabel);
        make.right.equalTo(self.contentView).offset(-16);
        make.width.offset(50);
        make.height.offset(19);
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(48);
        make.left.equalTo(self.contentView).offset(16);
        make.right.equalTo(self.contentView).offset(-16);
    }];
}
- (void)deleteComments{
    if (self.commentDelegate && [self.commentDelegate respondsToSelector:@selector(deleteClick:andType:andIndexPath:)]) {
        [self.commentDelegate deleteClick:_model.commentId andType:_model.objectType andIndexPath:_indexPath];
    }
}
@end
