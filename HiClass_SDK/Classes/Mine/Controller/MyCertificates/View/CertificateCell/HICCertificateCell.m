//
//  HICCertificateCell.m
//  HiClass
//
//  Created by Eddie_Ma on 18/4/20.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICCertificateCell.h"
#import "HICView.h"

@interface HICCertificateCell ()
@property (nonatomic, strong) UIImageView *certIV;
@property (nonatomic, strong) HICView *tagBGView;
@property (nonatomic, strong) UILabel *tagLabel;
@property (nonatomic, strong) UILabel *certNameLb;
@property (nonatomic, strong) UILabel *certIssueDateLb;
@property (nonatomic, strong) UILabel *certAuthorityLb;
@property (nonatomic, strong) UIView *lightGrayCover;
@property (nonatomic, strong) UILabel *revokeReasonLb;
@property (nonatomic, strong) UIView *dividedLine;
@end

@implementation HICCertificateCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [self.certIV sd_cancelCurrentImageLoad];
    self.certIV.image = [UIImage imageNamed:@"证书默认图2"];
}

- (void)createUI {
    self.backgroundColor = [UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.certIV];
    [self.contentView addSubview:self.certNameLb];
    [self.contentView addSubview:self.certIssueDateLb];
    [self.contentView addSubview:self.certAuthorityLb];
    [self.contentView addSubview:self.revokeReasonLb];
    [self.contentView addSubview:self.lightGrayCover];
    [self.contentView addSubview:self.tagBGView];
    [self.tagBGView addSubview:self.tagLabel];
    [self.contentView addSubview:self.dividedLine];
    [self makeAutoLayout];
}

- (void)setData:(HICCertificateModel *)cerModel {
    if (cerModel.picUrlImg) {
        self.certIV.image = cerModel.picUrlImg;
    } else if([NSString isValidStr:cerModel.picUrl]) {
        [self.certIV sd_setImageWithURL:[NSURL URLWithString:cerModel.picUrl] placeholderImage:[UIImage imageNamed:@"证书默认图2"]];
    }
    
    self.tagBGView.hidden = cerModel.status == HICCertNormal;
    self.lightGrayCover.hidden = cerModel.status == HICCertNormal || cerModel.status == HICCertWillInvalid;
    switch (cerModel.status) {
        case HICCertWillInvalid:
            self.tagLabel.text = NSLocalizableString(@"theFailure", nil);
            self.tagBGView.colors = @[[UIColor colorWithHexString:@"#FF8E6F"], [UIColor colorWithHexString:@"#FF553C"]];
            self.tagBGView.startPoint = CGPointMake(0, 0);
            self.tagBGView.endPoint = CGPointMake(1, 0);
            break;
        case HICCertInvalided:
            self.tagLabel.text = NSLocalizableString(@"hasTheFailure", nil);
            self.tagBGView.colors = @[[UIColor colorWithHexString:@"#B9B9B9"], [UIColor colorWithHexString:@"#B9B9B9"]];
            self.tagBGView.startPoint = CGPointMake(0, 0);
            self.tagBGView.endPoint = CGPointMake(0, 1);
            break;
        case HICCertRevoke:
            self.tagLabel.text = NSLocalizableString(@"hasBeenRevoked", nil);
            self.tagBGView.colors = @[[UIColor colorWithHexString:@"#B9B9B9"], [UIColor colorWithHexString:@"#B9B9B9"]];
            self.tagBGView.startPoint = CGPointMake(0, 0);
            self.tagBGView.endPoint = CGPointMake(0, 1);
            self.revokeReasonLb.text =  [NSString stringWithFormat:@"%@：%@", NSLocalizableString(@"revocationReason", nil),cerModel.revokeReason];
            break;
        default:
            break;
    }
    self.certNameLb.text = cerModel.name;
    self.certIssueDateLb.text = [NSString stringWithFormat:@"%@: %@", NSLocalizableString(@"releaseDate", nil),[HICCommonUtils timeStampToReadableDate:cerModel.createdTime isSecs:YES format:@"yyyy-MM-dd"]];
    self.certAuthorityLb.text = [NSString stringWithFormat:@"%@: %@", NSLocalizableString(@"licenseIssuingAgency", nil),[NSString isValidStr:cerModel.authority] ? cerModel.authority : NSLocalizableString(@"licenseIssuingAuthorityUnknown", nil)];
    self.revokeReasonLb.hidden = cerModel.status != HICCertRevoke;
}
- (void)makeAutoLayout {
    [self.certIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(17);
        make.width.mas_equalTo(90);
        make.height.equalTo(@130);
        make.left.equalTo(self.contentView).offset(16);
        make.bottom.lessThanOrEqualTo(self.contentView).offset(-16);
    }];
    [self.tagBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.certIV);
    }];
    [self.tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.tagBGView).inset(2);
    }];
    [self.certNameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(17);
        make.left.equalTo(self.certIV.mas_right).offset(16);
        make.right.equalTo(self.contentView).inset(16);
    }];
    [self.certIssueDateLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.certNameLb.mas_bottom).offset(16);
        make.left.right.equalTo(self.certNameLb);
    }];
    [self.certAuthorityLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.certIssueDateLb.mas_bottom).offset(4);
        make.left.right.equalTo(self.certNameLb);
    }];
    [self.revokeReasonLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.certAuthorityLb.mas_bottom).offset(12);
        make.left.right.equalTo(self.certNameLb);
        make.bottom.lessThanOrEqualTo(self.contentView).inset(16);
    }];
    [self.lightGrayCover mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    [self.dividedLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.certNameLb);
        make.bottom.right.equalTo(self.contentView);
        make.height.equalTo(@0.5);
    }];
}

#pragma mark -- 懒加载
- (UIImageView *)certIV {
    if (!_certIV) {
        _certIV = [[UIImageView alloc] initWithFrame:CGRectMake(16, 16.5, 90, 130)];
        _certIV.layer.cornerRadius = 5;
        _certIV.layer.masksToBounds = YES;
        _certIV.image = [UIImage imageNamed:@"证书默认图2"];
        _certIV.contentMode = UIViewContentModeScaleAspectFill;
        _certIV.layer.borderWidth = 0.5;
        _certIV.layer.borderColor = [UIColor colorWithHexString:@"e6e6e6"].CGColor;
    }
    return _certIV;
}
- (HICView *)tagBGView {
    if (!_tagBGView) {
        _tagBGView = [[HICView alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
        _tagBGView.corners = UIRectCornerTopLeft | UIRectCornerBottomRight;
        _tagBGView.cornerRadii = CGSizeMake(4.0, 4.0);
        _tagBGView.colors = @[[UIColor colorWithHexString:@"#B9B9B9"], [UIColor colorWithHexString:@"#B9B9B9"]];
        _tagBGView.locations = @[@0, @1];
        _tagBGView.startPoint = CGPointMake(0, 0);
        _tagBGView.endPoint = CGPointMake(0, 1);
    }
    return _tagBGView;
}
- (UILabel *)tagLabel {
    if (!_tagLabel) {
        _tagLabel = [[UILabel alloc] init];
        _tagLabel.textAlignment = NSTextAlignmentCenter;
        _tagLabel.textColor = [UIColor whiteColor];
        _tagLabel.font = FONT_MEDIUM_9;
    }
    return _tagLabel;
}
- (UILabel *)certNameLb {
    if (!_certNameLb) {
        _certNameLb = [[UILabel alloc] init];
        _certNameLb.text = NSLocalizableString(@"certificateName", nil);
        _certNameLb.textColor = [UIColor colorWithHexString:@"#333333"];
        _certNameLb.font = FONT_REGULAR_16;
        _certNameLb.numberOfLines = 2;
    }
    return _certNameLb;
}
- (UILabel *)certIssueDateLb {
    if (!_certIssueDateLb) {
        _certIssueDateLb = [[UILabel alloc] init];
        _certIssueDateLb.text = [NSString stringWithFormat:@"%@：",NSLocalizableString(@"releaseDate", nil)];
        _certIssueDateLb.textColor = [UIColor colorWithHexString:@"#858585"];
        _certIssueDateLb.font = FONT_REGULAR_14;
    }
    return _certIssueDateLb;
}
- (UILabel *)certAuthorityLb {
    if (!_certAuthorityLb) {
        _certAuthorityLb = [[UILabel alloc] init];
        _certAuthorityLb.text = [NSString stringWithFormat:@"%@：",NSLocalizableString(@"licenseIssuingAgency", nil)];
        _certAuthorityLb.textColor = [UIColor colorWithHexString:@"#858585"];
        _certAuthorityLb.font = FONT_REGULAR_14;
        _certAuthorityLb.numberOfLines = 2;
    }
    return _certAuthorityLb;
}
- (UIView *)lightGrayCover {
    if (!_lightGrayCover) {
        _lightGrayCover = [UIView new];
        _lightGrayCover.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    }
    return _lightGrayCover;
}
- (UILabel *)revokeReasonLb {
    if (!_revokeReasonLb) {
        _revokeReasonLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
        _revokeReasonLb.numberOfLines = 0;
        _revokeReasonLb.font = FONT_REGULAR_14;
        _revokeReasonLb.textColor = [UIColor colorWithHexString:@"#858585"];
    }
    return _revokeReasonLb;
}
- (UIView *)dividedLine {
    if (!_dividedLine) {
        _dividedLine = [[UIView alloc] init];
        _dividedLine.backgroundColor = [UIColor colorWithHexString:@"#E6E6E6"];
    }
    return _dividedLine;
}

@end
