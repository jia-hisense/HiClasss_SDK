//
//  HICLectureInductView.m
//  HiClass
//
//  Created by WorkOffice on 2020/3/12.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICLectureInductView.h"
#define GlobalFont(fontsize) [UIFont systemFontOfSize:fontsize]
@interface HICLectureInductView ()<UIScrollViewDelegate>
@property (nonatomic ,strong)UILabel *contentLabel;
@property (nonatomic ,strong)UILabel *contentLabelLong;
@property (nonatomic ,strong)UILabel *positionLabel;
@property (nonatomic ,strong)UILabel *companyGroupLabel;
@property (nonatomic ,strong)UILabel *locationLabel;
@property (nonatomic ,strong)UIButton *extensionBtn;
@property (nonatomic ,strong)UIView *contentView;
@property (nonatomic ,strong)UIView *middleView;
@property (nonatomic ,strong)UIImageView *img3;
@property (nonatomic ,strong)UIView *line2;
@property (nonatomic ,strong)UIView *bottomView;
@property (nonatomic ,strong)UILabel *bottomLabel;
@property (nonatomic ,strong)UIScrollView *scrollView;
@property (nonatomic ,assign)CGFloat bottomHeight;
@end
@implementation HICLectureInductView
- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.scrollEnabled = YES;
//        _scrollView.backgroundColor = [UIColor colorWithHexString:@"#E9E9E9"];
         _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.delegate = self;
        _scrollView.userInteractionEnabled = YES;
    }
    return _scrollView;
}
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}
- (void)createUI{
    [self addSubview:self.scrollView];
    _scrollView.frame = CGRectMake(0, 0, HIC_ScreenWidth, self.height - HIC_BottomHeight);
    _scrollView.contentSize = self.frame.size;
    self.contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, HIC_ScreenWidth, 100)];
     [self.scrollView addSubview:self.contentView];
//    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, HIC_ScreenWidth, 0.5)];
//    line.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6"];
//    [self.contentView addSubview:line];
    self.contentLabel = [[UILabel alloc]init];
    self.contentLabel.numberOfLines = 3;
    self.contentLabel.font = FONT_REGULAR_14;
    self.contentLabel.textColor = TEXT_COLOR_LIGHT;
    [self.contentView addSubview:self.contentLabel];
    self.contentLabel.hidden = NO;
    self.contentLabelLong = [[UILabel alloc]init];
    self.contentLabelLong.numberOfLines = 0;
    self.contentLabelLong.font = FONT_REGULAR_14;
    self.contentLabelLong.textColor = TEXT_COLOR_LIGHT;
    [self.contentView addSubview:self.contentLabelLong];
    self.contentLabelLong.hidden = YES;
    self.extensionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.extensionBtn.titleLabel.font = FONT_REGULAR_14;
    [self.extensionBtn setTitle:NSLocalizableString(@"develop", nil) forState:UIControlStateNormal];
    [self.extensionBtn setTitle:NSLocalizableString(@"packUp", nil) forState:UIControlStateSelected];
    [self.extensionBtn setTitleColor:[UIColor colorWithHexString:@"#00BED7"] forState:UIControlStateNormal];
    [self.extensionBtn addTarget:self action:@selector(extensionBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.extensionBtn];
    self.extensionBtn.hidden = YES;
    self.middleView = [[UIView alloc]init];
    [self.scrollView addSubview:self.middleView];
//    self.middleView.backgroundColor = UIColor.redColor;
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(16, 0, HIC_ScreenWidth - 32, 0.5)];
    line1.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6"];
    [self.middleView addSubview:line1];
    UIImageView *img1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"职位"]];
    img1.frame = CGRectMake(16, 13, 19, 19);
    [self.middleView addSubview:img1];
    self.positionLabel = [[UILabel alloc]initWithFrame:CGRectMake(50.5, 13, HIC_ScreenWidth - 50.5-16, 20)];
    self.positionLabel.font = FONT_REGULAR_14;
    self.positionLabel.textColor = TEXT_COLOR_DARK;
    [self.middleView addSubview:self.positionLabel];
    UIImageView *img2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"架构"]];
    img2.frame = CGRectMake(16, 48, 19, 19);
    [self.middleView addSubview:img2];
    self.companyGroupLabel = [[UILabel alloc]init];
    self.companyGroupLabel.font = FONT_REGULAR_14;
    self.companyGroupLabel.textColor = TEXT_COLOR_DARK;
    self.companyGroupLabel.numberOfLines = 0;
    self.companyGroupLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.middleView addSubview:self.companyGroupLabel];
    self.companyGroupLabel.text = @"高度撒谎的空间撒谎的快乐撒谎的；";
    self.img3 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"定位"]];
    [self.middleView addSubview:self.img3];
    self.locationLabel = [[UILabel alloc]init];
    self.locationLabel.font = FONT_REGULAR_14;
    self.locationLabel.textColor = TEXT_COLOR_DARK;
    [self.middleView addSubview:self.locationLabel];
    self.locationLabel.text = @"山东-青岛";
    self.line2 = [[UIView alloc]init];
    self.line2.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6"];
    [self.middleView addSubview:self.line2];
    
    self.bottomView = [[UIView alloc]init];
    [self.scrollView addSubview:self.bottomView];
    self.bottomLabel = [[UILabel alloc]init];
    self.bottomLabel.text = NSLocalizableString(@"goodAtField", nil);
    self.bottomLabel.font = FONT_MEDIUM_17;
    self.bottomLabel.textColor = TEXT_COLOR_DARK;
    [self.bottomView addSubview:self.bottomLabel];
    [self updateConstraints];
}
- (void)updateConstraints{
    [super updateConstraints];
//    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.offset(HIC_ScreenWidth);
//        make.top.equalTo(self);
//    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(16.5);
        make.left.equalTo(self.contentView).offset(16);
        make.width.offset(HIC_ScreenWidth - 32);
    }];
    
    [self.contentLabelLong mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(16.5);
         make.left.equalTo(self.contentView).offset(16);
        make.width.offset(HIC_ScreenWidth - 32);
    }];
    [self.extensionBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(16);
        make.bottom.equalTo(self.contentView).offset(-8);
    }];
    [self.middleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_bottom);
        make.left.equalTo(self);
        make.width.offset(HIC_ScreenWidth);
    }];
    [self.companyGroupLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.middleView).offset(48.5);
        make.left.equalTo(self.middleView).offset(50.5);
        make.width.offset(HIC_ScreenWidth - 50.5 - 16);
    }];
    [self.img3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.middleView).offset(16);
        make.top.equalTo(self.companyGroupLabel.mas_bottom).offset(13);
        make.width.offset(14.7);
        make.height.offset(19);
    }];
    [self.locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.companyGroupLabel.mas_bottom).offset(13);
        make.left.equalTo(self.img3.mas_right).offset(17.7);
        make.height.offset(20);
    }];
    [self.line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.middleView).offset(16);
        make.top.equalTo(self.locationLabel.mas_bottom).offset(16);
        make.width.offset(HIC_ScreenWidth - 32);
        make.height.offset(0.5);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line2.mas_bottom);
        make.left.equalTo(self);
        make.width.offset(HIC_ScreenWidth);
    }];
    [self.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomView).offset(16);
        make.left.equalTo(self.bottomView).offset(16);
        make.width.offset(HIC_ScreenWidth - 32);
    }];
    
}
-(void)setModel:(HICLectureDetailModel *)model{
    self.contentLabel.hidden = NO;
    self.contentLabelLong.hidden = YES;
    self.extensionBtn.selected = NO;
    if (![NSString isValidStr:model.briefIntroduction]) {
        model.briefIntroduction = NSLocalizableString(@"noIntroduction", nil);
    }
    self.contentLabel.text = model.briefIntroduction;
    self.contentLabelLong.text = model.briefIntroduction;
    if ( [self getContentHeight:model.briefIntroduction] > 60) {
        self.extensionBtn.hidden = NO;
        self.contentView.frame = CGRectMake(0, 0, HIC_ScreenWidth, 60 + 16 + 34);
    }else{
        self.extensionBtn.hidden = YES;
        self.contentView.frame = CGRectMake(0, 0, HIC_ScreenWidth, [self getContentHeight:model.briefIntroduction] + 16 + 14);
    }
    if ([NSString isValidStr:model.postName]) {
        self.positionLabel.text = model.postName;
    }else{
        self.positionLabel.text = @"--";
    }
    if ([NSString isValidStr:[NSString stringWithFormat:@"%@",model.deptName]]) {
        self.companyGroupLabel.text = [NSString stringWithFormat:@"%@",model.deptName];
    }else{
        self.companyGroupLabel.text = @"--";
    }
    if ([NSString isValidStr:model.province] && [NSString isValidStr:model.city]) {
      self.locationLabel.text = [NSString stringWithFormat:@"%@-%@",model.province,model.city];
    }else{
        self.locationLabel.text = @"--";
    }
    
    [self createTagView:model.tagList];
    [self layoutIfNeeded];
}
- (void)extensionBtnClick{
    if (!self.extensionBtn.isSelected) {
        self.extensionBtn.selected = YES;
        self.contentLabelLong.hidden = NO;
        self.contentView.frame = CGRectMake(0, 0, HIC_ScreenWidth, [self getContentHeight:self.contentLabelLong.text] + 16 + 34);
        self.contentLabel.hidden = YES;
        self.scrollView.contentSize = CGSizeMake(HIC_ScreenWidth, self.contentView.frame.size.height + self.companyGroupLabel.frame.size.height + self.positionLabel.frame.size.height + self.locationLabel.frame.size.height + self.bottomHeight+ HIC_BottomHeight);
    }else{
        self.extensionBtn.selected = NO;
        self.contentLabel.hidden = NO;
        self.contentView.frame = CGRectMake(0, 0, HIC_ScreenWidth, 60 + 16 + 34);
        self.contentLabelLong.hidden = YES;
        self.scrollView.contentSize = CGSizeMake(HIC_ScreenWidth, self.contentView.frame.size.height + self.companyGroupLabel.frame.size.height + self.positionLabel.frame.size.height + self.locationLabel.frame.size.height + self.bottomHeight+ HIC_BottomHeight);
    }
    [self updateConstraints];
}
- (void)createTagView:(NSArray *)tagArr{
    if (tagArr.count == 0) {
        UILabel *Label = [[UILabel alloc]initWithFrame:CGRectMake(16, 52, HIC_ScreenWidth - 32, 20)];
        Label.font = FONT_REGULAR_14;
        Label.textColor = TEXT_COLOR_LIGHT;
        Label.text = NSLocalizableString(@"noContent", nil);
        [self.bottomView addSubview:Label];
        return;
    }
        CGFloat tagBtnX = 16;
        CGFloat tagBtnY = 52;
        for (int i= 0; i<tagArr.count; i++) {
            CGSize tagTextSize = [tagArr[i][@"tagName"] sizeWithFont:GlobalFont(13) maxSize:CGSizeMake(HIC_ScreenWidth-32-32, 30)];
            if (tagBtnX+tagTextSize.width+30 > HIC_ScreenWidth-32) {
                tagBtnX = 16;
                tagBtnY += 30+15;
            }
            UIButton * tagBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            tagBtn.tag = 100+i;
            tagBtn.frame = CGRectMake(tagBtnX, tagBtnY, tagTextSize.width+30, 30);
            [tagBtn setTitle:tagArr[i][@"tagName"] forState:UIControlStateNormal];
            [tagBtn setTitleColor:TEXT_COLOR_DARK forState:UIControlStateNormal];
            tagBtn.titleLabel.font = FONT_REGULAR_13;
            tagBtn.layer.cornerRadius = 1.5;
            tagBtn.layer.masksToBounds = YES;
            tagBtn.layer.borderWidth = 1;
            tagBtn.layer.borderColor = [UIColor colorWithHexString:@"#C2C2C2"].CGColor;
            [self.bottomView addSubview:tagBtn];
            tagBtnX = CGRectGetMaxX(tagBtn.frame)+10;
        }
    self.bottomHeight = tagBtnY + 60;
    self.scrollView.contentSize = CGSizeMake(HIC_ScreenWidth, self.contentView.frame.size.height + self.companyGroupLabel.frame.size.height + self.positionLabel.frame.size.height + self.locationLabel.frame.size.height + self.bottomHeight + HIC_BottomHeight);
}
- (CGFloat)getViewHeight{
    return self.contentView.frame.size.height + self.companyGroupLabel.frame.size.height + self.positionLabel.frame.size.height + self.locationLabel.frame.size.height + self.bottomHeight + HIC_BottomHeight;
}
- (CGFloat)getContentHeight:(NSString *)str {
    UILabel *label = [[UILabel alloc] init];
    label.text = str;
    label.font = FONT_REGULAR_14;
    label.numberOfLines = 0;
    CGFloat labelHeight = [HICCommonUtils sizeOfString:str stringWidthBounding:HIC_ScreenWidth - 32 font:14 stringOnBtn:NO fontIsRegular:YES].height;
    label.frame = CGRectMake(0, 0, HIC_ScreenWidth - 32, labelHeight);
    [label sizeToFit];
    return label.frame.size.height;
}
@end
