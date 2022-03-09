//
//  HomeworkImageViewCell.m
//  HiClass
//
//  Created by 铁柱， on 2020/3/27.



//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HomeworkImageViewCell.h"

@interface HomeworkImageViewCell()

@property (nonatomic, strong) UIImageView *backImageView;

@property (nonatomic, strong) UIImageView *iconImageView;

@end

@implementation HomeworkImageViewCell

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createView];
    }
    return self;
}

-(void)createView {
    UIButton *but = [[UIButton alloc] initWithFrame:CGRectMake(self.width-20, 0, 20, 20)];
    [but setImage:[UIImage imageNamed:@"删除图片"] forState:UIControlStateNormal];
    [but addTarget:self action:@selector(clickDeleateBut:) forControlEvents:UIControlEventTouchUpInside];

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, 72, 72)];
    imageView.layer.cornerRadius = 2.f;
    imageView.layer.masksToBounds = YES;
    imageView.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6"];
    self.backImageView = imageView;

    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(16, 16, 40, 40)];
    iconImageView.image = [UIImage imageNamed:@"知识类型-视频"];
    [imageView addSubview:iconImageView];
    self.iconImageView = iconImageView;
    iconImageView.hidden = YES;

    [self.contentView addSubview:imageView];
    [self.contentView addSubview:but];
}

-(void)setModel:(HomeworkImageModel *)model {
    if (_model == model) {
        return;
    }
    _model = model;
    self.backImageView.image = nil;
    if (model.isAgainWrite) {
        if (model.againFileType == HICHomeworkAgainFileType_image) {
            if (model.attachmentModel.url) {
                [self.backImageView sd_setImageWithURL:[NSURL URLWithString:model.attachmentModel.url]];
            }
            self.iconImageView.hidden = YES;
        }else if (model.againFileType == HICHomeworkAgainFileType_voic) {
            self.iconImageView.hidden = NO;
            self.iconImageView.image = [UIImage imageNamed:@"知识类型-音频"];
        }else if (model.againFileType == HICHomeworkAgainFileType_video) {
            self.iconImageView.hidden = NO;
            self.iconImageView.image = [UIImage imageNamed:@"知识类型-视频"];
        }
    }else {
        if (model.type == HMBMessageFileType_image) {
            self.backImageView.image = model.image;
            self.iconImageView.hidden = YES;
        }else if (model.type == HMBMessageFileType_wav || model.type == HMBMessageFileType_amr) {
            self.iconImageView.hidden = NO;
            self.iconImageView.image = [UIImage imageNamed:@"知识类型-音频"];
        }else if (model.type == HMBMessageFileType_video) {
            self.iconImageView.hidden = NO;
            self.iconImageView.image = [UIImage imageNamed:@"知识类型-视频"];
        }
    }

    
}

-(void)clickDeleateBut:(UIButton *)but {
    if ([self.delegate respondsToSelector:@selector(imageViewCell:clickDeleateBut:model:)]) {
        [self.delegate imageViewCell:self clickDeleateBut:but model:self.model];
    }
}

@end
