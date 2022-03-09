//
//  HomeworkDetailBaseCell.m
//  HiClass
//
//  Created by 铁柱， on 2020/3/26.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HomeworkDetailBaseCell.h"

@implementation HomeworkDetailBaseCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

-(void)setCellPassImage:(BOOL)isPass score:(NSInteger)score isShowScore:(BOOL)isShowScore {
    // 子类实现方法
}

@end
