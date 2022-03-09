//
//  HICMsgCenterDetailVC.h
//  HiClass
//
//  Created by Eddie Ma on 2020/2/26.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HICMsgCenterDetailVC : UIViewController

@property (nonatomic, strong) NSString *naviTitle;
@property (nonatomic, assign) HICMsgType msgType; // 1-任务，2-待办，3-内容互动，4-群消息，5-评论

@end

NS_ASSUME_NONNULL_END
