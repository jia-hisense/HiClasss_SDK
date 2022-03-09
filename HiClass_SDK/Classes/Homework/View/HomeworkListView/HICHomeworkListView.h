//
//  HICHomeworkListView.h
//  HiClass
//
//  Created by Eddie Ma on 2020/3/11.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HICHomeworkModel.h"


NS_ASSUME_NONNULL_BEGIN

@class HICHomeworkListView;
@protocol HICHomeworkListViewDelegate <NSObject>

-(void)listView:(HICHomeworkListView *)view didCell:(UITableViewCell *_Nullable)cell model:(HICHomeworkModel *)model indexPath:(NSIndexPath *)indexPath;

@end

@interface HICHomeworkListView : UIView

@property (nonatomic, strong) NSNumber *trainId;

@property (nonatomic, strong) NSNumber *workId;

@property (nonatomic, weak) id <HICHomeworkListViewDelegate>delegate;

- (void)requestData;

@end

NS_ASSUME_NONNULL_END
