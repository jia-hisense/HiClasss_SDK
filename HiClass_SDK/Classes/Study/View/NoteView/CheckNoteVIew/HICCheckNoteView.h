//
//  HICCheckNoteView.h
//  HiClass
//
//  Created by Eddie Ma on 2020/2/8.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HICCheckNoteView : UIView
@property (nonatomic, strong) UITableView *tableView;
- (instancetype)initWithNotes:(NSArray *)notes type:(HICStudyBtmViewType)type identifier:(NSString *)identifier;
@property (nonatomic ,assign)BOOL isMy;
@end

NS_ASSUME_NONNULL_END
