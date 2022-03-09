//
//  HICMyNoteCell.m
//  HiClass
//
//  Created by WorkOffice on 2020/2/20.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICMyNoteCell.h"
#import "HICCourseModel.h"
#import "HICNoteInfoModel.h"
@interface HICMyNoteCell()
@property (nonatomic ,strong)UIImageView *leftView;
@property (nonatomic ,strong)UILabel *nameLabel;
@property (nonatomic ,strong)UILabel *numLabel;
@property (nonatomic ,strong)HICMyNoteModel *myNote;
@property (nonatomic ,strong)HICCourseModel *courseModel;
@property (nonatomic ,strong)HICNoteInfoModel *noteInfoModel;

@end
@implementation HICMyNoteCell
- (HICMyNoteModel *)myNote{
    if (!_myNote) {
        _myNote = [[HICMyNoteModel alloc]init];
    }
    return _myNote;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    [super awakeFromNib];
     if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
        [self updateConstraintsIfNeeded];
       }
    return self;
}
- (void)setNoteModel:(HICMyNoteModel *)noteModel{
    self.myNote = noteModel;
    self.courseModel = [HICCourseModel mj_objectWithKeyValues:self.myNote.courseKLDInfo];
    self.nameLabel.text = self.courseModel.courseKLDName;
//    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.courseModel.coverPic]];
//    self.leftView.image = [UIImage imageWithData:data];
    [self.leftView sd_setImageWithURL:[NSURL URLWithString:self.courseModel.coverPic]];
    self.numLabel.text = [NSString stringWithFormat:@"%ld",(long)self.myNote.notesNum];
    NSString *str = [NSString stringWithFormat:@"%ld%@",(long)self.myNote.notesNum,NSLocalizableString(@"aNote", nil)];
    NSMutableAttributedString *strAttr = [HICCommonUtils setupAttributeString:str rangeText:[NSString stringWithFormat:@"%ld",(long)self.myNote.notesNum] textColor:[UIColor colorWithHexString:@"#03B3CC"] stringColor:TEXT_COLOR_LIGHTM stringFont:[UIFont fontWithName:@"PingFangSC-Medium" size:13]];
    self.numLabel.attributedText = strAttr;
}

- (void)createUI{
    self.leftView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@""]];
    self.leftView.backgroundColor = [UIColor colorWithHexString:@"e6e6e6"];
    self.leftView.layer.cornerRadius = 4;
    self.leftView.clipsToBounds = YES;
    [self.contentView addSubview:self.leftView];
    
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.textColor = TEXT_COLOR_DARK;
    self.nameLabel.font = FONT_MEDIUM_15;
    self.nameLabel.numberOfLines = 2;
    self.nameLabel.text = @"课程名称心理学培训课-普通气昂昂奥奥奥奥奥奥奥奥奥奥奥";
    [self.contentView addSubview:self.nameLabel];
    
    self.numLabel = [[UILabel alloc]init];
    self.numLabel.textColor = TEXT_COLOR_LIGHTM;
    self.numLabel.font = FONT_REGULAR_13;
    self.numLabel.text = [NSString stringWithFormat:@"2%@",NSLocalizableString(@"aNote", nil)];;
    [self.contentView addSubview:self.numLabel];
}
- (void)updateConstraints {
    [super updateConstraints];
    [self.leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(16);
        make.top.equalTo(self.contentView).offset(16);
        make.width.offset(130);
        make.height.offset(73);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftView.mas_right).offset(12);
        make.top.equalTo(self.contentView).offset(16);
        make.width.offset(201);
    }];
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.width.offset(130);
        make.bottom.equalTo(self.leftView.mas_bottom);
    }];
}
@end
