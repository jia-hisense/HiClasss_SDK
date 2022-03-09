//
//  HICStudyDocPhotoDetailCell.m
//  HiClass
//
//  Created by Sir_Jing on 2020/2/10.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICStudyDocPhotoDetailCell.h"
#import "HICWaterView.h"
CGFloat maxScale = 3.0;
CGFloat minScale = 1.0;
@interface HICStudyDocPhotoDetailCell ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIImageView *detailImageView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) HICWaterView *waterView;
@end

@implementation HICStudyDocPhotoDetailCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createView];
    }
    return self;
}
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, HIC_ScreenWidth, HIC_ScreenHeight)];
    }
    return _scrollView;
}
- (void)setModel:(HICMediaInfoModel *)model {
    if (model.url) {
        [self.detailImageView sd_setImageWithURL:[NSURL URLWithString:model.url]];
    }
}
- (void)setControlModel:(HICControlInfoModel *)controlModel {
    if (controlModel.watermarkFlag) {
        if (self.waterView && self.waterView.superview) {
            [self.waterView removeFromSuperview];
        }
        self.waterView = [[HICWaterView alloc]initWithFrame:CGRectMake(6, 6, self.contentView.frame.size.width - 16,self.contentView.frame.size.height - 16) WithText:controlModel.watermarkText];
        [self.detailImageView addSubview:self.waterView];
        [self.waterView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.right.equalTo(self.detailImageView);
        }];
    }
}

- (void)createView {
    self.detailImageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
    self.detailImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.detailImageView.userInteractionEnabled = YES;
    self.detailImageView.backgroundColor = [UIColor colorWithHexString:@"#181818"];
    [self.scrollView addSubview:self.detailImageView];
//    self.scrollView.contentSize = self.detailImageView.size;
    [self.contentView addSubview:self.scrollView];
    self.scrollView.delegate = self;
    self.scrollView.maximumZoomScale = maxScale;
    self.scrollView.minimumZoomScale = minScale;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageTap)];
    tap.numberOfTapsRequired = 1;
    [self.scrollView addGestureRecognizer:tap];
    UITapGestureRecognizer *tapByDouble = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleClick:)];
    tapByDouble.numberOfTapsRequired = 2;
    [self.scrollView addGestureRecognizer:tapByDouble];
    [tap requireGestureRecognizerToFail:tapByDouble];
    [self makeLayout];
}

- (void)resumeScale {
    [self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:NO];
    self.scrollView.contentSize = self.size;
}

- (void)imageTap {
    [self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:NO];
    if (self.docDelegate && [self.docDelegate respondsToSelector:@selector(clickPic)]) {
        [self.docDelegate clickPic];
    }
}
- (void)doubleClick:(UITapGestureRecognizer *)sender {
    if (self.scrollView.zoomScale > self.scrollView.minimumZoomScale) {
        // 已经放大 现在缩小
        [self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:YES];
    } else {
        [self.scrollView setZoomScale:self.scrollView.maximumZoomScale animated:YES];
    }
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.detailImageView;
}

#pragma mark - MakeAutoLayout
- (void)makeLayout {
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self);
    }];
    [self.detailImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.width.height.equalTo(self.scrollView);
    }];
}

@end
