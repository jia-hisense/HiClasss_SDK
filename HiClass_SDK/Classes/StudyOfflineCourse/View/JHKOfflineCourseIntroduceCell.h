//
//  JHKOfflineCourseIntroduceCell.h
//  JHKOffLineViewDemo
//
//  Created by wangggang on 2020/4/21.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExpandLabel.h"
NS_ASSUME_NONNULL_BEGIN
static NSString * _Nullable JHKOfflineCourseIntroduceCellIdentifier = @"JHKOfflineCourseIntroduceCell";
typedef void(^GetIntroduceCellBlock)(CGFloat height);

@interface JHKOfflineCourseIntroduceCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImageV;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet ExpandLabel *introduceLabel;
@property (copy, nonatomic) GetIntroduceCellBlock introduceCellHeightBlock;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *introduceLabelH;
+(instancetype)getIntroduceCell;
-(void)setCellWithHeaderImage:(NSString *)headerImage andName:(NSString *)name andInfo:(NSString *)info andIntroduce:(NSString *)introduce;
@end

NS_ASSUME_NONNULL_END
