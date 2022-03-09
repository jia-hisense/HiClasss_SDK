//
//  HomeStudyBaseCell.m
//  iTest
//
//  Created by Sir_Jing on 2020/3/10.
//  Copyright © 2020 Sir_Jing. All rights reserved.
//

#import "HomeStudyBaseCell.h"

@implementation HomeStudyBaseCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = UIColor.whiteColor;
    }
    return self;
}

-(void)setHomeStudyModel:(HICHomeStudyModel *)homeStudyModel {
    _homeStudyModel = homeStudyModel;
}

-(UIView *)createClassBackView:(UIView *)backView {

    UIView *view = [[UIView alloc] initWithFrame:backView.bounds];

    UIImageView *palyImage = [[UIImageView alloc] initWithFrame:CGRectMake(view.bounds.size.width-15-5.5, view.bounds.size.height-15-5.5, 15, 15)];
    palyImage.image = [UIImage imageNamed:@"icon-播放"];
    [view addSubview:palyImage];

    view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];

    return view;
}

@end
