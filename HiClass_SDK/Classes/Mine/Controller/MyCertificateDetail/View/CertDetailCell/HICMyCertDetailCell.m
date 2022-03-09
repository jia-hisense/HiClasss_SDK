//
//  HICMyCertDetailCell.m
//  HiClass
//
//  Created by Eddie_Ma on 18/4/20.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICMyCertDetailCell.h"

@interface HICMyCertDetailCell ()
@property (nonatomic, strong) UIView *section1View;
@property (nonatomic, strong) UIView *section2View;
@property (nonatomic, strong) UIImageView *certIV;
@property (nonatomic, strong) UILabel *tagLabel;
@property (nonatomic, strong) UIView *gradientLabelView;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@property (nonatomic, strong) UILabel *certName;
@property (nonatomic, strong) UILabel *certNo; // 证书编号
@property (nonatomic, strong) UILabel *certIssueDate; // 发证日期
@property (nonatomic, strong) UILabel *certStartDate; // 生效日期
@property (nonatomic, strong) UILabel *certEndDate; // 失效日期
@property (nonatomic, strong) UILabel *certAuthorityTitle;
@property (nonatomic, strong) UILabel *certAuthority;
@property (nonatomic, strong) UILabel *certFromTitle;
@property (nonatomic, strong) UILabel *certFrom;
@property (nonatomic, strong) UILabel *certDescTitle;
@property (nonatomic, strong) UILabel *certDesc;
@property (nonatomic, strong) UILabel *certReasonTitle;
@property (nonatomic, strong) UILabel *certReason;
@property (nonatomic, strong) HICCertificateModel *certModel;
@property (nonatomic, strong) UIView *devidedLine;
@property (nonatomic, strong) UIView *devidedBoldLine;
@property (nonatomic, strong) UIButton *showAllBtn;
@property (nonatomic, assign) NSInteger index;
@end

@implementation HICMyCertDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    self.backgroundColor = [UIColor whiteColor];
    self.section1View = [[UIView alloc] init];
    [self.contentView addSubview:_section1View];
    self.section2View = [[UIView alloc] init];
    [self.contentView  addSubview:_section2View];

    self.certIV = [[UIImageView alloc] initWithFrame:CGRectMake(16, 16.5, HIC_ScreenWidth - 16 *2, (HIC_ScreenWidth - 16 *2) * 193 / 343)];
    [_section1View addSubview: _certIV];
    _certIV.layer.masksToBounds = YES;
    _certIV.layer.borderWidth = 0.5;
    _certIV.layer.borderColor = [UIColor colorWithHexString:@"e6e6e6"].CGColor;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImage)];
    [_certIV addGestureRecognizer:tapGesture];
    _certIV.userInteractionEnabled = YES;

    self.gradientLabelView = [[UIView alloc] init];
    [_certIV addSubview:_gradientLabelView];
    self.gradientLayer = [CAGradientLayer layer];

    self.tagLabel = [[UILabel alloc] init];
    [_gradientLabelView addSubview:_tagLabel];
    _tagLabel.hidden = YES;
    _tagLabel.backgroundColor = [UIColor clearColor];
    _tagLabel.textAlignment = NSTextAlignmentCenter;
    _tagLabel.textColor = [UIColor whiteColor];
    _tagLabel.font = FONT_MEDIUM_12;

    self.certName = [[UILabel alloc] init];
    [_section1View addSubview:_certName];
    _certName.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    _certName.font = FONT_REGULAR_17;
    _certName.numberOfLines = 2;

    self.certNo = [[UILabel alloc] init];
    [_section1View addSubview:_certNo];
    _certNo.textColor = [UIColor colorWithRed:133/255.0 green:133/255.0 blue:133/255.0 alpha:1/1.0];
    _certNo.font = FONT_REGULAR_14;

    self.certIssueDate = [[UILabel alloc] init];
    [_section1View addSubview:_certIssueDate];
    _certIssueDate.textColor = [UIColor colorWithRed:133/255.0 green:133/255.0 blue:133/255.0 alpha:1/1.0];
    _certIssueDate.font = FONT_REGULAR_14;

    self.certStartDate = [[UILabel alloc] init];
    [_section1View addSubview:_certStartDate];
    _certStartDate.textColor = [UIColor colorWithRed:133/255.0 green:133/255.0 blue:133/255.0 alpha:1/1.0];
    _certStartDate.font = FONT_REGULAR_14;

    self.certEndDate = [[UILabel alloc] init];
    [_section1View addSubview:_certEndDate];
    _certEndDate.textColor = [UIColor colorWithRed:133/255.0 green:133/255.0 blue:133/255.0 alpha:1/1.0];
    _certEndDate.font = FONT_REGULAR_14;

    self.certAuthorityTitle = [[UILabel alloc] init];
    [_section1View addSubview:_certAuthorityTitle];
    _certAuthorityTitle.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    _certAuthorityTitle.font = FONT_REGULAR_15;
    _certAuthorityTitle.text = NSLocalizableString(@"licenseIssuingAgency", nil);

    self.certAuthority = [[UILabel alloc] init];
    [_section1View addSubview:_certAuthority];
    _certAuthority.textColor = [UIColor colorWithRed:133/255.0 green:133/255.0 blue:133/255.0 alpha:1/1.0];
    _certAuthority.font = FONT_REGULAR_14;
    _certAuthority.numberOfLines = 2;

    self.certFromTitle = [[UILabel alloc] init];
    [_section1View addSubview:_certFromTitle];
    _certFromTitle.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    _certFromTitle.font = FONT_REGULAR_15;
    _certFromTitle.text = NSLocalizableString(@"certificateOrigin", nil);

    self.certFrom = [[UILabel alloc] init];
    [_section1View addSubview:_certFrom];
    _certFrom.textColor = [UIColor colorWithRed:133/255.0 green:133/255.0 blue:133/255.0 alpha:1/1.0];
    _certFrom.font = FONT_REGULAR_14;
    _certFrom.numberOfLines = 2;

    self.certDescTitle = [[UILabel alloc] init];
    [_section2View addSubview:_certDescTitle];
    _certDescTitle.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    _certDescTitle.font = FONT_REGULAR_15;
    _certDescTitle.text = NSLocalizableString(@"certificateIntroduction", nil);

    self.certDesc = [[UILabel alloc] init];
    [_section2View addSubview:_certDesc];
    _certDesc.textColor = [UIColor colorWithRed:133/255.0 green:133/255.0 blue:133/255.0 alpha:1/1.0];
    _certDesc.font = FONT_REGULAR_14;
    _certDesc.numberOfLines = 3;

    self.certReasonTitle = [[UILabel alloc] init];
    [_section2View addSubview:_certReasonTitle];
    _certReasonTitle.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    _certReasonTitle.font = FONT_REGULAR_15;
    _certReasonTitle.text = NSLocalizableString(@"howToGet", nil);

    self.certReason = [[UILabel alloc] init];
    [_section2View addSubview:_certReason];
    _certReason.textColor = [UIColor colorWithRed:133/255.0 green:133/255.0 blue:133/255.0 alpha:1/1.0];
    _certReason.font = FONT_REGULAR_14;
    _certReason.numberOfLines = 0;

    self.showAllBtn = [[UIButton alloc] init];
    [_section2View addSubview:_showAllBtn];
    [_showAllBtn setTitle:NSLocalizableString(@"develop", nil) forState:UIControlStateNormal];
    [_showAllBtn setTitleColor:[UIColor colorWithRed:0/255.0 green:190/255.0 blue:215/255.0 alpha:1/1.0] forState:UIControlStateNormal];
    _showAllBtn.titleLabel.font = FONT_REGULAR_14;
    _showAllBtn.tag = 10000;
    [_showAllBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setData:(HICCertificateModel *)cerModel index:(NSInteger)index descShowAll:(BOOL)descShowAll {
    self.certModel = cerModel;
    self.index = index;
    CGFloat height = 16;
    if (index == 0) {
        _section1View.hidden = NO;
        _section2View.hidden = YES;
        if ([NSString isValidStr:cerModel.picUrl]) {
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:cerModel.picUrl]]];
            if (image) {
                CGImageRef sourceImageRef = [image CGImage];//将UIImage转换成CGImageRef
                CGFloat _imageWidth = image.size.width * image.scale;
                CGFloat _imageHeight = image.size.height * image.scale;
                _imageHeight = _imageWidth * _certIV.frame.size.height / _certIV.frame.size.width;
                CGRect rect = CGRectMake(0, 0, _imageWidth, _imageHeight);
                CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, rect);//按照给定的矩形区域进行剪裁
                UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
                _certIV.image = newImage;
            } else {
                _certIV.image = [UIImage imageNamed:@"证书默认图"];
            }
        } else {
            _certIV.image = [UIImage imageNamed:@"证书默认图"];
        }

        if (cerModel.status == HICCertNormal) {
            _gradientLabelView.hidden = YES;
            _tagLabel.hidden = YES;
        } else {
            _gradientLabelView.hidden = NO;
            _tagLabel.hidden = NO;
            NSString *tagStr = NSLocalizableString(@"theFailure", nil);
            CGSize tagSize;
            tagSize = [HICCommonUtils sizeOfString:tagStr stringWidthBounding:HIC_ScreenWidth font:12 stringOnBtn:NO fontIsRegular:NO];
            _gradientLabelView.frame = CGRectMake(0, 0, tagSize.width + 6, tagSize.height + 2);
            [HICCommonUtils setRoundingCornersWithView:_gradientLabelView TopLeft:NO TopRight:NO bottomLeft:NO bottomRight:YES cornerRadius:8];
            [HICCommonUtils createGradientLayerWithLabel:_gradientLabelView gradientLayer:self.gradientLayer fromColor:[UIColor colorWithHexString:cerModel.status == HICCertWillInvalid ? @"FF553C" : @"B9B9B9" alpha:1.0f] toColor:[UIColor colorWithHexString:cerModel.status == HICCertWillInvalid ? @"FF8E6F" : @"B9B9B9" alpha:1.0f]];
            _tagLabel.frame = CGRectMake(0, 0, _gradientLabelView.frame.size.width, _gradientLabelView.frame.size.height);
            _tagLabel.text = tagStr;
        }

        height = height + _certIV.frame.size.height + 16;
        _certName.text = cerModel.name;
        CGSize certNameSize = [HICCommonUtils sizeOfString:_certName.text stringWidthBounding:HIC_ScreenWidth - 2 *16 font:17 stringOnBtn:NO fontIsRegular:YES];
        _certName.frame = CGRectMake(16, height, HIC_ScreenWidth - 2 * 16, certNameSize.height);
        [_certName sizeToFit];

        height = height + _certName.frame.size.height + 12;
        _certNo.text = [NSString stringWithFormat:@"%@: %@", NSLocalizableString(@"certificateNumber", nil),cerModel.certNo];
        _certNo.frame = CGRectMake(16, height, HIC_ScreenWidth - 2 * 16, 20);

        height = height + _certNo.frame.size.height;
        _certIssueDate.text = [NSString stringWithFormat:@"%@: %@", NSLocalizableString(@"releaseDate", nil),[HICCommonUtils timeStampToReadableDate:cerModel.createdTime isSecs:YES format:@"yyyy-MM-dd"]];
        _certIssueDate.frame = CGRectMake(16, height, HIC_ScreenWidth - 2 * 16, 20);

        height = height + _certIssueDate.frame.size.height;
        _certStartDate.text = [NSString stringWithFormat:@"%@: %@", NSLocalizableString(@"effectiveDate", nil),[HICCommonUtils timeStampToReadableDate:cerModel.effectiveDate isSecs:YES format:@"yyyy-MM-dd"]];
        _certStartDate.frame = CGRectMake(16, height, HIC_ScreenWidth - 2 * 16, 20);

        height = height + _certStartDate.frame.size.height;
        _certEndDate.text = [cerModel.expireDate integerValue] <= 0 ? [NSString stringWithFormat:@"%@: --",NSLocalizableString(@"expiryDate", nil)] : [NSString stringWithFormat:@"%@: %@", NSLocalizableString(@"expiryDate", nil),[HICCommonUtils timeStampToReadableDate:cerModel.expireDate isSecs:YES format:@"yyyy-MM-dd"]];
        _certEndDate.frame = CGRectMake(16, height, HIC_ScreenWidth - 2 * 16, 20);

        height = height + _certEndDate.frame.size.height + 16;
        [self.devidedLine removeFromSuperview];
        self.devidedLine = [[UIView alloc] initWithFrame:CGRectMake(16, height, HIC_ScreenWidth - 16, 0.5)];
        [_section1View addSubview:_devidedLine];
        _devidedLine.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6"];

        height = height + _devidedLine.frame.size.height + 16;
        _certAuthorityTitle.frame = CGRectMake(16, height, HIC_ScreenWidth - 2 * 16, 21);

        height = height + _certAuthorityTitle.frame.size.height + 8;
        _certAuthority.text = [NSString isValidStr:cerModel.authority]?cerModel.authority:NSLocalizableString(@"licenseIssuingAuthorityUnknown", nil);
        CGSize authoritySize = [HICCommonUtils sizeOfString:_certName.text stringWidthBounding:HIC_ScreenWidth - 2 *16 font:14 stringOnBtn:NO fontIsRegular:YES];
        _certAuthority.frame = CGRectMake(16, height, HIC_ScreenWidth - 2 * 16, authoritySize.height);
        [_certAuthority sizeToFit];

        height = height + _certAuthority.frame.size.height + 16;
        _certFromTitle.frame = CGRectMake(16, height, HIC_ScreenWidth - 2 * 16, 21);

        height = height + _certFromTitle.frame.size.height + 8;
        _certFrom.text = cerModel.certSource;
        CGSize fromSize = [HICCommonUtils sizeOfString:_certFrom.text stringWidthBounding:HIC_ScreenWidth - 2 *16 font:14 stringOnBtn:NO fontIsRegular:YES];
        _certFrom.frame = CGRectMake(16, height, HIC_ScreenWidth - 2 * 16, fromSize.height);
        [_certFrom sizeToFit];

        height = height + _certFrom.frame.size.height + 16;
        [self.devidedBoldLine removeFromSuperview];
        self.devidedBoldLine = [[UIView alloc] initWithFrame:CGRectMake(0, height, HIC_ScreenWidth, 8)];
        [_section1View addSubview:_devidedBoldLine];
        _devidedBoldLine.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];

        height = height + _devidedBoldLine.frame.size.height;
        _section1View.frame = CGRectMake(0, 0, HIC_ScreenWidth, height);

    } else {
        _section1View.hidden = YES;
        _section2View.hidden = NO;
        _certDescTitle.frame = CGRectMake(16, height, HIC_ScreenWidth - 2 * 16, 21);

        height = height + _certDescTitle.frame.size.height + 8;
        _certDesc.text = cerModel.desc;
        CGSize descSize = [HICCommonUtils sizeOfString:_certDesc.text stringWidthBounding:HIC_ScreenWidth - 2 *16 font:14 stringOnBtn:NO fontIsRegular:YES];
        _certDesc.numberOfLines = descShowAll ? 0 : 3;
        _certDesc.frame = CGRectMake(16, height, HIC_ScreenWidth - 2 * 16, descSize.height);
        [_certDesc sizeToFit];

        CGFloat showAllbtnH = 0;
        NSArray *descLines = _certDesc.text ? [HICCommonUtils getLinesArrayOfStringInLabel:_certDesc] : @[];
        if (descLines.count > 3) {
            showAllbtnH = 20;
            _showAllBtn.frame = CGRectMake(16, height + _certDesc.frame.size.height, 30, 20);
            _showAllBtn.hidden = NO;
        } else {
            _showAllBtn.hidden = YES;
        }
        _showAllBtn.selected = descShowAll;
        if (descShowAll) {
            [_showAllBtn setTitle:NSLocalizableString(@"packUp", nil) forState:UIControlStateNormal];
        } else {
            [_showAllBtn setTitle:NSLocalizableString(@"develop", nil) forState:UIControlStateNormal];
        }

        height = height + _certDesc.frame.size.height + showAllbtnH + 16;
        _certReasonTitle.frame = CGRectMake(16, height, HIC_ScreenWidth - 2 * 16, 21);

        height = height + _certReasonTitle.frame.size.height + 8;
        _certReason.text = cerModel.reason;
        CGSize reasonSize = [HICCommonUtils sizeOfString:_certReason.text stringWidthBounding:HIC_ScreenWidth - 2 *16 font:14 stringOnBtn:NO fontIsRegular:YES];
        _certReason.frame = CGRectMake(16, height, HIC_ScreenWidth - 2 * 16, reasonSize.height);
        [_certReason sizeToFit];

        height = height + _certReason.frame.size.height + 16;
        _section2View.frame = CGRectMake(0, 0, HIC_ScreenWidth, height);
    }

}

- (void)clickImage {
    if ([self.delegate respondsToSelector:@selector(imgClicked:)]) {
        [self.delegate imgClicked:_certModel.picUrl];
    }
}

- (void)btnClicked:(UIButton *)btn {
    if (btn.tag == 10000) {
        btn.selected = !btn.selected;
        if ([self.delegate respondsToSelector:@selector(showAll:index:)]) {
            [self.delegate showAll:btn.selected index:_index];
        }
    }
}

@end
