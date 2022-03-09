//
//  HICMyNoteCell.h
//  HiClass
//
//  Created by WorkOffice on 2020/2/20.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HICMyNoteModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HICMyNoteCell : UITableViewCell
@property (nonatomic ,strong)HICMyNoteModel *noteModel;
//- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier isEdit:(BOOL)isEdit;
@end

NS_ASSUME_NONNULL_END
